Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67BDE3754E9
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 15:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234369AbhEFNjk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 09:39:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55674 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233954AbhEFNjk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 May 2021 09:39:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620308321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NaJZZTBiusehu1Tq7zBJHOToPc0jvSFCIFWhGsqf9q0=;
        b=fresYRepUTg/YtxMS/3eGVjkRpuHC2Xi5fEGESlljRXmD5PL2fWTexa6z2dHsysbpno9TJ
        tkwTRHAiN4vJN9wgANKJgwRKXkgLVDloiLlGdGf+yccTbZe6atcZxHWkoBcfxYN1bgt7Gi
        Pwe4Jhb+5LbDNGRhRbmSjgWJlSTV28w=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-551-FEZgIZ2GPxqIYUxGuRdjdg-1; Thu, 06 May 2021 09:38:40 -0400
X-MC-Unique: FEZgIZ2GPxqIYUxGuRdjdg-1
Received: by mail-wr1-f72.google.com with SMTP id 91-20020adf94640000b029010b019075afso2201587wrq.17
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 06:38:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NaJZZTBiusehu1Tq7zBJHOToPc0jvSFCIFWhGsqf9q0=;
        b=CnKheQNPpcdngIDsD1ZZnP6FY5frkj/QxF5qjxecLNPD3jeoXekDJBnTjP1cZ0/+Pz
         i393J7b3h/ul9rFNfUgKvaLG6aAb5lz/yBbKB7Jxm11UJFEW0VXEX7c2CFSHckwmMrrL
         bm8KNm5R4+qL8XcciA3wJz9YLVMqpo6bDD60xeL8GgfnSAWFpkiSwU82IQKlqdZnEU8h
         zd/QcBUtcyyUkfBjlNcmeUzPUgxaYQrF6HS7n4S/FTLuP/Vn5Pk0IUomffceIRzY3GWa
         NYVHW0HzCqmdXArCgz826zhzESUm/p8qOT0wGsPZaRYQIG+N7uHTaZ3w0yrug68Qo6vs
         oPPw==
X-Gm-Message-State: AOAM531qT/7XSEIfhxFM5k+N2m9ckb9dpWVAh5OK//FJFeD3yygJ84S+
        6HrxqdR5+YLxnwlhUBxjPfqCMrx9GF1In2fvmAOZTm2phd75nZcNfJqqbugyTvwsmoDYUws1nGF
        MdruQ2o3CyFHP
X-Received: by 2002:adf:c002:: with SMTP id z2mr5292551wre.100.1620308318927;
        Thu, 06 May 2021 06:38:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyyHdfkaTmkvWQf5Hf6Mx8u2g2OWRDThcbJG1gkPh5MWHU1eQptHFzQJqG0ffuS/NnFVO+6Rg==
X-Received: by 2002:adf:c002:: with SMTP id z2mr5292527wre.100.1620308318789;
        Thu, 06 May 2021 06:38:38 -0700 (PDT)
Received: from localhost.localdomain (astrasbourg-652-1-219-60.w90-40.abo.wanadoo.fr. [90.40.114.60])
        by smtp.gmail.com with ESMTPSA id l22sm9501029wmq.28.2021.05.06.06.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 06:38:38 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-ppc@nongnu.org, qemu-arm@nongnu.org,
        Gerd Hoffmann <kraxel@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Andrew Jeffery <andrew@aj.id.au>, Joel Stanley <joel@jms.id.au>
Subject: [PATCH v2 8/9] hw/misc/pca9552: Replace g_newa() by g_new()
Date:   Thu,  6 May 2021 15:37:57 +0200
Message-Id: <20210506133758.1749233-9-philmd@redhat.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210506133758.1749233-1-philmd@redhat.com>
References: <20210506133758.1749233-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The ALLOCA(3) man-page mentions its "use is discouraged".

Replace the g_newa() call by g_new().

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/misc/pca9552.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/misc/pca9552.c b/hw/misc/pca9552.c
index b7686e27d7f..facf103cbfb 100644
--- a/hw/misc/pca9552.c
+++ b/hw/misc/pca9552.c
@@ -71,7 +71,7 @@ static void pca955x_display_pins_status(PCA955xState *s,
         return;
     }
     if (trace_event_get_state_backends(TRACE_PCA955X_GPIO_STATUS)) {
-        char *buf = g_newa(char, k->pin_count + 1);
+        g_autofree char *buf = g_new(char, k->pin_count + 1);
 
         for (i = 0; i < k->pin_count; i++) {
             if (extract32(pins_status, i, 1)) {
-- 
2.26.3

