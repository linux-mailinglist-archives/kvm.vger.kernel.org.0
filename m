Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 185B05210CF
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 11:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238736AbiEJJaX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 05:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233125AbiEJJaV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 05:30:21 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0FE1D6743;
        Tue, 10 May 2022 02:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652174784; x=1683710784;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Mp9jZr1YvFw211l0xlD/9OlTIu1yhkTn88WExDooEHI=;
  b=MROg9lb+7nRv7fJYO3KJ5DPhWBDpyrIsoWyXWp5tFmDJOu/hjSzt3IK2
   gCzimgSVMgJMSKHBCUC+JKCADJx5FHjRccr1oAQ2OrASAMkL4NAVwTGpr
   bdJ9S8pey+c8oa1Y0agQ67INLOsXPgVS1AQYyn9gSSAfneP98swD2/tHW
   EkWKFeAISXGPGAuCJ9D5IEZ7JjbmV8FxcdRvuEGJ02MWMgoQz8bW/qN30
   XDa5sCMeX0q/28nxxutIN67cHmp7oVCEcVRMFEc05Cwxqtoss7sTEvWZb
   SoficRH40apV6N6DHV+XLZ0ZCRavUE9ghHBEU1tDP27i1M/5DyZ5oRdwN
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10342"; a="332353868"
X-IronPort-AV: E=Sophos;i="5.91,214,1647327600"; 
   d="scan'208";a="332353868"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2022 02:26:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,214,1647327600"; 
   d="scan'208";a="623388039"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 10 May 2022 02:26:21 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1noM8K-000He2-Tq;
        Tue, 10 May 2022 09:26:20 +0000
Date:   Tue, 10 May 2022 17:25:49 +0800
From:   kernel test robot <lkp@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] x86/kvm: handle the failure of __pv_cpu_mask allocation
Message-ID: <202205101754.d5Mxymtk-lkp@intel.com>
References: <1650620846-12092-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1650620846-12092-1-git-send-email-wanpengli@tencent.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Wanpeng,

I love your patch! Perhaps something to improve:

[auto build test WARNING on kvm/master]
[also build test WARNING on tip/master linus/master linux/master v5.18-rc6 next-20220509]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Wanpeng-Li/x86-kvm-handle-the-failure-of-__pv_cpu_mask-allocation/20220422-175106
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git master
config: i386-randconfig-a004-20220502 (https://download.01.org/0day-ci/archive/20220510/202205101754.d5Mxymtk-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-20) 11.2.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/329f0c869cf176505509f65e95e47999a9e97b3b
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Wanpeng-Li/x86-kvm-handle-the-failure-of-__pv_cpu_mask-allocation/20220422-175106
        git checkout 329f0c869cf176505509f65e95e47999a9e97b3b
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash arch/x86/kernel/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> arch/x86/kernel/kvm.c:49:20: warning: 'orig_apic' defined but not used [-Wunused-variable]
      49 | static struct apic orig_apic;
         |                    ^~~~~~~~~


vim +/orig_apic +49 arch/x86/kernel/kvm.c

    48	
  > 49	static struct apic orig_apic;
    50	static int kvmapf = 1;
    51	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
