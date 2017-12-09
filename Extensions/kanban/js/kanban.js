
/*=======================================================\
|                        FrontKanban                     |
|--------------------------------------------------------|
|   Creator: Phương                                      |
|   Date :   01-12-2017                                  |
|   Description: Frontaccounting Project Management Ext  |
|   Free software under GNU GPL                          |
|                                                        |
\=======================================================*/
(function(){
	"use strict";

	var app_data = {
		people:{}
	};
	var IN_EDIT_MODE = false;

	var loadData = function() {
		var state_data = init_states(cols);
		$.ajax({
			type: 'POST',
			url: '../data.php',
			data: {action:'load'},
			dataType: 'json',
			success: function(data) {
				if (data === null) {
					data = {};
				}
				app_data.board = init_board(data);
				app_data.states = state_data.states;
				app_data.states_order = state_data.states_order;
				app_data.rawData = data;

				create_board(app_data);
				createPeopleList();
			}
		});
	};

	var createPeopleList = function() {
		var peopleList = '<form ><ul class="people-list">';
		for (var i in app_data.people) {
			if (app_data.people.hasOwnProperty(i)) {
				peopleList += '<li><input type="checkbox" name="'+i+'" value="0">'+i+'</li>';
			}
		}
		peopleList += '</ul></form>';
		$('#member_filter').append(peopleList);
	};

	var saveData = function(data) {
		if (data === '') {
			data = {};
		}
		$.ajax({
			type: 'POST',
			url: '../data.php',
			data: {action:'save',data:data},
			dataType:'json'
		});
	};

	var init_states = function(states_input) {
		var states = {};
		var states_order = [];
		for ( var i=0, len=states_input.length; i<len; i++ ) {
			var state = states_input[i].split(",");
			if (state.length === 2) {
				states[state[0]] = state[1];
				states_order.push(state[0]);
			}
		}
		return {states: states, states_order: states_order};
	};

	var init_board = function(tasks) {
		var board = {};
		for (var i in tasks) {
			if (tasks.hasOwnProperty(i)) {
				var task = tasks[i];
				task.id = i;
				if (! board[task.state]) {
					board[task.state] = [];
				}
				board[task.state].push(task);
			}
		}
		return board;
	};

	var create_task_li_item = function(task) {
		var task_element = $("<li data-state='"+task.state+"' data-id='"+task.id+"'><div class='task_box color_"+task.color+"' ><div class='task_editable' data-id='"+task.id+"'>" + task.title + "</div><div class='user_box'>" + task.responsible + "</div><a href='#' class='editable'>Edit</a></div></li>");

		if (app_data.people[task.responsible] === undefined) {
			app_data.people[task.responsible] = [task.id];
		}
		else {
			app_data.people[task.responsible].push(task.id);
		}
		return task_element;
	};

	var create_list = function(board, state) {
		var list = $("<ul></ul>");
		if (board[state]) {
			for (var i=0, len=board[state].length; i<len; i++) {
				var id = board[state][i].id;
				var task_element = create_task_li_item(app_data.rawData[id]);
				list.append(task_element);
			}
		}
		return "<ul class='state' id='" + state + "'>"+list.html()+"</ul>";
	};

	var create_column = function(board, state, headlines, num) {
		var odd_even = num % 2 == 0 ? 'col_even' : 'col_odd';
		var content = '<div class="col state_box state_'+state+' col_'+num+' '+odd_even+'"><h4><a href="#" class="new">+</a>'+headlines + '</h4>';
		
		content += create_list(board, state);
		content += '</div>';
		return content;
	};

	var create_board = function(app_data) {
		for (var j=0; j< app_data.states_order.length; j++) {
			var state = app_data.states_order[j];
			var col = create_column(app_data.board, state, app_data.states[state],j);
			$('#kanban_board').append(col);
		}
		
		startDragsort();
	};

	var create_task = function(id, text, state, color) {
		if (state === undefined) {
			state = app_data.states_order[0];
		}
		if (color === undefined) {
			color = 0;
		}

		var assignee = $('#kanban_board').find('select.user_list').val();
		if(assignee === undefined || assignee == 0)
			assignee = 'Not assigned';
		var task = {
			title:text,
			id:id,
			responsible:assignee,
			state:state,
			color:color
		};
		return task;
	};

	var droppedElement = function() {
		var newState = $(this).parent().attr('id');
		var taskId = $(this).attr('data-id');
		app_data.rawData[taskId].state = newState;
		saveData(app_data.rawData);
	};

	var startDragsort = function() {
		$('ul.state').dragsort({dragSelector:'li',dragBetween: true, placeHolderTemplate: "<li class='placeholder'><div>&nbsp</div></li>",dragEnd:droppedElement});
	};

	var destroyDragsort = function() {
		$('ul.state').dragsort("destroy");
	};

	var get_users = function() {
		$.ajax({
			type: 'POST',
			url: '../data.php',
			data: {action:'get_all_users'},
			dataType: 'json',
			success: function(data) {
				if (data === null) {
					data = {};
				}
				app_data.users = data;
			}
		});
	}

	var create_members_list = function(selected_id) {
		var list = "<select class='user_list'><option value='0'>not assigned</option>";
		for(var i=0; i<app_data.users.length; i++) {
			if(app_data.users[i].user_id == selected_id) {
				list += "<option value="+app_data.users[i].user_id+" selected='selected'>"+app_data.users[i].real_name+"</option>";
			}
			else {
				list += "<option value="+app_data.users[i].user_id+">"+app_data.users[i].real_name+"</option>";
			}
		}
		list += "</select>";

		return list;
	}
	
//--------------------------------------------------------------------------

	$(document).ready(function(){
		loadData();
		get_users();
		
		$('#kanban_board').on('click', '.new', function(){
			var id = new Date().getTime();
			var task = create_task(id, "New task", $(this).parent().siblings('.state').attr('id'));
			if (app_data.rawData === undefined) {
				app_data.rawData = {};
			}
			app_data.rawData[id] = task;
			saveData(app_data.rawData);
			var taskHtml = create_task_li_item(task);
			$('#'+task.state).append(taskHtml);
			$(taskHtml).find('.editable').trigger('click');
			destroyDragsort();
			return false;
		});

		$('#kanban_board').on('click','.editable', function(){
			if (!IN_EDIT_MODE) {
				var value = $(this).siblings('.task_editable').html();
				var taskId = $(this).parent().parent().attr('data-id');
				var oldColor = app_data.rawData[taskId].color;
				var oldAssignee = app_data.rawData[taskId].responsible;

				var members = create_members_list(oldAssignee);
				var form = '<form><textarea rows="10" class="editBox" value='+value+' data-old-value="'+value+'" data-old-color="'+oldColor+'">'+value+'</textarea><div class="user_list_cells">Assignee:'+members+'</div><br/><div class="task_modal_control"><a class="save" href="#">Save</a><a class="cancel" href="#">Cancel</a><a href="#" class="color">Color</a><a href="#" class="delete">Delete</a></div></form>';

				$(this).parent().addClass('task_modal');
				$('.task_modal').show();
				$(this).siblings('.task_editable').html(form);
				$(this).siblings('.task_editable').find('textarea').focus();
				var val = $(this).siblings('.task_editable').find('textarea').val();
				$(this).siblings('.task_editable').find('textarea').val('');
				$(this).siblings('.task_editable').find('textarea').val(val);
				destroyDragsort();
				IN_EDIT_MODE = true;
			}
		});

		$('#member_filter').on('change', '.people-list input[type="checkbox"]', function(){
			var responsible = $(this).attr('name');

			if($(this).val() == '0') {
				$(this).val('1')
			}
			else {
				$(this).val('0')
			}

			var count = 0;
			for (var k in app_data.people) {

			    if($('input[name="'+k+'"]').val() == "0") {
					for(var j in app_data.people[k]) {
						$('#kanban_board li[data-id="'+app_data.people[k][j]+'"] .task_box').addClass('blur_task');
					}
				}
				else {
					for(var j in app_data.people[k]) {
						$('#kanban_board li[data-id="'+app_data.people[k][j]+'"] .task_box').removeClass('blur_task');
					}
					count++ ;
				}
			}
			if(count == 0) {
				$('#kanban_board').find('.blur_task').removeClass('blur_task');
			}
		});

		$(document).keyup(function(e) {
			if (e.keyCode === 27) { 
				$('.cancel').trigger('click');
			}
			else if (e.keyCode === 78) {
				if (!IN_EDIT_MODE) {
					$('#new').trigger('click');
				}
			}
		});

		$('#kanban_board').on('click','.cancel', function(){
			var taskId = $(this).parent().parent().parent().attr('data-id');

			var remove_colors = "";
			for (var i=0;i<possible_colors;i++) {
				remove_colors += "color_"+i+" ";
			}
			var oldColor = $(this).parent().parent().find('textarea').attr('data-old-color');
			app_data.rawData[taskId].color = oldColor;
			$(this).parent().parent().parent().parent().removeClass(remove_colors);
			$(this).parent().parent().parent().parent().addClass('color_'+oldColor);
			$(this).parent().parent().parent().parent().removeClass('task_modal');
			$(this).parent().parent().parent().parent().attr('style', '');

			var oldContent = $(this).parent().parent().find('textarea').attr('data-old-value');
			$(this).parent().parent().parent().html(oldContent);

			$('html').unbind('click');
			setTimeout(function(){IN_EDIT_MODE = false;}, 200);
			startDragsort();
      		return false;
		});

		$('#kanban_board').on('click','.delete', function(){
			var id = $(this).parent().parent().parent().attr('data-id');
			$(this).parent().parent().parent().parent().parent().remove();
			$('html').unbind('click');
			delete app_data.rawData[id];
			saveData(app_data.rawData);
			setTimeout(function(){IN_EDIT_MODE = false;}, 200);
			$(this).parent().parent().parent().parent().removeClass('task_modal');
			startDragsort();
            return false;
		});

		$('#kanban_board').on('click', '.color', function() {
			var taskId = $(this).parent().parent().parent().attr('data-id');
			if (app_data.rawData[taskId].color === undefined) {
				app_data.rawData[taskId].color = 0;				
			}
			else {
				$(this).parent().parent().parent().parent().removeClass('color_'+app_data.rawData[taskId].color);
				app_data.rawData[taskId].color++;
				if (app_data.rawData[taskId].color >= possible_colors) {
					app_data.rawData[taskId].color = 0;
				}
			}
			$(this).parent().parent().parent().parent().addClass('color_'+app_data.rawData[taskId].color);
            return false;
		});

		$('#kanban_board').on('submit', 'form', function(){
			var title = $(this).find('textarea').val();
			var taskId = $(this).parent().attr('data-id');
			var state = $(this).parent().parent().parent().attr('data-state');
			var task = create_task(taskId, title, state, app_data.rawData[taskId].color);

			app_data.rawData[taskId] = task;
			saveData(app_data.rawData);
			$('html').unbind('click');
			$(this).parent().parent().attr('style', '');
			$(this).parent().siblings('.user_box').html(task.responsible);
			$(this).parent().html(task.title);

			setTimeout(function(){IN_EDIT_MODE = false;}, 200);
			return false;
		});

		$('#kanban_board').on('click','.save', function(){
			$(this).parent().parent().parent().parent().removeClass('task_modal');
			$(this).parent().parent().submit();
			startDragsort();
			
			return false;
		});
	});

  })();
