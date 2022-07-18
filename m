Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B405357880F
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 19:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235809AbiGRRF6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 13:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234464AbiGRRFu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 13:05:50 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4411D2C11C
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 10:05:48 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id j12so9588203plj.8
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 10:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/3vtOzL7H/3FhOEqt+TCzYFt3aLP8b6PmqU5Yxo7Fj8=;
        b=4uEa5LBy0DKcY8uwawFXfJDcyP2Fi+jae6+kTt2b2wiPbEE7wbhzRSXq/FBGMgOi/f
         hw86VLNxjdNtEI0yE51+u//XmslDWbju8DkFTny20OYQvzxqBoeGLkiEKPgITsrsNH0h
         qQRnpeE8Hwj4q3l6kiYjSyvG3r9D1tENLERXnC58erWdoBU1yy9KVWDXVVuCJbNyZVMu
         sq8BZOG2Ng3wxgfDGCyKf5yxkMdcvfdb+2Bf7FYJ4fM5MEmBHRL43SS/HZ+TFCiGQNl/
         eungSt9TWAodD9oHT7M2KCyNnNMMLzfGz5/ts/D2ADF68OzVyKx2zafdBTLeTq5jeMw+
         oYUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/3vtOzL7H/3FhOEqt+TCzYFt3aLP8b6PmqU5Yxo7Fj8=;
        b=w8zqKgIaNi0MZXCjAWTVP+AoCBTlFRtkNQpwFTZ3p3cKPZbBgjWLYJyMk39+udbNsj
         m3ekrVVTAcmmXW0vN+uV5TIUve0JQv3gRI+hGbedwjU323HK4FwDGA5UnQ7toWE1gyhY
         7p6oK6GPwu5V2tnCjQgGOZXs2RK35SY49NUc2sKTzuTtr5WDmzycufjmnVLufg+EVciK
         /LJhWYO4cnJBde4N7X7R3DtmY1smjQ3rS7MoeNXCvI+Rj20ZZwR89pkkjRcySjcNC0hY
         52bW3W9kaARNpP+0gRn8yhEeQgOqrY0YTANbWZVy1hfGBEPUQbbEINEW3lLLuhCDP1bb
         TqhA==
X-Gm-Message-State: AJIora99mQKBmvP/8tqW3mdUjmkjf0dujuPEJpQEXvgZy7RXlSsFVfCg
        rXAaPz3p11ia3wydnGb+IRdFIg==
X-Google-Smtp-Source: AGRyM1uSWzV58VCzHYwLZkTFFYZNxcIXLVpIo0ybe2iNKjofq3fVvwFRP5hLtK6LTf38a8cYPsHKQw==
X-Received: by 2002:a17:90b:388e:b0:1f0:3d7f:e620 with SMTP id mu14-20020a17090b388e00b001f03d7fe620mr34153286pjb.31.1658163948380;
        Mon, 18 Jul 2022 10:05:48 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id r10-20020a170902be0a00b0016bc947c5b7sm9733402pls.38.2022.07.18.10.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 10:05:48 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Guo Ren <guoren@kernel.org>, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Will Deacon <will@kernel.org>
Subject: [RFC  4/9] RISC-V: KVM: Improve privilege mode filtering for perf
Date:   Mon, 18 Jul 2022 10:02:00 -0700
Message-Id: <20220718170205.2972215-5-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220718170205.2972215-1-atishp@rivosinc.com>
References: <20220718170205.2972215-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, the host driver doesn't have any method to identify if the
requested perf event is from kvm or bare metal. As KVM runs in HS
mode, there are no separate hypervisor privilege mode to distinguish
between the attributes for guest/host.

Improve the privilege mode filtering by using the event specific
config1 field.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 drivers/perf/riscv_pmu_sbi.c   | 27 ++++++++++++++++++++++-----
 include/linux/perf/riscv_pmu.h |  2 ++
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index 5d0eef3ef136..34f9fcc221a8 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -275,6 +275,27 @@ int riscv_pmu_sbi_hpmc_width(void)
 }
 EXPORT_SYMBOL(riscv_pmu_sbi_hpmc_width);
 
+static unsigned long pmu_sbi_get_filter_flags(struct perf_event *event)
+{
+	unsigned long cflags = 0;
+	bool guest_events = false;
+
+	if (event->attr.config1 & RISCV_KVM_PMU_CONFIG1_GUEST_EVENTS)
+		guest_events = true;
+	if (event->attr.exclude_kernel)
+		cflags |= guest_events ? SBI_PMU_CFG_FLAG_SET_VSINH : SBI_PMU_CFG_FLAG_SET_SINH;
+	if (event->attr.exclude_user)
+		cflags |= guest_events ? SBI_PMU_CFG_FLAG_SET_VUINH : SBI_PMU_CFG_FLAG_SET_UINH;
+	if (guest_events && event->attr.exclude_hv)
+		cflags |= SBI_PMU_CFG_FLAG_SET_SINH;
+	if (event->attr.exclude_host)
+		cflags |= SBI_PMU_CFG_FLAG_SET_UINH | SBI_PMU_CFG_FLAG_SET_SINH;
+	if (event->attr.exclude_guest)
+		cflags |= SBI_PMU_CFG_FLAG_SET_VSINH | SBI_PMU_CFG_FLAG_SET_VUINH;
+
+	return cflags;
+}
+
 static int pmu_sbi_ctr_get_idx(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
@@ -286,11 +307,7 @@ static int pmu_sbi_ctr_get_idx(struct perf_event *event)
 	uint64_t cmask = GENMASK_ULL(rvpmu->num_counters - 1, 0);
 	unsigned long cflags = 0;
 
-	if (event->attr.exclude_kernel)
-		cflags |= SBI_PMU_CFG_FLAG_SET_SINH;
-	if (event->attr.exclude_user)
-		cflags |= SBI_PMU_CFG_FLAG_SET_UINH;
-
+	cflags = pmu_sbi_get_filter_flags(event);
 	/* retrieve the available counter index */
 #if defined(CONFIG_32BIT)
 	ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_CFG_MATCH, cbase, cmask,
diff --git a/include/linux/perf/riscv_pmu.h b/include/linux/perf/riscv_pmu.h
index 6fee211c27b5..825b95253bc5 100644
--- a/include/linux/perf/riscv_pmu.h
+++ b/include/linux/perf/riscv_pmu.h
@@ -26,6 +26,8 @@
 
 #define RISCV_PMU_STOP_FLAG_RESET 1
 
+#define RISCV_KVM_PMU_CONFIG1_GUEST_EVENTS 0x1
+
 struct cpu_hw_events {
 	/* currently enabled events */
 	int			n_events;
-- 
2.25.1

