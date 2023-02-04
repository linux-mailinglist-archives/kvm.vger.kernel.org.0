Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA0D68AA66
	for <lists+kvm@lfdr.de>; Sat,  4 Feb 2023 14:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233896AbjBDNyO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Feb 2023 08:54:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233846AbjBDNx4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Feb 2023 08:53:56 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9FEF37B79;
        Sat,  4 Feb 2023 05:53:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675518828; x=1707054828;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BwigBs1aMqtVp4Q9wvZ4hwv9KfZie/IcsgUZDHHV4Xk=;
  b=lRf8FL58rW0s9bVnW9XiKSqS1dGMNg47iQWa1rhfVlUXP1bhQvkMyU3M
   bFCPKoHTTAMjfOSMm9wO0vnbdy5Ba0XSThq+zVmPZPCoWjeMeV8aD+dGL
   sRh+CH6sNhq9a4lwhJeRWUhRIJRdjIYGHofXN+4Mu4zTjRbDeF6WfcW3i
   WtP0tU1ZVXqdoVD2Mm9z35x4wAixbvVzG23ujK7DSXkGX6OUZ1r1A6dK0
   cm+EqOQmrXmndAnYifRaR0V8jiUzU5XvZ0lmPbqqdWVSaw2GpdcomP3HN
   fMlf53bSgBTSDqr3kCjvoZO4lbwMAiKBixYYf2gIxZyU2KJ4wXp3XamCv
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="309279246"
X-IronPort-AV: E=Sophos;i="5.97,272,1669104000"; 
   d="scan'208";a="309279246"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2023 05:53:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="643564021"
X-IronPort-AV: E=Sophos;i="5.97,272,1669104000"; 
   d="scan'208";a="643564021"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 04 Feb 2023 05:53:45 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pOIzB-0001L8-00;
        Sat, 04 Feb 2023 13:53:45 +0000
Date:   Sat, 4 Feb 2023 21:52:49 +0800
From:   kernel test robot <lkp@intel.com>
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 11/21] KVM: x86/MMU: Cleanup shrinker interface with
 Shadow MMU
Message-ID: <202302042127.gbKNDVaL-lkp@intel.com>
References: <20230202182809.1929122-12-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202182809.1929122-12-bgardon@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ben,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on 7cb79f433e75b05d1635aefaa851cfcd1cb7dc4f]

url:    https://github.com/intel-lab-lkp/linux/commits/Ben-Gardon/KVM-x86-mmu-Rename-slot-rmap-walkers-to-add-clarity-and-clean-up-code/20230203-023259
base:   7cb79f433e75b05d1635aefaa851cfcd1cb7dc4f
patch link:    https://lore.kernel.org/r/20230202182809.1929122-12-bgardon%40google.com
patch subject: [PATCH 11/21] KVM: x86/MMU: Cleanup shrinker interface with Shadow MMU
config: x86_64-randconfig-a002 (https://download.01.org/0day-ci/archive/20230204/202302042127.gbKNDVaL-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/c1170de906dfe1ee64da0066e7c28d35e716ed18
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Ben-Gardon/KVM-x86-mmu-Rename-slot-rmap-walkers-to-add-clarity-and-clean-up-code/20230203-023259
        git checkout c1170de906dfe1ee64da0066e7c28d35e716ed18
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 olddefconfig
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash arch/x86/kvm/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> arch/x86/kvm/mmu/mmu.c:3148:15: warning: no previous prototype for 'mmu_shrink_scan' [-Wmissing-prototypes]
    3148 | unsigned long mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
         |               ^~~~~~~~~~~~~~~


vim +/mmu_shrink_scan +3148 arch/x86/kvm/mmu/mmu.c

  3147	
> 3148	unsigned long mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
  3149	{
  3150		struct kvm *kvm;
  3151		int nr_to_scan = sc->nr_to_scan;
  3152		unsigned long freed = 0;
  3153	
  3154		mutex_lock(&kvm_lock);
  3155	
  3156		list_for_each_entry(kvm, &vm_list, vm_list) {
  3157			/*
  3158			 * Never scan more than sc->nr_to_scan VM instances.
  3159			 * Will not hit this condition practically since we do not try
  3160			 * to shrink more than one VM and it is very unlikely to see
  3161			 * !n_used_mmu_pages so many times.
  3162			 */
  3163			if (!nr_to_scan--)
  3164				break;
  3165	
  3166			/*
  3167			 * n_used_mmu_pages is accessed without holding kvm->mmu_lock
  3168			 * here. We may skip a VM instance errorneosly, but we do not
  3169			 * want to shrink a VM that only started to populate its MMU
  3170			 * anyway.
  3171			 */
  3172			if (!kvm->arch.n_used_mmu_pages &&
  3173			    !kvm_shadow_mmu_has_zapped_obsolete_pages(kvm))
  3174				continue;
  3175	
  3176			freed = kvm_shadow_mmu_shrink_scan(kvm, sc->nr_to_scan);
  3177	
  3178			/*
  3179			 * unfair on small ones
  3180			 * per-vm shrinkers cry out
  3181			 * sadness comes quickly
  3182			 */
  3183			list_move_tail(&kvm->vm_list, &vm_list);
  3184			break;
  3185		}
  3186	
  3187		mutex_unlock(&kvm_lock);
  3188		return freed;
  3189	}
  3190	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
