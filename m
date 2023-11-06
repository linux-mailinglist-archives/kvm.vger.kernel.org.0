Return-Path: <kvm+bounces-683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38AC27E1F48
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:05:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 995E1B2196D
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:05:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32EF01BDCC;
	Mon,  6 Nov 2023 11:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="N8Vy/HKw"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F351A701
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:05:20 +0000 (UTC)
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E337DB0
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:05:18 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-32fb95dfe99so1770844f8f.2
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:05:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268717; x=1699873517; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vep8ejgClIB/0OUtyRO014f5iK14K4Tf/g8eVxuuhkY=;
        b=N8Vy/HKwavdw7v7DnLLei0YcmyvuqQY+xxD/oZy1Kwkuv8OrHDV0heuKDFmAk4G4H6
         9Dm5jmp8w2Zgo4exu8CmkJRVw0p1dH3M1adyRc6ut5Rwpm/PCGkzcgyaN5QiKRRQMaBD
         MZs1vy/HZ9kSsEpdM6BbTMsrcglXWCMS2h2oBrjLDoQhnbiUAkOl/5m1dtOONRRNbD1K
         vI3v0VnWwmJG76lYC2389yfjLnr8gU9fT9zGD+O7rbpWmnE927PkmHKrZyTpqFo0Vgw3
         v462ZwMFSagE+893jhWWBIVEBMJIuOKdwcv48wVkdaxyeroNJVvA5kfWnSM1M/6i1CMw
         TyGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268717; x=1699873517;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vep8ejgClIB/0OUtyRO014f5iK14K4Tf/g8eVxuuhkY=;
        b=F4djjJrMcXfiYkJZF3CIdanrrP9pJOWeYIoTQ8Ds/tF+Wh5YZZB9qSneMPSOKrXKVI
         4hurIzmgrzLOX0DQMjhA6uWAXwyJ5TH5sACtXgeIjW5680PvZYcbIg/+cyhPBNVK63KD
         Y8dvs/qj6bllkPCpNn/FNpdErz3WUB/p1Yseazbl6xsvnNewRO3+RzY5jZRyZrNrUiCf
         /f40iqapljKKFSQQLQFq/z9wbV0mu2Z0OKEl+gVRLpT0JOy6R+tk3/HGXf9/oJ4uMxNP
         ZvIH2VnOrrKRbkYO1LH8i/07yGysNNsGXVaSMnW6l/6z0sqQoqalFXSbet/2TarXvhC/
         +W1Q==
X-Gm-Message-State: AOJu0Yz9LJQUrHqDgC0M5Vj6RifyK2MWn3K6JzNmqswtC/L4NBCLQqEr
	dFkKEdRDoSjC7KT6ouYYJwbgSg==
X-Google-Smtp-Source: AGHT+IFGvT0btHnF3YPkzx9cmFeVj8iEZzjdIY/tcCq/l6fv1iFj5XC77e6JGhJHntN6X+4R9AYh8Q==
X-Received: by 2002:a05:6000:186c:b0:32f:7a65:da64 with SMTP id d12-20020a056000186c00b0032f7a65da64mr24414146wri.65.1699268717450;
        Mon, 06 Nov 2023 03:05:17 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id l9-20020adfe589000000b0032f7d7ec4adsm9108143wrm.92.2023.11.06.03.05.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:05:17 -0800 (PST)
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
	Brian Cain <bcain@quicinc.com>
Subject: [PULL 14/60] target/hexagon: Declare QOM definitions in 'cpu-qom.h'
Date: Mon,  6 Nov 2023 12:02:46 +0100
Message-ID: <20231106110336.358-15-philmd@linaro.org>
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
Reviewed-by: Brian Cain <bcain@quicinc.com>
Message-Id: <20231013140116.255-8-philmd@linaro.org>
---
 target/hexagon/cpu-qom.h | 28 ++++++++++++++++++++++++++++
 target/hexagon/cpu.h     | 15 +--------------
 2 files changed, 29 insertions(+), 14 deletions(-)
 create mode 100644 target/hexagon/cpu-qom.h

