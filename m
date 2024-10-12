Return-Path: <kvm+bounces-28664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E19AB99AF9F
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2024 02:11:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F1ED28542A
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2024 00:10:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02116184E;
	Sat, 12 Oct 2024 00:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZhycIjA1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545F238B
	for <kvm@vger.kernel.org>; Sat, 12 Oct 2024 00:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728691851; cv=none; b=qwV+uC8RiFcdsYtKWlFeAsAVcA8SBGStvrMpKyf9aEHJslUmdjpRfVbwx9VUbn913WpShvhFUGnYDDwnD8e6mKsku1g5iQES3GHzuT3zTzr8IJY1wjELbfJoj4q9BO7stiVYLbjBusDrWYpS6XeNvcTtibsROe3JeX+1M2159vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728691851; c=relaxed/simple;
	bh=E0RFbqikIkoA3KkqNL5ZRMolBELYaA7EJkna4JZX3OU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=uSS0b1j7JN85Q5MEDtI/2R55xPPyw0xb7Xz3unk39J0O6gt/XAMe+YkpxRTFXq8DtcljFdm4x+GvwgOqh6ZauLJCOqtsoodW8KWzSXPMGAeljKvu0qDoZeT/1cnbdITqaInK5VsvFapPMXAvXab8R9Zd2ugBZsYEKU06u5d/GYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZhycIjA1; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728691848; x=1760227848;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=E0RFbqikIkoA3KkqNL5ZRMolBELYaA7EJkna4JZX3OU=;
  b=ZhycIjA1+hyzq7Ck8DfnElA+4r/RLAck3ccGtWSP7Kmvh8KrURUpHMO9
   NHG2bk6FCVBE6h8rCGoXuCZyPjWJnpYDnCF7G2kk2EdqVaaWjwNDV8JZ1
   5GNLyUWCka/opsmPruoJGgl6Uj4U1f208E5D37pBcSE26sBqAI3CrN3EV
   Eq62Xlulze3qPdCUVGMCPG8aZiKQ6WIAgZUmi1tja5uXsHBkMDcSZIC0M
   SzxPBvyneOKOT947YhZcOd5VZlTQ4cRSiTPu7TyWekpm6B2KzQAvFClKn
   jH4twja15wXrxivsxmrOtJr9hC3LdwLShxQTiM4AQemUK5RnJb7+Pyp+K
   Q==;
X-CSE-ConnectionGUID: FEVrk0f1RyG8zXO8cwj/xA==
X-CSE-MsgGUID: vUsig7vKR9WeyIIIXGui6A==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="27584473"
X-IronPort-AV: E=Sophos;i="6.11,197,1725346800"; 
   d="scan'208";a="27584473"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2024 17:10:48 -0700
X-CSE-ConnectionGUID: xPRTGwb5Q+WZD4NIcfaKpA==
X-CSE-MsgGUID: NfUMoa1NQsC51LT93p9IeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,197,1725346800"; 
   d="scan'208";a="82052444"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 11 Oct 2024 17:10:45 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1szPiU-000Csp-0m;
	Sat, 12 Oct 2024 00:10:42 +0000
Date: Sat, 12 Oct 2024 08:10:21 +0800
From: kernel test robot <lkp@intel.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	Robert Hu <robert.hu@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Danmei Wei <danmei.wei@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Kai Huang <kai.huang@intel.com>, Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [kvm:kvm-coco-queue 60/109] arch/x86/kvm/mmu/tdp_mmu.c:1176:25:
 sparse: sparse: incorrect type in argument 1 (different address spaces)
