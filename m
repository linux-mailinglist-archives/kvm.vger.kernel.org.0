Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A50586DC25B
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 03:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjDJBhI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Apr 2023 21:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjDJBhH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Apr 2023 21:37:07 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B727535A7;
        Sun,  9 Apr 2023 18:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681090626; x=1712626626;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kM3MVlxT3U4OwC09SKYW+x+Zuer/Bey+4Mm+quIUoZI=;
  b=kqWDNU8/DuEvhb70D8DI1h+ky1kKev5x6UrAM3bu5y52/W3SaPewZO3P
   RXsbR1UvJ4khoIy5a7XmvaTPOwTJcHmF7WqLk2QihmIpLdIqJMnP4unKs
   tlLKhuAalWO+RpC/6aoW/Ss77JvzGkh2f2xRsIE4CYk/ScVcPFY/Danyd
   Mrmtrt0NYZbIYgV5tyr9D6u9BexKu4+dUw2uC16cifamjkJvzPw3UozsJ
   WgNfDvzdV1Q6BMKsLY1i9P9EnjFTrN3Tpko26z7mR1UAaSrlen0T5O0cr
   8bO0+5O2CasVXx32z3GrKeyt6Z93uvTPyQsyBAPgY1MGR4Eypl6xY+yER
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10675"; a="429551537"
X-IronPort-AV: E=Sophos;i="5.98,332,1673942400"; 
   d="scan'208";a="429551537"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2023 18:37:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10675"; a="688106998"
X-IronPort-AV: E=Sophos;i="5.98,332,1673942400"; 
   d="scan'208";a="688106998"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 09 Apr 2023 18:37:02 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1plgSr-000UuD-17;
        Mon, 10 Apr 2023 01:37:01 +0000
Date:   Mon, 10 Apr 2023 09:36:26 +0800
From:   kernel test robot <lkp@intel.com>
To:     Tianrui Zhao <zhaotianrui@loongson.cn>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     oe-kbuild-all@lists.linux.dev, Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>, zhaotianrui@loongson.cn
Subject: Re: [PATCH v5 30/30] LoongArch: KVM: Supplement kvm document about
 loongarch-specific part
Message-ID: <202304100944.xF4XkTAE-lkp@intel.com>
References: <20230407020003.3651096-31-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407020003.3651096-31-zhaotianrui@loongson.cn>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Tianrui,

kernel test robot noticed the following build warnings:

[auto build test WARNING on kvm/queue]
[also build test WARNING on linus/master v6.3-rc6 next-20230406]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Tianrui-Zhao/LoongArch-KVM-Add-kvm-related-header-files/20230407-100816
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20230407020003.3651096-31-zhaotianrui%40loongson.cn
patch subject: [PATCH v5 30/30] LoongArch: KVM: Supplement kvm document about loongarch-specific part
reproduce:
        # https://github.com/intel-lab-lkp/linux/commit/a4ea2786cae9b2350b1aed613edcc003ce93cfc2
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Tianrui-Zhao/LoongArch-KVM-Add-kvm-related-header-files/20230407-100816
        git checkout a4ea2786cae9b2350b1aed613edcc003ce93cfc2
        make menuconfig
        # enable CONFIG_COMPILE_TEST, CONFIG_WARN_MISSING_DOCUMENTS, CONFIG_WARN_ABI_ERRORS
        make htmldocs

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304100944.xF4XkTAE-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Documentation/virt/kvm/api.rst:423: WARNING: Literal block ends without a blank line; unexpected unindent.

vim +423 Documentation/virt/kvm/api.rst

   399	
   400	  /* x86 */
   401	  struct kvm_regs {
   402		/* out (KVM_GET_REGS) / in (KVM_SET_REGS) */
   403		__u64 rax, rbx, rcx, rdx;
   404		__u64 rsi, rdi, rsp, rbp;
   405		__u64 r8,  r9,  r10, r11;
   406		__u64 r12, r13, r14, r15;
   407		__u64 rip, rflags;
   408	  };
   409	
   410	  /* mips */
   411	  struct kvm_regs {
   412		/* out (KVM_GET_REGS) / in (KVM_SET_REGS) */
   413		__u64 gpr[32];
   414		__u64 hi;
   415		__u64 lo;
   416		__u64 pc;
   417	  };
   418	
   419	  /* loongarch */
   420	  struct kvm_regs {
   421	        unsigned long gpr[32];
   422	        unsigned long pc;
 > 423	};
   424	
   425	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
