Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD9B5333D6
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 01:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241667AbiEXXS0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 19:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233046AbiEXXSY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 19:18:24 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4EA77F25
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 16:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653434303; x=1684970303;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fZeHACaunBQRxf/ZvQrfl89qLke4rauBHHOhm0g7eek=;
  b=gnRvw0nd63xNm7mhc55aCZtSiBbsWAFsjInwW3exfws2NYzOQ/eioF6Z
   W7sYSPfeB8s0V3xoUWbo/hzQzbsot6Kb4x6dL5se0ddpjhwXTEzAh/YiH
   twDukME/YakbFQYa9nTHLOpr0AmzPaj+yTzm+NQVgegFHbE6+Gq4ab20+
   UIoSRPUaZWiXplp2ui5t9O+mVlbuezHvtOKx+80OXzwJ+enWQF8cH3DML
   3XmpBtGMPQJfVQEQjmU+nfOG0d+k9Sq4ili/07kGQlhRYXMCBsJegIQDm
   MEyDYWg5p9yYfAqblGTXnEhjsbGhzBCGkoXSXbqf+eCWjMFiOSEUAnwAD
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10357"; a="360063154"
X-IronPort-AV: E=Sophos;i="5.91,250,1647327600"; 
   d="scan'208";a="360063154"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2022 16:18:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,250,1647327600"; 
   d="scan'208";a="608877136"
Received: from lkp-server01.sh.intel.com (HELO db63a1be7222) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 24 May 2022 16:18:20 -0700
Received: from kbuild by db63a1be7222 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1ntdn9-0002XW-Kd;
        Tue, 24 May 2022 23:18:19 +0000
Date:   Wed, 25 May 2022 07:17:25 +0800
From:   kernel test robot <lkp@intel.com>
To:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, pbonzini@redhat.com,
        jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Subject: Re: [PATCH 1/4] kvm: x86/pmu: Introduce masked events to the pmu
 event filter
Message-ID: <202205250725.AFgtAciB-lkp@intel.com>
References: <20220523214110.1282480-2-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220523214110.1282480-2-aaronlewis@google.com>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Aaron,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on kvm/master]
[also build test ERROR on v5.18]
[cannot apply to mst-vhost/linux-next next-20220524]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Aaron-Lewis/kvm-x86-pmu-Introduce-and-test-masked-events/20220524-054438
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git master
config: i386-randconfig-a002 (https://download.01.org/0day-ci/archive/20220525/202205250725.AFgtAciB-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 10c9ecce9f6096e18222a331c5e7d085bd813f75)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/f189a455a73825b7025d8feff486db18ebef171f
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Aaron-Lewis/kvm-x86-pmu-Introduce-and-test-masked-events/20220524-054438
        git checkout f189a455a73825b7025d8feff486db18ebef171f
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> arch/x86/kvm/pmu.c:633:5: error: no previous prototype for function 'has_invalid_event' [-Werror,-Wmissing-prototypes]
   int has_invalid_event(struct kvm_pmu_event_filter *filter)
       ^
   arch/x86/kvm/pmu.c:633:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   int has_invalid_event(struct kvm_pmu_event_filter *filter)
   ^
   static 
   1 error generated.


vim +/has_invalid_event +633 arch/x86/kvm/pmu.c

   632	
 > 633	int has_invalid_event(struct kvm_pmu_event_filter *filter)
   634	{
   635		u64 event_mask;
   636		int i;
   637	
   638		event_mask = kvm_x86_ops.pmu_ops->get_event_mask(filter->flags);
   639		for(i = 0; i < filter->nevents; i++)
   640			if (filter->events[i] & ~event_mask)
   641				return true;
   642	
   643		return false;
   644	}
   645	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
