Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98B0C77F098
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 08:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348262AbjHQGjf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 02:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348256AbjHQGjS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 02:39:18 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545652701;
        Wed, 16 Aug 2023 23:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692254355; x=1723790355;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rFRRVEEucSSTXNeQi/3oBg68H2cCmE1GCVvNVuJOHew=;
  b=ZlBqf4fU3j6GjQL4bLQSugOWsvZH8zOxHEhFTPM73bAdcZmWsP937dxQ
   hjXXxI8hjcE9q8kjcrjZNiCLobZsNstIAybW19eNHw8k6UZDG59iTn2AB
   Brh8xoXKn8FQnY7Rr7yvVTD9oyTRHCYV6lhCGD2nsSjMB6gCN2ATqMe4F
   U+/7kWjphVNoAzKgO8mehg6qYCkfc0/eLn96FOUUGMWW2xRHMA0xZXKqp
   7q1F26DdeYpRNb3KnYyKMeAPUWbuUC74+UFsFgCNLH2ZPZFduW8EdvoXf
   7c2QA6RkCKWhh5nhtH4bgkFKwlo/J2Slfcdw/XO0CuVsD6rubonlBF3wK
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="372727111"
X-IronPort-AV: E=Sophos;i="6.01,179,1684825200"; 
   d="scan'208";a="372727111"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2023 23:39:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="1065135113"
X-IronPort-AV: E=Sophos;i="6.01,179,1684825200"; 
   d="scan'208";a="1065135113"
Received: from lkp-server02.sh.intel.com (HELO a9caf1a0cf30) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 16 Aug 2023 23:39:10 -0700
Received: from kbuild by a9caf1a0cf30 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qWWez-0000rX-0i;
        Thu, 17 Aug 2023 06:39:09 +0000
Date:   Thu, 17 Aug 2023 14:38:23 +0800
From:   kernel test robot <lkp@intel.com>
To:     Raghavendra Rao Ananta <rananta@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
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
Subject: Re: [PATCH v5 05/12] KVM: arm64: PMU: Simplify extracting PMCR_EL0.N
Message-ID: <202308171444.Q5rfJubF-lkp@intel.com>
References: <20230817003029.3073210-6-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230817003029.3073210-6-rananta@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Raghavendra,

kernel test robot noticed the following build errors:

[auto build test ERROR on 2ccdd1b13c591d306f0401d98dedc4bdcd02b421]

