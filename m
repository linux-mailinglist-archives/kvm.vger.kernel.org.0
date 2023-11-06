Return-Path: <kvm+bounces-684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A861D7E1F49
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:05:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D85CE1C209E4
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:05:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4CF31EB2F;
	Mon,  6 Nov 2023 11:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AA4+XnlG"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122681C6A3
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:05:28 +0000 (UTC)
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4141B2
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:05:26 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id ffacd0b85a97d-32fb95dfe99so1770946f8f.2
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:05:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268724; x=1699873524; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JXuP88BtphoINz4Bov6u/pkpdXdezQqYli4OVAIpAZI=;
        b=AA4+XnlG3554s1bGa/aRay++tHiJE7gwBegIEQmofQcGxfg1pLrrI7cw8Uk2Ly/J61
         HXkjTwvmhB4YqCIRa3kX2prP9CQjgesrPXrBjN5HMli1BgK5XOIT9PGsoJwzh935tKCm
         dn8Oe7Tn4Vum8OeyL77+LFxxZyYTD+xJXK8jy8tjNECGRbsKPuWr5KK8bRP6J0p5EDIR
         9YP1iigkg1CKyi+W2ZoNtdJsmaNVG17blsoThWjvE4HfpLjwolM4j0NrNZYqqMzND3+3
         /LADfVJ5DbI/xyWUPy6LybSWXn65C4zRDyv3fvH6QLrAmopU2MviwF8U+tfPl5OwcJ1S
         cVRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268724; x=1699873524;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JXuP88BtphoINz4Bov6u/pkpdXdezQqYli4OVAIpAZI=;
        b=dhWFXH/r0Ur+7pxwh1E5nLrwP9KfsT5xJ9kLjmbBJovEJGQQoPzFVUt95ulx5C/FK6
         rGLbMzBM6NbLfkpdnR/DL6noSQSHA/QOlS6egEXCjO4NdIwNOmTTIG2djZNGAT6rMNge
         LMp/IJowIWb2zpQh7XPIWs8dSeLHHJIy+5/EWy9FBMCzLCClRx9/RJFFLE+x+qo3zjj8
         WB/m7sm+7xXp1re0A1qHQqdzn2UPADfmFgYQAeE/XihMErrfMLGR7RRsiLtBkJ09Nme9
         KVuJTwD1LgGubcj2onGl6YacSu/FqGadDQTVlqBlI3pr46QlG4Z2rvsSpCIgoQsrItcH
         3YyQ==
X-Gm-Message-State: AOJu0YxRKpjbf/UVdsXwW6P+A2j6VpSmpw93V09ChFkW687g9nkUwC2O
	4+mNDZl4CCDCwV+bw1SZ3DRlxA==
X-Google-Smtp-Source: AGHT+IHaBHUQklVP9Pu5QT4vT7r66jTjw7Yf4RVyFH1CKsmkdCj1+2Bfzei9MwaofGzJpViR1lgQOw==
X-Received: by 2002:adf:e6c4:0:b0:32f:adaf:be86 with SMTP id y4-20020adfe6c4000000b0032fadafbe86mr8820884wrm.16.1699268724027;
        Mon, 06 Nov 2023 03:05:24 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id f6-20020a5d5686000000b0032f7eaa6e43sm9161653wrv.79.2023.11.06.03.05.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:05:23 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-s390x@nongnu.org,
	qemu-block@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Song Gao <gaosong@loongson.cn>,
	Richard Henderson <richard.henderson@linaro.org>
Subject: [PULL 15/60] target/loongarch: Declare QOM definitions in 'cpu-qom.h'
Date: Mon,  6 Nov 2023 12:02:47 +0100
Message-ID: <20231106110336.358-16-philmd@linaro.org>
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

Reviewed-by: Song Gao <gaosong@loongson.cn>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20231013140116.255-9-philmd@linaro.org>
---
 target/loongarch/cpu-qom.h | 24 ++++++++++++++++++++++++
 target/loongarch/cpu.h     | 10 +---------
 2 files changed, 25 insertions(+), 9 deletions(-)
 create mode 100644 target/loongarch/cpu-qom.h

diff --git a/target/loongarch/cpu-qom.h b/target/loongarch/cpu-qom.h
new file mode 100644
index 0000000000..82c86d146d
--- /dev/null
+++ b/target/loongarch/cpu-qom.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * QEMU LoongArch CPU QOM header (target agnostic)
+ *
+ * Copyright (c) 2021 Loongson Technology Corporation Limited
+ */
+
+#ifndef LOONGARCH_CPU_QOM_H
+#define LOONGARCH_CPU_QOM_H
+
+#include "hw/core/cpu.h"
+#include "qom/object.h"
+
+#define TYPE_LOONGARCH_CPU "loongarch-cpu"
+#define TYPE_LOONGARCH32_CPU "loongarch32-cpu"
+#define TYPE_LOONGARCH64_CPU "loongarch64-cpu"
+
+OBJECT_DECLARE_CPU_TYPE(LoongArchCPU, LoongArchCPUClass,
+                        LOONGARCH_CPU)
+
+#define LOONGARCH_CPU_TYPE_SUFFIX "-" TYPE_LOONGARCH_CPU
+#define LOONGARCH_CPU_TYPE_NAME(model) model LOONGARCH_CPU_TYPE_SUFFIX
+
+#endif
diff --git a/target/loongarch/cpu.h b/target/loongarch/cpu.h
index 8f0e9f0182..c8839f4cff 100644
--- a/target/loongarch/cpu.h
+++ b/target/loongarch/cpu.h
@@ -17,6 +17,7 @@
 #include "exec/memory.h"
 #endif
 #include "cpu-csr.h"
+#include "cpu-qom.h"
 
 #define IOCSRF_TEMP             0
 #define IOCSRF_NODECNT          1
@@ -381,13 +382,6 @@ struct ArchCPU {
     const char *dtb_compatible;
 };
 
-#define TYPE_LOONGARCH_CPU "loongarch-cpu"
-#define TYPE_LOONGARCH32_CPU "loongarch32-cpu"
-#define TYPE_LOONGARCH64_CPU "loongarch64-cpu"
-
-OBJECT_DECLARE_CPU_TYPE(LoongArchCPU, LoongArchCPUClass,
-                        LOONGARCH_CPU)
-
 /**
  * LoongArchCPUClass:
  * @parent_realize: The parent class' realize handler.
@@ -478,8 +472,6 @@ void loongarch_cpu_list(void);
 
 #include "exec/cpu-all.h"
 
-#define LOONGARCH_CPU_TYPE_SUFFIX "-" TYPE_LOONGARCH_CPU
-#define LOONGARCH_CPU_TYPE_NAME(model) model LOONGARCH_CPU_TYPE_SUFFIX
 #define CPU_RESOLVING_TYPE TYPE_LOONGARCH_CPU
 
 #endif /* LOONGARCH_CPU_H */
-- 
2.41.0


