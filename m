Return-Path: <kvm+bounces-52461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C138AB0562F
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 11:21:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 13B18189F211
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 09:21:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5281F2D63E8;
	Tue, 15 Jul 2025 09:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BhMwfBf0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D5D1DED5F;
	Tue, 15 Jul 2025 09:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752571287; cv=none; b=cTCx/ZprmIfk9Q19FWRnDkiax0eeL4YzVip+y6MhAdzcJjqKVu9zgOTQes1+DFtFZiR6A7PE3HX3nYi4sXipHpg2qT+3lRDWtEBVR89ZkM2a/7AB3B2mB1UlTX7Xhn4DkWCdSrAUPOYbOYjQvc2UYnguLfShh1PrIfZ1Ih3JVmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752571287; c=relaxed/simple;
	bh=NunjY/ejf2tMjN3S6lPzJGqxKykBxqbGhL/h+mQFzrg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IhCX3xFbGAe1mg3Nmzf4LvUJMHiKEenFpey6VMffRoDFNAx1gNmrl8oLo6XoeydNQ1rJDhNVsU+bl+kWxqHzi4EaA7sKixHvc6qoES+A5OuTl9ic9yUaYvBVUq+KDYAPtEeSnGd7dCxOnWCdvl7X3PVIXP3FL7QPm02Kb3oATpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BhMwfBf0; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752571286; x=1784107286;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NunjY/ejf2tMjN3S6lPzJGqxKykBxqbGhL/h+mQFzrg=;
  b=BhMwfBf05eRY17LyAx3G2dczfb+qfppL7XZoTkgzuvCYMpWZnoyBhxlV
   EwrNO4A/nlrjY+cwdYrNdJi79dmh6OXRiQNgCh6LmhImUQs/TDdQA3dXT
   thsHCk4fIk0McQLE2vCiRhm2AA0sCP8krmGJIFzqZ2Gh56l/v7zOf+pLv
   Y/9AqWXmZ3HflmQyHFAcXzeifSw/ZP9yttFElIar90oD/R9f8FQKylAlp
   9Uyx+y2B17HDajVcpymMQ2jgjMcFS9apBHqm9wOEbbZNjrjtFCQG1u1Ov
   2WQU7dOiV6bj+TbXJnLgg4G73f2FRWRX7Z+/djKRXFaGlDNcHAfybMvs7
   w==;
X-CSE-ConnectionGUID: hcrXXnzOQR6cTpyvgQ+eNQ==
X-CSE-MsgGUID: KpdgQErhSlClgPaDJcvN+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54003311"
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="54003311"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 02:21:25 -0700
X-CSE-ConnectionGUID: /3fAQin6R2iX2phJy2GJOg==
X-CSE-MsgGUID: sBisKdXmR3St1I0hpFd4MQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="188183672"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa001.fm.intel.com with ESMTP; 15 Jul 2025 02:21:21 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: "Kirill A. Shutemov" <kas@kernel.org>,
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
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Kai Huang <kai.huang@intel.com>,
	binbin.wu@linux.intel.com,
	yan.y.zhao@intel.com,
	reinette.chatre@intel.com,
	adrian.hunter@intel.com,
	tony.lindgren@intel.com,
	xiaoyao.li@intel.com
Subject: [PATCH v3 0/4] TDX: Clean up the definitions of TDX TD ATTRIBUTES
Date: Tue, 15 Jul 2025 17:13:08 +0800
Message-ID: <20250715091312.563773-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The main purpose of this series was to remove redundant macros between
core TDX and KVM, along with a typo fix. They were implemented as patch1
and patch2.

During the review of v1 and v2, there was encouragement to refine the
names of the macros related to TD attributes to clarify their scope.
Thus patch3 and patch 4 are added.

Discussion details can be found in previrous versions.


Changes in v3:
 - use the changelog provided by Rick for patch 1;
 - collect Reviewed-by on patch 4;
 - Add patch 3;

v2: https://lore.kernel.org/all/20250711132620.262334-1-xiaoyao.li@intel.com/
Changes in v2:
 - collect Reviewed-by;
 - Explains the impact of the change in patch 1 changelog;
 - Add patch 3.

v1: https://lore.kernel.org/all/20250708080314.43081-1-xiaoyao.li@intel.com/ 

Xiaoyao Li (4):
  x86/tdx: Fix the typo in TDX_ATTR_MIGRTABLE
  KVM: TDX: Remove redundant definitions of TDX_TD_ATTR_*
  x86/tdx: Rename TDX_ATTR_* to TDX_TD_ATTR_*
  KVM: TDX: Rename KVM_SUPPORTED_TD_ATTRS to KVM_SUPPORTED_TDX_TD_ATTRS

 arch/x86/coco/tdx/debug.c         | 26 ++++++++--------
 arch/x86/coco/tdx/tdx.c           |  8 ++---
 arch/x86/include/asm/shared/tdx.h | 50 +++++++++++++++----------------
 arch/x86/kvm/vmx/tdx.c            |  4 +--
 arch/x86/kvm/vmx/tdx_arch.h       |  6 ----
 5 files changed, 44 insertions(+), 50 deletions(-)

-- 
2.43.0


