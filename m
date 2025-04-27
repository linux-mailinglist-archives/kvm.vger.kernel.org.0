Return-Path: <kvm+bounces-44480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DE5BCA9DF46
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 08:15:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 51ED47B174D
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 06:14:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23813235360;
	Sun, 27 Apr 2025 06:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HUmFkslM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C87EA94A
	for <kvm@vger.kernel.org>; Sun, 27 Apr 2025 06:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745734520; cv=none; b=pB6te39cBzWy3pAJDHcLZ5gJKbZgG5zB6RZwdCVEVFMkV9REk8CeSIeYMLodS11rrrdlj0xSwq2ij84dhzKCxFr5qqvxtSTlXFOJJrcXt79nXGANyCNKM3AQtWyNEmOPwpVZItmq20w+G/ASTPL4pa7vg3LnUcjKnXKpsEO1DpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745734520; c=relaxed/simple;
	bh=rxpNcby6Q++OoV5RweTfvn1DH4Lzi1iHyCXm0T+R9I8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=uVMZ9xEw7Fu7EU1j7AnrgW9mqZLN/2NXKFwWm2k4mwWqAch3ZPUFU65TtgtFyRSBN/HsH9NNd4wJ+SnlDi24nruz1J1KABFDiWjxVVeFA0JH9Cuzwekimw9ngSjmngCcVTgZ4b4NGKTdsMTLWu+PuTVw+B2KiG0uHW3HdePZSRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HUmFkslM; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745734518; x=1777270518;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=rxpNcby6Q++OoV5RweTfvn1DH4Lzi1iHyCXm0T+R9I8=;
  b=HUmFkslM1X0bOoWgBhQCEsHpDZvyd0zM+5nLK8v8wSH5QuhWm1DMfpML
   GtLNXnjuHRQS3rh2dOdgFHCU0yws0su8mTMBkVy3ATgFUZeEab0aN0Fbh
   aEwscXUpR8RfbKrHwTakwVzPTt6an8p7nHVGg9Mi36vA4meWbk9fi4SGW
   ifA9iBYz3aBg2urP5DAmk2bYyGAGeLNf2Z3M/SFx2nGLFFWyi7nLT1/FI
   RWCcZiciSj8SP0Pg+SF4kWpvspAxLkDORnhtXsjAPNEgUngrDZeldIT86
   dFuddomEp9hdupZuSrl4j3hjG9XuaBazOAmCcYxMDm1lkIa5IWspaGQki
   Q==;
X-CSE-ConnectionGUID: MAtWbgUuRV6agSUoTD11HQ==
X-CSE-MsgGUID: 7pZw+x6hRjyO2Or191DmzA==
X-IronPort-AV: E=McAfee;i="6700,10204,11415"; a="46578504"
X-IronPort-AV: E=Sophos;i="6.15,243,1739865600"; 
   d="scan'208";a="46578504"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2025 23:15:18 -0700
X-CSE-ConnectionGUID: vvPqo2DTRG+vmJSc4g3kcA==
X-CSE-MsgGUID: osdeSxcWSsmSvbH2SRquCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,243,1739865600"; 
   d="scan'208";a="138331909"
Received: from lkp-server01.sh.intel.com (HELO 050dd05385d1) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 26 Apr 2025 23:15:16 -0700
Received: from kbuild by 050dd05385d1 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1u8vII-00068z-1k;
	Sun, 27 Apr 2025 06:15:14 +0000
Date: Sun, 27 Apr 2025 14:15:13 +0800
From: kernel test robot <lkp@intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	Farrah Chen <farrah.chen@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm:queue 9/13] arch/x86/kvm/svm/avic.c:807: warning: Function
 parameter or struct member 'pi->prev_ga_tag' not described in 'if'
