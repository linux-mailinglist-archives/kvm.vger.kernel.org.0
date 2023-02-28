Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 077506A5001
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 01:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjB1AJP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 19:09:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjB1AJM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 19:09:12 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08CC1BDA
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 16:08:55 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id y1-20020a631801000000b00503696ca95dso960637pgl.1
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 16:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2hx5vfPBIO0/rxJHl8Nre9/ek5yd0Nw1zRCzUtOuy94=;
        b=n0kdTP6jCacO3bGvV0DjyNeAc4CtVcdWb4mRnVRfnvogDa65Ao9oyONBCCMsTUYQ7m
         O3h9uTqLq2DdSEkJ7B938msjH4ar7PT0KcnY4sNskxR+jvUB0yplXP1Wg+reWoIEDtVL
         Hnu/Bzajty6nxvIuI173J5ibHRB4U+iavNPWXbpDHNjCV5djxGqLmjgcO2vGU+4zq4lQ
         mKbGUx50b8MQhAE28SY+sr3YB6xqad87Lj+ubFs6zC881MZZNqmVTdoceAA+7i5a8YK8
         Yg+xEh1TwKy77A41QV00jg6MYlUaXO7sT5ZqE8jJOD1V6pOsxK6mu4P9cS1Q9zmlvl8X
         QoSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2hx5vfPBIO0/rxJHl8Nre9/ek5yd0Nw1zRCzUtOuy94=;
        b=frt8x8I0UuGxKHfhGVuGGCIK423G/3noWEbLTMPPUYdcuX3APhLPi1fml4CtmuTq3H
         ACr0RDkGJUVKh3ihUr54qOHyqIvWEUjoYHqIPrdGCFiaKIZYw/+d4bC+zXyAdgjV36mO
         57bxe7qGuNtELj4E86aaNYdCCHghdi9aK4Ydb+i0gqFzipScYpyVbRD3ai8eyq1Vi73K
         l4yX5/s1OKxt7np1JDsGnwZbLrRvwuJAiSeV7SPPchHufXklehKkdUxgv2nxrGVya+9b
         5QZ9wQuHJ3Qj06/qD9v7W5o56pnt8B1KetnpNd0PqSpa8f/mvZAk5GC5HNjQKGFJQeBJ
         shdg==
X-Gm-Message-State: AO0yUKXMfPtrAEyGLntscwQ+9M3nOezeIGawC2DfOSkVgkL6tEOscoIi
        cf6nxadJYDFdoAKauGcnBK+e9Bxh857BC5Z6OVnS+JkziGX+kUkOCIRUXrG1art4nVr3r4+p9qM
        smz7fEmS7pOBJHxkKBT7c9op3VBuGE8lzR7TI1UP+2gIk/4nmtDRCJpY/YXcCUtWayLHM
X-Google-Smtp-Source: AK7set/2xsxQ3ysgVs0TyKe8CwMXREDxVU48/d1MStTWnQPLDWhmgSK7nuzIdfuXx0NLSb0loh0sgrFzf8vVxNC5
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a05:6a00:3247:b0:593:dcf6:acc2 with
 SMTP id bn7-20020a056a00324700b00593dcf6acc2mr340761pfb.1.1677542931322; Mon,
 27 Feb 2023 16:08:51 -0800 (PST)
Date:   Tue, 28 Feb 2023 00:06:41 +0000
In-Reply-To: <20230228000644.3204402-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230228000644.3204402-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230228000644.3204402-3-aaronlewis@google.com>
Subject: [PATCH v2 2/5] KVM: selftests: Add a common helper to the guest
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

Split out the common parts of the Intel and AMD guest code into a
helper function.  This is in preparation for adding
additional counters to the test.

No functional changes intended.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 .../kvm/x86_64/pmu_event_filter_test.c        | 31 ++++++++++++-------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index bad7ef8c5b92..f33079fc552b 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -100,6 +100,17 @@ static void check_msr(uint32_t msr, uint64_t bits_to_flip)
 		GUEST_SYNC(0);
 }
 
+static uint64_t test_guest(uint32_t msr_base)
+{
+	uint64_t br0, br1;
+
+	br0 = rdmsr(msr_base + 0);
+	__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
+	br1 = rdmsr(msr_base + 0);
+
+	return br1 - br0;
+}
+
 static void intel_guest_code(void)
 {
 	check_msr(MSR_CORE_PERF_GLOBAL_CTRL, 1);
@@ -108,16 +119,15 @@ static void intel_guest_code(void)
 	GUEST_SYNC(1);
 
 	for (;;) {
-		uint64_t br0, br1;
+		uint64_t count;
 
 		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
 		wrmsr(MSR_P6_EVNTSEL0, ARCH_PERFMON_EVENTSEL_ENABLE |
 		      ARCH_PERFMON_EVENTSEL_OS | INTEL_BR_RETIRED);
-		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 1);
-		br0 = rdmsr(MSR_IA32_PMC0);
-		__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
-		br1 = rdmsr(MSR_IA32_PMC0);
-		GUEST_SYNC(br1 - br0);
+		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0x1);
+
+		count = test_guest(MSR_IA32_PMC0);
+		GUEST_SYNC(count);
 	}
 }
 
@@ -133,15 +143,14 @@ static void amd_guest_code(void)
 	GUEST_SYNC(1);
 
 	for (;;) {
-		uint64_t br0, br1;
+		uint64_t count;
 
 		wrmsr(MSR_K7_EVNTSEL0, 0);
 		wrmsr(MSR_K7_EVNTSEL0, ARCH_PERFMON_EVENTSEL_ENABLE |
 		      ARCH_PERFMON_EVENTSEL_OS | AMD_ZEN_BR_RETIRED);
-		br0 = rdmsr(MSR_K7_PERFCTR0);
-		__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
-		br1 = rdmsr(MSR_K7_PERFCTR0);
-		GUEST_SYNC(br1 - br0);
+
+		count = test_guest(MSR_K7_PERFCTR0);
+		GUEST_SYNC(count);
 	}
 }
 
-- 
2.39.2.722.g9855ee24e9-goog

