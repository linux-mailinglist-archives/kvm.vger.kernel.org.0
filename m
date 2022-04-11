Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E59004FB952
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 12:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345294AbiDKKWX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 06:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345290AbiDKKWV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 06:22:21 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7634642A3C;
        Mon, 11 Apr 2022 03:20:02 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id t4so13795309pgc.1;
        Mon, 11 Apr 2022 03:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0eD8mKmQH7sQmJikQBGEGaLeEReKUW3TEXfdBvaqw4c=;
        b=SfeeHCn7o2nbaJL54nAzlBw0c2r7X89Kmi6z7HHRxwroSpyDla3+/vDeNMpZjuCFKV
         5vPYpGcEZcVbBnGI2MjXHylLyUl4+GsYcJd8SDKMhgoFDbPWxcUqwh0HjIzD1Y7xVwPB
         2/yZ/+sqZJnPYI4x0B6kqczhKZ4JQGQG4w2nJcoWX2JxR5maRmrA5q9k3qw9L0CeXY7Q
         1tosQHKrHPqM77stBFnChx2WKhjTQlKd7lL+EceLaf53+kRupGxPwNnVLH+9whxn7avB
         vgN/S6EUpbdu3fLNAhr2pqBwxMLNd1RzDHLigoDizDl6IjFK5wX1pxmccPvaLmNYPnAU
         C8pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0eD8mKmQH7sQmJikQBGEGaLeEReKUW3TEXfdBvaqw4c=;
        b=8B2rHhxZS72vWageTpNjHnw1BqlWD0ySnZcNYPCQJna9o56Q0JjGyFMt5/+FZhhWiY
         OzCYoHHuSx5bbnThsuuZIB0rlXL3dpT87AHykXhYVEOTP5lG6xPclVeEqgLLj8uGYG6y
         6be+zuuMd1LDMzEh5qVmpEEQ2qkTQjAab1u/9J0G0N+lPstLI4dpLmJXk4Xd/IFKHRN3
         pn8zes1GRii/81tpQ34WdZaTadtbAOs1mg5lVw/jKxGRKreia7KgUWHn8CZSM/0noEWz
         pEIg3lqBF5Pf2KltonQdGCKH5VB1CPRtKlQtbZq7I7wHAo4zjV3EOWGWoaSK/FqIrYhu
         JGrg==
X-Gm-Message-State: AOAM532G4LjfYwry0Bk2yqmRXDLobsRHg6+GFcvcYPpv51LQ4ZEsTKDA
        xVbWJd6FRVGI2ZToYH47BFxzd+pA9fI=
X-Google-Smtp-Source: ABdhPJxNk7vZOcbpYNxcTB+QtJRcLdU8EErBUvZFEev/F9v2XgGDA6r4OMn/EPLH7NZdS05lcJhNJw==
X-Received: by 2002:a05:6a00:2408:b0:4f7:a8cb:9b63 with SMTP id z8-20020a056a00240800b004f7a8cb9b63mr32186095pfh.33.1649672401485;
        Mon, 11 Apr 2022 03:20:01 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.112])
        by smtp.gmail.com with ESMTPSA id h10-20020a056a00230a00b004faa0f67c3esm34012280pfh.23.2022.04.11.03.19.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 03:20:01 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH RESEND v12 03/17] perf/x86/core: Pass "struct kvm_pmu *" to determine the guest values
Date:   Mon, 11 Apr 2022 18:19:32 +0800
Message-Id: <20220411101946.20262-4-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411101946.20262-1-likexu@tencent.com>
References: <20220411101946.20262-1-likexu@tencent.com>
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

From: Like Xu <like.xu@linux.intel.com>

Splitting the logic for determining the guest values is unnecessarily
confusing, and potentially fragile. Perf should have full knowledge and
control of what values are loaded for the guest.

If we change .guest_get_msrs() to take a struct kvm_pmu pointer, then it
can generate the full set of guest values by grabbing guest ds_area and
pebs_data_cfg. Alternatively, .guest_get_msrs() could take the desired
guest MSR values directly (ds_area and pebs_data_cfg), but kvm_pmu is
vendor agnostic, so we don't see any reason to not just pass the pointer.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/events/core.c            | 4 ++--
 arch/x86/events/intel/core.c      | 4 ++--
 arch/x86/events/perf_event.h      | 2 +-
 arch/x86/include/asm/perf_event.h | 4 ++--
 arch/x86/kvm/vmx/vmx.c            | 3 ++-
 5 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index adb6d9d3cd4d..7f1d10dbabc0 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -693,9 +693,9 @@ void x86_pmu_disable_all(void)
 	}
 }
 
-struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
+struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data)
 {
-	return static_call(x86_pmu_guest_get_msrs)(nr);
+	return static_call(x86_pmu_guest_get_msrs)(nr, data);
 }
 EXPORT_SYMBOL_GPL(perf_guest_get_msrs);
 
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 510fc2de4cd2..039e4e7cbc2f 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3972,7 +3972,7 @@ static int intel_pmu_hw_config(struct perf_event *event)
 	return 0;
 }
 
-static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
+static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
@@ -4005,7 +4005,7 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
 	return arr;
 }
 
-static struct perf_guest_switch_msr *core_guest_get_msrs(int *nr)
+static struct perf_guest_switch_msr *core_guest_get_msrs(int *nr, void *data)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index 0998742760c8..bf23cbe4f6cf 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -900,7 +900,7 @@ struct x86_pmu {
 	/*
 	 * Intel host/guest support (KVM)
 	 */
-	struct perf_guest_switch_msr *(*guest_get_msrs)(int *nr);
+	struct perf_guest_switch_msr *(*guest_get_msrs)(int *nr, void *data);
 
 	/*
 	 * Check period value for PERF_EVENT_IOC_PERIOD ioctl.
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 44c9a4c20c06..dc295b8c8def 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -492,10 +492,10 @@ static inline void perf_check_microcode(void) { }
 #endif
 
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
-extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr);
+extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data);
 extern int x86_perf_get_lbr(struct x86_pmu_lbr *lbr);
 #else
-struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr);
+struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data);
 static inline int x86_perf_get_lbr(struct x86_pmu_lbr *lbr)
 {
 	return -1;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cf8581978bce..ff28a3992427 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6696,9 +6696,10 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 {
 	int i, nr_msrs;
 	struct perf_guest_switch_msr *msrs;
+	struct kvm_pmu *pmu = vcpu_to_pmu(&vmx->vcpu);
 
 	/* Note, nr_msrs may be garbage if perf_guest_get_msrs() returns NULL. */
-	msrs = perf_guest_get_msrs(&nr_msrs);
+	msrs = perf_guest_get_msrs(&nr_msrs, (void *)pmu);
 	if (!msrs)
 		return;
 
-- 
2.35.1

