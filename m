Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9D3E4AA241
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 22:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242369AbiBDVXy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 16:23:54 -0500
Received: from mga05.intel.com ([192.55.52.43]:11862 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234066AbiBDVXw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 16:23:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644009832; x=1675545832;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WhYPkBeKsla88L2pdt3CpVMQF4rx+1J8iSq8/P2VoZE=;
  b=mYa1jzDfTSwIPjnZItVkvwzOWRr2YvMi/xQhnYu5fuCfKbwgvinUaBhp
   oW8AS7uN0W3aTm208LpzwFaVIBe4dnCsQm6RokdaRGDrWpfKWpi6TkzHe
   /96XCWRjIUGn70kyutn2HQUY5dEKK5CESd0HGL3tfqqbskGzDRl4EcYz0
   OVypjhWu5lFSc4Bc6g0uxl4PPs7mtMmdIvgjQzg0n3FvWhX3NAwDQ0rT7
   ZFXclINPhkTnamKz3bYHanH9ymjLsrQHpzwRpdat2/mC+wAwLIdka4eU6
   eD2CcV9X7zOndEu60B2M2ONKC6J0UhVKTCCFVW8exRvuZZhkFzdw8lCfy
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10248"; a="334841202"
X-IronPort-AV: E=Sophos;i="5.88,343,1635231600"; 
   d="scan'208";a="334841202"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2022 13:23:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,343,1635231600"; 
   d="scan'208";a="600343769"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 04 Feb 2022 13:23:49 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nG63Z-000YCz-6e; Fri, 04 Feb 2022 21:23:49 +0000
Date:   Sat, 5 Feb 2022 05:22:47 +0800
From:   kernel test robot <lkp@intel.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     kbuild-all@lists.01.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, thuth@redhat.com, pasic@linux.ibm.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com
Subject: Re: [PATCH v7 10/17] KVM: s390: pv: add mmu_notifier
Message-ID: <202202050519.HMLLILGz-lkp@intel.com>
References: <20220204155349.63238-11-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204155349.63238-11-imbrenda@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Claudio,

I love your patch! Yet something to improve:

[auto build test ERROR on kvm/queue]
[also build test ERROR on v5.17-rc2 next-20220204]
[cannot apply to kvms390/next s390/features]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Claudio-Imbrenda/KVM-s390-pv-implement-lazy-destroy-for-reboot/20220204-235609
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
config: s390-randconfig-r044-20220203 (https://download.01.org/0day-ci/archive/20220205/202202050519.HMLLILGz-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/9ee65f25ad996d38f6935360c99a89e72024174b
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Claudio-Imbrenda/KVM-s390-pv-implement-lazy-destroy-for-reboot/20220204-235609
        git checkout 9ee65f25ad996d38f6935360c99a89e72024174b
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=s390 SHELL=/bin/bash arch/s390/kvm/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   arch/s390/kvm/pv.c: In function 'kvm_s390_pv_init_vm':
>> arch/s390/kvm/pv.c:255:17: error: implicit declaration of function 'mmu_notifier_register'; did you mean 'mmu_notifier_release'? [-Werror=implicit-function-declaration]
     255 |                 mmu_notifier_register(&kvm->arch.pv.mmu_notifier, kvm->mm);
         |                 ^~~~~~~~~~~~~~~~~~~~~
         |                 mmu_notifier_release
   cc1: some warnings being treated as errors


vim +255 arch/s390/kvm/pv.c

   210	
   211	int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
   212	{
   213		struct uv_cb_cgc uvcb = {
   214			.header.cmd = UVC_CMD_CREATE_SEC_CONF,
   215			.header.len = sizeof(uvcb)
   216		};
   217		int cc, ret;
   218		u16 dummy;
   219	
   220		ret = kvm_s390_pv_alloc_vm(kvm);
   221		if (ret)
   222			return ret;
   223	
   224		/* Inputs */
   225		uvcb.guest_stor_origin = 0; /* MSO is 0 for KVM */
   226		uvcb.guest_stor_len = kvm->arch.pv.guest_len;
   227		uvcb.guest_asce = kvm->arch.gmap->asce;
   228		uvcb.guest_sca = (unsigned long)kvm->arch.sca;
   229		uvcb.conf_base_stor_origin = (u64)kvm->arch.pv.stor_base;
   230		uvcb.conf_virt_stor_origin = (u64)kvm->arch.pv.stor_var;
   231	
   232		cc = uv_call_sched(0, (u64)&uvcb);
   233		*rc = uvcb.header.rc;
   234		*rrc = uvcb.header.rrc;
   235		KVM_UV_EVENT(kvm, 3, "PROTVIRT CREATE VM: handle %llx len %llx rc %x rrc %x",
   236			     uvcb.guest_handle, uvcb.guest_stor_len, *rc, *rrc);
   237	
   238		/* Outputs */
   239		kvm->arch.pv.handle = uvcb.guest_handle;
   240	
   241		atomic_inc(&kvm->mm->context.protected_count);
   242		if (cc) {
   243			if (uvcb.header.rc & UVC_RC_NEED_DESTROY) {
   244				kvm_s390_pv_deinit_vm(kvm, &dummy, &dummy);
   245			} else {
   246				atomic_dec(&kvm->mm->context.protected_count);
   247				kvm_s390_pv_dealloc_vm(kvm);
   248			}
   249			return -EIO;
   250		}
   251		kvm->arch.gmap->guest_handle = uvcb.guest_handle;
   252		/* Add the notifier only once. No races because we hold kvm->lock */
   253		if (kvm->arch.pv.mmu_notifier.ops != &kvm_s390_pv_mmu_notifier_ops) {
   254			kvm->arch.pv.mmu_notifier.ops = &kvm_s390_pv_mmu_notifier_ops;
 > 255			mmu_notifier_register(&kvm->arch.pv.mmu_notifier, kvm->mm);
   256		}
   257		return 0;
   258	}
   259	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
