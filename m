Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B16DD564DBE
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 08:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbiGDGhg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 02:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiGDGhf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 02:37:35 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01FF5273D
        for <kvm@vger.kernel.org>; Sun,  3 Jul 2022 23:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656916654; x=1688452654;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UIHLEUSLVrnILEbXWMK72N3tcxbxZd5RKq12P2sn7hc=;
  b=Mpk/jUvjruiN3Mi13NM3YQh4Id2kBlVleXO7yBspeBw0tDwSzwXCqQMO
   gV/SINAo5c7rTseyGe9HfLBuuUTtK4bxl0J8My9TN0mk39P1RVjjI5zFh
   k955UeLCj/9KKBtU4LywRWq5s0r1z7jaD1dUAnf9NUrC53KgMaXNWbWK4
   dRAksW9YbZi99NQYviqXGcKfxRDJ547fwJjFvTRVh9zEJMura4YqDi7FY
   XdZ599XzBDz7IJm+7sao3gxXY+gj4CVhrPoy8fFcdCyn0azLaV9tHITiB
   4VOC9T3dYCv5s1dKktEFKufmqQdmDXRDTNqekTViBlw92ChJO6D/RAXQe
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10397"; a="283077249"
X-IronPort-AV: E=Sophos;i="5.92,243,1650956400"; 
   d="scan'208";a="283077249"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2022 23:37:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,243,1650956400"; 
   d="scan'208";a="660091837"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 03 Jul 2022 23:37:26 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o8Fi2-000HcF-5U;
        Mon, 04 Jul 2022 06:37:26 +0000
Date:   Mon, 4 Jul 2022 14:36:36 +0800
From:   kernel test robot <lkp@intel.com>
To:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Cc:     kbuild-all@lists.01.org, pbonzini@redhat.com, jmattson@google.com,
        seanjc@google.com, Aaron Lewis <aaronlewis@google.com>
Subject: Re: [PATCH v2 1/4] kvm: x86/pmu: Introduce masked events to the pmu
 event filter
Message-ID: <202207041456.bNLOWhOQ-lkp@intel.com>
References: <20220606175248.1884041-2-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220606175248.1884041-2-aaronlewis@google.com>
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

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on mst-vhost/linux-next]
[also build test WARNING on v5.19-rc5]
[cannot apply to kvm/queue next-20220701]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Aaron-Lewis/kvm-x86-pmu-Introduce-and-test-masked-events/20220607-020408
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git linux-next
reproduce: make htmldocs

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> Documentation/virt/kvm/api.rst:5023: WARNING: Unexpected indentation.
>> Documentation/virt/kvm/api.rst:5025: WARNING: Block quote ends without a blank line; unexpected unindent.

vim +5023 Documentation/virt/kvm/api.rst

  5015	
  5016	:Capability: KVM_CAP_PMU_EVENT_FILTER
  5017	:Architectures: x86
  5018	:Type: vm ioctl
  5019	:Parameters: struct kvm_pmu_event_filter (in)
  5020	:Returns: 0 on success,
  5021	    -EFAULT args[0] cannot be accessed.
  5022	    -EINVAL args[0] contains invalid data in the filter or events field.
> 5023	                    Note: event validation is only done for modes where
  5024	                    the flags field is non-zero.
> 5025	    -E2BIG nevents is too large.
  5026	    -ENOMEM not enough memory to allocate the filter.
  5027	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
