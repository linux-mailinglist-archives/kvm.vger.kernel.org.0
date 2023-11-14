Return-Path: <kvm+bounces-1658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CAD77EB274
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 15:39:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D29651F2503A
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 14:39:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91A0D4174A;
	Tue, 14 Nov 2023 14:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gdZNic/G"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0F941743
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 14:38:59 +0000 (UTC)
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7BA1980
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 06:38:55 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-9d2e7726d5bso856279766b.0
        for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 06:38:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699972734; x=1700577534; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xuAolXSNCEGrTS5m5CRvskBDG9NQVZE3kWB97Se1m9g=;
        b=gdZNic/GvjcgDIlpoGbOXtXRJlRFeKOcLARDnSefMwfY8bF0OmVyl0WQx2zIjNp1ZC
         OvDuuYH4Ay5wvpHRHdT5fDsiXrHaplfJv3KMIyeWooQzJjNM6ywSqNdbyFX73dntwHJw
         3GYNlO4W1Z/m/acFa/IQ9Tdn2Qq/yFN7tlDNG3f+Tmz4jSfO0LwJZNFj3pIt2y4u8cIH
         I4olfrdXCMOTPZ+tny8vlw1PCoA0bAbD0kjqD2mlRDPVVpMmGPcAlWiNZGyCi1GVaf7X
         Ft/ZsnzNrqCKxN962ce9GJoTkpV1buvULlNfMUrJrWzRITxQoqk3K7wWg95BjZ9W+9HE
         afHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699972734; x=1700577534;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xuAolXSNCEGrTS5m5CRvskBDG9NQVZE3kWB97Se1m9g=;
        b=ctXlA9jg/Fmc96tvC0+VEWSzS+PvZpRj9Bp56LCHEJ5Ft4C+ZN1ff66v9X2WR6s/s7
         IRxF9+GpHTEpNB/cmmZ6UD2iA8doApgnyjoAL90dyRN82pWIw8nkvj/dOZAEnxXewDwM
         arSV9vbUnVMo53XqEgCZmQp6H3ucXrKhNavdkTAfn6LvTb45lteOQuTwzyowbd+eBmis
         skaHkyxKwsaMzNU6ReGd6j0a3+PkKA3Hfil6qS/aoL4gl44Aj35zuZZB5hLUgy93U4c1
         IgDrwkejgwsunl/VSeq/szAWBbFaNl3oLxN6FRDhG1VzYnnzZVDFq0YSBWMQWcA9Dg3C
         dSCw==
X-Gm-Message-State: AOJu0YxD3v7lV7n3uIX64jgnTfBbjik7opmsW8j4MeIBVECTfInSCZta
	/mVAgWQ2ljnKiMTCjLuq1Ad4Hg==
X-Google-Smtp-Source: AGHT+IEd2vTLeg2GpIsCyOKyOB5sACh8KieliOs//U/3JH0fTJ/5IoDfAGItJdrYHg+Wv8sdCg7VbA==
X-Received: by 2002:a17:906:b78c:b0:9bf:f20:8772 with SMTP id dt12-20020a170906b78c00b009bf0f208772mr7590866ejb.26.1699972733904;
        Tue, 14 Nov 2023 06:38:53 -0800 (PST)
Received: from m1x-phil.lan (cac94-h02-176-184-25-155.dsl.sta.abo.bbox.fr. [176.184.25.155])
        by smtp.gmail.com with ESMTPSA id un1-20020a170907cb8100b009a9fbeb15f5sm5549367ejc.46.2023.11.14.06.38.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 14 Nov 2023 06:38:53 -0800 (PST)
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
	Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH-for-9.0 v2 05/19] hw/display: Restrict xen_register_framebuffer() call to Xen
Date: Tue, 14 Nov 2023 15:38:01 +0100
Message-ID: <20231114143816.71079-6-philmd@linaro.org>
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

Only call xen_register_framebuffer() when Xen is enabled.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/display/vga.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/hw/display/vga.c b/hw/display/vga.c
index 37557c3442..f9cf3d6f77 100644
--- a/hw/display/vga.c
+++ b/hw/display/vga.c
@@ -25,6 +25,7 @@
 #include "qemu/osdep.h"
 #include "qemu/units.h"
 #include "sysemu/reset.h"
+#include "sysemu/xen.h"
 #include "qapi/error.h"
 #include "hw/core/cpu.h"
 #include "hw/display/vga.h"
@@ -2223,7 +2224,9 @@ bool vga_common_init(VGACommonState *s, Object *obj, Error **errp)
         return false;
     }
     vmstate_register_ram(&s->vram, s->global_vmstate ? NULL : DEVICE(obj));
-    xen_register_framebuffer(&s->vram);
+    if (xen_enabled()) {
+        xen_register_framebuffer(&s->vram);
+    }
     s->vram_ptr = memory_region_get_ram_ptr(&s->vram);
     s->get_bpp = vga_get_bpp;
     s->get_offsets = vga_get_offsets;
-- 
2.41.0


