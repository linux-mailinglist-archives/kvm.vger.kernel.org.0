Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E49BA7A0ECC
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 22:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbjINULT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 16:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjINULS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 16:11:18 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5751826BC;
        Thu, 14 Sep 2023 13:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694722274; x=1726258274;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NhXCkUx/4wEGy8PcYWROJV8yPyG8l+yxCesPcMIlveg=;
  b=TZJ0iKu+GfbF3YN87x5aPwaM52wtrNydGhdeXSNCkBJ7mFKwUepIJXYK
   uAuyHsxg6Af9zAQ7OIeosgzB5tfDOv1UYBfxa0Srkk2MjLHdDYRnHskBf
   9e1RvU24WLpu4BpNvIVTpIqprS2smrftS7NA8zDVPpRNZbHU/S0ZamOJP
   h+GMnBHt/zh1tjkk3Nn7E0gY7f3lkZOH3bQ5NT1xCJqfrooT+42i7STwW
   Uf0AnVVljNTw5ztUjMLvvWI48K/rHNKvus08b/gBxCn4VCb+ZAWb6D6V/
   rb6vSwd4w1QYc59l0RTkvRBhR9At9xtm1RRC6/ZqnOwScLb524ySZjn5k
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="465432014"
X-IronPort-AV: E=Sophos;i="6.02,146,1688454000"; 
   d="scan'208";a="465432014"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 13:10:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="918366163"
X-IronPort-AV: E=Sophos;i="6.02,146,1688454000"; 
   d="scan'208";a="918366163"
Received: from lkp-server02.sh.intel.com (HELO 9ef86b2655e5) ([10.239.97.151])
  by orsmga005.jf.intel.com with ESMTP; 14 Sep 2023 13:10:47 -0700
Received: from kbuild by 9ef86b2655e5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qgsfl-00021V-1c;
        Thu, 14 Sep 2023 20:10:45 +0000
Date:   Fri, 15 Sep 2023 04:10:24 +0800
From:   kernel test robot <lkp@intel.com>
To:     Paul Durrant <paul@xen.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, Paul Durrant <pdurrant@amazon.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        David Woodhouse <dwmw2@infradead.org>, x86@kernel.org
Subject: Re: [PATCH 7/8] KVM: xen: prepare for using 'default' vcpu_info
Message-ID: <202309150313.w8vtnM1C-lkp@intel.com>
References: <20230914084946.200043-8-paul@xen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230914084946.200043-8-paul@xen.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paul,

kernel test robot noticed the following build warnings:

[auto build test WARNING on kvm/queue]
[also build test WARNING on mst-vhost/linux-next]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Paul-Durrant/KVM-pfncache-add-a-map-helper-function/20230914-171017
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20230914084946.200043-8-paul%40xen.org
patch subject: [PATCH 7/8] KVM: xen: prepare for using 'default' vcpu_info
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20230915/202309150313.w8vtnM1C-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20230915/202309150313.w8vtnM1C-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202309150313.w8vtnM1C-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/x86/kvm/xen.c:492:26: warning: no previous prototype for 'get_vcpu_info_cache' [-Wmissing-prototypes]
     492 | struct gfn_to_pfn_cache *get_vcpu_info_cache(struct kvm_vcpu *v, unsigned long *offset)
         |                          ^~~~~~~~~~~~~~~~~~~


vim +/get_vcpu_info_cache +492 arch/x86/kvm/xen.c

   491	
 > 492	struct gfn_to_pfn_cache *get_vcpu_info_cache(struct kvm_vcpu *v, unsigned long *offset)
   493	{
   494		if (offset)
   495			*offset = 0;
   496	
   497		return &v->arch.xen.vcpu_info_cache;
   498	}
   499	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
