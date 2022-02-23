Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9F84C074D
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 02:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236729AbiBWBpL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 20:45:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236743AbiBWBow (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 20:44:52 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20271517CB
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 17:44:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645580663; x=1677116663;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=/na68BmwfNyxGVFT5C6eEJf+tN2PqzEAB+w5bQ4l544=;
  b=bEuxdrfDWdLU+vLLXh/CZfkHxtj2DqM0l7fu8kNTnA8MyuBQxLj1l0vK
   RisJ7vDGYE/uf4n1PfTZEIBtC6mvYfI5UFXWc5D6XMDLnDVgPIVgDRKN/
   fDMp3Mwl1E0cnW84VYoKMuZnoq/f78O22qCLfg+aUQNWYcGjep/alvmEH
   tc8HS8MDwgh8px8aMpKUTTaGpT8YA0mCvdQLMD1A8gg7GFOTYrY7ggBAQ
   g5iTlf/P1b6uRCHcursJONja3Vq+Zat41tqUvVt59NozKVJUFp905njB8
   AwTAKyu+SbS59MX+VfHYC0MYDYPgfdYrK4M4uOfFi+I4AsIuw0lq7sSnC
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10266"; a="312574570"
X-IronPort-AV: E=Sophos;i="5.88,389,1635231600"; 
   d="scan'208";a="312574570"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 17:44:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,389,1635231600"; 
   d="scan'208";a="706843524"
Received: from lkp-server01.sh.intel.com (HELO 788b1cd46f0d) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 22 Feb 2022 17:44:10 -0800
Received: from kbuild by 788b1cd46f0d with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nMghN-0000ph-JX; Wed, 23 Feb 2022 01:44:09 +0000
Date:   Wed, 23 Feb 2022 09:43:48 +0800
From:   kernel test robot <lkp@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [kvm:next 100/102] arch/x86/include/asm/kvm-x86-ops.h:82:1: warning:
 pointer type mismatch ('bool (*)(struct kvm_vcpu *)' (aka '_Bool (*)(struct
 kvm_vcpu *)') and 'void *')
Message-ID: <202202230922.YPbPSQvc-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git next
head:   0828824158b1cb8108bb2b1f5eeab5826e6017e7
commit: 5be2226f417d5b06d17e6c52d6e341cf43c29e48 [100/102] KVM: x86: allow defining return-0 static calls
config: x86_64-randconfig-c007-20220221 (https://download.01.org/0day-ci/archive/20220223/202202230922.YPbPSQvc-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project d271fc04d5b97b12e6b797c6067d3c96a8d7470e)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=5be2226f417d5b06d17e6c52d6e341cf43c29e48
        git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
        git fetch --no-tags kvm next
        git checkout 5be2226f417d5b06d17e6c52d6e341cf43c29e48
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from arch/x86/kvm/../../../virt/kvm/kvm_main.c:18:
   In file included from include/linux/kvm_host.h:45:
   In file included from arch/x86/include/asm/kvm_host.h:1557:
>> arch/x86/include/asm/kvm-x86-ops.h:82:1: warning: pointer type mismatch ('bool (*)(struct kvm_vcpu *)' (aka '_Bool (*)(struct kvm_vcpu *)') and 'void *') [-Wpointer-type-mismatch]
   KVM_X86_OP_OPTIONAL_RET0(guest_apic_has_interrupt)
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/x86/include/asm/kvm_host.h:1555:54: note: expanded from macro 'KVM_X86_OP_OPTIONAL_RET0'
           static_call_update(kvm_x86_##func, kvm_x86_ops.func ? : \
           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~
   include/linux/static_call.h:154:42: note: expanded from macro 'static_call_update'
           typeof(&STATIC_CALL_TRAMP(name)) __F = (func);                  \
                                                   ^~~~
   In file included from arch/x86/kvm/../../../virt/kvm/kvm_main.c:18:
   In file included from include/linux/kvm_host.h:45:
   In file included from arch/x86/include/asm/kvm_host.h:1557:
>> arch/x86/include/asm/kvm-x86-ops.h:88:1: warning: pointer type mismatch ('int (*)(struct kvm *, unsigned int)' and 'void *') [-Wpointer-type-mismatch]
   KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/x86/include/asm/kvm_host.h:1555:54: note: expanded from macro 'KVM_X86_OP_OPTIONAL_RET0'
           static_call_update(kvm_x86_##func, kvm_x86_ops.func ? : \
           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~
   include/linux/static_call.h:154:42: note: expanded from macro 'static_call_update'
           typeof(&STATIC_CALL_TRAMP(name)) __F = (func);                  \
                                                   ^~~~
   In file included from arch/x86/kvm/../../../virt/kvm/kvm_main.c:18:
   In file included from include/linux/kvm_host.h:45:
   In file included from arch/x86/include/asm/kvm_host.h:1557:
>> arch/x86/include/asm/kvm-x86-ops.h:89:1: warning: pointer type mismatch ('int (*)(struct kvm *, u64)' (aka 'int (*)(struct kvm *, unsigned long long)') and 'void *') [-Wpointer-type-mismatch]
   KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/x86/include/asm/kvm_host.h:1555:54: note: expanded from macro 'KVM_X86_OP_OPTIONAL_RET0'
           static_call_update(kvm_x86_##func, kvm_x86_ops.func ? : \
           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~
   include/linux/static_call.h:154:42: note: expanded from macro 'static_call_update'
           typeof(&STATIC_CALL_TRAMP(name)) __F = (func);                  \
                                                   ^~~~
   In file included from arch/x86/kvm/../../../virt/kvm/kvm_main.c:18:
   In file included from include/linux/kvm_host.h:45:
   In file included from arch/x86/include/asm/kvm_host.h:1557:
>> arch/x86/include/asm/kvm-x86-ops.h:90:1: warning: pointer type mismatch ('u64 (*)(struct kvm_vcpu *, gfn_t, bool)' (aka 'unsigned long long (*)(struct kvm_vcpu *, unsigned long long, _Bool)') and 'void *') [-Wpointer-type-mismatch]
   KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/x86/include/asm/kvm_host.h:1555:54: note: expanded from macro 'KVM_X86_OP_OPTIONAL_RET0'
           static_call_update(kvm_x86_##func, kvm_x86_ops.func ? : \
           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~
   include/linux/static_call.h:154:42: note: expanded from macro 'static_call_update'
           typeof(&STATIC_CALL_TRAMP(name)) __F = (func);                  \
                                                   ^~~~
   In file included from arch/x86/kvm/../../../virt/kvm/kvm_main.c:18:
   In file included from include/linux/kvm_host.h:45:
   In file included from arch/x86/include/asm/kvm_host.h:1557:
   arch/x86/include/asm/kvm-x86-ops.h:108:1: warning: pointer type mismatch ('bool (*)(struct kvm_vcpu *)' (aka '_Bool (*)(struct kvm_vcpu *)') and 'void *') [-Wpointer-type-mismatch]
   KVM_X86_OP_OPTIONAL_RET0(dy_apicv_has_pending_interrupt)
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/x86/include/asm/kvm_host.h:1555:54: note: expanded from macro 'KVM_X86_OP_OPTIONAL_RET0'
           static_call_update(kvm_x86_##func, kvm_x86_ops.func ? : \
           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~
   include/linux/static_call.h:154:42: note: expanded from macro 'static_call_update'
           typeof(&STATIC_CALL_TRAMP(name)) __F = (func);                  \
                                                   ^~~~
   5 warnings generated.


vim +82 arch/x86/include/asm/kvm-x86-ops.h

     5	
     6	/*
     7	 * KVM_X86_OP() and KVM_X86_OP_OPTIONAL() are used to help generate
     8	 * both DECLARE/DEFINE_STATIC_CALL() invocations and
     9	 * "static_call_update()" calls.
    10	 *
    11	 * KVM_X86_OP_OPTIONAL() can be used for those functions that can have
    12	 * a NULL definition, for example if "static_call_cond()" will be used
    13	 * at the call sites.  KVM_X86_OP_OPTIONAL_RET0() can be used likewise
    14	 * to make a definition optional, but in this case the default will
    15	 * be __static_call_return0.
    16	 */
    17	KVM_X86_OP(hardware_enable)
    18	KVM_X86_OP(hardware_disable)
    19	KVM_X86_OP(hardware_unsetup)
    20	KVM_X86_OP(has_emulated_msr)
    21	KVM_X86_OP(vcpu_after_set_cpuid)
    22	KVM_X86_OP(vm_init)
    23	KVM_X86_OP_OPTIONAL(vm_destroy)
    24	KVM_X86_OP(vcpu_create)
    25	KVM_X86_OP(vcpu_free)
    26	KVM_X86_OP(vcpu_reset)
    27	KVM_X86_OP(prepare_switch_to_guest)
    28	KVM_X86_OP(vcpu_load)
    29	KVM_X86_OP(vcpu_put)
    30	KVM_X86_OP(update_exception_bitmap)
    31	KVM_X86_OP(get_msr)
    32	KVM_X86_OP(set_msr)
    33	KVM_X86_OP(get_segment_base)
    34	KVM_X86_OP(get_segment)
    35	KVM_X86_OP(get_cpl)
    36	KVM_X86_OP(set_segment)
    37	KVM_X86_OP(get_cs_db_l_bits)
    38	KVM_X86_OP(set_cr0)
    39	KVM_X86_OP_OPTIONAL(post_set_cr3)
    40	KVM_X86_OP(is_valid_cr4)
    41	KVM_X86_OP(set_cr4)
    42	KVM_X86_OP(set_efer)
    43	KVM_X86_OP(get_idt)
    44	KVM_X86_OP(set_idt)
    45	KVM_X86_OP(get_gdt)
    46	KVM_X86_OP(set_gdt)
    47	KVM_X86_OP(sync_dirty_debug_regs)
    48	KVM_X86_OP(set_dr7)
    49	KVM_X86_OP(cache_reg)
    50	KVM_X86_OP(get_rflags)
    51	KVM_X86_OP(set_rflags)
    52	KVM_X86_OP(get_if_flag)
    53	KVM_X86_OP(flush_tlb_all)
    54	KVM_X86_OP(flush_tlb_current)
    55	KVM_X86_OP_OPTIONAL(tlb_remote_flush)
    56	KVM_X86_OP_OPTIONAL(tlb_remote_flush_with_range)
    57	KVM_X86_OP(flush_tlb_gva)
    58	KVM_X86_OP(flush_tlb_guest)
    59	KVM_X86_OP(vcpu_pre_run)
    60	KVM_X86_OP(vcpu_run)
    61	KVM_X86_OP(handle_exit)
    62	KVM_X86_OP(skip_emulated_instruction)
    63	KVM_X86_OP_OPTIONAL(update_emulated_instruction)
    64	KVM_X86_OP(set_interrupt_shadow)
    65	KVM_X86_OP(get_interrupt_shadow)
    66	KVM_X86_OP(patch_hypercall)
    67	KVM_X86_OP(inject_irq)
    68	KVM_X86_OP(inject_nmi)
    69	KVM_X86_OP(queue_exception)
    70	KVM_X86_OP(cancel_injection)
    71	KVM_X86_OP(interrupt_allowed)
    72	KVM_X86_OP(nmi_allowed)
    73	KVM_X86_OP(get_nmi_mask)
    74	KVM_X86_OP(set_nmi_mask)
    75	KVM_X86_OP(enable_nmi_window)
    76	KVM_X86_OP(enable_irq_window)
    77	KVM_X86_OP_OPTIONAL(update_cr8_intercept)
    78	KVM_X86_OP(check_apicv_inhibit_reasons)
    79	KVM_X86_OP(refresh_apicv_exec_ctrl)
    80	KVM_X86_OP_OPTIONAL(hwapic_irr_update)
    81	KVM_X86_OP_OPTIONAL(hwapic_isr_update)
  > 82	KVM_X86_OP_OPTIONAL_RET0(guest_apic_has_interrupt)
    83	KVM_X86_OP_OPTIONAL(load_eoi_exitmap)
    84	KVM_X86_OP_OPTIONAL(set_virtual_apic_mode)
    85	KVM_X86_OP_OPTIONAL(set_apic_access_page_addr)
    86	KVM_X86_OP(deliver_interrupt)
    87	KVM_X86_OP_OPTIONAL(sync_pir_to_irr)
  > 88	KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
  > 89	KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
  > 90	KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
    91	KVM_X86_OP(load_mmu_pgd)
    92	KVM_X86_OP(has_wbinvd_exit)
    93	KVM_X86_OP(get_l2_tsc_offset)
    94	KVM_X86_OP(get_l2_tsc_multiplier)
    95	KVM_X86_OP(write_tsc_offset)
    96	KVM_X86_OP(write_tsc_multiplier)
    97	KVM_X86_OP(get_exit_info)
    98	KVM_X86_OP(check_intercept)
    99	KVM_X86_OP(handle_exit_irqoff)
   100	KVM_X86_OP(request_immediate_exit)
   101	KVM_X86_OP(sched_in)
   102	KVM_X86_OP_OPTIONAL(update_cpu_dirty_logging)
   103	KVM_X86_OP_OPTIONAL(vcpu_blocking)
   104	KVM_X86_OP_OPTIONAL(vcpu_unblocking)
   105	KVM_X86_OP_OPTIONAL(pi_update_irte)
   106	KVM_X86_OP_OPTIONAL(pi_start_assignment)
   107	KVM_X86_OP_OPTIONAL(apicv_post_state_restore)
   108	KVM_X86_OP_OPTIONAL_RET0(dy_apicv_has_pending_interrupt)
   109	KVM_X86_OP_OPTIONAL(set_hv_timer)
   110	KVM_X86_OP_OPTIONAL(cancel_hv_timer)
   111	KVM_X86_OP(setup_mce)
   112	KVM_X86_OP(smi_allowed)
   113	KVM_X86_OP(enter_smm)
   114	KVM_X86_OP(leave_smm)
   115	KVM_X86_OP(enable_smi_window)
   116	KVM_X86_OP_OPTIONAL(mem_enc_ioctl)
   117	KVM_X86_OP_OPTIONAL(mem_enc_register_region)
   118	KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
   119	KVM_X86_OP_OPTIONAL(vm_copy_enc_context_from)
   120	KVM_X86_OP_OPTIONAL(vm_move_enc_context_from)
   121	KVM_X86_OP(get_msr_feature)
   122	KVM_X86_OP(can_emulate_instruction)
   123	KVM_X86_OP(apic_init_signal_blocked)
   124	KVM_X86_OP_OPTIONAL(enable_direct_tlbflush)
   125	KVM_X86_OP_OPTIONAL(migrate_timers)
   126	KVM_X86_OP(msr_filter_changed)
   127	KVM_X86_OP(complete_emulated_msr)
   128	KVM_X86_OP(vcpu_deliver_sipi_vector)
   129	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
