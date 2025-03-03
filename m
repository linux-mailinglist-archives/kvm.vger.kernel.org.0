Return-Path: <kvm+bounces-39913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ABD00A4CA81
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 18:57:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 37C33174AEF
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 17:52:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E519B14A62B;
	Mon,  3 Mar 2025 17:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BvRp+RpF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4241F4C83
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 17:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741024354; cv=none; b=reCvM9zjtIfx8/FU3jx805nm7WbpbKlrf+eO2s7UyISpfK1jzn8Kd/hhGtIHgcqhwUpVehtay8Q49QJvbncHa3ZTeGtD0Zk+SyUPVSoY7/4XXD9id5ZCwtgV842IQBPTpOrC91HvCvTCyB09Z+C2gNOCV6jRY0UMVHhXnNCTpqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741024354; c=relaxed/simple;
	bh=9F2LtWXXlSX30cTWgq26RNKeGiOlNMUkTPieGkfimyU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=S7wTE6UQ/N0DxKpD5HPToIhfr19zWYbshsyKUjbDRQnUqc7Kh2r6b+46XJGgHHNcACGF08/YTzmOq1hoIOZZfxaZr/ahDKX/uFu1hhTbdyxDiyBAwW3BJ/KZU9jKMsbruI/s6kIFQp6DRBtsJtSQASX2N6Ki+co3GsWhHJKbpLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BvRp+RpF; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741024353; x=1772560353;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=9F2LtWXXlSX30cTWgq26RNKeGiOlNMUkTPieGkfimyU=;
  b=BvRp+RpFK2OgaltEr57ZpAt44hWd3oua1hhGM4Emuz7kHqx9eAaur7Hm
   I/Vb0GCZtzCpbWro624XzQ80t04qUkKAUq1XvSoBZ7C4rFLByJNcgnaiZ
   42FbKTKRE3BeLWPUIfF8CXDiF4YcXIo0+F1zQCoCo86h/5ZkKYvg572jK
   IiUHEUqlQnSejLygijSkpT0tkOYMxwprJsqKEG9dHGGILZstL6riUfmEf
   rMWw1V3wQ1x8bOVSACwtazXL42UhTe9iaRX30zJAAU+MW4R4FwD0WeT5B
   MAFl3W679/usVBCI8gbtQWQd1Lfb8K3kYA3zn46sCyNESIBKA4tPaY73d
   A==;
X-CSE-ConnectionGUID: /GeComAVTnigVhFBIuy4hA==
X-CSE-MsgGUID: 0pTUop47Ssa8rao7evTEXQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="41157025"
X-IronPort-AV: E=Sophos;i="6.13,330,1732608000"; 
   d="scan'208";a="41157025"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 09:52:32 -0800
X-CSE-ConnectionGUID: hxRG7/4ISYCjYaArTqD1hQ==
X-CSE-MsgGUID: dHtl9BCLTcGgrSKPYQh+cA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,330,1732608000"; 
   d="scan'208";a="122736352"
Received: from lkp-server02.sh.intel.com (HELO 76cde6cc1f07) ([10.239.97.151])
  by fmviesa005.fm.intel.com with ESMTP; 03 Mar 2025 09:52:30 -0800
Received: from kbuild by 76cde6cc1f07 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tp9xr-000Imj-2h;
	Mon, 03 Mar 2025 17:52:27 +0000
Date: Tue, 4 Mar 2025 01:51:48 +0800
From: kernel test robot <lkp@intel.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	kvm@vger.kernel.org, Farrah Chen <farrah.chen@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Binbin Wu <binbin.wu@linux.intel.com>
Subject: [kvm:kvm-coco-queue 113/127] ERROR: modpost: "tdx_interrupt_allowed"
 [arch/x86/kvm/kvm-intel.ko] undefined!
Message-ID: <202503040123.42BYAY9p-lkp@intel.com>
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
commit: 322c70bc596a64cdc219c028c7d765ee82c811f9 [113/127] KVM: TDX: Handle TDX PV HLT hypercall
config: x86_64-randconfig-077-20250302 (https://download.01.org/0day-ci/archive/20250304/202503040123.42BYAY9p-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250304/202503040123.42BYAY9p-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202503040123.42BYAY9p-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "tdx_interrupt_allowed" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "enable_tdx" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_disable_virtualization_cpu" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_vm_init" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_vm_destroy" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_mmu_release_hkid" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_vcpu_create" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_vcpu_free" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_vcpu_reset" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_prepare_switch_to_guest" [arch/x86/kvm/kvm-intel.ko] undefined!
WARNING: modpost: suppressed 21 unresolved symbol warnings because there were too many)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

