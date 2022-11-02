Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10FC06170EA
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 23:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbiKBWwA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 18:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbiKBWvq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 18:51:46 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31505DF6A
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 15:51:36 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id s15-20020a170902ea0f00b00187050232fcso194378plg.3
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 15:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/WzHmvQSU6M4bSICeKYbXzYA1VsWuSodUmHmde3yu4M=;
        b=HUQ3gAnvp3NR4dZjp90oQDKghHpMjrxG2/NbYbFAvTFM2kxNrrZA5iMUkwuCdC9Yar
         YZT9FPEb10FgR1sIanuLWi2GffmMWzeTFwaaLCeQQBeE21Y7EL9VkTb8CRVUIQbEFIic
         XWtGoaF70uT4u9MxhVbJ8Y3+cnV5OvoTckHyRWHuAVFhgOnnVX15EutQPQc/7mIxAUfP
         sqV3CWysQEtrg4P69S9E6XWNNg5rAxOgA2AzPZwZb4kvbuxAciVxoL3GsRV761opHmIM
         gQxLleyBh4DDhaLjlpPBQYLh/FloLcIW/96c4Twe23WG8Qx+RCRT1I28rnp3yY/2ncoR
         TPCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/WzHmvQSU6M4bSICeKYbXzYA1VsWuSodUmHmde3yu4M=;
        b=BJTV/leEGPNJSGiXsKtVM/U4TecmO793WZlTQ2ceyi4gNQzoUSXdlj8XHskc4MTp9S
         y7K60aFymlSkuoqrMNUJQOQk3J7yjxwIu5915e8I4nj1Y1/c9hM7+55+rg9C+BOIziQY
         GtX56B5k3c0dqeCu9C3lcR4YJ/F3eTRFCubFu4C8TcfLKAxiTvobSKwfIGOZX6yaIEbd
         maYaBpkZ1FaLwj+EVmCf1ah/DwBu8Fwxl5jwLDZI9wGm/Hfk4hf7yffLqYno+3BjUnnK
         ABPjWZO+8HMvlKK/EBBSCNPTTUe9iWx/sKZ/JjeeniS4PIy4WSwlZ0dfD8JDpIni5L1h
         eGPA==
X-Gm-Message-State: ACrzQf3MJDmvMRGP6Xu44LsDL6XvxXUPdJpEyeWpR+bmNAopHMXnd+h3
        XN/JdmjxNGBUK9QnRCKtg8VBCQXAXMM=
X-Google-Smtp-Source: AMsMyM4V/EVfaAlHIgqeTrrEMrsWjKdPxspqNFllj6YwK9HLMxQ1tn/EmF6vOHEyrzvc9S+E6EVVdqsFIGY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:114c:b0:528:2c7a:630e with SMTP id
 b12-20020a056a00114c00b005282c7a630emr26951465pfm.86.1667429495709; Wed, 02
 Nov 2022 15:51:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 22:50:55 +0000
In-Reply-To: <20221102225110.3023543-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102225110.3023543-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102225110.3023543-13-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v5 12/27] x86/pmu: Rename PC_VECTOR to
 PMI_VECTOR for better readability
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Like Xu <likexu@tencent.com>,
        Sandipan Das <sandipan.das@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

The original name "PC_VECTOR" comes from the LVT Performance
Counter Register. Rename it to PMI_VECTOR. That's much more familiar
for KVM developers and it's still correct, e.g. it's the PMI vector
that's programmed into the LVT PC register.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 03061388..b5828a14 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -11,7 +11,9 @@
 #include <stdint.h>
 
 #define FIXED_CNT_INDEX 32
-#define PC_VECTOR	32
+
+/* Performance Counter Vector for the LVT PC Register */
+#define PMI_VECTOR	32
 
 #define EVNSEL_EVENT_SHIFT	0
 #define EVNTSEL_UMASK_SHIFT	8
@@ -159,7 +161,7 @@ static void __start_event(pmu_counter_t *evt, uint64_t count)
 	    wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, ctrl);
     }
     global_enable(evt);
-    apic_write(APIC_LVTPC, PC_VECTOR);
+    apic_write(APIC_LVTPC, PMI_VECTOR);
 }
 
 static void start_event(pmu_counter_t *evt)
@@ -662,7 +664,7 @@ static void check_invalid_rdpmc_gp(void)
 int main(int ac, char **av)
 {
 	setup_vm();
-	handle_irq(PC_VECTOR, cnt_overflow);
+	handle_irq(PMI_VECTOR, cnt_overflow);
 	buf = malloc(N*64);
 
 	check_invalid_rdpmc_gp();
@@ -686,7 +688,7 @@ int main(int ac, char **av)
 	printf("Fixed counters:      %d\n", pmu_nr_fixed_counters());
 	printf("Fixed counter width: %d\n", pmu_fixed_counter_width());
 
-	apic_write(APIC_LVTPC, PC_VECTOR);
+	apic_write(APIC_LVTPC, PMI_VECTOR);
 
 	check_counters();
 
-- 
2.38.1.431.g37b22c650d-goog

