Return-Path: <kvm+bounces-30271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3A629B87C0
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 01:36:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3B6F282E7F
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 00:36:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E8F317C77;
	Fri,  1 Nov 2024 00:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iCEJHv3h"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D083AD4B
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 00:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730421369; cv=none; b=cQqHhkuFff2KZLFqvGNKXB/bBBMWWlwTyaqmBLxTNql16vWqjHWqFSIiyZV8jmr4c4rqseazXWKwAhM0NgCHzFwY8nUZP6QE94G1dO6JX9NkV1LYqfpAEVXYQz+J7yAd6DjTjhY5bZMpviOh/mBKecX8yLdW3sj/PtrI2TG5G30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730421369; c=relaxed/simple;
	bh=4/HsES9kFB+5RWVONeBQb5LIGIAwtM9s7tgILv01r00=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=L+IUif5Q0TuvHOMv54a+99qOl1KNj0pjmTkJNF++rHbG8YbzVATXKKbOgQATU9tAxok9um0GChG4mE1KbPABbI+t1WFuCHsjQhAYaMN15SrQunriKgHr8dg3axC/cYnHzNpYcLGbmBsYWD2d1n+yxoTefvgDxli9A26HR/OhUg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iCEJHv3h; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730421363; x=1761957363;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=4/HsES9kFB+5RWVONeBQb5LIGIAwtM9s7tgILv01r00=;
  b=iCEJHv3htS9cGZYQsol6Cq1OQ/5r0z8fsUUobRMSJTuKr6sXJym0xP6j
   9YP+jYRsrr+7oG+VwtvhNjaJl0bkFenuYs45C+Fd2VO4xb7CRrwDeqt2Q
   wC7MwQFrQ9t1mOyWWwmFnVkZs2PkH2+yPsJZTv7SybT9w9+tHteHUQzzp
   97HbzXe2kJRnue5pSRrT8hQdxUul5+bmECBCkbc/n0QdjHMRkuD3oc+2v
   VhRoG29O0xPb45pFtT1nn40UlXGGQa8QNd7mAfNutJXERFwc/W2vBWVFe
   1Dh+LNeI6+XMjg3gpmAzbERMGvd/JcP83hhMFrJlJErrzQxzIXtHXuw/2
   w==;
X-CSE-ConnectionGUID: 7qAGr9UHRvei75OApQxuow==
X-CSE-MsgGUID: hh5a38BaRImI6dVWNAM4cw==
X-IronPort-AV: E=McAfee;i="6700,10204,11242"; a="17823559"
X-IronPort-AV: E=Sophos;i="6.11,248,1725346800"; 
   d="scan'208";a="17823559"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 17:36:00 -0700
X-CSE-ConnectionGUID: lU/xmWc6Rf6/IEEBTUCC7w==
X-CSE-MsgGUID: t6pVC3efRxGM1eJISQXjNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,248,1725346800"; 
   d="scan'208";a="87397819"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 31 Oct 2024 17:35:52 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t6fdm-000gtQ-10;
	Fri, 01 Nov 2024 00:35:50 +0000
Date: Fri, 1 Nov 2024 08:35:20 +0800
From: kernel test robot <lkp@intel.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	Farrah Chen <farrah.chen@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Kai Huang <kai.huang@intel.com>, Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [kvm:kvm-coco-queue 116/186] arch/x86/kvm/mmu/tdp_mmu.c:1171:25:
 sparse: sparse: incorrect type in argument 1 (different address spaces)