Message-ID: <202504271426.qgsP6QxR-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
head:   45eb29140e68ffe8e93a5471006858a018480a45
commit: 268cbfe65bb9096f78f98d1e092b1939d3caa382 [9/13] KVM: SVM: WARN if an invalid posted interrupt IRTE entry is added
config: x86_64-randconfig-002-20250427 (https://download.01.org/0day-ci/archive/20250427/202504271426.qgsP6QxR-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250427/202504271426.qgsP6QxR-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202504271426.qgsP6QxR-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/x86/kvm/svm/avic.c:807: warning: Function parameter or struct member 'pi->prev_ga_tag' not described in 'if'
   arch/x86/kvm/svm/avic.c:807: warning: expecting prototype for In some cases, the existing irte is updated and re(). Prototype was for if() instead
   arch/x86/kvm/svm/avic.c:823: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
            * Allocating new amd_iommu_pi_data, which will get
   arch/x86/kvm/svm/avic.c:936: warning: Function parameter or struct member 'kvm_vcpu_apicv_active(&svm->vcpu' not described in 'if'
   arch/x86/kvm/svm/avic.c:936: warning: expecting prototype for Here, we setup with legacy mode in the following cases(). Prototype was for if() instead
   arch/x86/kvm/svm/avic.c:951: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
                            * Here, we successfully setting up vcpu affinity in
   arch/x86/kvm/svm/avic.c:983: warning: cannot understand function prototype: 'pi.prev_ga_tag = 0; '
   arch/x86/kvm/svm/avic.c:988: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
                    * Check if the posted interrupt was previously
   arch/x86/kvm/svm/avic.c:1128: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
                    * During AVIC temporary deactivation, guest could update


vim +807 arch/x86/kvm/svm/avic.c

   791	
   792	static int svm_ir_list_add(struct vcpu_svm *svm, struct amd_iommu_pi_data *pi)
   793	{
   794		int ret = 0;
   795		unsigned long flags;
   796		struct amd_svm_iommu_ir *ir;
   797		u64 entry;
   798	
   799		if (WARN_ON_ONCE(!pi->ir_data))
   800			return -EINVAL;
   801	
   802		/**
   803		 * In some cases, the existing irte is updated and re-set,
   804		 * so we need to check here if it's already been * added
   805		 * to the ir_list.
   806		 */
 > 807		if (pi->prev_ga_tag) {
   808			struct kvm *kvm = svm->vcpu.kvm;
   809			u32 vcpu_id = AVIC_GATAG_TO_VCPUID(pi->prev_ga_tag);
   810			struct kvm_vcpu *prev_vcpu = kvm_get_vcpu_by_id(kvm, vcpu_id);
   811			struct vcpu_svm *prev_svm;
   812	
   813			if (!prev_vcpu) {
   814				ret = -EINVAL;
   815				goto out;
   816			}
   817	
   818			prev_svm = to_svm(prev_vcpu);
   819			svm_ir_list_del(prev_svm, pi);
   820		}
   821	
   822		/**
   823		 * Allocating new amd_iommu_pi_data, which will get
   824		 * add to the per-vcpu ir_list.
   825		 */
   826		ir = kzalloc(sizeof(struct amd_svm_iommu_ir), GFP_ATOMIC | __GFP_ACCOUNT);
   827		if (!ir) {
   828			ret = -ENOMEM;
   829			goto out;
   830		}
   831		ir->data = pi->ir_data;
   832	
   833		spin_lock_irqsave(&svm->ir_list_lock, flags);
   834	
   835		/*
   836		 * Update the target pCPU for IOMMU doorbells if the vCPU is running.
   837		 * If the vCPU is NOT running, i.e. is blocking or scheduled out, KVM
   838		 * will update the pCPU info when the vCPU awkened and/or scheduled in.
   839		 * See also avic_vcpu_load().
   840		 */
   841		entry = READ_ONCE(*(svm->avic_physical_id_cache));
   842		if (entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK)
   843			amd_iommu_update_ga(entry & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK,
   844					    true, pi->ir_data);
   845	
   846		list_add(&ir->node, &svm->ir_list);
   847		spin_unlock_irqrestore(&svm->ir_list_lock, flags);
   848	out:
   849		return ret;
   850	}
   851	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

