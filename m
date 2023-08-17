Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 518D077F18A
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 09:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348633AbjHQHy6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 03:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348638AbjHQHyq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 03:54:46 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48CEB10C0;
        Thu, 17 Aug 2023 00:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692258885; x=1723794885;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=R79VlJVX68ZrNvthc9VenRmouTu3zoPG+dVStn5+q6E=;
  b=Y0dvRoRViJymwPck6C3tsBQgv2NvSxCpcvbi3oy5a0lvtl7RWIUe/edx
   l++i2djiod9WDaEL4KI/UFnBrir652s0qdHE8vx6KcvpSaCYQdcwpwVCH
   RLb78Jl1TPtslFMT4dLn783i3f7u8GhQVyhiX5YT+2tFfpK2rkxxuUT5M
   yTVxE5n9Hx2+cC8x86Wa4/6fx9rCkAUC7ASQMe/0AoRy1Hz0h7bYmQLNR
   1dnOf1XIlMHkMSYx6zf7mmsqBwtyoqaQw+3TQUvg3OgPK/JvRKKM9Px7d
   4JLcwAm2GlcgdqYwtY+fzjvwLnh2sdpwQUHEB+AeZi5DUKWA4E171JUdn
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="372740413"
X-IronPort-AV: E=Sophos;i="6.01,179,1684825200"; 
   d="scan'208";a="372740413"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2023 00:54:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="848796705"
X-IronPort-AV: E=Sophos;i="6.01,179,1684825200"; 
   d="scan'208";a="848796705"
Received: from lkp-server02.sh.intel.com (HELO a9caf1a0cf30) ([10.239.97.151])
  by fmsmga002.fm.intel.com with ESMTP; 17 Aug 2023 00:54:39 -0700
Received: from kbuild by a9caf1a0cf30 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qWXq3-0000vJ-0X;
        Thu, 17 Aug 2023 07:54:39 +0000
Date:   Thu, 17 Aug 2023 15:54:35 +0800
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
Subject: Re: [PATCH v5 02/12] KVM: arm64: PMU: Set the default PMU for the
 guest on vCPU reset
Message-ID: <202308171559.K5QeXXZk-lkp@intel.com>
References: <20230817003029.3073210-3-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230817003029.3073210-3-rananta@google.com>
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

kernel test robot noticed the following build warnings:

[auto build test WARNING on 2ccdd1b13c591d306f0401d98dedc4bdcd02b421]

url:    https://github.com/intel-lab-lkp/linux/commits/Raghavendra-Rao-Ananta/KVM-arm64-PMU-Introduce-a-helper-to-set-the-guest-s-PMU/20230817-083353
base:   2ccdd1b13c591d306f0401d98dedc4bdcd02b421
patch link:    https://lore.kernel.org/r/20230817003029.3073210-3-rananta%40google.com
patch subject: [PATCH v5 02/12] KVM: arm64: PMU: Set the default PMU for the guest on vCPU reset
config: arm64-randconfig-r024-20230817 (https://download.01.org/0day-ci/archive/20230817/202308171559.K5QeXXZk-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 12.3.0
reproduce: (https://download.01.org/0day-ci/archive/20230817/202308171559.K5QeXXZk-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308171559.K5QeXXZk-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from arch/arm64/include/asm/kvm_host.h:37,
                    from include/linux/kvm_host.h:45,
                    from arch/arm64/kernel/asm-offsets.c:16:
>> include/kvm/arm_pmu.h:176:62: warning: 'struct arm_pmu' declared inside parameter list will not be visible outside of this definition or declaration
     176 | static inline int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
         |                                                              ^~~~~~~
--
   In file included from arch/arm64/include/asm/kvm_host.h:37,
                    from include/linux/kvm_host.h:45,
                    from arch/arm64/kernel/asm-offsets.c:16:
>> include/kvm/arm_pmu.h:176:62: warning: 'struct arm_pmu' declared inside parameter list will not be visible outside of this definition or declaration
     176 | static inline int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
         |                                                              ^~~~~~~


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
