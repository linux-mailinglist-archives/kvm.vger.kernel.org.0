Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 270D769C7EB
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 10:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231547AbjBTJsS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 04:48:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbjBTJsQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 04:48:16 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C59C672;
        Mon, 20 Feb 2023 01:48:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676886495; x=1708422495;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vQmDqxb9kEUGbhsZdbhEIPJY1DZxqbi/gUkFIWUe5qM=;
  b=DdMGO/6tMWnV2/9ZYkp53LmjSsSSZKcokkDk9xpVOFg39Au97uYHPwA3
   MLAqeVPyf8MkbUiM4Q4JieZIlfRDkm63AJ7626OvpJHqqY32I4da8lKsz
   89T2+Nqge7UHfcjnlFhlFrxHz4zdk3mhn0Vo3En2TwSoHSrBcteGERBoT
   J+J9WkWC5KjdOUPdw1emKlofr/uaZzG2l1UvBvtMfA/VOfDuR0PZf/wum
   mNSOX5nuG1V/ihohdaz0QPjg/PCNbY2RUYWxIhPhRUuJDJodpIBREAJqT
   dlfsFwAXbsDS2q4P9l9xsr7vxS9UmNlTO51LlIkrbmYVj1yNaW7G+VIbE
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10626"; a="334565112"
X-IronPort-AV: E=Sophos;i="5.97,312,1669104000"; 
   d="scan'208";a="334565112"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2023 01:48:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10626"; a="845276926"
X-IronPort-AV: E=Sophos;i="5.97,312,1669104000"; 
   d="scan'208";a="845276926"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 20 Feb 2023 01:48:10 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pU2mH-000Dpr-2w;
        Mon, 20 Feb 2023 09:48:09 +0000
Date:   Mon, 20 Feb 2023 17:47:33 +0800
From:   kernel test robot <lkp@intel.com>
To:     Tianrui Zhao <zhaotianrui@loongson.cn>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     oe-kbuild-all@lists.linux.dev, Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn
Subject: Re: [PATCH v2 29/29] LoongArch: KVM: Enable kvm config and add the
 makefile
