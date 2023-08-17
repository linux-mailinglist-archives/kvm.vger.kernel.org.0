Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B76977F003
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 07:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347972AbjHQFEk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 01:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347904AbjHQFEZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 01:04:25 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D902684;
        Wed, 16 Aug 2023 22:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692248662; x=1723784662;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eGAo3CKDuFdSelabgpUj3MV0KM14lEa4HJoAlNa67+w=;
  b=gAY4QpzTtocywhJpcjQVNt465oSXTFddRJibJyf+9Yy7ZGelXrywOJGq
   6pZmyfYhzU1RnVGregAzKobKO8vjCIzjjdpDDs2/pm3fAUFMQ00A1ycQH
   D47SKtZQpj7pt+AQtUhL4nzSpGGP1Nu4ddkS0tXEZV8z5fUsCtOf1CgGu
   MlNeqJxKqWjurO4PUp9NjyHeJ1zjKS/N8FMripkcP0Ih05ySRtbnANExw
   p7oaOSMxxMIzNniLtQTe22MCS8QnP6zYph5t9X/4vzFwIAY72oVkNJF6W
   07YX9azm4WRTdnAHyCtO3G9JU8vLOywC5va8U4VIvD+IOQW4RBDue3JYi
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="372712797"
X-IronPort-AV: E=Sophos;i="6.01,179,1684825200"; 
   d="scan'208";a="372712797"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2023 22:04:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="763895792"
X-IronPort-AV: E=Sophos;i="6.01,179,1684825200"; 
   d="scan'208";a="763895792"
Received: from lkp-server02.sh.intel.com (HELO a9caf1a0cf30) ([10.239.97.151])
  by orsmga008.jf.intel.com with ESMTP; 16 Aug 2023 22:04:17 -0700
Received: from kbuild by a9caf1a0cf30 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qWVBB-0000o6-0C;
        Thu, 17 Aug 2023 05:04:17 +0000
Date:   Thu, 17 Aug 2023 13:03:28 +0800
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
Subject: Re: [PATCH v5 02/12] KVM: arm64: PMU: Set the default PMU for the
 guest on vCPU reset
Message-ID: <202308171212.KW8LnRRC-lkp@intel.com>
References: <20230817003029.3073210-3-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230817003029.3073210-3-rananta@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Raghavendra,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 2ccdd1b13c591d306f0401d98dedc4bdcd02b421]

url:    https://github.com/intel-lab-lkp/linux/commits/Raghavendra-Rao-Ananta/KVM-arm64-PMU-Introduce-a-helper-to-set-the-guest-s-PMU/20230817-083353
base:   2ccdd1b13c591d306f0401d98dedc4bdcd02b421
patch link:    https://lore.kernel.org/r/20230817003029.3073210-3-rananta%40google.com
patch subject: [PATCH v5 02/12] KVM: arm64: PMU: Set the default PMU for the guest on vCPU reset
config: arm64-randconfig-r032-20230817 (https://download.01.org/0day-ci/archive/20230817/202308171212.KW8LnRRC-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project.git 4a5ac14ee968ff0ad5d2cc1ffa0299048db4c88a)
reproduce: (https://download.01.org/0day-ci/archive/20230817/202308171212.KW8LnRRC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308171212.KW8LnRRC-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from arch/arm64/kernel/asm-offsets.c:16:
   In file included from include/linux/kvm_host.h:45:
   In file included from arch/arm64/include/asm/kvm_host.h:37:
>> include/kvm/arm_pmu.h:176:62: warning: declaration of 'struct arm_pmu' will not be visible outside of this function [-Wvisibility]
     176 | static inline int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
         |                                                              ^
   1 warning generated.
--
   In file included from arch/arm64/kernel/asm-offsets.c:16:
   In file included from include/linux/kvm_host.h:45:
   In file included from arch/arm64/include/asm/kvm_host.h:37:
>> include/kvm/arm_pmu.h:176:62: warning: declaration of 'struct arm_pmu' will not be visible outside of this function [-Wvisibility]
     176 | static inline int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
         |                                                              ^
   1 warning generated.


vim +176 include/kvm/arm_pmu.h

   175	
 > 176	static inline int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
   177	{
   178		return -ENODEV;
   179	}
   180	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
