Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BABF7135E6
	for <lists+kvm@lfdr.de>; Sat, 27 May 2023 19:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbjE0RgR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 May 2023 13:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjE0RgQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 May 2023 13:36:16 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D42D3
        for <kvm@vger.kernel.org>; Sat, 27 May 2023 10:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685208974; x=1716744974;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QULAGHRfPIcCGNhFsRmU3EDDOLgnaqBRBo8qhWPVE+E=;
  b=F3AeMaIqWS4mA17rDz/g9rPBfXH8aYwLUdn97rMdJb1x1oluX170zYpm
   rju3YFuGN1kA1+OtZfnAUcDg3WRsYpAGbwtqXl6j8j1QFP97FjsM++52B
   Bloj2X4AW1RSEkjLb1S5fEwjQ4afdrjQ6oH5Me9XQIiiYixDeenhwKT/A
   cD3g9ubNNSfwdLda15iPpbl/DgGsP+n2vjRCwXxtAQEweHeTJ++IZp8B/
   iBZAOwGSPPOM+umdhBLlSeLLfY1pNSc366fjHlAPxuEkU1LrRrxw2wfeK
   YBMjd1rnrMjB+Z0ROwjBLZuk5qRbJN1jpzORlUnTry4GosjPyeQw04VNw
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10723"; a="351928710"
X-IronPort-AV: E=Sophos;i="6.00,197,1681196400"; 
   d="scan'208";a="351928710"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2023 10:36:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10723"; a="849883924"
X-IronPort-AV: E=Sophos;i="6.00,197,1681196400"; 
   d="scan'208";a="849883924"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 27 May 2023 10:36:11 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1q2xpq-000K6c-1J;
        Sat, 27 May 2023 17:36:10 +0000
Date:   Sun, 28 May 2023 01:35:49 +0800
From:   kernel test robot <lkp@intel.com>
To:     Reiji Watanabe <reijiw@google.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc:     oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Will Deacon <will@kernel.org>,
        Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH 2/4] KVM: arm64: PMU: Set the default PMU for the guest
 on vCPU reset
Message-ID: <202305280138.CQFgYLdh-lkp@intel.com>
References: <20230527040236.1875860-3-reijiw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230527040236.1875860-3-reijiw@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reiji,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 44c026a73be8038f03dbdeef028b642880cf1511]

url:    https://github.com/intel-lab-lkp/linux/commits/Reiji-Watanabe/KVM-arm64-PMU-Introduce-a-helper-to-set-the-guest-s-PMU/20230527-120717
base:   44c026a73be8038f03dbdeef028b642880cf1511
patch link:    https://lore.kernel.org/r/20230527040236.1875860-3-reijiw%40google.com
patch subject: [PATCH 2/4] KVM: arm64: PMU: Set the default PMU for the guest on vCPU reset
config: arm64-randconfig-r006-20230526 (https://download.01.org/0day-ci/archive/20230528/202305280138.CQFgYLdh-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        mkdir -p ~/bin
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/6339e7261a0e27669f5e17362150b7f3f5681f4a
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Reiji-Watanabe/KVM-arm64-PMU-Introduce-a-helper-to-set-the-guest-s-PMU/20230527-120717
        git checkout 6339e7261a0e27669f5e17362150b7f3f5681f4a
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 ~/bin/make.cross W=1 O=build_dir ARCH=arm64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 ~/bin/make.cross W=1 O=build_dir ARCH=arm64 prepare

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202305280138.CQFgYLdh-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from arch/arm64/include/asm/kvm_host.h:37,
                    from include/linux/kvm_host.h:45,
                    from arch/arm64/kernel/asm-offsets.c:16:
>> include/kvm/arm_pmu.h:172:62: warning: 'struct arm_pmu' declared inside parameter list will not be visible outside of this definition or declaration
     172 | static inline int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
         |                                                              ^~~~~~~
--
   In file included from arch/arm64/include/asm/kvm_host.h:37,
                    from include/linux/kvm_host.h:45,
                    from arch/arm64/kernel/asm-offsets.c:16:
>> include/kvm/arm_pmu.h:172:62: warning: 'struct arm_pmu' declared inside parameter list will not be visible outside of this definition or declaration
     172 | static inline int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
         |                                                              ^~~~~~~


vim +172 include/kvm/arm_pmu.h

   171	
 > 172	static inline int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
   173	{
   174		return 0;
   175	}
   176	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
