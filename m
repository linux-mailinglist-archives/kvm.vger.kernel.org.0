Return-Path: <kvm+bounces-681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CDDA7E1F45
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:05:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9CDB3281034
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:05:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07A061A5BB;
	Mon,  6 Nov 2023 11:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YVnYOCXg"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5529F1A598
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:05:05 +0000 (UTC)
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D4298
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:05:04 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-4081ccf69dcso31167025e9.0
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:05:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268702; x=1699873502; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RkZROkW3VJc36/l321YGkxp/mj9LkNXWejNsMfklYm4=;
        b=YVnYOCXgDyvghTY2UF9oGvYb3nezSSWAdUnQHIS/fnUNqSdQqX6lubupYGznln3fJL
         9dslcbraBXZwlsllN9GHsdY/N2IhJWZJ+0dxR7Z6s3R4gFGTXP17AzFljDqbOwy8D+28
         ZfVsgLzxbgM24v0/q6bX1Tvh07dJM+nO1t7MYbVRG2sy1dUWCnY97afVnaiguS5aDPjZ
         hz4APexPWcfCmt7Sm0tK1KbplZuA94CcFHvkM2x10a59E4U4KjzsuCgmQAP8JwhQj8Da
         MX5Jye6QnyA/9sibpNJDaMQENlI9KAac1Go6uVlSBo1pyN2s7xrVK86bzxgI1S2mxhde
         0oJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268702; x=1699873502;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RkZROkW3VJc36/l321YGkxp/mj9LkNXWejNsMfklYm4=;
        b=Yuh589YnJ6a6SQ0dD0ED5L1++Tosg7NANZVxiYS2E5wBMf4XMVvMMZPutA4ziK4lHM
         kA+Nh6fmVc/AGWvh0qrZzhcxlh4jxazQGYCqPCpN+wxn1lghsLFRSfevmr4Na/wzrwBr
         bfJK6Zrzr9sSB0+J/K5xzBzp96lcVZ8VtVwfjLy3RvvJkCbdySUCFgCVm1UUbaw1yAft
         3Xxe/j5TMSRFmnkxCrS6mu+NAiqzt9FGul2Tf2mMVWWOXZFlda/m2ej3cYfOIZ1E4vyb
         k3fzNTS3XNS1pVRBgVswcLQBnOnl8RJ/zeyHA9Lw1kjZGJ+ad3TASMqgiZCb5GDA3ew0
         81og==
X-Gm-Message-State: AOJu0YyuqRmoba6Fzge4uQ6kcTpWLKbTUAgHxOE6yUzpIVnd3T3Y54n1
	3XpyFu3EU/PPMyB0Ju11r9lwN82Vbfo6r8guxrA=
X-Google-Smtp-Source: AGHT+IGPi0CoBElw4e4e166oDDPnxqGeqjewSbN0jbUXOO8Wcvzxylrv4M0+O34JS3v7Ej+kyRAkyA==
X-Received: by 2002:a05:6000:1845:b0:32d:a431:9045 with SMTP id c5-20020a056000184500b0032da4319045mr10462910wri.30.1699268702575;
        Mon, 06 Nov 2023 03:05:02 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id k9-20020a056000004900b0032dbf26e7aesm8956250wrx.65.2023.11.06.03.05.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:05:02 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-s390x@nongnu.org,
	qemu-block@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	LIU Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Bin Meng <bin.meng@windriver.com>,
	Weiwei Li <liweiwei@iscas.ac.cn>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PULL 12/60] target/riscv: Remove CPU_RESOLVING_TYPE from 'cpu-qom.h'
Date: Mon,  6 Nov 2023 12:02:44 +0100
Message-ID: <20231106110336.358-13-philmd@linaro.org>
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

CPU_RESOLVING_TYPE is a per-target definition, and is
irrelevant for other targets. Move it to "cpu.h".

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: LIU Zhiwei <zhiwei_liu@linux.alibaba.com>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20231013140116.255-6-philmd@linaro.org>
---
 target/riscv/cpu-qom.h | 1 -
 target/riscv/cpu.h     | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/target/riscv/cpu-qom.h b/target/riscv/cpu-qom.h
index b9164a8e5b..b78169093f 100644
--- a/target/riscv/cpu-qom.h
+++ b/target/riscv/cpu-qom.h
@@ -27,7 +27,6 @@
 
 #define RISCV_CPU_TYPE_SUFFIX "-" TYPE_RISCV_CPU
 #define RISCV_CPU_TYPE_NAME(name) (name RISCV_CPU_TYPE_SUFFIX)
-#define CPU_RESOLVING_TYPE TYPE_RISCV_CPU
 
 #define TYPE_RISCV_CPU_ANY              RISCV_CPU_TYPE_NAME("any")
 #define TYPE_RISCV_CPU_MAX              RISCV_CPU_TYPE_NAME("max")
diff --git a/target/riscv/cpu.h b/target/riscv/cpu.h
index f0dc257a75..144cc94cce 100644
--- a/target/riscv/cpu.h
+++ b/target/riscv/cpu.h
@@ -32,6 +32,8 @@
 #include "qapi/qapi-types-common.h"
 #include "cpu-qom.h"
 
+#define CPU_RESOLVING_TYPE TYPE_RISCV_CPU
+
 #define TCG_GUEST_DEFAULT_MO 0
 
 /*
-- 
2.41.0


