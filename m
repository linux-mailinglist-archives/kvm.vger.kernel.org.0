Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F967B28A5
	for <lists+kvm@lfdr.de>; Fri, 29 Sep 2023 01:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbjI1XIr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 19:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjI1XIq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 19:08:46 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D13CAC;
        Thu, 28 Sep 2023 16:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695942524; x=1727478524;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bsdaHx5i6d0dQbRebscdJjGlFmzP3UXXQapI7gY5p/8=;
  b=BZtgA3se+Ka89fvUu2cqJoGTzaF/DrIg3bIz4mCg0Zsk0POI6V/wHojH
   Q67L6+XX/C+MU+nz6uIi767z1rB6bmaT0hXUT6G5fL6zsNdTcu62Re1SS
   rNGBtsIsrt5fZ6+FAkjdjrf0Xwy0jmKwXEpN7V7lfXiPFuoAL7LJeFIJe
   4mFa5HBz0zgm8GMhEFBiVfUvEDCPvPOacUwjR9jstL/OZPOBSL0GRI4IY
   ZhNJSDYkz3dGmxSQRQItMZX06QO8HrS0TqiwxIqFwnJWtGCzkeD78Db4R
   Rs0tiCbtatYtOfbDZWKODHmgRisx9g5dNjlXreiIIf3cpMqcl+WkBqZIZ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10847"; a="446357861"
X-IronPort-AV: E=Sophos;i="6.03,185,1694761200"; 
   d="scan'208";a="446357861"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2023 16:08:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10847"; a="749776304"
X-IronPort-AV: E=Sophos;i="6.03,185,1694761200"; 
   d="scan'208";a="749776304"
Received: from lkp-server02.sh.intel.com (HELO c3b01524d57c) ([10.239.97.151])
  by orsmga002.jf.intel.com with ESMTP; 28 Sep 2023 16:08:39 -0700
Received: from kbuild by c3b01524d57c with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qm07Y-00027h-33;
        Thu, 28 Sep 2023 23:08:36 +0000
Date:   Fri, 29 Sep 2023 07:08:29 +0800
From:   kernel test robot <lkp@intel.com>
To:     Raghavendra Rao Ananta <rananta@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>
Cc:     oe-kbuild-all@lists.linux.dev,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v6 07/11] KVM: arm64: PMU: Allow userspace to limit
 PMCR_EL0.N for the guest
Message-ID: <202309290607.Qgg05wKw-lkp@intel.com>
References: <20230926234008.2348607-8-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230926234008.2348607-8-rananta@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Raghavendra,

kernel test robot noticed the following build errors:

[auto build test ERROR on 6465e260f48790807eef06b583b38ca9789b6072]

