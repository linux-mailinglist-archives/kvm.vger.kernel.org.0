Return-Path: <kvm+bounces-685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D15D7E1F4C
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:05:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 76FF4B21687
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:05:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 398561EB35;
	Mon,  6 Nov 2023 11:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="d34aoMmD"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947F31EB29
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:05:34 +0000 (UTC)
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B271BB0
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:05:32 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-40859c466efso32054395e9.3
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:05:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268731; x=1699873531; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q3038rtVd/3WYQydMHaBWtXOqOEbAhMugZOF+LS9h+c=;
        b=d34aoMmDfIIMA7/5qNTponuXAvVYffTv8H7SpF3c0rO/kwnDOiKYZ9gUEZq7SkUTwQ
         NrOypUKeEpM5ZPZoKa7e7t6cpOokSxdvF1GBJFWjlkYXPdaAOqsFhFmgjk5PvYgk1ALY
         LChpsWzFJKXhCSbUOar8sehXwMfS/tvehqeH0d+gxtiF8LFkGfRvtCrBdxMPBa2pVAfU
         NMeLqfuqOKos7XYIFhGtiV5/XCprU5Jobc7GBNjbt3DIw+W+FmjmdJCz8KKP8n7VHLU6
         FMxB4mTMoL4/u34pe2qyFy4ed59GhfDNZikZJmZO9/ujgNakhX8XH+eh/ffUugy8qQ4W
         nAfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268731; x=1699873531;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q3038rtVd/3WYQydMHaBWtXOqOEbAhMugZOF+LS9h+c=;
        b=mZ2X+WxmGAf7ej8N+TE0KpGSvFSj1jRDPy5kr7AFOkSv67/qZDzCEqyVaUzsOt6P2k
         DavtswuIqCKBaBmCdryTcaB78C5IRijgjvzIdE/4iD/DSy+QdvlwInIZjwNMoLykrnRW
         cppKq9TORCaGbKs9YlCT2PAwVE5atIMHxBaNWaHiAi2BWxwxrrpwVjGo1vsPUiTyLMOE
         P3zjP1upRGY13kJajjl9xU9vM3adrwHfvUynnDS/MaWoC2/qUNN5ifoQXPyvy/ClcSVY
         ZqxaIWAIbnaXU3wXCd+UAL8A7rPoaX/Bl7P46QnvUzB5j+nFs5wcZV1CXTT6aaRPCN7J
         nemQ==
X-Gm-Message-State: AOJu0Yz9T0op3D3Vr698aQsNnCzN7ZfpAAGBuZfSaNnxWlhOPW4gukKP
	f2iQcC3F47Jf6G5Qg/OpsDB/uQ==
X-Google-Smtp-Source: AGHT+IEmOjZD5v1Cylghy37IhDMNKkapCYPdrPhk6W27hiP8WG5JpxCt9Mc0gI0+angLDuM2K899rw==
X-Received: by 2002:a05:600c:4897:b0:401:38dc:8916 with SMTP id j23-20020a05600c489700b0040138dc8916mr23234105wmp.10.1699268731199;
        Mon, 06 Nov 2023 03:05:31 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id o8-20020a05600c510800b00407752f5ab6sm12025312wms.6.2023.11.06.03.05.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:05:30 -0800 (PST)
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
	Chris Wulff <crwulff@gmail.com>,
	Marek Vasut <marex@denx.de>
Subject: [PULL 16/60] target/nios2: Declare QOM definitions in 'cpu-qom.h'
Date: Mon,  6 Nov 2023 12:02:48 +0100
Message-ID: <20231106110336.358-17-philmd@linaro.org>
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
Message-Id: <20231013140116.255-10-philmd@linaro.org>
---
 target/nios2/cpu-qom.h | 19 +++++++++++++++++++
 target/nios2/cpu.h     |  7 +------
 2 files changed, 20 insertions(+), 6 deletions(-)
 create mode 100644 target/nios2/cpu-qom.h

diff --git a/target/nios2/cpu-qom.h b/target/nios2/cpu-qom.h
new file mode 100644
index 0000000000..931bc69b10
--- /dev/null
+++ b/target/nios2/cpu-qom.h
@@ -0,0 +1,19 @@
+/*
+ * QEMU Nios II CPU QOM header (target agnostic)
+ *
+ * Copyright (c) 2012 Chris Wulff <crwulff@gmail.com>
+ *
+ * SPDX-License-Identifier: LGPL-2.1-or-later
+ */
+
+#ifndef QEMU_NIOS2_CPU_QOM_H
+#define QEMU_NIOS2_CPU_QOM_H
+
+#include "hw/core/cpu.h"
+#include "qom/object.h"
+
+#define TYPE_NIOS2_CPU "nios2-cpu"
+
+OBJECT_DECLARE_CPU_TYPE(Nios2CPU, Nios2CPUClass, NIOS2_CPU)
+
+#endif
diff --git a/target/nios2/cpu.h b/target/nios2/cpu.h
index ede1ba2140..2d79b5b298 100644
--- a/target/nios2/cpu.h
+++ b/target/nios2/cpu.h
@@ -21,20 +21,15 @@
 #ifndef NIOS2_CPU_H
 #define NIOS2_CPU_H
 
+#include "cpu-qom.h"
 #include "exec/cpu-defs.h"
-#include "hw/core/cpu.h"
 #include "hw/registerfields.h"
-#include "qom/object.h"
 
 typedef struct CPUArchState CPUNios2State;
 #if !defined(CONFIG_USER_ONLY)
 #include "mmu.h"
 #endif
 
-#define TYPE_NIOS2_CPU "nios2-cpu"
-
-OBJECT_DECLARE_CPU_TYPE(Nios2CPU, Nios2CPUClass, NIOS2_CPU)
-
 /**
  * Nios2CPUClass:
  * @parent_phases: The parent class' reset phase handlers.
-- 
2.41.0


