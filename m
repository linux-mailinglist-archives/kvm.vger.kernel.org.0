Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67E7F6B3DE0
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 12:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbjCJLeN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 06:34:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbjCJLeK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 06:34:10 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE415A6CD;
        Fri, 10 Mar 2023 03:34:08 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id q31-20020a17090a17a200b0023750b69614so4881583pja.5;
        Fri, 10 Mar 2023 03:34:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678448048;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gUEAdqF+264y6tlNIPm7sGs8cFITkhpABstRdo7c1DM=;
        b=MRvkh5/PNs0WAUTuQkUSErisBQ7SsJAicgBMz6NQmzDG4hjoYzDT4DvVMPKDsQp0Ln
         2XXYoBb64e6AJIQS9sBUzRC0oFKVe93Dch7ihhYyBk75Gkybk8Xc5g551xYhIqSnbeYU
         0FNmL1uk8Tp9+eEbQJCQRMCFgchDK0xi4JA6v4HHpHYK71B7ZizhuKQFOfU8/5E4HR5p
         SbxHiCInlm4h2GtMHK7ioKz5BLyOpUHxaaJVz15UugrOC/3OQe8q69NdFiwZckFvnHgk
         aIHTUgPMnNpvtvxsPJODfkASHHgayhGAswmwbrjk7d2Qjk0YGXpP/9TR+RapSto7d5Tq
         fKjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678448048;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gUEAdqF+264y6tlNIPm7sGs8cFITkhpABstRdo7c1DM=;
        b=QzxhQ0eh9IoXhPNXYXoaUAulFdJnm3t4g2tNOKiO5EaQJGEIpL4Ey1hd454iV2aY9c
         FBo9ylgcCUl0mAx26ycUTDK6mlLM+qx0ZSkwNzSDBPwXRQVAYcD5/k30S+nrVaA+eG35
         BRXUUJsYv0Ny1371yn0ZCTvyuBK8S62KpyqWcM17tFh/1ngcKTvNifeoP1aKTomIeSDb
         C6Rqzr8qWZxUe5nDNEBCQEEWiWvmX+blw/w9lXI2GLwjMxbi1TZegl/htdzgGrralZ4B
         ZfcdsXcz2I3mtW38+QKhI6KVLNrRkLhHB3qCAVDn5Ip8SMLUtpsG3IoM5ULW4hHPbdPV
         oQYw==
X-Gm-Message-State: AO0yUKXgRzIuvaGRXC2tyoWvN131dA4E7cMYIF++1A9rFtjjtzn8LXKP
        xoWZVvtBpIHJ60BCQUNuRXc=
X-Google-Smtp-Source: AK7set/OHox9rucqDPJR8yo7aCauRXYUk3HSK2MhXL8vQd/4hyDXGo0VYrHSc03jBfNFe7z2C+EO2g==
X-Received: by 2002:a17:902:b193:b0:19a:a815:2876 with SMTP id s19-20020a170902b19300b0019aa8152876mr22021968plr.62.1678448048257;
        Fri, 10 Mar 2023 03:34:08 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id a17-20020a170902b59100b00198fde9178csm1242857pls.197.2023.03.10.03.34.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 03:34:07 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: x86/pmu/misc: Fix a typo on kvm_pmu_request_counter_reprogam()
Date:   Fri, 10 Mar 2023 19:33:49 +0800
Message-Id: <20230310113349.31799-1-likexu@tencent.com>
X-Mailer: git-send-email 2.39.2
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

Fix a "reprogam" typo in the kvm_pmu_request_counter_reprogam(), which
should be fixed earlier to follow the meaning of {pmc_}reprogram_counter().

Fixes: 68fb4757e867 ("KVM: x86/pmu: Defer reprogram_counter() to kvm_pmu_handle_event()")
Signed-off-by: Like Xu <likexu@tencent.com>
---
v1: https://lore.kernel.org/all/20230308104707.27284-1-likexu@tencent.com
 arch/x86/kvm/pmu.c           | 2 +-
 arch/x86/kvm/pmu.h           | 2 +-
 arch/x86/kvm/svm/pmu.c       | 2 +-
 arch/x86/kvm/vmx/pmu_intel.c | 6 +++---
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 7b6c3ba2c8e1..bdeec0ab5e2b 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -646,7 +646,7 @@ static void kvm_pmu_incr_counter(struct kvm_pmc *pmc)
 {
 	pmc->prev_counter = pmc->counter;
 	pmc->counter = (pmc->counter + 1) & pmc_bitmask(pmc);
-	kvm_pmu_request_counter_reprogam(pmc);
+	kvm_pmu_request_counter_reprogram(pmc);
 }
 
 static inline bool eventsel_match_perf_hw_id(struct kvm_pmc *pmc,
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 79988dafb15b..cff0651b030b 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -183,7 +183,7 @@ static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
 					     KVM_PMC_MAX_FIXED);
 }
 
-static inline void kvm_pmu_request_counter_reprogam(struct kvm_pmc *pmc)
+static inline void kvm_pmu_request_counter_reprogram(struct kvm_pmc *pmc)
 {
 	set_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi);
 	kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index cc77a0681800..5fa939e411d8 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -161,7 +161,7 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		data &= ~pmu->reserved_bits;
 		if (data != pmc->eventsel) {
 			pmc->eventsel = data;
-			kvm_pmu_request_counter_reprogam(pmc);
+			kvm_pmu_request_counter_reprogram(pmc);
 		}
 		return 0;
 	}
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index e8a3be0b9df9..797fff9dbe80 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -57,7 +57,7 @@ static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
 		pmc = get_fixed_pmc(pmu, MSR_CORE_PERF_FIXED_CTR0 + i);
 
 		__set_bit(INTEL_PMC_IDX_FIXED + i, pmu->pmc_in_use);
-		kvm_pmu_request_counter_reprogam(pmc);
+		kvm_pmu_request_counter_reprogram(pmc);
 	}
 }
 
@@ -81,7 +81,7 @@ static void reprogram_counters(struct kvm_pmu *pmu, u64 diff)
 	for_each_set_bit(bit, (unsigned long *)&diff, X86_PMC_IDX_MAX) {
 		pmc = intel_pmc_idx_to_pmc(pmu, bit);
 		if (pmc)
-			kvm_pmu_request_counter_reprogam(pmc);
+			kvm_pmu_request_counter_reprogram(pmc);
 	}
 }
 
@@ -482,7 +482,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 				reserved_bits ^= HSW_IN_TX_CHECKPOINTED;
 			if (!(data & reserved_bits)) {
 				pmc->eventsel = data;
-				kvm_pmu_request_counter_reprogam(pmc);
+				kvm_pmu_request_counter_reprogram(pmc);
 				return 0;
 			}
 		} else if (intel_pmu_handle_lbr_msrs_access(vcpu, msr_info, false))

base-commit: 13738a3647368f7f600b30d241779bcd2a3ebbfd
-- 
2.39.2

