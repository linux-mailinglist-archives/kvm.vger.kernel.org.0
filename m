Return-Path: <kvm+bounces-42244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EC78AA76236
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 10:30:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A3F271654A5
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 08:30:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 336441F09BD;
	Mon, 31 Mar 2025 08:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="gZFEitNC"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2141A1D5178;
	Mon, 31 Mar 2025 08:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743409468; cv=none; b=OWutZy+o3b4e0Y4kOznJl8kNGnVOYAcf2FMfpN+BiaaPGvnVW9zowXp1fK8bVZTAst6iIexSJ/E4ehKFORtiNEudZ3h4A3ZD392/duKIh1NH89O0UwUh7kYwvzM+x3l1jG6K6DjV2JmWWEom/aO3kuN01KsasVKKj/YiKaYXrNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743409468; c=relaxed/simple;
	bh=6EPdz8aFjQ1ednZahrkNwc2//BReoieOSPgWhzZZxB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LxudXpiOokoouJgFdxoCxJ3WYjAvrSK1vCqJtxkgyoxJE1T4QTG7uPmQaig4GJ3+fvr+8B/7kUvc39JS8gNdxFSSbYAeMBtQU/3IZkvY2yQywjim2eVinuobglDxu8EokglOBeB0t27VdBVJe16efpa5vv3gchyvJRuM/evbus8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=gZFEitNC; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 52V8Mp033171319
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 31 Mar 2025 01:23:04 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 52V8Mp033171319
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025032001; t=1743409386;
	bh=5yXzAEblnWuewwiM+2a2MBWdk0hE50lz5zB2BZNESnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gZFEitNCvpKZCut95fXZKAqZjYVexIRqqCsmMBp2CZW5W/F+F8YdgBRq7Jas48oEm
	 jA/8QUCfk2D6k8vYesJGOnrzZv+XWetZsr8GnENjabojFMIx710C0/l2qUvpne52/U
	 BKRmW6qbXZJEaaZotvS+ZyspM+SBZxcPiUz0OolK8l3PTAJGgcrhaoBd8FoI0axiFO
	 UYJY19A43VO/nzu4JfIPKLbCPKuIQ+Fm3xRSaESxcKaXZ3m3Z/51sVm6ksmFV/kMOP
	 i/pGDQotEM9rWQRUfcKCF7CHn9HUUQ60/HHqfKDisSlMtrPlhTUBKsDUSIOgBvisE7
	 KhHjRSIG4ujjQ==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
        linux-edac@vger.kernel.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-ide@vger.kernel.org,
        linux-pm@vger.kernel.org, bpf@vger.kernel.org, llvm@lists.linux.dev
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        jgross@suse.com, andrew.cooper3@citrix.com, peterz@infradead.org,
        acme@kernel.org, namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        alexey.amakhalov@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        tony.luck@intel.com, pbonzini@redhat.com, vkuznets@redhat.com,
        seanjc@google.com, luto@kernel.org, boris.ostrovsky@oracle.com,
        kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com
Subject: [RFC PATCH v1 03/15] x86/msr: Simplify pmu_msr_{read,write}()
Date: Mon, 31 Mar 2025 01:22:39 -0700
Message-ID: <20250331082251.3171276-4-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250331082251.3171276-1-xin@zytor.com>
References: <20250331082251.3171276-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove calling native_{read,write}_msr{_safe}() in pmu_msr_{read,write}(),
and have them return false to let their caller to do that instead.

Refactor pmu_msr_write() to take the input MSR value in an u64 argument,
replacing the current dual u32 arguments.

Suggested-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Sign-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/xen/enlighten_pv.c |  6 +++++-
 arch/x86/xen/pmu.c          | 27 ++++-----------------------
 arch/x86/xen/xen-ops.h      |  4 ++--
 3 files changed, 11 insertions(+), 26 deletions(-)

diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index dcc2041f8e61..2bfe57469ac3 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -1133,6 +1133,8 @@ static void set_seg(unsigned int which, unsigned int low, unsigned int high,
 static void xen_do_write_msr(unsigned int msr, unsigned int low,
 			     unsigned int high, int *err)
 {
+	u64 val;
+
 	switch (msr) {
 	case MSR_FS_BASE:
 		set_seg(SEGBASE_FS, low, high, err);
@@ -1159,7 +1161,9 @@ static void xen_do_write_msr(unsigned int msr, unsigned int low,
 		break;
 
 	default:
-		if (!pmu_msr_write(msr, low, high, err)) {
+		val = (u64)high << 32 | low;
+
+		if (!pmu_msr_write(msr, val)) {
 			if (err)
 				*err = native_write_msr_safe(msr, low, high);
 			else
diff --git a/arch/x86/xen/pmu.c b/arch/x86/xen/pmu.c
index f06987b0efc3..1364cd3fb3ef 100644
--- a/arch/x86/xen/pmu.c
+++ b/arch/x86/xen/pmu.c
@@ -313,37 +313,18 @@ static bool pmu_msr_chk_emulated(unsigned int msr, uint64_t *val, bool is_read,
 	return true;
 }
 
-bool pmu_msr_read(unsigned int msr, uint64_t *val, int *err)
+bool pmu_msr_read(u32 msr, u64 *val, int *err)
 {
 	bool emulated;
 
-	if (!pmu_msr_chk_emulated(msr, val, true, &emulated))
-		return false;
-
-	if (!emulated) {
-		*val = err ? native_read_msr_safe(msr, err)
-			   : native_read_msr(msr);
-	}
-
-	return true;
+	return pmu_msr_chk_emulated(msr, val, true, &emulated) && emulated;
 }
 
-bool pmu_msr_write(unsigned int msr, uint32_t low, uint32_t high, int *err)
+bool pmu_msr_write(u32 msr, u64 val)
 {
-	uint64_t val = ((uint64_t)high << 32) | low;
 	bool emulated;
 
-	if (!pmu_msr_chk_emulated(msr, &val, false, &emulated))
-		return false;
-
-	if (!emulated) {
-		if (err)
-			*err = native_write_msr_safe(msr, low, high);
-		else
-			native_write_msr(msr, low, high);
-	}
-
-	return true;
+	return pmu_msr_chk_emulated(msr, &val, false, &emulated) && emulated;
 }
 
 static unsigned long long xen_amd_read_pmc(int counter)
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 63c13a2ccf55..4a0a1d73d8b8 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -274,8 +274,8 @@ void xen_pmu_finish(int cpu);
 static inline void xen_pmu_init(int cpu) {}
 static inline void xen_pmu_finish(int cpu) {}
 #endif
-bool pmu_msr_read(unsigned int msr, uint64_t *val, int *err);
-bool pmu_msr_write(unsigned int msr, uint32_t low, uint32_t high, int *err);
+bool pmu_msr_read(u32 msr, u64 *val, int *err);
+bool pmu_msr_write(u32 msr, u64 val);
 int pmu_apic_update(uint32_t reg);
 unsigned long long xen_read_pmc(int counter);
 
-- 
2.49.0


