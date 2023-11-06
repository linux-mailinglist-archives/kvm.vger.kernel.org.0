Return-Path: <kvm+bounces-694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FF887E1F5E
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:06:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 519601C20BE5
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:06:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 482561EB38;
	Mon,  6 Nov 2023 11:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LYqeAQJm"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC591EB29
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:06:36 +0000 (UTC)
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF2E134
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:06:34 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-9d242846194so625427766b.1
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:06:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268793; x=1699873593; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QkEvU4QtX35g0CiL+rllnKg5EMCBRsMDB6Gavwvy6mM=;
        b=LYqeAQJm1XfhxGwOB9+/SQQ+km8H2IRwZ+n0Ff2kNDpGGoRvc4+tfxFcKe4PEnJSpZ
         L7/YsRNLF3z6uaVHzeOC0GslLuWrVc28RE5P9vMGaJraDcZXxaNgAEB8DzgRRvwudX3d
         uDgLiWEOa9IE8oqS3dvs7AlmH3tXcQGLpliIcIHvBcGv9QyX0bsiuDvZgmzdO5NBoucz
         imG++sABAhRuFM3AErjcOykMWGeI+akYtlKVYd+BGQu0w4ItJLerIbIAFkLsfFzbgYyr
         P9QziHkDLgJFMyZxbhwCKyjasn7QXD7SLrZAyQy/FUv+zFGscB0wA6IvqBnBEA1AHFha
         wqJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268793; x=1699873593;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QkEvU4QtX35g0CiL+rllnKg5EMCBRsMDB6Gavwvy6mM=;
        b=EsBOcngBlHd9CycL15oFem+7Tk6GQeZVz8aZ+gKyqYSsvcBifRYKz2QFXOdAq1fAlN
         celE4PGKUWFp2qI9OD9koyD08up76VzK/ruDCyjlQa5sMtOFzzjMKxvbrfeoQDXeXrSC
         +KItpgFII3i6HtYrxgwxGoMZRY3jQrxhFj000cUv+iC4Vk6ahD0HGexoMyVA4CnplbVF
         Fdi0ke35S9RYjc5psZwcGl63Yf6hBu/V2eQ5hxW0Fl074HasusOuQpVh2CsAxH0BQ7+M
         ApbPb3WFOvwwvrITPFbwV3ihwXMo4K1j7VCR5OO0tu4BZV7NXrqsjOBLJTTTUchSE9ko
         +qEw==
X-Gm-Message-State: AOJu0YyK0IYE7fpc+Xhv//IEBpT7ZNEaHc+K7k+iQFNFZSqgGpKXNnYe
	OxV1jEH2ohb2JZLnpyv0Nlpnfrt8pkFNUNvY4qE=
X-Google-Smtp-Source: AGHT+IFMgW1bfJ6Ek6vHroNC5F5c731oGSUYMxBHstbBSE+tYzXzXN3ikXIqjnIkkxPWlLbFWPB2pQ==
X-Received: by 2002:a17:907:2ce2:b0:9be:36c2:162 with SMTP id hz2-20020a1709072ce200b009be36c20162mr13367612ejc.31.1699268793032;
        Mon, 06 Nov 2023 03:06:33 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id iv12-20020a05600c548c00b0040641a9d49bsm11948176wmb.17.2023.11.06.03.06.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:06:32 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-s390x@nongnu.org,
	qemu-block@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Cameron Esfahani <dirty@apple.com>,
	Roman Bolshakov <rbolshakov@ddn.com>
Subject: [PULL 25/60] target/i386/hvf: Use CPUState typedef
Date: Mon,  6 Nov 2023 12:02:57 +0100
Message-ID: <20231106110336.358-26-philmd@linaro.org>
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

Follow C style guidelines and use CPUState forward
declaration from "qemu/typedefs.h".

No functional changes.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Message-Id: <20231020111136.44401-2-philmd@linaro.org>
---
 target/i386/hvf/x86_emu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/target/i386/hvf/x86_emu.c b/target/i386/hvf/x86_emu.c
index b1f8a685d1..cd7ef30126 100644
--- a/target/i386/hvf/x86_emu.c
+++ b/target/i386/hvf/x86_emu.c
@@ -45,7 +45,7 @@
 #include "vmcs.h"
 #include "vmx.h"
 
-void hvf_handle_io(struct CPUState *cpu, uint16_t port, void *data,
+void hvf_handle_io(CPUState *cpu, uint16_t port, void *data,
                    int direction, int size, uint32_t count);
 
 #define EXEC_2OP_FLAGS_CMD(env, decode, cmd, FLAGS_FUNC, save_res) \
@@ -1417,7 +1417,7 @@ static void init_cmd_handler()
     }
 }
 
-void load_regs(struct CPUState *cpu)
+void load_regs(CPUState *cpu)
 {
     X86CPU *x86_cpu = X86_CPU(cpu);
     CPUX86State *env = &x86_cpu->env;
@@ -1440,7 +1440,7 @@ void load_regs(struct CPUState *cpu)
     env->eip = rreg(cpu->accel->fd, HV_X86_RIP);
 }
 
-void store_regs(struct CPUState *cpu)
+void store_regs(CPUState *cpu)
 {
     X86CPU *x86_cpu = X86_CPU(cpu);
     CPUX86State *env = &x86_cpu->env;
-- 
2.41.0


