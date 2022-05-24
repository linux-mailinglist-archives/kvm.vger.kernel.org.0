Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0941533068
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 20:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234732AbiEXS1L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 14:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231477AbiEXS1K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 14:27:10 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0AB3D1D0
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 11:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653416828; x=1684952828;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/SbyFbcG3/xefT5O4aa/e6GiwfAmhi9pY/fhzvfkdzw=;
  b=n7UaB9QQommN3JIFDiEVuMvTmYeaGpOsU7y0AGY3HgWTK2ZlNrqgHsj0
   VxuqDsAhi7E39V+Wzu8JhnGXtJuRWRzT9XGFATtkqd96uvlYPfd5JVLJN
   eGB6mpkVQ3OP9VTnKuaczquSLeVp/JYBjJXqR3+lQYEb5DmaiT4fiv2Hp
   nr2VY0+VndzeUhT+jsvdptuJaw+aPObldxhR3mBvhDXwYCmbWSgArXFro
   XUII8cGMktUz34qjPjZg3IkyE+2sUO3u46jIJ+Y6kyrjbgT6DrjytmScK
   YgCPOmff4T4qx27sRF4XBykLUSuVWwLe85swKsOXpv3dyY93nMz4/t5l/
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10357"; a="271195955"
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="271195955"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2022 11:27:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="559246573"
Received: from lkp-server01.sh.intel.com (HELO db63a1be7222) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 24 May 2022 11:27:06 -0700
Received: from kbuild by db63a1be7222 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1ntZFJ-0002L8-K4;
        Tue, 24 May 2022 18:27:05 +0000
Date:   Wed, 25 May 2022 02:27:03 +0800
From:   kernel test robot <lkp@intel.com>
To:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Cc:     kbuild-all@lists.01.org, pbonzini@redhat.com, jmattson@google.com,
        seanjc@google.com, Aaron Lewis <aaronlewis@google.com>
Subject: Re: [PATCH 1/4] kvm: x86/pmu: Introduce masked events to the pmu
 event filter
Message-ID: <202205250255.HGMufiYY-lkp@intel.com>
References: <20220523214110.1282480-2-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220523214110.1282480-2-aaronlewis@google.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
config: i386-randconfig-a004-20211129 (https://download.01.org/0day-ci/archive/20220525/202205250255.HGMufiYY-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-1) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/f189a455a73825b7025d8feff486db18ebef171f
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Aaron-Lewis/kvm-x86-pmu-Introduce-and-test-masked-events/20220524-054438
        git checkout f189a455a73825b7025d8feff486db18ebef171f
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash arch/x86/kvm/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> arch/x86/kvm/pmu.c:633:5: error: no previous prototype for 'has_invalid_event' [-Werror=missing-prototypes]
     633 | int has_invalid_event(struct kvm_pmu_event_filter *filter)
         |     ^~~~~~~~~~~~~~~~~
   cc1: all warnings being treated as errors


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
