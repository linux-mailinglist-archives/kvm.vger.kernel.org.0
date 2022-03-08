Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE81C4D244A
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 23:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350739AbiCHWaq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 17:30:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350488AbiCHWam (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 17:30:42 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1585758E7D
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 14:29:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646778583; x=1678314583;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=MsZS/snTdXJtUsxglht7BmeMVVrRncz9zab3wOMFjpw=;
  b=l189JKXGQc+BTRUzCqRJpgcpATVUrzGzo6IPfVZHASlYBsg8fxCNuXdM
   mI0LWTNAklFBRLuFvCaWZ1H3aduP7T8DqOcM1OBjiCdfA8HWFt5YrbLTn
   wdncsFaWZrMTNXJSy7ormh+70+rUSyFF/VOvwGZLKgAlNCEAoBT4K+d/m
   CZ7JKMmjBdpPwthFTeHpqOvO/8PPNHhr9jM5kUdpdYvReCDuQmz63Y1Qf
   4QM4kREchLN8NjsDMumuIkTWG2/OBQ4ZL2R635e9R8gvbnNB0S8MXSuFn
   3yGZscQ2k3AXR3wE/jc5n9h/ZD7Rh3Vqx9o00cEn2N1jlgbokQkEepwuE
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10280"; a="234783016"
X-IronPort-AV: E=Sophos;i="5.90,165,1643702400"; 
   d="scan'208";a="234783016"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2022 14:29:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,165,1643702400"; 
   d="scan'208";a="688085532"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by fmsmga001.fm.intel.com with ESMTP; 08 Mar 2022 14:29:41 -0800
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nRiKq-00026R-BB; Tue, 08 Mar 2022 22:29:40 +0000
Date:   Wed, 9 Mar 2022 06:29:11 +0800
From:   kernel test robot <lkp@intel.com>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wang GuangJu <wangguangju@baidu.com>
Subject: [kvm:queue 182/203] arch/x86/include/asm/paravirt.h:683:35: error:
 '__raw_callee_save___kvm_vcpu_is_preempted' undeclared
Message-ID: <202203090607.5kEhVF3N-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HEXHASH_WORD,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
head:   00a2bd3464280ca1f08e2cbfab22b884ffb731d8
commit: dc889a8974087aba3eb1cc6db2066fbbdb58922a [182/203] KVM: x86: Support the vCPU preemption check with nopvspin and realtime hint
config: i386-randconfig-a003 (https://download.01.org/0day-ci/archive/20220309/202203090607.5kEhVF3N-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=dc889a8974087aba3eb1cc6db2066fbbdb58922a
        git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
        git fetch --no-tags kvm queue
        git checkout dc889a8974087aba3eb1cc6db2066fbbdb58922a
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from arch/x86/include/asm/spinlock.h:10,
                    from include/linux/spinlock.h:93,
                    from include/linux/wait.h:9,
                    from include/linux/pid.h:6,
                    from include/linux/sched.h:14,
                    from include/linux/context_tracking.h:5,
                    from arch/x86/kernel/kvm.c:12:
   arch/x86/kernel/kvm.c: In function 'kvm_guest_init':
>> arch/x86/include/asm/paravirt.h:683:35: error: '__raw_callee_save___kvm_vcpu_is_preempted' undeclared (first use in this function)
     683 |  ((struct paravirt_callee_save) { __raw_callee_save_##func })
         |                                   ^~~~~~~~~~~~~~~~~~
   arch/x86/kernel/kvm.c:769:4: note: in expansion of macro 'PV_CALLEE_SAVE'
     769 |    PV_CALLEE_SAVE(__kvm_vcpu_is_preempted);
         |    ^~~~~~~~~~~~~~
   arch/x86/include/asm/paravirt.h:683:35: note: each undeclared identifier is reported only once for each function it appears in
     683 |  ((struct paravirt_callee_save) { __raw_callee_save_##func })
         |                                   ^~~~~~~~~~~~~~~~~~
   arch/x86/kernel/kvm.c:769:4: note: in expansion of macro 'PV_CALLEE_SAVE'
     769 |    PV_CALLEE_SAVE(__kvm_vcpu_is_preempted);
         |    ^~~~~~~~~~~~~~


vim +/__raw_callee_save___kvm_vcpu_is_preempted +683 arch/x86/include/asm/paravirt.h

2e47d3e6c35bb5 include/asm-x86/paravirt.h      Glauber de Oliveira Costa 2008-01-30  648  
ecb93d1ccd0aac arch/x86/include/asm/paravirt.h Jeremy Fitzhardinge       2009-01-28  649  /*
ecb93d1ccd0aac arch/x86/include/asm/paravirt.h Jeremy Fitzhardinge       2009-01-28  650   * Generate a thunk around a function which saves all caller-save
ecb93d1ccd0aac arch/x86/include/asm/paravirt.h Jeremy Fitzhardinge       2009-01-28  651   * registers except for the return value.  This allows C functions to
ecb93d1ccd0aac arch/x86/include/asm/paravirt.h Jeremy Fitzhardinge       2009-01-28  652   * be called from assembler code where fewer than normal registers are
ecb93d1ccd0aac arch/x86/include/asm/paravirt.h Jeremy Fitzhardinge       2009-01-28  653   * available.  It may also help code generation around calls from C
ecb93d1ccd0aac arch/x86/include/asm/paravirt.h Jeremy Fitzhardinge       2009-01-28  654   * code if the common case doesn't use many registers.
ecb93d1ccd0aac arch/x86/include/asm/paravirt.h Jeremy Fitzhardinge       2009-01-28  655   *
ecb93d1ccd0aac arch/x86/include/asm/paravirt.h Jeremy Fitzhardinge       2009-01-28  656   * When a callee is wrapped in a thunk, the caller can assume that all
ecb93d1ccd0aac arch/x86/include/asm/paravirt.h Jeremy Fitzhardinge       2009-01-28  657   * arg regs and all scratch registers are preserved across the
ecb93d1ccd0aac arch/x86/include/asm/paravirt.h Jeremy Fitzhardinge       2009-01-28  658   * call. The return value in rax/eax will not be saved, even for void
ecb93d1ccd0aac arch/x86/include/asm/paravirt.h Jeremy Fitzhardinge       2009-01-28  659   * functions.
ecb93d1ccd0aac arch/x86/include/asm/paravirt.h Jeremy Fitzhardinge       2009-01-28  660   */
87b240cbe3e51b arch/x86/include/asm/paravirt.h Josh Poimboeuf            2016-01-21  661  #define PV_THUNK_NAME(func) "__raw_callee_save_" #func
20125c872a3f12 arch/x86/include/asm/paravirt.h Peter Zijlstra            2021-06-24  662  #define __PV_CALLEE_SAVE_REGS_THUNK(func, section)			\
ecb93d1ccd0aac arch/x86/include/asm/paravirt.h Jeremy Fitzhardinge       2009-01-28  663  	extern typeof(func) __raw_callee_save_##func;			\
ecb93d1ccd0aac arch/x86/include/asm/paravirt.h Jeremy Fitzhardinge       2009-01-28  664  									\
20125c872a3f12 arch/x86/include/asm/paravirt.h Peter Zijlstra            2021-06-24  665  	asm(".pushsection " section ", \"ax\";"				\
87b240cbe3e51b arch/x86/include/asm/paravirt.h Josh Poimboeuf            2016-01-21  666  	    ".globl " PV_THUNK_NAME(func) ";"				\
87b240cbe3e51b arch/x86/include/asm/paravirt.h Josh Poimboeuf            2016-01-21  667  	    ".type " PV_THUNK_NAME(func) ", @function;"			\
87b240cbe3e51b arch/x86/include/asm/paravirt.h Josh Poimboeuf            2016-01-21  668  	    PV_THUNK_NAME(func) ":"					\
87b240cbe3e51b arch/x86/include/asm/paravirt.h Josh Poimboeuf            2016-01-21  669  	    FRAME_BEGIN							\
ecb93d1ccd0aac arch/x86/include/asm/paravirt.h Jeremy Fitzhardinge       2009-01-28  670  	    PV_SAVE_ALL_CALLER_REGS					\
ecb93d1ccd0aac arch/x86/include/asm/paravirt.h Jeremy Fitzhardinge       2009-01-28  671  	    "call " #func ";"						\
ecb93d1ccd0aac arch/x86/include/asm/paravirt.h Jeremy Fitzhardinge       2009-01-28  672  	    PV_RESTORE_ALL_CALLER_REGS					\
87b240cbe3e51b arch/x86/include/asm/paravirt.h Josh Poimboeuf            2016-01-21  673  	    FRAME_END							\
b17c2baa305ccc arch/x86/include/asm/paravirt.h Peter Zijlstra            2021-12-04  674  	    ASM_RET							\
083db676482199 arch/x86/include/asm/paravirt.h Josh Poimboeuf            2019-07-17  675  	    ".size " PV_THUNK_NAME(func) ", .-" PV_THUNK_NAME(func) ";"	\
ecb93d1ccd0aac arch/x86/include/asm/paravirt.h Jeremy Fitzhardinge       2009-01-28  676  	    ".popsection")
ecb93d1ccd0aac arch/x86/include/asm/paravirt.h Jeremy Fitzhardinge       2009-01-28  677  
20125c872a3f12 arch/x86/include/asm/paravirt.h Peter Zijlstra            2021-06-24  678  #define PV_CALLEE_SAVE_REGS_THUNK(func)			\
20125c872a3f12 arch/x86/include/asm/paravirt.h Peter Zijlstra            2021-06-24  679  	__PV_CALLEE_SAVE_REGS_THUNK(func, ".text")
20125c872a3f12 arch/x86/include/asm/paravirt.h Peter Zijlstra            2021-06-24  680  
ecb93d1ccd0aac arch/x86/include/asm/paravirt.h Jeremy Fitzhardinge       2009-01-28  681  /* Get a reference to a callee-save function */
ecb93d1ccd0aac arch/x86/include/asm/paravirt.h Jeremy Fitzhardinge       2009-01-28  682  #define PV_CALLEE_SAVE(func)						\
ecb93d1ccd0aac arch/x86/include/asm/paravirt.h Jeremy Fitzhardinge       2009-01-28 @683  	((struct paravirt_callee_save) { __raw_callee_save_##func })
ecb93d1ccd0aac arch/x86/include/asm/paravirt.h Jeremy Fitzhardinge       2009-01-28  684  

:::::: The code at line 683 was first introduced by commit
:::::: ecb93d1ccd0aac63f03be2db3cac3fa974716f4c x86/paravirt: add register-saving thunks to reduce caller register pressure

:::::: TO: Jeremy Fitzhardinge <jeremy@goop.org>
:::::: CC: H. Peter Anvin <hpa@linux.intel.com>

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
