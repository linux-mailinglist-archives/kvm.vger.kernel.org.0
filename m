Return-Path: <kvm+bounces-49559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B5380AD9D46
	for <lists+kvm@lfdr.de>; Sat, 14 Jun 2025 16:05:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 073D13B955D
	for <lists+kvm@lfdr.de>; Sat, 14 Jun 2025 14:04:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 420102C3258;
	Sat, 14 Jun 2025 14:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T0MjElQE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA63E282E1;
	Sat, 14 Jun 2025 14:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749909898; cv=none; b=qbQa083kDgx8NBcoyjKAORmTjK5dJ3LT0XurdWgQGTmwho+8r+j3m64VdcsADzhSybnD8xMjd0cGjdTW3RZ4HHoidK2Kioi0tb7rTwPsbWTBdLAjnqUrINjwjxofHW+O76JiTe6WosyTzS5lmjV+zot7vqSpVRO/JAanbEI4vFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749909898; c=relaxed/simple;
	bh=xm5tcvEy40uXYu7d3Dn0xgyv2xe6et8D2Xd+tZ6+Fzw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JHtV2PEMQUy0b6WO9+83X/MF1USmlfZA0zQNStykBmg7hfVj6kMvtKdsh0FidkKBygn/OggprOeiWa0Pf0LEUv3OpkBoU4Vg/hi4n/B5Axoq202nNVR57dzKolqT+N0uJsAGEvwwpyIegqz0Hne6DPRQm98j2zPk4cJMTHc4N9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T0MjElQE; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749909897; x=1781445897;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xm5tcvEy40uXYu7d3Dn0xgyv2xe6et8D2Xd+tZ6+Fzw=;
  b=T0MjElQEFBi/XButvn2xHnZPi3sXKkh44Ky9BK0VSJlieoUuzgeW8u6Q
   eJ+lffgz7AGjQcbUuxk2ojqqdQ9hm+309hd9oVS9FNBH3exUYKdyQBDqR
   JCwwwJ/zqjkWyAn1hHyu0nPxJRemimYsBjHEhe3/TJ2RJUS/r2swc4mVb
   mhQuxfu4mKeAILsqdxHZjZEqnTV1c+diP7CWqUs6nu1782XkdtDTobESQ
   PznnPxd8fH3NrlTqnLj0chCOiZ6AtvEGqxd6Le99BYHIUzLS7D9MhPyVF
   +KBkDiGZUMW1R6lBtP+Y+nJMHH144zC9dUVhP+As/nP1YuXwQ1z8IMDNe
   A==;
X-CSE-ConnectionGUID: q6Ce1nXCR1uVFGPpYLCAmQ==
X-CSE-MsgGUID: PGUf3CNySimJwknI/wYqWA==
X-IronPort-AV: E=McAfee;i="6800,10657,11464"; a="63462486"
X-IronPort-AV: E=Sophos;i="6.16,236,1744095600"; 
   d="scan'208";a="63462486"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2025 07:04:56 -0700
X-CSE-ConnectionGUID: JmHiYuqzSYyxp9TLdbfcxw==
X-CSE-MsgGUID: LmI3ZGq+RWS3SOIUtH2rvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,236,1744095600"; 
   d="scan'208";a="148445854"
Received: from lkp-server01.sh.intel.com (HELO e8142ee1dce2) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 14 Jun 2025 07:04:54 -0700
Received: from kbuild by e8142ee1dce2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uQRV6-000DYY-08;
	Sat, 14 Jun 2025 14:04:52 +0000
Date: Sat, 14 Jun 2025 22:03:52 +0800
From: kernel test robot <lkp@intel.com>
To: James Houghton <jthoughton@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Vipin Sharma <vipinsh@google.com>,
	David Matlack <dmatlack@google.com>,
	James Houghton <jthoughton@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/7] KVM: x86/mmu: Recover TDP MMU NX huge pages using
 MMU read lock
Message-ID: <202506142129.ClBlxdtW-lkp@intel.com>
References: <20250613202315.2790592-4-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250613202315.2790592-4-jthoughton@google.com>

Hi James,

kernel test robot noticed the following build errors:

[auto build test ERROR on 8046d29dde17002523f94d3e6e0ebe486ce52166]

