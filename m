Return-Path: <kvm+bounces-537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F5417E0BDC
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 00:06:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C0AD81C210FD
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 23:06:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F96B25110;
	Fri,  3 Nov 2023 23:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gueaNZV7"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B848250F0
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 23:05:49 +0000 (UTC)
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B542D65
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 16:05:48 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1cc252cbde2so18218985ad.0
        for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 16:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699052747; x=1699657547; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=MBBm7FlqrdtgkBqnXXMbaJMJAl32htix/RXmITDIFAI=;
        b=gueaNZV7Vxljy9Q/ZB6efChaUm6uV0JEKE+GkSzYs0C+5Hb2jInuMrWqWStXtvCpsj
         FIV/nOkF+TaLyFtofsUQCUscJw5TWNJNazwdeKTjzT2uXcYc+MX3n3tEFjW7UjyLeDlz
         Ba8/sno1/y4NA59qibyaIZ+4UY8/vZYJarUESnE6yZqKgb2vf8hyojXbDWS6AHyWhC93
         LT/QK7GJu/AenrGm6vl7rj7+wTbnMpLxej/hVdg84XSyGDUmeGfFgJYzFj24pvf086VK
         lHwNygVS9lQhMIRSH7iRAJk1JVnweIZ0Ct6vhTW1LxUHGPH7mEESHAuQX4PP/BCMZCcU
         K91Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699052747; x=1699657547;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MBBm7FlqrdtgkBqnXXMbaJMJAl32htix/RXmITDIFAI=;
        b=a9YKCLECsAZnS5Y3nw3QfcNJIbLs3SX4ehby3hm7Zq3ClxE4ZsNaTlM73RzJKxaRWq
         nAuExj9ToyW97IjoVd6MMJ3xzDZscLSqsoTO17Vw4BVeGGJZoi/FzI2qFWg+P9LCEhKK
         ScaQpaTtCWmELlJfai/7MTOrLbi8S42NeYn0OWPPAs9h6lqvAPERwxB8KP1Y+L7x08R6
         7XNrnGEyMNNpVKTt9Gcz0GgxpiuOw7ijKLlFjvKuyXS5+K4yBzVppTpR3MuCC71yak+I
         2FDvTVYF7/zkdEHOzeBJ67RvTGDn7Da6z32Z6KNCtCP5x+rAvkiV0vv1QMNjBk9LKV/I
         R12A==
X-Gm-Message-State: AOJu0YwaSTJGLkBixXBH6v1ilGAkgqiTpH0sPlBhN7N5YJTzleaKK71M
	BeqEvIOB9jO4EpQopn7Ru9Ymq5vBu7E=
X-Google-Smtp-Source: AGHT+IFxtJq6aoqhiA8nBzG/BJYd7WTpHjuZTRpBVdCBHzeUugR2TSdZ06fuNypYZHlYf/ldSoVRa3HYNVE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:3303:b0:1cc:38e0:dbab with SMTP id
 jk3-20020a170903330300b001cc38e0dbabmr336922plb.3.1699052747477; Fri, 03 Nov
 2023 16:05:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  3 Nov 2023 16:05:37 -0700
In-Reply-To: <20231103230541.352265-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231103230541.352265-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231103230541.352265-3-seanjc@google.com>
Subject: [PATCH v2 2/6] KVM: x86/pmu: Reset the PMU, i.e. stop counters,
 before refreshing
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Mingwei Zhang <mizhang@google.com>, 
	Roman Kagan <rkagan@amazon.de>, Jim Mattson <jmattson@google.com>, 
	Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Stop all counters and release all perf events before refreshing the vPMU,
i.e. before reconfiguring the vPMU to respond to changes in the vCPU
model.

Clear need_cleanup in kvm_pmu_reset() as well so that KVM doesn't
prematurely stop counters, e.g. if KVM enters the guest and enables
counters before the vCPU is scheduled out.

Cc: stable@vger.kernel.org
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c | 35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 027e9c3c2b93..dc8e8e907cfb 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -657,25 +657,14 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	return 0;
 }
 
-/* refresh PMU settings. This function generally is called when underlying
- * settings are changed (such as changes of PMU CPUID by guest VMs), which
- * should rarely happen.
- */
-void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
-{
-	if (KVM_BUG_ON(kvm_vcpu_has_run(vcpu), vcpu->kvm))
-		return;
-
-	bitmap_zero(vcpu_to_pmu(vcpu)->all_valid_pmc_idx, X86_PMC_IDX_MAX);
-	static_call(kvm_x86_pmu_refresh)(vcpu);
-}
-
 void kvm_pmu_reset(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct kvm_pmc *pmc;
 	int i;
 
+	pmu->need_cleanup = false;
+
 	bitmap_zero(pmu->reprogram_pmi, X86_PMC_IDX_MAX);
 
 	for_each_set_bit(i, pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX) {
@@ -695,6 +684,26 @@ void kvm_pmu_reset(struct kvm_vcpu *vcpu)
 	static_call_cond(kvm_x86_pmu_reset)(vcpu);
 }
 
+
+/*
+ * Refresh the PMU configuration for the vCPU, e.g. if userspace changes CPUID
+ * and/or PERF_CAPABILITIES.
+ */
+void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
+{
+	if (KVM_BUG_ON(kvm_vcpu_has_run(vcpu), vcpu->kvm))
+		return;
+
+	/*
+	 * Stop/release all existing counters/events before realizing the new
+	 * vPMU model.
+	 */
+	kvm_pmu_reset(vcpu);
+
+	bitmap_zero(vcpu_to_pmu(vcpu)->all_valid_pmc_idx, X86_PMC_IDX_MAX);
+	static_call(kvm_x86_pmu_refresh)(vcpu);
+}
+
 void kvm_pmu_init(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-- 
2.42.0.869.gea05f2083d-goog


