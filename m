Return-Path: <kvm+bounces-43692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A0ABEA9430E
	for <lists+kvm@lfdr.de>; Sat, 19 Apr 2025 13:17:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5A8F518920BD
	for <lists+kvm@lfdr.de>; Sat, 19 Apr 2025 11:17:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 269441C84CD;
	Sat, 19 Apr 2025 11:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MxqH4MKr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A329715665C
	for <kvm@vger.kernel.org>; Sat, 19 Apr 2025 11:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745061445; cv=none; b=Ne2ukxT//B3/AC4GS/w1LvlU+/pl8Z/byFGC32E9z2xTqOW1bbW+p5FlFP41gYoa6bjjDtWNSWh2iONy8EirwUVzuqBIz8IsU5sEQ5/zhHMCaNH4WmnWyZz5IveMHtzWqsayzM8L5G5beIkq8ajtv2tuOuTOtx0/B5miAAnPZqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745061445; c=relaxed/simple;
	bh=twaPTPxrSRUfYcP8Q2Lg0ehwGFBWuSiY9lcXs0+JpzQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=hHoh65V9tK1yrEHNGsoSJ+aj+eZmgYwisLRrwqPD3TCtvfK4QI1ZyybiyRYOXOdnO0kQCfvr8tiSCQ4QtKgUaqHKls/IJttwt08KG3eJPB5jgt1ezLtCHx9w9dHNuaMp7m1Ygv4WrtQFn6ysADlx7+yxr5t3qA+gjZcHOX+4KLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MxqH4MKr; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745061444; x=1776597444;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=twaPTPxrSRUfYcP8Q2Lg0ehwGFBWuSiY9lcXs0+JpzQ=;
  b=MxqH4MKrlc0L6hGBPHF98yf7kEpd4fiOPfUTnv459Qxpnk+SQ63RYABv
   Grxj3hqJYnypSUF2acrzqMKedcmRZalLOuTL1WlsyIdo8w2+/dCxEfOOQ
   +fmptWS3lqiPC/4DxGx5h8x5xeWMDnRD/eEfHvhigsTznMNnezSerhz52
   IaAqk6PtccdvX12DwkEBOLrpAbycuBGG4KYLickkTrRM5fqd6xgSWiXQv
   dcBLn7UtDF+dyqtAlIdTFMrPJ4ZPx6hoe5IBpSt67JfxR2S3r5p+js2NJ
   oYOst0zpO1DZoBQleY8AFC6DcB2LmqD7WqSd4FWeJxKRdWUpzVyj8JYRH
   A==;
X-CSE-ConnectionGUID: bTVYQMvOQZyH1Yse7pZfdg==
X-CSE-MsgGUID: nkkZWqwzQj2Gt6KnuP5WDA==
X-IronPort-AV: E=McAfee;i="6700,10204,11407"; a="58050982"
X-IronPort-AV: E=Sophos;i="6.15,224,1739865600"; 
   d="scan'208";a="58050982"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2025 04:17:23 -0700
X-CSE-ConnectionGUID: HvVrSFfiRIW1jZd0Huidpg==
X-CSE-MsgGUID: i1fjJdb2RI2fmM9whXxT7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,224,1739865600"; 
   d="scan'208";a="154486846"
Received: from lkp-server01.sh.intel.com (HELO 61e10e65ea0f) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 19 Apr 2025 04:17:22 -0700
Received: from kbuild by 61e10e65ea0f with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1u66CF-0003of-1e;
	Sat, 19 Apr 2025 11:17:19 +0000
Date: Sat, 19 Apr 2025 19:16:35 +0800
From: kernel test robot <lkp@intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	kvm@vger.kernel.org, Farrah Chen <farrah.chen@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm:queue 1/11] ERROR: modpost: "kvm_arch_has_irq_bypass"
 [arch/x86/kvm/kvm-amd.ko] undefined!
Message-ID: <202504191926.BiMYxNlQ-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
head:   2ae06ae44beb53e7a19df0d46c7f388e6c5b6eb8
commit: 73e0c567c24a10fb4f750d6a9e90562ee96a6052 [1/11] KVM: SVM: Don't update IRTEs if APICv/AVIC is disabled
config: x86_64-buildonly-randconfig-006-20250419 (https://download.01.org/0day-ci/archive/20250419/202504191926.BiMYxNlQ-lkp@intel.com/config)
compiler: clang version 20.1.2 (https://github.com/llvm/llvm-project 58df0ef89dd64126512e4ee27b4ac3fd8ddf6247)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250419/202504191926.BiMYxNlQ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202504191926.BiMYxNlQ-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "kvm_arch_has_irq_bypass" [arch/x86/kvm/kvm-amd.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

