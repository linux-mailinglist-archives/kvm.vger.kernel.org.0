Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9265648931
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 20:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbiLITuK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 14:50:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiLITuI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 14:50:08 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C1A93AC3F
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 11:50:07 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-3d3769a8103so62273827b3.17
        for <kvm@vger.kernel.org>; Fri, 09 Dec 2022 11:50:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ockhN2neCgs2vztfmQt5TPkd6dlXFCpHuOLhT896PhU=;
        b=CjQ4OcsMtkem+PyG4BmTfQReva/kI+LHuLYPWZ9xU6uxjMRyRXKw6CRpbHJr0gbAIN
         3A9AoKUSVn9u8DhnriOV9zYspZPdUbFpqGBtpbUQvAq+JMyUOH3Jj+0xBdng0qnjYd9x
         LIqb9coy4M5u6nIQxdHb4he++FXTNYvshGaT5AkR/A2tt69dtP5xkkcA3iekUZ2EmRru
         O6aMBulpDobUJTO6H7Y3cCNrimdV2C9+Uwv8a8V/kNB8Q3UXRkz85vPSNde4zcVBhzk/
         M9yH+Mv+8XvOWgWk0FaiadMAxvBMD9wL/O69R22TwpxVfNH7BdBooFTXj+LfQjxI4dr8
         NX8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ockhN2neCgs2vztfmQt5TPkd6dlXFCpHuOLhT896PhU=;
        b=jNKf0UpDym785J54X6owVw6y67sYIWX18S1nBRtmR67oT3DsWG0q85wF8wtgaccLgV
         jSZU0ztklyThjCrcu6XGw2taIRq3XaEUQoZy0nBGLyqTP5HL3uQNK4iUk0sHfiNHr+vq
         zgs6ybQrkSwH2zQBVE9124x9F9pQkTndUm0roeaAT+3rnExdRaLZhPPWKnMTCsCepvmL
         LTmZZWy7uG62VtKdzjB4KH3rVAZw22T3xR972p6vQhkiZ1EcKKBdDcSNTBQOSAtFNanf
         EX0Inve9yK2AjhrkuQ6XCDVR/b4w0cmd8Di+a5manrtkoaPdb1XYbujZRd2Zd5mCH25l
         neJw==
X-Gm-Message-State: ANoB5pkRq9e6U5Qpcn3rwWoB6G8sd1M4YC/8zpnOf1wdJHVPxpwaHp2k
        puNzVjeT19+5Jvz/puT1AYce0Aepmx92WigL/yInbz5CsS+Nmtu7Wy6zQg2JsNgl8n92yFkTQBZ
        B0tn40i37WEwOE35DKTcLr+cZWRrX1G+4pqOMR3g26ZISElALxH/4PyBLMNAD7RBrnEZf
X-Google-Smtp-Source: AA0mqf7F2L2xby4GHm9f5G3giyek3vz9f7ckNxx+YXnucJ2jiHXWVUXimso/8pA8o/ZvZxaySyo34Im/UPFdTPY4
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a25:b43:0:b0:6fe:3d7f:d04a with SMTP id
 64-20020a250b43000000b006fe3d7fd04amr25261612ybl.617.1670615406510; Fri, 09
 Dec 2022 11:50:06 -0800 (PST)
Date:   Fri,  9 Dec 2022 19:49:56 +0000
In-Reply-To: <20221209194957.2774423-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20221209194957.2774423-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221209194957.2774423-2-aaronlewis@google.com>
Subject: [PATCH 1/2] KVM: x86/pmu: Prevent the PMU from counting disallowed events
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
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
 arch/x86/kvm/pmu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 684393c22105..b87cf35a38b7 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -581,7 +581,9 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id)
 	for_each_set_bit(i, pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX) {
 		pmc = static_call(kvm_x86_pmu_pmc_idx_to_pmc)(pmu, i);
 
-		if (!pmc || !pmc_is_enabled(pmc) || !pmc_speculative_in_use(pmc))
+		if (!pmc || !pmc_is_enabled(pmc) ||
+		    !pmc_speculative_in_use(pmc) ||
+		    !check_pmu_event_filter(pmc))
 			continue;
 
 		/* Ignore checks for edge detect, pin control, invert and CMASK bits */
-- 
2.39.0.rc1.256.g54fd8350bd-goog

