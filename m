Return-Path: <kvm+bounces-686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A8467E1F4D
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:05:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7ADB51C20BAA
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:05:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ED091EB33;
	Mon,  6 Nov 2023 11:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qXZxcmIx"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1141EB2B
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:05:40 +0000 (UTC)
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F928FA
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:05:39 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id 38308e7fff4ca-2c6b30aca06so57567861fa.3
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:05:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268737; x=1699873537; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nk4cWXrgP2wfdX8K07cLqFbkIit3uK5saNqg4nYpY5E=;
        b=qXZxcmIxIknONPXiTdWztlKpbDT4lQyZjS4qRtDjn25MfmK83TJy12PYN7UMMPjjp0
         jlxCtbN2p1a8gt4riB+Vvv4734wKq1qNH1FaaPFNmO+93TayfifFqyXp9Se9tVHOlFXs
         zQclrfoTTky8Rc2V5WQNBJfmT7K5oD0r81Jr5wKyuoUn6WVYLRmr7RyL5jaMe8D2wzKP
         45oHVkEVj/i6LROd15gJjxODppp0dB8DnPnbk6QvXYhI/VNDUnRzTXz41umhuELkB3JM
         BCTpYjOoUCHh2qZjPdMi2iVn7px3wnIP+UPoIJTzDO+EijV6E8GvRH4jK5LUcwYNojF+
         tjmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268737; x=1699873537;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nk4cWXrgP2wfdX8K07cLqFbkIit3uK5saNqg4nYpY5E=;
        b=Zld+WXus7ebUVRHP7HDW3J9qMG9k2aX0iXERXoMsKCR4YH0QWlhfOS/IooXsPnIPgi
         XYoZXrexnU2VMQZTxxxlok3P2UQp3EkrvCpA0P0VDrBwH+S2AXOs0aNhwYjw+0FU7a6A
         A0E+R08IePeXKPUMLqbb37snlhKPbdnfnkak8tXrULURS41a6d4F/yih9b7izZEdpF2l
         v5SGMGi7ZomIx1h84ISnYxTvFrLMGkzfJwJk2OQflXrfVkkcRuG5UZmSkzUqKYT9H/k+
         HtP+Lj2UX5GBFYgFDZ0uL65kR9RERaA0zuxw3rKBiUUlLAi9AZv4KhVhpL1+rKd+BBLN
         Z9hw==
X-Gm-Message-State: AOJu0YwC0DEs0/2AUuQO883AGLIWHj3qzIEETndTqHXLFcaHH2sZ1TWA
	sGrVMm5wKMJTf1TiiQTmOgq27w==
X-Google-Smtp-Source: AGHT+IHKiC1CxF8T0vSr2BLcywa6c3PPTVgxII/mK+f6zwidK7EflGt0iUFCbELVhD20Vx3Mom76tg==
X-Received: by 2002:a2e:9cc6:0:b0:2c5:1bd3:5657 with SMTP id g6-20020a2e9cc6000000b002c51bd35657mr22787612ljj.15.1699268737741;
        Mon, 06 Nov 2023 03:05:37 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id o13-20020a05600c4fcd00b0040588d85b3asm11817685wmq.15.2023.11.06.03.05.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:05:37 -0800 (PST)
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
	Stafford Horne <shorne@gmail.com>
Subject: [PULL 17/60] target/openrisc: Declare QOM definitions in 'cpu-qom.h'
Date: Mon,  6 Nov 2023 12:02:49 +0100
Message-ID: <20231106110336.358-18-philmd@linaro.org>
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

"target/foo/cpu.h" contains the target specific declarations.

A heterogeneous setup need to access target agnostic declarations
(at least the QOM ones, to instantiate the objects).

Our convention is to add such target agnostic QOM declarations in
the "target/foo/cpu-qom.h" header.
Add a comment clarifying that in the header.

Extract QOM definitions from "cpu.h" to "cpu-qom.h".

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20231013140116.255-11-philmd@linaro.org>
---
 target/openrisc/cpu-qom.h | 22 ++++++++++++++++++++++
 target/openrisc/cpu.h     | 10 +---------
 2 files changed, 23 insertions(+), 9 deletions(-)
 create mode 100644 target/openrisc/cpu-qom.h

diff --git a/target/openrisc/cpu-qom.h b/target/openrisc/cpu-qom.h
new file mode 100644
index 0000000000..1ba9fb0a4c
--- /dev/null
+++ b/target/openrisc/cpu-qom.h
@@ -0,0 +1,22 @@
+/*
+ * QEMU OpenRISC CPU QOM header (target agnostic)
+ *
+ * Copyright (c) 2011-2012 Jia Liu <proljc@gmail.com>
+ *
+ * SPDX-License-Identifier: LGPL-2.1-or-later
+ */
+
+#ifndef QEMU_OPENRISC_CPU_QOM_H
+#define QEMU_OPENRISC_CPU_QOM_H
+
+#include "hw/core/cpu.h"
+#include "qom/object.h"
+
+#define TYPE_OPENRISC_CPU "or1k-cpu"
+
+OBJECT_DECLARE_CPU_TYPE(OpenRISCCPU, OpenRISCCPUClass, OPENRISC_CPU)
+
+#define OPENRISC_CPU_TYPE_SUFFIX "-" TYPE_OPENRISC_CPU
+#define OPENRISC_CPU_TYPE_NAME(model) model OPENRISC_CPU_TYPE_SUFFIX
+
+#endif
diff --git a/target/openrisc/cpu.h b/target/openrisc/cpu.h
index 29cda7279c..dedeb89f8e 100644
--- a/target/openrisc/cpu.h
+++ b/target/openrisc/cpu.h
@@ -20,17 +20,12 @@
 #ifndef OPENRISC_CPU_H
 #define OPENRISC_CPU_H
 
+#include "cpu-qom.h"
 #include "exec/cpu-defs.h"
 #include "fpu/softfloat-types.h"
-#include "hw/core/cpu.h"
-#include "qom/object.h"
 
 #define TCG_GUEST_DEFAULT_MO (0)
 
-#define TYPE_OPENRISC_CPU "or1k-cpu"
-
-OBJECT_DECLARE_CPU_TYPE(OpenRISCCPU, OpenRISCCPUClass, OPENRISC_CPU)
-
 /**
  * OpenRISCCPUClass:
  * @parent_realize: The parent class' realize handler.
@@ -304,7 +299,6 @@ struct ArchCPU {
     CPUOpenRISCState env;
 };
 
-
 void cpu_openrisc_list(void);
 void openrisc_cpu_dump_state(CPUState *cpu, FILE *f, int flags);
 int openrisc_cpu_gdb_read_register(CPUState *cpu, GByteArray *buf, int reg);
@@ -339,8 +333,6 @@ void cpu_openrisc_count_start(OpenRISCCPU *cpu);
 void cpu_openrisc_count_stop(OpenRISCCPU *cpu);
 #endif
 
-#define OPENRISC_CPU_TYPE_SUFFIX "-" TYPE_OPENRISC_CPU
-#define OPENRISC_CPU_TYPE_NAME(model) model OPENRISC_CPU_TYPE_SUFFIX
 #define CPU_RESOLVING_TYPE TYPE_OPENRISC_CPU
 
 #include "exec/cpu-all.h"
-- 
2.41.0


