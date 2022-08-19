Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE7BE599ACD
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 13:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348719AbiHSLKS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 07:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348704AbiHSLKR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 07:10:17 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BAB7FBA6A
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 04:10:16 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id w14so3845967plp.9
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 04:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=z6evWdl7qRpX717ycIDK2BtR5ifsL2gP87zXn8UQIMk=;
        b=J+XUAOeTv4KVFy0O5O6g70qCT4WkhMpYcqqI9RXS+Qe3vLZ5Qkp/eSH1z2s0TUNffl
         nQt7sRy2ReCywvyxYR4qiWfg8f6006Hzk0pg+ix1J1Ez8WPRVWExGSqEU1kZWZTQvo+H
         hHgA8OeyFUTAEpnkbcgAjEPhf+z0Iizn+nqxO+9rdFIc9efFoUMj9ceoX23MWoMhNe7Z
         va13J59UEvLTrogYbyTS6nHvBHbfwgbP5KfF6O36cGIkgZrRoURFczaQUlXm/oJoKLGs
         I/qAHYn1ys+w0U09MBltgBkEwL2WpKOQ4yOIihMiDa4W9GTN+XypwtGDo4zy9RnjMpyv
         cDSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=z6evWdl7qRpX717ycIDK2BtR5ifsL2gP87zXn8UQIMk=;
        b=7yOUWBLPR6ViT4HE/7FKE3mgWFPrwOBDNk2+8DxJYQOOiWuVkfnUxVwqcdb2z3+Cg5
         kFYLPgiV8D4IX4g23pnQx80n49Xmg+X/Jy+TXbbbios0xUGRcxdyy6ZmLx+P42G/AsUr
         KyIuNMRNIMzGa5NLqKfWo2ClnpmUIv7RRNEtplRBedTF/MLF6E5gQEMoCFiE/kb/Mmtq
         HhHItlIsEKZBoxejtz2rFKpTBPSZRdN+/stccLVeRsrVZkW+qbPRMHkdqC4JdUykiFA1
         Nu10SSD0NXHVAaOrdHPZjkBgZhM+st8FofN8Vw+fcXV8d567yaQNSuQLKDDAacYpOrDz
         BhLw==
X-Gm-Message-State: ACgBeo2rePcpbAq3jG2kAG+r6mBGmXJ2Vyb67SdvFvbpOLhibNMRrH8a
        /hrHeJTH2zsoN7NbcEHrHuQ=
X-Google-Smtp-Source: AA6agR7wAnLOGEGU2fMgNFFSibTKkGzmPbCDFhT9yiYtoWt3IKi8sOULrUTNZwGEUQxmWKaOWJcl3A==
X-Received: by 2002:a17:90b:3511:b0:1f4:e0cd:1e04 with SMTP id ls17-20020a17090b351100b001f4e0cd1e04mr13839797pjb.154.1660907415600;
        Fri, 19 Aug 2022 04:10:15 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id jd7-20020a170903260700b0016bfbd99f64sm2957778plb.118.2022.08.19.04.10.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 04:10:15 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 10/13] x86/pmu: Update testcases to cover Intel Arch PMU Version 1
Date:   Fri, 19 Aug 2022 19:09:36 +0800
Message-Id: <20220819110939.78013-11-likexu@tencent.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819110939.78013-1-likexu@tencent.com>
References: <20220819110939.78013-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

For most unit tests, the basic framework and use cases which test
any PMU counter do not require any changes, except for two things:

- No access to registers introduced only in PMU version 2 and above;
- Expanded tolerance for testing counter overflows
  due to the loss of uniform control of the gloabl_ctrl register

