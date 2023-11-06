Return-Path: <kvm+bounces-676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 522CB7E1F3D
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:04:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 88F32B2164A
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:04:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A9F91EB34;
	Mon,  6 Nov 2023 11:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NUkHd2UD"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF601EB2B
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:04:32 +0000 (UTC)
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02A11125
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:04:29 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-40790b0a224so32901035e9.0
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:04:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268667; x=1699873467; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=599/Bj9mord/rWtxWCsNHAuRNbZVNvVu72yn9cQly6g=;
        b=NUkHd2UDtzyJZ68cpDCGlBqeAQ2WhXH+nkHFx1t9I2rnZh9rq5aVmuOETHIJ+UiBh6
         gEhrf0Nq4mH1tP0dhbUBtKaTpwQRykDnOS+Rb0ELnm+TEErhMHid0kVl7IQZZ9vBLM3p
         xc8ZE+BZiqHzItsZVXUGGxVuBrgWodTT2ptwzQEayrMB0SCjDhWD01JYUkkicttrpnnV
         UBqsixw+8vEckcVTlFlzru6xAY4AmptvEs34vtHnl8Kq0Lv/gYeCZkUbMmoS5qNHTeiX
         IZ8Abl/n5G+Qvx2P58rKWIha7YRYydXF91t1hHPBP+oyMSCcIhBCugGtJEb2P2r9cfS1
         d2XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268667; x=1699873467;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=599/Bj9mord/rWtxWCsNHAuRNbZVNvVu72yn9cQly6g=;
        b=MbP/+tnFzCQsm67NA0/Rf5MVezfzjAf2IKSaJIfONycepSRJOG5EhAbIRkl4Uz8kAi
         Tycj4jEtIc/Sq15Lt0kxTL9EMYmcZQ/5QCLF4ODBJWszN/9KTZ0dQyyONz2+6aLNzwt/
         wvi+DKxBnCBqsA0kqWyB3JO6IylVxNs624JxBmZNKGFqk8d5FnKOvhoOdpQy1DZb7rMY
         yG/thk7d+vK1d+NTzpV3bfHNyLnql/jg7Uf4y1W1F4DSF4EIikB+vaJTYLmWgVAWhLEb
         XiI01P58nHFZJhw2ZPdFG0cDLPnlisppWKb+vWYDXab5zC5fdhsFPfzXJyjG/LbR02JX
         ATpw==
X-Gm-Message-State: AOJu0YwXqxxxAajdnqQvXsV04MPWrrf45v4PPGm5P1j47AA5fVFJdDct
	HXCH1ETEi/PqH+E5c3iRYNN/CA==
X-Google-Smtp-Source: AGHT+IEzp/mPbFUy8SkmetAAoTy+TS+vDzZzjoAJkoCTBAmaD/KNwWEWoOROTPCc4oN0cNW9yDLu/w==
X-Received: by 2002:a05:600c:488a:b0:408:3c8f:afd9 with SMTP id j10-20020a05600c488a00b004083c8fafd9mr22199866wmp.3.1699268667013;
        Mon, 06 Nov 2023 03:04:27 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id s7-20020a05600c45c700b003fc16ee2864sm11816561wmo.48.2023.11.06.03.04.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:04:26 -0800 (PST)
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
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PULL 07/60] accel/tcg: Factor tcg_cpu_reset_hold() out
Date: Mon,  6 Nov 2023 12:02:39 +0100
Message-ID: <20231106110336.358-8-philmd@linaro.org>
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

Factor the TCG specific code from cpu_common_reset_hold() to
tcg_cpu_reset_hold() within tcg-accel-ops.c. Since this file
is sysemu specific, we can inline tcg_flush_softmmu_tlb(),
removing its declaration in "exec/cpu-common.h".

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Anton Johansson <anjo@rev.ng>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20230918104153.24433-4-philmd@linaro.org>
---
 include/exec/cpu-common.h | 2 --
 accel/stubs/tcg-stub.c    | 4 ----
 accel/tcg/tcg-accel-ops.c | 8 ++++++++
 accel/tcg/translate-all.c | 8 --------
 hw/core/cpu-common.c      | 5 -----
 5 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index f700071d12..41115d8919 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -45,8 +45,6 @@ void cpu_list_lock(void);
 void cpu_list_unlock(void);
 unsigned int cpu_list_generation_id_get(void);
 
