.. default-domain:: py

pathoption
==========

.. automodule:: pathoption
    
.. function:: create_pathoption()

    Returns a PathOption object

        :rtype: PathOption

|

.. function:: register_pathoption(pathoption,key,function_reference)

    Registers data pair key:function_reference with object pathoption.

    :param PathOption pathoption: The object to register the data pair.
    :param str key: The --path option value
    :param function_reference: A reference to  a function
|

.. class:: PathOption

    PathOption stores the function references that when invoked return the
    installation paths. The function references are stored in data pairs
    key:function_reference where key corresponds to the --path option value.

    .. method:: add_option(self,key,ref_to_function)

        Adds the data value pair key:function_reference. No duplicate key values
        are allowed. 

        :param str key: A --path option value
        :param ref_to_function: A function reference that when invoked returns a string.

    .. method:: get_path(self,key)

        For the value of key, returns the corresponding function reference.

        :param str key: A --path option value
        :rtype: str
        :Returns: The corresponding  path for the key value.
