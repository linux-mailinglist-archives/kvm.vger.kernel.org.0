Return-Path: <kvm+bounces-674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A71C17E1F3B
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:04:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2C3C4B21368
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:04:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91B061EB3C;
	Mon,  6 Nov 2023 11:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uEsYRuZZ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC0D1EB2B
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:04:18 +0000 (UTC)
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 899CDBB
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:04:15 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-40859c466efso32045885e9.3
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:04:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268654; x=1699873454; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e2dhS3KlkYuIzlj4JyHbDi+Agmw3+gkCUCmK+83aHSA=;
        b=uEsYRuZZ80LyI8nKheQ+1NrUGJo3TAAsS7lwA0NVRLdIommUMjkbnETS/DHaykVyph
         rDX3ltunMFKuCHd/6T45RK+t6etMSNX6QCHfF6hywGdJz1rpSrH8K6fJD+6aRJ5C+vf9
         JZHhfHU7PDH0TAs1J2HBiLnAdVaJKX0Yf9agkUlNUTq7LwBsDgnHU+yWJQbKoiTsdsTV
         QnGrxfD12jErvYo7vUKblpQuBCYaBgUE5M9pGgxx4aaBW6Y4Qj+0qOgh6uxQVeVDPq1g
         SX/+0YvN+kbiH3wgRs4kFcud4u3qRssxyj6x6ps6amCq/c/DYroQYFx994oFzdR4pqik
         77mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268654; x=1699873454;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e2dhS3KlkYuIzlj4JyHbDi+Agmw3+gkCUCmK+83aHSA=;
        b=ovk4gJA5XCKNoRSTaqeySui0Mxj22aQ2/C53LIO3UKtKjPx+dSIjoSHWjCH79wlM93
         jkq7jaCLt0P/ifQpeiUq6SdozHv+YJvTse19JTx4lLYF5o0AbgYKwEJVjItKkvIAa6kb
         TOIKXhgPO61bYrQu4SCLXfvgh8GbI7fsoTd84Amtrk+wXlvKPP64Jyv0zx6EbBoSxQOh
         T7KxaZ/dKjXgcLybJS8jKlmkFq5n0CRxjlZVyfz5bTLEtEbZ/6tGJbZy8tnqO2756B3u
         5yDbPoQZienSpbtN6uJCuoS4HdyzU2QGmER9ipZxpJbhnW1gNlld9RMUS5K2GNw/M1sm
         D/kQ==
X-Gm-Message-State: AOJu0YxPJlUc+uKbhVyVI1vJhv+/PY4Tqku7eDM6r0GsH0CgYIDBxADy
	5O7huJD/h2z23gXv3maTXrk0yQ==
X-Google-Smtp-Source: AGHT+IEBVIn/0r+UoLYA97Mnp+piCsSmfP4bBhuQ8Q479GVHXuAJkDevEs+mH3EZ9a+ZFr4LoWGeXw==
X-Received: by 2002:a05:600c:5116:b0:409:2825:6dd5 with SMTP id o22-20020a05600c511600b0040928256dd5mr23574505wms.13.1699268653839;
        Mon, 06 Nov 2023 03:04:13 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id n26-20020a1c721a000000b0040849ce7116sm11652236wmc.43.2023.11.06.03.04.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:04:13 -0800 (PST)
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
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Alexandre Iooss <erdnaxe@crans.org>,
	Mahmoud Mandour <ma.mandourr@gmail.com>
Subject: [PULL 05/60] accel/tcg: Declare tcg_flush_jmp_cache() in 'exec/tb-flush.h'
Date: Mon,  6 Nov 2023 12:02:37 +0100
Message-ID: <20231106110336.358-6-philmd@linaro.org>
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

"exec/cpu-common.h" is meant to contain the declarations
related to CPU usable with any accelerator / target
combination.

tcg_flush_jmp_cache() is specific to TCG, so restrict its
declaration by moving it to "exec/tb-flush.h".

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Anton Johansson <anjo@rev.ng>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20230918104153.24433-2-philmd@linaro.org>
---
 include/exec/cpu-common.h | 1 -
 include/exec/tb-flush.h   | 2 ++
 accel/tcg/cputlb.c        | 1 +
 accel/tcg/tcg-accel-ops.c | 1 +
 hw/core/cpu-common.c      | 1 +
 plugins/core.c            | 1 -
 6 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index 30c376a4de..f700071d12 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -46,7 +46,6 @@ void cpu_list_unlock(void);
 unsigned int cpu_list_generation_id_get(void);
 
 void tcg_flush_softmmu_tlb(CPUState *cs);
-void tcg_flush_jmp_cache(CPUState *cs);
 
 void tcg_iommu_init_notifier_list(CPUState *cpu);
 void tcg_iommu_free_notifier_list(CPUState *cpu);
diff --git a/include/exec/tb-flush.h b/include/exec/tb-flush.h
index d92d06565b..142c240d94 100644
--- a/include/exec/tb-flush.h
+++ b/include/exec/tb-flush.h
@@ -23,4 +23,6 @@
  */
 void tb_flush(CPUState *cs);
 
+void tcg_flush_jmp_cache(CPUState *cs);
+
 #endif /* _TB_FLUSH_H_ */
diff --git a/accel/tcg/cputlb.c b/accel/tcg/cputlb.c
index b8c5e345b8..6ea95ca03c 100644
--- a/accel/tcg/cputlb.c
+++ b/accel/tcg/cputlb.c
@@ -24,6 +24,7 @@
 #include "exec/memory.h"
 #include "exec/cpu_ldst.h"
 #include "exec/cputlb.h"
+#include "exec/tb-flush.h"
 #include "exec/memory-internal.h"
 #include "exec/ram_addr.h"
 #include "tcg/tcg.h"
diff --git a/accel/tcg/tcg-accel-ops.c b/accel/tcg/tcg-accel-ops.c
index d885cc1d3c..7ddb05c332 100644
--- a/accel/tcg/tcg-accel-ops.c
+++ b/accel/tcg/tcg-accel-ops.c
@@ -34,6 +34,7 @@
 #include "qemu/timer.h"
 #include "exec/exec-all.h"
 #include "exec/hwaddr.h"
+#include "exec/tb-flush.h"
 #include "exec/gdbstub.h"
 
 #include "tcg-accel-ops.h"
diff --git a/hw/core/cpu-common.c b/hw/core/cpu-common.c
index bab8942c30..29c917c5dc 100644
--- a/hw/core/cpu-common.c
+++ b/hw/core/cpu-common.c
@@ -27,6 +27,7 @@
 #include "qemu/main-loop.h"
 #include "exec/log.h"
 #include "exec/cpu-common.h"
+#include "exec/tb-flush.h"
 #include "qemu/error-report.h"
 #include "qemu/qemu-print.h"
 #include "sysemu/tcg.h"
diff --git a/plugins/core.c b/plugins/core.c
index fcd33a2bff..49588285dd 100644
--- a/plugins/core.c
+++ b/plugins/core.c
@@ -21,7 +21,6 @@
 #include "qemu/xxhash.h"
 #include "qemu/rcu.h"
 #include "hw/core/cpu.h"
-#include "exec/cpu-common.h"
 
 #include "exec/exec-all.h"
 #include "exec/tb-flush.h"
-- 
2.41.0