-void tcg_flush_softmmu_tlb(CPUState *cs);
-
 void tcg_iommu_init_notifier_list(CPUState *cpu);
 void tcg_iommu_free_notifier_list(CPUState *cpu);
 
diff --git a/accel/stubs/tcg-stub.c b/accel/stubs/tcg-stub.c
index a9e7a2d5b4..8a496a2a6f 100644
--- a/accel/stubs/tcg-stub.c
+++ b/accel/stubs/tcg-stub.c
@@ -22,10 +22,6 @@ void tlb_set_dirty(CPUState *cpu, vaddr vaddr)
 {
 }
 
-void tcg_flush_jmp_cache(CPUState *cpu)
-{
-}
-
 int probe_access_flags(CPUArchState *env, vaddr addr, int size,
                        MMUAccessType access_type, int mmu_idx,
                        bool nonfault, void **phost, uintptr_t retaddr)
diff --git a/accel/tcg/tcg-accel-ops.c b/accel/tcg/tcg-accel-ops.c
index 7ddb05c332..1b57290682 100644
--- a/accel/tcg/tcg-accel-ops.c
+++ b/accel/tcg/tcg-accel-ops.c
@@ -78,6 +78,13 @@ int tcg_cpus_exec(CPUState *cpu)
     return ret;
 }
 
+static void tcg_cpu_reset_hold(CPUState *cpu)
+{
+    tcg_flush_jmp_cache(cpu);
+
+    tlb_flush(cpu);
+}
+
 /* mask must never be zero, except for A20 change call */
 void tcg_handle_interrupt(CPUState *cpu, int mask)
 {
@@ -206,6 +213,7 @@ static void tcg_accel_ops_init(AccelOpsClass *ops)
         }
     }
 
+    ops->cpu_reset_hold = tcg_cpu_reset_hold;
     ops->supports_guest_debug = tcg_supports_guest_debug;
     ops->insert_breakpoint = tcg_insert_breakpoint;
     ops->remove_breakpoint = tcg_remove_breakpoint;
diff --git a/accel/tcg/translate-all.c b/accel/tcg/translate-all.c
index 8cb6ad3511..27e8152f0a 100644
--- a/accel/tcg/translate-all.c
+++ b/accel/tcg/translate-all.c
@@ -800,11 +800,3 @@ void tcg_flush_jmp_cache(CPUState *cpu)
         qatomic_set(&jc->array[i].tb, NULL);
     }
 }
-
-/* This is a wrapper for common code that can not use CONFIG_SOFTMMU */
-void tcg_flush_softmmu_tlb(CPUState *cs)
-{
-#ifdef CONFIG_SOFTMMU
-    tlb_flush(cs);
-#endif
-}
diff --git a/hw/core/cpu-common.c b/hw/core/cpu-common.c
index 7d266c36ac..baa6d28b64 100644
--- a/hw/core/cpu-common.c
+++ b/hw/core/cpu-common.c
@@ -27,7 +27,6 @@
 #include "qemu/main-loop.h"
 #include "exec/log.h"
 #include "exec/cpu-common.h"
-#include "exec/tb-flush.h"
 #include "qemu/error-report.h"
 #include "qemu/qemu-print.h"
 #include "sysemu/tcg.h"
@@ -138,10 +137,6 @@ static void cpu_common_reset_hold(Object *obj)
     cpu->cflags_next_tb = -1;
 
     cpu_exec_reset_hold(cpu);
-    if (tcg_enabled()) {
-        tcg_flush_jmp_cache(cpu);
-        tcg_flush_softmmu_tlb(cpu);
-    }
 }
 
 static bool cpu_common_has_work(CPUState *cs)
-- 
2.41.0


