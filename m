Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0258A7BD051
	for <lists+kvm@lfdr.de>; Sun,  8 Oct 2023 23:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344628AbjJHVdZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Oct 2023 17:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjJHVdY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Oct 2023 17:33:24 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7D69D;
        Sun,  8 Oct 2023 14:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696800803; x=1728336803;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QjUYd7D8jxKwhfKDBMGlUwHrcS+k4UsbgJEgqAWVww8=;
  b=P2bHOeHixqQultUazxx9JCgR+5Kcz0QAWqZXWXB2RdpmzU3yqlcvDZz0
   8G8EvLsoZVac/Mx9KLYTQxm0UZH++fZWa5Tu4wQvBEE+LKDKH7gMXLiEb
   I20cK5M7ittyHlGJ1nAl/JqIYaIdenJZFCA3nXPOotl0hf0hKJtMKe/2H
   NwsoATemZXqxLySiW0leo7kP+8TO+WdG6SF3CYUuX0cACBOt8aX+HNj9x
   571+fJDt07dmnaNzFqMKrv2OhIYN0cmtcB2Y8oDr2TIuTH4KHCtc+rMIA
   iKNWspPX6IMCgG+6Z0VcxfML9t2UetnIuRZlMyf14+34k0eaRpbCBcR1x
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10857"; a="5580185"
X-IronPort-AV: E=Sophos;i="6.03,207,1694761200"; 
   d="scan'208";a="5580185"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2023 14:33:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10857"; a="787968390"
X-IronPort-AV: E=Sophos;i="6.03,207,1694761200"; 
   d="scan'208";a="787968390"
Received: from lkp-server01.sh.intel.com (HELO 8a3a91ad4240) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 08 Oct 2023 14:33:17 -0700
Received: from kbuild by 8a3a91ad4240 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qpbOl-0005mD-1l;
        Sun, 08 Oct 2023 21:33:15 +0000
Date:   Mon, 9 Oct 2023 05:32:47 +0800
From:   kernel test robot <lkp@intel.com>
To:     Tianyi Liu <i.pear@outlook.com>, seanjc@google.com,
        pbonzini@redhat.com, peterz@infradead.org, mingo@redhat.com,
        acme@kernel.org
Cc:     oe-kbuild-all@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        namhyung@kernel.org, irogers@google.com, adrian.hunter@intel.com,
        Tianyi Liu <i.pear@outlook.com>
Subject: Re: [PATCH v2 1/5] KVM: Add arch specific interfaces for sampling
 guest callchains
Message-ID: <202310090559.wzrojQni-lkp@intel.com>
References: <SY4P282MB10840154D4F09917D6528BC69DCFA@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SY4P282MB10840154D4F09917D6528BC69DCFA@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Tianyi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 8a749fd1a8720d4619c91c8b6e7528c0a355c0aa]

url:    https://github.com/intel-lab-lkp/linux/commits/Tianyi-Liu/KVM-Add-arch-specific-interfaces-for-sampling-guest-callchains/20231008-230042
base:   8a749fd1a8720d4619c91c8b6e7528c0a355c0aa
patch link:    https://lore.kernel.org/r/SY4P282MB10840154D4F09917D6528BC69DCFA%40SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
patch subject: [PATCH v2 1/5] KVM: Add arch specific interfaces for sampling guest callchains
config: x86_64-defconfig (https://download.01.org/0day-ci/archive/20231009/202310090559.wzrojQni-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-12) 11.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231009/202310090559.wzrojQni-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202310090559.wzrojQni-lkp@intel.com/

All warnings (new ones prefixed by >>):

   arch/x86/kvm/x86.c: In function 'kvm_arch_vcpu_read_virt':
>> arch/x86/kvm/x86.c:12917:42: warning: passing argument 2 of 'kvm_read_guest_virt' makes integer from pointer without a cast [-Wint-conversion]
   12917 |         return kvm_read_guest_virt(vcpu, addr, dest, length, &e) == X86EMUL_CONTINUE;
         |                                          ^~~~
         |                                          |
         |                                          void *
   arch/x86/kvm/x86.c:7388:38: note: expected 'gva_t' {aka 'long unsigned int'} but argument is of type 'void *'
    7388 |                                gva_t addr, void *val, unsigned int bytes,
         |                                ~~~~~~^~~~


vim +/kvm_read_guest_virt +12917 arch/x86/kvm/x86.c

 12911	
 12912	bool kvm_arch_vcpu_read_virt(struct kvm_vcpu *vcpu, void *addr, void *dest, unsigned int length)
 12913	{
 12914		struct x86_exception e;
 12915	
 12916		/* Return true on success */
 12917		return kvm_read_guest_virt(vcpu, addr, dest, length, &e) == X86EMUL_CONTINUE;
 12918	}
 12919	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
