Return-Path: <kvm+bounces-52161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A41FAB01DE2
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 15:39:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5A559B47D1D
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 13:34:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69F5A2E0401;
	Fri, 11 Jul 2025 13:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f8k9Hj+t"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC482D8385;
	Fri, 11 Jul 2025 13:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752240864; cv=none; b=ecjWps1FAtR16OChmiTvfSm19FejbBEmkg9gJS8PHGaHELNqhL9jGOrH7C97VeMiSiVeK3mbNH2iN5VXrxcO6tzT06OYk3gC8iB/rJIDAzVoMf7lmxVDSZIjTwZe9pofg1Ox/hifYgo911rn0zCtYxIY7+0IyMdFIvOMZ2d6XQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752240864; c=relaxed/simple;
	bh=hIuaHIUW/2tBZyLHxK7pwAlBg9QJ/ynlLfhkCZird+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S1ME/YDoATAhPmtqfNgBJ7/ibsIlNGCLzML09JxN8dMqmM5dW90l3xTEG18KkMhFV+3oAmSu382QO04cj8z87rd7+21yXoHxplv88lWAIgcilwwN3iAO6Psb7Zw7aRbs4yRbbAp2YkmYYMhsnoediO5VRYVfNnjgWe9fD8h2SKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f8k9Hj+t; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752240862; x=1783776862;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hIuaHIUW/2tBZyLHxK7pwAlBg9QJ/ynlLfhkCZird+Q=;
  b=f8k9Hj+tMTBIIUMCQ67XKhoNJMIIBd4uVgESGvgynITO3y/wL/vaHJJX
   xfZae5GiIRpPWuwZo2hOvaz8Uw7ppbvlhguW7rqFqqHmyU8QIHJsJrCQF
   HuOXR/cqR2AXnhH+AzrFEpjnk4rqKKFxo5rPL//p+hiRQvrwRpcPRJEOQ
   JfYgKX6d0GsMVTFUOTITjmGSf073cm5hMeJcDbpQ0mSRE/OHP64bw9o3t
   IaeTvMgTwFDlNBuSv0h2GwYv1VALWYjPI2yRR33+wbRUnZ/MPQDy93mgW
   NqxdGHkH0uKcllLt/YZKVCrPWqXH56Iu3P+mKnwdL+Af0B3reYtEex2x9
   g==;
X-CSE-ConnectionGUID: U2a9H2PuSquC8vuPOHDInA==
X-CSE-MsgGUID: 7zG92DFYSfqfGSpUV2AQxA==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="65603392"
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="65603392"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 06:34:21 -0700
X-CSE-ConnectionGUID: afqFL2hwTwOMOffUEbd4AA==
X-CSE-MsgGUID: NzGjN/0zS6+L/6GWYO+RQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="187349197"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa001.fm.intel.com with ESMTP; 11 Jul 2025 06:34:17 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-coco@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Kai Huang <kai.huang@intel.com>,
	binbin.wu@linux.intel.com,
	yan.y.zhao@intel.com,
	reinette.chatre@intel.com,
	isaku.yamahata@intel.com,
	adrian.hunter@intel.com,
	tony.lindgren@intel.com,
	xiaoyao.li@intel.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH v2 0/3] TDX: Clean up the definitions of TDX ATTRIBUTES
Date: Fri, 11 Jul 2025 21:26:17 +0800
Message-ID: <20250711132620.262334-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Although some duplications were identified during the community review
of TDX KVM base support[1][2], a few slipped through unnoticed due to
the simultaneous evolution of the TD guest part.

Patch 1 fixes the typo. Patch 2 removes the redundant definitions of
TD ATTRIBUTES bits. Patch 3 rename KVM_SUPPORTED_TD_ATTRS to include
"TDX" in it, based on Sean's preference[3].

Note, this series doesn't rename TDX_ATTR_* in asm/shared/tdx.h to
TDX_TD_ATTR_*, so that KVM_SUPPORTED_TDX_TD_ATTRS in patch 3 looks
a little inconsistent. Because I'm not sure what the preference of tip
maintainers on the name is. So I only honor KVM maintainer's preference
and leave the stuff outside KVM unchanged.

[1] https://lore.kernel.org/all/e5387c7c-9df8-4e39-bbe9-23e8bb09e527@intel.com/
[2] https://lore.kernel.org/all/25bf543723a176bf910f27ede288f3d20f20aed1.camel@intel.com/
[3] https://lore.kernel.org/all/aG0uyLwxqfKSX72s@google.com/


Changes in v2:
 - collect Reviewed-by;
 - Explains the impact of the change in patch 1 changelog;
 - Add patch 3.

v1: https://lore.kernel.org/all/20250708080314.43081-1-xiaoyao.li@intel.com/ 

Xiaoyao Li (3):
  x86/tdx: Fix the typo of TDX_ATTR_MIGRTABLE
  KVM: TDX: Remove redundant definitions of TDX_TD_ATTR_*
  KVM: TDX: Rename KVM_SUPPORTED_TD_ATTRS to KVM_SUPPORTED_TDX_TD_ATTRS

 arch/x86/coco/tdx/debug.c         | 2 +-
 arch/x86/include/asm/shared/tdx.h | 4 ++--
 arch/x86/kvm/vmx/tdx.c            | 6 +++---
 arch/x86/kvm/vmx/tdx_arch.h       | 6 ------
 4 files changed, 6 insertions(+), 12 deletions(-)


base-commit: e4775f57ad51a5a7f1646ac058a3d00c8eec1e98
prerequisite-patch-id: 96c55dfc551bf62e0b18e75547ba3bf671e30ee8
-- 
2.43.0


