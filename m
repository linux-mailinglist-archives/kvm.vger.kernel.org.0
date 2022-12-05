Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC7C642848
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 13:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbiLEMVK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 07:21:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbiLEMVJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 07:21:09 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5279CE0A8;
        Mon,  5 Dec 2022 04:21:08 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id jl24so10609713plb.8;
        Mon, 05 Dec 2022 04:21:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ujNogmjXUzAdISFdb+k3CYrlxMM8u71cOZOj6myJAqE=;
        b=No09YoJkVDU4OufxqqO6sN8dTeRdkfVar42K6FmDqjxSn+V79DeZYHgDGMSsUc+yzO
         swE56S7z6QryfN/O2b0ocCjHnBapNqaZ8CecL9o7yMKRbI55uVtvwOmgcZVeLy5y4+KT
         zPpULhsThc+raDCqC+Ul923r0ZeCPoslYvCIVPv/nYjWvJRIf9k+BGNDEwquTmNQaqFY
         XNCG6rG9/tQ7R6/sZ750f4sc7cJACL7xZ/LF7z57lggPqbyCO4GQelqspkBSVZeYZgAN
         R9hpJAhTVco0U12Vi++ttYjU7WeQkW6TjnPlJVCiCO9nCZU9mSOwAObmBE/Xu/nXYihu
         YbKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ujNogmjXUzAdISFdb+k3CYrlxMM8u71cOZOj6myJAqE=;
        b=kSJ4Ndu1FDtCp3o+5TnaEFspnqH4Bj6cyyKftgsceL84cmC0HCL6AEHRKmaC1q7NDy
         uqrOg3giPFLgZtzdx8HdCf2R8FOnC7LmvM4JjG3Ax2o13Rt2MR4oL9V44+52dZJbIeSz
         I8dvUU7vXv+cOc0EHKwsKwN9FKrp8Fmq9YZDopLrU5UCXUe9vbPlU6agXDG42wga9cqs
         3eQCVSgD3QQhqp2m5k/9Hxhci9LTYi1ltFOG7Mp7Cc5/Kd6jDdqqjhC8zIXbQAzOQ0cq
         kS0qF1Q6nCu0qZvIUc+d5fORGRBmHGyWm21F+WXdx6Mgds/8lroflGFGZmcyP94JWaig
         dvNA==
X-Gm-Message-State: ANoB5plYsdFD6rORoAsmGmYoAnKvaGY54c9wJN3SVRbVz1uVcR4mrt59
        hlpfXcsrMZRAZeABjxsWptSD58FuxjaLng==
X-Google-Smtp-Source: AA0mqf6J2G6JDn5Wk7NDveDevBtWVzpm+g15JdSbwO9wxgEMv+vSRBvdSsyR6//5Z5G6Oc2wXA9GHA==
X-Received: by 2002:a17:902:b184:b0:189:1d01:a4ae with SMTP id s4-20020a170902b18400b001891d01a4aemr65843926plr.93.1670242867768;
        Mon, 05 Dec 2022 04:21:07 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id jf1-20020a170903268100b00186b7443082sm10458256plb.195.2022.12.05.04.21.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 04:21:07 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/pmu: Drop event_type and rename "struct kvm_event_hw_type_mapping"
Date:   Mon,  5 Dec 2022 20:20:48 +0800
Message-Id: <20221205122048.16023-1-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

After commit ("02791a5c362b KVM: x86/pmu: Use PERF_TYPE_RAW
to merge reprogram_{gp,fixed}counter()"), vPMU starts to directly
use the hardware event eventsel and unit_mask to reprogram perf_event,
and the event_type field in the "struct kvm_event_hw_type_mapping"
is simply no longer being used.

After discarding this field, the name of the structure also lost
its mapping semantics, renaming it "struct kvm_pmu_hw_event" and
reorganizing the comments to continue to help newcomers.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.h           |  3 +--
 arch/x86/kvm/vmx/pmu_intel.c | 34 +++++++++++++++++++++++++---------
 2 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 85ff3c0588ba..2aef09eafb70 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -18,10 +18,9 @@
 #define VMWARE_BACKDOOR_PMC_REAL_TIME		0x10001
 #define VMWARE_BACKDOOR_PMC_APPARENT_TIME	0x10002
 
-struct kvm_event_hw_type_mapping {
+struct kvm_pmu_hw_event {
 	u8 eventsel;
 	u8 unit_mask;
-	unsigned event_type;
 };
 
 struct kvm_pmu_ops {
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 28b0a784f6e9..d34e9f85bdce 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -20,16 +20,32 @@
 
 #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
 
-static struct kvm_event_hw_type_mapping intel_arch_events[] = {
-	[0] = { 0x3c, 0x00, PERF_COUNT_HW_CPU_CYCLES },
-	[1] = { 0xc0, 0x00, PERF_COUNT_HW_INSTRUCTIONS },
-	[2] = { 0x3c, 0x01, PERF_COUNT_HW_BUS_CYCLES  },
-	[3] = { 0x2e, 0x4f, PERF_COUNT_HW_CACHE_REFERENCES },
-	[4] = { 0x2e, 0x41, PERF_COUNT_HW_CACHE_MISSES },
-	[5] = { 0xc4, 0x00, PERF_COUNT_HW_BRANCH_INSTRUCTIONS },
-	[6] = { 0xc5, 0x00, PERF_COUNT_HW_BRANCH_MISSES },
+/*
+ * The first part of hw_events in the following array represent Intel's
+ * Pre-defined Architectural Performance Events in an ordered manner:
+ *
+ * 0 - PERF_COUNT_HW_CPU_CYCLES
+ * 1 - PERF_COUNT_HW_INSTRUCTIONS
+ * 2 - PERF_COUNT_HW_BUS_CYCLES
+ * 3 - PERF_COUNT_HW_CACHE_REFERENCES
+ * 4 - PERF_COUNT_HW_CACHE_MISSES
+ * 5 - PERF_COUNT_HW_BRANCH_INSTRUCTIONS
+ * 6 - PERF_COUNT_HW_BRANCH_MISSES
+ *
+ * the second part of hw_events is defined by the generic kernel perf:
+ *
+ * 7 - PERF_COUNT_HW_REF_CPU_CYCLES
+ */
+static struct kvm_pmu_hw_event intel_arch_events[] = {
+	[0] = { 0x3c, 0x00 },
+	[1] = { 0xc0, 0x00 },
+	[2] = { 0x3c, 0x01 },
+	[3] = { 0x2e, 0x4f },
+	[4] = { 0x2e, 0x41 },
+	[5] = { 0xc4, 0x00 },
+	[6] = { 0xc5, 0x00 },
 	/* The above index must match CPUID 0x0A.EBX bit vector */
-	[7] = { 0x00, 0x03, PERF_COUNT_HW_REF_CPU_CYCLES },
+	[7] = { 0x00, 0x03 },
 };
 
 /* mapping between fixed pmc index and intel_arch_events array */
-- 
2.38.1

