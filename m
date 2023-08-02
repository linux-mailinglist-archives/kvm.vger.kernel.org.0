Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8DAC76C1F0
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 03:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbjHBBPy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 21:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjHBBPx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 21:15:53 -0400
Received: from mgamail.intel.com (unknown [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C1371BE3
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 18:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690938952; x=1722474952;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aHAviXhYhpJw3O8zDa1GoifisOzps1Rdl4ShruvBQnA=;
  b=RpSoDvqjTfepNJ5B8oiNPVEypWmv2y9plwliRcoPdVkfy/rgvDrv9cde
   4hxAHet1QOHca3FZ0SXIyltL1OLtJB7qx0V/0dvX+hqcQGdl+e3ogUEXd
   SoiQJWzY3hQs43hw0y/B/WB2NGFmAdtJ065VGJq0XnIE+CAQ5dxk0inMK
   go27Wbbn/vrBrgS56MIBUnWjxH/yGRCmIJ2HDWZclNP9OaerDLxb3JehT
   aPTLJmRbqmrln9Zkm2Wh2aiKF3Y8yz8H4CcU8xsQH6yDQcEVEFXcCzpwq
   MM1QzRxuPTLzREDcxoHgvDnIPYqtGv4RlqADdrpUfp65EGWA2460aVJH5
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10789"; a="433289910"
X-IronPort-AV: E=Sophos;i="6.01,248,1684825200"; 
   d="scan'208";a="433289910"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2023 18:15:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10789"; a="758551516"
X-IronPort-AV: E=Sophos;i="6.01,248,1684825200"; 
   d="scan'208";a="758551516"
Received: from lkp-server01.sh.intel.com (HELO d1ccc7e87e8f) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 01 Aug 2023 18:15:48 -0700
Received: from kbuild by d1ccc7e87e8f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qR0Sq-0000jf-0G;
        Wed, 02 Aug 2023 01:15:48 +0000
Date:   Wed, 2 Aug 2023 09:14:56 +0800
From:   kernel test robot <lkp@intel.com>
To:     Xiong Zhang <xiong.y.zhang@intel.com>, kvm@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, weijiang.yang@intel.com,
        seanjc@google.com, like.xu.linux@gmail.com, zhiyuan.lv@intel.com,
        zhenyu.z.wang@intel.com, kan.liang@intel.com,
        Xiong Zhang <xiong.y.zhang@intel.com>
Subject: Re: [PATCH v2] Documentation: KVM: Add vPMU implementaion and gap
 document
Message-ID: <202308020931.XkEOeIFg-lkp@intel.com>
References: <20230801035836.1048879-1-xiong.y.zhang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230801035836.1048879-1-xiong.y.zhang@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Xiong,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 88bb466c9dec4f70d682cf38c685324e7b1b3d60]

url:    https://github.com/intel-lab-lkp/linux/commits/Xiong-Zhang/Documentation-KVM-Add-vPMU-implementaion-and-gap-document/20230801-120150
base:   88bb466c9dec4f70d682cf38c685324e7b1b3d60
patch link:    https://lore.kernel.org/r/20230801035836.1048879-1-xiong.y.zhang%40intel.com
patch subject: [PATCH v2] Documentation: KVM: Add vPMU implementaion and gap document
reproduce: (https://download.01.org/0day-ci/archive/20230802/202308020931.XkEOeIFg-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308020931.XkEOeIFg-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Documentation/virt/kvm/x86/pmu.rst:45: WARNING: Inline emphasis start-string without end-string.

vim +45 Documentation/virt/kvm/x86/pmu.rst

    44	
  > 45	Perf event is created by perf_event_open() system call:
    46	int syscall(SYS_perf_event_open, struct perf_event_attr *attr,
    47		    pid_t pid, int cpu, int roup_fd, unsigned long flags)
    48	
    49	    struct perf_event_attr {
    50		    ......
    51		    /* Major type: hardware/software/tracepoint/etc. */
    52		    __u32   type;
    53		    /* Type specific configuration information. */
    54		    __u64   config;
    55		    union {
    56			    __u64      sample_period;
    57			    __u64      sample_freq;
    58		    }
    59		   __u64   disabled :1;
    60		           pinned   :1;
    61			   exclude_user  :1;
    62			   exclude_kernel :1;
    63			   exclude_host   :1;
    64		           exclude_guest  :1;
    65		    ......
    66	    }
    67	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
