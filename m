Return-Path: <kvm+bounces-679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53AF27E1F42
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:05:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 774DD1C20B7A
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:05:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 563E418E24;
	Mon,  6 Nov 2023 11:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UE9FceSP"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C3A18B0C
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:04:52 +0000 (UTC)
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A646AC6
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:04:50 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-40839652b97so32700295e9.3
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:04:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268689; x=1699873489; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5wOkrsA8z2Hole9awlJYsNuk4oh7gPmhIjtphAMJsw8=;
        b=UE9FceSPlDMJk7CZToEJXS87GfXMmOG3kbFD9fAAg/A+oGcelQRpbFg7rjagIs4K0i
         b3tmhol6+seysAXNM2H+10oFjuqWk+laVF/Qq3etBjYynBovtq7nDlM3he6uS4w7Xn5D
         DC/DfrTD5WexzvJ+ZmTl6h91+hkqnv2XPvb8rw7je8sC4G2bEiaPkfeiTjcOLzJcfnEE
         mL3Ix4kPdukOwUaklW9w2QDxQskmCqtjG4G2VnKLY4wejRMH9i2dlzhS8mesVpS1ZleW
         0xxaw+6iniMXopqkZYAxAl/EtdnBrvrX7JzFfhYaVSU/XH1KM6k6rFZDTShlP0ihD6bZ
         Wsfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268689; x=1699873489;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5wOkrsA8z2Hole9awlJYsNuk4oh7gPmhIjtphAMJsw8=;
        b=FZynxwxkTSYCT2nJwD9spsOu0eW7y0TCcBWVO7CvYNWSrl1lMg0eeW1rWkAI9ksCLW
         bTGaeyNYF3CoTWisMqO3r3bxaGJj3hfC3Np+lvw0d8+75qtTjFpJcTe3n096nS39hJ06
         QWYqFFKmWMvh2TOb8bHRLpnRdpime2JRqFjnZI/+YEzfzsK34uTI2YqKsNmsawQTbXDm
         RnWAMr60tQdUv9npwBrWWfP2vg3PXEtTA/GK/DnUr8wHFbYiAHt5AfT0XqOBk8/QcO/d
         9xtv87KK+/EIXjKCz7OTO4o1RJcmYhqBK94CNLf4aswbfnswAt33YzcDnUFuNPtSSRFs
         jYwQ==
X-Gm-Message-State: AOJu0YwYdZtNMo5PfyUmS+COTe3LJDgiXplkbR18yQFNyg1pQ6XkFk/X
	R4btkM1Ay3XNdqjpBNcCx1as/A==
X-Google-Smtp-Source: AGHT+IECfFst9YsrR74+b52RmZLy9M9KXPMfA+PoNFzuGn/ZVvte53NMfTf9ib4YmQOSoxKMcxtfzw==
X-Received: by 2002:a05:6000:18a9:b0:32f:9a39:777f with SMTP id b9-20020a05600018a900b0032f9a39777fmr15067192wri.62.1699268689108;
        Mon, 06 Nov 2023 03:04:49 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id z2-20020a5d6402000000b0032d9caeab0fsm9209526wru.77.2023.11.06.03.04.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:04:48 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-s390x@nongnu.org,
	qemu-block@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PULL 10/60] target/arm: Move internal declarations from 'cpu-qom.h' to 'cpu.h'
Date: Mon,  6 Nov 2023 12:02:42 +0100
Message-ID: <20231106110336.358-11-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231106110336.358-1-philmd@linaro.org>
References: <20231106110336.358-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

These definitions and declarations are only used by
target/arm/, no need to expose them to generic hw/.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20231013140116.255-4-philmd@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Message-Id: <c48c9829-3dfa-79cf-3042-454fda0d00dc@linaro.org>
---
 target/arm/cpu-qom.h   | 28 ----------------------------
 target/arm/cpu.h       | 22 ++++++++++++++++++++++
 target/arm/internals.h |  6 ++++++
 3 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/target/arm/cpu-qom.h b/target/arm/cpu-qom.h
index dfb9d5b827..35c3b0924e 100644
--- a/target/arm/cpu-qom.h
+++ b/target/arm/cpu-qom.h
@@ -35,9 +35,6 @@ typedef struct ARMCPUInfo {
     void (*class_init)(ObjectClass *oc, void *data);
 } ARMCPUInfo;
 
