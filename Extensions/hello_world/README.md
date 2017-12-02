FA 2.4.x Hello World Extension Manual Install

Unzip the `hello_world.zip` file into the `<FA webroot>/modules` folder.
Increment the `$next_extension_id` variable and append a stanza like the following into the `installed_extensions.php` file:
````
  2 => 
  array (
    'name' => 'Hello World',
    'package' => 'hello_world',
    'version' => '-',
    'type' => 'extension',
    'active' => false,
    'path' => 'modules/hello_world',
  ),
````
* The `2` in the array key above will possibly be different for your install.
* Login to the default company and navigate to `Setup => Install/Update Extensions`
* Install the `hello_world` extension.
* Choose to `activate` it for a specific company.
* Logout and now login to the specific company that has the `Hello World` extension activated
* Navigate to the `Hello World` tab
* Now under section `Inquiries and Reports`, click the `Hello World` menu link in the right column.
* Tab Ordering

You have now successfully deployed the `Hello World` Extension in a separate tab in FA!
