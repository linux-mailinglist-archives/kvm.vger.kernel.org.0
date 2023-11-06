Return-Path: <kvm+bounces-727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BAE07E1FA5
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:10:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EAEDB2814CD
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:10:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8DA5199B3;
	Mon,  6 Nov 2023 11:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Z7bIyyF2"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BFC318C07
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:10:20 +0000 (UTC)
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38C0CC
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:10:13 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id ffacd0b85a97d-32d895584f1so2598451f8f.1
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:10:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699269012; x=1699873812; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cyEPFd8qKgVauKHH+mzQW+99WSkPGmQyoZYgi3VA9Vc=;
        b=Z7bIyyF2oS+al0C0npkdYuv5lL3BiSEtFNek7DQPLKejCQJhUTWHDIP0wWurpA7xXh
         MdAtbuMueUhx2S+A9PITajCEtRxlO3AbWZC8L4MuWte10D/TuBc0RML2HSlow2ytuuio
         EdEfAQCMv91sUaRf1KgS1sMBcsmq2t0KZfkRRnkegpgRMrwg48sA7TKVQwjJ0KJUVBHd
         tzdZ+04+v6WJyh8pCz04vdWDMoPiFLl1I/NxqHciTSLXOj9Kv/o6AVi1oLzyE8Ja7Yvy
         ZeuRVpXoJGSNF/Y+7UvasrIlmqtoPx1v1rBvSR2oadSDCZIY/+7WUvHdV83vYyzdVmkY
         9VCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699269012; x=1699873812;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cyEPFd8qKgVauKHH+mzQW+99WSkPGmQyoZYgi3VA9Vc=;
        b=aHz08eQ96USPTe+D1HXIcuQJK/NLPb/TCMCeFx0qs754Qrur/hzAj2PGHp8xtK465m
         zo3hLbxmorbrQbUG26R9lulNXsEU/sFD9dExIqk8OdoFmtWoNw2Z1F6KXeOajoz0zBsZ
         CmV06GpLxPD+saLd4CtpxB2bIe9GBCQ0dyLQGHMnJaaUgBdPjgQdp8WbXTMxL7H+iIsU
         E2aYh9x84E5ShnATUDAtFhQdnR6qRZljUWJPtpJcz2ORUyHy0kOlOGEJoBbTlRoJR4u1
         onXkdkU4k/nSuOLq7gs2cVmlIQlO1K9snFXlOolKox3rvGBJIa0Cdal9PLGk5zjXQFa4
         ZWFA==
X-Gm-Message-State: AOJu0YzT/U3mpkju+VKk1MFidMpgbZEmyJWTRXu6TA7wfD0H9kFO02AE
	cux2aDlXdNohWy++GZIB4vBb5A==
X-Google-Smtp-Source: AGHT+IEMIDW7hBBkWZ0URkD2CfnnnPG/ExOR7Okjzu2uwpb1mtEO/NwWscUpM9JIRDLHPNQlRwIx/g==
X-Received: by 2002:a05:6000:1842:b0:32f:7b2e:2dd with SMTP id c2-20020a056000184200b0032f7b2e02ddmr23663996wri.45.1699269012416;
        Mon, 06 Nov 2023 03:10:12 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id j5-20020adfe505000000b0031fd849e797sm8761303wrm.105.2023.11.06.03.10.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:10:12 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-s390x@nongnu.org,
	qemu-block@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	Thomas Huth <thuth@redhat.com>,
	Vikram Garhwal <vikram.garhwal@amd.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pavel Pisa <pisa@cmp.felk.cvut.cz>
Subject: [PULL 58/60] MAINTAINERS: Add the CAN documentation file to the CAN section
Date: Mon,  6 Nov 2023 12:03:30 +0100
Message-ID: <20231106110336.358-59-philmd@linaro.org>
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

From: Thomas Huth <thuth@redhat.com>

Add can.rst to the corresponding section in MAINTAINERS, so that
the maintainers get CC:-ed on corresponding patches.

Signed-off-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Vikram Garhwal <vikram.garhwal@amd.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Acked-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
Message-ID: <20231027060931.242491-1-thuth@redhat.com>
[PMD: Fixed typo in subject]
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3014e768f7..c57868c94c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2588,6 +2588,7 @@ W: https://canbus.pages.fel.cvut.cz/
 F: net/can/*
 F: hw/net/can/*
 F: include/net/can_*.h
+F: docs/system/devices/can.rst
 
 OpenPIC interrupt controller
 M: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
-- 
2.41.0


