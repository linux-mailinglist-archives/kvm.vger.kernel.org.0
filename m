Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 524A06A5004
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 01:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbjB1AJT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 19:09:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjB1AJM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 19:09:12 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9BB6A68
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 16:08:55 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id u4-20020a170902bf4400b0019e30a57694so232459pls.20
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 16:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W+8dwHsB+Gu2Q76MGxzkoyzzfv3d8yoeeGPaquCGBac=;
        b=OGDDYdCth6uOxOAOjkLpR4SVviA2JCyYfvFvjd/Zb3gf0QIsMtKQKbH5pRX2WYVvPB
         oUof0MzMrD15TiKIqJItvS60MeGziFcqXuxR1TFFdcy37h1HoeY22bYv0GYQKG08Pkor
         ONX8vLl6vr0wE1sbLFOzFar1IqpDny0L6ma8HulwRrn9Ae0PvlGI79tMy9FeM/o0bE+U
         yDqqdaoHe84KwkElaJobu0NdCSv/2X/ZY4vlz9Fc8t5TuZ5AjFJsjoBPNQsb1+dvMKIP
         addSPrQdiSeTSvko1eRG0lw0TW8WW9qHfuFvZnCRF0xbvOgvtwiG3blHhtymC6pcJbAu
         Wrhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W+8dwHsB+Gu2Q76MGxzkoyzzfv3d8yoeeGPaquCGBac=;
        b=41MhvfONKZRaSZzT7PzO0k9FMXohjAOvI9GH258vw3xppj61Lz8Zmuo17l/ZQA0P6j
         SjV+G4qDjGRzqJr/rzV7knC++sKVm++7CQ5ebmZo7XoIpZo5mjB2Yh6mjwKI0Rzvu8+4
         jDsclLuV9yQaYa/s0Eeafm8LuTLWqT9TFBE6x2/tSHJPXhfxOGrKgTgigIiBxh8uuVT3
         IjFZFPZ6sDJnRdMhWRRpOCnKgmMUe4EA8fKTuCOiYUTVi1fiAIDLeJF5oQJ4NJVcmubI
         8OmFfYo/faCtQUqHKzlgaNqnre/kE99Hn2ylb/W7Jb8HYiCRB1cerMSiEtQi3xeXByfF
         0tTg==
X-Gm-Message-State: AO0yUKVkAazCjC0wvLdFZ7IBPLiOQ2CGSHEnVhsGLroMdO9gtQtBE8rc
        lU9X4yElIPe/VzY2cQwm4IIeZ5stmHAPkbjT7EyVHRq/nGVJLv8yHqiEqxH/VsHyK9wGUh4omHa
        d73P8Xlk3akapOkbXW/1b5BsNOxQVz26ypEeNryg7Fcymcl37gGBp2W5L+yG+QTfUDe0E
X-Google-Smtp-Source: AK7set8TiqlOy2/6W7SQbvSZPEX/DMZFIXr/FCOO8xO+JRgDPa0lt0+xBP/BKzhRaxGpLyUhVfBNVZv/llb+W64y
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a62:8245:0:b0:5a8:b513:f942 with SMTP
 id w66-20020a628245000000b005a8b513f942mr323814pfd.1.1677542929553; Mon, 27
 Feb 2023 16:08:49 -0800 (PST)
Date:   Tue, 28 Feb 2023 00:06:40 +0000
In-Reply-To: <20230228000644.3204402-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230228000644.3204402-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230228000644.3204402-2-aaronlewis@google.com>
Subject: [PATCH v2 1/5] KVM: x86/pmu: Prevent the PMU from counting disallowed events
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, Aaron Lewis <aaronlewis@google.com>
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

When counting "Instructions Retired" (0xc0) in a guest, KVM will
occasionally increment the PMU counter regardless of if that event is
being filtered. This is because some PMU events are incremented via
kvm_pmu_trigger_event(), which doesn't know about the event filter. Add
the event filter to kvm_pmu_trigger_event(), so events that are
disallowed do not increment their counters.

Fixes: 9cd803d496e7 ("KVM: x86: Update vPMCs when retiring instructions")
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/pmu.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 612e6c70ce2e..0fe23bda855b 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -400,6 +400,12 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 	return is_fixed_event_allowed(filter, pmc->idx);
 }
 
+static bool pmc_is_allowed(struct kvm_pmc *pmc)
+{
+	return pmc_is_enabled(pmc) && pmc_speculative_in_use(pmc) &&
+	       check_pmu_event_filter(pmc);
+}
+
 static void reprogram_counter(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
@@ -409,10 +415,7 @@ static void reprogram_counter(struct kvm_pmc *pmc)
 
 	pmc_pause_counter(pmc);
 
-	if (!pmc_speculative_in_use(pmc) || !pmc_is_enabled(pmc))
-		goto reprogram_complete;
-
-	if (!check_pmu_event_filter(pmc))
+	if (!pmc_is_allowed(pmc))
 		goto reprogram_complete;
 
 	if (pmc->counter < pmc->prev_counter)
@@ -684,7 +687,7 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id)
 	for_each_set_bit(i, pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX) {
 		pmc = static_call(kvm_x86_pmu_pmc_idx_to_pmc)(pmu, i);
 
-		if (!pmc || !pmc_is_enabled(pmc) || !pmc_speculative_in_use(pmc))
+		if (!pmc || !pmc_is_allowed(pmc))
 			continue;
 
 		/* Ignore checks for edge detect, pin control, invert and CMASK bits */
-- 
2.39.2.722.g9855ee24e9-goog

