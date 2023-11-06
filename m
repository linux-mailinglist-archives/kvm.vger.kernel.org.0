Return-Path: <kvm+bounces-709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3ADA7E1F82
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:08:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C2CA81C20BAD
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:08:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3B0919BA3;
	Mon,  6 Nov 2023 11:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MuvGfNFA"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F403C182C1
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:08:16 +0000 (UTC)
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08517A3
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:08:15 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-32fd7fc9f19so308058f8f.2
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:08:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268893; x=1699873693; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1c+BV5Tpk9NJdk/9uGPTtpoehyOljryZgDubWA0xkSQ=;
        b=MuvGfNFAM9MQGFCQS/5TsqG4N8yHvx90JnWeZNahhXuAn2uH1k9DOiIcJIfhlamMDe
         VaW2mB+dNj7est0QJoPY9TkwceBI4YQVx9KZhp6HZVtKryxDMnDP72n02ITufK8aKcLq
         Vl+DADaPUFW3/pRN4H9MfwZ+p0FpH8o9eCq+5sLeOqa+N/ZI8IKyhDlsdD7tsHixJwuu
         al0e94PH2wL7KP5GgoD/OnCkI2sl+Z2Iz+ZWFspyftc3R+OYH083DGjmFAD55Ii3WxO9
         Dp2lFsidAuy5RNtPxzuDjNn4THV+yIaBgwcFG0xipi1SOBammULu8FryYNvJEypdhRgn
         L3Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268893; x=1699873693;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1c+BV5Tpk9NJdk/9uGPTtpoehyOljryZgDubWA0xkSQ=;
        b=ph3Nzt1DvY3Yrg8tTqQNG/jF+ZBbqxaAwrBveBPGixdKePNZiPacqsgpUeyBM416bb
         3ZWXh+rZniWvQ9BCoFAXq8znXsO4ILnQxKmlqeRuivKvChw25Xtbi53zcb7KlOMwEt1v
         pFrxnnokv8jlBM/u4gDpEPDPllu+/AKBiohCj/71NPrVSk7DfSB+24Ga04r07xbaCwQN
         6bZuNtaoMiVNPBrlmtRKuiTC0GE7fsCwuYHAPBK8dbV7HThmUGQXBJvLT4Lip63Xi4fj
         aVpFw/G3grbjp0TMTY5Zs0BAT7/Q+Weih/dbwqaPuZ6uOOMXU5Offh9tmXkIV5o5rQzH
         HzOw==
X-Gm-Message-State: AOJu0YylylXbgeo1ickU9ZM3q+tkVfhECyMWb6F7t6yuwWUiOkEvVU14
	LQt3UDQPT8AgIrEL3sMMldSRLQ==
X-Google-Smtp-Source: AGHT+IFUfEPgJeqeBUUqYn0HxWEHowevUtNbHp5ZBZ2R9PkQdeXdrg9oHvMCfdnh5DWjqHW4fF0gbg==
X-Received: by 2002:a05:6000:1864:b0:32f:7c4d:8746 with SMTP id d4-20020a056000186400b0032f7c4d8746mr24071431wri.12.1699268893422;
        Mon, 06 Nov 2023 03:08:13 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id h16-20020a05600004d000b0032dbf99bf4fsm9290025wri.89.2023.11.06.03.08.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:08:13 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-s390x@nongnu.org,
	qemu-block@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Ani Sinha <anisinha@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Laurent Vivier <laurent@vivier.eu>,
	David Hildenbrand <david@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PULL 40/60] hw/cpu: Clean up global variable shadowing
Date: Mon,  6 Nov 2023 12:03:12 +0100
Message-ID: <20231106110336.358-41-philmd@linaro.org>
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

Fix:

  hw/core/machine.c:1302:22: error: declaration shadows a variable in the global scope [-Werror,-Wshadow]
      const CPUArchId *cpus = possible_cpus->cpus;
                       ^
  hw/core/numa.c:69:17: error: declaration shadows a variable in the global scope [-Werror,-Wshadow]
      uint16List *cpus = NULL;
                  ^
  hw/acpi/aml-build.c:2005:20: error: declaration shadows a variable in the global scope [-Werror,-Wshadow]
      CPUArchIdList *cpus = ms->possible_cpus;
                     ^
  hw/core/machine-smp.c:77:14: error: declaration shadows a variable in the global scope [-Werror,-Wshadow]
      unsigned cpus    = config->has_cpus ? config->cpus : 0;
               ^
  include/hw/core/cpu.h:589:17: note: previous declaration is here
  extern CPUTailQ cpus;
                  ^

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Ani Sinha <anisinha@redhat.com>
Message-Id: <20231010115048.11856-2-philmd@linaro.org>
---
 include/hw/core/cpu.h     | 8 ++++----
 cpu-common.c              | 6 +++---
 linux-user/main.c         | 2 +-
 target/s390x/cpu_models.c | 2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index eb943efb8f..77893d7b81 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -586,13 +586,13 @@ static inline CPUArchState *cpu_env(CPUState *cpu)
 }
 
 typedef QTAILQ_HEAD(CPUTailQ, CPUState) CPUTailQ;
