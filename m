Return-Path: <kvm+bounces-36975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ED9B6A23C8F
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 11:58:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 573551883506
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 10:58:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B5BC1B85EC;
	Fri, 31 Jan 2025 10:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MSXhyynl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4731B6D14
	for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 10:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738321079; cv=none; b=NaFR9IoyBTJYeWRd1ovUs9okF8k/s5TcQcBdppNJ/hC+zshgS8hJS9090GTMk8mYiy1XKTvPO5lLQKFJUcnUnBumSCkwivClrz4O/C+NsfE7oxzaX9wBPgao5LPoaFU4ijinBNyI+dbx0dTtj8ivnh+8dTV7DLe8kCaypL+P87Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738321079; c=relaxed/simple;
	bh=HmcFTHtCSkE4p5Vx86iDRx2lQmsuGDOrl0D76rU1PtE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=oaUKqamBfjTPMJBVk65WXp4DHKWBJhWikC9bWAtJ3m9hUyZWS6OHvGwwXds++u5+2Wg8ibyFfZvkpSmzaDe4ysbHWjnAnnpODUQ/eJNbY0OVJER0HxamslXkcEqiYuYp0kaIwrvG/DSQTohixqKz78JGKGfWVAEoMJiLRP0SZdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MSXhyynl; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738321077; x=1769857077;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=HmcFTHtCSkE4p5Vx86iDRx2lQmsuGDOrl0D76rU1PtE=;
  b=MSXhyynlO3cBPAq5CR2/tV7aRvrJ3PfU1+kqZ5tpn+7UpkzT8czO8BO3
   az82wXGCTQvTlYGKiWfdIelhp06L68uLEic5z/z214Lbr/MyGYbRVlnQh
   5Usi8Sh1inUaS3mz9aaqCjC2g4L9OTDO4Ire7zL24UQEhxOKiUXNLipol
   PzV26Zvy/8/skQ6uGWf1m9QTVY+bGkQ74odxuzn2x1PV1neDZW94ZuHaJ
   lw84wMsIAd2EL3HxFUPmZvELH16Cfk5nNT4dBu/dD293btxvlvigtZDUK
   jgtscE7mp2ruG7Nm/cjwGmO7OX5xCwvXxT56NzQI9+9FXREFxCK3FJhb8
   A==;
X-CSE-ConnectionGUID: w1iCSdupRziwx6fS6OH8mA==
X-CSE-MsgGUID: GA1gulZATj2iTpdiXCW/Rw==
X-IronPort-AV: E=McAfee;i="6700,10204,11331"; a="38791511"
X-IronPort-AV: E=Sophos;i="6.13,248,1732608000"; 
   d="scan'208";a="38791511"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2025 02:57:56 -0800
X-CSE-ConnectionGUID: CU2o7CGHTiq3+ruC5mnwMg==
X-CSE-MsgGUID: KzH4pnsiRAeRpkEPf8kLrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="146779572"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 31 Jan 2025 02:57:54 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tdoid-000mHt-2a;
	Fri, 31 Jan 2025 10:57:51 +0000
Date: Fri, 31 Jan 2025 18:57:42 +0800
From: kernel test robot <lkp@intel.com>
To: Kai Huang <kai.huang@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	Farrah Chen <farrah.chen@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm:kvm-coco-queue-20250129 43/129] arch/x86/kvm/vmx/main.c:176:13:
 error: 'vt_exit' undeclared; did you mean 'vmx_exit'?
