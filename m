Return-Path: <kvm+bounces-705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6ABC27E1F7D
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:08:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A6A31C20B8D
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:08:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FF261EB55;
	Mon,  6 Nov 2023 11:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="z43JXbHH"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E711EB39
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:07:48 +0000 (UTC)
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F4D123
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:07:46 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-40891d38e3fso30632525e9.1
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:07:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268865; x=1699873665; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=95fjXxwoCEM5MPpLzleCUNmgt+EGYy9i69c6BsnNRfk=;
        b=z43JXbHHlKFbOubTUOoUCrRLBbX8i0hv8qPD+KqlgC1Cj2as9T79PKiAchSEv1q7Ib
         hInIIyPfDLyhlOHFHZVhQf8ayAw94IsVlrdlcvBOGcDCfPKAZ7PUaiGFDy6CK/7lhb/p
         35p3h5ugMmIsp20avrotb9IyoRkM6l14dj1Ag/Tk6e+E2BquDe8MMnW6utP7jJIitBvp
         nORknrmIIH73JiDauubZPsikvclLDtABnvjsvW7FzUSCYb2kcIvO5w7HytZwgNgSZ3Rb
         EK7pCEk2wdsVHfa3uTStIRjzh6IWbRxLHCOvP34qgZQWtZcOnzeovu+0xtILhKN0PdQW
         k2cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268865; x=1699873665;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=95fjXxwoCEM5MPpLzleCUNmgt+EGYy9i69c6BsnNRfk=;
        b=DMXMiBe2IFgwDugW25MF/1UYdf1LMbNb38djEwwMuLDWoLR9QRGJEHNy8zh/HQkw7T
         LXE7xctbmXInBwMPz/C0dM/ubY9xDtrH3wXsYXTGEKXM1m8gQEmycB6he5nREp295ZC2
         5qRqBEt/v8BReFQfc8nVVhcSCf6afjSKqdEl2Z7UMSrLARXI0rN0h4mgL+z0d5o6XfKN
         0+5kOxP0jkLv4lAV6to0TXxwpqeeTeUR+AIc70LUnij9Z1psHih18oD2zgpFVbLMIRgo
         0irFy1L/ap7KzUGLtR7XQh+OnaTmK8zJP61oTnR+TDried/VLeRtVlPWZ0cj2+q/LjLa
         /5JA==
X-Gm-Message-State: AOJu0YzxX6b1u1cS7P12ljCKUDrAQZFFZLrv3S9igNjZDUSXWJu0Oj76
	LYJAGatSdlLmCNbDUM3fs9bBboBw9/LoAXlkfQA=
X-Google-Smtp-Source: AGHT+IFA2chfzU/RG3fUnF9L1zuwbrR/mZ3//aX7n36RLMNo0C4jCT70SUW9S7M0scEuKtQWCV9uyw==
X-Received: by 2002:a05:600c:4c9a:b0:409:57ec:9d7e with SMTP id g26-20020a05600c4c9a00b0040957ec9d7emr13786805wmp.21.1699268865155;
        Mon, 06 Nov 2023 03:07:45 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id f20-20020a05600c43d400b003fbe4cecc3bsm11518827wmn.16.2023.11.06.03.07.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:07:44 -0800 (PST)
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
Subject: [PULL 36/60] target/nios2: Create IRQs *after* accelerator vCPU is realized
Date: Mon,  6 Nov 2023 12:03:08 +0100
Message-ID: <20231106110336.358-37-philmd@linaro.org>
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

Architecture specific hardware doesn't have a particular dependency
on the accelerator vCPU (created with cpu_exec_realizefn), and can
be initialized *after* the vCPU is realized. Doing so allows further
generic API simplification (in few commits).

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20230918160257.30127-12-philmd@linaro.org>
---
 target/nios2/cpu.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/target/nios2/cpu.c b/target/nios2/cpu.c
index 15e499f828..a27732bf2b 100644
--- a/target/nios2/cpu.c
+++ b/target/nios2/cpu.c
@@ -199,14 +199,6 @@ static void nios2_cpu_realizefn(DeviceState *dev, Error **errp)
     Nios2CPUClass *ncc = NIOS2_CPU_GET_CLASS(dev);
     Error *local_err = NULL;
 
-#ifndef CONFIG_USER_ONLY
-    if (cpu->eic_present) {
-        qdev_init_gpio_in_named(DEVICE(cpu), eic_set_irq, "EIC", 1);
-    } else {
-        qdev_init_gpio_in_named(DEVICE(cpu), iic_set_irq, "IRQ", 32);
-    }
-#endif
-
     cpu_exec_realizefn(cs, &local_err);
     if (local_err != NULL) {
         error_propagate(errp, local_err);
@@ -220,6 +212,14 @@ static void nios2_cpu_realizefn(DeviceState *dev, Error **errp)
     /* We have reserved storage for cpuid; might as well use it. */
     cpu->env.ctrl[CR_CPUID] = cs->cpu_index;
 
+#ifndef CONFIG_USER_ONLY
+    if (cpu->eic_present) {
+        qdev_init_gpio_in_named(DEVICE(cpu), eic_set_irq, "EIC", 1);
+    } else {
+        qdev_init_gpio_in_named(DEVICE(cpu), iic_set_irq, "IRQ", 32);
+    }
+#endif
+
     ncc->parent_realize(dev, errp);
 }
 
-- 
2.41.0


