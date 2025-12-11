Return-Path: <kvm+bounces-65715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CCE0ACB4D28
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 06:53:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E6241303658E
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 05:51:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D9D82D8799;
	Thu, 11 Dec 2025 05:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oHOwMsq7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1E02D6624
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 05:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765431889; cv=none; b=oy30zEwBEvlbkN2xO60aVpNgMuj8qCF6ryJcxLuID6ulQvdKk/MPla41sAwhLgmTieWlgVyQqM+2PzYG0kopI1+YgVZqKDecIY9ifY6W8OVFRY3z7BXENm7inbJ3taHkytaTXGrAxrmEm71f/bJtabIBX6K0zzudPjj+AF7YYBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765431889; c=relaxed/simple;
	bh=0uF8jj575zYxVcWmkztmsgjmlH5SFSks+bBKxFEAv3A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UoxVBKlSlkiKMLc3hWvrV0jDLbUSx+U+IivBZUrBPh6qrVZmKOLpgMONb+qHhcmVNVGwzwGILevvZ05bdtqKnVTnEQKIl3S9jScZYXCBZzDogq4F+h43ayJX6Yws7KHUyIqtUZj7q+h77xD0bWTKhgdw+UD8yclJH4fnlZ62pfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oHOwMsq7; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765431888; x=1796967888;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0uF8jj575zYxVcWmkztmsgjmlH5SFSks+bBKxFEAv3A=;
  b=oHOwMsq7DLPjcY5QA4388xUzR9VdeteObs0cLdpOeGZkEsOWpUpSe33N
   7Lr1Bw8dJW1yNvcLvMYC1u8LMKqjpuDzSRQLK+9M69onin4NvyA3wq8dy
   4mb8YnO/+yEy88mjHrPlj4oD/bTyB0RGEGyQiAuEj7jTSX7yLHY8EDI61
   TVgclV3C8Yg7SmogOmABa0XRED3JjdlmfHPWby12ry8a47N6SZ2OVcQel
   kiaWfml6jxhwtemQXvGFlf4V2AEajHSJSOFmHobpEAiu8dFedCrkQbEds
   vPMQzvsP1fQ46EmJM4XtqpVv7Cxc087tSelK3FuwNeUT14s5/fxfehMb4
   Q==;
X-CSE-ConnectionGUID: 1C2aAZKKQ16u8y4wA3Mp0Q==
X-CSE-MsgGUID: mWcctg8YSKK2g7AzD3GPeg==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="66410020"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="66410020"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 21:44:48 -0800
X-CSE-ConnectionGUID: R+WptcuRQoWiK19k3FqoBQ==
X-CSE-MsgGUID: LYgSZ0qYRROV8ROnrBh0cQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="227366269"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa002.jf.intel.com with ESMTP; 10 Dec 2025 21:44:44 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Chao Gao <chao.gao@intel.com>,
	Xin Li <xin@zytor.com>,
	John Allen <john.allen@amd.com>,
	Babu Moger <babu.moger@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Zide Chen <zide.chen@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v5 22/22] i386/tdx: Add CET SHSTK/IBT into the supported CPUID by XFAM
Date: Thu, 11 Dec 2025 14:08:01 +0800
Message-Id: <20251211060801.3600039-23-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251211060801.3600039-1-zhao1.liu@intel.com>
References: <20251211060801.3600039-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chenyi Qiang <chenyi.qiang@intel.com>

So that it can be configured in TD guest.

And considerring CET_U and CET_S bits are always same in supported
XFAM reported by TDX module, i.e., either 00 or 11. So, only need to
choose one of them.

Tested-by: Farrah Chen <farrah.chen@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes Since v3:
 - Refine the commit message.
---
 target/i386/kvm/tdx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index a3444623657f..01619857685b 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -526,6 +526,8 @@ TdxXFAMDep tdx_xfam_deps[] = {
     { XSTATE_OPMASK_BIT,    { FEAT_7_0_EDX, CPUID_7_0_EDX_AVX512_FP16 } },
     { XSTATE_PT_BIT,        { FEAT_7_0_EBX, CPUID_7_0_EBX_INTEL_PT } },
     { XSTATE_PKRU_BIT,      { FEAT_7_0_ECX, CPUID_7_0_ECX_PKU } },
+    { XSTATE_CET_U_BIT,     { FEAT_7_0_ECX, CPUID_7_0_ECX_CET_SHSTK } },
+    { XSTATE_CET_U_BIT,     { FEAT_7_0_EDX, CPUID_7_0_EDX_CET_IBT } },
     { XSTATE_XTILE_CFG_BIT, { FEAT_7_0_EDX, CPUID_7_0_EDX_AMX_BF16 } },
     { XSTATE_XTILE_CFG_BIT, { FEAT_7_0_EDX, CPUID_7_0_EDX_AMX_TILE } },
     { XSTATE_XTILE_CFG_BIT, { FEAT_7_0_EDX, CPUID_7_0_EDX_AMX_INT8 } },
-- 
2.34.1


