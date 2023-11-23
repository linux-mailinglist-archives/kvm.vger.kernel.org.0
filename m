Return-Path: <kvm+bounces-2378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F04EF7F664F
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 19:36:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5BA88B21605
	for <lists+kvm@lfdr.de>; Thu, 23 Nov 2023 18:36:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57C954B5DE;
	Thu, 23 Nov 2023 18:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="maypWj+j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC8ED7F
	for <kvm@vger.kernel.org>; Thu, 23 Nov 2023 10:36:12 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-332ce50450dso741801f8f.1
        for <kvm@vger.kernel.org>; Thu, 23 Nov 2023 10:36:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1700764570; x=1701369370; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OSjIUExNNTZZyxxju0j+hfpNF1ayVJnEfjEBE24u3Js=;
        b=maypWj+jCI8QOcisbWlycpw9eP27PfEcCwmGMz5iAipvwOv2ti6MNFLxFzSSia6vEU
         XduogVFqrzRHf5PeWSkFoo4yRUi+KTl1pFNpZpD5t2HJn1uDX7YCk6Y9zRzZReZefmOZ
         KYTO1bBd+x90CO8h4VfyyBSV/sq3KS+HK/dpDr5NEb2+vzTc/SIQaxt8seAi3yZYK4kY
         2qBKj8bsdkD88ikp9G4snQXFCHlLWRmryjzAs0nF4dzKkF7cSErmF1Ns6lK2OS4Ti0wV
         vid0pb/tFccYnTIcUrVAAA+Szx8naz0AoB9u6CSgFkl2i8qRJXVmfWBuTFBDxuN9ycjl
         +iCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700764570; x=1701369370;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OSjIUExNNTZZyxxju0j+hfpNF1ayVJnEfjEBE24u3Js=;
        b=WoJC11zO0vl+W0x3EI3BSeuLnRsGojt619AG1+v7aYPAD8kzpzODhObFnaFeZYgi/W
         +y9zv1rZqOBn+Js7CwG4XIbKtvVZHZBhLbF6BuTR9u053X/eG0W7JutBvGFUgWK+dVSR
         T8MhqZPrHSW0d1S8gxuk/xQcpuiVnBPnIY5bNjaXgyqer3W7iYEIveSKp7x8cPljSI5L
         MgYaawzxj+jwMOKwwY3WWJnk/s1CKdV46brwqW0w+Vlf9CJ058Oes/HIml9uFPeB5mAR
         5ZHpxlVofk2bmfyOF4PH6gQlLN8XzJ4WBFtdzBtFOKkuuqABoIfCWMHyScfCfI33xNAC
         /cIA==
X-Gm-Message-State: AOJu0Yw9l94Af23WB5oOS7uK98puezQR9UABDstnVARGd+mSG0gSMYQZ
	XFEwyogX/vm1RVUxXnjWfmMD0w==
X-Google-Smtp-Source: AGHT+IFgzxS1rMr+4vJyVHw8yTL7+XlGZ+6k9Z3h/Y0p6Y8WoWsGCe6GudKC213LdZDrUfDjX2soLA==
X-Received: by 2002:a5d:6152:0:b0:332:e75e:f39a with SMTP id y18-20020a5d6152000000b00332e75ef39amr228741wrt.35.1700764570576;
        Thu, 23 Nov 2023 10:36:10 -0800 (PST)
Received: from m1x-phil.lan ([176.176.165.237])
        by smtp.gmail.com with ESMTPSA id n8-20020a5d67c8000000b00332e84210c2sm259285wrw.88.2023.11.23.10.36.09
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 23 Nov 2023 10:36:10 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH-for-9.0 09/16] target/arm/kvm: Have kvm_arm_pmu_set_irq take a ARMCPU argument
Date: Thu, 23 Nov 2023 19:35:10 +0100
Message-ID: <20231123183518.64569-10-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231123183518.64569-1-philmd@linaro.org>
References: <20231123183518.64569-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Unify the "kvm_arm.h" API: All functions related to ARM vCPUs
take a ARMCPU* argument. Use the CPU() QOM cast macro When
calling the generic vCPU API from "sysemu/kvm.h".

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/arm/kvm_arm.h | 4 ++--
 hw/arm/virt.c        | 2 +-
 target/arm/kvm.c     | 6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index fde1c45609..55fcc35ed7 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -201,7 +201,7 @@ int kvm_arm_get_max_vm_ipa_size(MachineState *ms, bool *fixed_ipa);
 int kvm_arm_vgic_probe(void);
 
 void kvm_arm_pmu_init(ARMCPU *cpu);
-void kvm_arm_pmu_set_irq(CPUState *cs, int irq);
+void kvm_arm_pmu_set_irq(ARMCPU *cpu, int irq);
 
 /**
  * kvm_arm_pvtime_init:
@@ -258,7 +258,7 @@ static inline int kvm_arm_vgic_probe(void)
     g_assert_not_reached();
 }
 
-static inline void kvm_arm_pmu_set_irq(CPUState *cs, int irq)
+static inline void kvm_arm_pmu_set_irq(ARMCPU *cpu, int irq)
 {
     g_assert_not_reached();
 }
diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 63f3c0b750..040ca2d794 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -1998,7 +1998,7 @@ static void virt_cpu_post_init(VirtMachineState *vms, MemoryRegion *sysmem)
             if (pmu) {
                 assert(arm_feature(&ARM_CPU(cpu)->env, ARM_FEATURE_PMU));
                 if (kvm_irqchip_in_kernel()) {
-                    kvm_arm_pmu_set_irq(cpu, VIRTUAL_PMU_IRQ);
+                    kvm_arm_pmu_set_irq(ARM_CPU(cpu), VIRTUAL_PMU_IRQ);
                 }
                 kvm_arm_pmu_init(ARM_CPU(cpu));
             }
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index e7cbe1ff05..f17e706e48 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1727,7 +1727,7 @@ void kvm_arm_pmu_init(ARMCPU *cpu)
     }
 }
 
-void kvm_arm_pmu_set_irq(CPUState *cs, int irq)
+void kvm_arm_pmu_set_irq(ARMCPU *cpu, int irq)
 {
     struct kvm_device_attr attr = {
         .group = KVM_ARM_VCPU_PMU_V3_CTRL,
@@ -1735,10 +1735,10 @@ void kvm_arm_pmu_set_irq(CPUState *cs, int irq)
         .attr = KVM_ARM_VCPU_PMU_V3_IRQ,
     };
 
-    if (!ARM_CPU(cs)->has_pmu) {
+    if (!cpu->has_pmu) {
         return;
     }
-    if (!kvm_arm_set_device_attr(ARM_CPU(cs), &attr, "PMU")) {
+    if (!kvm_arm_set_device_attr(cpu, &attr, "PMU")) {
         error_report("failed to set irq for PMU");
         abort();
     }
-- 
2.41.0