url:    https://github.com/intel-lab-lkp/linux/commits/Raghavendra-Rao-Ananta/KVM-arm64-PMU-Introduce-a-helper-to-set-the-guest-s-PMU/20230817-083353
base:   2ccdd1b13c591d306f0401d98dedc4bdcd02b421
patch link:    https://lore.kernel.org/r/20230817003029.3073210-6-rananta%40google.com
patch subject: [PATCH v5 05/12] KVM: arm64: PMU: Simplify extracting PMCR_EL0.N
config: arm-randconfig-r046-20230817 (https://download.01.org/0day-ci/archive/20230817/202308171444.Q5rfJubF-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project.git 4a5ac14ee968ff0ad5d2cc1ffa0299048db4c88a)
reproduce: (https://download.01.org/0day-ci/archive/20230817/202308171444.Q5rfJubF-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308171444.Q5rfJubF-lkp@intel.com/

All errors (new ones prefixed by >>):

         |                                                                 ^~~~~~
   drivers/perf/arm_pmuv3.c:141:2: note: previous initialization is here
     141 |         PERF_CACHE_MAP_ALL_UNSUPPORTED,
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmu.h:45:31: note: expanded from macro 'PERF_CACHE_MAP_ALL_UNSUPPORTED'
      45 |                 [0 ... C(RESULT_MAX) - 1] = CACHE_OP_UNSUPPORTED,       \
         |                                             ^~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmu.h:37:31: note: expanded from macro 'CACHE_OP_UNSUPPORTED'
      37 | #define CACHE_OP_UNSUPPORTED            0xFFFF
         |                                         ^~~~~~
   drivers/perf/arm_pmuv3.c:148:44: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
     148 |         [C(DTLB)][C(OP_READ)][C(RESULT_ACCESS)] = ARMV8_IMPDEF_PERFCTR_L1D_TLB_RD,
         |                                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmuv3.h:133:44: note: expanded from macro 'ARMV8_IMPDEF_PERFCTR_L1D_TLB_RD'
     133 | #define ARMV8_IMPDEF_PERFCTR_L1D_TLB_RD                         0x004E
         |                                                                 ^~~~~~
   drivers/perf/arm_pmuv3.c:141:2: note: previous initialization is here
     141 |         PERF_CACHE_MAP_ALL_UNSUPPORTED,
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmu.h:45:31: note: expanded from macro 'PERF_CACHE_MAP_ALL_UNSUPPORTED'
      45 |                 [0 ... C(RESULT_MAX) - 1] = CACHE_OP_UNSUPPORTED,       \
         |                                             ^~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmu.h:37:31: note: expanded from macro 'CACHE_OP_UNSUPPORTED'
      37 | #define CACHE_OP_UNSUPPORTED            0xFFFF
         |                                         ^~~~~~
   drivers/perf/arm_pmuv3.c:149:45: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
     149 |         [C(DTLB)][C(OP_WRITE)][C(RESULT_ACCESS)] = ARMV8_IMPDEF_PERFCTR_L1D_TLB_WR,
         |                                                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmuv3.h:134:44: note: expanded from macro 'ARMV8_IMPDEF_PERFCTR_L1D_TLB_WR'
     134 | #define ARMV8_IMPDEF_PERFCTR_L1D_TLB_WR                         0x004F
         |                                                                 ^~~~~~
   drivers/perf/arm_pmuv3.c:141:2: note: previous initialization is here
     141 |         PERF_CACHE_MAP_ALL_UNSUPPORTED,
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmu.h:45:31: note: expanded from macro 'PERF_CACHE_MAP_ALL_UNSUPPORTED'
      45 |                 [0 ... C(RESULT_MAX) - 1] = CACHE_OP_UNSUPPORTED,       \
         |                                             ^~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmu.h:37:31: note: expanded from macro 'CACHE_OP_UNSUPPORTED'
      37 | #define CACHE_OP_UNSUPPORTED            0xFFFF
         |                                         ^~~~~~
   drivers/perf/arm_pmuv3.c:150:42: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
     150 |         [C(DTLB)][C(OP_READ)][C(RESULT_MISS)]   = ARMV8_IMPDEF_PERFCTR_L1D_TLB_REFILL_RD,
         |                                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmuv3.h:131:50: note: expanded from macro 'ARMV8_IMPDEF_PERFCTR_L1D_TLB_REFILL_RD'
     131 | #define ARMV8_IMPDEF_PERFCTR_L1D_TLB_REFILL_RD                  0x004C
         |                                                                 ^~~~~~
   drivers/perf/arm_pmuv3.c:141:2: note: previous initialization is here
     141 |         PERF_CACHE_MAP_ALL_UNSUPPORTED,
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmu.h:45:31: note: expanded from macro 'PERF_CACHE_MAP_ALL_UNSUPPORTED'
      45 |                 [0 ... C(RESULT_MAX) - 1] = CACHE_OP_UNSUPPORTED,       \
         |                                             ^~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmu.h:37:31: note: expanded from macro 'CACHE_OP_UNSUPPORTED'
      37 | #define CACHE_OP_UNSUPPORTED            0xFFFF
         |                                         ^~~~~~
   drivers/perf/arm_pmuv3.c:151:43: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
     151 |         [C(DTLB)][C(OP_WRITE)][C(RESULT_MISS)]  = ARMV8_IMPDEF_PERFCTR_L1D_TLB_REFILL_WR,
         |                                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmuv3.h:132:50: note: expanded from macro 'ARMV8_IMPDEF_PERFCTR_L1D_TLB_REFILL_WR'
     132 | #define ARMV8_IMPDEF_PERFCTR_L1D_TLB_REFILL_WR                  0x004D
         |                                                                 ^~~~~~
   drivers/perf/arm_pmuv3.c:141:2: note: previous initialization is here
     141 |         PERF_CACHE_MAP_ALL_UNSUPPORTED,
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmu.h:45:31: note: expanded from macro 'PERF_CACHE_MAP_ALL_UNSUPPORTED'
      45 |                 [0 ... C(RESULT_MAX) - 1] = CACHE_OP_UNSUPPORTED,       \
         |                                             ^~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmu.h:37:31: note: expanded from macro 'CACHE_OP_UNSUPPORTED'
      37 | #define CACHE_OP_UNSUPPORTED            0xFFFF
         |                                         ^~~~~~
   drivers/perf/arm_pmuv3.c:153:44: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
     153 |         [C(NODE)][C(OP_READ)][C(RESULT_ACCESS)] = ARMV8_IMPDEF_PERFCTR_BUS_ACCESS_RD,
         |                                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmuv3.h:148:46: note: expanded from macro 'ARMV8_IMPDEF_PERFCTR_BUS_ACCESS_RD'
     148 | #define ARMV8_IMPDEF_PERFCTR_BUS_ACCESS_RD                      0x0060
         |                                                                 ^~~~~~
   drivers/perf/arm_pmuv3.c:141:2: note: previous initialization is here
     141 |         PERF_CACHE_MAP_ALL_UNSUPPORTED,
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmu.h:45:31: note: expanded from macro 'PERF_CACHE_MAP_ALL_UNSUPPORTED'
      45 |                 [0 ... C(RESULT_MAX) - 1] = CACHE_OP_UNSUPPORTED,       \
         |                                             ^~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmu.h:37:31: note: expanded from macro 'CACHE_OP_UNSUPPORTED'
      37 | #define CACHE_OP_UNSUPPORTED            0xFFFF
         |                                         ^~~~~~
   drivers/perf/arm_pmuv3.c:154:45: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
     154 |         [C(NODE)][C(OP_WRITE)][C(RESULT_ACCESS)] = ARMV8_IMPDEF_PERFCTR_BUS_ACCESS_WR,
         |                                                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmuv3.h:149:46: note: expanded from macro 'ARMV8_IMPDEF_PERFCTR_BUS_ACCESS_WR'
     149 | #define ARMV8_IMPDEF_PERFCTR_BUS_ACCESS_WR                      0x0061
         |                                                                 ^~~~~~
   drivers/perf/arm_pmuv3.c:141:2: note: previous initialization is here
     141 |         PERF_CACHE_MAP_ALL_UNSUPPORTED,
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmu.h:45:31: note: expanded from macro 'PERF_CACHE_MAP_ALL_UNSUPPORTED'
      45 |                 [0 ... C(RESULT_MAX) - 1] = CACHE_OP_UNSUPPORTED,       \
         |                                             ^~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmu.h:37:31: note: expanded from macro 'CACHE_OP_UNSUPPORTED'
      37 | #define CACHE_OP_UNSUPPORTED            0xFFFF
         |                                         ^~~~~~
>> drivers/perf/arm_pmuv3.c:1131:24: error: call to undeclared function 'FIELD_GET'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    1131 |         cpu_pmu->num_events = FIELD_GET(ARMV8_PMU_PMCR_N, armv8pmu_pmcr_read());
         |                               ^
   55 warnings and 1 error generated.


vim +/FIELD_GET +1131 drivers/perf/arm_pmuv3.c

  1114	
  1115	static void __armv8pmu_probe_pmu(void *info)
  1116	{
  1117		struct armv8pmu_probe_info *probe = info;
  1118		struct arm_pmu *cpu_pmu = probe->pmu;
  1119		u64 pmceid_raw[2];
  1120		u32 pmceid[2];
  1121		int pmuver;
  1122	
  1123		pmuver = read_pmuver();
  1124		if (!pmuv3_implemented(pmuver))
  1125			return;
  1126	
  1127		cpu_pmu->pmuver = pmuver;
  1128		probe->present = true;
  1129	
  1130		/* Read the nb of CNTx counters supported from PMNC */
> 1131		cpu_pmu->num_events = FIELD_GET(ARMV8_PMU_PMCR_N, armv8pmu_pmcr_read());
  1132	
  1133		/* Add the CPU cycles counter */
  1134		cpu_pmu->num_events += 1;
  1135	
  1136		pmceid[0] = pmceid_raw[0] = read_pmceid0();
  1137		pmceid[1] = pmceid_raw[1] = read_pmceid1();
  1138	
  1139		bitmap_from_arr32(cpu_pmu->pmceid_bitmap,
  1140				     pmceid, ARMV8_PMUV3_MAX_COMMON_EVENTS);
  1141	
  1142		pmceid[0] = pmceid_raw[0] >> 32;
  1143		pmceid[1] = pmceid_raw[1] >> 32;
  1144	
  1145		bitmap_from_arr32(cpu_pmu->pmceid_ext_bitmap,
  1146				     pmceid, ARMV8_PMUV3_MAX_COMMON_EVENTS);
  1147	
  1148		/* store PMMIR register for sysfs */
  1149		if (is_pmuv3p4(pmuver) && (pmceid_raw[1] & BIT(31)))
  1150			cpu_pmu->reg_pmmir = read_pmmir();
  1151		else
  1152			cpu_pmu->reg_pmmir = 0;
  1153	}
  1154	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
