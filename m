Return-Path: <kvm+bounces-5881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C8398828712
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 14:29:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6BAC4B23411
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 13:29:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DC8439AC0;
	Tue,  9 Jan 2024 13:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I1DIV3f+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F29439AE7
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 13:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704806946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=i0+DHpd7B30vu6fjnHdBNrEBMCfCzpaCXTPrr7P02Nk=;
	b=I1DIV3f+ctJqiZu6fnciP8Xhm+DHYr6Z24jUpHjCoGrW2KhMqU3grOcWzD+9pbw365ebfa
	JEdq4qjynvZV/y1cEKd4BfCRnyN/x0VvCxWRlNEH+dDgB3ZzI24gyWaryU0Plh2pYdYxCg
	Uvsnk2oN6bcAu5oOgpphGFfBxZ+Gy6U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-nR1OQ4LLO4el9gRbLWjSbQ-1; Tue, 09 Jan 2024 08:29:04 -0500
X-MC-Unique: nR1OQ4LLO4el9gRbLWjSbQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6324585A5B7
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 13:29:04 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.39.195.73])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3D078492BC9;
	Tue,  9 Jan 2024 13:29:03 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH] x86: Fix various typos
Date: Tue,  9 Jan 2024 14:29:02 +0100
Message-ID: <20240109132902.129377-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

Fix typos that have been discovered with the "codespell" utility.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 x86/pmu.c       | 2 +-
 x86/pmu_pebs.c  | 2 +-
 x86/svm_tests.c | 4 ++--
 x86/vmx_tests.c | 6 +++---
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 0def2869..47a1a602 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -563,7 +563,7 @@ static void check_tsx_cycles(void)
 		cnt.ctr = MSR_GP_COUNTERx(i);
 
 		if (i == 2) {
-			/* Transactional cycles commited only on gp counter 2 */
+			/* Transactional cycles committed only on gp counter 2 */
 			cnt.config = EVNTSEL_OS | EVNTSEL_USR | 0x30000003c;
 		} else {
 			/* Transactional cycles */
diff --git a/x86/pmu_pebs.c b/x86/pmu_pebs.c
index d1a68ca3..f7b52b90 100644
--- a/x86/pmu_pebs.c
+++ b/x86/pmu_pebs.c
@@ -308,7 +308,7 @@ static void check_pebs_records(u64 bitmask, u64 pebs_data_cfg)
 			(pebs_rec->format_size & GENMASK_ULL(47, 0)) == pebs_data_cfg;
 		expected = pebs_idx_match && pebs_size_match && data_cfg_match;
 		report(expected,
-		       "PEBS record (written seq %d) is verified (inclduing size, counters and cfg).", count);
+		       "PEBS record (written seq %d) is verified (including size, counters and cfg).", count);
 		cur_record = cur_record + pebs_record_size;
 		count++;
 	} while (expected && (void *)cur_record < (void *)ds->pebs_index);
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index e87aa1f4..c81b7465 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -395,7 +395,7 @@ static bool msr_intercept_finished(struct svm_test *test)
 		}
 
 		/*
-		 * Warn that #GP exception occured instead.
+		 * Warn that #GP exception occurred instead.
 		 * RCX holds the MSR index.
 		 */
 		printf("%s 0x%lx #GP exception\n",
@@ -2776,7 +2776,7 @@ static void svm_no_nm_test(void)
 
 	vmcb->save.cr0 = vmcb->save.cr0 & ~(X86_CR0_TS | X86_CR0_EM);
 	report(svm_vmrun() == SVM_EXIT_VMMCALL,
-	       "fnop with CR0.TS and CR0.EM unset no #NM excpetion");
+	       "fnop with CR0.TS and CR0.EM unset no #NM exception");
 }
 
 static u64 amd_get_lbr_rip(u32 msr)
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index c1540d39..97b8e727 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -7667,7 +7667,7 @@ static void test_host_addr_size(void)
 	 * testcases as needed, but don't guarantee a VM-Exit and so the active
 	 * CR4 and RIP may still hold a test value.  Running with the test CR4
 	 * and RIP values at some point is unavoidable, and the active values
-	 * are unlikely to affect VM-Enter, so the above doen't force a VM-Exit
+	 * are unlikely to affect VM-Enter, so the above doesn't force a VM-exit
 	 * between testcases.  Note, if VM-Enter is surrounded by CALL+RET then
 	 * the active RIP will already be restored, but that's also not
 	 * guaranteed, and CR4 needs to be restored regardless.
@@ -9382,7 +9382,7 @@ static void vmx_eoi_bitmap_ioapic_scan_test(void)
 	/*
 	 * Launch L2.
 	 * We expect the exit reason to be VMX_VMCALL (and not EOI INDUCED).
-	 * In case the reason isn't VMX_VMCALL, the asserion inside
+	 * In case the reason isn't VMX_VMCALL, the assertion inside
 	 * skip_exit_vmcall() will fail.
 	 */
 	enter_guest();
@@ -9698,7 +9698,7 @@ static void vmx_init_signal_test(void)
 	init_signal_test_exit_reason = -1ull;
 	vmx_set_test_stage(4);
 	/*
-	 * Wait reasonable amont of time for other CPU
+	 * Wait reasonable amount of time for other CPU
 	 * to exit to VMX root mode
 	 */
 	delay(INIT_SIGNAL_TEST_DELAY);
-- 
2.43.0