diff --git a/target/hexagon/cpu-qom.h b/target/hexagon/cpu-qom.h
new file mode 100644
index 0000000000..f02df7ee6f
--- /dev/null
+++ b/target/hexagon/cpu-qom.h
@@ -0,0 +1,28 @@
+/*
+ * QEMU Hexagon CPU QOM header (target agnostic)
+ *
+ * Copyright(c) 2019-2023 Qualcomm Innovation Center, Inc. All Rights Reserved.
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#ifndef QEMU_HEXAGON_CPU_QOM_H
+#define QEMU_HEXAGON_CPU_QOM_H
+
+#include "hw/core/cpu.h"
+#include "qom/object.h"
+
+#define TYPE_HEXAGON_CPU "hexagon-cpu"
+
+#define HEXAGON_CPU_TYPE_SUFFIX "-" TYPE_HEXAGON_CPU
+#define HEXAGON_CPU_TYPE_NAME(name) (name HEXAGON_CPU_TYPE_SUFFIX)
+
+#define TYPE_HEXAGON_CPU_V67 HEXAGON_CPU_TYPE_NAME("v67")
+#define TYPE_HEXAGON_CPU_V68 HEXAGON_CPU_TYPE_NAME("v68")
+#define TYPE_HEXAGON_CPU_V69 HEXAGON_CPU_TYPE_NAME("v69")
+#define TYPE_HEXAGON_CPU_V71 HEXAGON_CPU_TYPE_NAME("v71")
+#define TYPE_HEXAGON_CPU_V73 HEXAGON_CPU_TYPE_NAME("v73")
+
+OBJECT_DECLARE_CPU_TYPE(HexagonCPU, HexagonCPUClass, HEXAGON_CPU)
+
+#endif
diff --git a/target/hexagon/cpu.h b/target/hexagon/cpu.h
index 035ac4fb6d..7d16083c6a 100644
--- a/target/hexagon/cpu.h
+++ b/target/hexagon/cpu.h
@@ -20,11 +20,10 @@
 
 #include "fpu/softfloat-types.h"
 
+#include "cpu-qom.h"
 #include "exec/cpu-defs.h"
 #include "hex_regs.h"
 #include "mmvec/mmvec.h"
-#include "qom/object.h"
-#include "hw/core/cpu.h"
 #include "hw/registerfields.h"
 
 #define NUM_PREGS 4
@@ -36,18 +35,8 @@
 #define PRED_WRITES_MAX 5                   /* 4 insns + endloop */
 #define VSTORES_MAX 2
 
-#define TYPE_HEXAGON_CPU "hexagon-cpu"
-
-#define HEXAGON_CPU_TYPE_SUFFIX "-" TYPE_HEXAGON_CPU
-#define HEXAGON_CPU_TYPE_NAME(name) (name HEXAGON_CPU_TYPE_SUFFIX)
 #define CPU_RESOLVING_TYPE TYPE_HEXAGON_CPU
 
-#define TYPE_HEXAGON_CPU_V67 HEXAGON_CPU_TYPE_NAME("v67")
-#define TYPE_HEXAGON_CPU_V68 HEXAGON_CPU_TYPE_NAME("v68")
-#define TYPE_HEXAGON_CPU_V69 HEXAGON_CPU_TYPE_NAME("v69")
-#define TYPE_HEXAGON_CPU_V71 HEXAGON_CPU_TYPE_NAME("v71")
-#define TYPE_HEXAGON_CPU_V73 HEXAGON_CPU_TYPE_NAME("v73")
-
 void hexagon_cpu_list(void);
 #define cpu_list hexagon_cpu_list
 
@@ -127,8 +116,6 @@ typedef struct CPUArchState {
     VTCMStoreLog vtcm_log;
 } CPUHexagonState;
 
-OBJECT_DECLARE_CPU_TYPE(HexagonCPU, HexagonCPUClass, HEXAGON_CPU)
-
 typedef struct HexagonCPUClass {
     CPUClass parent_class;
 
-- 
2.41.0


