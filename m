Return-Path: <kvm+bounces-39845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D191A4B65D
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 03:59:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9834C3B073E
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 02:58:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C5B31AD3E1;
	Mon,  3 Mar 2025 02:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e+kWpZSu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532AE22611
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 02:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740970742; cv=none; b=f4e9GO762+M4CGwICJmDpFJBKjid3Vxl5uMUlPJcKz94C9r97QrgdjwU8wuxD7CIuhpZ7fmkVOrzhLyb4FsDBMbCazHCx8AuQF18ityxvYDYrSlJc5JrG6kAtvR8XwUzeXG9xUo0rlkEdea7msQBLguw9o7ZB7sDcIJrcCx3H9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740970742; c=relaxed/simple;
	bh=Luqld3AfInH59ustwtHCslDoPNlUnD9gFCk9KkHinLo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=VziwTpRBMIXumTL48K977j7Eq1CjkTwOSBgvdVm0A4pV7Qw4vxBEYMzT4OC4N/b9dCFsR7vOTZAXkVDKoJu3/fkFtPkfVUugRGdNbD4n9i0rmhubKApYgNdxhps/ZnDqs55JbAvCzUfp/0XZvWPSqFg+KSSHBseG7oHV3xqIMGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e+kWpZSu; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740970740; x=1772506740;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=Luqld3AfInH59ustwtHCslDoPNlUnD9gFCk9KkHinLo=;
  b=e+kWpZSuotj/DtbaH0+N91YmzYimV4xLYgsJV63XEBTUBpxb8GjQQTpr
   izxeHCeE0qloBMBEasb8EOSAwi+mKWS6gpIjQxjeOcMOT1DOJmNF0V1sh
   NZlt9RAcFii5Ki+LzR0uUxJEINzD3Ss+moh7ZBb6WESpj3gOKdv1+Y8rk
   FOTmxdtzky1FVFiYloNUWVOhCfdbuKzXTSiFOvnd3hu64C3RU107hLOTh
   krP1fSeA5h0tHssJO3/FqBnKR0d/XIE/Gln9tjp6RqdHn9Tc8CRjFArCX
   Yz7KsuXO5er0E3oxn0CoqdDuAcMGYoc8pQGqIcjt3/ukd4k9hcZh0Tfmo
   A==;
X-CSE-ConnectionGUID: 5i+u6gBNSSm1IoosMb8HTw==
X-CSE-MsgGUID: Y4raJREiQ0+LnvW1gKFaRw==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="53239885"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="53239885"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2025 18:59:00 -0800
X-CSE-ConnectionGUID: AhuoRWYgSo2WE34JLwOQDA==
X-CSE-MsgGUID: 2SibpFiUQB6gBhlgPYM3ug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="118787836"
Received: from lkp-server02.sh.intel.com (HELO 76cde6cc1f07) ([10.239.97.151])
  by orviesa008.jf.intel.com with ESMTP; 02 Mar 2025 18:58:57 -0800
Received: from kbuild by 76cde6cc1f07 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tow19-000HrP-03;
	Mon, 03 Mar 2025 02:58:55 +0000
Date: Mon, 3 Mar 2025 10:57:54 +0800
From: kernel test robot <lkp@intel.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	kvm@vger.kernel.org, Farrah Chen <farrah.chen@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [kvm:kvm-coco-queue 60/127] ERROR: modpost:
 "tdx_disable_virtualization_cpu" [arch/x86/kvm/kvm-intel.ko] undefined!
Message-ID: <202503031010.ev5TpPSM-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-coco-queue
head:   9fe4541afcfad987d39790f0a40527af190bf0dd
commit: 0a930010a3d3bb8b04824ee083b51be313b939f1 [60/127] KVM: TDX: Handle vCPU dissociation
config: x86_64-randconfig-077-20250302 (https://download.01.org/0day-ci/archive/20250303/202503031010.ev5TpPSM-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250303/202503031010.ev5TpPSM-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202503031010.ev5TpPSM-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

ERROR: modpost: "enable_tdx" [arch/x86/kvm/kvm-intel.ko] undefined!
>> ERROR: modpost: "tdx_disable_virtualization_cpu" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_vm_init" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_vm_destroy" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_mmu_release_hkid" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_vcpu_create" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_vcpu_free" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_vcpu_load" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_flush_tlb_all" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_flush_tlb_current" [arch/x86/kvm/kvm-intel.ko] undefined!
WARNING: modpost: suppressed 10 unresolved symbol warnings because there were too many)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

