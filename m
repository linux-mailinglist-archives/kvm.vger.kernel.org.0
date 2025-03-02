Return-Path: <kvm+bounces-39819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 22908A4B416
	for <lists+kvm@lfdr.de>; Sun,  2 Mar 2025 19:32:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0415D188EA72
	for <lists+kvm@lfdr.de>; Sun,  2 Mar 2025 18:33:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A7921EB1A1;
	Sun,  2 Mar 2025 18:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QeSfQLQf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1551ADC98
	for <kvm@vger.kernel.org>; Sun,  2 Mar 2025 18:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740940372; cv=none; b=TE0hLFlOtY16mR+RBt2ObAX0bpW2lwFnc7vVxpep0R/jQQGnZ+9tqnemE2bbYISrSY60QVpb9hPWZzzdQwCLINOBM8HdeLmUIvO9bbcOeIt5CbnkZBPhiU81b5VMsumgltQ635RGZ0ufUHBsY019hglqrOXnx7sPm2jC45cYsB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740940372; c=relaxed/simple;
	bh=L0zY7H39BPgrQsaUTKK99onsMr5XmylhBQKwZxrgLyA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=T9MkazkIG/XnCsy7WoxXwhdoshTKUmEIpsv8ZA4p1LQ2KI2I2/KTzjIqGMVtr8YH4cqgOtUrS9xAIFeJaakSqsZ6ARr0g+IpAOsTdhJs7MuCvVCcSjgN4c1EBrVCpepYVlUDlDHYgMiMz/ca14tj7XxRa9B0IR5obBK+D5wNGpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QeSfQLQf; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740940369; x=1772476369;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=L0zY7H39BPgrQsaUTKK99onsMr5XmylhBQKwZxrgLyA=;
  b=QeSfQLQfvpqYAlTV5mlsvHSCUXVX6HnyMkFH1kkSZlW1nXzjzMRHAfPC
   RrLR+ktGf3gp/iDjcXW4PSfsCeDu401rL7WykRiM6zpf5gqG+qoRK+DIg
   rMkGeJjia1CNYewnpVeSjdfw1k9JSP6WGHmdinM0rTwqwWLR6cxjX5uVz
   eSH3Yf6A3EMMMcGR84sUDu4OuGipQfXbBW1NxYPRe+LujilL63FWeR99L
   7fV6ap74OqX+spxOPPdBBRRcGfVkhd9iFU2gh3wHc713y6cSGC7SYn3SJ
   fVCBJAjgYznedYF+kdTrA5Yil84SB/yEkznVGfKN1LcwWJcqUeI2PBMoE
   A==;
X-CSE-ConnectionGUID: Hk3wDI4IQEKWTktizHc8OQ==
X-CSE-MsgGUID: QQoZOOlQSdiMiv8/mgUpQA==
X-IronPort-AV: E=McAfee;i="6700,10204,11361"; a="45467575"
X-IronPort-AV: E=Sophos;i="6.13,328,1732608000"; 
   d="scan'208";a="45467575"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2025 10:32:49 -0800
X-CSE-ConnectionGUID: dVgVgaj2SkCImpXuPyougA==
X-CSE-MsgGUID: 2dYm69rGRy6e+CqgFZpTqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="123048396"
Received: from lkp-server02.sh.intel.com (HELO 76cde6cc1f07) ([10.239.97.151])
  by orviesa005.jf.intel.com with ESMTP; 02 Mar 2025 10:32:46 -0800
Received: from kbuild by 76cde6cc1f07 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1too7I-000HWn-1I;
	Sun, 02 Mar 2025 18:32:44 +0000
Date: Mon, 3 Mar 2025 02:32:33 +0800
From: kernel test robot <lkp@intel.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	kvm@vger.kernel.org, Farrah Chen <farrah.chen@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [kvm:kvm-coco-queue 32/127] ERROR: modpost: "tdx_vcpu_create"
 [arch/x86/kvm/kvm-intel.ko] undefined!
Message-ID: <202503030235.MiYJbBOG-lkp@intel.com>
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
commit: b6c5df065013b1ccb29a23f59f7ad4e8a366a6fd [32/127] KVM: TDX: create/free TDX vcpu structure
config: x86_64-randconfig-077-20250302 (https://download.01.org/0day-ci/archive/20250303/202503030235.MiYJbBOG-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250303/202503030235.MiYJbBOG-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202503030235.MiYJbBOG-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

ERROR: modpost: "tdx_vm_init" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_vm_destroy" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_mmu_release_hkid" [arch/x86/kvm/kvm-intel.ko] undefined!
>> ERROR: modpost: "tdx_vcpu_create" [arch/x86/kvm/kvm-intel.ko] undefined!
>> ERROR: modpost: "tdx_vcpu_free" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_vm_ioctl" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "enable_tdx" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_cleanup" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_bringup" [arch/x86/kvm/kvm-intel.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

