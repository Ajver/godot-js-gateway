GDPC                                                                                   res://default_env.tres  �      �       um�`�N��<*ỳ�8   res://icon.png  �#      v      ge��@o�7�|AZ   res://project.binary1      �      ���1����Zf���   res://src/Main/Main.gd.remap�"      (       T֑%�*�LT%���`�   res://src/Main/Main.gdc 0      �      �K�,=�w�rQ��ƛ�   res://src/Main/Main.tscn�            ga������P"��ˢ   res://src/UI/UI.gd.remap�"      $       ���k��L6T�Z�+   res://src/UI/UI.gdc       �      ����i:��LXb�<   res://src/UI/UI.tscn 
      q      �:�	��Gu�}+��u�(   res://src/scripts/GodotGateway.gd.remap  #      3       ݓ�|���/���$   res://src/scripts/GodotGateway.gdc  �      R      ��8���� G�R6Z�$   res://src/scripts/JS_API.gd.remap   `#      -       67�Zav1���lП�a   res://src/scripts/JS_API.gdc�      �      \v#�߃e�Y�����[gd_resource type="Environment" load_steps=2 format=2]

[sub_resource type="ProceduralSky" id=1]

[resource]
background_mode = 2
background_sky = SubResource( 1 )
             GDSC   	         ?      ���Ӷ���   �߶�   ����   �����϶�   �����������϶���   ������¶   ��������¶��   �����Ӷ�   �����׶�      event      	   _on_event         Unexpected event name:                     
                                  	   !   
   ,      0      3      =      3YY5;�  W�  YYY0�  PQX=V�  �  T�  PRR�  QYYY0�  P�  R�  QX=V�  /�  V�  \V�  �?  P�  �>  P�  QQY`               [gd_scene load_steps=3 format=2]

[ext_resource path="res://src/Main/Main.gd" type="Script" id=1]
[ext_resource path="res://src/UI/UI.tscn" type="PackedScene" id=2]

[node name="Main" type="Node"]
script = ExtResource( 1 )

[node name="UI" parent="." instance=ExtResource( 2 )]
          GDSC            a      ������ڶ   ��������ƶ��   �����������Ѷ���   �����������ƶ���   ������������¶��   �������¶���   ��������Ӷ��   �����϶�   �����������϶���   �����������������Ķ�   �����������Ӷ���   ��Ѷ   ����������¶   ����ƶ��   ���������������������Ҷ�   ���¶���   ��������¶��      MessageTextEdit       message       show_message      message_from_godot                                             !      ,   	   -   
   .      9      ?      E      F      G      M      V      _      3YY5;�  V�  W�  Y5;�  V�  �  PQYYY0�  PQX=V�  �  T�	  P�  RR�  QYYY0�
  P�  V�  QX=V�  �  T�  �  �  �  T�  PQYYY0�  PQV�  ;�  V�  �  T�  �  �  T�  P�  R�  QY`    [gd_scene load_steps=2 format=2]

[ext_resource path="res://src/UI/UI.gd" type="Script" id=1]

[node name="UI" type="Control"]
anchor_right = 1.0
anchor_bottom = 1.0
script = ExtResource( 1 )
__meta__ = {
"_edit_use_anchors_": false
}

[node name="MessagePopup" type="AcceptDialog" parent="."]
anchor_left = 0.5
anchor_top = 0.5
anchor_right = 0.5
anchor_bottom = 0.5
margin_left = -150.0
margin_top = -100.0
margin_right = 150.0
margin_bottom = 100.0
rect_min_size = Vector2( 300, 200 )
window_title = "Message"

[node name="MarginContainer" type="MarginContainer" parent="."]
anchor_right = 1.0
margin_bottom = 180.0
custom_constants/margin_right = 40
custom_constants/margin_top = 40
custom_constants/margin_left = 40
custom_constants/margin_bottom = 40
__meta__ = {
"_edit_use_anchors_": false
}

[node name="CenterContainer" type="CenterContainer" parent="MarginContainer"]
margin_left = 40.0
margin_top = 40.0
margin_right = 984.0
margin_bottom = 140.0
rect_min_size = Vector2( 0, 100 )
__meta__ = {
"_edit_use_anchors_": false
}

[node name="VBoxContainer" type="VBoxContainer" parent="MarginContainer/CenterContainer"]
margin_left = 372.0
margin_top = 4.0
margin_right = 572.0
margin_bottom = 96.0

[node name="Label" type="Label" parent="MarginContainer/CenterContainer/VBoxContainer"]
margin_right = 200.0
margin_bottom = 14.0
text = "Message: "

[node name="MessageTextEdit" type="TextEdit" parent="MarginContainer/CenterContainer/VBoxContainer"]
margin_top = 18.0
margin_right = 200.0
margin_bottom = 48.0
rect_min_size = Vector2( 0, 30 )

[node name="GodotEvent" type="Button" parent="MarginContainer/CenterContainer/VBoxContainer"]
margin_top = 52.0
margin_right = 200.0
margin_bottom = 92.0
rect_min_size = Vector2( 200, 40 )
text = "Call event from Godot"
[connection signal="pressed" from="MarginContainer/CenterContainer/VBoxContainer/GodotEvent" to="." method="_on_GodotEvent_pressed"]
               GDSC   "      j   /     ���Ӷ���   ����¶��   ���Ӷ���   ���׶���   ���������������Ŷ���   ��������¶��   �����Ӷ�   �����׶�   ��������   ������������ض��   ���������ն�   ��������Ӷ��   �����϶�   �����������϶���   ������������Ҷ��(   �������������������������������������¶�   �������������¶�   ����������Ŷ   �������Ŷ���   ����׶��   ��������������Ŷ   ����������ڶ   ��������������Ŷ   ��Ŷ   ��Ķ   ����   ���Ӷ���   ���ڶ���   �����������������Ķ�   ��������ݶ��   ��������������������Ķ��   ߶��   �����Ӷ�   �����������������Ķ�      gatewayToJS.newEvent      gatewayToGodot.    &   _check_gateways_and_create_ready_event        gatewayToGodot     ;   Gateway to Godot is undefined. Events will not be processed              gatewayToJS    >   Gateway to JS is undefined. 'new_event' function will not work     	   new_event         ready                hasEvent      getCurrentEventName       getCurrentEventData       event         next      clearEventsArray                                                                       	      
                                                   !      "      #      2      ?      @      A      J      T      U      V      ^      e      f       g   !   o   "   y   #   ~   $   �   %   �   &   �   '   �   (   �   )   �   *   �   +   �   ,   �   -   �   .   �   /   �   0   �   1   �   2   �   3   �   4   �   5   �   6   �   7   �   8   �   9   �   :   �   ;     <     =     >     ?     @      A   !  B   +  C   1  D   ;  E   E  F   N  G   O  H   P  I   c  J   m  K   u  L   v  M   �  N   �  O   �  P   �  Q   �  R   �  S   �  T   �  U   �  V   �  W   �  X   �  Y   �  Z   �  [   �  \   �  ]   �  ^   �  _   �  `      a     b     c     d     e     f   &  g   )  h   *  i   -  j   3YYB�  P�  R�  QYYYYYYYYYYYYYYY;�  V�  NOYYY0�  P�  V�  R�  V�  QX=V�  �  T�	  PRL�  R�  MQYYY0�
  P�  V�  QV�  .�  T�	  P�  �  QYYY0�  PQX=V�  �  T�  P�  QYYY0�  PQX=V�  &�  T�  P�  QV�  �F  P�  Q�  �  T�  P�  Q�  �  &�  T�  P�  QV�  �F  P�  Q�  (V�  �  T�  P�  R�	  R�
  QYYY0�  P�  QX=V�  &�  T�
  P�  QV�  �  T�  PQYYY0�  PQX=V�  *�  T�
  P�  QV�  ;�  �  T�
  P�  Q�  ;�  �  T�
  P�  Q�  �  �  P�  R�  R�  Q�  �  P�  R�  Q�  �  �  T�
  P�  Q�  �  �  T�
  P�  QYYY0�  P�  V�  R�  QX=V�  &�  T�  P�  QV�  .�  �  ;�  V�  �  L�  M�  )�  �  V�  ;�  V�  L�  M�  ;�  V�  �  L�  M�  �  T�  P�  R�  QYYY0�  P�  V�  R�  VR�  V�  QX=V�  &�  T�  P�  QV�  �  L�  MLM�  �  ;�  V�  �  L�  M�  �  T�  PL�  R�  MQYYY0�  P�  V�  R�  VR�  V�  QX=V�  &�  T�  P�  QV�  .�  �  ;�  V�  �  L�  M�  ;�  V�  �  )�  �  V�  &�  L�  M�  V�  &�  L�  M�  V�  �  T�   P�  Q�  �  �  �  YYY0�!  P�  V�  R�  VR�  V�  QX�  V�  &�  T�  P�  QV�  .�  �  �  ;�  V�  �  L�  M�  )�  �  V�  &�  L�  M�  V�  &�  L�  M�  V�  .�  �  �  .�  Y`              GDSC         #   �      ���Ӷ���   ���ڶ���   ������Ӷ   �嶶   ����������Ӷ   ���������¶�   ������������ض��   ��������Ӷ��   �����������϶���   ���������Ķ�   ������������������Ķ   �������Ķ���   ��������   �����������¶���   ���Ӷ���   ߶��   ƶ��   �������������¶�   �������Ӷ���   �������Ķ���   ����������ض   
   JavaScript            (         );                     '         ,                (typeof        !== 'undefined')                                              !      $   	   %   
   &      6      ?      M      U      V      W      b      h      r      s      ~      �      �      �      �      �      �      �      �      �      �       �   !   �   "   �   #   3YYY0�  P�  V�  QV�  &�  T�  PQV�  .�  T�  P�  Q�  (V�  .�  YYY0�  P�  V�  R�  V�  LMQV�  ;�	  V�
  P�  Q�  ;�  �>  P�  R�  R�	  R�  Q�  .�  T�  P�  QYYY0�
  P�  V�  QX�  V�  ;�	  V�  �  ;�  V�  T�  PQ�  �  )�  �K  P�  �  QV�  ;�  �  L�  M�  �	  �  �  �  �  �  �  &�  �  V�  �	  �  �  L�  �  M�  �  �  .�	  YYY0�  P�  V�  QX�  V�  ;�  �	  �  �
  �  ;�  �  T�  P�  Q�  .�  Y`             [remap]

