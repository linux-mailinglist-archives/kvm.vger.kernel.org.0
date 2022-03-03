Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBCDF4CB55A
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 04:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231965AbiCCDNc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 22:13:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbiCCDNb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 22:13:31 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C32C5B;
        Wed,  2 Mar 2022 19:12:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646277166; x=1677813166;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SgeVA5g+s36SRkRxOQRJ2ZD4+6IxWoQsjjXwIO8y/pA=;
  b=HZp47U2Lf6qsgIU6srM1hyq0slgQM+H20+qGuPWEEgRRlPjvLQo/2q57
   97qD2OrRdd9lf9pGf/aTHfDqrd4oqEWbpvlLSy9Ssy1YAhrhT4/Na5LB+
   d1EUDynngX0MkNL4K21MOzipEIfd4wxNnM+EPuoOnejXqDsuAtvdxS9rW
   6PyUZlZ/fyF2PxW4Fxgif3oIWwWPI2uSBm1qOl0XaGnhCcwrie/xqRvDS
   XkF/QLqG3rhUxwVegy1tCGdJ9WS8DuHTuLPaecl/k9ZY5ZF7sT+R01aYc
   UTNYHP49evHuiOpS8GMu0bLwcVBbTJvfbRXIYEXyl8ur7jFkiCK5V8ay0
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="316782844"
X-IronPort-AV: E=Sophos;i="5.90,150,1643702400"; 
   d="scan'208";a="316782844"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 19:12:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,150,1643702400"; 
   d="scan'208";a="535641926"
Received: from lkp-server01.sh.intel.com (HELO ccb16ba0ecc3) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 02 Mar 2022 19:12:42 -0800
Received: from kbuild by ccb16ba0ecc3 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nPbtS-00004c-7j; Thu, 03 Mar 2022 03:12:42 +0000
Date:   Thu, 3 Mar 2022 11:12:22 +0800
From:   kernel test robot <lkp@intel.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     kbuild-all@lists.01.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, thuth@redhat.com, pasic@linux.ibm.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [PATCH v8 10/17] KVM: s390: pv: add mmu_notifier
Message-ID: <202203031051.SV8THyiU-lkp@intel.com>
References: <20220302181143.188283-11-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220302181143.188283-11-imbrenda@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Claudio,

I love your patch! Yet something to improve:

[auto build test ERROR on kvm/master]
[also build test ERROR on v5.17-rc6 next-20220302]
[cannot apply to kvms390/next s390/features]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Claudio-Imbrenda/KVM-s390-pv-implement-lazy-destroy-for-reboot/20220303-021407
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git master
config: s390-buildonly-randconfig-r006-20220302 (https://download.01.org/0day-ci/archive/20220303/202203031051.SV8THyiU-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/bbf278ea47b7bdfb3c72e24faffedbb8a3a5b9f9
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Claudio-Imbrenda/KVM-s390-pv-implement-lazy-destroy-for-reboot/20220303-021407
        git checkout bbf278ea47b7bdfb3c72e24faffedbb8a3a5b9f9
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=s390 SHELL=/bin/bash arch/s390/kvm/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   arch/s390/kvm/kvm-s390.c: In function 'kvm_arch_destroy_vm':
>> arch/s390/kvm/kvm-s390.c:2839:17: error: implicit declaration of function 'mmu_notifier_unregister'; did you mean 'preempt_notifier_unregister'? [-Werror=implicit-function-declaration]
    2839 |                 mmu_notifier_unregister(&kvm->arch.pv.mmu_notifier, kvm->mm);
         |                 ^~~~~~~~~~~~~~~~~~~~~~~
         |                 preempt_notifier_unregister
   cc1: some warnings being treated as errors
--
   arch/s390/kvm/pv.c: In function 'kvm_s390_pv_init_vm':
>> arch/s390/kvm/pv.c:260:17: error: implicit declaration of function 'mmu_notifier_register'; did you mean 'mmu_notifier_release'? [-Werror=implicit-function-declaration]
     260 |                 mmu_notifier_register(&kvm->arch.pv.mmu_notifier, kvm->mm);
         |                 ^~~~~~~~~~~~~~~~~~~~~
         |                 mmu_notifier_release
   cc1: some warnings being treated as errors


vim +2839 arch/s390/kvm/kvm-s390.c

  2823	
  2824	void kvm_arch_destroy_vm(struct kvm *kvm)
  2825	{
  2826		u16 rc, rrc;
  2827	
  2828		kvm_destroy_vcpus(kvm);
  2829		sca_dispose(kvm);
  2830		kvm_s390_gisa_destroy(kvm);
  2831		/*
  2832		 * We are already at the end of life and kvm->lock is not taken.
  2833		 * This is ok as the file descriptor is closed by now and nobody
  2834		 * can mess with the pv state. To avoid lockdep_assert_held from
  2835		 * complaining we do not use kvm_s390_pv_is_protected.
  2836		 */
  2837		if (kvm_s390_pv_get_handle(kvm)) {
  2838			kvm_s390_pv_deinit_vm(kvm, &rc, &rrc);
> 2839			mmu_notifier_unregister(&kvm->arch.pv.mmu_notifier, kvm->mm);
  2840		}
  2841		debug_unregister(kvm->arch.dbf);
  2842		free_page((unsigned long)kvm->arch.sie_page2);
  2843		if (!kvm_is_ucontrol(kvm))
  2844			gmap_remove(kvm->arch.gmap);
  2845		kvm_s390_destroy_adapters(kvm);
  2846		kvm_s390_clear_float_irqs(kvm);
  2847		kvm_s390_vsie_destroy(kvm);
  2848		KVM_EVENT(3, "vm 0x%pK destroyed", kvm);
  2849	}
  2850	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
