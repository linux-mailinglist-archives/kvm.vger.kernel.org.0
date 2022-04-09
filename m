Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEE34FA16A
	for <lists+kvm@lfdr.de>; Sat,  9 Apr 2022 03:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbiDIBym (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 21:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiDIByk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 21:54:40 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6697836233C;
        Fri,  8 Apr 2022 18:52:33 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id f10so9398071plr.6;
        Fri, 08 Apr 2022 18:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RjihL0uHY+RkFPan2lJsu4yZo9/HaqGSbiMBNVKtTG4=;
        b=GpskndQDEpfP4T4ZxzoL2TF0xW2Td/y88vlchAQ5Eq2FAnUFqDuvScba9UXf6Dw/DD
         gbB9tyExh6a2sM4gSCaGxcOyz2Wjb0A5rbgiaKRQ2Z2JfyqSYoEhqOtskMgTP1oGtBh3
         AJvsxnMkbi3rs05Gffa47SuWlKlwS2v5Oj4pgBTinDIFtpGpclgyrT4VlwbAsSkT3kvD
         uWZ8YdJdOKjepBtUOV2EEfUF9T6XoQKoduwIVhTEGHw5EuBLt32DRh7WbAoeVmEJhQJ+
         kCJNwUNNNrzdCegxA84ROE/svU9SRmAbXDRn1ZzoZTEVqNPGmtMdbHaRF25N9AiUQDGv
         Eq/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RjihL0uHY+RkFPan2lJsu4yZo9/HaqGSbiMBNVKtTG4=;
        b=H3wjZlXSAPLitif1ZSxd+Wti4EM7e4wKTIa0TVvEGYQgc7Ouyy17a3bVo15t/2wva4
         2sT/n5/4L7Ymg346prjri5i3b+DvZcI2JRH2qfur2WvFJmTCp288K2pewof/syxA9Z52
         PQGPg4o+XdJ+RtL3+e2OsBo5m7EqZvgZUjqlZ3D8qS7uM9UdltlA+JEzba7bzd3LJiPx
         qhgYg22c/+Z4SNpVm8DqhLfHZOPUeildZBpmUgd+BhQpv36l2KNlSfeSJPSdltM9NrYF
         JGBXtHw8Vp70QE0f3SGPcGo3j41jYZLOOFTPzU5RcHObDibeNqo53eGl/Fq4SLiEBtPC
         +Bcg==
X-Gm-Message-State: AOAM531KescsXgxTg6GH2PaslpxnX4SeYRHj14ZGSsZm1vu+h2DsEdz4
        EonjTjzaWuh5C1JpHs0pHQI=
X-Google-Smtp-Source: ABdhPJwV6iG+YcngTQe+cOKTKlzEVRa1//IpPQ+pskMgjGBlnLBI40gQA9tKtNKoMbko6e6mAaMFXw==
X-Received: by 2002:a17:90b:3889:b0:1c7:a31f:2a50 with SMTP id mu9-20020a17090b388900b001c7a31f2a50mr25031747pjb.193.1649469152888;
        Fri, 08 Apr 2022 18:52:32 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.115])
        by smtp.gmail.com with ESMTPSA id f6-20020a056a00238600b004fae79a3cbfsm28946172pfc.100.2022.04.08.18.52.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 18:52:32 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Dongli Cao <caodongli@kingsoft.com>,
        Eric Hankland <ehankland@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] KVM: x86/pmu: Update AMD PMC sample period to fix guest NMI-watchdog
Date:   Sat,  9 Apr 2022 09:52:26 +0800
Message-Id: <20220409015226.38619-1-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
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

NMI-watchdog is one of the favorite features of kernel developers,
but it does not work in AMD guest even with vPMU enabled and worse,
the system misrepresents this capability via /proc.

This is a PMC emulation error. KVM does not pass the latest valid
value to perf_event in time when guest NMI-watchdog is running, thus
the perf_event corresponding to the watchdog counter will enter the
old state at some point after the first guest NMI injection, forcing
the hardware register PMC0 to be constantly written to 0x800000000001.

Meanwhile, the running counter should accurately reflect its new value
based on the latest coordinated pmc->counter (from vPMC's point of view)
rather than the value written directly by the guest.

Fixes: 168d918f2643 ("KVM: x86: Adjust counter sample period after a wrmsr")
Reported-by: Dongli Cao <caodongli@kingsoft.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Reviewed-by: Yanan Wang <wangyanan55@huawei.com>
Tested-by: Yanan Wang <wangyanan55@huawei.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/pmu.h           | 9 +++++++++
 arch/x86/kvm/svm/pmu.c       | 1 +
 arch/x86/kvm/vmx/pmu_intel.c | 8 ++------
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 2a53b6c9495c..e745f443b6a8 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -135,6 +135,15 @@ static inline u64 get_sample_period(struct kvm_pmc *pmc, u64 counter_value)
 	return sample_period;
 }
 
+static inline void pmc_update_sample_period(struct kvm_pmc *pmc)
+{
+	if (!pmc->perf_event || pmc->is_paused)
+		return;
+
+	perf_event_period(pmc->perf_event,
+			  get_sample_period(pmc, pmc->counter));
+}
+
 void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel);
 void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int fixed_idx);
 void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx);
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 57ab4739eb19..79af9a93aab7 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -257,6 +257,7 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	pmc = get_gp_pmc_amd(pmu, msr, PMU_TYPE_COUNTER);
 	if (pmc) {
 		pmc->counter += data - pmc_read_counter(pmc);
+		pmc_update_sample_period(pmc);
 		return 0;
 	}
 	/* MSR_EVNTSELn */
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 9db662399487..37e9eb32e3d9 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -431,15 +431,11 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			    !(msr & MSR_PMC_FULL_WIDTH_BIT))
 				data = (s64)(s32)data;
 			pmc->counter += data - pmc_read_counter(pmc);
-			if (pmc->perf_event && !pmc->is_paused)
-				perf_event_period(pmc->perf_event,
-						  get_sample_period(pmc, data));
+			pmc_update_sample_period(pmc);
 			return 0;
 		} else if ((pmc = get_fixed_pmc(pmu, msr))) {
 			pmc->counter += data - pmc_read_counter(pmc);
-			if (pmc->perf_event && !pmc->is_paused)
-				perf_event_period(pmc->perf_event,
-						  get_sample_period(pmc, data));
+			pmc_update_sample_period(pmc);
 			return 0;
 		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
 			if (data == pmc->eventsel)
-- 
2.35.1

