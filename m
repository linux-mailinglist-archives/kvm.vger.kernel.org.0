Return-Path: <kvm+bounces-52207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F7B9B0267B
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 23:42:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5ADAA7BA9E7
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 21:41:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFC39217666;
	Fri, 11 Jul 2025 21:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZyhMw0iy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFA41991C9;
	Fri, 11 Jul 2025 21:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752270145; cv=none; b=iGAlbyLQ/nyZuXhFcbmNqAAAk0DsH//IwVvQ9t9/+o5AqM0TOdbdo9iGrXNaJSwc0uivr7yUd2rAfGx7uDt/F8F5f6FeWmp1kMWmtz9TthfKoHn7al3C+/yn4rdO+9M6mSOc9h6omRBbAkiZ9nuJFueFN17agDG09Iy0wFU/UDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752270145; c=relaxed/simple;
	bh=FRJZTMDli33z+2VYtIwPjKtkzXPLWnmyhYXuUGVZ4Hc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kRl11OzuIE07/kWkvnBB8xKRGuxWqiZ7M0wVC1OAqmk/qm+BvQl5nfcZVezinBWDvZrvGuwvu2PGG0rO9eI5o0OOYTQiqvTYvN719ikwWYwgxAhjKWBdLCIiUjl4YLS5yFelPawWPXryQBZ0UNYSKuOiCDVDf0Ai4MGTz4tn1Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZyhMw0iy; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752270142; x=1783806142;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FRJZTMDli33z+2VYtIwPjKtkzXPLWnmyhYXuUGVZ4Hc=;
  b=ZyhMw0iyqoO6BKg1ZY98ZdWk3d0RLfZjuUlLMkLsS0pVZRz2wNJP6EXc
   8GvT41UVlFz47z2rPQnmqNmCsCkA8qjqU6B8BqyBOKO0r22tGPYpsMLI9
   9kr56yYE8+vjePOp+7K3c/59AyPp+rE63aZEK+SJkpuhffDLoOhS3os42
   MJ/HqPalSuEPw36glQI6CfFteEi143St8E17K6qApiYU39LaVP8MQPM/F
   GM1DT0rYNOiHj26c43UgD6U2jyD6B09dcO0IkTsRDRHR0QR5C4u+bDdKG
   +gicy0qxSeVz497KmocSNZaaetiPjepaFFA64U5LOTeT6T704XV/ma7mY
   A==;
X-CSE-ConnectionGUID: /243kq0ERAe4dc0aZ5/AgA==
X-CSE-MsgGUID: En9f3oxGSIOA0M/zyoC1zw==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="58381142"
X-IronPort-AV: E=Sophos;i="6.16,304,1744095600"; 
   d="scan'208";a="58381142"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 14:42:21 -0700
X-CSE-ConnectionGUID: DLeCp0zyQniDp8k0huMS+w==
X-CSE-MsgGUID: D+NrjiQ5QSK5LShoTx+gxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,304,1744095600"; 
   d="scan'208";a="160759947"
Received: from lkp-server01.sh.intel.com (HELO 9ee84586c615) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 11 Jul 2025 14:42:19 -0700
Received: from kbuild by 9ee84586c615 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uaLVZ-0006oN-0u;
	Fri, 11 Jul 2025 21:42:17 +0000
Date: Sat, 12 Jul 2025 05:42:06 +0800
From: kernel test robot <lkp@intel.com>
To: Nikunj A Dadhania <nikunj@amd.com>, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	thomas.lendacky@amd.com, santosh.shukla@amd.com, bp@alien8.de,
	nikunj@amd.com, Michael Roth <michael.roth@amd.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] KVM: SEV: Enforce minimum GHCB version requirement for
 SEV-SNP guests
Message-ID: <202507120551.iDEiTBBN-lkp@intel.com>
References: <20250711045408.95129-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250711045408.95129-1-nikunj@amd.com>

Hi Nikunj,

