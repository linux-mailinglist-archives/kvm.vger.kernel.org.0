Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9DB6B04EA
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 11:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbjCHKr3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 05:47:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbjCHKr1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 05:47:27 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4C8AB0BC;
        Wed,  8 Mar 2023 02:47:25 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id qa18-20020a17090b4fd200b0023750b675f5so1835634pjb.3;
        Wed, 08 Mar 2023 02:47:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678272445;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rbWmFnTKQlbCc6ADUzUn6/K5znBMlvjFmo8cpVLeLXo=;
        b=n51BtufHJPWng+b5UZvMOjHuv8IZMz9vNVrd44/CHFxzZIFd3sVpc6dqRzZyyLO0KV
         vUjAQKYvmbf/zHDew5hpobeGl1cosr2UKDGDCRKWHY/Q3CqoQlHOVvxGajpMjcKOb8Lq
         nAA7bJrgmko+IAKeznlhuVwaUmqs+4cl+lEd8P0XRQcL7YJIYd6qEC9kTNDUo+dAp1Sf
         O73A8FXZxXovn/6JZ3nNN9JY6D1VGSjmyI7oecN/u5Hb+DsYU7B49NFt5MvnG0fHUK0R
         GOWSfeCxS1mM5TQlzZoZYfW2PF5PEOeKaq8xieJByy+oj/W81JJQaRYdujdAgf7pR86j
         k9pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678272445;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rbWmFnTKQlbCc6ADUzUn6/K5znBMlvjFmo8cpVLeLXo=;
        b=lTalPq4VBxOOh2eESo4woPUjR2H5wUB2bEV4HzSZvlK/IFamWWhKuMR9VynDO92qRN
         NHk1hFMimfJZzZaFi7O9RWBTMY8PbSWw/QVcLNmriolkHDH8d1Hcpme6e1SDMlApmLZH
         BOjyWDusF9bkQHwMgsB7EsvbmRbizXkOchSHLRwuDRoTYnAw3xkkH172yzDHatVQOSce
         9JbH8EOC6uNfWJlkToNInKl+fZxU3YZWWT6ZaynRhRfaegV6l/czm19ki8QFpzPEo+wK
         4VQMavXYSkx9NBhs43uya4t0uXi7qwLoX29L8BaG+VkBBk+trOJe9cQs3gaK2kNRHeNo
         t84Q==
X-Gm-Message-State: AO0yUKX1Of5NyFf8+FD8bJzIWwOYbX6Lg2LOo1LDnXQU70HiDARxJFXD
        hO/gtm8p/qCvKq3l1byFA5Y=
X-Google-Smtp-Source: AK7set+UQsgNFsZLbqft3dB8bKLzGWM6QMRLqT/O6cQIt6zOlPRA2UxOsnH1iH3huxdxVLego6KzxQ==
X-Received: by 2002:a17:90a:1942:b0:233:e9a7:209e with SMTP id 2-20020a17090a194200b00233e9a7209emr18360372pjh.28.1678272445217;
        Wed, 08 Mar 2023 02:47:25 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 15-20020a17090a0f0f00b002310ed024adsm8164783pjy.12.2023.03.08.02.47.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 02:47:24 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/pmu/misc: Fix a typo on kvm_pmu_request_counter_reprogam()
Date:   Wed,  8 Mar 2023 18:47:07 +0800
Message-Id: <20230308104707.27284-1-likexu@tencent.com>
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

The typo first appeared in the comments [*], then smoothly escaped the
eyes of the developer and survived multiple iterations. Now we had to
regretfully append a minor follow-up fix, which pollutes our Git history.

[*] Yw5N+eGfOsCgtHpw@google.com

Signed-off-by: Like Xu <likexu@tencent.com>
---
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