Message-ID: <202302201710.ERtpPSuD-lkp@intel.com>
References: <20230220065735.1282809-30-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220065735.1282809-30-zhaotianrui@loongson.cn>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Tianrui,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v6.2]
[cannot apply to kvm/queue kvm/linux-next next-20230220]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Tianrui-Zhao/LoongArch-KVM-Add-kvm-related-header-files/20230220-151305
patch link:    https://lore.kernel.org/r/20230220065735.1282809-30-zhaotianrui%40loongson.cn
patch subject: [PATCH v2 29/29] LoongArch: KVM: Enable kvm config and add the makefile
config: loongarch-defconfig (https://download.01.org/0day-ci/archive/20230220/202302201710.ERtpPSuD-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/55ee4e26440ad32966cf3ee796b8a519c77ac66b
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Tianrui-Zhao/LoongArch-KVM-Add-kvm-related-header-files/20230220-151305
        git checkout 55ee4e26440ad32966cf3ee796b8a519c77ac66b
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=loongarch olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=loongarch SHELL=/bin/bash arch/loongarch/kvm/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302201710.ERtpPSuD-lkp@intel.com/

All warnings (new ones prefixed by >>):

   arch/loongarch/kvm/vcpu.c: In function 'kvm_own_fpu':
>> arch/loongarch/kvm/vcpu.c:595:23: warning: variable 'sr' set but not used [-Wunused-but-set-variable]
     595 |         unsigned long sr;
         |                       ^~
   arch/loongarch/kvm/vcpu.c: At top level:
>> arch/loongarch/kvm/vcpu.c:636:5: warning: no previous prototype for 'kvm_vcpu_ioctl_interrupt' [-Wmissing-prototypes]
     636 | int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
         |     ^~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/huge_mm.h:8,
                    from include/linux/mm.h:746,
                    from include/linux/kvm_host.h:16,
                    from arch/loongarch/kvm/vcpu.c:6:
   arch/loongarch/kvm/vcpu.c:126:25: warning: 'vcpu_pid_fops' defined but not used [-Wunused-const-variable=]
     126 | DEFINE_SIMPLE_ATTRIBUTE(vcpu_pid_fops, vcpu_pid_get, NULL, "%llu\n");
         |                         ^~~~~~~~~~~~~
   include/linux/fs.h:3496:37: note: in definition of macro 'DEFINE_SIMPLE_ATTRIBUTE_XSIGNED'
    3496 | static const struct file_operations __fops = {                          \
         |                                     ^~~~~~
   arch/loongarch/kvm/vcpu.c:126:1: note: in expansion of macro 'DEFINE_SIMPLE_ATTRIBUTE'
     126 | DEFINE_SIMPLE_ATTRIBUTE(vcpu_pid_fops, vcpu_pid_get, NULL, "%llu\n");
         | ^~~~~~~~~~~~~~~~~~~~~~~
   arch/loongarch/kvm/vcpu.c:116:25: warning: 'lvcpu_stat_fops' defined but not used [-Wunused-const-variable=]
     116 | DEFINE_SIMPLE_ATTRIBUTE(lvcpu_stat_fops, lvcpu_stat_get, NULL, "%llu\n");
         |                         ^~~~~~~~~~~~~~~
   include/linux/fs.h:3496:37: note: in definition of macro 'DEFINE_SIMPLE_ATTRIBUTE_XSIGNED'
    3496 | static const struct file_operations __fops = {                          \
         |                                     ^~~~~~
   arch/loongarch/kvm/vcpu.c:116:1: note: in expansion of macro 'DEFINE_SIMPLE_ATTRIBUTE'
     116 | DEFINE_SIMPLE_ATTRIBUTE(lvcpu_stat_fops, lvcpu_stat_get, NULL, "%llu\n");
         | ^~~~~~~~~~~~~~~~~~~~~~~


vim +/sr +595 arch/loongarch/kvm/vcpu.c

81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  591  
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  592  /* Enable FPU for guest and restore context */
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  593  void kvm_own_fpu(struct kvm_vcpu *vcpu)
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  594  {
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20 @595  	unsigned long sr;
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  596  
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  597  	preempt_disable();
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  598  
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  599  	sr = kvm_read_hw_gcsr(LOONGARCH_CSR_EUEN);
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  600  
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  601  	/*
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  602  	 * Enable FPU for guest
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  603  	 * We set FR and FRE according to guest context
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  604  	 */
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  605  	set_csr_euen(CSR_EUEN_FPEN);
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  606  
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  607  	/* If guest FPU state not active, restore it now */
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  608  	if (!(vcpu->arch.aux_inuse & KVM_LARCH_FPU)) {
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  609  		kvm_restore_fpu(&vcpu->arch.fpu);
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  610  		vcpu->arch.aux_inuse |= KVM_LARCH_FPU;
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  611  		trace_kvm_aux(vcpu, KVM_TRACE_AUX_RESTORE, KVM_TRACE_AUX_FPU);
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  612  	} else {
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  613  		trace_kvm_aux(vcpu, KVM_TRACE_AUX_ENABLE, KVM_TRACE_AUX_FPU);
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  614  	}
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  615  
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  616  	preempt_enable();
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  617  }
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  618  
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  619  /* Save and disable FPU */
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  620  void kvm_lose_fpu(struct kvm_vcpu *vcpu)
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  621  {
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  622  	preempt_disable();
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  623  
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  624  	if (vcpu->arch.aux_inuse & KVM_LARCH_FPU) {
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  625  		kvm_save_fpu(&vcpu->arch.fpu);
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  626  		vcpu->arch.aux_inuse &= ~KVM_LARCH_FPU;
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  627  		trace_kvm_aux(vcpu, KVM_TRACE_AUX_SAVE, KVM_TRACE_AUX_FPU);
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  628  
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  629  		/* Disable FPU */
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  630  		clear_csr_euen(CSR_EUEN_FPEN);
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  631  	}
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  632  
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  633  	preempt_enable();
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  634  }
81d0b9f4fa1f11 Tianrui Zhao 2023-02-20  635  
a4dadfc6695b38 Tianrui Zhao 2023-02-20 @636  int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
a4dadfc6695b38 Tianrui Zhao 2023-02-20  637  			     struct kvm_loongarch_interrupt *irq)
a4dadfc6695b38 Tianrui Zhao 2023-02-20  638  {
a4dadfc6695b38 Tianrui Zhao 2023-02-20  639  	int intr = (int)irq->irq;
a4dadfc6695b38 Tianrui Zhao 2023-02-20  640  	struct kvm_vcpu *dvcpu = NULL;
a4dadfc6695b38 Tianrui Zhao 2023-02-20  641  
a4dadfc6695b38 Tianrui Zhao 2023-02-20  642  	if (irq->cpu == -1)
a4dadfc6695b38 Tianrui Zhao 2023-02-20  643  		dvcpu = vcpu;
a4dadfc6695b38 Tianrui Zhao 2023-02-20  644  	else
a4dadfc6695b38 Tianrui Zhao 2023-02-20  645  		dvcpu = kvm_get_vcpu(vcpu->kvm, irq->cpu);
a4dadfc6695b38 Tianrui Zhao 2023-02-20  646  
a4dadfc6695b38 Tianrui Zhao 2023-02-20  647  	if (intr > 0)
a4dadfc6695b38 Tianrui Zhao 2023-02-20  648  		_kvm_queue_irq(dvcpu, intr);
a4dadfc6695b38 Tianrui Zhao 2023-02-20  649  	else if (intr < 0)
a4dadfc6695b38 Tianrui Zhao 2023-02-20  650  		_kvm_dequeue_irq(dvcpu, -intr);
a4dadfc6695b38 Tianrui Zhao 2023-02-20  651  	else {
a4dadfc6695b38 Tianrui Zhao 2023-02-20  652  		kvm_err("%s: invalid interrupt ioctl (%d:%d)\n", __func__,
a4dadfc6695b38 Tianrui Zhao 2023-02-20  653  				irq->cpu, irq->irq);
a4dadfc6695b38 Tianrui Zhao 2023-02-20  654  		return -EINVAL;
a4dadfc6695b38 Tianrui Zhao 2023-02-20  655  	}
a4dadfc6695b38 Tianrui Zhao 2023-02-20  656  
a4dadfc6695b38 Tianrui Zhao 2023-02-20  657  	kvm_vcpu_kick(dvcpu);
a4dadfc6695b38 Tianrui Zhao 2023-02-20  658  	return 0;
a4dadfc6695b38 Tianrui Zhao 2023-02-20  659  }
a4dadfc6695b38 Tianrui Zhao 2023-02-20  660  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
