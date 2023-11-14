Return-Path: <kvm+bounces-1671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EEC17EB29A
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 15:40:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FF6A1C20AED
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 14:40:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E765541232;
	Tue, 14 Nov 2023 14:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KMgbMoZ7"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C8D4123E
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 14:40:25 +0000 (UTC)
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 454E810D
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 06:40:23 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-5431614d90eso8857989a12.1
        for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 06:40:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699972822; x=1700577622; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xWc7O88tTfL+IROUfXsM+NSd2X7VWDO4aCdpc797HXc=;
        b=KMgbMoZ7+JL2XT3qjscUa+Cv6MyGK7c3BCTWVYdHhXaKgVI1fJDW39IaCxava1edtB
         R8hRyEXFu8nqErrdwrSYF9yK6brF4wCBxQrT9gdEK/34iS+oMDmojmG852H1ZyoN5j2U
         d6m7n//7IIfbRRCh9K2S35eVTcsCwH1b85mQ4U9wWoqKvrGCAOHSWamXzaytfReoIF3t
         /sr3oBoCCVl90OzM9trKzczs6kqABWA17Me/WNAES/u/Rv+l56XpHphg94uxyI3LbCNw
         sndNBoGI9pT2gbBkxIa4lGXGCWrkxQFX1DC+4mjldz7dQ/XbKLf+Iyl9PrkIfCW1GUHN
         uK5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699972822; x=1700577622;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xWc7O88tTfL+IROUfXsM+NSd2X7VWDO4aCdpc797HXc=;
        b=mEGnMbjXhtt9tbjNvNYG6HIe2Ko1xTpWtJ1CZRt1f9uP5WTUiPZHAePZgT/vYnNSTy
         WM1oxec3qxElLcP63QIv6ABIKsz8b2ZexhLI7kf/Ag6nynZJFOInCBkYusEvcBH4Doc9
         j7y9dGLWTH9ryb61fkYDKMk62+LHqpXVxneLAo8Tq8Hze0mxtz1BOPHvE0iPy2nW+wQ2
         A+b7X6wo1KFWVsmQButGUKuCzDYi2Pn6miSdtxgFrGx1gNZUH09Pa2wiHRO1sOGQivhU
         p4CnfU68ohBw5FdaXJGMnl/Kx2NMQMKvMsDfgaUesxoU0VjrYwyKelX8yhbOEVwhiH9z
         IsCQ==
X-Gm-Message-State: AOJu0Yw8SSBDtv7h1NHql1omIgxTSFnji4I4so2K/AMUpA2INYjnS7Bt
	i/M0yv5+K3hkwUScLfdCR+X+Tw==
X-Google-Smtp-Source: AGHT+IHNrn5T4boQ0NzVhZdNm2rxcLbpt1HdZaO6IACtyCbzFgVV5y7RIxXgNNvQBcNbwz/XH0TntA==
X-Received: by 2002:a05:6402:518e:b0:543:5c2f:e0e6 with SMTP id q14-20020a056402518e00b005435c2fe0e6mr7401790edd.17.1699972821905;
        Tue, 14 Nov 2023 06:40:21 -0800 (PST)
Received: from m1x-phil.lan (cac94-h02-176-184-25-155.dsl.sta.abo.bbox.fr. [176.184.25.155])
        by smtp.gmail.com with ESMTPSA id e29-20020a50d4dd000000b0052e1783ab25sm5343752edj.70.2023.11.14.06.40.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 14 Nov 2023 06:40:21 -0800 (PST)
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
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Eduardo Habkost <eduardo@habkost.net>
Subject: [PATCH-for-9.0 v2 18/19] hw/i386/xen: Compile 'xen-hvm.c' with Xen CPPFLAGS
Date: Tue, 14 Nov 2023 15:38:14 +0100
Message-ID: <20231114143816.71079-19-philmd@linaro.org>
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

xen-hvm.c calls xc_set_hvm_param() from <xenctrl.h>,
so better compile it with Xen CPPFLAGS.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/i386/xen/meson.build | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/hw/i386/xen/meson.build b/hw/i386/xen/meson.build
index 3dc4c4f106..3f0df8bc07 100644
--- a/hw/i386/xen/meson.build
+++ b/hw/i386/xen/meson.build
@@ -1,8 +1,10 @@
 i386_ss.add(when: 'CONFIG_XEN', if_true: files(
-  'xen-hvm.c',
   'xen_apic.c',
   'xen_pvdevice.c',
 ))
+i386_ss.add(when: ['CONFIG_XEN', xen], if_true: files(
+  'xen-hvm.c',
+))
 
 i386_ss.add(when: 'CONFIG_XEN_BUS', if_true: files(
   'xen_platform.c',
-- 
2.41.0


