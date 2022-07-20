Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF83657BE5F
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 21:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233697AbiGTTYH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 15:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233129AbiGTTX5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 15:23:57 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A9D54AF9
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 12:23:56 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id e132so17277789pgc.5
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 12:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k7oAEso24XUyiMu0RhEG3Nlz67s2VkRn8qN/IYX5xGk=;
        b=sY9xzDFI9X3wzme+LId9I8R9+tn4yaAMLQpEbWaQ3yG2PQ5DtSBnecKXDC1IFimX6t
         K/qY0qg/2psalruNjlEzf0CEI1o2HccaVgkbFwMlwJj8LXADl7lxeiKjvIzcYUI8q5uJ
         ttyGd73sE3NX1DqDjAytZoQjw4rUEo0+iIqu765dNAOiICi/0wbNDYOGnMYM7Idiw+f9
         dxI0O1CY6sfcSs5MWgNo9pDebidl7EyZEPDZa3unG5xPqkvDeJRoKSNwIckNUA+nvsiS
         kQry5184T2awXHtc9U47ggv3Fvs0JXytLLjZ9uJzG/lLzy5sXq+hstOnl5ywDIiGBreq
         hYWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k7oAEso24XUyiMu0RhEG3Nlz67s2VkRn8qN/IYX5xGk=;
        b=CdlmZWJAQ7cXeA2jXhRsTtIRTZPAY+HQ5F2j7D5VuuS4Z1/B2tqAZWqywMfmli8+H1
         HYKkUzFvPybTj/7GoBmtn5grqcIxCQ5Zn/13LIM4XUTd0XpfdENBywCh3juGLUGQvnJZ
         6MjZc5VX6GKZAgBD2B0C+Tve1y5iFgPgT/AAMR4Hw1RQdtySvNAQ1GrCVVTiXSmxj29X
         vEYxOj4nZ5JUm8Ws8Zf0FZccVwpSqXlw0hxHw6f2BZ+fT5J18Ss6mUtiwmR0/vNNCo9M
         a73DKn4YwzKb0jvyAzRR2nzg+9FUBeURXzV1+/vvtI8O518xKfiWAzneBRDLz0TkuV4J
         VchA==
X-Gm-Message-State: AJIora+gQmqDYTN5GPH00hL1oKgC/JHB0zJu3MNMm18D2wXgkO5K3D6A
        Viq24gRVp052yfSuvLLqFPH25w==
X-Google-Smtp-Source: AGRyM1u3GnXaQ/dPKAAkFwq7+MPBAz7n0FxebmLk2pgdq9YV976oddbOqJyDP0CBIXa4PDlmreA76w==
X-Received: by 2002:a65:4501:0:b0:3fc:4895:283b with SMTP id n1-20020a654501000000b003fc4895283bmr35712773pgq.231.1658345035855;
        Wed, 20 Jul 2022 12:23:55 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id y23-20020a17090264d700b0016d2e772550sm219902pli.175.2022.07.20.12.23.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 12:23:55 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>,
        Anup Patel <anup@brainfault.org>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Atish Patra <atishp@atishpatra.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Liu Shaohua <liush@allwinnertech.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Philipp Tomsich <philipp.tomsich@vrull.eu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tsukasa OI <research_trasio@irq.a4lg.com>,
        Wei Fu <wefu@redhat.com>
Subject: [PATCH v5 3/4] RISC-V: Prefer sstc extension if available
Date:   Wed, 20 Jul 2022 12:23:41 -0700
Message-Id: <20220720192342.3428144-4-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220720192342.3428144-1-atishp@rivosinc.com>
References: <20220720192342.3428144-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RISC-V ISA has sstc extension which allows updating the next clock event
via a CSR (stimecmp) instead of an SBI call. This should happen dynamically
if sstc extension is available. Otherwise, it will fallback to SBI call
to maintain backward compatibility.

Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 drivers/clocksource/timer-riscv.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/clocksource/timer-riscv.c b/drivers/clocksource/timer-riscv.c
index 593d5a957b69..3f100fb53d82 100644
--- a/drivers/clocksource/timer-riscv.c
+++ b/drivers/clocksource/timer-riscv.c
@@ -7,6 +7,9 @@
  * either be read from the "time" and "timeh" CSRs, and can use the SBI to
  * setup events, or directly accessed using MMIO registers.
  */
+
+#define pr_fmt(fmt) "riscv-timer: " fmt
+
 #include <linux/clocksource.h>
 #include <linux/clockchips.h>
 #include <linux/cpu.h>
@@ -23,11 +26,24 @@
 #include <asm/sbi.h>
 #include <asm/timex.h>
 
+static DEFINE_STATIC_KEY_FALSE(riscv_sstc_available);
+
 static int riscv_clock_next_event(unsigned long delta,
 		struct clock_event_device *ce)
 {
+	u64 next_tval = get_cycles64() + delta;
+
 	csr_set(CSR_IE, IE_TIE);
-	sbi_set_timer(get_cycles64() + delta);
+	if (static_branch_likely(&riscv_sstc_available)) {
+#if defined(CONFIG_32BIT)
+		csr_write(CSR_STIMECMP, next_tval & 0xFFFFFFFF);
+		csr_write(CSR_STIMECMPH, next_tval >> 32);
+#else
+		csr_write(CSR_STIMECMP, next_tval);
+#endif
+	} else
+		sbi_set_timer(next_tval);
+
 	return 0;
 }
 
@@ -165,6 +181,12 @@ static int __init riscv_timer_init_dt(struct device_node *n)
 	if (error)
 		pr_err("cpu hp setup state failed for RISCV timer [%d]\n",
 		       error);
+
+	if (riscv_isa_extension_available(NULL, SSTC)) {
+		pr_info("Timer interrupt in S-mode is available via sstc extension\n");
+		static_branch_enable(&riscv_sstc_available);
+	}
+
 	return error;
 }
 
-- 
2.25.1

