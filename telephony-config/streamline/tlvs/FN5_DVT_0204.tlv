   ��     �  nvm:fix_s45_lut.tx.tx_config_table[0,19].active_bands={2,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
nvm:fix_s45_lut.txlte.txlte_config_table[0,19].4g_active_bands={0,2,0,4,5,0,0,13,0,0,0,0,0,0,0,0,0,0,0,0}
nvm:fix_s45_lut.tx.fbr_config_table[0,23].bands={2,2,4,5,5,13,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
nvm:fix_s45_lut.tx.fbr_config_table[0,23].cal_mode={1,2,2,1,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
nvm:fix_s45_lut.tx.fbr_config_table[0,23].supported_mode={2,5,4,2,5,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
nvm:fix_s45_lut.rfc.sr_rfc_tx_gctdep_pat[0,27].sr_rfc_ser_tx_pat0_pa={22,22,17,17,4,4,3,9,9,12,12,12,12,10,0,10,11,0,0,0,0,0,0,0,0,0,0,0}
nvm:fix_s45_lut.rfc.sr_rfc_tx_gctdep_pat[0,27].sr_rfc_ser_tx_pat1_pa={22,22,17,17,6,6,5,9,9,12,12,12,12,10,0,10,11,0,0,0,0,0,0,0,0,0,0,0}
nvm:fix_s45_lut.rfc.sr_rfc_tx_gctdep_pat[0,27].sr_rfc_ser_tx_pat2_pa={22,22,12,12,12,12,9,9,9,12,12,12,12,10,0,10,11,0,0,0,0,0,0,0,0,0,0,0}
nvm:fix_s45_lut.rfc.sr_rfc_tx_gctdep_pat[0,27].sr_rfc_ser_tx_pat4_pa={8,8,4,4,3,3,5,9,9,10,9,11,11,7,0,7,7,0,0,0,0,0,0,0,0,0,0,0}
nvm:fix_s45_lut.rfc.sr_rfc_tx_gctdep_pat[0,27].sr_rfc_ser_tx_pat5_pa={8,8,4,4,5,5,7,9,9,10,9,11,11,7,0,7,7,0,0,0,0,0,0,0,0,0,0,0}
nvm:fix_s45_lut.rfc.sr_rfc_tx_gctdep_pat[0,27].sr_rfc_ser_tx_pat6_pa={8,8,11,11,10,10,11,9,9,10,9,11,11,7,0,7,7,0,0,0,0,0,0,0,0,0,0,0}
nvm:fix_s45_lut.txlte.txlte_config_table[0,19].4g_subband={255,255,255,255,255,255,255,255,255,255,0,0,0,0,0,0,0,0,0,0}
nvm:fix_s45_lut.txlte.txlte_config_table[0,19].4g_tx_max_pwr={0,368,0,376,368,0,0,368,0,0,0,0,0,0,0,0,0,0,0,0}
nvm:fix_s45_lut.tx.sr_tq_fbr_temp_comp[0,15].sr_tq_fbr_temp_coeff_hi={15,13,11,15,18,10,1,13,0,11,11,0,15,0,0,0}
nvm:fix_s45_lut.tx.sr_tq_fbr_temp_comp[0,15].sr_tq_fbr_temp_coeff_lo={20,16,20,16,16,25,16,18,0,27,25,0,17,0,0,0}
nvm:fix_s45_lut.tx.sr_tq_fbr_temp_comp[0,15].sr_tq_fbr_temp_thr={26,28,26,26,28,26,34,26,26,26,26,26,26,0,0,0}
nvm:fix_s45_lut.tx3g.tempcomp.sr_tp_u_cl_tempcomp_tb[0,6].sr_tp_u_cl_tempcoeff_hit={16,30,16,26,18,18,16}
nvm:fix_s45_lut.tx3g.pmax.sr_tp_u_pmax_tb[0,15].sr_tp_u_pmax={368,368,368,368,368,368,368,368,368,368,368,368,368,368,368,368}
nvm:fix_s45_lut.tx2g.pmax.sr_tp_g_pmax_tb[0,3].sr_tp_g_pmax={528,528,480,480}
nvm:fix_s45_lut.tx2g.pmax.sr_tp_p_pmax_tb[0,3].sr_tp_p_pmax={432,432,416,416}
nvm:store_nvm_sync(fix_s45_lut)
nvm:fix_cps.gsm_band_config.nvr_nbr_band_config=2
nvm:fix_cps.gsm_band_config.nvr_band_config_list[0,9]= {5,6,255,255,255,255,255,255,255,255}
nvm:store_nvm_sync(fix_cps)
nvm:fix_s45_lut.cust_ovw.sr_tx_reg_res_ovw_cust_lut[0,63].sr_data={0,25752,40088,42144,0,0,0,12,32904,768,40968,2816,40968,2817,63496,0,63496,0,40968,2560,40968,2561,63496,0,63496,0,63496,0,63496,0,0,0,526,128,3840,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
nvm:fix_s45_lut.rfc.sr_rfc_fe_pat[0,19].sr_rfc_pat_fe1_on={0,0,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,15,0}
nvm:store_nvm_sync(fix_s45_lut)
nvm:cal_s45_lut.txlte.dcdc.sr_tq_dcdc2_coeff[0,15].sr_tq_dcdc_coeff_a_hi={92,50,72,73,73,72,85,90,99,72,102,48,90,46,100,82}
nvm:cal_s45_lut.txlte.dcdc.sr_tq_dcdc2_coeff[0,15].sr_tq_dcdc_coeff_b_hi={100,70,86,72,74,76,90,74,82,73,86,116,74,50,83,50}
nvm:store_nvm_sync(cal_s45_lut)

      J;<.��TV(���&�|�x�����Q�/��)Q�\��Y����nT�O��$��ϊ�2�v�k�."e�rk�_
�Χ�˂g��^1t׾|B�N/#�8��Ì��/�:`����[�@��M�z��V,�A=���I̍%���-U�%�=)<�)D���5u�a%�?�Te�^K�R�n�� �y�*a�.4q�����f�	ݛ��Jh�0�e&����a��-j.`��n�i��-{aw�\T+��U