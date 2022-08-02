Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E971E587716
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 08:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232948AbiHBG3L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 02:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231404AbiHBG3K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 02:29:10 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A361A06A
        for <kvm@vger.kernel.org>; Mon,  1 Aug 2022 23:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659421749; x=1690957749;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=vPiuaKeTp0x8Cuq6VsJqkXQzm9sKzyEZcIQ3/R99ico=;
  b=EnjjLL5UunnVWY4ZOxPetKmNSF1a3cXdbhzHozE4hvZ4XTEgpD1fyftZ
   +YNQPHfFC3VItM7ZtUsqCyDzqx5GHd6JXz/1iVqn+Q51G6jSSut8sev/o
   FpNsZNapsbISNRgNhmsPh/LoJKcBTAW0fKs5uo7fLYQdZRnucOTbwnbPh
   xkiZe7k6pN4Xqzt3KLgxsTI04PPCLtmiLjaHZ9nh1AMtc8ruysthggVqz
   BtdDQESIoxJdXKdGyHnamePreXix+X4BQBx2gNljuRJupDCHTQYJmUQoM
   ZgZIVQRIwA7/zDkPMkLn0mf06S3Zdoj5y/0EzNxGaHybhorJ/uBknCAAt
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10426"; a="288090217"
X-IronPort-AV: E=Sophos;i="5.93,210,1654585200"; 
   d="scan'208";a="288090217"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2022 23:29:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,210,1654585200"; 
   d="scan'208";a="661488931"
Received: from lkp-server01.sh.intel.com (HELO e0eace57cfef) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 01 Aug 2022 23:29:07 -0700
Received: from kbuild by e0eace57cfef with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oIlOt-000Flr-0B;
        Tue, 02 Aug 2022 06:29:07 +0000
Date:   Tue, 2 Aug 2022 14:28:34 +0800
From:   kernel test robot <lkp@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>
Subject: [kvm:queue 2/3] arch/riscv/kvm/mmu.c:355:75: error: expected '}'
 before ';' token
Message-ID: <202208021421.qOE4UXM6-lkp@intel.com>
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
config: riscv-rv32_defconfig (https://download.01.org/0day-ci/archive/20220802/202208021421.qOE4UXM6-lkp@intel.com/config)
compiler: riscv32-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=24688433d2ef9b65af51aa065f649b5f891f6961
        git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
        git fetch --no-tags kvm queue
        git checkout 24688433d2ef9b65af51aa065f649b5f891f6961
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash arch/riscv/kvm/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   arch/riscv/kvm/mmu.c: In function 'kvm_riscv_gstage_ioremap':
>> arch/riscv/kvm/mmu.c:355:75: error: expected '}' before ';' token
     355 |                 .gfp_custom = (in_atomic) ? GFP_ATOMIC | __GFP_ACCOUNT : 0;
         |                                                                           ^
   arch/riscv/kvm/mmu.c:354:46: note: to match this '{'
     354 |         struct kvm_mmu_memory_cache pcache = {
         |                                              ^


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
   356			.gfp_zero = __GFP_ZERO;
   357		};
   358	
   359		end = (gpa + size + PAGE_SIZE - 1) & PAGE_MASK;
   360		pfn = __phys_to_pfn(hpa);
   361	
   362		for (addr = gpa; addr < end; addr += PAGE_SIZE) {
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
   381	out:
   382		kvm_mmu_free_memory_cache(&pcache);
   383		return ret;
   384	}
   385	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
