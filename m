Return-Path: <kvm+bounces-65696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C0897CB4C9B
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 06:44:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3686B3018D5D
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 05:43:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3338628CF56;
	Thu, 11 Dec 2025 05:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DNeGgfva"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D435F20F08D
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 05:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765431815; cv=none; b=oeAyGgnAOu5pgwxdh9tChchcPJlPgnMEMUydQVEdDv8N3kV6uuwAaN88p9RjgZZzM1S93z2z/KWDA30L/JS/D5SyCCimnkLaxnnXWsXgA248q3JheUpYtCoCznsracxcud4VL8bCAwF3MsJwiwBHQV4mZPhn7uBHPlsms5VVsIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765431815; c=relaxed/simple;
	bh=8C3Jr7X1l8TpBRvZp6B109oTdbjj9lF4vCeG//3Doqk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PfNBly8m+tXhgjxN8xrhps3X2Ki0PSRjJLm3DoQv+hO9rCiRXP2wTiK/9NEJsZ1mvGX9IWQ4CfW7JeHQl8Y9fE2Fs6Htlw5IL/2JKO0Vv5sqfBK6v+jdVxB+b3EWG7kd6CYMZ2Gmta2lZ4ly5O2+8dua76HUgDxlKAJUMfkCE/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DNeGgfva; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765431814; x=1796967814;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8C3Jr7X1l8TpBRvZp6B109oTdbjj9lF4vCeG//3Doqk=;
  b=DNeGgfvaSHSA7ceGcf64xKHsq5SLYYnXiO4/iZPK8w74TADC+FVSk/OM
   /NieILl5EH5fN4/vdPNZbN7+WdcDUqj0aXVlyIq3/zOPPXEOK9sYjO0TV
   bYGE4DSJaigq66+AzqYZ1ZlY4vBjkVhrExkyCBEkHn5VH8NQC6OwMs3WB
   qxRiBaSwflBuhxRxzIYp+4oE+lEK2YQkF8hwmHcqMYrV7+pT4HiOhBkK+
   mF/3Rr6i9UlwvMN5zqFtGWS/XGKqbiyDJpRxcFFwLsIvlO/jckmXBBdAS
   UfGUPdwkrJJqVIFJgNSb3KHyTcJ7unX69jpiflzm60EAzzmTFGwVV65Cj
   A==;
X-CSE-ConnectionGUID: Fo4TIa+TTVG243l+Vr+CyQ==
X-CSE-MsgGUID: 0XTUIZY0Q9+mAPlZ34NZqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="66409821"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="66409821"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 21:43:34 -0800
X-CSE-ConnectionGUID: TdeHQIneQXyHdDxufozGQg==
X-CSE-MsgGUID: r3+DuJGcS7ee4VCrh0dOGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="227366004"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa002.jf.intel.com with ESMTP; 10 Dec 2025 21:43:30 -0800
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
Subject: [PATCH v5 03/22] i386/cpu: Reorganize arch lbr structure definitions
Date: Thu, 11 Dec 2025 14:07:42 +0800
Message-Id: <20251211060801.3600039-4-zhao1.liu@intel.com>
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

- Move ARCH_LBR_NR_ENTRIES macro and LBREntry definition before XSAVE
  areas definitions.
- Reorder XSavesArchLBR (area 15) between XSavePKRU (area 9) and
  XSaveXTILECFG (area 17), and reorder the related QEMU_BUILD_BUG_ON
  check to keep the same ordering.

This makes xsave structures to be organized together and makes them
clearer.

Tested-by: Farrah Chen <farrah.chen@intel.com>
Reviewed-by: Zide Chen <zide.chen@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.h | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index c95b772719ce..a183394eca7f 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1652,6 +1652,14 @@ typedef struct {
 
 #define NB_OPMASK_REGS 8
 
+typedef struct {
+    uint64_t from;
+    uint64_t to;
+    uint64_t info;
+} LBREntry;
+
+#define ARCH_LBR_NR_ENTRIES 32
+
 /* CPU can't have 0xFFFFFFFF APIC ID, use that value to distinguish
  * that APIC ID hasn't been set yet
  */
@@ -1729,24 +1737,6 @@ typedef struct XSavePKRU {
     uint32_t padding;
 } XSavePKRU;
 
-/* Ext. save area 17: AMX XTILECFG state */
-typedef struct XSaveXTILECFG {
-    uint8_t xtilecfg[64];
-} XSaveXTILECFG;
-
-/* Ext. save area 18: AMX XTILEDATA state */
-typedef struct XSaveXTILEDATA {
-    uint8_t xtiledata[8][1024];
-} XSaveXTILEDATA;
-
-typedef struct {
-       uint64_t from;
-       uint64_t to;
-       uint64_t info;
-} LBREntry;
-
-#define ARCH_LBR_NR_ENTRIES            32
-
 /* Ext. save area 15: Arch LBR state */
 typedef struct XSaveArchLBR {
     uint64_t lbr_ctl;
@@ -1757,6 +1747,16 @@ typedef struct XSaveArchLBR {
     LBREntry lbr_records[ARCH_LBR_NR_ENTRIES];
 } XSaveArchLBR;
 
+/* Ext. save area 17: AMX XTILECFG state */
+typedef struct XSaveXTILECFG {
+    uint8_t xtilecfg[64];
+} XSaveXTILECFG;
+
+/* Ext. save area 18: AMX XTILEDATA state */
+typedef struct XSaveXTILEDATA {
+    uint8_t xtiledata[8][1024];
+} XSaveXTILEDATA;
+
 QEMU_BUILD_BUG_ON(sizeof(XSaveAVX) != 0x100);
 QEMU_BUILD_BUG_ON(sizeof(XSaveBNDREG) != 0x40);
 QEMU_BUILD_BUG_ON(sizeof(XSaveBNDCSR) != 0x40);
@@ -1764,9 +1764,9 @@ QEMU_BUILD_BUG_ON(sizeof(XSaveOpmask) != 0x40);
 QEMU_BUILD_BUG_ON(sizeof(XSaveZMM_Hi256) != 0x200);
 QEMU_BUILD_BUG_ON(sizeof(XSaveHi16_ZMM) != 0x400);
 QEMU_BUILD_BUG_ON(sizeof(XSavePKRU) != 0x8);
+QEMU_BUILD_BUG_ON(sizeof(XSaveArchLBR) != 0x328);
 QEMU_BUILD_BUG_ON(sizeof(XSaveXTILECFG) != 0x40);
 QEMU_BUILD_BUG_ON(sizeof(XSaveXTILEDATA) != 0x2000);
-QEMU_BUILD_BUG_ON(sizeof(XSaveArchLBR) != 0x328);
 
 typedef struct ExtSaveArea {
     uint32_t feature, bits;
-- 
2.34.1


