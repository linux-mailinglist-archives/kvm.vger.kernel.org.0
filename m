Return-Path: <kvm+bounces-707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5B197E1F7F
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:08:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A515281632
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:08:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 319481862D;
	Mon,  6 Nov 2023 11:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HIDP4jIR"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB6517754
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:08:03 +0000 (UTC)
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7324DB0
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:08:01 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id ffacd0b85a97d-32f87b1c725so3054986f8f.3
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:08:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268880; x=1699873680; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KMjbC2xJWHxNTrhQC1HW/27kz6qe7U3LIUpfEfCgflY=;
        b=HIDP4jIRpU1/hcmWWmR4dZbaGRms5qyrf/6wx9v2M9kXLYYSG5pFjcv5qbsLqN55BW
         WQX4b3xqYi21ni8YffZZMOgInyhYHN3WxnqCwx8RRWmDC63/tH23JbJXc13TV9lHe2Le
         B5AFFA0juHhWZuL0oPu/xJ7XdsKRfmPRtVXhoisAsq0HWToPttOznDaUUVIcQ87Im6xz
         N0P8dXDeVx1FSnY8H2ZobK3F7M4ZDH9bfu9QhGiSAID8e1BAuJYLBq0EHmlyk1rhoMo6
         7s0yvK0yF6iRLhOKV8Mz2b0p1KS/HMNBmk3kqdWxVvfWWftJqjbgcWpE5cqXMGg6ZbGo
         z9Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268880; x=1699873680;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KMjbC2xJWHxNTrhQC1HW/27kz6qe7U3LIUpfEfCgflY=;
        b=hNYifSsUl2iuHL99KYVwx1aUM1wI97fozvyWNBaiYXOn52d79JUozU5K2bZnWE1UrK
         wZYLhV5w1ePAenX6f96VnVJCkuZtMveoRztqjqUsZssLMHYCkC0f9nqgJh5DMkPGJNiL
         tnQ6soF266dq0Jill/l4unV013hjHOGduf/pjLIBmf2DefGtNWWTdqst+/nQVRbS+iTc
         polv/wXZWscSeDbIB7DswYjtJCSbyLFChQxIHF7vadfhor8qljPrezCDBvnzD3JO0c8b
         uTsFRctM5j793z4fno05eu1qvEmG+x4Gd4HEFkDuUURoapYoTy7BLYny21x78lXekNAT
         OeGQ==
X-Gm-Message-State: AOJu0Yx8I/oseVTqCQ6El6kD2Gv3QLclGbT0QkLCBz58NY0vw2zVh9m3
	WkN6FNXn/LOnbn1KrKukxgZ/QQ==
X-Google-Smtp-Source: AGHT+IH9X2GE3xs55/ZsOwgF8AvUm+DWjmmM+7ejsJtn9NBM/K//H0bsohOzSfHKuAoPE0hD1kKuBQ==
X-Received: by 2002:a5d:47a9:0:b0:32f:96c6:8bb with SMTP id 9-20020a5d47a9000000b0032f96c608bbmr13753845wrb.7.1699268879845;
        Mon, 06 Nov 2023 03:07:59 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id l4-20020a5d5604000000b0032f78feb826sm9106145wrv.104.2023.11.06.03.07.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:07:59 -0800 (PST)
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
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Michael Rolnik <mrolnik@gmail.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Brian Cain <bcain@quicinc.com>,
	Song Gao <gaosong@loongson.cn>,
	Laurent Vivier <laurent@vivier.eu>,
	Stafford Horne <shorne@gmail.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Bin Meng <bin.meng@windriver.com>,
	Weiwei Li <liweiwei@iscas.ac.cn>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
	Max Filippov <jcmvbkbc@gmail.com>
Subject: [PULL 38/60] hw/cpu: Call object_class_is_abstract() once in cpu_class_by_name()
Date: Mon,  6 Nov 2023 12:03:10 +0100
Message-ID: <20231106110336.358-39-philmd@linaro.org>
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

