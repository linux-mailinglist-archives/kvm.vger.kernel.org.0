Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5960248D124
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 04:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232391AbiAMDxk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 22:53:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232386AbiAMDxf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 22:53:35 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD4EC061748;
        Wed, 12 Jan 2022 19:53:35 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id c3so7654856pls.5;
        Wed, 12 Jan 2022 19:53:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TAgI2TJU7veYy/9IG8eVZWWNyX9wqETK8RiqzSJm0IY=;
        b=X2wBkSxnrzOdE7uTE3O3YWW8AkKnt7wtS3LaqkwsgKc4W/er6LBQG2m7SSEhENUB9b
         B/ZeYOauL/vOZvD7eLsGylDzthX43II7t+zEIVTL4rP9Zuh3qwQ5MdfvdNoXwbm40u7S
         5ZRZJfHa3J1OxbdppCMea/qffcefjtYpPdFMKIiC8auS4dkRUYRnykXyVsuTn2Jt0YZo
         1tnytyqHljP2D7Rdy8tmybHkQh5EvKICqs/4ju627E7HpyJfEjv0mxgxtSyu7Uc77mLo
         xErjNmW1HBqFNel8mz82+6xBrMazxG+6JsS5XimxTC6R/qAT0pXNP4Tgxlgblu04KlaJ
         POEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TAgI2TJU7veYy/9IG8eVZWWNyX9wqETK8RiqzSJm0IY=;
        b=BdgC7rMAnu6kMpUxPnNp9W0irJgYiVyRb/ab85vlM5ayNgL0XDAeqBUxDMl6YDWQNG
         MB5DsahQjLkLLREW1umufjlJaTJQJfLnB33Kwj43Nv+smE+vAqv5kkZVnMQB3K9KPOcM
         Ymh/4/YC+Flq4B2FcfpMqwwYvIhRdZtHXLfbAS4pUA84JkQTAE7P/k/DkuzqcO4McHZY
         +ClCziGRFFoZ40Pb58vhaTPEgS8OIMNwJwmf0lw1X8XuWCNXtOKDs28JQ4ISqFCWoN04
         2mCaPz+MTecDinNJ9tj25lzSMy87/1XResgisDAZ1v6CYNA3eQGLRM4MS3beb6StanVt
         UFmA==
X-Gm-Message-State: AOAM5317Y1p1gEvZU8FkYRJvjT3xlWJC9sN4kSRpKXV+AUxJUcYyG86S
        dliExgSQRg/M7gP/DWNx8KEY1mLgeoIk2hi1WoE3Ig==
X-Google-Smtp-Source: ABdhPJwRblKo/oNfvblTbqD45RoQA7n6JrbDO/3RI0w0eBl/hKZM4zRL/w1KYXm4NVhp7tgbJ4G2+g==
X-Received: by 2002:a17:902:ea85:b0:14a:3c49:f140 with SMTP id x5-20020a170902ea8500b0014a3c49f140mr2516213plb.31.1642046014882;
        Wed, 12 Jan 2022 19:53:34 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id o11sm912745pgk.36.2022.01.12.19.53.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 19:53:34 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] KVM: x86: Make the module parameter of vPMU more common
Date:   Thu, 13 Jan 2022 11:53:24 +0800
Message-Id: <20220113035324.59572-1-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

The new module parameter to control PMU virtualization should apply
to Intel as well as AMD, for situations where userspace is not trusted.
If the module parameter allows PMU virtualization, there could be a
new KVM_CAP or guest CPUID bits whereby userspace can enable/disable
PMU virtualization on a per-VM basis.

If the module parameter does not allow PMU virtualization, there
should be no userspace override, since we have no precedent for
authorizing that kind of override. If it's false, other counter-based
profiling features (such as LBR including the associated CPUID bits
if any) will not be exposed.

The module_param_named() is used so that KVM can use "enable_pmu"
for all its checks, but the user only needs to type "pmu=?" when
manipulating the module param.

Fixes: b1d66dad65dc ("KVM: x86/svm: Add module param to control PMU virtualization")
Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
v2 -> v3 Changelog:
- Use module_param_named() for the use of both enable_pmu and pmu; (Sean)

