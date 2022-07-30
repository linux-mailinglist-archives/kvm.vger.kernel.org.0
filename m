Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74798585A63
	for <lists+kvm@lfdr.de>; Sat, 30 Jul 2022 14:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234149AbiG3MUJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Jul 2022 08:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbiG3MUI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Jul 2022 08:20:08 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB52A19B
        for <kvm@vger.kernel.org>; Sat, 30 Jul 2022 05:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659183606; x=1690719606;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=pCLGv3g2wk0CNIr1FfigMKEt3WZnTGnj6YVJwIPCAmo=;
  b=UPb2YjzXUyviY4LgD4GJj4gUGZbToUHQHW4h3LZgi6Y9pdBORoX74aLq
   AEzPxiyiDxrPiDt2f0NPT94FvlzRp5sxmufYe4b2a1iZ4MB1Ljz84zBPW
   z6x7jJpawtN9SUU8v/7hA78OOqAyXB2wvmxTHJMczDqHMpq5cbB4V4pXc
   9WbTKuUbQNYlbD+OMi6UHJnmWq8souUlIPOZ3WZ+r4po4Ek7ClEZnBrYg
   m6OVJA4X9/ENK5tUwaiHT9Ee1amSFU5CW+qwLPv+Baq/ONPahgs+yi7Jy
   f+AymWXSeUIpc9Kojfv0hoeRUx+ecYn1psTXG/OMAcF2nf4E9NoZLvLMc
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10423"; a="269296677"
X-IronPort-AV: E=Sophos;i="5.93,204,1654585200"; 
   d="scan'208";a="269296677"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2022 05:20:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,204,1654585200"; 
   d="scan'208";a="743798736"
Received: from lkp-server01.sh.intel.com (HELO e0eace57cfef) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 30 Jul 2022 05:20:04 -0700
Received: from kbuild by e0eace57cfef with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oHlRr-000CoZ-3B;
        Sat, 30 Jul 2022 12:20:03 +0000
