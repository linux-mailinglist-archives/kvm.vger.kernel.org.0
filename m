Return-Path: <kvm+bounces-65695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D53C7CB4C8F
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 06:43:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1E08F3010E46
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 05:43:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D131328BA95;
	Thu, 11 Dec 2025 05:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SPIA8V3b"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25CB120F08D
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 05:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765431811; cv=none; b=MlX5sR7XwKdhGYRp/v48Eo26AhGK+MUiXaCJH+csug2BSbDCQSixSVi0uRHrvL9Km0Ta90AYQ4pPikZ1K14waoh/wzMkVLCS9nMYGPH6j4gp0PV/EMJaZ9UI/rwaJD1sMkoeQBaBngrrWTDmKbwE8y1r3YoYcbcwaIHZuMDNGVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765431811; c=relaxed/simple;
	bh=enKcO38L6D4368mFk9WuGh+dSr2WFd6BUxl4+hq0Pz4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QkdMZwpIOKg6Q+0Neh+R/RVFC3G+DFG/ZO5MsIPuiG2KhcsJrqB7kdgWsOFUovLnP1cJOt115LlKUCY2gtKZzXihcBZNU0/fd2aKAxHykb0BmQiUrlrbh6jVPkACDYbH1CWUg5cv6jOj88MuHxtqZRZ594/GO8xCf1wNToJ4UdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SPIA8V3b; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765431810; x=1796967810;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=enKcO38L6D4368mFk9WuGh+dSr2WFd6BUxl4+hq0Pz4=;
  b=SPIA8V3bypvEie2j7FkZrgVL8Ao9MSCEODb4UpXuzMK02fLrmC2T5BnX
   3H4tfHy3aRsyl18wY+TQ8TNGaHQZBO8rXRew7haiU6+0ix29cusgv0U2i
   96Yw1x/2qXOK/7Z0FIX09INgDxOREs0rJBy5cotohumcd71Qymo+K2+gd
   nWaBEkXbGvWKAAWwz2ctf+2x1vovZ4nOAZqKGL/LhvrDrjzH9vssSi4/S
   ljzs6G+GUkkyWYVrAYaU+QJc4J8FpTxANZHdxq2whQIMPcIJsumAmbIos
   trGa7VABG58iSiZGBuISvdowBky/pjFb13vQf2sP7rJYeBfNkYUTLtoFR
   A==;
X-CSE-ConnectionGUID: 8+1kdseER9G9N42O5JXNKA==
X-CSE-MsgGUID: VscnLsIDSEKBbvJNWq0r/w==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="66409812"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="66409812"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 21:43:30 -0800
X-CSE-ConnectionGUID: lrkqon5iRo2SDWa7Pj3FrA==
X-CSE-MsgGUID: QXPI0j7ORYqGIEJCmadyVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="227365997"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa002.jf.intel.com with ESMTP; 10 Dec 2025 21:43:26 -0800
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
Subject: [PATCH v5 02/22] i386/cpu: Clean up arch lbr xsave struct and comment
Date: Thu, 11 Dec 2025 14:07:41 +0800
Message-Id: <20251211060801.3600039-3-zhao1.liu@intel.com>
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

Arch LBR state is area 15, not 19. Fix this comment. And considerring
other areas don't mention user or supervisor state, for consistent
style, remove "Supervisor mode" from its comment.

Moreover, rename XSavesArchLBR to XSaveArchLBR since there's no need to
emphasize XSAVES in naming; the XSAVE related structure is mainly
used to represent memory layout.

In addition, arch lbr specifies its offset of xsave component as 0. But
this cannot help on anything. The offset of ExtSaveArea is initialized
by accelerators (e.g., hvf_cpu_xsave_init(), kvm_cpu_xsave_init() and
x86_tcg_cpu_xsave_init()), so explicitly setting the offset doesn't
work and CPUID 0xD encoding has already ensure supervisor states won't
have non-zero offsets. Drop the offset initialization and its comment
from the xsave area of arch lbr.

Tested-by: Farrah Chen <farrah.chen@intel.com>
Reviewed-by: Zide Chen <zide.chen@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 3 +--
 target/i386/cpu.h | 8 ++++----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index c598f09f3d50..34a4c2410d03 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -2058,8 +2058,7 @@ ExtSaveArea x86_ext_save_areas[XSAVE_STATE_AREA_COUNT] = {
     },
     [XSTATE_ARCH_LBR_BIT] = {
         .feature = FEAT_7_0_EDX, .bits = CPUID_7_0_EDX_ARCH_LBR,
-        .offset = 0 /*supervisor mode component, offset = 0 */,
-        .size = sizeof(XSavesArchLBR),
+        .size = sizeof(XSaveArchLBR),
     },
     [XSTATE_XTILE_CFG_BIT] = {
         .feature = FEAT_7_0_EDX, .bits = CPUID_7_0_EDX_AMX_TILE,
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index cee1f692a1c3..c95b772719ce 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1747,15 +1747,15 @@ typedef struct {
 
 #define ARCH_LBR_NR_ENTRIES            32
 
-/* Ext. save area 19: Supervisor mode Arch LBR state */
-typedef struct XSavesArchLBR {
+/* Ext. save area 15: Arch LBR state */
+typedef struct XSaveArchLBR {
     uint64_t lbr_ctl;
     uint64_t lbr_depth;
     uint64_t ler_from;
     uint64_t ler_to;
     uint64_t ler_info;
     LBREntry lbr_records[ARCH_LBR_NR_ENTRIES];
-} XSavesArchLBR;
+} XSaveArchLBR;
 
 QEMU_BUILD_BUG_ON(sizeof(XSaveAVX) != 0x100);
 QEMU_BUILD_BUG_ON(sizeof(XSaveBNDREG) != 0x40);
@@ -1766,7 +1766,7 @@ QEMU_BUILD_BUG_ON(sizeof(XSaveHi16_ZMM) != 0x400);
 QEMU_BUILD_BUG_ON(sizeof(XSavePKRU) != 0x8);
 QEMU_BUILD_BUG_ON(sizeof(XSaveXTILECFG) != 0x40);
 QEMU_BUILD_BUG_ON(sizeof(XSaveXTILEDATA) != 0x2000);
-QEMU_BUILD_BUG_ON(sizeof(XSavesArchLBR) != 0x328);
+QEMU_BUILD_BUG_ON(sizeof(XSaveArchLBR) != 0x328);
 
 typedef struct ExtSaveArea {
     uint32_t feature, bits;
-- 
2.34.1