Previous:
https://lore.kernel.org/kvm/20220112040116.23937-1-likexu@tencent.com/

 arch/x86/kvm/cpuid.c            | 6 +++---
 arch/x86/kvm/pmu.c              | 5 +++++
 arch/x86/kvm/pmu.h              | 1 +
 arch/x86/kvm/svm/pmu.c          | 2 +-
 arch/x86/kvm/svm/svm.c          | 8 ++------
 arch/x86/kvm/svm/svm.h          | 1 -
 arch/x86/kvm/vmx/capabilities.h | 4 ++++
 arch/x86/kvm/vmx/pmu_intel.c    | 2 +-
 8 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0b920e12bb6d..4ac7172478a0 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -770,10 +770,10 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		perf_get_x86_pmu_capability(&cap);
 
 		/*
-		 * Only support guest architectural pmu on a host
-		 * with architectural pmu.
+		 * The guest architecture pmu is only supported if the architecture
+		 * pmu exists on the host and the module parameters allow it.
 		 */
-		if (!cap.version)
+		if (!enable_pmu || !cap.version)
 			memset(&cap, 0, sizeof(cap));
 
 		eax.split.version_id = min(cap.version, 2);
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index e632693a2266..03e6a24dd8cb 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -19,6 +19,11 @@
 #include "lapic.h"
 #include "pmu.h"
 
+/* Enable/disable PMU virtualization */
+bool __read_mostly enable_pmu = true;
+EXPORT_SYMBOL_GPL(enable_pmu);
+module_param_named(pmu, enable_pmu, bool, 0444);
+
 /* This is enough to filter the vast majority of currently defined events. */
 #define KVM_PMU_EVENT_FILTER_MAX_EVENTS 300
 
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 7a7b8d5b775e..46df3d58784b 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -163,4 +163,5 @@ bool is_vmware_backdoor_pmc(u32 pmc_idx);
 
 extern struct kvm_pmu_ops intel_pmu_ops;
 extern struct kvm_pmu_ops amd_pmu_ops;
+extern bool enable_pmu;
 #endif /* __KVM_X86_PMU_H */
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 12d8b301065a..5aa45f13b16d 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -101,7 +101,7 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
 {
 	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
 
-	if (!pmu)
+	if (!enable_pmu)
 		return NULL;
 
 	switch (msr) {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6cb38044a860..549f73ce5ebc 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -192,10 +192,6 @@ module_param(vgif, int, 0444);
 static int lbrv = true;
 module_param(lbrv, int, 0444);
 
-/* enable/disable PMU virtualization */
-bool pmu = true;
-module_param(pmu, bool, 0444);
-
 static int tsc_scaling = true;
 module_param(tsc_scaling, int, 0444);
 
@@ -4573,7 +4569,7 @@ static __init void svm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
 
 	/* AMD PMU PERFCTR_CORE CPUID */
-	if (pmu && boot_cpu_has(X86_FEATURE_PERFCTR_CORE))
+	if (enable_pmu && boot_cpu_has(X86_FEATURE_PERFCTR_CORE))
 		kvm_cpu_cap_set(X86_FEATURE_PERFCTR_CORE);
 
 	/* CPUID 0x8000001F (SME/SEV features) */
@@ -4712,7 +4708,7 @@ static __init int svm_hardware_setup(void)
 			pr_info("LBR virtualization supported\n");
 	}
 
-	if (!pmu)
+	if (!enable_pmu)
 		pr_info("PMU virtualization is disabled\n");
 
 	svm_set_cpu_caps();
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index daa8ca84afcc..47ef8f4a9358 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -32,7 +32,6 @@
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
 extern bool intercept_smi;
-extern bool pmu;
 
 /*
  * Clean bits in VMCB.
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index c8029b7845b6..401c48000a48 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -5,6 +5,7 @@
 #include <asm/vmx.h>
 
 #include "lapic.h"
+#include "pmu.h"
 
 extern bool __read_mostly enable_vpid;
 extern bool __read_mostly flexpriority_enabled;
@@ -389,6 +390,9 @@ static inline u64 vmx_get_perf_capabilities(void)
 {
 	u64 perf_cap = 0;
 
+	if (!enable_pmu)
+		return perf_cap;
+
 	if (boot_cpu_has(X86_FEATURE_PDCM))
 		rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_cap);
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index ffccfd9823c0..f3656b95cd2f 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -487,7 +487,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->reserved_bits = 0xffffffff00200000ull;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
-	if (!entry)
+	if (!enable_pmu || !entry)
 		return;
 	eax.full = entry->eax;
 	edx.full = entry->edx;
-- 
2.33.1

