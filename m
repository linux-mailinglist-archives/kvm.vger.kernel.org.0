Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3E00784DCA
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 02:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231859AbjHWA04 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 20:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbjHWA04 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 20:26:56 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD29CF9;
        Tue, 22 Aug 2023 17:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692750414; x=1724286414;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=igVviDeI9rrt5AfwD9yTvCGN8lWm5SAWlmC86ohF/W0=;
  b=j3/xdIR8il8wR9ad8WWO9QkQ9hYTA3PCzkX/QczwvJ0HhpsicwVfeDs/
   wrDXg0tLhIh/lFhnU0BDSbkM4pFK5Gb/7fUh9PI2Rd9ckIT1FixEEUiiP
   HdlcNtaz3zX1wT2y6MFNanQGIXmwKbGWT4B9phXwQFihxShq9A4jtYPCT
   j2Iobz8rdlklEZ+3VxWcXuR8RXOhg7Lqriu9ydh/Q/9KXOdTFdkHeb1YL
   4SLYPj7ORWsY+FL0s+CE0s9I/3CTJqxDCBXG6+wyx2iI7FerqSDz6Ax/B
   ohkzNDCoUEandDqlah79ePrhec/jhCcBN+HRYfQinZLCRaSZuSVeKjkoE
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10810"; a="374003858"
X-IronPort-AV: E=Sophos;i="6.01,194,1684825200"; 
   d="scan'208";a="374003858"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2023 17:26:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10810"; a="1067256439"
X-IronPort-AV: E=Sophos;i="6.01,194,1684825200"; 
   d="scan'208";a="1067256439"
Received: from lkp-server02.sh.intel.com (HELO daf8bb0a381d) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 22 Aug 2023 17:26:52 -0700
Received: from kbuild by daf8bb0a381d with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qYbhz-0000eM-1H;
        Wed, 23 Aug 2023 00:26:51 +0000
Date:   Wed, 23 Aug 2023 08:26:35 +0800
From:   kernel test robot <lkp@intel.com>
To:     Hao Xiang <hao.xiang@linux.alibaba.com>, kvm@vger.kernel.org
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        shannon.zhao@linux.alibaba.com, pbonzini@redhat.com,
        seanjc@google.com, linux-kernel@vger.kernel.org,
        Hao Xiang <hao.xiang@linux.alibaba.com>
Subject: Re: [PATCH] kvm: x86: emulate MSR_PLATFORM_INFO msr bits
Message-ID: <202308230803.qc3KTHx1-lkp@intel.com>
References: <1692588151-33716-1-git-send-email-hao.xiang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1692588151-33716-1-git-send-email-hao.xiang@linux.alibaba.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Hao,

kernel test robot noticed the following build errors:

[auto build test ERROR on kvm/queue]
[also build test ERROR on mst-vhost/linux-next tip/x86/core linus/master v6.5-rc7 next-20230822]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Hao-Xiang/kvm-x86-emulate-MSR_PLATFORM_INFO-msr-bits/20230821-125755
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/1692588151-33716-1-git-send-email-hao.xiang%40linux.alibaba.com
patch subject: [PATCH] kvm: x86: emulate MSR_PLATFORM_INFO msr bits
config: i386-buildonly-randconfig-003-20230823 (https://download.01.org/0day-ci/archive/20230823/202308230803.qc3KTHx1-lkp@intel.com/config)
compiler: clang version 16.0.4 (https://github.com/llvm/llvm-project.git ae42196bc493ffe877a7e3dff8be32035dea4d07)
reproduce: (https://download.01.org/0day-ci/archive/20230823/202308230803.qc3KTHx1-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308230803.qc3KTHx1-lkp@intel.com/

All errors (new ones prefixed by >>):

>> arch/x86/kvm/x86.c:1695:24: error: use of undeclared identifier 'MSR_PLATFORM_INFO_MAX_NON_TURBO_RATIO'
           msr_platform_info &= (MSR_PLATFORM_INFO_MAX_NON_TURBO_RATIO |
                                 ^
   1 error generated.


vim +/MSR_PLATFORM_INFO_MAX_NON_TURBO_RATIO +1695 arch/x86/kvm/x86.c

  1678	
  1679	
  1680	static u64 kvm_get_msr_platform_info(void)
  1681	{
  1682		u64 msr_platform_info = 0;
  1683	
  1684		rdmsrl_safe(MSR_PLATFORM_INFO, &msr_platform_info);
  1685		/*
  1686		 * MSR_PLATFORM_INFO bits:
  1687		 * bit 15:8, Maximum Non-Turbo Ratio (MAX_NON_TURBO_LIM_RATIO)
  1688		 * bit 31, CPUID Faulting Enabled (CPUID_FAULTING_EN)
  1689		 * bit 47:40, Maximum Efficiency Ratio (MAX_EFFICIENCY_RATIO)
  1690		 *
  1691		 * Emulate part msr bits, expose above msr info to guest,
  1692		 * to make sure guest can get correct turbo frequency info.
  1693		 */
  1694	
> 1695		msr_platform_info &= (MSR_PLATFORM_INFO_MAX_NON_TURBO_RATIO |
  1696				MSR_PLATFORM_INFO_MAX_EFFICIENCY_RATIO);
  1697		msr_platform_info |= MSR_PLATFORM_INFO_CPUID_FAULT;
  1698	
  1699		return msr_platform_info;
  1700	}
  1701	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
