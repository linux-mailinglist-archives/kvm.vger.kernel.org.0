Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64BA6595700
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 11:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234008AbiHPJs4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 05:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234010AbiHPJsY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 05:48:24 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413A074346
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 01:10:15 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id pm17so9093986pjb.3
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 01:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=puBBR6EVoQqAaVenerbCRq3gvGe0Yaq7L/nKySh8igU=;
        b=LfNYKqwMiN3AHNO4ChiKf35lsIu2ZOcgmzTRFm+rIdXXSqhWpbPqeuRfBXVBIboSjM
         UBaUAgeBdswxaRrJie7oxV/YFEyDZ/LW6WUub04L6K7viVMOO0A0Q8ZzzTDF0gsR2JYX
         ugfVJG7ZxlpBqwSVpAY7GdU7LIMA2MyX2QNyUsA5fEynjE04ToyEfbXx8c2XKJYmjOcq
         5Q0jXOco29xtxGSgEIQGwKLHjHQMQdGo4qJFiBYEIbXAsTSdRzf2USjvuLPkTEArsO/t
         IQVSvt9pnVbWW5mXF99xXDZxYoevgzWL32U0Z0n0HwM3MkB/8udahnxT0jeVDs1dvBIQ
         aGVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=puBBR6EVoQqAaVenerbCRq3gvGe0Yaq7L/nKySh8igU=;
        b=IdKxq5k/OkROSUqkgToHlCvll8aTNY308vyeaaiM41yhkKW4MeUtzbnxdp0unJ+65T
         2ZNR1w3BJreF/fZnWJYqbxWZG/LIXxtvQg+fq7on/++6GYUrZdzyA1D6+g0c0POQGDQ9
         KoXZaqIyefC6uGWVFtJkunuWKYfWM6b0wGMJAfmlBkGuPtpsK3B2KbAb8HJ0EiFEMFCz
         4y4cStulj57bqVfckUpzNOZQ3Xp4fl8f8VvvrpmaVcZiniGyQeCJ7dRgI0wsSO8wKJLo
         NYyICIWXbsq1J9QNzlFygpkD4GCLzjex6bc/96yVkCX3IRjXv0oZvwwXqV/X/bvD2D+X
         PtGQ==
X-Gm-Message-State: ACgBeo3ULGgv59LuBC0njpBA2EyLHR2khoGPObfAXt05KE4fykZCbysK
        GmkwOBx6q8i2++IixIVWX1o=
X-Google-Smtp-Source: AA6agR6uxJsFkWU9IbhzMsdF9IRS5avuCGWjT5lA/XHiDVwwStUffHUjzTcHMLkZeiV8vCZ5IbfE4g==
X-Received: by 2002:a17:902:eb8a:b0:16d:bf08:9311 with SMTP id q10-20020a170902eb8a00b0016dbf089311mr21430643plg.139.1660637414786;
        Tue, 16 Aug 2022 01:10:14 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id m12-20020a170902db0c00b0016d7b2352desm8400920plx.244.2022.08.16.01.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 01:10:14 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 2/5] x86/pmu: Introduce multiple_{one, many}() to improve readability
Date:   Tue, 16 Aug 2022 16:09:06 +0800
Message-Id: <20220816080909.90622-3-likexu@tencent.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220816080909.90622-1-likexu@tencent.com>
References: <20220816080909.90622-1-likexu@tencent.com>
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

The current measure_one() forces the common case to pass in unnecessary
information in order to give flexibility to a single use case. It's just
syntatic sugar, but it really does help readers as it's not obvious that
the "1" specifies the number of events, whereas multiple_many() and
measure_one() are relatively self-explanatory.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 x86/pmu.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 817b4d0..277fa6c 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -181,7 +181,7 @@ static void stop_event(pmu_counter_t *evt)
 	evt->count = rdmsr(evt->ctr);
 }
 
-static void measure(pmu_counter_t *evt, int count)
+static void multiple_many(pmu_counter_t *evt, int count)
 {
 	int i;
 	for (i = 0; i < count; i++)
@@ -191,6 +191,11 @@ static void measure(pmu_counter_t *evt, int count)
 		stop_event(&evt[i]);
 }
 
+static void measure_one(pmu_counter_t *evt)
+{
+	multiple_many(evt, 1);
+}
+
 static void __measure(pmu_counter_t *evt, uint64_t count)
 {
 	__start_event(evt, count);
@@ -220,7 +225,7 @@ static void check_gp_counter(struct pmu_event *evt)
 	int i;
 
 	for (i = 0; i < nr_gp_counters; i++, cnt.ctr++) {
-		measure(&cnt, 1);
+		measure_one(&cnt);
 		report(verify_event(cnt.count, evt), "%s-%d", evt->name, i);
 	}
 }
@@ -247,7 +252,7 @@ static void check_fixed_counters(void)
 
 	for (i = 0; i < nr_fixed_counters; i++) {
 		cnt.ctr = fixed_events[i].unit_sel;
-		measure(&cnt, 1);
+		measure_one(&cnt);
 		report(verify_event(cnt.count, &fixed_events[i]), "fixed-%d", i);
 	}
 }
@@ -274,7 +279,7 @@ static void check_counters_many(void)
 		n++;
 	}
 
-	measure(cnt, n);
+	multiple_many(cnt, n);
 
 	for (i = 0; i < n; i++)
 		if (!verify_counter(&cnt[i]))
@@ -338,7 +343,7 @@ static void check_gp_counter_cmask(void)
 		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel /* instructions */,
 	};
 	cnt.config |= (0x2 << EVNTSEL_CMASK_SHIFT);
-	measure(&cnt, 1);
+	measure_one(&cnt);
 	report(cnt.count < gp_events[1].min, "cmask");
 }
 
-- 
2.37.2

