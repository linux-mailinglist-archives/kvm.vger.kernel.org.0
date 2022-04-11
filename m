Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6317E4FB966
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 12:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345357AbiDKKYa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 06:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345483AbiDKKWs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 06:22:48 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E28040A17;
        Mon, 11 Apr 2022 03:20:32 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id p25so7463621pfn.13;
        Mon, 11 Apr 2022 03:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XPwt8sGod7zPq0cTkkL/MnhWtC0l3QC4vFa0Zg+Ea+E=;
        b=c/fA6Q9EuU4ofYYxy79GJYlvLXT8ykwtiA/LrXPGlWubjmYLzm14ZODjef+/HFzewP
         c3m5daV5trxi1SWgrC8rouV1rYp//gVFSw67Q4b/G/XBawK2hGGLFYYJ1VvmW7rJJN6X
         vD/yCH2I9BfcUyZfHa9ElFDLmGMECz8BQZmdH0MmQUcCQmowUbEzLGta9sj8BeWQx1IZ
         FDBUnLAiMUuKzOFg+Y9L6Fxe7p05fQ5dQ7bl+UllZTVwah20R9BtObN1o15fVg8MONsm
         UR6Y69cASB6mJ+QtHvvQqhcyuaobioaf1cwUwdHr1STb5qbaQamCAd7axso0W/n9OQ+g
         Glrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XPwt8sGod7zPq0cTkkL/MnhWtC0l3QC4vFa0Zg+Ea+E=;
        b=a9frOXmGNNFeAYwZzIgElkxmiOzxNV+Bcnvnsyg2LGCL1NItqwYc4ZIv7i2xEge/0i
         +aXNZo3vfb4sItEaY+jH5I2vuCzkPGgoTJEPy6WlJJ9+J9l5bfGmcKYh6HMbrQwIn7qN
         CgUmdh8ThShgqL5l0Ie4D63a4s9v1MdyuYcIKZRVysGPRdS87X/I1FVAc+G8CnBMbtJ2
         xJNXXhBqK9Ahsqd3igh8yBZ4nXIpmQA8YkY56KgeszhJLU/edaCVV1SvVnZ47qp7a6Oa
         suYIGrgv9cp4nvt9KnjtcCGst9AqG3EUiYJgydm0kpetxKIFPFvaMIQmHLA/+qhUt1IH
         YgSg==
X-Gm-Message-State: AOAM533JFi0S8tSX1dO+/FJ07dDgAVnIciQV6BEUupU5qFXkgGo4W+S4
        hlKIlhevEC4iLjAmqxLb0HM=
X-Google-Smtp-Source: ABdhPJxQDPKgR0zGDRMxI8sWUu0g3w4WOwnsewfVr5s5E0e4ZXNfIV4MFQDzHg+xFLNtviou/+x2oQ==
X-Received: by 2002:a63:195f:0:b0:399:1f0e:a21d with SMTP id 31-20020a63195f000000b003991f0ea21dmr25580971pgz.393.1649672432192;
        Mon, 11 Apr 2022 03:20:32 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.112])
        by smtp.gmail.com with ESMTPSA id h10-20020a056a00230a00b004faa0f67c3esm34012280pfh.23.2022.04.11.03.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 03:20:32 -0700 (PDT)
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
Subject: [PATCH RESEND v12 13/17] KVM: x86/pmu: Move pmc_speculative_in_use() to arch/x86/kvm/pmu.h
Date:   Mon, 11 Apr 2022 18:19:42 +0800
Message-Id: <20220411101946.20262-14-likexu@tencent.com>
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

It allows this inline function to be reused by more callers in
more files, such as pmu_intel.c.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/kvm/pmu.c | 11 -----------
 arch/x86/kvm/pmu.h | 11 +++++++++++
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index c1312cd32237..122e4bb4fa47 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -500,17 +500,6 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
 	kvm_pmu_refresh(vcpu);
 }
 
-static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
-{
-	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
-
-	if (pmc_is_fixed(pmc))
-		return fixed_ctrl_field(pmu->fixed_ctr_ctrl,
-			pmc->idx - INTEL_PMC_IDX_FIXED) & 0x3;
-
-	return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
-}
-
 /* Release perf_events for vPMCs that have been unused for a full time slice.  */
 void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 06e750824da1..b51f804737bd 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -143,6 +143,17 @@ static inline u64 get_sample_period(struct kvm_pmc *pmc, u64 counter_value)
 	return sample_period;
 }
 
+static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
+{
+	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
+
+	if (pmc_is_fixed(pmc))
+		return fixed_ctrl_field(pmu->fixed_ctr_ctrl,
+					pmc->idx - INTEL_PMC_IDX_FIXED) & 0x3;
+
+	return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
+}
+
 void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel);
 void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int fixed_idx);
 void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx);
-- 
2.35.1

