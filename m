Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C397357880A
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 19:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235500AbiGRRFt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 13:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235702AbiGRRFr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 13:05:47 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833572BB12
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 10:05:46 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id q5-20020a17090a304500b001efcc885cc4so13234101pjl.4
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 10:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H7ChdRBKS+9A003EiQbM2SMDrKCCYQePnInXhSsyMB0=;
        b=2V7H54kc+3zNv1TcuveEZhkWNgIt1ocwR1qZtOLzfciyvULmAUYAVdSYvDM/LMqPW7
         B2K1L+wSiEDZFuMDMucw3/YkGg89OijRh8dtnIplDxavoLr+HLhF1RSyQXxCnRG/72Tf
         KHeNwRoBhGw0rXQdnYIWadk5aSrZwLj7I/0cV0ZkgQrHx0ezw5iLQkZg1Uak7Z5I0sqE
         qFLiHdxohtP+MR29CMLuGTlZRid3ndTvwyv2IFhPeeJPuBbWKdNqbpz4KKb8bRDh9SWd
         v8nTz6wqG+l9bP6qNs15D6dX6qH+nOrr4SmzAUcKI22h5JluwKsyWFI5ud4IQSpY+eeR
         W4Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H7ChdRBKS+9A003EiQbM2SMDrKCCYQePnInXhSsyMB0=;
        b=w71mIMAato6quQ/ItPvv3mw0fN/8RsrAq+q3w/EFhEtSq/1hWt7zRTmnEw6Pp3l4Jj
         FBP/vsTvuqY9i9XQg5GLs4b1dZjM5rhG/0ViS0LMl902/Vg4p2D9Y+G1TMkNkk0cNTRH
         4rkTCl0keGEwnG5Aw52J2VCuW7GcRilZqNHjJlB1h41w0gomNjXJHx7bUrGQvq3N529l
         JeuaAbXr0OcovZO5LEM0aUuY8qgEyDILYhltF/gvntYQfC4lc+Y/t7LQDAxxZWVmJ5Br
         HrbZNhttfXyy55Gz3musDlRaps+cdRemPMaVWUqpCsnItZ7pH2UwnxynXrrNBC2pyz8b
         5XoA==
X-Gm-Message-State: AJIora82F6SjmmtABFVu7mboJjFwalQk+Mms/RLqwcjkYGYOD48XjHbL
        +F0saLs0jztpmyrGOtJNXgURtw==
X-Google-Smtp-Source: AGRyM1uvFkWFiSwIv2bxiYnsB/Me0O2umAIdMXnBAJupJyduccoZ2CTvIm6kzqVVu3DQdq7Cn7s+hQ==
X-Received: by 2002:a17:902:a413:b0:156:15b:524a with SMTP id p19-20020a170902a41300b00156015b524amr30012463plq.106.1658163945893;
        Mon, 18 Jul 2022 10:05:45 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id r10-20020a170902be0a00b0016bc947c5b7sm9733402pls.38.2022.07.18.10.05.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 10:05:45 -0700 (PDT)
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
Subject: [RFC  2/9] RISC-V: Define a helper function to return counter width
Date:   Mon, 18 Jul 2022 10:01:58 -0700
Message-Id: <20220718170205.2972215-3-atishp@rivosinc.com>
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

The virtual hardware counters need to have the same width as the
logical hardware counters for simplicity.  However, there shouldn't
be mapping between virtual hardware counters and logical hardware
counters. As we don't support hetergeneous harts or counters with
different width as of now, the implementation relies on the counter
width of the first available programmable counter.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 drivers/perf/riscv_pmu_sbi.c   | 25 +++++++++++++++++++++++++
 include/linux/perf/riscv_pmu.h |  1 +
 2 files changed, 26 insertions(+)

diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index 1723af68ffa1..5d0eef3ef136 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -250,6 +250,31 @@ static bool pmu_sbi_ctr_is_fw(int cidx)
 	return (info->type == SBI_PMU_CTR_TYPE_FW) ? true : false;
 }
 
+/*
+ * Returns the counter width of a programmable counter
+ * As we don't support heterneous CPUs yet, it is okay to just
+ * return the counter width of the first programmable counter.
+ */
+int riscv_pmu_sbi_hpmc_width(void)
+{
+	int i;
+	union sbi_pmu_ctr_info *info;
+
+	if (!rvpmu)
+		return -EINVAL;
+
+	for (i = 0; i < rvpmu->num_counters; i++) {
+		info = &pmu_ctr_list[i];
+		if (!info)
+			continue;
+		if (info->type == SBI_PMU_CTR_TYPE_HW)
+			return info->width;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(riscv_pmu_sbi_hpmc_width);
+
 static int pmu_sbi_ctr_get_idx(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
diff --git a/include/linux/perf/riscv_pmu.h b/include/linux/perf/riscv_pmu.h
index fc47167e000c..6fee211c27b5 100644
--- a/include/linux/perf/riscv_pmu.h
+++ b/include/linux/perf/riscv_pmu.h
@@ -72,6 +72,7 @@ static inline void riscv_pmu_legacy_skip_init(void) {};
 struct riscv_pmu *riscv_pmu_alloc(void);
 #ifdef CONFIG_RISCV_PMU_SBI
 int riscv_pmu_sbi_get_num_hw_ctrs(void);
+int riscv_pmu_sbi_hpmc_width(void);
 #endif
 
 #endif /* CONFIG_RISCV_PMU */
-- 
2.25.1