Adding some pmu_version() return value checks can seamlessly support
Intel Arch PMU Version 1, while opening the door for AMD PMUs tests.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 x86/pmu.c | 64 +++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 43 insertions(+), 21 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 25fafbe..826472c 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -125,14 +125,19 @@ static struct pmu_event* get_counter_event(pmu_counter_t *cnt)
 
 static void global_enable(pmu_counter_t *cnt)
 {
-	cnt->idx = event_to_global_idx(cnt);
+	if (pmu_version() < 2)
+		return;
 
+	cnt->idx = event_to_global_idx(cnt);
 	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, rdmsr(MSR_CORE_PERF_GLOBAL_CTRL) |
 			(1ull << cnt->idx));
 }
 
 static void global_disable(pmu_counter_t *cnt)
 {
+	if (pmu_version() < 2)
+		return;
+
 	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, rdmsr(MSR_CORE_PERF_GLOBAL_CTRL) &
 			~(1ull << cnt->idx));
 }
@@ -301,7 +306,10 @@ static void check_counter_overflow(void)
 	count = cnt.count;
 
 	/* clear status before test */
-	wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL, rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
+	if (pmu_version() > 1) {
+		wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL,
+		      rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
+	}
 
 	report_prefix_push("overflow");
 
@@ -327,13 +335,21 @@ static void check_counter_overflow(void)
 			cnt.config &= ~EVNTSEL_INT;
 		idx = event_to_global_idx(&cnt);
 		__measure(&cnt, cnt.count);
-		report(cnt.count == 1, "cntr-%d", i);
+
+		report(check_irq() == (i % 2), "irq-%d", i);
+		if (pmu_version() > 1)
+			report(cnt.count == 1, "cntr-%d", i);
+		else
+			report(cnt.count < 4, "cntr-%d", i);
+
+		if (pmu_version() < 2)
+			continue;
+
 		status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
 		report(status & (1ull << idx), "status-%d", i);
 		wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL, status);
 		status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
 		report(!(status & (1ull << idx)), "status clear-%d", i);
-		report(check_irq() == (i % 2), "irq-%d", i);
 	}
 
 	report_prefix_pop();
@@ -440,8 +456,10 @@ static void check_running_counter_wrmsr(void)
 	report(evt.count < gp_events[1].min, "cntr");
 
 	/* clear status before overflow test */
-	wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL,
-	      rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
+	if (pmu_version() > 1) {
+		wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL,
+			rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
+	}
 
 	start_event(&evt);
 
@@ -453,8 +471,11 @@ static void check_running_counter_wrmsr(void)
 
 	loop();
 	stop_event(&evt);
-	status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
-	report(status & 1, "status");
+
+	if (pmu_version() > 1) {
+		status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
+		report(status & 1, "status");
+	}
 
 	report_prefix_pop();
 }
@@ -474,8 +495,10 @@ static void check_emulated_instr(void)
 	};
 	report_prefix_push("emulated instruction");
 
-	wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL,
-	      rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
+	if (pmu_version() > 1) {
+		wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL,
+			rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
+	}
 
 	start_event(&brnch_cnt);
 	start_event(&instr_cnt);
@@ -509,7 +532,8 @@ static void check_emulated_instr(void)
 		:
 		: "eax", "ebx", "ecx", "edx");
 
-	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
+	if (pmu_version() > 1)
+		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
 
 	stop_event(&brnch_cnt);
 	stop_event(&instr_cnt);
@@ -520,10 +544,13 @@ static void check_emulated_instr(void)
 	       "instruction count");
 	report(brnch_cnt.count - brnch_start >= EXPECTED_BRNCH,
 	       "branch count");
-	// Additionally check that those counters overflowed properly.
-	status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
-	report(status & 1, "instruction counter overflow");
-	report(status & 2, "branch counter overflow");
+
+	if (pmu_version() > 1) {
+		// Additionally check that those counters overflowed properly.
+		status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
+		report(status & 1, "instruction counter overflow");
+		report(status & 2, "branch counter overflow");
+	}
 
 	report_prefix_pop();
 }
@@ -647,12 +674,7 @@ int main(int ac, char **av)
 	buf = malloc(N*64);
 
 	if (!pmu_version()) {
-		report_skip("No pmu is detected!");
-		return report_summary();
-	}
-
-	if (pmu_version() == 1) {
-		report_skip("PMU version 1 is not supported.");
+		report_skip("No Intel Arch PMU is detected!");
 		return report_summary();
 	}
 
-- 
2.37.2