Message-ID: <202501311811.fRf67aOn-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-coco-queue-20250129
head:   0bc4f452607db4e7eee4d3056cd6ec98636260bc
commit: 4b55a8f7c5f508fe1dd0005aecc81bbb5676aaec [43/129] KVM: VMX: Refactor VMX module init/exit functions
config: i386-allmodconfig (https://download.01.org/0day-ci/archive/20250131/202501311811.fRf67aOn-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250131/202501311811.fRf67aOn-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202501311811.fRf67aOn-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/kallsyms.h:14,
                    from include/linux/ftrace.h:13,
                    from include/linux/kvm_host.h:32,
                    from arch/x86/kvm/vmx/x86_ops.h:5,
                    from arch/x86/kvm/vmx/main.c:4:
   arch/x86/kvm/vmx/main.c: In function '__exittest':
>> arch/x86/kvm/vmx/main.c:176:13: error: 'vt_exit' undeclared (first use in this function); did you mean 'vmx_exit'?
     176 | module_exit(vt_exit);
         |             ^~~~~~~
   include/linux/module.h:140:18: note: in definition of macro 'module_exit'
     140 |         { return exitfn; }                                      \
         |                  ^~~~~~
   arch/x86/kvm/vmx/main.c:176:13: note: each undeclared identifier is reported only once for each function it appears in
     176 | module_exit(vt_exit);
         |             ^~~~~~~
   include/linux/module.h:140:18: note: in definition of macro 'module_exit'
     140 |         { return exitfn; }                                      \
         |                  ^~~~~~
   In file included from include/linux/compiler_types.h:89,
                    from <command-line>:
   arch/x86/kvm/vmx/main.c: At top level:
>> arch/x86/kvm/vmx/main.c:176:13: error: 'vt_exit' undeclared here (not in a function); did you mean 'vmx_exit'?
     176 | module_exit(vt_exit);
         |             ^~~~~~~
   include/linux/compiler_attributes.h:92:65: note: in definition of macro '__copy'
      92 | # define __copy(symbol)                 __attribute__((__copy__(symbol)))
         |                                                                 ^~~~~~
   arch/x86/kvm/vmx/main.c:176:1: note: in expansion of macro 'module_exit'
     176 | module_exit(vt_exit);
         | ^~~~~~~~~~~
>> include/linux/module.h:139:49: error: redefinition of '__exittest'
     139 |         static inline exitcall_t __maybe_unused __exittest(void)                \
         |                                                 ^~~~~~~~~~
   arch/x86/kvm/vmx/main.c:183:1: note: in expansion of macro 'module_exit'
     183 | module_exit(vt_exit);
         | ^~~~~~~~~~~
   include/linux/module.h:139:49: note: previous definition of '__exittest' with type 'void (*(void))(void)'
     139 |         static inline exitcall_t __maybe_unused __exittest(void)                \
         |                                                 ^~~~~~~~~~
   arch/x86/kvm/vmx/main.c:176:1: note: in expansion of macro 'module_exit'
     176 | module_exit(vt_exit);
         | ^~~~~~~~~~~
>> include/linux/module.h:141:14: error: redefinition of 'cleanup_module'
     141 |         void cleanup_module(void) __copy(exitfn)                \
         |              ^~~~~~~~~~~~~~
   arch/x86/kvm/vmx/main.c:183:1: note: in expansion of macro 'module_exit'
     183 | module_exit(vt_exit);
         | ^~~~~~~~~~~
   include/linux/module.h:141:14: note: previous definition of 'cleanup_module' with type 'void(void)'
     141 |         void cleanup_module(void) __copy(exitfn)                \
         |              ^~~~~~~~~~~~~~
   arch/x86/kvm/vmx/main.c:176:1: note: in expansion of macro 'module_exit'
     176 | module_exit(vt_exit);
         | ^~~~~~~~~~~
--
   In file included from include/linux/kallsyms.h:14,
                    from include/linux/ftrace.h:13,
                    from include/linux/kvm_host.h:32,
                    from vmx/x86_ops.h:5,
                    from vmx/main.c:4:
   vmx/main.c: In function '__exittest':
   vmx/main.c:176:13: error: 'vt_exit' undeclared (first use in this function); did you mean 'vmx_exit'?
     176 | module_exit(vt_exit);
         |             ^~~~~~~
   include/linux/module.h:140:18: note: in definition of macro 'module_exit'
     140 |         { return exitfn; }                                      \
         |                  ^~~~~~
   vmx/main.c:176:13: note: each undeclared identifier is reported only once for each function it appears in
     176 | module_exit(vt_exit);
         |             ^~~~~~~
   include/linux/module.h:140:18: note: in definition of macro 'module_exit'
     140 |         { return exitfn; }                                      \
         |                  ^~~~~~
   In file included from include/linux/compiler_types.h:89,
                    from <command-line>:
   vmx/main.c: At top level:
   vmx/main.c:176:13: error: 'vt_exit' undeclared here (not in a function); did you mean 'vmx_exit'?
     176 | module_exit(vt_exit);
         |             ^~~~~~~
   include/linux/compiler_attributes.h:92:65: note: in definition of macro '__copy'
      92 | # define __copy(symbol)                 __attribute__((__copy__(symbol)))
         |                                                                 ^~~~~~
   vmx/main.c:176:1: note: in expansion of macro 'module_exit'
     176 | module_exit(vt_exit);
         | ^~~~~~~~~~~
>> include/linux/module.h:139:49: error: redefinition of '__exittest'
     139 |         static inline exitcall_t __maybe_unused __exittest(void)                \
         |                                                 ^~~~~~~~~~
   vmx/main.c:183:1: note: in expansion of macro 'module_exit'
     183 | module_exit(vt_exit);
         | ^~~~~~~~~~~
   include/linux/module.h:139:49: note: previous definition of '__exittest' with type 'void (*(void))(void)'
     139 |         static inline exitcall_t __maybe_unused __exittest(void)                \
         |                                                 ^~~~~~~~~~
   vmx/main.c:176:1: note: in expansion of macro 'module_exit'
     176 | module_exit(vt_exit);
         | ^~~~~~~~~~~
>> include/linux/module.h:141:14: error: redefinition of 'cleanup_module'
     141 |         void cleanup_module(void) __copy(exitfn)                \
         |              ^~~~~~~~~~~~~~
   vmx/main.c:183:1: note: in expansion of macro 'module_exit'
     183 | module_exit(vt_exit);
         | ^~~~~~~~~~~
   include/linux/module.h:141:14: note: previous definition of 'cleanup_module' with type 'void(void)'
     141 |         void cleanup_module(void) __copy(exitfn)                \
         |              ^~~~~~~~~~~~~~
   vmx/main.c:176:1: note: in expansion of macro 'module_exit'
     176 | module_exit(vt_exit);
         | ^~~~~~~~~~~


vim +176 arch/x86/kvm/vmx/main.c

     3	
   > 4	#include "x86_ops.h"
     5	#include "vmx.h"
     6	#include "nested.h"
     7	#include "pmu.h"
     8	#include "posted_intr.h"
     9	
    10	#define VMX_REQUIRED_APICV_INHIBITS				\
    11		(BIT(APICV_INHIBIT_REASON_DISABLED) |			\
    12		 BIT(APICV_INHIBIT_REASON_ABSENT) |			\
    13		 BIT(APICV_INHIBIT_REASON_HYPERV) |			\
    14		 BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |			\
    15		 BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |	\
    16		 BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |		\
    17		 BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED))
    18	
    19	struct kvm_x86_ops vt_x86_ops __initdata = {
    20		.name = KBUILD_MODNAME,
    21	
    22		.check_processor_compatibility = vmx_check_processor_compat,
    23	
    24		.hardware_unsetup = vmx_hardware_unsetup,
    25	
    26		.enable_virtualization_cpu = vmx_enable_virtualization_cpu,
    27		.disable_virtualization_cpu = vmx_disable_virtualization_cpu,
    28		.emergency_disable_virtualization_cpu = vmx_emergency_disable_virtualization_cpu,
    29	
    30		.has_emulated_msr = vmx_has_emulated_msr,
    31	
    32		.vm_size = sizeof(struct kvm_vmx),
    33		.vm_init = vmx_vm_init,
    34		.vm_destroy = vmx_vm_destroy,
    35	
    36		.vcpu_precreate = vmx_vcpu_precreate,
    37		.vcpu_create = vmx_vcpu_create,
    38		.vcpu_free = vmx_vcpu_free,
    39		.vcpu_reset = vmx_vcpu_reset,
    40	
    41		.prepare_switch_to_guest = vmx_prepare_switch_to_guest,
    42		.vcpu_load = vmx_vcpu_load,
    43		.vcpu_put = vmx_vcpu_put,
    44	
    45		.update_exception_bitmap = vmx_update_exception_bitmap,
    46		.get_feature_msr = vmx_get_feature_msr,
    47		.get_msr = vmx_get_msr,
    48		.set_msr = vmx_set_msr,
    49		.get_segment_base = vmx_get_segment_base,
    50		.get_segment = vmx_get_segment,
    51		.set_segment = vmx_set_segment,
    52		.get_cpl = vmx_get_cpl,
    53		.get_cpl_no_cache = vmx_get_cpl_no_cache,
    54		.get_cs_db_l_bits = vmx_get_cs_db_l_bits,
    55		.is_valid_cr0 = vmx_is_valid_cr0,
    56		.set_cr0 = vmx_set_cr0,
    57		.is_valid_cr4 = vmx_is_valid_cr4,
    58		.set_cr4 = vmx_set_cr4,
    59		.set_efer = vmx_set_efer,
    60		.get_idt = vmx_get_idt,
    61		.set_idt = vmx_set_idt,
    62		.get_gdt = vmx_get_gdt,
    63		.set_gdt = vmx_set_gdt,
    64		.set_dr7 = vmx_set_dr7,
    65		.sync_dirty_debug_regs = vmx_sync_dirty_debug_regs,
    66		.cache_reg = vmx_cache_reg,
    67		.get_rflags = vmx_get_rflags,
    68		.set_rflags = vmx_set_rflags,
    69		.get_if_flag = vmx_get_if_flag,
    70	
    71		.flush_tlb_all = vmx_flush_tlb_all,
    72		.flush_tlb_current = vmx_flush_tlb_current,
    73		.flush_tlb_gva = vmx_flush_tlb_gva,
    74		.flush_tlb_guest = vmx_flush_tlb_guest,
    75	
    76		.vcpu_pre_run = vmx_vcpu_pre_run,
    77		.vcpu_run = vmx_vcpu_run,
    78		.handle_exit = vmx_handle_exit,
    79		.skip_emulated_instruction = vmx_skip_emulated_instruction,
    80		.update_emulated_instruction = vmx_update_emulated_instruction,
    81		.set_interrupt_shadow = vmx_set_interrupt_shadow,
    82		.get_interrupt_shadow = vmx_get_interrupt_shadow,
    83		.patch_hypercall = vmx_patch_hypercall,
    84		.inject_irq = vmx_inject_irq,
    85		.inject_nmi = vmx_inject_nmi,
    86		.inject_exception = vmx_inject_exception,
    87		.cancel_injection = vmx_cancel_injection,
    88		.interrupt_allowed = vmx_interrupt_allowed,
    89		.nmi_allowed = vmx_nmi_allowed,
    90		.get_nmi_mask = vmx_get_nmi_mask,
    91		.set_nmi_mask = vmx_set_nmi_mask,
    92		.enable_nmi_window = vmx_enable_nmi_window,
    93		.enable_irq_window = vmx_enable_irq_window,
    94		.update_cr8_intercept = vmx_update_cr8_intercept,
    95	
    96		.x2apic_icr_is_split = false,
    97		.set_virtual_apic_mode = vmx_set_virtual_apic_mode,
    98		.set_apic_access_page_addr = vmx_set_apic_access_page_addr,
    99		.refresh_apicv_exec_ctrl = vmx_refresh_apicv_exec_ctrl,
   100		.load_eoi_exitmap = vmx_load_eoi_exitmap,
   101		.apicv_pre_state_restore = vmx_apicv_pre_state_restore,
   102		.required_apicv_inhibits = VMX_REQUIRED_APICV_INHIBITS,
   103		.hwapic_isr_update = vmx_hwapic_isr_update,
   104		.sync_pir_to_irr = vmx_sync_pir_to_irr,
   105		.deliver_interrupt = vmx_deliver_interrupt,
   106		.dy_apicv_has_pending_interrupt = pi_has_pending_interrupt,
   107	
   108		.set_tss_addr = vmx_set_tss_addr,
   109		.set_identity_map_addr = vmx_set_identity_map_addr,
   110		.get_mt_mask = vmx_get_mt_mask,
   111	
   112		.get_exit_info = vmx_get_exit_info,
   113		.get_entry_info = vmx_get_entry_info,
   114	
   115		.vcpu_after_set_cpuid = vmx_vcpu_after_set_cpuid,
   116	
   117		.has_wbinvd_exit = cpu_has_vmx_wbinvd_exit,
   118	
   119		.get_l2_tsc_offset = vmx_get_l2_tsc_offset,
   120		.get_l2_tsc_multiplier = vmx_get_l2_tsc_multiplier,
   121		.write_tsc_offset = vmx_write_tsc_offset,
   122		.write_tsc_multiplier = vmx_write_tsc_multiplier,
   123	
   124		.load_mmu_pgd = vmx_load_mmu_pgd,
   125	
   126		.check_intercept = vmx_check_intercept,
   127		.handle_exit_irqoff = vmx_handle_exit_irqoff,
   128	
   129		.cpu_dirty_log_size = PML_LOG_NR_ENTRIES,
   130		.update_cpu_dirty_logging = vmx_update_cpu_dirty_logging,
   131	
   132		.nested_ops = &vmx_nested_ops,
   133	
   134		.pi_update_irte = vmx_pi_update_irte,
   135		.pi_start_assignment = vmx_pi_start_assignment,
   136	
   137	#ifdef CONFIG_X86_64
   138		.set_hv_timer = vmx_set_hv_timer,
   139		.cancel_hv_timer = vmx_cancel_hv_timer,
   140	#endif
   141	
   142		.setup_mce = vmx_setup_mce,
   143	
   144	#ifdef CONFIG_KVM_SMM
   145		.smi_allowed = vmx_smi_allowed,
   146		.enter_smm = vmx_enter_smm,
   147		.leave_smm = vmx_leave_smm,
   148		.enable_smi_window = vmx_enable_smi_window,
   149	#endif
   150	
   151		.check_emulate_instruction = vmx_check_emulate_instruction,
   152		.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
   153		.migrate_timers = vmx_migrate_timers,
   154	
   155		.msr_filter_changed = vmx_msr_filter_changed,
   156		.complete_emulated_msr = kvm_complete_insn_gp,
   157	
   158		.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
   159	
   160		.get_untagged_addr = vmx_get_untagged_addr,
   161	};
   162	
   163	struct kvm_x86_init_ops vt_init_ops __initdata = {
   164		.hardware_setup = vmx_hardware_setup,
   165		.handle_intel_pt_intr = NULL,
   166	
   167		.runtime_ops = &vt_x86_ops,
   168		.pmu_ops = &intel_pmu_ops,
   169	};
   170	
   171	static void __vt_exit(void)
   172	{
   173		vmx_exit();
   174		kvm_x86_vendor_exit();
   175	}
 > 176	module_exit(vt_exit);
   177	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