-void arm_cpu_register(const ARMCPUInfo *info);
-void aarch64_cpu_register(const ARMCPUInfo *info);
-
 /**
  * ARMCPUClass:
  * @parent_realize: The parent class' realize handler.
@@ -63,29 +60,4 @@ struct AArch64CPUClass {
     ARMCPUClass parent_class;
 };
 
-void register_cp_regs_for_features(ARMCPU *cpu);
-void init_cpreg_list(ARMCPU *cpu);
-
-/* Callback functions for the generic timer's timers. */
-void arm_gt_ptimer_cb(void *opaque);
-void arm_gt_vtimer_cb(void *opaque);
-void arm_gt_htimer_cb(void *opaque);
-void arm_gt_stimer_cb(void *opaque);
-void arm_gt_hvtimer_cb(void *opaque);
-
-#define ARM_AFF0_SHIFT 0
-#define ARM_AFF0_MASK  (0xFFULL << ARM_AFF0_SHIFT)
-#define ARM_AFF1_SHIFT 8
-#define ARM_AFF1_MASK  (0xFFULL << ARM_AFF1_SHIFT)
-#define ARM_AFF2_SHIFT 16
-#define ARM_AFF2_MASK  (0xFFULL << ARM_AFF2_SHIFT)
-#define ARM_AFF3_SHIFT 32
-#define ARM_AFF3_MASK  (0xFFULL << ARM_AFF3_SHIFT)
-#define ARM_DEFAULT_CPUS_PER_CLUSTER 8
-
-#define ARM32_AFFINITY_MASK (ARM_AFF0_MASK|ARM_AFF1_MASK|ARM_AFF2_MASK)
-#define ARM64_AFFINITY_MASK \
-    (ARM_AFF0_MASK|ARM_AFF1_MASK|ARM_AFF2_MASK|ARM_AFF3_MASK)
-#define ARM64_AFFINITY_INVALID (~ARM64_AFFINITY_MASK)
-
 #endif
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index 2f7ab22169..4a86c8f831 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -1116,11 +1116,33 @@ struct ArchCPU {
     uint64_t gt_cntfrq_hz;
 };
 
+/* Callback functions for the generic timer's timers. */
+void arm_gt_ptimer_cb(void *opaque);
+void arm_gt_vtimer_cb(void *opaque);
+void arm_gt_htimer_cb(void *opaque);
+void arm_gt_stimer_cb(void *opaque);
+void arm_gt_hvtimer_cb(void *opaque);
+
 unsigned int gt_cntfrq_period_ns(ARMCPU *cpu);
 void gt_rme_post_el_change(ARMCPU *cpu, void *opaque);
 
 void arm_cpu_post_init(Object *obj);
 
+#define ARM_AFF0_SHIFT 0
+#define ARM_AFF0_MASK  (0xFFULL << ARM_AFF0_SHIFT)
+#define ARM_AFF1_SHIFT 8
+#define ARM_AFF1_MASK  (0xFFULL << ARM_AFF1_SHIFT)
+#define ARM_AFF2_SHIFT 16
+#define ARM_AFF2_MASK  (0xFFULL << ARM_AFF2_SHIFT)
+#define ARM_AFF3_SHIFT 32
+#define ARM_AFF3_MASK  (0xFFULL << ARM_AFF3_SHIFT)
+#define ARM_DEFAULT_CPUS_PER_CLUSTER 8
+
+#define ARM32_AFFINITY_MASK (ARM_AFF0_MASK | ARM_AFF1_MASK | ARM_AFF2_MASK)
+#define ARM64_AFFINITY_MASK \
+    (ARM_AFF0_MASK | ARM_AFF1_MASK | ARM_AFF2_MASK | ARM_AFF3_MASK)
+#define ARM64_AFFINITY_INVALID (~ARM64_AFFINITY_MASK)
+
 uint64_t arm_cpu_mp_affinity(int idx, uint8_t clustersz);
 
 #ifndef CONFIG_USER_ONLY
diff --git a/target/arm/internals.h b/target/arm/internals.h
index c837506e44..143d57c0fe 100644
--- a/target/arm/internals.h
+++ b/target/arm/internals.h
@@ -183,6 +183,12 @@ static inline int r14_bank_number(int mode)
     return (mode == ARM_CPU_MODE_HYP) ? BANK_USRSYS : bank_number(mode);
 }
 
+void arm_cpu_register(const ARMCPUInfo *info);
+void aarch64_cpu_register(const ARMCPUInfo *info);
+
+void register_cp_regs_for_features(ARMCPU *cpu);
+void init_cpreg_list(ARMCPU *cpu);
+
 void arm_cpu_register_gdb_regs_for_features(ARMCPU *cpu);
 void arm_translate_init(void);
 
-- 
2.41.0


