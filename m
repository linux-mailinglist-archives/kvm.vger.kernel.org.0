Return-Path: <kvm+bounces-703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AFEAA7E1F7B
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:07:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65F14280D0B
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:07:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AD2C1EB34;
	Mon,  6 Nov 2023 11:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zvHmpphE"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1730C1A737
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:07:37 +0000 (UTC)
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C7ED6B
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:07:33 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-4079ed65582so32870765e9.1
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:07:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268852; x=1699873652; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cb2SoP+Kcg9QwI4B3FcAYm9BYCwnPa3WzQeoNeejBGE=;
        b=zvHmpphETVF1bVI04pb8VaDcDZCtQq3zDUq2EkMzpSBxWIzfs/WsMTxi5Fyjd/euyw
         rLJypWa/XIb9r5bDZjlDYVtMKPNVKilyOCDgpVKNjGHMf7tv6jf6x6JzHzUbx/aLjQKu
         mjKqlLchCYeQ2/Ak6WKwjGEgFendwxfsA1uU3kixHAW+C/mC7tj1jnSGp+ISu35uzhmR
         VyYhLWH4Xmumtflf5jVFOUkM0RIP0FStwu4GokeeZOi++5ovtLwtFNzxhxC2kVn1szcz
         maaQBqdOsGRxMQRUAcF6z/slUjxRQ1Cp5zKfPR5eRGtKMVySixpgP1dwXbI6bPGSlhDB
         604g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268852; x=1699873652;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cb2SoP+Kcg9QwI4B3FcAYm9BYCwnPa3WzQeoNeejBGE=;
        b=T+X9581+cRk5PT7a6YSVC8AQKeOdN7vonWkPd8tZhUhoQ1kCZIRLmj4N3hDDbnFhwi
         exMzgQDLOZjhMomwBj4xWuHZvpEI6eBi1SkqQSMMmVaI7vCf+xY08BjllioxmYoeL+AX
         DI3ZNVhRNsNSkzsStKt5ioUQz4TmlEsVTqXWiaN/on88Ld8eIk7FQT0drC8M03n3pORv
         QP32P+Kgrn2cliR8mMG1KljQT3SIgCu35OZ8r6VDSZhL2y8wxx5+atvCVb7fiK6NryZB
         /fCN1DXvNKSRQFkfuVqdTZV3W+MI0unfmT1uyVWhCgb1okOI7O4V20qIzPx1W2G3kC1W
         70Lg==
X-Gm-Message-State: AOJu0YzaAUtd3dCfrox5KWNmRGYnq3KWwAEV/XyaNAtermpejxTl8r8K
	WmsPKD48dq1wL3KSyFXH5jHBTQ==
X-Google-Smtp-Source: AGHT+IGOwGb19To8VXCdR8ERpA0kEx5JDBtiDEBtx2l74K+wLoipriHx1wrJrWcABU//cghRcbbU9g==
X-Received: by 2002:a05:600c:4fc6:b0:401:b652:b6cf with SMTP id o6-20020a05600c4fc600b00401b652b6cfmr23757960wmq.13.1699268851941;
        Mon, 06 Nov 2023 03:07:31 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id f13-20020a05600c4e8d00b0040596352951sm11677086wmq.5.2023.11.06.03.07.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:07:31 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-s390x@nongnu.org,
	qemu-block@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Tokarev <mjt@tls.msk.ru>,
	Nicholas Piggin <npiggin@gmail.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
Subject: [PULL 34/60] target/ppc: Restrict KVM objects to system emulation
Date: Mon,  6 Nov 2023 12:03:06 +0100
Message-ID: <20231106110336.358-35-philmd@linaro.org>
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

CONFIG_KVM is always FALSE on user emulation, so 'kvm.c'
won't be added to ppc_ss[] source set; direcly use the system
specific ppc_system_ss[] source set.

Reviewed-by: Michael Tokarev <mjt@tls.msk.ru>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Message-Id: <20231003070427.69621-4-philmd@linaro.org>
---
 target/ppc/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/ppc/meson.build b/target/ppc/meson.build
index eab4e3e1b3..0b89f9b89f 100644
--- a/target/ppc/meson.build
+++ b/target/ppc/meson.build
@@ -30,7 +30,6 @@ gen = [
 ]
 ppc_ss.add(when: 'CONFIG_TCG', if_true: gen)
 
-ppc_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c'))
 ppc_ss.add(when: 'CONFIG_USER_ONLY', if_true: files('user_only_helper.c'))
 
 ppc_system_ss = ss.source_set()
@@ -46,6 +45,7 @@ ppc_system_ss.add(when: 'CONFIG_TCG', if_true: files(
 ), if_false: files(
   'tcg-stub.c',
 ))
+ppc_system_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c'))
 
 ppc_system_ss.add(when: 'TARGET_PPC64', if_true: files(
   'compat.c',
-- 
2.41.0