url:    https://github.com/intel-lab-lkp/linux/commits/Raghavendra-Rao-Ananta/KVM-arm64-PMU-Introduce-helpers-to-set-the-guest-s-PMU/20230927-095821
base:   6465e260f48790807eef06b583b38ca9789b6072
patch link:    https://lore.kernel.org/r/20230926234008.2348607-8-rananta%40google.com
patch subject: [PATCH v6 07/11] KVM: arm64: PMU: Allow userspace to limit PMCR_EL0.N for the guest
config: arm64-randconfig-003-20230928 (https://download.01.org/0day-ci/archive/20230929/202309290607.Qgg05wKw-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20230929/202309290607.Qgg05wKw-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202309290607.Qgg05wKw-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/arm64/kvm/sys_regs.c: In function 'set_pmcr':
>> arch/arm64/kvm/sys_regs.c:1110:52: error: invalid use of undefined type 'struct arm_pmu'
    1110 |                 u8 pmcr_n_limit = kvm->arch.arm_pmu->num_events - 1;
         |                                                    ^~
   arch/arm64/kvm/sys_regs.c: At top level:
   arch/arm64/kvm/sys_regs.c:2207:66: warning: initialized field overwritten [-Woverride-init]
    2207 |         { PMU_SYS_REG(PMCR_EL0), .access = access_pmcr, .reset = reset_pmcr,
         |                                                                  ^~~~~~~~~~
   arch/arm64/kvm/sys_regs.c:2207:66: note: (near initialization for 'sys_reg_descs[233].reset')
   In file included from include/uapi/linux/posix_types.h:5,
                    from include/uapi/linux/types.h:14,
                    from include/linux/types.h:6,
                    from include/linux/kasan-checks.h:5,
                    from include/asm-generic/rwonce.h:26,
                    from arch/arm64/include/asm/rwonce.h:71,
                    from include/linux/compiler.h:246,
                    from include/linux/build_bug.h:5,
                    from include/linux/bitfield.h:10,
                    from arch/arm64/kvm/sys_regs.c:12:
   include/linux/stddef.h:8:14: warning: initialized field overwritten [-Woverride-init]
       8 | #define NULL ((void *)0)
         |              ^
   arch/arm64/kvm/sys_regs.c:2221:46: note: in expansion of macro 'NULL'
    2221 |           .access = access_pmswinc, .reset = NULL },
         |                                              ^~~~
   include/linux/stddef.h:8:14: note: (near initialization for 'sys_reg_descs[237].reset')
       8 | #define NULL ((void *)0)
         |              ^
   arch/arm64/kvm/sys_regs.c:2221:46: note: in expansion of macro 'NULL'
    2221 |           .access = access_pmswinc, .reset = NULL },
         |                                              ^~~~
   arch/arm64/kvm/sys_regs.c:2223:45: warning: initialized field overwritten [-Woverride-init]
    2223 |           .access = access_pmselr, .reset = reset_pmselr, .reg = PMSELR_EL0 },
         |                                             ^~~~~~~~~~~~
   arch/arm64/kvm/sys_regs.c:2223:45: note: (near initialization for 'sys_reg_descs[238].reset')
   include/linux/stddef.h:8:14: warning: initialized field overwritten [-Woverride-init]
       8 | #define NULL ((void *)0)
         |              ^
   arch/arm64/kvm/sys_regs.c:2225:45: note: in expansion of macro 'NULL'
    2225 |           .access = access_pmceid, .reset = NULL },
         |                                             ^~~~
   include/linux/stddef.h:8:14: note: (near initialization for 'sys_reg_descs[239].reset')
       8 | #define NULL ((void *)0)
         |              ^
   arch/arm64/kvm/sys_regs.c:2225:45: note: in expansion of macro 'NULL'
    2225 |           .access = access_pmceid, .reset = NULL },
         |                                             ^~~~
   include/linux/stddef.h:8:14: warning: initialized field overwritten [-Woverride-init]
       8 | #define NULL ((void *)0)
         |              ^
   arch/arm64/kvm/sys_regs.c:2227:45: note: in expansion of macro 'NULL'
    2227 |           .access = access_pmceid, .reset = NULL },
         |                                             ^~~~
   include/linux/stddef.h:8:14: note: (near initialization for 'sys_reg_descs[240].reset')
       8 | #define NULL ((void *)0)
         |              ^
   arch/arm64/kvm/sys_regs.c:2227:45: note: in expansion of macro 'NULL'
    2227 |           .access = access_pmceid, .reset = NULL },
         |                                             ^~~~
   arch/arm64/kvm/sys_regs.c:2229:49: warning: initialized field overwritten [-Woverride-init]
    2229 |           .access = access_pmu_evcntr, .reset = reset_unknown,
         |                                                 ^~~~~~~~~~~~~
   arch/arm64/kvm/sys_regs.c:2229:49: note: (near initialization for 'sys_reg_descs[241].reset')
   include/linux/stddef.h:8:14: warning: initialized field overwritten [-Woverride-init]
       8 | #define NULL ((void *)0)
         |              ^
   arch/arm64/kvm/sys_regs.c:2232:50: note: in expansion of macro 'NULL'
    2232 |           .access = access_pmu_evtyper, .reset = NULL },
         |                                                  ^~~~
   include/linux/stddef.h:8:14: note: (near initialization for 'sys_reg_descs[242].reset')
       8 | #define NULL ((void *)0)
         |              ^
   arch/arm64/kvm/sys_regs.c:2232:50: note: in expansion of macro 'NULL'
    2232 |           .access = access_pmu_evtyper, .reset = NULL },
         |                                                  ^~~~
   include/linux/stddef.h:8:14: warning: initialized field overwritten [-Woverride-init]
       8 | #define NULL ((void *)0)
         |              ^
   arch/arm64/kvm/sys_regs.c:2234:49: note: in expansion of macro 'NULL'
    2234 |           .access = access_pmu_evcntr, .reset = NULL },
         |                                                 ^~~~
   include/linux/stddef.h:8:14: note: (near initialization for 'sys_reg_descs[243].reset')
       8 | #define NULL ((void *)0)
         |              ^
   arch/arm64/kvm/sys_regs.c:2234:49: note: in expansion of macro 'NULL'
    2234 |           .access = access_pmu_evcntr, .reset = NULL },
         |                                                 ^~~~
   arch/arm64/kvm/sys_regs.c:1162:20: warning: initialized field overwritten [-Woverride-init]
    1162 |           .reset = reset_pmevcntr, .get_user = get_pmu_evcntr,          \
         |                    ^~~~~~~~~~~~~~
   arch/arm64/kvm/sys_regs.c:2330:9: note: in expansion of macro 'PMU_PMEVCNTR_EL0'
    2330 |         PMU_PMEVCNTR_EL0(0),
         |         ^~~~~~~~~~~~~~~~
   arch/arm64/kvm/sys_regs.c:1162:20: note: (near initialization for 'sys_reg_descs[327].reset')
    1162 |           .reset = reset_pmevcntr, .get_user = get_pmu_evcntr,          \
         |                    ^~~~~~~~~~~~~~
   arch/arm64/kvm/sys_regs.c:2330:9: note: in expansion of macro 'PMU_PMEVCNTR_EL0'
    2330 |         PMU_PMEVCNTR_EL0(0),
         |         ^~~~~~~~~~~~~~~~
   arch/arm64/kvm/sys_regs.c:1162:20: warning: initialized field overwritten [-Woverride-init]
    1162 |           .reset = reset_pmevcntr, .get_user = get_pmu_evcntr,          \
         |                    ^~~~~~~~~~~~~~


