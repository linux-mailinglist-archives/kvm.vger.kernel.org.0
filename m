Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B61C479108B
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 06:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351460AbjIDERL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 00:17:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235595AbjIDERK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 00:17:10 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 273DEFA
        for <kvm@vger.kernel.org>; Sun,  3 Sep 2023 21:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693801027; x=1725337027;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CpGwqWAtA/9ynEZ5PCzAiS9mPBBLeJgq8BRk/fK8g1g=;
  b=HiguDE9YeKWBsDytG1hz7v/smGZL9zNqkuXEePWSS985OswuX/IpJ0wm
   jrjTlewhs5bHWegTzxJ9jNtBhPeZOKYOR3ZMUpDHnKpPk+Qw3rCOCha7l
   yfIVnG3Oc8PcJUXtd9PcVy2Thk304++5xAKFdOzwuUc9xVkf+y4/U/qEa
   x1+SQS1EV/atuGpIKgk08eCbB00j+Tut7kKNEeg3iMSHIK4qoYKE5CkUy
   9wynFT3oGPHyF2lBuWk03U/tSB/PhA5/dk+McXlHfeDT96jaU5oMyuENI
   L5ztYweCShO9USZGuOVJ195P89HO/GC8SV/SLIFBmO+u5yiaL6CD5myoI
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="380306265"
X-IronPort-AV: E=Sophos;i="6.02,225,1688454000"; 
   d="scan'208";a="380306265"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2023 21:17:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="734183717"
X-IronPort-AV: E=Sophos;i="6.02,225,1688454000"; 
   d="scan'208";a="734183717"
Received: from lkp-server02.sh.intel.com (HELO e0b2ea88afd5) ([10.239.97.151])
  by orsmga007.jf.intel.com with ESMTP; 03 Sep 2023 21:17:04 -0700
Received: from kbuild by e0b2ea88afd5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qd11E-00009j-1N;
        Mon, 04 Sep 2023 04:16:58 +0000
Date:   Mon, 4 Sep 2023 12:16:45 +0800
From:   kernel test robot <lkp@intel.com>
To:     Tao Su <tao1.su@linux.intel.com>, kvm@vger.kernel.org
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        guang.zeng@intel.com, yi1.lai@intel.com, tao1.su@linux.intel.com
Subject: Re: [PATCH 2/2] KVM: x86: Clear X2APIC_ICR_UNUSED_12 after
 APIC-write VM-exit
Message-ID: <202309041224.CDj6t1BN-lkp@intel.com>
References: <20230904013555.725413-3-tao1.su@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230904013555.725413-3-tao1.su@linux.intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Tao,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 708283abf896dd4853e673cc8cba70acaf9bf4ea]

url:    https://github.com/intel-lab-lkp/linux/commits/Tao-Su/x86-apic-Introduce-X2APIC_ICR_UNUSED_12-for-x2APIC-mode/20230904-093801
base:   708283abf896dd4853e673cc8cba70acaf9bf4ea
patch link:    https://lore.kernel.org/r/20230904013555.725413-3-tao1.su%40linux.intel.com
patch subject: [PATCH 2/2] KVM: x86: Clear X2APIC_ICR_UNUSED_12 after APIC-write VM-exit
config: x86_64-randconfig-003-20230904 (https://download.01.org/0day-ci/archive/20230904/202309041224.CDj6t1BN-lkp@intel.com/config)
compiler: clang version 16.0.4 (https://github.com/llvm/llvm-project.git ae42196bc493ffe877a7e3dff8be32035dea4d07)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20230904/202309041224.CDj6t1BN-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202309041224.CDj6t1BN-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/x86/kvm/lapic.c:2445:30: warning: variable 'val' is uninitialized when used here [-Wuninitialized]
                   kvm_x2apic_icr_write(apic, val);
                                              ^~~
   arch/x86/kvm/lapic.c:2435:9: note: initialize the variable 'val' to silence this warning
           u64 val;
                  ^
                   = 0
   1 warning generated.


vim +/val +2445 arch/x86/kvm/lapic.c

  2430	
  2431	/* emulate APIC access in a trap manner */
  2432	void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
  2433	{
  2434		struct kvm_lapic *apic = vcpu->arch.apic;
  2435		u64 val;
  2436	
  2437		/*
  2438		 * ICR is a single 64-bit register when x2APIC is enabled.  For legacy
  2439		 * xAPIC, ICR writes need to go down the common (slightly slower) path
  2440		 * to get the upper half from ICR2.
  2441		 *
  2442		 * TODO: optimize to just emulate side effect w/o one more write
  2443		 */
  2444		if (apic_x2apic_mode(apic) && offset == APIC_ICR) {
> 2445			kvm_x2apic_icr_write(apic, val);
  2446		} else {
  2447			val = kvm_lapic_get_reg(apic, offset);
  2448			kvm_lapic_reg_write(apic, offset, (u32)val);
  2449		}
  2450	}
  2451	EXPORT_SYMBOL_GPL(kvm_apic_write_nodecode);
  2452	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