Message-ID: <202410120851.DMfCaszW-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-coco-queue
head:   d2c7662a6ea1c325a9ae878b3f1a265264bcd18b
commit: f6ab1baaf315a860e46baf9f7b1a5bf3db99f9ec [60/109] KVM: x86/tdp_mmu: Support mirror root for TDP MMU
config: x86_64-randconfig-121-20241011 (https://download.01.org/0day-ci/archive/20241012/202410120851.DMfCaszW-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241012/202410120851.DMfCaszW-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410120851.DMfCaszW-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> arch/x86/kvm/mmu/tdp_mmu.c:1176:25: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected unsigned long long [usertype] *sptep @@     got unsigned long long [noderef] [usertype] __rcu *[addressable] [usertype] sptep @@
   arch/x86/kvm/mmu/tdp_mmu.c:1176:25: sparse:     expected unsigned long long [usertype] *sptep
   arch/x86/kvm/mmu/tdp_mmu.c:1176:25: sparse:     got unsigned long long [noderef] [usertype] __rcu *[addressable] [usertype] sptep
   arch/x86/kvm/mmu/tdp_mmu.c: note: in included file (through include/linux/rbtree.h, include/linux/mm_types.h, include/linux/mmzone.h, ...):
   include/linux/rcupdate.h:869:25: sparse: sparse: context imbalance in '__tdp_mmu_zap_root' - unexpected unlock
   arch/x86/kvm/mmu/tdp_mmu.c:1459:33: sparse: sparse: context imbalance in 'tdp_mmu_split_huge_pages_root' - unexpected unlock

vim +1176 arch/x86/kvm/mmu/tdp_mmu.c

  1120	
  1121	static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
  1122					   struct kvm_mmu_page *sp, bool shared);
  1123	
  1124	/*
  1125	 * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
  1126	 * page tables and SPTEs to translate the faulting guest physical address.
  1127	 */
  1128	int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
  1129	{
  1130		struct kvm_mmu_page *root = tdp_mmu_get_root_for_fault(vcpu, fault);
  1131		struct kvm *kvm = vcpu->kvm;
  1132		struct tdp_iter iter;
  1133		struct kvm_mmu_page *sp;
  1134		int ret = RET_PF_RETRY;
  1135	
  1136		kvm_mmu_hugepage_adjust(vcpu, fault);
  1137	
  1138		trace_kvm_mmu_spte_requested(fault);
  1139	
  1140		rcu_read_lock();
  1141	
  1142		tdp_mmu_for_each_pte(iter, kvm, root, fault->gfn, fault->gfn + 1) {
  1143			int r;
  1144	
  1145			if (fault->nx_huge_page_workaround_enabled)
  1146				disallowed_hugepage_adjust(fault, iter.old_spte, iter.level);
  1147	
  1148			/*
  1149			 * If SPTE has been frozen by another thread, just give up and
  1150			 * retry, avoiding unnecessary page table allocation and free.
  1151			 */
  1152			if (is_frozen_spte(iter.old_spte))
  1153				goto retry;
  1154	
  1155			if (iter.level == fault->goal_level)
  1156				goto map_target_level;
  1157	
  1158			/* Step down into the lower level page table if it exists. */
  1159			if (is_shadow_present_pte(iter.old_spte) &&
  1160			    !is_large_pte(iter.old_spte))
  1161				continue;
  1162	
  1163			/*
  1164			 * The SPTE is either non-present or points to a huge page that
  1165			 * needs to be split.
  1166			 */
  1167			sp = tdp_mmu_alloc_sp(vcpu);
  1168			tdp_mmu_init_child_sp(sp, &iter);
  1169			if (is_mirror_sp(sp))
  1170				kvm_mmu_alloc_external_spt(vcpu, sp);
  1171	
  1172			sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
  1173	
  1174			if (is_shadow_present_pte(iter.old_spte)) {
  1175				/* Don't support large page for mirrored roots (TDX) */
> 1176				KVM_BUG_ON(is_mirror_sptep(iter.sptep), vcpu->kvm);
  1177				r = tdp_mmu_split_huge_page(kvm, &iter, sp, true);
  1178			} else {
  1179				r = tdp_mmu_link_sp(kvm, &iter, sp, true);
  1180			}
  1181	
  1182			/*
  1183			 * Force the guest to retry if installing an upper level SPTE
  1184			 * failed, e.g. because a different task modified the SPTE.
  1185			 */
  1186			if (r) {
  1187				tdp_mmu_free_sp(sp);
  1188				goto retry;
  1189			}
  1190	
  1191			if (fault->huge_page_disallowed &&
  1192			    fault->req_level >= iter.level) {
  1193				spin_lock(&kvm->arch.tdp_mmu_pages_lock);
  1194				if (sp->nx_huge_page_disallowed)
  1195					track_possible_nx_huge_page(kvm, sp);
  1196				spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
  1197			}
  1198		}
  1199	
  1200		/*
  1201		 * The walk aborted before reaching the target level, e.g. because the
  1202		 * iterator detected an upper level SPTE was frozen during traversal.
  1203		 */
  1204		WARN_ON_ONCE(iter.level == fault->goal_level);
  1205		goto retry;
  1206	
  1207	map_target_level:
  1208		ret = tdp_mmu_map_handle_target_level(vcpu, fault, &iter);
  1209	
  1210	retry:
  1211		rcu_read_unlock();
  1212		return ret;
  1213	}
  1214	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