kernel test robot noticed the following build errors:

[auto build test ERROR on kvm/queue]
[also build test ERROR on kvm/next linus/master v6.16-rc5 next-20250711]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Nikunj-A-Dadhania/KVM-SEV-Enforce-minimum-GHCB-version-requirement-for-SEV-SNP-guests/20250711-125527
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20250711045408.95129-1-nikunj%40amd.com
patch subject: [PATCH] KVM: SEV: Enforce minimum GHCB version requirement for SEV-SNP guests
config: x86_64-rhel-9.4-rust (https://download.01.org/0day-ci/archive/20250712/202507120551.iDEiTBBN-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250712/202507120551.iDEiTBBN-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507120551.iDEiTBBN-lkp@intel.com/

All errors (new ones prefixed by >>):

>> arch/x86/kvm/svm/sev.c:426:6: error: use of undeclared identifier 'snp_active'
     426 |         if (snp_active && data->ghcb_version && data->ghcb_version < 2)
         |             ^
   1 error generated.


vim +/snp_active +426 arch/x86/kvm/svm/sev.c

   400	
   401	static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
   402				    struct kvm_sev_init *data,
   403				    unsigned long vm_type)
   404	{
   405		struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
   406		struct sev_platform_init_args init_args = {0};
   407		bool es_active = vm_type != KVM_X86_SEV_VM;
   408		u64 valid_vmsa_features = es_active ? sev_supported_vmsa_features : 0;
   409		int ret;
   410	
   411		if (kvm->created_vcpus)
   412			return -EINVAL;
   413	
   414		if (data->flags)
   415			return -EINVAL;
   416	
   417		if (data->vmsa_features & ~valid_vmsa_features)
   418			return -EINVAL;
   419	
   420		if (data->ghcb_version > GHCB_VERSION_MAX || (!es_active && data->ghcb_version))
   421			return -EINVAL;
   422	
   423		if (unlikely(sev->active))
   424			return -EINVAL;
   425	
 > 426		if (snp_active && data->ghcb_version && data->ghcb_version < 2)
   427			return -EINVAL;
   428	
   429		sev->active = true;
   430		sev->es_active = es_active;
   431		sev->vmsa_features = data->vmsa_features;
   432		sev->ghcb_version = data->ghcb_version;
   433	
   434		/*
   435		 * Currently KVM supports the full range of mandatory features defined
   436		 * by version 2 of the GHCB protocol, so default to that for SEV-ES
   437		 * guests created via KVM_SEV_INIT2.
   438		 */
   439		if (sev->es_active && !sev->ghcb_version)
   440			sev->ghcb_version = GHCB_VERSION_DEFAULT;
   441	
   442		if (vm_type == KVM_X86_SNP_VM)
   443			sev->vmsa_features |= SVM_SEV_FEAT_SNP_ACTIVE;
   444	
   445		ret = sev_asid_new(sev);
   446		if (ret)
   447			goto e_no_asid;
   448	
   449		init_args.probe = false;
   450		ret = sev_platform_init(&init_args);
   451		if (ret)
   452			goto e_free;
   453	
   454		/* This needs to happen after SEV/SNP firmware initialization. */
   455		if (vm_type == KVM_X86_SNP_VM) {
   456			ret = snp_guest_req_init(kvm);
   457			if (ret)
   458				goto e_free;
   459		}
   460	
   461		INIT_LIST_HEAD(&sev->regions_list);
   462		INIT_LIST_HEAD(&sev->mirror_vms);
   463		sev->need_init = false;
   464	
   465		kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_SEV);
   466	
   467		return 0;
   468	
   469	e_free:
   470		argp->error = init_args.error;
   471		sev_asid_free(sev);
   472		sev->asid = 0;
   473	e_no_asid:
   474		sev->vmsa_features = 0;
   475		sev->es_active = false;
   476		sev->active = false;
   477		return ret;
   478	}
   479	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