url:    https://github.com/intel-lab-lkp/linux/commits/James-Houghton/KVM-x86-mmu-Track-TDP-MMU-NX-huge-pages-separately/20250614-042620
base:   8046d29dde17002523f94d3e6e0ebe486ce52166
patch link:    https://lore.kernel.org/r/20250613202315.2790592-4-jthoughton%40google.com
patch subject: [PATCH v4 3/7] KVM: x86/mmu: Recover TDP MMU NX huge pages using MMU read lock
config: i386-buildonly-randconfig-003-20250614 (https://download.01.org/0day-ci/archive/20250614/202506142129.ClBlxdtW-lkp@intel.com/config)
compiler: clang version 20.1.2 (https://github.com/llvm/llvm-project 58df0ef89dd64126512e4ee27b4ac3fd8ddf6247)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250614/202506142129.ClBlxdtW-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202506142129.ClBlxdtW-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/x86/kvm/mmu/mmu.c:7570:28: error: use of undeclared identifier 'KVM_TDP_MMU'
    7570 |         bool is_tdp = mmu_type == KVM_TDP_MMU;
         |                                   ^
>> arch/x86/kvm/mmu/mmu.c:7594:25: error: no member named 'tdp_mmu_pages_lock' in 'struct kvm_arch'
    7594 |                         spin_lock(&kvm->arch.tdp_mmu_pages_lock);
         |                                    ~~~~~~~~~ ^
   arch/x86/kvm/mmu/mmu.c:7597:28: error: no member named 'tdp_mmu_pages_lock' in 'struct kvm_arch'
    7597 |                                 spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
         |                                              ~~~~~~~~~ ^
   arch/x86/kvm/mmu/mmu.c:7617:27: error: no member named 'tdp_mmu_pages_lock' in 'struct kvm_arch'
    7617 |                         spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
         |                                      ~~~~~~~~~ ^
   4 errors generated.


vim +7594 arch/x86/kvm/mmu/mmu.c

  7565	
  7566	static void kvm_recover_nx_huge_pages(struct kvm *kvm,
  7567					      enum kvm_mmu_type mmu_type)
  7568	{
  7569		unsigned long to_zap = nx_huge_pages_to_zap(kvm, mmu_type);
> 7570		bool is_tdp = mmu_type == KVM_TDP_MMU;
  7571		struct list_head *nx_huge_pages;
  7572		struct kvm_mmu_page *sp;
  7573		LIST_HEAD(invalid_list);
  7574		bool flush = false;
  7575		int rcu_idx;
  7576	
  7577		nx_huge_pages = &kvm->arch.possible_nx_huge_pages[mmu_type].pages;
  7578	
  7579		rcu_idx = srcu_read_lock(&kvm->srcu);
  7580		if (is_tdp)
  7581			read_lock(&kvm->mmu_lock);
  7582		else
  7583			write_lock(&kvm->mmu_lock);
  7584	
  7585		/*
  7586		 * Zapping TDP MMU shadow pages, including the remote TLB flush, must
  7587		 * be done under RCU protection, because the pages are freed via RCU
  7588		 * callback.
  7589		 */
  7590		rcu_read_lock();
  7591	
  7592		for ( ; to_zap; --to_zap) {
  7593			if (is_tdp)
> 7594				spin_lock(&kvm->arch.tdp_mmu_pages_lock);
  7595			if (list_empty(nx_huge_pages)) {
  7596				if (is_tdp)
  7597					spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
  7598				break;
  7599			}
  7600	
  7601			/*
  7602			 * We use a separate list instead of just using active_mmu_pages
  7603			 * because the number of shadow pages that be replaced with an
  7604			 * NX huge page is expected to be relatively small compared to
  7605			 * the total number of shadow pages.  And because the TDP MMU
  7606			 * doesn't use active_mmu_pages.
  7607			 */
  7608			sp = list_first_entry(nx_huge_pages,
  7609					      struct kvm_mmu_page,
  7610					      possible_nx_huge_page_link);
  7611			WARN_ON_ONCE(!sp->nx_huge_page_disallowed);
  7612			WARN_ON_ONCE(!sp->role.direct);
  7613	
  7614			unaccount_nx_huge_page(kvm, sp);
  7615	
  7616			if (is_tdp)
  7617				spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
  7618	
  7619			/*
  7620			 * Do not attempt to recover any NX Huge Pages that are being
  7621			 * dirty tracked, as they would just be faulted back in as 4KiB
  7622			 * pages. The NX Huge Pages in this slot will be recovered,
  7623			 * along with all the other huge pages in the slot, when dirty
  7624			 * logging is disabled.
  7625			 */
  7626			if (!kvm_mmu_sp_dirty_logging_enabled(kvm, sp)) {
  7627				if (is_tdp)
  7628					flush |= kvm_tdp_mmu_zap_possible_nx_huge_page(kvm, sp);
  7629				else
  7630					kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
  7631	
  7632			}
  7633	
  7634			WARN_ON_ONCE(sp->nx_huge_page_disallowed);
  7635	
  7636			if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
  7637				kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
  7638				rcu_read_unlock();
  7639	
  7640				if (is_tdp)
  7641					cond_resched_rwlock_read(&kvm->mmu_lock);
  7642				else
  7643					cond_resched_rwlock_write(&kvm->mmu_lock);
  7644	
  7645				flush = false;
  7646				rcu_read_lock();
  7647			}
  7648		}
  7649		kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
  7650	
  7651		rcu_read_unlock();
  7652	
  7653		if (is_tdp)
  7654			read_unlock(&kvm->mmu_lock);
  7655		else
  7656			write_unlock(&kvm->mmu_lock);
  7657		srcu_read_unlock(&kvm->srcu, rcu_idx);
  7658	}
  7659	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

