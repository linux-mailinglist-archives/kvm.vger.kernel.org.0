Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D725649AB09
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 05:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S3418000AbiAYEFz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 23:05:55 -0500
Received: from mga07.intel.com ([134.134.136.100]:14053 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S248010AbiAYDzp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jan 2022 22:55:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643082945; x=1674618945;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=63ESE7Tc2CYT1m5Oit+Z+quuqyGdO13wm2AqQxbFE78=;
  b=eZw3OglALguvmks8gYQ/WABk6lI+B2qOrw5jSF1p5lUC4ODxhXJOPWyj
   GB8WiA6WYSqa1aZFoE9jFG4cp7gq1BCOz/Ke2Q/WBAyNzP+JF2gNnjwEQ
   y6HNTWs38z8Y5DOWrykXKeWmYNXxwB8ny9wfOmkdqFffMPW0FDwHCduoN
   GAqqtfHJ5Zi0xDlIiD93UHuD+lMgvWxgRUc3sU1YFJqjxakm/dl9VATQC
   2sUQnBPJLOEiarjk+fT9u2/LUo34cgk2Hi2mLPz8XP1XnO4vcA/mcR4Sk
   g5zy1l4a1yFCXdkNdzgyukxAf0J2k3coS6hv2/XJzzTV5IwpslXbFjAD6
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10237"; a="309530415"
X-IronPort-AV: E=Sophos;i="5.88,314,1635231600"; 
   d="scan'208";a="309530415"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 19:48:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,314,1635231600"; 
   d="scan'208";a="627754818"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 24 Jan 2022 19:48:21 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nCCoe-000JIq-Sr; Tue, 25 Jan 2022 03:48:20 +0000
Date:   Tue, 25 Jan 2022 11:48:17 +0800
From:   kernel test robot <lkp@intel.com>
To:     Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Tian Kevin <kevin.tian@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/cpuid: Exclude unpermitted xfeatures sizes at
 KVM_GET_SUPPORTED_CPUID
Message-ID: <202201251137.85eenHWr-lkp@intel.com>
References: <20220124080251.60558-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124080251.60558-1-likexu@tencent.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Like,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on kvm/queue]
[also build test ERROR on v5.17-rc1 next-20220124]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Like-Xu/KVM-x86-cpuid-Exclude-unpermitted-xfeatures-sizes-at-KVM_GET_SUPPORTED_CPUID/20220124-160452
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
config: i386-randconfig-a002 (https://download.01.org/0day-ci/archive/20220125/202201251137.85eenHWr-lkp@intel.com/config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project 2e58a18910867ba6795066e044293e6daf89edf5)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/b29c71ea177d9a2225208d501987598610261749
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Like-Xu/KVM-x86-cpuid-Exclude-unpermitted-xfeatures-sizes-at-KVM_GET_SUPPORTED_CPUID/20220124-160452
        git checkout b29c71ea177d9a2225208d501987598610261749
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> arch/x86/kvm/cpuid.c:890:24: error: variable 'supported_xcr0' is uninitialized when used within its own initialization [-Werror,-Wuninitialized]
                   u64 supported_xcr0 = supported_xcr0 & xstate_get_guest_group_perm();
                       ~~~~~~~~~~~~~~   ^~~~~~~~~~~~~~
   1 error generated.


vim +/supported_xcr0 +890 arch/x86/kvm/cpuid.c

   758	
   759	static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
   760	{
   761		struct kvm_cpuid_entry2 *entry;
   762		int r, i, max_idx;
   763	
   764		/* all calls to cpuid_count() should be made on the same cpu */
   765		get_cpu();
   766	
   767		r = -E2BIG;
   768	
   769		entry = do_host_cpuid(array, function, 0);
   770		if (!entry)
   771			goto out;
   772	
   773		switch (function) {
   774		case 0:
   775			/* Limited to the highest leaf implemented in KVM. */
   776			entry->eax = min(entry->eax, 0x1fU);
   777			break;
   778		case 1:
   779			cpuid_entry_override(entry, CPUID_1_EDX);
   780			cpuid_entry_override(entry, CPUID_1_ECX);
   781			break;
   782		case 2:
   783			/*
   784			 * On ancient CPUs, function 2 entries are STATEFUL.  That is,
   785			 * CPUID(function=2, index=0) may return different results each
   786			 * time, with the least-significant byte in EAX enumerating the
   787			 * number of times software should do CPUID(2, 0).
   788			 *
   789			 * Modern CPUs, i.e. every CPU KVM has *ever* run on are less
   790			 * idiotic.  Intel's SDM states that EAX & 0xff "will always
   791			 * return 01H. Software should ignore this value and not
   792			 * interpret it as an informational descriptor", while AMD's
   793			 * APM states that CPUID(2) is reserved.
   794			 *
   795			 * WARN if a frankenstein CPU that supports virtualization and
   796			 * a stateful CPUID.0x2 is encountered.
   797			 */
   798			WARN_ON_ONCE((entry->eax & 0xff) > 1);
   799			break;
   800		/* functions 4 and 0x8000001d have additional index. */
   801		case 4:
   802		case 0x8000001d:
   803			/*
   804			 * Read entries until the cache type in the previous entry is
   805			 * zero, i.e. indicates an invalid entry.
   806			 */
   807			for (i = 1; entry->eax & 0x1f; ++i) {
   808				entry = do_host_cpuid(array, function, i);
   809				if (!entry)
   810					goto out;
   811			}
   812			break;
   813		case 6: /* Thermal management */
   814			entry->eax = 0x4; /* allow ARAT */
   815			entry->ebx = 0;
   816			entry->ecx = 0;
   817			entry->edx = 0;
   818			break;
   819		/* function 7 has additional index. */
   820		case 7:
   821			entry->eax = min(entry->eax, 1u);
   822			cpuid_entry_override(entry, CPUID_7_0_EBX);
   823			cpuid_entry_override(entry, CPUID_7_ECX);
   824			cpuid_entry_override(entry, CPUID_7_EDX);
   825	
   826			/* KVM only supports 0x7.0 and 0x7.1, capped above via min(). */
   827			if (entry->eax == 1) {
   828				entry = do_host_cpuid(array, function, 1);
   829				if (!entry)
   830					goto out;
   831	
   832				cpuid_entry_override(entry, CPUID_7_1_EAX);
   833				entry->ebx = 0;
   834				entry->ecx = 0;
   835				entry->edx = 0;
   836			}
   837			break;
   838		case 9:
   839			break;
   840		case 0xa: { /* Architectural Performance Monitoring */
   841			struct x86_pmu_capability cap;
   842			union cpuid10_eax eax;
   843			union cpuid10_edx edx;
   844	
   845			perf_get_x86_pmu_capability(&cap);
   846	
   847			/*
   848			 * The guest architecture pmu is only supported if the architecture
   849			 * pmu exists on the host and the module parameters allow it.
   850			 */
   851			if (!cap.version || !enable_pmu)
   852				memset(&cap, 0, sizeof(cap));
   853	
   854			eax.split.version_id = min(cap.version, 2);
   855			eax.split.num_counters = cap.num_counters_gp;
   856			eax.split.bit_width = cap.bit_width_gp;
   857			eax.split.mask_length = cap.events_mask_len;
   858	
   859			edx.split.num_counters_fixed = min(cap.num_counters_fixed, MAX_FIXED_COUNTERS);
   860			edx.split.bit_width_fixed = cap.bit_width_fixed;
   861			if (cap.version)
   862				edx.split.anythread_deprecated = 1;
   863			edx.split.reserved1 = 0;
   864			edx.split.reserved2 = 0;
   865	
   866			entry->eax = eax.full;
   867			entry->ebx = cap.events_mask;
   868			entry->ecx = 0;
   869			entry->edx = edx.full;
   870			break;
   871		}
   872		/*
   873		 * Per Intel's SDM, the 0x1f is a superset of 0xb,
   874		 * thus they can be handled by common code.
   875		 */
   876		case 0x1f:
   877		case 0xb:
   878			/*
   879			 * Populate entries until the level type (ECX[15:8]) of the
   880			 * previous entry is zero.  Note, CPUID EAX.{0x1f,0xb}.0 is
   881			 * the starting entry, filled by the primary do_host_cpuid().
   882			 */
   883			for (i = 1; entry->ecx & 0xff00; ++i) {
   884				entry = do_host_cpuid(array, function, i);
   885				if (!entry)
   886					goto out;
   887			}
   888			break;
   889		case 0xd: {
 > 890			u64 supported_xcr0 = supported_xcr0 & xstate_get_guest_group_perm();
   891	
   892			entry->eax &= supported_xcr0;
   893			entry->ebx = xstate_required_size(supported_xcr0, false);
   894			entry->ecx = entry->ebx;
   895			entry->edx &= supported_xcr0 >> 32;
   896			if (!supported_xcr0)
   897				break;
   898	
   899			entry = do_host_cpuid(array, function, 1);
   900			if (!entry)
   901				goto out;
   902	
   903			cpuid_entry_override(entry, CPUID_D_1_EAX);
   904			if (entry->eax & (F(XSAVES)|F(XSAVEC)))
   905				entry->ebx = xstate_required_size(supported_xcr0 | supported_xss,
   906								  true);
   907			else {
   908				WARN_ON_ONCE(supported_xss != 0);
   909				entry->ebx = 0;
   910			}
   911			entry->ecx &= supported_xss;
   912			entry->edx &= supported_xss >> 32;
   913	
   914			for (i = 2; i < 64; ++i) {
   915				bool s_state;
   916				if (supported_xcr0 & BIT_ULL(i))
   917					s_state = false;
   918				else if (supported_xss & BIT_ULL(i))
   919					s_state = true;
   920				else
   921					continue;
   922	
   923				entry = do_host_cpuid(array, function, i);
   924				if (!entry)
   925					goto out;
   926	
   927				/*
   928				 * The supported check above should have filtered out
   929				 * invalid sub-leafs.  Only valid sub-leafs should
   930				 * reach this point, and they should have a non-zero
   931				 * save state size.  Furthermore, check whether the
   932				 * processor agrees with supported_xcr0/supported_xss
   933				 * on whether this is an XCR0- or IA32_XSS-managed area.
   934				 */
   935				if (WARN_ON_ONCE(!entry->eax || (entry->ecx & 0x1) != s_state)) {
   936					--array->nent;
   937					continue;
   938				}
   939	
   940				if (!kvm_cpu_cap_has(X86_FEATURE_XFD))
   941					entry->ecx &= ~BIT_ULL(2);
   942				entry->edx = 0;
   943			}
   944			break;
   945		}
   946		case 0x12:
   947			/* Intel SGX */
   948			if (!kvm_cpu_cap_has(X86_FEATURE_SGX)) {
   949				entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
   950				break;
   951			}
   952	
   953			/*
   954			 * Index 0: Sub-features, MISCSELECT (a.k.a extended features)
   955			 * and max enclave sizes.   The SGX sub-features and MISCSELECT
   956			 * are restricted by kernel and KVM capabilities (like most
   957			 * feature flags), while enclave size is unrestricted.
   958			 */
   959			cpuid_entry_override(entry, CPUID_12_EAX);
   960			entry->ebx &= SGX_MISC_EXINFO;
   961	
   962			entry = do_host_cpuid(array, function, 1);
   963			if (!entry)
   964				goto out;
   965	
   966			/*
   967			 * Index 1: SECS.ATTRIBUTES.  ATTRIBUTES are restricted a la
   968			 * feature flags.  Advertise all supported flags, including
   969			 * privileged attributes that require explicit opt-in from
   970			 * userspace.  ATTRIBUTES.XFRM is not adjusted as userspace is
   971			 * expected to derive it from supported XCR0.
   972			 */
   973			entry->eax &= SGX_ATTR_DEBUG | SGX_ATTR_MODE64BIT |
   974				      SGX_ATTR_PROVISIONKEY | SGX_ATTR_EINITTOKENKEY |
   975				      SGX_ATTR_KSS;
   976			entry->ebx &= 0;
   977			break;
   978		/* Intel PT */
   979		case 0x14:
   980			if (!kvm_cpu_cap_has(X86_FEATURE_INTEL_PT)) {
   981				entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
   982				break;
   983			}
   984	
   985			for (i = 1, max_idx = entry->eax; i <= max_idx; ++i) {
   986				if (!do_host_cpuid(array, function, i))
   987					goto out;
   988			}
   989			break;
   990		/* Intel AMX TILE */
   991		case 0x1d:
   992			if (!kvm_cpu_cap_has(X86_FEATURE_AMX_TILE)) {
   993				entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
   994				break;
   995			}
   996	
   997			for (i = 1, max_idx = entry->eax; i <= max_idx; ++i) {
   998				if (!do_host_cpuid(array, function, i))
   999					goto out;
  1000			}
  1001			break;
  1002		case 0x1e: /* TMUL information */
  1003			if (!kvm_cpu_cap_has(X86_FEATURE_AMX_TILE)) {
  1004				entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
  1005				break;
  1006			}
  1007			break;
  1008		case KVM_CPUID_SIGNATURE: {
  1009			const u32 *sigptr = (const u32 *)KVM_SIGNATURE;
  1010			entry->eax = KVM_CPUID_FEATURES;
  1011			entry->ebx = sigptr[0];
  1012			entry->ecx = sigptr[1];
  1013			entry->edx = sigptr[2];
  1014			break;
  1015		}
  1016		case KVM_CPUID_FEATURES:
  1017			entry->eax = (1 << KVM_FEATURE_CLOCKSOURCE) |
  1018				     (1 << KVM_FEATURE_NOP_IO_DELAY) |
  1019				     (1 << KVM_FEATURE_CLOCKSOURCE2) |
  1020				     (1 << KVM_FEATURE_ASYNC_PF) |
  1021				     (1 << KVM_FEATURE_PV_EOI) |
  1022				     (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT) |
  1023				     (1 << KVM_FEATURE_PV_UNHALT) |
  1024				     (1 << KVM_FEATURE_PV_TLB_FLUSH) |
  1025				     (1 << KVM_FEATURE_ASYNC_PF_VMEXIT) |
  1026				     (1 << KVM_FEATURE_PV_SEND_IPI) |
  1027				     (1 << KVM_FEATURE_POLL_CONTROL) |
  1028				     (1 << KVM_FEATURE_PV_SCHED_YIELD) |
  1029				     (1 << KVM_FEATURE_ASYNC_PF_INT);
  1030	
  1031			if (sched_info_on())
  1032				entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
  1033	
  1034			entry->ebx = 0;
  1035			entry->ecx = 0;
  1036			entry->edx = 0;
  1037			break;
  1038		case 0x80000000:
  1039			entry->eax = min(entry->eax, 0x8000001f);
  1040			break;
  1041		case 0x80000001:
  1042			cpuid_entry_override(entry, CPUID_8000_0001_EDX);
  1043			cpuid_entry_override(entry, CPUID_8000_0001_ECX);
  1044			break;
  1045		case 0x80000006:
  1046			/* L2 cache and TLB: pass through host info. */
  1047			break;
  1048		case 0x80000007: /* Advanced power management */
  1049			/* invariant TSC is CPUID.80000007H:EDX[8] */
  1050			entry->edx &= (1 << 8);
  1051			/* mask against host */
  1052			entry->edx &= boot_cpu_data.x86_power;
  1053			entry->eax = entry->ebx = entry->ecx = 0;
  1054			break;
  1055		case 0x80000008: {
  1056			unsigned g_phys_as = (entry->eax >> 16) & 0xff;
  1057			unsigned virt_as = max((entry->eax >> 8) & 0xff, 48U);
  1058			unsigned phys_as = entry->eax & 0xff;
  1059	
  1060			/*
  1061			 * If TDP (NPT) is disabled use the adjusted host MAXPHYADDR as
  1062			 * the guest operates in the same PA space as the host, i.e.
  1063			 * reductions in MAXPHYADDR for memory encryption affect shadow
  1064			 * paging, too.
  1065			 *
  1066			 * If TDP is enabled but an explicit guest MAXPHYADDR is not
  1067			 * provided, use the raw bare metal MAXPHYADDR as reductions to
  1068			 * the HPAs do not affect GPAs.
  1069			 */
  1070			if (!tdp_enabled)
  1071				g_phys_as = boot_cpu_data.x86_phys_bits;
  1072			else if (!g_phys_as)
  1073				g_phys_as = phys_as;
  1074	
  1075			entry->eax = g_phys_as | (virt_as << 8);
  1076			entry->edx = 0;
  1077			cpuid_entry_override(entry, CPUID_8000_0008_EBX);
  1078			break;
  1079		}
  1080		case 0x8000000A:
  1081			if (!kvm_cpu_cap_has(X86_FEATURE_SVM)) {
  1082				entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
  1083				break;
  1084			}
  1085			entry->eax = 1; /* SVM revision 1 */
  1086			entry->ebx = 8; /* Lets support 8 ASIDs in case we add proper
  1087					   ASID emulation to nested SVM */
  1088			entry->ecx = 0; /* Reserved */
  1089			cpuid_entry_override(entry, CPUID_8000_000A_EDX);
  1090			break;
  1091		case 0x80000019:
  1092			entry->ecx = entry->edx = 0;
  1093			break;
  1094		case 0x8000001a:
  1095		case 0x8000001e:
  1096			break;
  1097		case 0x8000001F:
  1098			if (!kvm_cpu_cap_has(X86_FEATURE_SEV)) {
  1099				entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
  1100			} else {
  1101				cpuid_entry_override(entry, CPUID_8000_001F_EAX);
  1102	
  1103				/*
  1104				 * Enumerate '0' for "PA bits reduction", the adjusted
  1105				 * MAXPHYADDR is enumerated directly (see 0x80000008).
  1106				 */
  1107				entry->ebx &= ~GENMASK(11, 6);
  1108			}
  1109			break;
  1110		/*Add support for Centaur's CPUID instruction*/
  1111		case 0xC0000000:
  1112			/*Just support up to 0xC0000004 now*/
  1113			entry->eax = min(entry->eax, 0xC0000004);
  1114			break;
  1115		case 0xC0000001:
  1116			cpuid_entry_override(entry, CPUID_C000_0001_EDX);
  1117			break;
  1118		case 3: /* Processor serial number */
  1119		case 5: /* MONITOR/MWAIT */
  1120		case 0xC0000002:
  1121		case 0xC0000003:
  1122		case 0xC0000004:
  1123		default:
  1124			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
  1125			break;
  1126		}
  1127	
  1128		r = 0;
  1129	
  1130	out:
  1131		put_cpu();
  1132	
  1133		return r;
  1134	}
  1135	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
