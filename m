Return-Path: <kvm+bounces-675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C8F2F7E1F3C
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:04:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 59881B20D66
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:04:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C07EA1EB2C;
	Mon,  6 Nov 2023 11:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NFenQgRw"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF951EB31
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:04:23 +0000 (UTC)
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 080C8FA
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:04:22 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-4084095722aso33486155e9.1
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268660; x=1699873460; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vBU4Pso0gSsGUJn6Y+tUxfBbchAwyEFBu11FifHIio4=;
        b=NFenQgRwp3mcMP5N0RZvhctVrozKPA+o9CeMHsVICoYMEtfFN3bjJ/udPwvkw9MtOQ
         sm/N2wdnDawzawr7vTBuSnTmBNdYW/wGzGbViWhFZw9+22+fyt1s6IR/U28SSRgpokI3
         ds6S5aJ4mbCCXFS16tCZcbX4WFfxzVgFFrEV0kjQ9o0b2RpsHSNxrWWo8nKE1WrzlrMy
         xI1p61ACJtDvCGeCgl27A8HPuv43ujSv4NNlSLZpUi8MSYgGbs44GdSXxmQt8/Ki9XZp
         go58IDKVLpsQ3lENeB0TloRqfNp9eRCIlsXRHm24fIj2H7ORa7+qoRqWgDWp7UIHZJty
         gVCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268660; x=1699873460;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vBU4Pso0gSsGUJn6Y+tUxfBbchAwyEFBu11FifHIio4=;
        b=Si9P2X7jiBOdh32JtKhvH+Mk1uv4pzJ3n2kzdCJB5tmR8Y7iCObMOpKa1EoS87kRAc
         5swZ3Hl9ZusGHGrnor1VFGJ7grkmJK4FmZJ7XS9wZ7c+XzUXKxQ2TSpA2YHISa88Ljzn
         vu2rW+QCpoCcY4vNmvFwbQzzDqXwS8WnbBulUHXArZnTarXEAuds4UPyban+Uq4255c9
         ied5Gq3ME/DME2JR0kyXks34oNMsDyFOigNZz90ydRqkaZnMHY2MZP2jba0c4TWtYQ8f
         HRZfO3XJoHs0T76fAs0WgECXPTuSKYF1QJJZI9ue7FCS7qSVy+BcbfshXwclGvsVMsQe
         IuVQ==
X-Gm-Message-State: AOJu0YwcD1JpRM0f2YTS4t3w0em5wmqd64gPNmHB5+TAfBkuMcyHvMzr
	5+fpOx6JXWictCUhYjxtpjVb2A==
X-Google-Smtp-Source: AGHT+IFNaWNTXm6/JgnRLDfhCwlt529RJlrSNb5hfX6nFr1uBzGpsDlgEDrmBYL8mOG8EZ2XGLOTgg==
X-Received: by 2002:a05:600c:1906:b0:408:3b8d:f7e8 with SMTP id j6-20020a05600c190600b004083b8df7e8mr24996294wmq.33.1699268660546;
        Mon, 06 Nov 2023 03:04:20 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id g20-20020a05600c4ed400b003fee8793911sm12010027wmq.44.2023.11.06.03.04.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:04:20 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-s390x@nongnu.org,
	qemu-block@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Anton Johansson <anjo@rev.ng>,
	Richard Henderson <richard.henderson@linaro.org>,
	Riku Voipio <riku.voipio@iki.fi>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>
Subject: [PULL 06/60] accel: Introduce cpu_exec_reset_hold()
Date: Mon,  6 Nov 2023 12:02:38 +0100
Message-ID: <20231106110336.358-7-philmd@linaro.org>
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

Introduce cpu_exec_reset_hold() which call an accelerator
specific AccelOpsClass::cpu_reset_hold() handler.

Define a stub on TCG user emulation, because CPU reset is
irrelevant there.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Anton Johansson <anjo@rev.ng>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20230918104153.24433-3-philmd@linaro.org>
---
 include/hw/core/cpu.h      | 1 +
 include/sysemu/accel-ops.h | 1 +
 accel/tcg/user-exec-stub.c | 4 ++++
 hw/core/cpu-common.c       | 1 +
 system/cpus.c              | 7 +++++++
 5 files changed, 14 insertions(+)

diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index 18593db5b2..6373aa4501 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -1153,6 +1153,7 @@ void cpu_class_init_props(DeviceClass *dc);
 void cpu_exec_initfn(CPUState *cpu);
 void cpu_exec_realizefn(CPUState *cpu, Error **errp);
 void cpu_exec_unrealizefn(CPUState *cpu);
+void cpu_exec_reset_hold(CPUState *cpu);
 
 /**
  * target_words_bigendian:
diff --git a/include/sysemu/accel-ops.h b/include/sysemu/accel-ops.h
index 3c1fab4b1e..ef91fc28bb 100644
--- a/include/sysemu/accel-ops.h
+++ b/include/sysemu/accel-ops.h
@@ -30,6 +30,7 @@ struct AccelOpsClass {
     void (*ops_init)(AccelOpsClass *ops);
 
     bool (*cpus_are_resettable)(void);
+    void (*cpu_reset_hold)(CPUState *cpu);
 
     void (*create_vcpu_thread)(CPUState *cpu); /* MANDATORY NON-NULL */
     void (*kick_vcpu_thread)(CPUState *cpu);
diff --git a/accel/tcg/user-exec-stub.c b/accel/tcg/user-exec-stub.c
index 2dc6fd9c4e..4fbe2dbdc8 100644
--- a/accel/tcg/user-exec-stub.c
+++ b/accel/tcg/user-exec-stub.c
@@ -14,6 +14,10 @@ void qemu_init_vcpu(CPUState *cpu)
 {
 }
 
+void cpu_exec_reset_hold(CPUState *cpu)
+{
+}
+
 /* User mode emulation does not support record/replay yet.  */
 
 bool replay_exception(void)
diff --git a/hw/core/cpu-common.c b/hw/core/cpu-common.c
index 29c917c5dc..7d266c36ac 100644
--- a/hw/core/cpu-common.c
+++ b/hw/core/cpu-common.c
@@ -137,6 +137,7 @@ static void cpu_common_reset_hold(Object *obj)
     cpu->crash_occurred = false;
     cpu->cflags_next_tb = -1;
 
+    cpu_exec_reset_hold(cpu);
     if (tcg_enabled()) {
         tcg_flush_jmp_cache(cpu);
         tcg_flush_softmmu_tlb(cpu);
diff --git a/system/cpus.c b/system/cpus.c
index 0848e0dbdb..952f15868c 100644
--- a/system/cpus.c
+++ b/system/cpus.c
@@ -201,6 +201,13 @@ bool cpus_are_resettable(void)
     return true;
 }
 
+void cpu_exec_reset_hold(CPUState *cpu)
+{
+    if (cpus_accel->cpu_reset_hold) {
+        cpus_accel->cpu_reset_hold(cpu);
+    }
+}
+
 int64_t cpus_get_virtual_clock(void)
 {
     /*
-- 
2.41.0


