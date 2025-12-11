Return-Path: <kvm+bounces-65709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 69352CB4CFE
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 06:51:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 27CC7300162B
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 05:51:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFCB42C0297;
	Thu, 11 Dec 2025 05:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PmBjxG4v"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5E22BEC42
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 05:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765431867; cv=none; b=B668kG60kI9H06t6LY2YBD12fmJz2cbqULR+5E7YsNgctMCOrK6bCietNchgTo5VN92CKxSrsis0DX+n7udRy+GANag9wrYIwIae91urGgqh8c5GARFk4WbnVhV4dfDmcJiKVEh0DUy3vl2gFXdIo2aPdSG2XYz0MZjBQoI6jnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765431867; c=relaxed/simple;
	bh=H43GacNZ74LpZvq1iBt7jAREOYz4e8zAxG+jaXrh3os=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OkYl8pWDnqnbJ0ugBj4PiAP11jO+GOD5ODWDHLHWIOMf+GGpsxs7b59L+dxf60Sty4+vCS+eqvrGJ0Ypo6cA2+H9NP/l1dCfxbE7rpsHRfm7gncU2JIJVLmlbXW9QT+epPUgycCNu2V3tmRzKlXL9DDbhnkgZH8EZZRk3RhJtFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PmBjxG4v; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765431866; x=1796967866;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=H43GacNZ74LpZvq1iBt7jAREOYz4e8zAxG+jaXrh3os=;
  b=PmBjxG4vtCu3/IjHX1AwhVB1/hSHg3oipq/Pr2f5SYVL+YS70wQy/8V8
   BGM1gXwKKGp0LH9ujbPdfOjhIRz+mIvw34PDj0LsL3cmnQDKSl8alNNTG
   YkieA/sjR+ZPetV27huZuPkWx6h/pmnlvNmANvrydd1QahH3heuwdcGhp
   JQvn2RWjRF+fqo+/BKOysq81jkcl7pAf+XF51parfoYrTV18MBYwxGBgp
   W7vfUPexzgAf1JvKvMTN9nu4+3IvdF67i11pnKAgvVaEyMOqdHThnjuRY
   qXiBHWarqPoFF22nRWh1USKQf3LPcQ+Tc7j4d9HLbbaTquz8pSvuxo4fJ
   w==;
X-CSE-ConnectionGUID: sGEPcEZJSwmj744qIsCDlg==
X-CSE-MsgGUID: Hkm4fsOqTEmk1sEvkxdMNg==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="66409951"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="66409951"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 21:44:25 -0800
X-CSE-ConnectionGUID: Fml8hIaRRhG2ftMfKKQcAQ==
X-CSE-MsgGUID: XfpiWL36QduylJDRnqf97A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="227366193"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.39])
  by orviesa002.jf.intel.com with ESMTP; 10 Dec 2025 21:44:22 -0800
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
Subject: [PATCH v5 16/22] i386/cpu: Migrate MSR_IA32_PL0_SSP for FRED and CET-SHSTK
Date: Thu, 11 Dec 2025 14:07:55 +0800
Message-Id: <20251211060801.3600039-17-zhao1.liu@intel.com>
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

From: "Xin Li (Intel)" <xin@zytor.com>

Both FRED and CET-SHSTK need MSR_IA32_PL0_SSP, so add the vmstate for
this MSR.

When CET-SHSTK is not supported, MSR_IA32_PL0_SSP keeps accessible, but
its value doesn't take effect. Therefore, treat this vmstate as a
subsection rather than a fix for the previous FRED vmstate.

Tested-by: Farrah Chen <farrah.chen@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Co-developed-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes Since v4:
 - Check if pl0_ssp is used instead of checking CPUIDs.

Changes Since v3:
 - New commit.
---
 target/i386/machine.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/target/i386/machine.c b/target/i386/machine.c
index 45b7cea80aa7..bf13f7f0f66e 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -1668,6 +1668,28 @@ static const VMStateDescription vmstate_triple_fault = {
     }
 };
 
+static bool pl0_ssp_needed(void *opaque)
+{
+    X86CPU *cpu = opaque;
+
+    /*
+     * CPUID_7_1_EAX_FRED and CPUID_7_0_ECX_CET_SHSTK are checked because
+     * if all of these bits are zero and the MSR will not be settable.
+     */
+    return !!(cpu->env.pl0_ssp);
+}
+
+static const VMStateDescription vmstate_pl0_ssp = {
+    .name = "cpu/msr_pl0_ssp",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = pl0_ssp_needed,
+    .fields = (const VMStateField[]) {
+        VMSTATE_UINT64(env.pl0_ssp, X86CPU),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
 const VMStateDescription vmstate_x86_cpu = {
     .name = "cpu",
     .version_id = 12,
@@ -1817,6 +1839,7 @@ const VMStateDescription vmstate_x86_cpu = {
 #endif
         &vmstate_arch_lbr,
         &vmstate_triple_fault,
+        &vmstate_pl0_ssp,
         NULL
     }
 };
-- 
2.34.1


