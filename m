Return-Path: <kvm+bounces-688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E32287E1F53
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:06:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 73F35B21A9F
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:06:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9F641EB2C;
	Mon,  6 Nov 2023 11:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qgJaTLaQ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016121EB2E
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:05:55 +0000 (UTC)
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC58BB
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:05:53 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-40806e4106dso25960585e9.1
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268752; x=1699873552; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oZ4xqFJalLvpzsW1bcHeUL/13mhLi/mzZSAy+mux2v0=;
        b=qgJaTLaQnrF3FRlgM4dnO8rJSYudacBS92LDmwzpG+ypHUqJwMoi3888ND13yqBoA1
         sYVX+pUta4zAHUwNDcNChP+t5DPb0oRB3rxErfi3YovWPL+hscsg6HiCo6xLzEqImgrE
         XAeYuLBjKdLKlRu2e/WJI0XVU75dnBKfBCZw4krSdKPwV+wBk5PhAyiuM7ueCfxD956e
         5hk8UEgod73sYlBc8Xysb5MrU2xaxCP7i5n44Bxt9IUBHOANR3i0vz0bZM+5QKT6oTE+
         WaxDlcbxQZj9Ma6/tWXHSw5CdPn/oa3iY9SDrm6MIKpcYVWl2yJuM6toGH+ZtGLxjOTQ
         nTUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268752; x=1699873552;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oZ4xqFJalLvpzsW1bcHeUL/13mhLi/mzZSAy+mux2v0=;
        b=fOptc41xguXY8RPNQ9hLigdj1z2ZvS7q4NoQqkQ03Z86QBJwRMBBRb3THBhEgaBavP
         +LUMLc2O9rYNZxSwRq2QbZWdDPAHUGbIuGzFSng7nHr0bLk44U00j4XSQ1I7WTd9Kkv6
         yMnKg3D10uv4zHcEvu9bR38XTQ3WKwqDWPuL5SsV95c8XFsyFtOgVbRPrRtABHgpaXCC
         iLt0d9eppbbNHEiwf6ZqBueuvy3cF0JB3FXeHBkgrOAl4joUjwAdg4Sa9gfDyFBkPqEC
         Ue8dV5IHqBxhqqDpn9Uel00dA7vlJq+56UPa/LH+L6xO/GuQkIbk6PW5yavhClGF+ywX
         vA7A==
X-Gm-Message-State: AOJu0YxPaEjIxU+j8cuEj8c5XahdS5Lxxlpu97Oin3FTDgdSJVqnUXel
	Bm7gAxlmAgzVEfuke9ICatsLkA==
X-Google-Smtp-Source: AGHT+IG9mJw0F90hy4Uu6xuSpQrJC5TM2lMXtp6Q5jTJMspVFVuvMPHpaiGipu7vhxIPNtgi1AXh6Q==
X-Received: by 2002:a7b:c7c9:0:b0:406:45c1:4dd with SMTP id z9-20020a7bc7c9000000b0040645c104ddmr10153754wmk.14.1699268751703;
        Mon, 06 Nov 2023 03:05:51 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id bh5-20020a05600c3d0500b004094e565e71sm12164949wmb.23.2023.11.06.03.05.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:05:51 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-s390x@nongnu.org,
	qemu-block@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Alistair Francis <alistair.francis@wdc.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
Subject: [PULL 19/60] target/ppc: Use env_archcpu() in helper_book3s_msgsndp()
Date: Mon,  6 Nov 2023 12:02:51 +0100
Message-ID: <20231106110336.358-20-philmd@linaro.org>
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

When CPUArchState* is available (here CPUPPCState*), we
can use the fast env_archcpu() macro to get ArchCPU* (here
PowerPCCPU*). The QOM cast POWERPC_CPU() macro will be
slower when building with --enable-qom-cast-debug.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Acked-by: Alistair Francis <alistair.francis@wdc.com>
Message-Id: <20231009110239.66778-2-philmd@linaro.org>
---
 target/ppc/excp_helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/ppc/excp_helper.c b/target/ppc/excp_helper.c
index 7926114d5c..a42743a3e0 100644
--- a/target/ppc/excp_helper.c
+++ b/target/ppc/excp_helper.c
@@ -3136,7 +3136,7 @@ void helper_book3s_msgclrp(CPUPPCState *env, target_ulong rb)
 void helper_book3s_msgsndp(CPUPPCState *env, target_ulong rb)
 {
     CPUState *cs = env_cpu(env);
-    PowerPCCPU *cpu = POWERPC_CPU(cs);
+    PowerPCCPU *cpu = env_archcpu(env);
     CPUState *ccs;
     uint32_t nr_threads = cs->nr_threads;
     int ttir = rb & PPC_BITMASK(57, 63);
-- 
2.41.0


