Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9614C7D45B4
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 04:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbjJXCs4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 22:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232410AbjJXCsw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 22:48:52 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7CE10E7
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 19:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698115725; x=1729651725;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Vn/fjV4P+zc9B3QmfEgLuMtyggmZPzlv8T3CRouHy8c=;
  b=b2xrJmmIMT1kANld1djENWpgq3QeGHM/xERSuAPGCsbGCKAEEqELiSU4
   TvAGWqHieRF1QF6R8uGWVha1oZoBtwCmFaEK4bvQp0cGjUKVsSJCKV1Nj
   zdllYw4mcVWrqNcDr2AZyFWxtxlZplk8hV80gzfnsUwGI6mpi6nm1tmNS
   IcpPLMxrJuxzpu1BzG6AAV4zqc+52JACcoJW6ywtk7sUafJ5L7Vl3VDkf
   oo+onidJvUWnzf08OH8/CoDL3AtSZkpwBGNaZSLbLv9EYO7ZBRbNyeQHd
   fWm7u+6iLlr59Ntre2gAC1Na9YehVxFp7sQu7mZauYefA1dP/YbZ148cU
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="384172018"
X-IronPort-AV: E=Sophos;i="6.03,246,1694761200"; 
   d="scan'208";a="384172018"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2023 19:48:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,246,1694761200"; 
   d="scan'208";a="6020662"
Received: from lkp-server01.sh.intel.com (HELO 8917679a5d3e) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 23 Oct 2023 19:47:20 -0700
Received: from kbuild by 8917679a5d3e with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qv7T8-0007Uy-0h;
        Tue, 24 Oct 2023 02:48:34 +0000
Date:   Tue, 24 Oct 2023 10:47:58 +0800
From:   kernel test robot <lkp@intel.com>
To:     Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc:     oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v3 1/2] KVM: arm64: Make PMEVTYPER<n>_EL0.NSH RES0 if EL2
 isn't advertised
Message-ID: <202310241025.FmLnpSTG-lkp@intel.com>
References: <20231019185618.3442949-2-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231019185618.3442949-2-oliver.upton@linux.dev>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

kernel test robot noticed the following build errors:

[auto build test ERROR on 6465e260f48790807eef06b583b38ca9789b6072]

