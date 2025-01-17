Return-Path: <kvm+bounces-35719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 787ACA1484C
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 03:34:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CF50A1889238
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 02:34:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B5557FBAC;
	Fri, 17 Jan 2025 02:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OEJH24o5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A2725A620;
	Fri, 17 Jan 2025 02:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737081274; cv=none; b=RjTqnK5DIh+zJ1+ZXiSg1WGhY+Q2WebWu23I0yFkurAYR5jNQcnhtYAN4DNPiDoEoO0Dj2JaO5JlKEWSu1sVZZe7391n9spVz9VMahkNTZLgX79SKzEDAoQGFiBFSadYIqVsk5Y7LmrHmtjQrC+IDIBxG/bjgNwxG9dR4ISwVmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737081274; c=relaxed/simple;
	bh=IbpOuCB0PVCg0GMj7JYqLyLPivC2fAXTi2lfyteKyjw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N+NfY9ISsEW6AFVsqEqgW3YTat0OSkK123EH5x1u549bg+Pn6o+fiIIMjl88G3vTjh11Ai/I8pW/mcJkZrBapAas/94iv3qrgOoSu1EHr0EVhoaO1BEIE0yMtlbxxAmdBmA8qUbJfdIDkTEuzlR7WQwjdFapOw5kirK8qYcl3LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OEJH24o5; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737081272; x=1768617272;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IbpOuCB0PVCg0GMj7JYqLyLPivC2fAXTi2lfyteKyjw=;
  b=OEJH24o5H+MUxDPyLnMKvA/VGrqI3y2srPvOuUO6d/QtQLso7lT7Ax+a
   2b25YqcBrxjC/R3wZVuMVT0l3BNbJmP/sgqvmHobDEmkTelwBpu5L7YSx
   ooE16G+L9bFCO6yUGw/nGe2yg5rbRZCjS6TXVf2f8C/QlvovM4/BVjKDd
   8++UeShDF1GOJy5nJLQ4djXqcWyxphQ6Xz6QZm3OzRzke+ivktcSWYw6E
   l3XTKF7A8OfGPadEpkSC3pqaRP/hEc43nqWtLKIRAu/tALiVAcTmwQ9ZY
   Mf8fBwUulockL2S9zkx8k4D12zX4FzQchNjjukIc7+vuBD4uEGNyzJlnj
   Q==;
X-CSE-ConnectionGUID: N0JlleUZSDeB+E/+4BG5ug==
X-CSE-MsgGUID: /Mv/0S3mRMKPwSwyrYQoVA==
X-IronPort-AV: E=McAfee;i="6700,10204,11317"; a="37735280"
X-IronPort-AV: E=Sophos;i="6.13,211,1732608000"; 
   d="scan'208";a="37735280"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2025 18:34:32 -0800
X-CSE-ConnectionGUID: pLWp/igBRTWuqm7bF9lITA==
X-CSE-MsgGUID: TrgTChtERluJ67P28x4/yA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="128928043"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 16 Jan 2025 18:34:29 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tYcBn-000SdL-09;
	Fri, 17 Jan 2025 02:34:27 +0000
Date: Fri, 17 Jan 2025 10:34:01 +0800
From: kernel test robot <lkp@intel.com>
To: Vaibhav Jain <vaibhav@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org, kvm-ppc@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Vaibhav Jain <vaibhav@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
	sbhat@linux.ibm.com, gautam@linux.ibm.com, kconsul@linux.ibm.com,
	amachhiw@linux.ibm.com
Subject: Re: [PATCH v2 4/6] kvm powerpc/book3s-apiv2: Introduce kvm-hv
 specific PMU
Message-ID: <202501171030.3x0gqW8G-lkp@intel.com>
References: <20250115143948.369379-5-vaibhav@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250115143948.369379-5-vaibhav@linux.ibm.com>

Hi Vaibhav,

kernel test robot noticed the following build warnings:

[auto build test WARNING on powerpc/topic/ppc-kvm]
[also build test WARNING on powerpc/next powerpc/fixes kvm/queue kvm/next mst-vhost/linux-next linus/master v6.13-rc7 next-20250116]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Vaibhav-Jain/powerpc-Document-APIv2-KVM-hcall-spec-for-Hostwide-counters/20250116-024240
base:   https://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git topic/ppc-kvm
patch link:    https://lore.kernel.org/r/20250115143948.369379-5-vaibhav%40linux.ibm.com
patch subject: [PATCH v2 4/6] kvm powerpc/book3s-apiv2: Introduce kvm-hv specific PMU
config: powerpc-allnoconfig (https://download.01.org/0day-ci/archive/20250117/202501171030.3x0gqW8G-lkp@intel.com/config)
compiler: powerpc-linux-gcc (GCC) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250117/202501171030.3x0gqW8G-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202501171030.3x0gqW8G-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from arch/powerpc/include/asm/kvm_ppc.h:22,
                    from arch/powerpc/include/asm/dbell.h:17,
                    from arch/powerpc/kernel/asm-offsets.c:36:
>> arch/powerpc/include/asm/kvm_book3s.h:357:13: warning: 'kvmppc_unregister_pmu' defined but not used [-Wunused-function]
     357 | static void kvmppc_unregister_pmu(void)
         |             ^~~~~~~~~~~~~~~~~~~~~
>> arch/powerpc/include/asm/kvm_book3s.h:352:12: warning: 'kvmppc_register_pmu' defined but not used [-Wunused-function]
     352 | static int kvmppc_register_pmu(void)
         |            ^~~~~~~~~~~~~~~~~~~
--
   In file included from arch/powerpc/include/asm/kvm_ppc.h:22,
                    from arch/powerpc/include/asm/dbell.h:17,
                    from arch/powerpc/kernel/asm-offsets.c:36:
>> arch/powerpc/include/asm/kvm_book3s.h:357:13: warning: 'kvmppc_unregister_pmu' defined but not used [-Wunused-function]
     357 | static void kvmppc_unregister_pmu(void)
         |             ^~~~~~~~~~~~~~~~~~~~~
>> arch/powerpc/include/asm/kvm_book3s.h:352:12: warning: 'kvmppc_register_pmu' defined but not used [-Wunused-function]
     352 | static int kvmppc_register_pmu(void)
         |            ^~~~~~~~~~~~~~~~~~~


vim +/kvmppc_unregister_pmu +357 arch/powerpc/include/asm/kvm_book3s.h

   351	
 > 352	static int kvmppc_register_pmu(void)
   353	{
   354		return 0;
   355	}
   356	
 > 357	static void kvmppc_unregister_pmu(void)
   358	{
   359	}
   360	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

