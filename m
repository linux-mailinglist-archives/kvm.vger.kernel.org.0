Return-Path: <kvm+bounces-1660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B99AA7EB27D
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 15:39:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 765A02811EC
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 14:39:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5054D41756;
	Tue, 14 Nov 2023 14:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kkz1o2z2"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72DB4174A
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 14:39:09 +0000 (UTC)
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8151A173B
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 06:39:08 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-9d2e7726d5bso856318166b.0
        for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 06:39:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699972747; x=1700577547; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oo2mmHUNt8cswMDm2G2tk7NYG50Leech1RMDbe0XTgw=;
        b=kkz1o2z2Itu6yTNcz2cpsDUKbOT1Oal2bSvG7/AoCCAxyUdTVoPrLs56ysvardQxgZ
         ILTV1GLLpNI4jwCcQuzwhbd7fTEqfzHX9OGBSxA0z3UQRLXqEDbIfqoxHjF9N7mNP4xh
         npKNFUedNQNTfJjA5SWFxYA2KTu3aqeAkqtsNnUy0qg3H94JJiTfBGU8lBoB6Xlu6tFI
         PZNMeWe3Kbkx7gKJ5bGEyNGBFwPAig8zNsh6FJmcrer4xqQJsJv3XUFtmzufQxuWXHXX
         tLm8oeT1yPGn9x+DBixfBLESLk5lO/S+vCgw9wJCcKXiWBhNOTIUEIpUD0a82Q0KE2Lq
         7Yxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699972747; x=1700577547;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oo2mmHUNt8cswMDm2G2tk7NYG50Leech1RMDbe0XTgw=;
        b=Mx0wJ1AlDTpFYHF2MZbSRTbnZsQKDDaqoO8dGofKOgDVaJa5pWM6R1NdmaBcCbIv15
         ovtVq8NEjZ3DxYrI3VK1vuve8FjbFHP4kspQj/bVk3XVMv903e0BUj2p776ugqG+Suq0
         OpvAF22382xuQ3afe1Fqpnn3Wm6nfdYg4f27EWa81bU9vj1imL1f1T0v/4kbGqufO0Zd
         9oDaTqobxdPSEEFAVg+O0spLhkXLtNEfIprL4fd13BwIJ05vMlr3UzjGfSEXBvpGqB6J
         ii5Pqoz1xoFlw/N4B2Dn/hCNXUVnBwljQfE3TcGUlNn5Q5JET8p0ofENRMXdU/o0JMC8
         Cu7w==
X-Gm-Message-State: AOJu0YwoAWh9REP+9AuEZAvYa7ZmFKeKZhLRWa8zp7ywWmfYKvm6htcC
	D7OapTlyRf01PnzFaZZxpWijIg==
X-Google-Smtp-Source: AGHT+IFJHEre72B5jboKAaroDeSDmy2A+msHyepV3IUCtazYitevtMIyD1yfonucyI3qP3HjOGn0kg==
X-Received: by 2002:a17:906:45a:b0:9c7:56ee:b6e5 with SMTP id e26-20020a170906045a00b009c756eeb6e5mr6778901eja.40.1699972747032;
        Tue, 14 Nov 2023 06:39:07 -0800 (PST)
Received: from m1x-phil.lan (cac94-h02-176-184-25-155.dsl.sta.abo.bbox.fr. [176.184.25.155])
        by smtp.gmail.com with ESMTPSA id m13-20020a170906234d00b00997e00e78e6sm5591697eja.112.2023.11.14.06.39.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 14 Nov 2023 06:39:06 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: David Woodhouse <dwmw@amazon.co.uk>,
	qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paul Durrant <paul@xen.org>,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	xen-devel@lists.xenproject.org,
	qemu-block@nongnu.org,
	Anthony Perard <anthony.perard@citrix.com>,
	kvm@vger.kernel.org,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH-for-9.0 v2 07/19] hw/xen: Remove unnecessary xen_hvm_inject_msi() stub
Date: Tue, 14 Nov 2023 15:38:03 +0100
Message-ID: <20231114143816.71079-8-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231114143816.71079-1-philmd@linaro.org>
References: <20231114143816.71079-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Since commit 04b0de0ee8 ("xen: factor out common functions")
xen_hvm_inject_msi() stub is not required.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 stubs/xen-hw-stub.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/stubs/xen-hw-stub.c b/stubs/xen-hw-stub.c
index 7d7ffe83a9..6cf0e9a4c1 100644
--- a/stubs/xen-hw-stub.c
+++ b/stubs/xen-hw-stub.c
@@ -24,10 +24,6 @@ int xen_set_pci_link_route(uint8_t link, uint8_t irq)
     return -1;
 }
 
-void xen_hvm_inject_msi(uint64_t addr, uint32_t data)
-{
-}
-
 int xen_is_pirq_msi(uint32_t msi_data)
 {
     return 0;
-- 
2.41.0


