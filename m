Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0B4A4FA4B4
	for <lists+kvm@lfdr.de>; Sat,  9 Apr 2022 07:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbiDIFDv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Apr 2022 01:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241040AbiDIEzI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Apr 2022 00:55:08 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A56EACA7
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 21:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649479918; x=1681015918;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=m99myn4BC7BodDsZQ+mdhI1ipOS8W0CNzPn/MvEXBi8=;
  b=DHbz0HX3Mc/YXsGCsJE9Sga4GmVmT137PPGfwjuRwx5YEQIjT1Sx6QvU
   hWIXfXv5945MUhmc6z2W4EYl9stfSDUkzGufv9wmWZ2gA+ZfIsuOralE6
   J/NpJ09Oe+5sZq/i4U6xDzbLyfz/0UMSzJUGfaJXAx814+3mwaRlALkeT
   VU691SGmZhKMAOUQBJK/l/hZiJAhr9rI8UySq/WICjDcJdiSn8mitJhxp
   OIBlkabsqi5QHtUtPRTFcDOp8azaaI1frp8qrCKX15OYZjd+yzVqZk4BS
   S6iJWzYuBNnTnFhQB6DmhfOajOVwLs/tliAJynYAQEv75mz1X9pxWu1jK
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10311"; a="261938691"
X-IronPort-AV: E=Sophos;i="5.90,247,1643702400"; 
   d="scan'208";a="261938691"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 21:51:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,247,1643702400"; 
   d="scan'208";a="558083757"
Received: from lkp-server02.sh.intel.com (HELO 7e80bc2a00a0) ([10.239.97.151])
  by fmsmga007.fm.intel.com with ESMTP; 08 Apr 2022 21:51:56 -0700
Received: from kbuild by 7e80bc2a00a0 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nd34l-0000sV-ES;
        Sat, 09 Apr 2022 04:51:55 +0000
Date:   Sat, 9 Apr 2022 12:51:04 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm:queue 19/54] arch/x86/kvm/mmu/paging_tmpl.h:532:8: error: use
 of undeclared identifier 'EPT_VIOLATION_RWX_SHIFT'
