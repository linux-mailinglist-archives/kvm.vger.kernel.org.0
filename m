Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C34F63754EA
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 15:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234390AbhEFNjr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 09:39:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45660 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233954AbhEFNjq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 May 2021 09:39:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620308327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RLFve6Y/zmLo3HdgEB/9T6FDXcQ0p9jwbmagngeIlOE=;
        b=XSZTY0dF3//VL+zAfbQ7M4B9+MMOYKVm8Ei1drOjWr40BijNSmiPlRFRYBzy5Pq/7KbvWn
        CQWJjFhTEYHrHD4iy1aBMt9uS5dxzBxxvEhY2u8zHx17IKh/znlgDNoIZ/l1TNNUZuash4
        c30fibj6K1qX1yOcNrtDZN75KSQDuo8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-uCjJ-GfmPE-8MebAzoRaXw-1; Thu, 06 May 2021 09:38:45 -0400
X-MC-Unique: uCjJ-GfmPE-8MebAzoRaXw-1
Received: by mail-wm1-f72.google.com with SMTP id y193-20020a1c32ca0000b029014cbf30c3f2so2646077wmy.1
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 06:38:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RLFve6Y/zmLo3HdgEB/9T6FDXcQ0p9jwbmagngeIlOE=;
        b=fYBiqcTTNJ8o+5yN8rsXcGT5dUrf+hCB0kQFyOJDDF/NsRT23UdrwEHAy5+SxRLf6s
         LhD0mqW0sq388hwIYQXg6Vz/nCEQ/0e/Ugp6RT+WWk9PrHZ+W8TFg/R5tj0oXR+ntHRX
         BCiHscDb65m3vfTCb62X9TVlPrT7p7e5eiLuuTIuzPUqKHaom8W3B4Xq0xE0nm2I2KaC
         Ybfz4RGMgx9vGY0EabXR79Npu0FAe2IoA8IdCBDvSxX/0tdbLDYiTAhs6o1coLYyhoWh
         fG9NmjYkiWy18VRBR7P64FlJ0ZJZU4rWftFZgzDoD4N/6pD1aBOxTNBtbZTuNRW8vxmD
         gKOA==
X-Gm-Message-State: AOAM5332CF0hy/xO2QL1ghCQDQfUIgrdlSFE+8ACKy/Rg/hbgnOrJHZV
        iA0Rzcm5iqAv4IWyb0C8hI6Qt7Fu49NWvIrEaEALaHT1t5toM9SvkaYTOJkKqU5vu1lMmKEUx/L
        2LRLkXxOue8sA
X-Received: by 2002:adf:e348:: with SMTP id n8mr5215091wrj.209.1620308324012;
        Thu, 06 May 2021 06:38:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwvsmJHX73t3ak/OC4xbrrBRJCZcdb4T22RK9A3SSLmm4vJNsQC6Ff+qwwaWbT6aA16s1zISA==
X-Received: by 2002:adf:e348:: with SMTP id n8mr5215061wrj.209.1620308323810;
        Thu, 06 May 2021 06:38:43 -0700 (PDT)
Received: from localhost.localdomain (astrasbourg-652-1-219-60.w90-40.abo.wanadoo.fr. [90.40.114.60])
        by smtp.gmail.com with ESMTPSA id w25sm3208909wmk.39.2021.05.06.06.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 06:38:43 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-ppc@nongnu.org, qemu-arm@nongnu.org,
        Gerd Hoffmann <kraxel@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>
Subject: [PATCH v2 9/9] target/ppc/kvm: Replace alloca() by g_malloc()
Date:   Thu,  6 May 2021 15:37:58 +0200
Message-Id: <20210506133758.1749233-10-philmd@redhat.com>
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

Replace it by a g_malloc() call.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/ppc/kvm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index 104a308abb5..63c458e2211 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -2698,11 +2698,10 @@ int kvmppc_save_htab(QEMUFile *f, int fd, size_t bufsize, int64_t max_ns)
 int kvmppc_load_htab_chunk(QEMUFile *f, int fd, uint32_t index,
                            uint16_t n_valid, uint16_t n_invalid, Error **errp)
 {
-    struct kvm_get_htab_header *buf;
     size_t chunksize = sizeof(*buf) + n_valid * HASH_PTE_SIZE_64;
+    g_autofree struct kvm_get_htab_header *buf = g_malloc(chunksize);
     ssize_t rc;
 
-    buf = alloca(chunksize);
     buf->index = index;
     buf->n_valid = n_valid;
     buf->n_invalid = n_invalid;
-- 
2.26.3