url:    https://github.com/intel-lab-lkp/linux/commits/Oliver-Upton/KVM-arm64-Make-PMEVTYPER-n-_EL0-NSH-RES0-if-EL2-isn-t-advertised/20231020-025836
base:   6465e260f48790807eef06b583b38ca9789b6072
patch link:    https://lore.kernel.org/r/20231019185618.3442949-2-oliver.upton%40linux.dev
patch subject: [PATCH v3 1/2] KVM: arm64: Make PMEVTYPER<n>_EL0.NSH RES0 if EL2 isn't advertised
config: arm64-randconfig-004-20231023 (https://download.01.org/0day-ci/archive/20231024/202310241025.FmLnpSTG-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231024/202310241025.FmLnpSTG-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202310241025.FmLnpSTG-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/arm64/kvm/sys_regs.c: In function 'reset_pmevtyper':
>> arch/arm64/kvm/sys_regs.c:754:41: error: too many arguments to function 'kvm_pmu_evtyper_mask'
     754 |         __vcpu_sys_reg(vcpu, r->reg) &= kvm_pmu_evtyper_mask(vcpu->kvm);
         |                                         ^~~~~~~~~~~~~~~~~~~~
   In file included from arch/arm64/include/asm/kvm_host.h:37,
                    from include/linux/kvm_host.h:45,
                    from arch/arm64/kvm/sys_regs.c:15:
   include/kvm/arm_pmu.h:176:19: note: declared here
     176 | static inline u64 kvm_pmu_evtyper_mask(void)
         |                   ^~~~~~~~~~~~~~~~~~~~
   arch/arm64/kvm/sys_regs.c: At top level:
   arch/arm64/kvm/sys_regs.c:2174:20: warning: initialized field overwritten [-Woverride-init]
    2174 |           .reset = reset_pmcr, .reg = PMCR_EL0 },
         |                    ^~~~~~~~~~
   arch/arm64/kvm/sys_regs.c:2174:20: note: (near initialization for 'sys_reg_descs[233].reset')
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
   arch/arm64/kvm/sys_regs.c:2187:46: note: in expansion of macro 'NULL'
    2187 |           .access = access_pmswinc, .reset = NULL },
         |                                              ^~~~
   include/linux/stddef.h:8:14: note: (near initialization for 'sys_reg_descs[237].reset')
       8 | #define NULL ((void *)0)
         |              ^
   arch/arm64/kvm/sys_regs.c:2187:46: note: in expansion of macro 'NULL'
    2187 |           .access = access_pmswinc, .reset = NULL },
         |                                              ^~~~
   arch/arm64/kvm/sys_regs.c:2189:45: warning: initialized field overwritten [-Woverride-init]
    2189 |           .access = access_pmselr, .reset = reset_pmselr, .reg = PMSELR_EL0 },
         |                                             ^~~~~~~~~~~~
   arch/arm64/kvm/sys_regs.c:2189:45: note: (near initialization for 'sys_reg_descs[238].reset')
   include/linux/stddef.h:8:14: warning: initialized field overwritten [-Woverride-init]
       8 | #define NULL ((void *)0)
         |              ^
   arch/arm64/kvm/sys_regs.c:2191:45: note: in expansion of macro 'NULL'
    2191 |           .access = access_pmceid, .reset = NULL },
         |                                             ^~~~
   include/linux/stddef.h:8:14: note: (near initialization for 'sys_reg_descs[239].reset')
       8 | #define NULL ((void *)0)
         |              ^
   arch/arm64/kvm/sys_regs.c:2191:45: note: in expansion of macro 'NULL'
    2191 |           .access = access_pmceid, .reset = NULL },
         |                                             ^~~~
   include/linux/stddef.h:8:14: warning: initialized field overwritten [-Woverride-init]
       8 | #define NULL ((void *)0)
         |              ^
   arch/arm64/kvm/sys_regs.c:2193:45: note: in expansion of macro 'NULL'
    2193 |           .access = access_pmceid, .reset = NULL },
         |                                             ^~~~
   include/linux/stddef.h:8:14: note: (near initialization for 'sys_reg_descs[240].reset')
       8 | #define NULL ((void *)0)
         |              ^
   arch/arm64/kvm/sys_regs.c:2193:45: note: in expansion of macro 'NULL'
    2193 |           .access = access_pmceid, .reset = NULL },
         |                                             ^~~~
   arch/arm64/kvm/sys_regs.c:2195:49: warning: initialized field overwritten [-Woverride-init]
    2195 |           .access = access_pmu_evcntr, .reset = reset_unknown,
         |                                                 ^~~~~~~~~~~~~
   arch/arm64/kvm/sys_regs.c:2195:49: note: (near initialization for 'sys_reg_descs[241].reset')
   include/linux/stddef.h:8:14: warning: initialized field overwritten [-Woverride-init]
       8 | #define NULL ((void *)0)
         |              ^
   arch/arm64/kvm/sys_regs.c:2198:50: note: in expansion of macro 'NULL'
    2198 |           .access = access_pmu_evtyper, .reset = NULL },
         |                                                  ^~~~
   include/linux/stddef.h:8:14: note: (near initialization for 'sys_reg_descs[242].reset')
       8 | #define NULL ((void *)0)
         |              ^
   arch/arm64/kvm/sys_regs.c:2198:50: note: in expansion of macro 'NULL'
    2198 |           .access = access_pmu_evtyper, .reset = NULL },
         |                                                  ^~~~
   include/linux/stddef.h:8:14: warning: initialized field overwritten [-Woverride-init]
       8 | #define NULL ((void *)0)
         |              ^
   arch/arm64/kvm/sys_regs.c:2200:49: note: in expansion of macro 'NULL'
    2200 |           .access = access_pmu_evcntr, .reset = NULL },
         |                                                 ^~~~
   include/linux/stddef.h:8:14: note: (near initialization for 'sys_reg_descs[243].reset')
       8 | #define NULL ((void *)0)
         |              ^
   arch/arm64/kvm/sys_regs.c:2200:49: note: in expansion of macro 'NULL'
    2200 |           .access = access_pmu_evcntr, .reset = NULL },
         |                                                 ^~~~
   arch/arm64/kvm/sys_regs.c:2206:20: warning: initialized field overwritten [-Woverride-init]
    2206 |           .reset = reset_val, .reg = PMUSERENR_EL0, .val = 0 },
         |                    ^~~~~~~~~
   arch/arm64/kvm/sys_regs.c:2206:20: note: (near initialization for 'sys_reg_descs[244].reset')
   arch/arm64/kvm/sys_regs.c:1128:20: warning: initialized field overwritten [-Woverride-init]
    1128 |           .reset = reset_pmevcntr, .get_user = get_pmu_evcntr,          \
         |                    ^~~~~~~~~~~~~~
   arch/arm64/kvm/sys_regs.c:2296:9: note: in expansion of macro 'PMU_PMEVCNTR_EL0'
    2296 |         PMU_PMEVCNTR_EL0(0),


vim +/kvm_pmu_evtyper_mask +754 arch/arm64/kvm/sys_regs.c

   746	
   747	static u64 reset_pmevtyper(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
   748	{
   749		/* This thing will UNDEF, who cares about the reset value? */
   750		if (!kvm_vcpu_has_pmu(vcpu))
   751			return 0;
   752	
   753		reset_unknown(vcpu, r);
 > 754		__vcpu_sys_reg(vcpu, r->reg) &= kvm_pmu_evtyper_mask(vcpu->kvm);
   755	
   756		return __vcpu_sys_reg(vcpu, r->reg);
   757	}
   758	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