Let CPUClass::class_by_name() handlers to return abstract classes,
and filter them once in the public cpu_class_by_name() method.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20230908112235.75914-3-philmd@linaro.org>
---
 include/hw/core/cpu.h  |  7 ++++---
 hw/core/cpu-common.c   | 14 +++++++++++---
 target/alpha/cpu.c     |  3 +--
 target/arm/cpu.c       |  3 +--
 target/avr/cpu.c       |  3 +--
 target/cris/cpu.c      |  3 +--
 target/hexagon/cpu.c   |  3 +--
 target/loongarch/cpu.c |  3 +--
 target/m68k/cpu.c      |  3 +--
 target/openrisc/cpu.c  |  3 +--
 target/riscv/cpu.c     |  3 +--
 target/rx/cpu.c        |  6 +-----
 target/sh4/cpu.c       |  3 ---
 target/tricore/cpu.c   |  3 +--
 target/xtensa/cpu.c    |  3 +--
 15 files changed, 27 insertions(+), 36 deletions(-)

diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index 6373aa4501..5d6f8dca43 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -102,7 +102,7 @@ struct SysemuCPUOps;
 /**
  * CPUClass:
  * @class_by_name: Callback to map -cpu command line model name to an
- * instantiatable CPU type.
+ *                 instantiatable CPU type.
  * @parse_features: Callback to parse command line arguments.
  * @reset_dump_flags: #CPUDumpFlags to use for reset logging.
  * @has_work: Callback for checking if there is work to do.
@@ -772,9 +772,10 @@ void cpu_reset(CPUState *cpu);
  * @typename: The CPU base type.
  * @cpu_model: The model string without any parameters.
  *
- * Looks up a CPU #ObjectClass matching name @cpu_model.
+ * Looks up a concrete CPU #ObjectClass matching name @cpu_model.
  *
- * Returns: A #CPUClass or %NULL if not matching class is found.
+ * Returns: A concrete #CPUClass or %NULL if no matching class is found
+ *          or if the matching class is abstract.
  */
 ObjectClass *cpu_class_by_name(const char *typename, const char *cpu_model);
 