Date:   Sat, 30 Jul 2022 20:19:40 +0800
From:   kernel test robot <lkp@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>
Subject: [kvm:queue 2/3] arch/riscv/kvm/mmu.c:355:61: error: expected '}'
Message-ID: <202207302002.opeObPd2-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
head:   93472b79715378a2386598d6632c654a2223267b
commit: 24688433d2ef9b65af51aa065f649b5f891f6961 [2/3] Merge remote-tracking branch 'kvm/next' into kvm-next-5.20
config: riscv-randconfig-r012-20220729 (https://download.01.org/0day-ci/archive/20220730/202207302002.opeObPd2-lkp@intel.com/config)
compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project 52cd00cabf479aa7eb6dbb063b7ba41ea57bce9e)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install riscv cross compiling tool for clang build
        # apt-get install binutils-riscv64-linux-gnu
        # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=24688433d2ef9b65af51aa065f649b5f891f6961
        git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
        git fetch --no-tags kvm queue
        git checkout 24688433d2ef9b65af51aa065f649b5f891f6961
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash arch/riscv/kvm/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> arch/riscv/kvm/mmu.c:355:61: error: expected '}'
                   .gfp_custom = (in_atomic) ? GFP_ATOMIC | __GFP_ACCOUNT : 0;
                                                                             ^
   arch/riscv/kvm/mmu.c:354:39: note: to match this '{'
           struct kvm_mmu_memory_cache pcache = {
                                                ^
>> arch/riscv/kvm/mmu.c:356:3: error: expected expression
                   .gfp_zero = __GFP_ZERO;
                   ^
>> arch/riscv/kvm/mmu.c:359:2: error: type specifier missing, defaults to 'int'; ISO C99 and later do not support implicit int [-Wimplicit-int]
           end = (gpa + size + PAGE_SIZE - 1) & PAGE_MASK;
           ^
           int
>> arch/riscv/kvm/mmu.c:359:9: error: use of undeclared identifier 'gpa'
           end = (gpa + size + PAGE_SIZE - 1) & PAGE_MASK;
                  ^
>> arch/riscv/kvm/mmu.c:359:15: error: use of undeclared identifier 'size'
           end = (gpa + size + PAGE_SIZE - 1) & PAGE_MASK;
                        ^
   arch/riscv/kvm/mmu.c:360:2: error: type specifier missing, defaults to 'int'; ISO C99 and later do not support implicit int [-Wimplicit-int]
           pfn = __phys_to_pfn(hpa);
           ^
           int
>> arch/riscv/kvm/mmu.c:360:22: error: use of undeclared identifier 'hpa'
           pfn = __phys_to_pfn(hpa);
                               ^
>> arch/riscv/kvm/mmu.c:362:2: error: expected identifier or '('
           for (addr = gpa; addr < end; addr += PAGE_SIZE) {
           ^
   arch/riscv/kvm/mmu.c:381:1: error: type specifier missing, defaults to 'int'; ISO C99 and later do not support implicit int [-Wimplicit-int]
   out:
   ^
   int
>> arch/riscv/kvm/mmu.c:381:4: error: expected ';' after top level declarator
   out:
      ^
      ;
>> arch/riscv/kvm/mmu.c:382:28: error: expected parameter declarator
           kvm_mmu_free_memory_cache(&pcache);
                                     ^
>> arch/riscv/kvm/mmu.c:382:28: error: expected ')'
   arch/riscv/kvm/mmu.c:382:27: note: to match this '('
           kvm_mmu_free_memory_cache(&pcache);
                                    ^
   arch/riscv/kvm/mmu.c:382:2: error: type specifier missing, defaults to 'int'; ISO C99 and later do not support implicit int [-Wimplicit-int]
           kvm_mmu_free_memory_cache(&pcache);
           ^
           int
>> arch/riscv/kvm/mmu.c:382:27: error: a function declaration without a prototype is deprecated in all versions of C [-Werror,-Wstrict-prototypes]
           kvm_mmu_free_memory_cache(&pcache);
                                    ^
                                            void
>> arch/riscv/kvm/mmu.c:382:2: error: a function declaration without a prototype is deprecated in all versions of C and is treated as a zero-parameter prototype in C2x, conflicting with a previous declaration [-Werror,-Wdeprecated-non-prototype]
           kvm_mmu_free_memory_cache(&pcache);
           ^
   include/linux/kvm_host.h:1356:6: note: conflicting prototype is here
   void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc);
        ^
>> arch/riscv/kvm/mmu.c:382:2: error: conflicting types for 'kvm_mmu_free_memory_cache'
           kvm_mmu_free_memory_cache(&pcache);
           ^
   include/linux/kvm_host.h:1356:6: note: previous declaration is here
   void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc);
        ^
   arch/riscv/kvm/mmu.c:383:2: error: expected identifier or '('
           return ret;
           ^
>> arch/riscv/kvm/mmu.c:384:1: error: extraneous closing brace ('}')
   }
   ^
   18 errors generated.


vim +355 arch/riscv/kvm/mmu.c

   345	
   346	int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
   347				     phys_addr_t hpa, unsigned long size,
   348				     bool writable, bool in_atomic)
   349	{
   350		pte_t pte;
   351		int ret = 0;
   352		unsigned long pfn;
   353		phys_addr_t addr, end;
   354		struct kvm_mmu_memory_cache pcache = {
 > 355			.gfp_custom = (in_atomic) ? GFP_ATOMIC | __GFP_ACCOUNT : 0;
 > 356			.gfp_zero = __GFP_ZERO;
   357		};
   358	
 > 359		end = (gpa + size + PAGE_SIZE - 1) & PAGE_MASK;
 > 360		pfn = __phys_to_pfn(hpa);
   361	
 > 362		for (addr = gpa; addr < end; addr += PAGE_SIZE) {
   363			pte = pfn_pte(pfn, PAGE_KERNEL_IO);
   364	
   365			if (!writable)
   366				pte = pte_wrprotect(pte);
   367	
   368			ret = kvm_mmu_topup_memory_cache(&pcache, gstage_pgd_levels);
   369			if (ret)
   370				goto out;
   371	
   372			spin_lock(&kvm->mmu_lock);
   373			ret = gstage_set_pte(kvm, 0, &pcache, addr, &pte);
   374			spin_unlock(&kvm->mmu_lock);
   375			if (ret)
   376				goto out;
   377	
   378			pfn++;
   379		}
   380	
 > 381	out:
 > 382		kvm_mmu_free_memory_cache(&pcache);
   383		return ret;
 > 384	}
   385	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
