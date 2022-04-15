Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F9D502FCA
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 22:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351147AbiDOUcH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 16:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233989AbiDOUcF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 16:32:05 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B30613D2B
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 13:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650054575; x=1681590575;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=RUwt1uKFZJBWr5c6P/yatujumHDfzn8uGPVQng5YafE=;
  b=f6rRrXMtRhJTG0gLr0pmXDszP00Hdm2KTHzluLUeIkFdQDnff8SpBNu3
   4O7kQfeOPUkkwvjBbJEwq8g3AiXNoAE4NvxNJzZlAa5wk45mhHvaKrU29
   p3VEZVsJM8XL/yjUrwkxU7KQc+fU3p0HdBEj0Fr7Dxw1/SIWLeFaYB5TG
   G6oSgD+sfpox5jyXPBNnsJtNKSzXjoqtqilne1ULT+j93kjh6BMef+6z5
   t5SynJXPJvxakbuVMszAWGm4rYaDKhDmPjRUrH0k/mcv8xNwTDkEqxIpU
   nLlEoFsrNHfPAaWVNohw0z9Tk3XrN4j0Ou3Uh2fezH122Uf16Ow3S+2QG
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10318"; a="250522523"
X-IronPort-AV: E=Sophos;i="5.90,263,1643702400"; 
   d="scan'208";a="250522523"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2022 13:29:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,263,1643702400"; 
   d="scan'208";a="856368353"
Received: from lkp-server01.sh.intel.com (HELO 3abc53900bec) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 15 Apr 2022 13:29:32 -0700
Received: from kbuild by 3abc53900bec with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nfSZQ-0002Nj-2e;
        Fri, 15 Apr 2022 20:29:32 +0000
Date:   Sat, 16 Apr 2022 04:29:26 +0800
From:   kernel test robot <lkp@intel.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm:kvm-tdx-5.17 23/141] arch/x86/kernel/process.c:785:49: error:
 implicit declaration of function 'platform_has_tdx'
Message-ID: <202204160429.53nZyD9a-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-tdx-5.17
head:   a50e4531e92e36f185ea32843c149c4703451109
commit: bf2274dac8e8671ae89971ae8c89f4f2f8f13095 [23/141] x86: Flush cache of TDX private memory during kexec()
config: i386-tinyconfig (https://download.01.org/0day-ci/archive/20220416/202204160429.53nZyD9a-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-19) 11.2.0
reproduce (this is a W=1 build):
        # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=bf2274dac8e8671ae89971ae8c89f4f2f8f13095
        git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
        git fetch --no-tags kvm kvm-tdx-5.17
        git checkout bf2274dac8e8671ae89971ae8c89f4f2f8f13095
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash arch/x86/kernel/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   arch/x86/kernel/process.c: In function 'stop_this_cpu':
>> arch/x86/kernel/process.c:785:49: error: implicit declaration of function 'platform_has_tdx' [-Werror=implicit-function-declaration]
     785 |         if ((cpuid_eax(0x8000001f) & BIT(0)) || platform_has_tdx())
         |                                                 ^~~~~~~~~~~~~~~~
   arch/x86/kernel/process.c: At top level:
   arch/x86/kernel/process.c:903:13: warning: no previous prototype for 'arch_post_acpi_subsys_init' [-Wmissing-prototypes]
     903 | void __init arch_post_acpi_subsys_init(void)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


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