diff --git a/hw/core/cpu-common.c b/hw/core/cpu-common.c
index baa6d28b64..d4112b8919 100644
--- a/hw/core/cpu-common.c
+++ b/hw/core/cpu-common.c
@@ -146,10 +146,18 @@ static bool cpu_common_has_work(CPUState *cs)
 
 ObjectClass *cpu_class_by_name(const char *typename, const char *cpu_model)
 {
-    CPUClass *cc = CPU_CLASS(object_class_by_name(typename));
+    ObjectClass *oc;
+    CPUClass *cc;
 
-    assert(cpu_model && cc->class_by_name);
-    return cc->class_by_name(cpu_model);
+    oc = object_class_by_name(typename);
+    cc = CPU_CLASS(oc);
+    assert(cc->class_by_name);
+    assert(cpu_model);
+    oc = cc->class_by_name(cpu_model);
+    if (oc == NULL || object_class_is_abstract(oc)) {
+        return NULL;
+    }
+    return oc;
 }
 
 static void cpu_common_parse_features(const char *typename, char *features,
diff --git a/target/alpha/cpu.c b/target/alpha/cpu.c
index fae2cb6ec7..39cf841b3e 100644
--- a/target/alpha/cpu.c
+++ b/target/alpha/cpu.c
@@ -126,8 +126,7 @@ static ObjectClass *alpha_cpu_class_by_name(const char *cpu_model)
     int i;
 
     oc = object_class_by_name(cpu_model);
-    if (oc != NULL && object_class_dynamic_cast(oc, TYPE_ALPHA_CPU) != NULL &&
-        !object_class_is_abstract(oc)) {
+    if (oc != NULL && object_class_dynamic_cast(oc, TYPE_ALPHA_CPU) != NULL) {
         return oc;
     }
 
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index df6496b019..25e9d2ae7b 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -2401,8 +2401,7 @@ static ObjectClass *arm_cpu_class_by_name(const char *cpu_model)
     oc = object_class_by_name(typename);
     g_strfreev(cpuname);
     g_free(typename);
-    if (!oc || !object_class_dynamic_cast(oc, TYPE_ARM_CPU) ||
-        object_class_is_abstract(oc)) {
+    if (!oc || !object_class_dynamic_cast(oc, TYPE_ARM_CPU)) {
         return NULL;
     }
     return oc;
diff --git a/target/avr/cpu.c b/target/avr/cpu.c
index 14d8b9d1f0..44de1e18d1 100644
--- a/target/avr/cpu.c
+++ b/target/avr/cpu.c
@@ -157,8 +157,7 @@ static ObjectClass *avr_cpu_class_by_name(const char *cpu_model)
     ObjectClass *oc;
 
     oc = object_class_by_name(cpu_model);
-    if (object_class_dynamic_cast(oc, TYPE_AVR_CPU) == NULL ||
-        object_class_is_abstract(oc)) {
+    if (object_class_dynamic_cast(oc, TYPE_AVR_CPU) == NULL) {
         oc = NULL;
     }
     return oc;
diff --git a/target/cris/cpu.c b/target/cris/cpu.c
index be4a44c218..675b73ac04 100644
--- a/target/cris/cpu.c
+++ b/target/cris/cpu.c
@@ -95,8 +95,7 @@ static ObjectClass *cris_cpu_class_by_name(const char *cpu_model)
     typename = g_strdup_printf(CRIS_CPU_TYPE_NAME("%s"), cpu_model);
     oc = object_class_by_name(typename);
     g_free(typename);
-    if (oc != NULL && (!object_class_dynamic_cast(oc, TYPE_CRIS_CPU) ||
-                       object_class_is_abstract(oc))) {
+    if (oc != NULL && !object_class_dynamic_cast(oc, TYPE_CRIS_CPU)) {
         oc = NULL;
     }
     return oc;
diff --git a/target/hexagon/cpu.c b/target/hexagon/cpu.c
index 1adc11b713..9d1ffc3b4b 100644
--- a/target/hexagon/cpu.c
+++ b/target/hexagon/cpu.c
@@ -63,8 +63,7 @@ static ObjectClass *hexagon_cpu_class_by_name(const char *cpu_model)
     oc = object_class_by_name(typename);
     g_strfreev(cpuname);
     g_free(typename);
-    if (!oc || !object_class_dynamic_cast(oc, TYPE_HEXAGON_CPU) ||
-        object_class_is_abstract(oc)) {
+    if (!oc || !object_class_dynamic_cast(oc, TYPE_HEXAGON_CPU)) {
         return NULL;
     }
     return oc;
diff --git a/target/loongarch/cpu.c b/target/loongarch/cpu.c
index ef1bf89dac..06d1b9bb95 100644
--- a/target/loongarch/cpu.c
+++ b/target/loongarch/cpu.c
@@ -648,8 +648,7 @@ static ObjectClass *loongarch_cpu_class_by_name(const char *cpu_model)
         }
     }
 
-    if (object_class_dynamic_cast(oc, TYPE_LOONGARCH_CPU)
-        && !object_class_is_abstract(oc)) {
+    if (object_class_dynamic_cast(oc, TYPE_LOONGARCH_CPU)) {
         return oc;
     }
     return NULL;
diff --git a/target/m68k/cpu.c b/target/m68k/cpu.c
index 538d9473c2..11c7e0a790 100644
--- a/target/m68k/cpu.c
+++ b/target/m68k/cpu.c
@@ -111,8 +111,7 @@ static ObjectClass *m68k_cpu_class_by_name(const char *cpu_model)
     typename = g_strdup_printf(M68K_CPU_TYPE_NAME("%s"), cpu_model);
     oc = object_class_by_name(typename);
     g_free(typename);
-    if (oc != NULL && (object_class_dynamic_cast(oc, TYPE_M68K_CPU) == NULL ||
-                       object_class_is_abstract(oc))) {
+    if (oc != NULL && object_class_dynamic_cast(oc, TYPE_M68K_CPU) == NULL) {
         return NULL;
     }
     return oc;
diff --git a/target/openrisc/cpu.c b/target/openrisc/cpu.c
index f5a3d5273b..1173260017 100644
--- a/target/openrisc/cpu.c
+++ b/target/openrisc/cpu.c
@@ -164,8 +164,7 @@ static ObjectClass *openrisc_cpu_class_by_name(const char *cpu_model)
     typename = g_strdup_printf(OPENRISC_CPU_TYPE_NAME("%s"), cpu_model);
     oc = object_class_by_name(typename);
     g_free(typename);
-    if (oc != NULL && (!object_class_dynamic_cast(oc, TYPE_OPENRISC_CPU) ||
-                       object_class_is_abstract(oc))) {
+    if (oc != NULL && !object_class_dynamic_cast(oc, TYPE_OPENRISC_CPU)) {
         return NULL;
     }
     return oc;
diff --git a/target/riscv/cpu.c b/target/riscv/cpu.c
index ac4a6c7eec..63624e8b76 100644
--- a/target/riscv/cpu.c
+++ b/target/riscv/cpu.c
@@ -636,8 +636,7 @@ static ObjectClass *riscv_cpu_class_by_name(const char *cpu_model)
     oc = object_class_by_name(typename);
     g_strfreev(cpuname);
     g_free(typename);
-    if (!oc || !object_class_dynamic_cast(oc, TYPE_RISCV_CPU) ||
-        object_class_is_abstract(oc)) {
+    if (!oc || !object_class_dynamic_cast(oc, TYPE_RISCV_CPU)) {
         return NULL;
     }
     return oc;
diff --git a/target/rx/cpu.c b/target/rx/cpu.c
index 4d0d3a0c8c..9cc9d9d15e 100644
--- a/target/rx/cpu.c
+++ b/target/rx/cpu.c
@@ -111,16 +111,12 @@ static ObjectClass *rx_cpu_class_by_name(const char *cpu_model)
     char *typename;
 
     oc = object_class_by_name(cpu_model);
-    if (oc != NULL && object_class_dynamic_cast(oc, TYPE_RX_CPU) != NULL &&
-        !object_class_is_abstract(oc)) {
+    if (oc != NULL && object_class_dynamic_cast(oc, TYPE_RX_CPU) != NULL) {
         return oc;
     }
     typename = g_strdup_printf(RX_CPU_TYPE_NAME("%s"), cpu_model);
     oc = object_class_by_name(typename);
     g_free(typename);
-    if (oc != NULL && object_class_is_abstract(oc)) {
-        oc = NULL;
-    }
 
     return oc;
 }
diff --git a/target/sh4/cpu.c b/target/sh4/cpu.c
index 788e41fea6..a8ec98b134 100644
--- a/target/sh4/cpu.c
+++ b/target/sh4/cpu.c
@@ -152,9 +152,6 @@ static ObjectClass *superh_cpu_class_by_name(const char *cpu_model)
 
     typename = g_strdup_printf(SUPERH_CPU_TYPE_NAME("%s"), s);
     oc = object_class_by_name(typename);
-    if (oc != NULL && object_class_is_abstract(oc)) {
-        oc = NULL;
-    }
 
 out:
     g_free(s);
diff --git a/target/tricore/cpu.c b/target/tricore/cpu.c
index 5ca666ee12..034e01c189 100644
--- a/target/tricore/cpu.c
+++ b/target/tricore/cpu.c
@@ -132,8 +132,7 @@ static ObjectClass *tricore_cpu_class_by_name(const char *cpu_model)
     typename = g_strdup_printf(TRICORE_CPU_TYPE_NAME("%s"), cpu_model);
     oc = object_class_by_name(typename);
     g_free(typename);
-    if (!oc || !object_class_dynamic_cast(oc, TYPE_TRICORE_CPU) ||
-        object_class_is_abstract(oc)) {
+    if (!oc || !object_class_dynamic_cast(oc, TYPE_TRICORE_CPU)) {
         return NULL;
     }
     return oc;
diff --git a/target/xtensa/cpu.c b/target/xtensa/cpu.c
index ea1dae7390..e20fe87bf2 100644
--- a/target/xtensa/cpu.c
+++ b/target/xtensa/cpu.c
@@ -141,8 +141,7 @@ static ObjectClass *xtensa_cpu_class_by_name(const char *cpu_model)
     typename = g_strdup_printf(XTENSA_CPU_TYPE_NAME("%s"), cpu_model);
     oc = object_class_by_name(typename);
     g_free(typename);
-    if (oc == NULL || !object_class_dynamic_cast(oc, TYPE_XTENSA_CPU) ||
-        object_class_is_abstract(oc)) {
+    if (oc == NULL || !object_class_dynamic_cast(oc, TYPE_XTENSA_CPU)) {
         return NULL;
     }
     return oc;
-- 
2.41.0