path="res://src/Main/Main.gdc"
        [remap]

path="res://src/UI/UI.gdc"
            [remap]

path="res://src/scripts/GodotGateway.gdc"
             [remap]

path="res://src/scripts/JS_API.gdc"
   �PNG

   IHDR   @   @   �iq�   sRGB ���  0IDATx��}pTU����L����W�$�@HA�%"fa��Yw�)��A��Egةf���X�g˱��tQ���Eq�!�|K�@BHH:�t>�;�����1!ݝn�A�_UWw����{λ��sϽO�q汤��X,�q�z�<�q{cG.;��]�_�`9s��|o���:��1�E�V� ~=�	��ݮ����g[N�u�5$M��NI��-
�"(U*��@��"oqdYF�y�x�N�e�2���s����KҦ`L��Z)=,�Z}"
�A�n{�A@%$��R���F@�$m������[��H���"�VoD��v����Kw�d��v	�D�$>	�J��;�<�()P�� �F��
�< �R����&�կ��� ����������%�u̚VLNfڠus2�̚VL�~�>���mOMJ���J'R��������X����׬X�Ϲ虾��6Pq������j���S?�1@gL���±����(�2A�l��h��õm��Nb�l_�U���+����_����p�)9&&e)�0 �2{��������1���@LG�A��+���d�W|x�2-����Fk7�2x��y,_�_��}z��rzy��%n�-]l����L��;
�s���:��1�sL0�ڳ���X����m_]���BJ��im�  �d��I��Pq���N'�����lYz7�����}1�sL��v�UIX���<��Ó3���}���nvk)[����+bj�[���k�������cݮ��4t:= $h�4w:qz|A��٧�XSt�zn{�&��õmQ���+�^�j�*��S��e���o�V,	��q=Y�)hԪ��F5~����h�4 *�T�o��R���z�o)��W�]�Sm銺#�Qm�]�c�����v��JO��?D��B v|z�կ��܈�'�z6?[� ���p�X<-���o%�32����Ρz�>��5�BYX2���ʦ�b��>ǣ������SI,�6���|���iXYQ���U�҅e�9ma��:d`�iO����{��|��~����!+��Ϧ�u�n��7���t>�l捊Z�7�nвta�Z���Ae:��F���g�.~����_y^���K�5��.2�Zt*�{ܔ���G��6�Y����|%�M	���NPV.]��P���3�8g���COTy�� ����AP({�>�"/��g�0��<^��K���V����ϫ�zG�3K��k���t����)�������6���a�5��62Mq����oeJ�R�4�q�%|�� ������z���ä�>���0�T,��ǩ�����"lݰ���<��fT����IrX>� � ��K��q�}4���ʋo�dJ��م�X�sؘ]hfJ�����Ŧ�A�Gm߽�g����YG��X0u$�Y�u*jZl|p������*�Jd~qcR�����λ�.�
�r�4���zپ;��AD�eЪU��R�:��I���@�.��&3}l
o�坃7��ZX��O�� 2v����3��O���j�t	�W�0�n5����#è����%?}����`9۶n���7"!�uf��A�l܈�>��[�2��r��b�O�������gg�E��PyX�Q2-7���ʕ������p��+���~f��;����T	�*�(+q@���f��ϫ����ѓ���a��U�\.��&��}�=dd'�p�l�e@y��
r�����zDA@����9�:��8�Y,�����=�l�֮��F|kM�R��GJK��*�V_k+��P�,N.�9��K~~~�HYY��O��k���Q�����|rss�����1��ILN��~�YDV��-s�lfB֬Y�#.�=�>���G\k֬fB�f3��?��k~���f�IR�lS'�m>²9y���+ �v��y��M;NlF���A���w���w�b���Л�j�d��#T��b���e��[l<��(Z�D�NMC���k|Zi�������Ɗl��@�1��v��Щ�!曣�n��S������<@̠7�w�4X�D<A`�ԑ�ML����jw���c��8��ES��X��������ƤS�~�׾�%n�@��( Zm\�raҩ���x��_���n�n���2&d(�6�,8^o�TcG���3���emv7m6g.w��W�e
�h���|��Wy��~���̽�!c� �ݟO�)|�6#?�%�,O֫9y������w��{r�2e��7Dl �ׇB�2�@���ĬD4J)�&�$
�HԲ��
/�߹�m��<JF'!�>���S��PJ"V5!�A�(��F>SD�ۻ�$�B/>lΞ�.Ϭ�?p�l6h�D��+v�l�+v$Q�B0ūz����aԩh�|9�p����cƄ,��=Z�����������Dc��,P��� $ƩЩ�]��o+�F$p�|uM���8R��L�0�@e'���M�]^��jt*:��)^�N�@�V`�*�js�up��X�n���tt{�t:�����\�]>�n/W�\|q.x��0���D-���T��7G5jzi���[��4�r���Ij������p�=a�G�5���ͺ��S���/��#�B�EA�s�)HO`���U�/QM���cdz
�,�!�(���g�m+<R��?�-`�4^}�#>�<��mp��Op{�,[<��iz^�s�cü-�;���쾱d����xk瞨eH)��x@���h�ɪZNU_��cxx�hƤ�cwzi�p]��Q��cbɽcx��t�����M|�����x�=S�N���
Ͽ�Ee3HL�����gg,���NecG�S_ѠQJf(�Jd�4R�j��6�|�6��s<Q��N0&Ge
��Ʌ��,ᮢ$I�痹�j���Nc���'�N�n�=>|~�G��2�)�D�R U���&ՠ!#1���S�D��Ǘ'��ೃT��E�7��F��(?�����s��F��pC�Z�:�m�p�l-'�j9QU��:��a3@0�*%�#�)&�q�i�H��1�'��vv���q8]t�4����j��t-}IـxY�����C}c��-�"?Z�o�8�4Ⱦ���J]/�v�g���Cȷ2]�.�Ǣ ��Ս�{0
�>/^W7�_�����mV铲�
i���FR��$>��}^��dُ�۵�����%��*C�'�x�d9��v�ߏ � ���ۣ�Wg=N�n�~������/�}�_��M��[���uR�N���(E�	� ������z��~���.m9w����c����
�?���{�    IEND�B`�          ECFG      _global_script_classes             _global_script_class_icons             application/config/name         GodotJSGateway     application/run/main_scene          res://src/Main/Main.tscn   application/config/icon         res://icon.png     autoload/GodotGateway,      "   *res://src/scripts/GodotGateway.gd     autoload/JS_API$         *res://src/scripts/JS_API.gd   editor_plugins/enabled            gut $   rendering/quality/driver/driver_name         GLES2   %   rendering/vram_compression/import_etc         &   rendering/vram_compression/import_etc2          )   rendering/environment/default_environment          res://default_env.tres                