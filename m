Return-Path: <kvm+bounces-680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 934F97E1F44
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:05:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4C3F1C20B49
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:05:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 841BF1A28A;
	Mon,  6 Nov 2023 11:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QIG1oeoY"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1273199A7
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:04:58 +0000 (UTC)
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5CD98
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:04:57 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-5094cb3a036so5224991e87.2
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:04:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268696; x=1699873496; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vePePWiaVFUAUv821iwYutEeShxemZReiuwQp7UFnAo=;
        b=QIG1oeoYYiMyDF8MK5Kh2mQKLT0xhZ/c00lDbEnRoa/CsDQZ+swg4IUmwa7lsR1d+P
         SQ0JikYTKJ+J9VfS4F3DF3cUBMq25QUQp9nn8OQgnBAutLMVIFAgnfp90zIjGqw2br/4
         Vx7XagEOnhtGQwA11s+hGLiueF6UYLsuEGqYlTeJLmvkz58dt7qO8wEXnMqFgzMwoSu8
         mPKi9MQGg5j5aSLhEmNdd4Zf5i6EXWyMStqEfCvc97gHPHOsMpNhAWAOYzLvJio3YfKw
         wKQlD3mHDtlo3r/ffRxFWBRUQNpCSG/6TZMLbFo9rpf5tfrjmOnKAiEPuevW3ZMen198
         OkQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268696; x=1699873496;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vePePWiaVFUAUv821iwYutEeShxemZReiuwQp7UFnAo=;
        b=MseNM+Spn4b1wbKo7o28Z0TlnRV/Rylw5grr92pqVxbgWSSKeiWMoxeHxwWaN/5365
         Qq7wV4tiKJkzYJ4DAAh0YHkkmzIq4DNwew82rmcmWlM4ankBI72KtZ3dlIFill2ktlpY
         fjKd+5C9VEfybjOogy4zzSbQkODeuZ1nMBebVsAtBlJkjSRrZ4KmwDZvjZcQ/mQsACKy
         SQqrkj0XAA1K4LqBHN5sX0rNJ2Fo/nO4EcGsH9iSu1IsYqQWB9zz7YdcF93xl8IXP8za
         C7OerxBxfT879iY5aGUbxMIliclDF6JkoNbAmZogMAxcGxmQX64gv+DoFi+dD89muSRl
         HWaQ==
X-Gm-Message-State: AOJu0YxvK4pn6wUthor4IIa0Ns/B0MUJuh7yu49C7X9mIEHeRUftP4JB
	wfDBidpAo7fay6ebpdel0Q4aIA==
X-Google-Smtp-Source: AGHT+IGU7JDB32d3EmZv97kO2MEntQmcvvGtu7x3AN/j6r3vWH3xlZC+Z5FtDVtjxNdca8AyJOth4A==
X-Received: by 2002:ac2:4d93:0:b0:507:b074:ecd4 with SMTP id g19-20020ac24d93000000b00507b074ecd4mr20448646lfe.7.1699268695795;
        Mon, 06 Nov 2023 03:04:55 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id p12-20020adfce0c000000b0032dc1fc84f2sm9191301wrn.46.2023.11.06.03.04.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:04:55 -0800 (PST)
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
	Nicholas Piggin <npiggin@gmail.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
Subject: [PULL 11/60] target/ppc: Remove CPU_RESOLVING_TYPE from 'cpu-qom.h'
Date: Mon,  6 Nov 2023 12:02:43 +0100
Message-ID: <20231106110336.358-12-philmd@linaro.org>
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

"target/ppc/cpu-qom.h" is supposed to be target agnostic
(include-able by any target). Add such mention in the
header.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20231013140116.255-5-philmd@linaro.org>
---
 target/ppc/cpu-qom.h | 3 +--
 target/ppc/cpu.h     | 2 ++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/target/ppc/cpu-qom.h b/target/ppc/cpu-qom.h
index be33786bd8..41df51269b 100644
--- a/target/ppc/cpu-qom.h
+++ b/target/ppc/cpu-qom.h
@@ -1,5 +1,5 @@
 /*
- * QEMU PowerPC CPU
+ * QEMU PowerPC CPU QOM header (target agnostic)
  *
  * Copyright (c) 2012 SUSE LINUX Products GmbH
  *
@@ -33,7 +33,6 @@ OBJECT_DECLARE_CPU_TYPE(PowerPCCPU, PowerPCCPUClass, POWERPC_CPU)
 
 #define POWERPC_CPU_TYPE_SUFFIX "-" TYPE_POWERPC_CPU
 #define POWERPC_CPU_TYPE_NAME(model) model POWERPC_CPU_TYPE_SUFFIX
-#define CPU_RESOLVING_TYPE TYPE_POWERPC_CPU
 
 #define TYPE_HOST_POWERPC_CPU POWERPC_CPU_TYPE_NAME("host")
 
diff --git a/target/ppc/cpu.h b/target/ppc/cpu.h
index 24dd6b1b0a..02619e5d54 100644
--- a/target/ppc/cpu.h
+++ b/target/ppc/cpu.h
@@ -27,6 +27,8 @@
 #include "qom/object.h"
 #include "hw/registerfields.h"
 
+#define CPU_RESOLVING_TYPE TYPE_POWERPC_CPU
+
 #define TCG_GUEST_DEFAULT_MO 0
 
 #define TARGET_PAGE_BITS_64K 16
-- 
2.41.0


