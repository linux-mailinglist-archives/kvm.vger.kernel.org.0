Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09A557B2DB1
	for <lists+kvm@lfdr.de>; Fri, 29 Sep 2023 10:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232838AbjI2IUf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Sep 2023 04:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbjI2IUe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Sep 2023 04:20:34 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA2511AC;
        Fri, 29 Sep 2023 01:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695975631; x=1727511631;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3Sbjr4bWWU8vPLpeQtrtcmY71cQMw2ZI0PYPYGnshE8=;
  b=BgTuBBQ7ikRnMPf7yJ4997Xb0F+SNknoCqL6m2GOkmyH+MugKpahyNj0
   VVLpBlm9NNA24gM99tJmcUFYfMe2/cCQCJk3Orz0dmOfCWtxHCbRi1FX1
   I4IPBmZiU+3rmiAg2rBLSXRI8qNzZuCaTwpLdVXqF31c7oic8iXeGhhE9
   Vl1TIcG/2pezD6Z9CGGTvEPzgVDjUMXu4R7dO5iqk/YeuwrkQwqfsYEgg
   zoyEZ9aHR5PfMTedNFNXE2YydY173ygq7mIUZt8eIoKGdVVKsoqjN0Sv9
   ai5cKLm7XoxTYghZdUcjvptR6G1C7cVS59nxkDS7+bI53rJ0GsO+x5ILI
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10847"; a="379521645"
X-IronPort-AV: E=Sophos;i="6.03,186,1694761200"; 
   d="scan'208";a="379521645"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2023 00:30:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10847"; a="840199144"
X-IronPort-AV: E=Sophos;i="6.03,186,1694761200"; 
   d="scan'208";a="840199144"
Received: from lkp-server02.sh.intel.com (HELO c3b01524d57c) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Sep 2023 00:30:38 -0700
Received: from kbuild by c3b01524d57c with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qm7xM-0002aX-17;
        Fri, 29 Sep 2023 07:30:36 +0000
Date:   Fri, 29 Sep 2023 15:30:21 +0800
From:   kernel test robot <lkp@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 3/3] KVM: x86/mmu: always take tdp_mmu_pages_lock
Message-ID: <202309291557.Eq3JDvT6-lkp@intel.com>
References: <20230928162959.1514661-4-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230928162959.1514661-4-pbonzini@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

kernel test robot noticed the following build warnings:

[auto build test WARNING on kvm/queue]
[also build test WARNING on linus/master v6.6-rc3 next-20230929]
[cannot apply to mst-vhost/linux-next kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Paolo-Bonzini/KVM-x86-mmu-remove-unnecessary-bool-shared-argument-from-functions/20230929-003259
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20230928162959.1514661-4-pbonzini%40redhat.com
patch subject: [PATCH 3/3] KVM: x86/mmu: always take tdp_mmu_pages_lock
config: x86_64-buildonly-randconfig-004-20230929 (https://download.01.org/0day-ci/archive/20230929/202309291557.Eq3JDvT6-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20230929/202309291557.Eq3JDvT6-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202309291557.Eq3JDvT6-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/x86/kvm/mmu/tdp_mmu.c:289: warning: Excess function parameter 'shared' description in 'tdp_mmu_unlink_sp'


vim +289 arch/x86/kvm/mmu/tdp_mmu.c

43a063cab325ee7 Yosry Ahmed         2022-08-23  278  
a9442f594147f95 Ben Gardon          2021-02-02  279  /**
c298a30c2821cb0 David Matlack       2022-01-19  280   * tdp_mmu_unlink_sp() - Remove a shadow page from the list of used pages
a9442f594147f95 Ben Gardon          2021-02-02  281   *
a9442f594147f95 Ben Gardon          2021-02-02  282   * @kvm: kvm instance
a9442f594147f95 Ben Gardon          2021-02-02  283   * @sp: the page to be removed
9a77daacc87dee9 Ben Gardon          2021-02-02  284   * @shared: This operation may not be running under the exclusive use of
9a77daacc87dee9 Ben Gardon          2021-02-02  285   *	    the MMU lock and the operation must synchronize with other
9a77daacc87dee9 Ben Gardon          2021-02-02  286   *	    threads that might be adding or removing pages.
a9442f594147f95 Ben Gardon          2021-02-02  287   */
44f1ce87ebc1ca1 Paolo Bonzini       2023-09-28  288  static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
a9442f594147f95 Ben Gardon          2021-02-02 @289  {
44f1ce87ebc1ca1 Paolo Bonzini       2023-09-28  290  	lockdep_assert_held(&kvm->mmu_lock);
44f1ce87ebc1ca1 Paolo Bonzini       2023-09-28  291  
43a063cab325ee7 Yosry Ahmed         2022-08-23  292  	tdp_unaccount_mmu_page(kvm, sp);
d25ceb9264364dc Sean Christopherson 2022-10-19  293  
d25ceb9264364dc Sean Christopherson 2022-10-19  294  	if (!sp->nx_huge_page_disallowed)
d25ceb9264364dc Sean Christopherson 2022-10-19  295  		return;
d25ceb9264364dc Sean Christopherson 2022-10-19  296  
9a77daacc87dee9 Ben Gardon          2021-02-02  297  	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
61f94478547bb4f Sean Christopherson 2022-10-19  298  	sp->nx_huge_page_disallowed = false;
61f94478547bb4f Sean Christopherson 2022-10-19  299  	untrack_possible_nx_huge_page(kvm, sp);
9a77daacc87dee9 Ben Gardon          2021-02-02  300  	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
a9442f594147f95 Ben Gardon          2021-02-02  301  }
a9442f594147f95 Ben Gardon          2021-02-02  302  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
