Return-Path: <kvm+bounces-44509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 79AEFA9E1EF
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 11:28:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B9541A8488E
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 09:25:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 767DE258CE4;
	Sun, 27 Apr 2025 09:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="Qe7DdUyA"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E556E253959;
	Sun, 27 Apr 2025 09:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745745698; cv=none; b=MShcAVOVzR9iAsXZP7GuFf9FAFgEhti3CDMSq/ZFv9WN6sJKCzJ7IY/+iXFzpY2/4RlmrFv4MinD5nY0apzrDhzJJi1YrnTuMVI1MtqS/GiysGmTtouCTdDwHwWHLeYylzF9eRBMrHJbKtpPZWFpo+1vVCjmqCCFAuZhi/Lu854=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745745698; c=relaxed/simple;
	bh=OS1y00M6nUqPAmb7VOw9fHGsSGTPfh2ajEfFaeIv6qI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UK6xhw9EmnMKeVnQf7TaWlOjbsrzxRkGcZApbhzN5KL+r75EzsNNwC1foaYKzPPfdxSkJXRNkKRW5ZvHxvqY85LJUuIbj5O9LONBkNrvqEfC3UUO6nWr7fmNfZUgpxKrW51PTEqZxj3sQsBF1kscfq+ha4JUzCkV4eAkX8SIv9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=Qe7DdUyA; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53R9KRS81598826
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Sun, 27 Apr 2025 02:20:54 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53R9KRS81598826
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745745656;
	bh=bzFeWw6MFKyWrGw0/gn3Z8aFXHMt/Uenz11b4dG3MDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qe7DdUyA6Vfc8M4QRIxa4Z9YkrXEdOqRRWeljkIsdUk3S4jQ0WofjiJl/3JtPZfRa
	 oqYLhNa9F2QGhF74XS4fySVpp8gUtxFi4eGGCFmiLuWoGJTzccCu6vKUJxTqaN1p/9
	 i/ooQbZ0h1EJW57gJwo9FzQk1GNeYSlypakueXANTztoi0o6vItHNEVUV01dWO9Uoa
	 eudFhhaYI3XxIT5LpI91SsbwdMc33b51+WdKFBmbeTLbM2d3b+o0fahMn0n17WD5RG
	 kWY/LYuOeuPBrl8OO2lTxqBNoHq+wD10METAdlfpDLmlGTBeOlSi18XTgg9dWCWVSt
	 ULCokpcBvc9vg==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux.dev, linux-pm@vger.kernel.org,
        linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org,
        netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        acme@kernel.org, jgross@suse.com, andrew.cooper3@citrix.com,
        peterz@infradead.org, namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
        luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, decui@microsoft.com,
        dapeng1.mi@linux.intel.com, ilpo.jarvinen@linux.intel.com
Subject: [PATCH v4 11/15] x86/xen/msr: Remove pmu_msr_{read,write}()
Date: Sun, 27 Apr 2025 02:20:23 -0700
Message-ID: <20250427092027.1598740-12-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250427092027.1598740-1-xin@zytor.com>
References: <20250427092027.1598740-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As pmu_msr_{read,write}() are now wrappers of pmu_msr_chk_emulated(),
remove them and use pmu_msr_chk_emulated() directly.

As pmu_msr_chk_emulated() could easily return false in the cases where
it would set *emul to false, remove the "emul" argument and use the
return value instead.

While at it, convert the data type of MSR index to u32 in functions
called in pmu_msr_chk_emulated().

Suggested-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Suggested-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---

Change in v4:
*) Remove two "else" that no longer make sense (Juergen Gross).

Change in v3:
*) Remove the "emul" argument of pmu_msr_chk_emulated() (Juergen Gross).
---
 arch/x86/xen/enlighten_pv.c | 15 ++++++++-------
 arch/x86/xen/pmu.c          | 33 ++++++++-------------------------
 arch/x86/xen/xen-ops.h      |  3 +--
 3 files changed, 17 insertions(+), 34 deletions(-)

diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index 61e51a970f3c..528a2f4df050 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -1090,7 +1090,7 @@ static u64 xen_do_read_msr(unsigned int msr, int *err)
 {
 	u64 val = 0;	/* Avoid uninitialized value for safe variant. */
 
-	if (pmu_msr_read_emulated(msr, &val))
+	if (pmu_msr_chk_emulated(msr, &val, true))
 		return val;
 
 	if (err)
@@ -1162,12 +1162,13 @@ static void xen_do_write_msr(unsigned int msr, unsigned int low,
 	default:
 		val = (u64)high << 32 | low;
 
-		if (!pmu_msr_write_emulated(msr, val)) {
-			if (err)
-				*err = native_write_msr_safe(msr, low, high);
-			else
-				native_write_msr(msr, low, high);
-		}
+		if (pmu_msr_chk_emulated(msr, &val, false))
+			return;
+
+		if (err)
+			*err = native_write_msr_safe(msr, low, high);
+		else
+			native_write_msr(msr, low, high);
 	}
 }
 
diff --git a/arch/x86/xen/pmu.c b/arch/x86/xen/pmu.c
index b6557f2d1a2e..5f3d2a6c70f1 100644
--- a/arch/x86/xen/pmu.c
+++ b/arch/x86/xen/pmu.c
@@ -128,7 +128,7 @@ static inline uint32_t get_fam15h_addr(u32 addr)
 	return addr;
 }
 
-static inline bool is_amd_pmu_msr(unsigned int msr)
+static bool is_amd_pmu_msr(u32 msr)
 {
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD &&
 	    boot_cpu_data.x86_vendor != X86_VENDOR_HYGON)
@@ -194,8 +194,7 @@ static bool is_intel_pmu_msr(u32 msr_index, int *type, int *index)
 	}
 }
 
-static bool xen_intel_pmu_emulate(unsigned int msr, u64 *val, int type,
-				  int index, bool is_read)
+static bool xen_intel_pmu_emulate(u32 msr, u64 *val, int type, int index, bool is_read)
 {
 	uint64_t *reg = NULL;
 	struct xen_pmu_intel_ctxt *ctxt;
@@ -257,7 +256,7 @@ static bool xen_intel_pmu_emulate(unsigned int msr, u64 *val, int type,
 	return false;
 }
 
-static bool xen_amd_pmu_emulate(unsigned int msr, u64 *val, bool is_read)
+static bool xen_amd_pmu_emulate(u32 msr, u64 *val, bool is_read)
 {
 	uint64_t *reg = NULL;
 	int i, off = 0;
@@ -298,33 +297,17 @@ static bool xen_amd_pmu_emulate(unsigned int msr, u64 *val, bool is_read)
 	return false;
 }
 
-static bool pmu_msr_chk_emulated(unsigned int msr, uint64_t *val, bool is_read,
-				 bool *emul)
+bool pmu_msr_chk_emulated(u32 msr, u64 *val, bool is_read)
 {
 	int type, index = 0;
 
 	if (is_amd_pmu_msr(msr))
-		*emul = xen_amd_pmu_emulate(msr, val, is_read);
-	else if (is_intel_pmu_msr(msr, &type, &index))
-		*emul = xen_intel_pmu_emulate(msr, val, type, index, is_read);
-	else
-		return false;
-
-	return true;
-}
-
-bool pmu_msr_read_emulated(u32 msr, u64 *val)
-{
-	bool emulated;
+		return xen_amd_pmu_emulate(msr, val, is_read);
 
-	return pmu_msr_chk_emulated(msr, val, true, &emulated) && emulated;
-}
+	if (is_intel_pmu_msr(msr, &type, &index))
+		return xen_intel_pmu_emulate(msr, val, type, index, is_read);
 
-bool pmu_msr_write_emulated(u32 msr, u64 val)
-{
-	bool emulated;
-
-	return pmu_msr_chk_emulated(msr, &val, false, &emulated) && emulated;
+	return false;
 }
 
 static u64 xen_amd_read_pmc(int counter)
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 163e03e33089..fd7f845b83a3 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -274,8 +274,7 @@ void xen_pmu_finish(int cpu);
 static inline void xen_pmu_init(int cpu) {}
 static inline void xen_pmu_finish(int cpu) {}
 #endif
-bool pmu_msr_read_emulated(u32 msr, u64 *val);
-bool pmu_msr_write_emulated(u32 msr, u64 val);
+bool pmu_msr_chk_emulated(u32 msr, u64 *val, bool is_read);
 int pmu_apic_update(uint32_t reg);
 u64 xen_read_pmc(int counter);
 
-- 
2.49.0