vim +1110 arch/arm64/kvm/sys_regs.c

  1090	
  1091	static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
  1092			    u64 val)
  1093	{
  1094		struct kvm *kvm = vcpu->kvm;
  1095		u64 new_n, mutable_mask;
  1096	
  1097		mutex_lock(&kvm->arch.config_lock);
  1098	
  1099		/*
  1100		 * Make PMCR immutable once the VM has started running, but do
  1101		 * not return an error (-EBUSY) to meet the existing expectations.
  1102		 */
  1103		if (kvm_vm_has_ran_once(vcpu->kvm)) {
  1104			mutex_unlock(&kvm->arch.config_lock);
  1105			return 0;
  1106		}
  1107	
  1108		new_n = (val >> ARMV8_PMU_PMCR_N_SHIFT) & ARMV8_PMU_PMCR_N_MASK;
  1109		if (new_n != kvm->arch.pmcr_n) {
> 1110			u8 pmcr_n_limit = kvm->arch.arm_pmu->num_events - 1;
  1111	
  1112			/*
  1113			 * The vCPU can't have more counters than the PMU hardware
  1114			 * implements. Ignore this error to maintain compatibility
  1115			 * with the existing KVM behavior.
  1116			 */
  1117			if (new_n <= pmcr_n_limit)
  1118				kvm->arch.pmcr_n = new_n;
  1119		}
  1120		mutex_unlock(&kvm->arch.config_lock);
  1121	
  1122		/*
  1123		 * Ignore writes to RES0 bits, read only bits that are cleared on
  1124		 * vCPU reset, and writable bits that KVM doesn't support yet.
  1125		 * (i.e. only PMCR.N and bits [7:0] are mutable from userspace)
  1126		 * The LP bit is RES0 when FEAT_PMUv3p5 is not supported on the vCPU.
  1127		 * But, we leave the bit as it is here, as the vCPU's PMUver might
  1128		 * be changed later (NOTE: the bit will be cleared on first vCPU run
  1129		 * if necessary).
  1130		 */
  1131		mutable_mask = (ARMV8_PMU_PMCR_MASK |
  1132				(ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT));
  1133		val &= mutable_mask;
  1134		val |= (__vcpu_sys_reg(vcpu, r->reg) & ~mutable_mask);
  1135	
  1136		/* The LC bit is RES1 when AArch32 is not supported */
  1137		if (!kvm_supports_32bit_el0())
  1138			val |= ARMV8_PMU_PMCR_LC;
  1139	
  1140		__vcpu_sys_reg(vcpu, r->reg) = val;
  1141		return 0;
  1142	}
  1143	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
