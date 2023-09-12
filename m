Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5135079D493
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 17:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236256AbjILPQh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 11:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236227AbjILPQg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 11:16:36 -0400
Received: from mail-wm1-x34a.google.com (mail-wm1-x34a.google.com [IPv6:2a00:1450:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331191BB
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 08:16:32 -0700 (PDT)
Received: by mail-wm1-x34a.google.com with SMTP id 5b1f17b1804b1-4011fa32e99so43924575e9.0
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 08:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694531790; x=1695136590; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DSSb3wJwwJOYnhbMDsHN3g3fU/f9wd1vkngB6Xy4Iy8=;
        b=qH8MMekUaNKjIFq6ExyQSELZbuipSQzLPs6fzvWx71+za7wtPUdcT1Aj+0Ybuki+Sx
         anTgSSpMGOfwYXCsfuEyCdHhcdgAWT2Oe/V3XItg76vZGEe3FaY4uPE9Q/bMkEB5xgW6
         TJ0r8FRgyeA/oLgYBQZ8OZDA6lWfo8avUsdDNP7lGABjj4Fy5dV3cIfK24tTu+tFb7IR
         X/6I7s2dS+F3Y176AH7H0CTKQ4r7GMOk9CVZRcIF4V5qmmf4/6cCDcbHfdmvwtYHu2UJ
         CRC1sqWQ34SWVOCBjSz2a4Z/j2mLYrrNt41vGDmuoL0iuIgZ69ZKHZku1NBK2XPDgQJi
         +KHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694531790; x=1695136590;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DSSb3wJwwJOYnhbMDsHN3g3fU/f9wd1vkngB6Xy4Iy8=;
        b=LUg4UZfKfNtw1EwN5QEFLigaE05T+fr9ZBZ34Y7tFozAs5Sk8tJ9y5vo5ufyGXb+Mf
         8XzAqHkEuZQR7JDtlWKJ1sM5eT6GfVqPZG0tle6yR7RlcWUYhQsOj8j/vQPrSH64kzGk
         f2yBTE2CquaHTkF2+maw9CLkAKlOLRUbCGnjgRFo7lRVYBoZFcGrFRWGy50047E1JTM+
         wseKPmA9ldiaXXB3NFfI9fnvRB1SH+tOpAAyfKUHkk4iE6kdQHjeCzsbfmezQcv8RGY/
         qV1vO28kd8iIMQty2rWJ/FsxKt+wyKmdi0qouVyYj3LiCfdeBhDMQ/2IU9RiMYNNDBq5
         tsxw==
X-Gm-Message-State: AOJu0YzaP7mhsFLqE0fFEBvtwQHMBG+oPVL8ICpzt8O0YEBkZ0eiBWaf
        hsvZ6+to5kw0F3yMlkA57Nwk5Z+V4nRte4eKcSh8brd72t6rRMaamvw5VZzJVgN+CTZFK7huyxW
        tVe80UO4RrKtblM49SC9fk8FI6eCbpBX8uCtXssMqOBNZChYieRav70Y=
X-Google-Smtp-Source: AGHT+IEAzg6mUToilyQxjWdZq12Fyey0jhHzClgFcPgfc+oz8wvtDI0/fZ/5iPyq71/u3XlrVw1BVK8clQ==
X-Received: from keirf-cvd.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:23a8])
 (user=keirf job=sendgmr) by 2002:a5d:4388:0:b0:317:6b94:b700 with SMTP id
 i8-20020a5d4388000000b003176b94b700mr150488wrq.9.1694531790591; Tue, 12 Sep
 2023 08:16:30 -0700 (PDT)
Date:   Tue, 12 Sep 2023 15:16:21 +0000
In-Reply-To: <20230912151623.2558794-1-keirf@google.com>
Mime-Version: 1.0
References: <20230912151623.2558794-1-keirf@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230912151623.2558794-2-keirf@google.com>
Subject: [PATCH 1/3] virtio/pci: Level-trigger the legacy IRQ line in all cases
From:   Keir Fraser <keirf@google.com>
To:     kvm@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Keir Fraser <keirf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The PCI legacy IRQ line is level triggered, but is treated as
edge triggered via kvm__irq_trigger() for signalling of config
changes.

Fix this by using kvm__irq_level(), as for queue signalling.

Signed-off-by: Keir Fraser <keirf@google.com>
---
 virtio/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virtio/pci.c b/virtio/pci.c
index 701f456..7a206be 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -264,7 +264,7 @@ int virtio_pci__signal_config(struct kvm *kvm, struct virtio_device *vdev)
 			kvm__irq_trigger(kvm, vpci->config_gsi);
 	} else {
 		vpci->isr = VIRTIO_PCI_ISR_CONFIG;
-		kvm__irq_trigger(kvm, vpci->legacy_irq_line);
+		kvm__irq_line(kvm, vpci->legacy_irq_line, VIRTIO_IRQ_HIGH);
 	}
 
 	return 0;
-- 
2.42.0.283.g2d96d420d3-goog

