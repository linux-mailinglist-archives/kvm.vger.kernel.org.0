Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 752B84D2425
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 23:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238847AbiCHWUl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 17:20:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232983AbiCHWUk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 17:20:40 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3F7725F0
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 14:19:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646777983; x=1678313983;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=Cp8zGGLTLUHm8iCY4AoXsdfeinLenignQ5FmKmCOhbE=;
  b=OmFmAlsHgTxD5DjeJ8YdhVnVyiOR1klvrK0pGuI3WJS3BgbmqycMESa5
   ByqPWoknMpMA1bTNtLgGq540BAZeWakiGeMgbUrBe5YyvPLWlDaWVey8d
   s7DDEs0orx4PZxrzvqfuHJRzdDDfraY09E0i/03NTs014wrNyr1NeGbUX
   YUlCCx1zXXDHd2SnUKKU9vh4VrMFpCCt0xwru2xxYhx0ae+AJgszqJu6T
   XWSXjZrg0ld0c6iDm4jZkazmnB6hazXokGT38Q8+CYncqXgOudXvpYjJI
   Qg/coGah1bDRbLaeIgieFslK9eGkcN0JRwI0IrM/CxHBSdSLAUIJUpk4o
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10280"; a="252400134"
X-IronPort-AV: E=Sophos;i="5.90,165,1643702400"; 
   d="scan'208";a="252400134"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2022 14:19:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,165,1643702400"; 
   d="scan'208";a="643816899"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by orsmga004.jf.intel.com with ESMTP; 08 Mar 2022 14:19:40 -0800
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nRiBA-00025r-61; Tue, 08 Mar 2022 22:19:40 +0000
Date:   Wed, 9 Mar 2022 06:18:53 +0800
From:   kernel test robot <lkp@intel.com>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wang GuangJu <wangguangju@baidu.com>
Subject: [kvm:queue 182/203] arch/x86/kernel/kvm.c:769:4: error: use of
 undeclared identifier '__raw_callee_save___kvm_vcpu_is_preempted'
Message-ID: <202203090613.qYNxBFkZ-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
head:   00a2bd3464280ca1f08e2cbfab22b884ffb731d8
commit: dc889a8974087aba3eb1cc6db2066fbbdb58922a [182/203] KVM: x86: Support the vCPU preemption check with nopvspin and realtime hint
config: x86_64-randconfig-a001 (https://download.01.org/0day-ci/archive/20220309/202203090613.qYNxBFkZ-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 0dc66b76fe4c33843755ade391b85ffda0742aeb)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=dc889a8974087aba3eb1cc6db2066fbbdb58922a
        git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
        git fetch --no-tags kvm queue
        git checkout dc889a8974087aba3eb1cc6db2066fbbdb58922a
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> arch/x86/kernel/kvm.c:769:4: error: use of undeclared identifier '__raw_callee_save___kvm_vcpu_is_preempted'
                           PV_CALLEE_SAVE(__kvm_vcpu_is_preempted);
                           ^
   arch/x86/include/asm/paravirt.h:683:35: note: expanded from macro 'PV_CALLEE_SAVE'
           ((struct paravirt_callee_save) { __raw_callee_save_##func })
                                            ^
   <scratch space>:52:1: note: expanded from here
   __raw_callee_save___kvm_vcpu_is_preempted
   ^
   1 error generated.


vim +/__raw_callee_save___kvm_vcpu_is_preempted +769 arch/x86/kernel/kvm.c

   754	
   755	static void __init kvm_guest_init(void)
   756	{
   757		int i;
   758	
   759		paravirt_ops_setup();
   760		register_reboot_notifier(&kvm_pv_reboot_nb);
   761		for (i = 0; i < KVM_TASK_SLEEP_HASHSIZE; i++)
   762			raw_spin_lock_init(&async_pf_sleepers[i].lock);
   763	
   764		if (kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
   765			has_steal_clock = 1;
   766			static_call_update(pv_steal_clock, kvm_steal_clock);
   767	
   768			pv_ops.lock.vcpu_is_preempted =
 > 769				PV_CALLEE_SAVE(__kvm_vcpu_is_preempted);
   770		}
   771	
   772		if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
   773			apic_set_eoi_write(kvm_guest_apic_eoi_write);
   774	
   775		if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_INT) && kvmapf) {
   776			static_branch_enable(&kvm_async_pf_enabled);
   777			alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR, asm_sysvec_kvm_asyncpf_interrupt);
   778		}
   779	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
