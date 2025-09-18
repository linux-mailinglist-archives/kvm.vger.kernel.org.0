Return-Path: <kvm+bounces-57963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89E9EB82AF0
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 04:46:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC9BD6254D0
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 02:46:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB1C523F431;
	Thu, 18 Sep 2025 02:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FCRiRDav"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644C51A262A;
	Thu, 18 Sep 2025 02:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758163557; cv=none; b=LuvBOUZrbrTbzYIE07KAj64oioRpXVWY3u6QVkGh2rYhROEGupVXSPdqO6zDrzF68LG+xRV+FT/sVa4xaKkzSkT1xOH0eZHsGUFfsm4TIQfmX412pRYnJzpivxKwyzKCmFeXW2GuNLjyQToiQPJXxPMCHLpTf4Gr4g7XcA8Uh7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758163557; c=relaxed/simple;
	bh=MGtmbYJr4izzxh9Q5fjjfxZ6vSiqc+Pmx0sDfZpsERU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YNd5U6TlVal/d/m5SKuhxmWjVoWbrF6120YlpbjrbjGSXDjydn8pOb1SbkmZT9g8uVmDQpa64l+BSVjrQBwZx3pNZ9ioripDZQYbezBLLGVAr8gAUD48IqI1mNdQySIT3oDIlketOurlz+0/xlkjLVP3s+9JNH1fU0Da2v1W1mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FCRiRDav; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758163557; x=1789699557;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MGtmbYJr4izzxh9Q5fjjfxZ6vSiqc+Pmx0sDfZpsERU=;
  b=FCRiRDavXTfO8xtmZP9ucyArldgmtS3NaHk4u9TFUTFKDlrVAg2/WZFT
   i2fx/vo66oGXQhTFc2TzBldo5tHsooUeTBHKoDtmbbXHMdH/zMRl4EIA1
   Jt72iGvDAEM0+MDphbLwOD3OKyXEd9TFOhGY7o99lHZKWP3qU4lOZmBbO
   +uE+niNN/WoUkHsFhWmfNHEPfv+1cQ3dXYBUzgT2Pm1BOkZyHaaMpv0P+
   UeI8ueUYU8Xmbm3VqPekBR7qCRpNfUtQcd7/F7Pv0TykxO9d63G9WK+u/
   r5TuZTdx89Nv8HobiRChkD4vJ+PG6coC/nMQkKv1kDf/KjAFQd92PPPCR
   g==;
X-CSE-ConnectionGUID: YZnMUvQoRxmLGRjJTT2WwQ==
X-CSE-MsgGUID: xOOkeYytSr6C6b66QVCh6A==
X-IronPort-AV: E=McAfee;i="6800,10657,11556"; a="71908147"
X-IronPort-AV: E=Sophos;i="6.18,273,1751266800"; 
   d="scan'208";a="71908147"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 19:45:56 -0700
X-CSE-ConnectionGUID: BKE0jq5BSkG7P9Qe24Ll7w==
X-CSE-MsgGUID: 9xb6ixm/TWyg48SGy4T1TA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,273,1751266800"; 
   d="scan'208";a="175012948"
Received: from lkp-server01.sh.intel.com (HELO 84a20bd60769) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 17 Sep 2025 19:45:50 -0700
Received: from kbuild by 84a20bd60769 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uz4ea-0002f9-0T;
	Thu, 18 Sep 2025 02:45:48 +0000
Date: Thu, 18 Sep 2025 10:45:17 +0800
From: kernel test robot <lkp@intel.com>
To: Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org,
	x86@kernel.org, linux-hyperv@vger.kernel.org,
	virtualization@lists.linux.dev, kvm@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v2 21/21] x86/pvlocks: Move paravirt spinlock functions
 into own header
Message-ID: <202509181008.MoLd2u4e-lkp@intel.com>
References: <20250917145220.31064-22-jgross@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917145220.31064-22-jgross@suse.com>

Hi Juergen,

kernel test robot noticed the following build warnings:

[auto build test WARNING on tip/sched/core]
[also build test WARNING on kvm/queue kvm/next linus/master v6.17-rc6 next-20250917]
[cannot apply to tip/x86/core kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Juergen-Gross/x86-paravirt-Remove-not-needed-includes-of-paravirt-h/20250917-230321
base:   tip/sched/core
patch link:    https://lore.kernel.org/r/20250917145220.31064-22-jgross%40suse.com
patch subject: [PATCH v2 21/21] x86/pvlocks: Move paravirt spinlock functions into own header
config: x86_64-randconfig-003-20250918 (https://download.01.org/0day-ci/archive/20250918/202509181008.MoLd2u4e-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250918/202509181008.MoLd2u4e-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509181008.MoLd2u4e-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/x86/kernel/paravirt-spinlocks.c:13:13: warning: no previous prototype for function 'native_pv_lock_init' [-Wmissing-prototypes]
      13 | void __init native_pv_lock_init(void)
         |             ^
   arch/x86/kernel/paravirt-spinlocks.c:13:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
      13 | void __init native_pv_lock_init(void)
         | ^
         | static 
   1 warning generated.


vim +/native_pv_lock_init +13 arch/x86/kernel/paravirt-spinlocks.c

    12	
  > 13	void __init native_pv_lock_init(void)
    14	{
    15		if (boot_cpu_has(X86_FEATURE_HYPERVISOR))
    16			static_branch_enable(&virt_spin_lock_key);
    17	}
    18	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

