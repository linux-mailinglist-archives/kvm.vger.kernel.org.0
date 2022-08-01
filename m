Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBD25867D2
	for <lists+kvm@lfdr.de>; Mon,  1 Aug 2022 12:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbiHAKud (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 06:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbiHAKub (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 06:50:31 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88F95F61
        for <kvm@vger.kernel.org>; Mon,  1 Aug 2022 03:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659351030; x=1690887030;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=f3v1ux66m7a2ihMBXUXzNx+w88ZVMkW229GNzM/Kzkc=;
  b=MBWQN2zG0wftoZJILZB65hN383P0qskMr8RyRRGXjR6IEzbf6HiDDiXF
   31qw+5yjjn6Ylup9SpPbvteWhx0W4rAf0xIvgFwsGPzPDCatsmSVxK3jQ
   bXvSAOeAgdS5CLy/ZrRIk/hrJ5NhEU94EsCXKu1mioGq8dtlqvAGn7HE+
   qrybIOKvX9oiRiShMEJxYfq48EF2oHXyovNmBTAbBasF7jstrej0S2wTZ
   IUE64aWC9vnYanuTdS5OrG6xjwjSC4a/FM5uYH3gxGFrHVnictLNWm1PH
   l5ah9X7/BMTt8gvKYl3I0E0fM0vAoVp8ESI6h9sORg6TOPpbuFhrnFxbf
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10425"; a="353119969"
X-IronPort-AV: E=Sophos;i="5.93,206,1654585200"; 
   d="scan'208";a="353119969"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2022 03:50:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,206,1654585200"; 
   d="scan'208";a="552474649"
Received: from lkp-server01.sh.intel.com (HELO e0eace57cfef) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 01 Aug 2022 03:50:27 -0700
Received: from kbuild by e0eace57cfef with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oIT0F-000F2h-0n;
        Mon, 01 Aug 2022 10:50:27 +0000
Date:   Mon, 1 Aug 2022 18:50:03 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: [kvm:queue 15/59] arch/x86/kvm/mmu/mmu.c:6391:12: warning: variable
 'pfn' set but not used
Message-ID: <202208011816.5DCA1Eta-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HEXHASH_WORD,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
head:   93472b79715378a2386598d6632c654a2223267b
commit: a8ac499bb6abbd55fe60f1dc2d053f4b5b13aa73 [15/59] KVM: x86/mmu: Don't require refcounted "struct page" to create huge SPTEs
config: x86_64-randconfig-a001-20220801 (https://download.01.org/0day-ci/archive/20220801/202208011816.5DCA1Eta-lkp@intel.com/config)
compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project 52cd00cabf479aa7eb6dbb063b7ba41ea57bce9e)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=a8ac499bb6abbd55fe60f1dc2d053f4b5b13aa73
        git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
        git fetch --no-tags kvm queue
        git checkout a8ac499bb6abbd55fe60f1dc2d053f4b5b13aa73
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash arch/x86/kvm/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> arch/x86/kvm/mmu/mmu.c:6391:12: warning: variable 'pfn' set but not used [-Wunused-but-set-variable]
           kvm_pfn_t pfn;
                     ^
   1 warning generated.


vim +/pfn +6391 arch/x86/kvm/mmu/mmu.c

a3fe5dbda0a4bb arch/x86/kvm/mmu/mmu.c David Matlack       2022-01-19  6383  
3ea3b7fa9af067 arch/x86/kvm/mmu.c     Wanpeng Li          2015-04-03  6384  static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
0a234f5dd06582 arch/x86/kvm/mmu/mmu.c Sean Christopherson 2021-02-12  6385  					 struct kvm_rmap_head *rmap_head,
269e9552d20817 arch/x86/kvm/mmu/mmu.c Hamza Mahfooz       2021-07-12  6386  					 const struct kvm_memory_slot *slot)
3ea3b7fa9af067 arch/x86/kvm/mmu.c     Wanpeng Li          2015-04-03  6387  {
3ea3b7fa9af067 arch/x86/kvm/mmu.c     Wanpeng Li          2015-04-03  6388  	u64 *sptep;
3ea3b7fa9af067 arch/x86/kvm/mmu.c     Wanpeng Li          2015-04-03  6389  	struct rmap_iterator iter;
3ea3b7fa9af067 arch/x86/kvm/mmu.c     Wanpeng Li          2015-04-03  6390  	int need_tlb_flush = 0;
ba049e93aef7e8 arch/x86/kvm/mmu.c     Dan Williams        2016-01-15 @6391  	kvm_pfn_t pfn;
3ea3b7fa9af067 arch/x86/kvm/mmu.c     Wanpeng Li          2015-04-03  6392  	struct kvm_mmu_page *sp;
3ea3b7fa9af067 arch/x86/kvm/mmu.c     Wanpeng Li          2015-04-03  6393  
0d5367900a319a arch/x86/kvm/mmu.c     Xiao Guangrong      2015-05-13  6394  restart:
018aabb56d6109 arch/x86/kvm/mmu.c     Takuya Yoshikawa    2015-11-20  6395  	for_each_rmap_spte(rmap_head, &iter, sptep) {
573546820b792e arch/x86/kvm/mmu/mmu.c Sean Christopherson 2020-06-22  6396  		sp = sptep_to_sp(sptep);
3ea3b7fa9af067 arch/x86/kvm/mmu.c     Wanpeng Li          2015-04-03  6397  		pfn = spte_to_pfn(*sptep);
3ea3b7fa9af067 arch/x86/kvm/mmu.c     Wanpeng Li          2015-04-03  6398  
3ea3b7fa9af067 arch/x86/kvm/mmu.c     Wanpeng Li          2015-04-03  6399  		/*
decf63336e3564 arch/x86/kvm/mmu.c     Xiao Guangrong      2015-04-14  6400  		 * We cannot do huge page mapping for indirect shadow pages,
decf63336e3564 arch/x86/kvm/mmu.c     Xiao Guangrong      2015-04-14  6401  		 * which are found on the last rmap (level = 1) when not using
decf63336e3564 arch/x86/kvm/mmu.c     Xiao Guangrong      2015-04-14  6402  		 * tdp; such shadow pages are synced with the page table in
decf63336e3564 arch/x86/kvm/mmu.c     Xiao Guangrong      2015-04-14  6403  		 * the guest, and the guest page table is using 4K page size
decf63336e3564 arch/x86/kvm/mmu.c     Xiao Guangrong      2015-04-14  6404  		 * mapping if the indirect sp has level = 1.
3ea3b7fa9af067 arch/x86/kvm/mmu.c     Wanpeng Li          2015-04-03  6405  		 */
5d49f08c2e08c1 arch/x86/kvm/mmu/mmu.c Sean Christopherson 2022-04-29  6406  		if (sp->role.direct &&
9eba50f8d7fcb6 arch/x86/kvm/mmu/mmu.c Sean Christopherson 2021-02-12  6407  		    sp->role.level < kvm_mmu_max_mapping_level(kvm, slot, sp->gfn,
a8ac499bb6abbd arch/x86/kvm/mmu/mmu.c Sean Christopherson 2022-07-15  6408  							       PG_LEVEL_NUM)) {
9202aee816c84d arch/x86/kvm/mmu/mmu.c Sean Christopherson 2022-07-15  6409  			kvm_zap_one_rmap_spte(kvm, rmap_head, sptep);
40ef75a758b291 arch/x86/kvm/mmu.c     Lan Tianyu          2018-12-06  6410  
40ef75a758b291 arch/x86/kvm/mmu.c     Lan Tianyu          2018-12-06  6411  			if (kvm_available_flush_tlb_with_range())
40ef75a758b291 arch/x86/kvm/mmu.c     Lan Tianyu          2018-12-06  6412  				kvm_flush_remote_tlbs_with_address(kvm, sp->gfn,
40ef75a758b291 arch/x86/kvm/mmu.c     Lan Tianyu          2018-12-06  6413  					KVM_PAGES_PER_HPAGE(sp->role.level));
40ef75a758b291 arch/x86/kvm/mmu.c     Lan Tianyu          2018-12-06  6414  			else
3ea3b7fa9af067 arch/x86/kvm/mmu.c     Wanpeng Li          2015-04-03  6415  				need_tlb_flush = 1;
40ef75a758b291 arch/x86/kvm/mmu.c     Lan Tianyu          2018-12-06  6416  
0d5367900a319a arch/x86/kvm/mmu.c     Xiao Guangrong      2015-05-13  6417  			goto restart;
0d5367900a319a arch/x86/kvm/mmu.c     Xiao Guangrong      2015-05-13  6418  		}
3ea3b7fa9af067 arch/x86/kvm/mmu.c     Wanpeng Li          2015-04-03  6419  	}
3ea3b7fa9af067 arch/x86/kvm/mmu.c     Wanpeng Li          2015-04-03  6420  
3ea3b7fa9af067 arch/x86/kvm/mmu.c     Wanpeng Li          2015-04-03  6421  	return need_tlb_flush;
3ea3b7fa9af067 arch/x86/kvm/mmu.c     Wanpeng Li          2015-04-03  6422  }
3ea3b7fa9af067 arch/x86/kvm/mmu.c     Wanpeng Li          2015-04-03  6423  

:::::: The code at line 6391 was first introduced by commit
:::::: ba049e93aef7e8c571567088b1b73f4f5b99272a kvm: rename pfn_t to kvm_pfn_t

:::::: TO: Dan Williams <dan.j.williams@intel.com>
:::::: CC: Linus Torvalds <torvalds@linux-foundation.org>

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
