Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B04C0761A80
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 15:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbjGYNtu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 09:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbjGYNtf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 09:49:35 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256392D45
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 06:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690292963; x=1721828963;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vzmyew1zHaAjyohrBlKaReRdxmqxZXs2iL/nx5P57NQ=;
  b=LY/Ot1snu/jd6bZgbdtJPw6MJGr3c0/VaQSWsPAM0X8vBpwHHPUFzp6W
   gy85eIdRJXyWGIZU92uIjPuvWDWJEqnqcq9GhiACbN6wO/PL/cA3F81K0
   jd4o9rXiJ50H9KyTzXuDpYxywuEmDMmCJNI5KzF087j1322gjhbV5pnHi
   6YBuQiCdL6e79pcFewjae3Jp/KwyMBaF0XKJImqP2P069/S1hCooKgczP
   5uhwmRk0iLFO2AypVC205CA9H1yquYl86qm/xJvZXEpbetIvNoG6EkZ1i
   mYfjrXkftUhVl1KJycDiBTDCyU0AhZV/LLEnK8+Kg3rJdEIW5KWzo7DDx
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="347332863"
X-IronPort-AV: E=Sophos;i="6.01,230,1684825200"; 
   d="scan'208";a="347332863"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 06:49:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="726119837"
X-IronPort-AV: E=Sophos;i="6.01,230,1684825200"; 
   d="scan'208";a="726119837"
Received: from lkp-server02.sh.intel.com (HELO 36946fcf73d7) ([10.239.97.151])
  by orsmga002.jf.intel.com with ESMTP; 25 Jul 2023 06:49:19 -0700
Received: from kbuild by 36946fcf73d7 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qOIPe-000AeK-1G;
        Tue, 25 Jul 2023 13:49:18 +0000
Date:   Tue, 25 Jul 2023 21:48:22 +0800
From:   kernel test robot <lkp@intel.com>
To:     Xiong Zhang <xiong.y.zhang@intel.com>, kvm@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, seanjc@google.com,
        like.xu.linux@gmail.com, weijiang.yang@intel.com,
        zhiyuan.lv@intel.com, zhenyu.z.wang@intel.com, kan.liang@intel.com,
        Xiong Zhang <xiong.y.zhang@intel.com>
Subject: Re: [PATCH] Documentation: KVM: Add vPMU implementaion and gap
 document
Message-ID: <202307252116.sD1ngIZF-lkp@intel.com>
References: <20230724104154.259573-1-xiong.y.zhang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230724104154.259573-1-xiong.y.zhang@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Xiong,

kernel test robot noticed the following build warnings:

[auto build test WARNING on kvm/queue]
[also build test WARNING on mst-vhost/linux-next linus/master v6.5-rc3 next-20230725]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Xiong-Zhang/Documentation-KVM-Add-vPMU-implementaion-and-gap-document/20230724-184443
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20230724104154.259573-1-xiong.y.zhang%40intel.com
patch subject: [PATCH] Documentation: KVM: Add vPMU implementaion and gap document
reproduce: (https://download.01.org/0day-ci/archive/20230725/202307252116.sD1ngIZF-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202307252116.sD1ngIZF-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Documentation/virt/kvm/x86/pmu.rst:104: WARNING: Unexpected indentation.
>> Documentation/virt/kvm/x86/pmu.rst:104: WARNING: Unexpected section title or transition.

vim +104 Documentation/virt/kvm/x86/pmu.rst

   100	
   101	When guest no longer access the virtual counter's MSR within a
   102	scheduling time slice and the virtual counter is disabled, KVM will
   103	release the kvm perf event.
 > 104	  ----------------------------
   105	  |  Guest                   |
   106	  |  perf subsystem          |
   107	  ----------------------------
   108	       |            ^
   109	  vMSR |            | vPMI
   110	       v            |
   111	  ----------------------------
   112	  |  vPMU        KVM vCPU    |
   113	  ----------------------------
   114	        |          ^
   115	  Call  |          | Callbacks
   116	        v          |
   117	  ---------------------------
   118	  | Host Linux Kernel       |
   119	  | perf subsystem          |
   120	  ---------------------------
   121	               |       ^
   122	           MSR |       | PMI
   123	               v       |
   124	         --------------------
   125		 | PMU        CPU   |
   126	         --------------------
   127	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
