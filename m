Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4FDF6ADD86
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 12:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbjCGLfA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 06:35:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbjCGLeq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 06:34:46 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C7032CE2;
        Tue,  7 Mar 2023 03:33:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678188824; x=1709724824;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xylpS4dMHvwStOXeEA691mA7Cx1+UtxKNUF6D05Th1k=;
  b=BYcPsIrrsoLF9jSky3eECHOFdGnIQ8xZJQyLdQoEIfmOuxk65d0t1dRT
   0sYWHjpfpOGXGTk4uESAIkwhMDZAZCQucRNC/FoZMuJZmsLN+0lAEJVbV
   wsOsXRlDjV0hiWNFPkm+QPueP+GcxaPSss9atms0QN9X+6za8jSdK68hn
   2M3hOLed/U2FzO5bWM4+X+wGdAsaHI+YEv/cy1X2fuRVc6boGBDxA2YEb
   iD9HZ9FBJF2l6k4Fck/1G+2XGELfu9P/k1KRk6DpRK1cKL9s3u6pQKZ9k
   P9V63GT/1jjcM4zMudYlbCMJJda7JoOGM2Q2ZPgXdraNhaz4TQ3nO1Mgd
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="338151866"
X-IronPort-AV: E=Sophos;i="5.98,240,1673942400"; 
   d="scan'208";a="338151866"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 03:33:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="653947214"
X-IronPort-AV: E=Sophos;i="5.98,240,1673942400"; 
   d="scan'208";a="653947214"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 07 Mar 2023 03:33:03 -0800
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pZVZ0-0001GJ-0s;
        Tue, 07 Mar 2023 11:33:02 +0000
Date:   Tue, 7 Mar 2023 19:32:04 +0800
From:   kernel test robot <lkp@intel.com>
To:     Vipin Sharma <vipinsh@google.com>, seanjc@google.com,
        pbonzini@redhat.com, bgardon@google.com, dmatlack@google.com
Cc:     oe-kbuild-all@lists.linux.dev, jmattson@google.com,
        mizhang@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Subject: Re: [Patch v4 03/18] KVM: x86/mmu: Track count of pages in KVM MMU
 page caches globally
Message-ID: <202303071940.sFeQ4FpU-lkp@intel.com>
References: <20230306224127.1689967-4-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306224127.1689967-4-vipinsh@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vipin,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on kvm/queue]
[also build test WARNING on kvmarm/next linus/master v6.3-rc1 next-20230307]
[cannot apply to mst-vhost/linux-next kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Vipin-Sharma/KVM-x86-mmu-Change-KVM-mmu-shrinker-to-no-op/20230307-064510
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20230306224127.1689967-4-vipinsh%40google.com
patch subject: [Patch v4 03/18] KVM: x86/mmu: Track count of pages in KVM MMU page caches globally
config: i386-randconfig-a003-20230306 (https://download.01.org/0day-ci/archive/20230307/202303071940.sFeQ4FpU-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/511e837798da25063830276b8a3345c7601c6459
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Vipin-Sharma/KVM-x86-mmu-Change-KVM-mmu-shrinker-to-no-op/20230307-064510
        git checkout 511e837798da25063830276b8a3345c7601c6459
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 olddefconfig
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash arch/x86/kvm/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303071940.sFeQ4FpU-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/x86/kvm/mmu/mmu.c:676: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
    * Caller should hold mutex lock corresponding to cache, if available.
   arch/x86/kvm/mmu/mmu.c:693: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
    * Caller should hold mutex lock corresponding to kvm_mmu_memory_cache, if
   arch/x86/kvm/mmu/mmu.c:1404: warning: Function parameter or member 'kvm' not described in 'kvm_arch_mmu_enable_log_dirty_pt_masked'
   arch/x86/kvm/mmu/mmu.c:1404: warning: Function parameter or member 'slot' not described in 'kvm_arch_mmu_enable_log_dirty_pt_masked'
   arch/x86/kvm/mmu/mmu.c:1404: warning: Function parameter or member 'gfn_offset' not described in 'kvm_arch_mmu_enable_log_dirty_pt_masked'
   arch/x86/kvm/mmu/mmu.c:1404: warning: Function parameter or member 'mask' not described in 'kvm_arch_mmu_enable_log_dirty_pt_masked'


vim +676 arch/x86/kvm/mmu/mmu.c

   674	
   675	/**
 > 676	 * Caller should hold mutex lock corresponding to cache, if available.
   677	 */
   678	static int mmu_topup_sp_memory_cache(struct kvm_mmu_memory_cache *cache,
   679					     int min)
   680	{
   681		int orig_nobjs, r;
   682	
   683		orig_nobjs = cache->nobjs;
   684		r = kvm_mmu_topup_memory_cache(cache, min);
   685		if (orig_nobjs != cache->nobjs)
   686			percpu_counter_add(&kvm_total_unused_cached_pages,
   687					   (cache->nobjs - orig_nobjs));
   688	
   689		return r;
   690	}
   691	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
