CLASS zgs_cl_abap2ui5_ch1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES z2ui5_if_app .

    DATA:
      user_name    TYPE string,
      request_date TYPE string,
      check_initialized TYPE abap_bool.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zgs_cl_abap2ui5_ch1 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    if check_initialized = abap_false.
        check_initialized = abap_true.
        user_name = ''.
        request_date = sy-datum.
    endif.
    " Initialize form data
*    user_name = ''.
*    request_date = sy-datum.

    CASE client->get( )-event.
      WHEN 'BUTTON_POST'.
        client->popup_message_toast( |App executed on { request_date } by { user_name }| ).
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-id_prev_app_stack  ) ).
    ENDCASE.

    client->set_next( VALUE #( xml_main = z2ui5_cl_xml_view=>factory(
     )->shell(
        )->page(
            title = 'ABAP Challenge - Week 2'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton = abap_true
            )->header_content(
                )->link(
                    text = 'Source Code'
                    href = z2ui5_cl_xml_view=>hlp_get_source_code_url( app = me get = client->get( ) )
                    target = '_blank'
                    )->get_parent(
                        )->simple_form(
                            title = 'Form Title'
                            editable = abap_true
                            )->content( 'form'
                                )->title( 'Input'
                                )->label( 'User'
                                )->input( value = client->_bind( user_name ) editable = abap_true
                                )->label( 'Date'
                                )->date_picker( value = client->_bind( request_date )
                                )->button( text = 'Post' press = client->_event( 'BUTTON_POST' )
                                )->get_root(  )->xml_get(  )

     ) ).

  ENDMETHOD.
ENDCLASS.
