Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E76585030FB
	for <lists+kvm@lfdr.de>; Sat, 16 Apr 2022 01:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245668AbiDOW4Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 18:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbiDOW4O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 18:56:14 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461AD443F8
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 15:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650063225; x=1681599225;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=W9gfzpqXHjMO207De/Tr0o7ydsrZvK9ohYQYzlsbiyk=;
  b=TUwEDmtuHxAIHidtsUqNw5OlZ29webuX6WWPBXpSbHIAciLlK1lMx5HU
   nZH9CymB0+q2uCp1qndtCKt9GKYnCzr5EKSRjqNhqj6IONpN2qu3M111q
   vOk0gYSqYkirhMOFq4XjoLnjR/FrzEsyxnyY0uM77tnKxoPqRKLHMisdm
   4JGizQkkwAGR2s7bTfSZgUhmVlsOm+qJ/PVmafHLayM5NwPgbOAz317of
   iXHwG4LjDDGfTIOMADzwFtpVavGjFiJwfeEY4lD4TQNRrnjwqXo0yJOSq
   o+KQlby+vpjEouIdi+LZGCb5IjBqex08ZTCKnUmoiQ9QIVegWsX0akZb7
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10318"; a="326145828"
X-IronPort-AV: E=Sophos;i="5.90,264,1643702400"; 
   d="scan'208";a="326145828"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2022 15:53:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,264,1643702400"; 
   d="scan'208";a="646207879"
Received: from lkp-server01.sh.intel.com (HELO 3abc53900bec) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Apr 2022 15:53:37 -0700
Received: from kbuild by 3abc53900bec with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nfUor-0002VK-2i;
        Fri, 15 Apr 2022 22:53:37 +0000
Date:   Sat, 16 Apr 2022 06:52:45 +0800
From:   kernel test robot <lkp@intel.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm:kvm-tdx-5.17 23/141] arch/x86/kernel/process.c:785:42: error:
 implicit declaration of function 'platform_has_tdx'
Message-ID: <202204160600.8e4g9QZR-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-tdx-5.17
head:   a50e4531e92e36f185ea32843c149c4703451109
commit: bf2274dac8e8671ae89971ae8c89f4f2f8f13095 [23/141] x86: Flush cache of TDX private memory during kexec()
config: x86_64-randconfig-a016 (https://download.01.org/0day-ci/archive/20220416/202204160600.8e4g9QZR-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 8e43cbab33765c476337571e5ed11b005199dd0d)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=bf2274dac8e8671ae89971ae8c89f4f2f8f13095
        git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
        git fetch --no-tags kvm kvm-tdx-5.17
        git checkout bf2274dac8e8671ae89971ae8c89f4f2f8f13095
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> arch/x86/kernel/process.c:785:42: error: implicit declaration of function 'platform_has_tdx' [-Werror,-Wimplicit-function-declaration]
           if ((cpuid_eax(0x8000001f) & BIT(0)) || platform_has_tdx())
                                                   ^
   1 error generated.


vim +/platform_has_tdx +785 arch/x86/kernel/process.c

   749	
   750	void stop_this_cpu(void *dummy)
   751	{
   752		local_irq_disable();
   753		/*
   754		 * Remove this CPU:
   755		 */
   756		set_cpu_online(smp_processor_id(), false);
   757		disable_local_APIC();
   758		mcheck_cpu_clear(this_cpu_ptr(&cpu_info));
   759	
   760		/*
   761		 * Use wbinvd on processors that support SME. This provides support
   762		 * for performing a successful kexec when going from SME inactive
   763		 * to SME active (or vice-versa). The cache must be cleared so that
   764		 * if there are entries with the same physical address, both with and
   765		 * without the encryption bit, they don't race each other when flushed
   766		 * and potentially end up with the wrong entry being committed to
   767		 * memory.
   768		 *
   769		 * Test the CPUID bit directly because the machine might've cleared
   770		 * X86_FEATURE_SME due to cmdline options.
   771		 *
   772		 * In case of kexec, similar to SME, if TDX is ever enabled, the
   773		 * cachelines of TDX private memory (including PAMTs) used by TDX
   774		 * module need to be flushed before transiting to the new kernel,
   775		 * otherwise they may silently corrupt the new kernel.
   776		 *
   777		 * Note TDX is enabled on demand at runtime, and enabling TDX has a
   778		 * state machine protected with a mutex to prevent concurrent calls
   779		 * from multiple callers.  Holding the mutex is required to get the
   780		 * TDX enabling status, but this function runs in interrupt context.
   781		 * So to make it simple, always flush cache when platform supports
   782		 * TDX (detected at boot time), regardless whether TDX is truly
   783		 * enabled by kernel.
   784		 */
 > 785		if ((cpuid_eax(0x8000001f) & BIT(0)) || platform_has_tdx())
   786			native_wbinvd();
   787		for (;;) {
   788			/*
   789			 * Use native_halt() so that memory contents don't change
   790			 * (stack usage and variables) after possibly issuing the
   791			 * native_wbinvd() above.
   792			 */
   793			native_halt();
   794		}
   795	}
   796	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
