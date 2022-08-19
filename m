Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F89D599A9C
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 13:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348693AbiHSLKF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 07:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348690AbiHSLKE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 07:10:04 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF28F6196
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 04:10:02 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id x23so3849928pll.7
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 04:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=Y8bupUhiF48s2pTjppCuB8jZfYQ8o5CSEyoPhtiNoQw=;
        b=L41EwR29pTqBq8vANXqLw53klPpXyhHKgdvX5XfkDZfGH89bS5fuin0MDTLKE34qyP
         B+TNCrrpB2czfs/IcX7+BjHZEnrikQcbJat58NXKVFKGm8rESD8eQqPu5Az/OfbxL7q4
         6L8dDyzGWoso+RyteaTIsZcjAMN2e4xIA0UGiN2bG6xXQU0IHT/0N1lkvhEzA9yfCJJ6
         TrVWDSsnCDeCNGMRioNfK3r9gPc5VqJSQaqGxRq7qN+x2hW35G5tZNFA8N/IT4TolT7l
         sXZgFl8bDoMpXIhRV3WjRQmlv4X5qGoK2dgycNDHezqexJ0VuOFTjdbmVXfcTgd9ZW3p
         iNvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=Y8bupUhiF48s2pTjppCuB8jZfYQ8o5CSEyoPhtiNoQw=;
        b=Pj+Jwi0emcVduh8pFnsGkcsnZbnx3TJKJMZVrqlvjxjZhxQZSwwgqRmZngzojshcni
         ZlU5tiKGgaKOI+m7bFTddLlHKK4E+zhtrz5dRIfppRuTl6IzZwwPnNDhcpNcnaSSRYBn
         Ghpd991gndP4w5JVrt4FuuTZDArWqAf1LTf027f4SLF6hurxGp/4Kn6Lz/p7rMfFEqlB
         vMuT26BNqUicEcx2jOaM+/JlLwCVUBzMsnDSnU8M52cKAwC4g0Zfy4oIUT/5rz9e9P1U
         ebVWNXN2pQHfghYzLWpkywUuTV6tswg4h1/fQZEPnN2VuRT8KaeX4M9kVobNn1rM4qDF
         L6uQ==
X-Gm-Message-State: ACgBeo3QV+n/28j1CNl1JVoLwRjNy32RBoTA1vNtq2h3Th3rtd4ihCTP
        xdLzCJFbNNcn4/d0KaAFAy9pKQwnjNPC7w==
X-Google-Smtp-Source: AA6agR6w/jJEYMrmemS0KfexrbaUIA/5VptL+HLVZeVHZwCvgK8iP0WkC/nErriIcCAh+0aA+t9ayg==
X-Received: by 2002:a17:90a:17e1:b0:1f2:2ff2:6cae with SMTP id q88-20020a17090a17e100b001f22ff26caemr13520867pja.196.1660907402423;
        Fri, 19 Aug 2022 04:10:02 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id jd7-20020a170903260700b0016bfbd99f64sm2957778plb.118.2022.08.19.04.10.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 04:10:02 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 02/13] x86/pmu: Introduce multiple_{one, many}() to improve readability
Date:   Fri, 19 Aug 2022 19:09:28 +0800
Message-Id: <20220819110939.78013-3-likexu@tencent.com>
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
index 817b4d0..45ca2c6 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -181,7 +181,7 @@ static void stop_event(pmu_counter_t *evt)
 	evt->count = rdmsr(evt->ctr);
 }
 
-static void measure(pmu_counter_t *evt, int count)
+static void measure_many(pmu_counter_t *evt, int count)
 {
 	int i;
 	for (i = 0; i < count; i++)
@@ -191,6 +191,11 @@ static void measure(pmu_counter_t *evt, int count)
 		stop_event(&evt[i]);
 }
 
+static void measure_one(pmu_counter_t *evt)
+{
+	measure_many(evt, 1);
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
+	measure_many(cnt, n);
 
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