Message-ID: <202204091254.FzYg6D71-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
head:   59d9e75d641565603e7c293f4cec182d86db8586
commit: 68ca1f59584e5793a3949d8806f683f9245d33f9 [19/54] KVM: x86/mmu: Derive EPT violation RWX bits from EPTE RWX bits
config: x86_64-randconfig-a014 (https://download.01.org/0day-ci/archive/20220409/202204091254.FzYg6D71-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project c29a51b3a257908aebc01cd7c4655665db317d66)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=68ca1f59584e5793a3949d8806f683f9245d33f9
        git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
        git fetch --no-tags kvm queue
        git checkout 68ca1f59584e5793a3949d8806f683f9245d33f9
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from arch/x86/kvm/mmu/mmu.c:4259:
>> arch/x86/kvm/mmu/paging_tmpl.h:532:8: error: use of undeclared identifier 'EPT_VIOLATION_RWX_SHIFT'
                                                    EPT_VIOLATION_RWX_SHIFT;
                                                    ^
   1 error generated.
--
>> arch/x86/kvm/vmx/vmx.c:5408:38: error: use of undeclared identifier 'EPT_VIOLATION_RWX_SHIFT'
           error_code |= (exit_qualification & EPT_VIOLATION_RWX_MASK)
                                               ^
   arch/x86/include/asm/vmx.h:551:54: note: expanded from macro 'EPT_VIOLATION_RWX_MASK'
   #define EPT_VIOLATION_RWX_MASK          (VMX_EPT_RWX_MASK << EPT_VIOLATION_RWX_SHIFT)
                                                                ^
   1 error generated.


vim +/EPT_VIOLATION_RWX_SHIFT +532 arch/x86/kvm/mmu/paging_tmpl.h

   301	
   302	static inline bool FNAME(is_last_gpte)(struct kvm_mmu *mmu,
   303					       unsigned int level, unsigned int gpte)
   304	{
   305		/*
   306		 * For EPT and PAE paging (both variants), bit 7 is either reserved at
   307		 * all level or indicates a huge page (ignoring CR3/EPTP).  In either
   308		 * case, bit 7 being set terminates the walk.
   309		 */
   310	#if PTTYPE == 32
   311		/*
   312		 * 32-bit paging requires special handling because bit 7 is ignored if
   313		 * CR4.PSE=0, not reserved.  Clear bit 7 in the gpte if the level is
   314		 * greater than the last level for which bit 7 is the PAGE_SIZE bit.
   315		 *
   316		 * The RHS has bit 7 set iff level < (2 + PSE).  If it is clear, bit 7
   317		 * is not reserved and does not indicate a large page at this level,
   318		 * so clear PT_PAGE_SIZE_MASK in gpte if that is the case.
   319		 */
   320		gpte &= level - (PT32_ROOT_LEVEL + mmu->mmu_role.ext.cr4_pse);
   321	#endif
   322		/*
   323		 * PG_LEVEL_4K always terminates.  The RHS has bit 7 set
   324		 * iff level <= PG_LEVEL_4K, which for our purpose means
   325		 * level == PG_LEVEL_4K; set PT_PAGE_SIZE_MASK in gpte then.
   326		 */
   327		gpte |= level - PG_LEVEL_4K - 1;
   328	
   329		return gpte & PT_PAGE_SIZE_MASK;
   330	}
   331	/*
   332	 * Fetch a guest pte for a guest virtual address, or for an L2's GPA.
   333	 */
   334	static int FNAME(walk_addr_generic)(struct guest_walker *walker,
   335					    struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
   336					    gpa_t addr, u64 access)
   337	{
   338		int ret;
   339		pt_element_t pte;
   340		pt_element_t __user *ptep_user;
   341		gfn_t table_gfn;
   342		u64 pt_access, pte_access;
   343		unsigned index, accessed_dirty, pte_pkey;
   344		u64 nested_access;
   345		gpa_t pte_gpa;
   346		bool have_ad;
   347		int offset;
   348		u64 walk_nx_mask = 0;
   349		const int write_fault = access & PFERR_WRITE_MASK;
   350		const int user_fault  = access & PFERR_USER_MASK;
   351		const int fetch_fault = access & PFERR_FETCH_MASK;
   352		u16 errcode = 0;
   353		gpa_t real_gpa;
   354		gfn_t gfn;
   355	
   356		trace_kvm_mmu_pagetable_walk(addr, access);
   357	retry_walk:
   358		walker->level = mmu->root_level;
   359		pte           = mmu->get_guest_pgd(vcpu);
   360		have_ad       = PT_HAVE_ACCESSED_DIRTY(mmu);
   361	
   362	#if PTTYPE == 64
   363		walk_nx_mask = 1ULL << PT64_NX_SHIFT;
   364		if (walker->level == PT32E_ROOT_LEVEL) {
   365			pte = mmu->get_pdptr(vcpu, (addr >> 30) & 3);
   366			trace_kvm_mmu_paging_element(pte, walker->level);
   367			if (!FNAME(is_present_gpte)(pte))
   368				goto error;
   369			--walker->level;
   370		}
   371	#endif
   372		walker->max_level = walker->level;
   373		ASSERT(!(is_long_mode(vcpu) && !is_pae(vcpu)));
   374	
   375		/*
   376		 * FIXME: on Intel processors, loads of the PDPTE registers for PAE paging
   377		 * by the MOV to CR instruction are treated as reads and do not cause the
   378		 * processor to set the dirty flag in any EPT paging-structure entry.
   379		 */
   380		nested_access = (have_ad ? PFERR_WRITE_MASK : 0) | PFERR_USER_MASK;
   381	
   382		pte_access = ~0;
   383		++walker->level;
   384	
   385		do {
   386			unsigned long host_addr;
   387	
   388			pt_access = pte_access;
   389			--walker->level;
   390	
   391			index = PT_INDEX(addr, walker->level);
   392			table_gfn = gpte_to_gfn(pte);
   393			offset    = index * sizeof(pt_element_t);
   394			pte_gpa   = gfn_to_gpa(table_gfn) + offset;
   395	
   396			BUG_ON(walker->level < 1);
   397			walker->table_gfn[walker->level - 1] = table_gfn;
   398			walker->pte_gpa[walker->level - 1] = pte_gpa;
   399	
   400			real_gpa = kvm_translate_gpa(vcpu, mmu, gfn_to_gpa(table_gfn),
   401						     nested_access, &walker->fault);
   402	
   403			/*
   404			 * FIXME: This can happen if emulation (for of an INS/OUTS
   405			 * instruction) triggers a nested page fault.  The exit
   406			 * qualification / exit info field will incorrectly have
   407			 * "guest page access" as the nested page fault's cause,
   408			 * instead of "guest page structure access".  To fix this,
   409			 * the x86_exception struct should be augmented with enough
   410			 * information to fix the exit_qualification or exit_info_1
   411			 * fields.
   412			 */
   413			if (unlikely(real_gpa == UNMAPPED_GVA))
   414				return 0;
   415	
   416			host_addr = kvm_vcpu_gfn_to_hva_prot(vcpu, gpa_to_gfn(real_gpa),
   417						    &walker->pte_writable[walker->level - 1]);
   418			if (unlikely(kvm_is_error_hva(host_addr)))
   419				goto error;
   420	
   421			ptep_user = (pt_element_t __user *)((void *)host_addr + offset);
   422			if (unlikely(__get_user(pte, ptep_user)))
   423				goto error;
   424			walker->ptep_user[walker->level - 1] = ptep_user;
   425	
   426			trace_kvm_mmu_paging_element(pte, walker->level);
   427	
   428			/*
   429			 * Inverting the NX it lets us AND it like other
   430			 * permission bits.
   431			 */
   432			pte_access = pt_access & (pte ^ walk_nx_mask);
   433	
   434			if (unlikely(!FNAME(is_present_gpte)(pte)))
   435				goto error;
   436	
   437			if (unlikely(FNAME(is_rsvd_bits_set)(mmu, pte, walker->level))) {
   438				errcode = PFERR_RSVD_MASK | PFERR_PRESENT_MASK;
   439				goto error;
   440			}
   441	
   442			walker->ptes[walker->level - 1] = pte;
   443	
   444			/* Convert to ACC_*_MASK flags for struct guest_walker.  */
   445			walker->pt_access[walker->level - 1] = FNAME(gpte_access)(pt_access ^ walk_nx_mask);
   446		} while (!FNAME(is_last_gpte)(mmu, walker->level, pte));
   447	
   448		pte_pkey = FNAME(gpte_pkeys)(vcpu, pte);
   449		accessed_dirty = have_ad ? pte_access & PT_GUEST_ACCESSED_MASK : 0;
   450	
   451		/* Convert to ACC_*_MASK flags for struct guest_walker.  */
   452		walker->pte_access = FNAME(gpte_access)(pte_access ^ walk_nx_mask);
   453		errcode = permission_fault(vcpu, mmu, walker->pte_access, pte_pkey, access);
   454		if (unlikely(errcode))
   455			goto error;
   456	
   457		gfn = gpte_to_gfn_lvl(pte, walker->level);
   458		gfn += (addr & PT_LVL_OFFSET_MASK(walker->level)) >> PAGE_SHIFT;
   459	
   460		if (PTTYPE == 32 && walker->level > PG_LEVEL_4K && is_cpuid_PSE36())
   461			gfn += pse36_gfn_delta(pte);
   462	
   463		real_gpa = kvm_translate_gpa(vcpu, mmu, gfn_to_gpa(gfn), access, &walker->fault);
   464		if (real_gpa == UNMAPPED_GVA)
   465			return 0;
   466	
   467		walker->gfn = real_gpa >> PAGE_SHIFT;
   468	
   469		if (!write_fault)
   470			FNAME(protect_clean_gpte)(mmu, &walker->pte_access, pte);
   471		else
   472			/*
   473			 * On a write fault, fold the dirty bit into accessed_dirty.
   474			 * For modes without A/D bits support accessed_dirty will be
   475			 * always clear.
   476			 */
   477			accessed_dirty &= pte >>
   478				(PT_GUEST_DIRTY_SHIFT - PT_GUEST_ACCESSED_SHIFT);
   479	
   480		if (unlikely(!accessed_dirty)) {
   481			ret = FNAME(update_accessed_dirty_bits)(vcpu, mmu, walker,
   482								addr, write_fault);
   483			if (unlikely(ret < 0))
   484				goto error;
   485			else if (ret)
   486				goto retry_walk;
   487		}
   488	
   489		pgprintk("%s: pte %llx pte_access %x pt_access %x\n",
   490			 __func__, (u64)pte, walker->pte_access,
   491			 walker->pt_access[walker->level - 1]);
   492		return 1;
   493	
   494	error:
   495		errcode |= write_fault | user_fault;
   496		if (fetch_fault && (is_efer_nx(mmu) || is_cr4_smep(mmu)))
   497			errcode |= PFERR_FETCH_MASK;
   498	
   499		walker->fault.vector = PF_VECTOR;
   500		walker->fault.error_code_valid = true;
   501		walker->fault.error_code = errcode;
   502	
   503	#if PTTYPE == PTTYPE_EPT
   504		/*
   505		 * Use PFERR_RSVD_MASK in error_code to to tell if EPT
   506		 * misconfiguration requires to be injected. The detection is
   507		 * done by is_rsvd_bits_set() above.
   508		 *
   509		 * We set up the value of exit_qualification to inject:
   510		 * [2:0] - Derive from the access bits. The exit_qualification might be
   511		 *         out of date if it is serving an EPT misconfiguration.
   512		 * [5:3] - Calculated by the page walk of the guest EPT page tables
   513		 * [7:8] - Derived from [7:8] of real exit_qualification
   514		 *
   515		 * The other bits are set to 0.
   516		 */
   517		if (!(errcode & PFERR_RSVD_MASK)) {
   518			vcpu->arch.exit_qualification &= (EPT_VIOLATION_GVA_IS_VALID |
   519							  EPT_VIOLATION_GVA_TRANSLATED);
   520			if (write_fault)
   521				vcpu->arch.exit_qualification |= EPT_VIOLATION_ACC_WRITE;
   522			if (user_fault)
   523				vcpu->arch.exit_qualification |= EPT_VIOLATION_ACC_READ;
   524			if (fetch_fault)
   525				vcpu->arch.exit_qualification |= EPT_VIOLATION_ACC_INSTR;
   526	
   527			/*
   528			 * Note, pte_access holds the raw RWX bits from the EPTE, not
   529			 * ACC_*_MASK flags!
   530			 */
   531			vcpu->arch.exit_qualification |= (pte_access & VMX_EPT_RWX_MASK) <<
 > 532							 EPT_VIOLATION_RWX_SHIFT;
   533		}
   534	#endif
   535		walker->fault.address = addr;
   536		walker->fault.nested_page_fault = mmu != vcpu->arch.walk_mmu;
   537		walker->fault.async_page_fault = false;
   538	
   539		trace_kvm_mmu_walker_error(walker->fault.error_code);
   540		return 0;
   541	}
   542	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
