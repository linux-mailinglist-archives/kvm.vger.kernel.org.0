Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0B126D69B5
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 19:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235408AbjDDRAp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 13:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235403AbjDDRAo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 13:00:44 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CB3D1
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 10:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680627641; x=1712163641;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5xKt3Mh+Sl3zFYCi02o8CwPXbzSSg3wM1CcnJxfZW4s=;
  b=lSHEXpl7Xh9k/fKXaeoXgAz7g1hYYiV5Ff3YDACnvDc1zcY47tHlDMG5
   k2dhCm6hjDG0iWXvJKelubu2IexPkWLLF2RgEXAv8olprzX3c1chAfR0L
   rQ8NiBN7QV+HhdNUcxIjDvrGZLVnpKBTN+/WicHo4+bRUD1ey3W4TMjBe
   kMgwVycttS4gkqvCwgt7HnOF+hPxPA3ZV7Rwxpidm5FhuIwYUy2+VjRRE
   wrs30N2sdQj5ulnfBlt1yuA8fSQSPw+YELkOWPviqc4FWzCsxgDNrwHZ2
   STdUxiB06KLT84aWVD3fRRrOp4knqn7wXJFerSamUoMDYRIDJMsf43VAF
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="343951133"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; 
   d="scan'208";a="343951133"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 10:00:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="750993725"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; 
   d="scan'208";a="750993725"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 04 Apr 2023 10:00:37 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pjk1M-000Pve-1d;
        Tue, 04 Apr 2023 17:00:36 +0000
Date:   Wed, 5 Apr 2023 00:59:46 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@google.com>
Cc:     oe-kbuild-all@lists.linux.dev, Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v6 4/6] KVM: arm64: Use per guest ID register for
 ID_AA64DFR0_EL1.PMUVer
Message-ID: <202304050006.49TmDWF6-lkp@intel.com>
References: <20230404035344.4043856-5-jingzhangos@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404035344.4043856-5-jingzhangos@google.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jing,

kernel test robot noticed the following build errors:

[auto build test ERROR on 7e364e56293bb98cae1b55fd835f5991c4e96e7d]

url:    https://github.com/intel-lab-lkp/linux/commits/Jing-Zhang/KVM-arm64-Move-CPU-ID-feature-registers-emulation-into-a-separate-file/20230404-115612
base:   7e364e56293bb98cae1b55fd835f5991c4e96e7d
patch link:    https://lore.kernel.org/r/20230404035344.4043856-5-jingzhangos%40google.com
patch subject: [PATCH v6 4/6] KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
config: arm64-allyesconfig (https://download.01.org/0day-ci/archive/20230405/202304050006.49TmDWF6-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/66ece3020c02ab1206bb9478e8cb0172e125bbfc
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jing-Zhang/KVM-arm64-Move-CPU-ID-feature-registers-emulation-into-a-separate-file/20230404-115612
        git checkout 66ece3020c02ab1206bb9478e8cb0172e125bbfc
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash arch/arm64/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304050006.49TmDWF6-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/rhashtable-types.h:14,
                    from include/linux/ipc.h:7,
                    from include/uapi/linux/sem.h:5,
                    from include/linux/sem.h:5,
                    from include/linux/sched.h:15,
                    from include/linux/hardirq.h:9,
                    from include/linux/kvm_host.h:7,
                    from arch/arm64/kvm/id_regs.c:13:
   arch/arm64/kvm/id_regs.c: In function 'set_id_aa64dfr0_el1':
>> arch/arm64/kvm/id_regs.c:261:44: error: 'struct kvm_arch' has no member named 'config_lock'
     261 |                 mutex_lock(&vcpu->kvm->arch.config_lock);
         |                                            ^
   include/linux/mutex.h:187:44: note: in definition of macro 'mutex_lock'
     187 | #define mutex_lock(lock) mutex_lock_nested(lock, 0)
         |                                            ^~~~
   arch/arm64/kvm/id_regs.c:269:46: error: 'struct kvm_arch' has no member named 'config_lock'
     269 |                 mutex_unlock(&vcpu->kvm->arch.config_lock);
         |                                              ^
   arch/arm64/kvm/id_regs.c: In function 'set_id_dfr0_el1':
   arch/arm64/kvm/id_regs.c:311:44: error: 'struct kvm_arch' has no member named 'config_lock'
     311 |                 mutex_lock(&vcpu->kvm->arch.config_lock);
         |                                            ^
   include/linux/mutex.h:187:44: note: in definition of macro 'mutex_lock'
     187 | #define mutex_lock(lock) mutex_lock_nested(lock, 0)
         |                                            ^~~~
   arch/arm64/kvm/id_regs.c:318:46: error: 'struct kvm_arch' has no member named 'config_lock'
     318 |                 mutex_unlock(&vcpu->kvm->arch.config_lock);
         |                                              ^


vim +261 arch/arm64/kvm/id_regs.c

   228	
   229	static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
   230				       const struct sys_reg_desc *rd,
   231				       u64 val)
   232	{
   233		u8 pmuver, host_pmuver;
   234		bool valid_pmu;
   235	
   236		host_pmuver = kvm_arm_pmu_get_pmuver_limit();
   237	
   238		/*
   239		 * Allow AA64DFR0_EL1.PMUver to be set from userspace as long
   240		 * as it doesn't promise more than what the HW gives us. We
   241		 * allow an IMPDEF PMU though, only if no PMU is supported
   242		 * (KVM backward compatibility handling).
   243		 */
   244		pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), val);
   245		if ((pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF && pmuver > host_pmuver))
   246			return -EINVAL;
   247	
   248		valid_pmu = (pmuver != 0 && pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF);
   249	
   250		/* Make sure view register and PMU support do match */
   251		if (kvm_vcpu_has_pmu(vcpu) != valid_pmu)
   252			return -EINVAL;
   253	
   254		/* We can only differ with PMUver, and anything else is an error */
   255		val ^= read_id_reg(vcpu, rd);
   256		val &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
   257		if (val)
   258			return -EINVAL;
   259	
   260		if (valid_pmu) {
 > 261			mutex_lock(&vcpu->kvm->arch.config_lock);
   262			IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
   263			IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |= FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK,
   264									    pmuver);
   265	
   266			IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &= ~ID_DFR0_EL1_PerfMon_MASK;
   267			IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |= FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK,
   268									pmuver_to_perfmon(pmuver));
   269			mutex_unlock(&vcpu->kvm->arch.config_lock);
   270		} else {
   271			assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags,
   272				   pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF);
   273		}
   274	
   275		return 0;
   276	}
   277	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