Message-ID: <202411010854.46G4UJpa-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-coco-queue
head:   49c492a89914b02fa5011d9ea9848318c6c98dd9
commit: 51bdd33b88604316f46202567d29b596721d8823 [116/186] KVM: x86/tdp_mmu: Support mirror root for TDP MMU
config: x86_64-randconfig-123-20241101 (https://download.01.org/0day-ci/archive/20241101/202411010854.46G4UJpa-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241101/202411010854.46G4UJpa-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411010854.46G4UJpa-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> arch/x86/kvm/mmu/tdp_mmu.c:1171:25: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected unsigned long long [usertype] *sptep @@     got unsigned long long [noderef] [usertype] __rcu *[addressable] [usertype] sptep @@
   arch/x86/kvm/mmu/tdp_mmu.c:1171:25: sparse:     expected unsigned long long [usertype] *sptep
   arch/x86/kvm/mmu/tdp_mmu.c:1171:25: sparse:     got unsigned long long [noderef] [usertype] __rcu *[addressable] [usertype] sptep
   arch/x86/kvm/mmu/tdp_mmu.c: note: in included file (through include/linux/rbtree.h, include/linux/mm_types.h, include/linux/mmzone.h, ...):
   include/linux/rcupdate.h:880:25: sparse: sparse: context imbalance in '__tdp_mmu_zap_root' - unexpected unlock
   arch/x86/kvm/mmu/tdp_mmu.c:1447:33: sparse: sparse: context imbalance in 'tdp_mmu_split_huge_pages_root' - unexpected unlock

vim +1171 arch/x86/kvm/mmu/tdp_mmu.c

  1115	
  1116	static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
  1117					   struct kvm_mmu_page *sp, bool shared);
  1118	
  1119	/*
  1120	 * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
  1121	 * page tables and SPTEs to translate the faulting guest physical address.
  1122	 */
  1123	int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
  1124	{
  1125		struct kvm_mmu_page *root = tdp_mmu_get_root_for_fault(vcpu, fault);
  1126		struct kvm *kvm = vcpu->kvm;
  1127		struct tdp_iter iter;
  1128		struct kvm_mmu_page *sp;
  1129		int ret = RET_PF_RETRY;
  1130	
  1131		kvm_mmu_hugepage_adjust(vcpu, fault);
  1132	
  1133		trace_kvm_mmu_spte_requested(fault);
  1134	
  1135		rcu_read_lock();
  1136	
  1137		tdp_mmu_for_each_pte(iter, kvm, root, fault->gfn, fault->gfn + 1) {
  1138			int r;
  1139	
  1140			if (fault->nx_huge_page_workaround_enabled)
  1141				disallowed_hugepage_adjust(fault, iter.old_spte, iter.level);
  1142	
  1143			/*
  1144			 * If SPTE has been frozen by another thread, just give up and
  1145			 * retry, avoiding unnecessary page table allocation and free.
  1146			 */
  1147			if (is_frozen_spte(iter.old_spte))
  1148				goto retry;
  1149	
  1150			if (iter.level == fault->goal_level)
  1151				goto map_target_level;
  1152	
  1153			/* Step down into the lower level page table if it exists. */
  1154			if (is_shadow_present_pte(iter.old_spte) &&
  1155			    !is_large_pte(iter.old_spte))
  1156				continue;
  1157	
  1158			/*
  1159			 * The SPTE is either non-present or points to a huge page that
  1160			 * needs to be split.
  1161			 */
  1162			sp = tdp_mmu_alloc_sp(vcpu);
  1163			tdp_mmu_init_child_sp(sp, &iter);
  1164			if (is_mirror_sp(sp))
  1165				kvm_mmu_alloc_external_spt(vcpu, sp);
  1166	
  1167			sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
  1168	
  1169			if (is_shadow_present_pte(iter.old_spte)) {
  1170				/* Don't support large page for mirrored roots (TDX) */
> 1171				KVM_BUG_ON(is_mirror_sptep(iter.sptep), vcpu->kvm);
  1172				r = tdp_mmu_split_huge_page(kvm, &iter, sp, true);
  1173			} else {
  1174				r = tdp_mmu_link_sp(kvm, &iter, sp, true);
  1175			}
  1176	
  1177			/*
  1178			 * Force the guest to retry if installing an upper level SPTE
  1179			 * failed, e.g. because a different task modified the SPTE.
  1180			 */
  1181			if (r) {
  1182				tdp_mmu_free_sp(sp);
  1183				goto retry;
  1184			}
  1185	
  1186			if (fault->huge_page_disallowed &&
  1187			    fault->req_level >= iter.level) {
  1188				spin_lock(&kvm->arch.tdp_mmu_pages_lock);
  1189				if (sp->nx_huge_page_disallowed)
  1190					track_possible_nx_huge_page(kvm, sp);
  1191				spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
  1192			}
  1193		}
  1194	
  1195		/*
  1196		 * The walk aborted before reaching the target level, e.g. because the
  1197		 * iterator detected an upper level SPTE was frozen during traversal.
  1198		 */
  1199		WARN_ON_ONCE(iter.level == fault->goal_level);
  1200		goto retry;
  1201	
  1202	map_target_level:
  1203		ret = tdp_mmu_map_handle_target_level(vcpu, fault, &iter);
  1204	
  1205	retry:
  1206		rcu_read_unlock();
  1207		return ret;
  1208	}
  1209	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

