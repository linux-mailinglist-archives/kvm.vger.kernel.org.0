Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81610715556
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 08:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbjE3GFr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 02:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbjE3GFd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 02:05:33 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C35F193;
        Mon, 29 May 2023 23:05:06 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id 98e67ed59e1d1-2567b589d3bso1133505a91.0;
        Mon, 29 May 2023 23:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685426705; x=1688018705;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LJ2FwZAiYnnxTMqhmBL3k/Q41PMPtvvS6ULSWDD5Mqc=;
        b=HPC9KjgnqebMUM2BNBy9LntiMFDjIn1C7O0cXwicuTccC7Z49EDUW0+mbwiV+yK7Sz
         352WqL5SSlwa5KrPN88g9CbT5Mkyc8U4gsJaV2hQIpKB/7rEHiPb/z7ll94OyOuwD+OG
         TblY+xS3X/Az0L87SVJXNxMRGKE90q1YF0MlAreGQEJpq29KBhrQGenKJRJy+Yjk0ROx
         qJ/c8mNNE5mT6F9JkQo8990lCK6M42t6TRXHk24YjdPktjITEEn2dMbLvprgjeKvyrYU
         NL8XC6UizRS0YMoJ8ZTPFODqsfw4PC1hzVWuj44jSau2PiPIrurAMKnbxHPwK7fxMyfE
         5gfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685426705; x=1688018705;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LJ2FwZAiYnnxTMqhmBL3k/Q41PMPtvvS6ULSWDD5Mqc=;
        b=I2S+o2TEOKZuiQsyB09vvlZKdrg4cygtmZf3mjU1E4zLEwIj4ixwcg0IFvKKRsomZB
         vz0FZ/R552LoI4hnu0gfyv94DzjqZM8fWK3XU35tqslEbjOk+49KVU97XQcQUK2cIAip
         /ySn3ceqcuek7RtBJetWlw5RMar3I3W3YiTokYZrWY/fEL4sPblASk48Ia6CfgOlVGAO
         dif8iurQ2tMnK3x5mE6uVraNhnzLyWAyvQbxH+9xqVRSqvlenCOqTiCQvLvaJ+e6396i
         3jm1p0rrScRVJ1JI8HYB1dWMG4NNnZrYUK4Wa2inb7F2QrLHTln5PyniDK7UUUTpWZrq
         FkVw==
X-Gm-Message-State: AC+VfDyyfeY3DlwihuCOJ94Se1jvCQrYH9nNV7C9m9wAKm84bPgvbhvR
        YMNxwcTlLMveVULvlETAo6hzC2TJ/pS0Qhgpgug=
X-Google-Smtp-Source: ACHHUZ4uS3H9sQQBMFqwjQNQ/rHgvhfvNYFF61L+vvlwZiSXcnFl+IHX3upZuBZaJttgC1bRUznrGQ==
X-Received: by 2002:a17:90a:af97:b0:255:6ea7:7041 with SMTP id w23-20020a17090aaf9700b002556ea77041mr1385139pjq.41.1685426705637;
        Mon, 29 May 2023 23:05:05 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id gw8-20020a17090b0a4800b00256b67208b1sm638072pjb.56.2023.05.29.23.05.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 23:05:05 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>
Subject: [PATCH v6 10/10] KVM: x86/cpuid: Add AMD CPUID ExtPerfMonAndDbg leaf 0x80000022
Date:   Tue, 30 May 2023 14:04:23 +0800
Message-Id: <20230530060423.32361-11-likexu@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230530060423.32361-1-likexu@tencent.com>
References: <20230530060423.32361-1-likexu@tencent.com>
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

CPUID leaf 0x80000022 i.e. ExtPerfMonAndDbg advertises some new
performance monitoring features for AMD processors.

Bit 0 of EAX indicates support for Performance Monitoring Version 2
(PerfMonV2) features. If found to be set during PMU initialization,
the EBX bits of the same CPUID function can be used to determine
the number of available PMCs for different PMU types.

Expose the relevant bits via KVM_GET_SUPPORTED_CPUID so that
guests can make use of the PerfMonV2 features.

Co-developed-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/cpuid.c   | 28 +++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.c |  4 ++++
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 61bc71882f07..0e5584f4acd7 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -734,6 +734,10 @@ void kvm_set_cpu_caps(void)
 		F(NULL_SEL_CLR_BASE) | F(AUTOIBRS) | 0 /* PrefetchCtlMsr */
 	);
 
+	kvm_cpu_cap_init_kvm_defined(CPUID_8000_0022_EAX,
+		F(PERFMON_V2)
+	);
+
 	/*
 	 * Synthesize "LFENCE is serializing" into the AMD-defined entry in
 	 * KVM's supported CPUID if the feature is reported as supported by the
@@ -1128,7 +1132,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->edx = 0;
 		break;
 	case 0x80000000:
-		entry->eax = min(entry->eax, 0x80000021);
+		entry->eax = min(entry->eax, 0x80000022);
 		/*
 		 * Serializing LFENCE is reported in a multitude of ways, and
 		 * NullSegClearsBase is not reported in CPUID on Zen2; help
@@ -1233,6 +1237,28 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->ebx = entry->ecx = entry->edx = 0;
 		cpuid_entry_override(entry, CPUID_8000_0021_EAX);
 		break;
+	/* AMD Extended Performance Monitoring and Debug */
+	case 0x80000022: {
+		union cpuid_0x80000022_ebx ebx;
+
+		entry->ecx = entry->edx = 0;
+		if (!enable_pmu || !kvm_cpu_cap_has(X86_FEATURE_PERFMON_V2)) {
+			entry->eax = entry->ebx;
+			break;
+		}
+
+		cpuid_entry_override(entry, CPUID_8000_0022_EAX);
+
+		if (kvm_cpu_cap_has(X86_FEATURE_PERFMON_V2))
+			ebx.split.num_core_pmc = kvm_pmu_cap.num_counters_gp;
+		else if (kvm_cpu_cap_has(X86_FEATURE_PERFCTR_CORE))
+			ebx.split.num_core_pmc = AMD64_NUM_COUNTERS_CORE;
+		else
+			ebx.split.num_core_pmc = AMD64_NUM_COUNTERS;
+
+		entry->ebx = ebx.full;
+		break;
+	}
 	/*Add support for Centaur's CPUID instruction*/
 	case 0xC0000000:
 		/*Just support up to 0xC0000004 now*/
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d9669e3cc00a..ff48cdea1fbf 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5036,6 +5036,10 @@ static __init void svm_set_cpu_caps(void)
 							  kvm_pmu_cap.num_counters_gp);
 		else
 			kvm_cpu_cap_check_and_set(X86_FEATURE_PERFCTR_CORE);
+
+		if (kvm_pmu_cap.version != 2 ||
+		    !kvm_cpu_cap_has(X86_FEATURE_PERFCTR_CORE))
+			kvm_cpu_cap_clear(X86_FEATURE_PERFMON_V2);
 	}
 
 	/* CPUID 0x8000001F (SME/SEV features) */
-- 
2.40.1