-extern CPUTailQ cpus;
+extern CPUTailQ cpus_queue;
 
-#define first_cpu        QTAILQ_FIRST_RCU(&cpus)
+#define first_cpu        QTAILQ_FIRST_RCU(&cpus_queue)
 #define CPU_NEXT(cpu)    QTAILQ_NEXT_RCU(cpu, node)
-#define CPU_FOREACH(cpu) QTAILQ_FOREACH_RCU(cpu, &cpus, node)
+#define CPU_FOREACH(cpu) QTAILQ_FOREACH_RCU(cpu, &cpus_queue, node)
 #define CPU_FOREACH_SAFE(cpu, next_cpu) \
-    QTAILQ_FOREACH_SAFE_RCU(cpu, &cpus, node, next_cpu)
+    QTAILQ_FOREACH_SAFE_RCU(cpu, &cpus_queue, node, next_cpu)
 
 extern __thread CPUState *current_cpu;
 
diff --git a/cpu-common.c b/cpu-common.c
index 45c745ecf6..c81fd72d16 100644
--- a/cpu-common.c
+++ b/cpu-common.c
@@ -73,7 +73,7 @@ static int cpu_get_free_index(void)
     return max_cpu_index;
 }
 
-CPUTailQ cpus = QTAILQ_HEAD_INITIALIZER(cpus);
+CPUTailQ cpus_queue = QTAILQ_HEAD_INITIALIZER(cpus_queue);
 static unsigned int cpu_list_generation_id;
 
 unsigned int cpu_list_generation_id_get(void)
@@ -90,7 +90,7 @@ void cpu_list_add(CPUState *cpu)
     } else {
         assert(!cpu_index_auto_assigned);
     }
-    QTAILQ_INSERT_TAIL_RCU(&cpus, cpu, node);
+    QTAILQ_INSERT_TAIL_RCU(&cpus_queue, cpu, node);
     cpu_list_generation_id++;
 }
 
@@ -102,7 +102,7 @@ void cpu_list_remove(CPUState *cpu)
         return;
     }
 
-    QTAILQ_REMOVE_RCU(&cpus, cpu, node);
+    QTAILQ_REMOVE_RCU(&cpus_queue, cpu, node);
     cpu->cpu_index = UNASSIGNED_CPU_INDEX;
     cpu_list_generation_id++;
 }
diff --git a/linux-user/main.c b/linux-user/main.c
index 0c23584a96..0cdaf30d34 100644
--- a/linux-user/main.c
+++ b/linux-user/main.c
@@ -156,7 +156,7 @@ void fork_end(int child)
            Discard information about the parent threads.  */
         CPU_FOREACH_SAFE(cpu, next_cpu) {
             if (cpu != thread_cpu) {
-                QTAILQ_REMOVE_RCU(&cpus, cpu, node);
+                QTAILQ_REMOVE_RCU(&cpus_queue, cpu, node);
             }
         }
         qemu_init_cpu_list();
diff --git a/target/s390x/cpu_models.c b/target/s390x/cpu_models.c
index 4dead48650..5c455d00c0 100644
--- a/target/s390x/cpu_models.c
+++ b/target/s390x/cpu_models.c
@@ -757,7 +757,7 @@ void s390_set_qemu_cpu_model(uint16_t type, uint8_t gen, uint8_t ec_ga,
     const S390CPUDef *def = s390_find_cpu_def(type, gen, ec_ga, NULL);
 
     g_assert(def);
-    g_assert(QTAILQ_EMPTY_RCU(&cpus));
+    g_assert(QTAILQ_EMPTY_RCU(&cpus_queue));
 
     /* build the CPU model */
     s390_qemu_cpu_model.def = def;
-- 
2.41.0


