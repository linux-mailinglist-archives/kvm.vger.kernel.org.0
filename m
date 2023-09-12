Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6CCD79D494
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 17:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236280AbjILPQk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 11:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236270AbjILPQj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 11:16:39 -0400
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB6DCC3
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 08:16:35 -0700 (PDT)
Received: by mail-wr1-x449.google.com with SMTP id ffacd0b85a97d-31f3eaa5c5eso3793013f8f.3
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 08:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694531793; x=1695136593; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=huKCk2g0BNIHM38+AvbfGWcHeU/DmBmWJoZhqWvPsM4=;
        b=wu/xgyme8153Jup6tAMM6dOw2WM8LFgFGIi/9fobS+fbB5OAX/iU9aDD3G8xxPTDOZ
         DJPKGl/xwsqTz6U4TCQcN7FPNsqv/9x3zhx2qJcc2ayZhWBO4TuoBN4fupwIpAdkx9MW
         35zhdvb3YYx3JwbKvN77NX3SY7saLp9nXKzXdH3l2p/P73+9z8jJ6hb2UJBisJla8qPf
         rXZlcmmSxTsJfdCuiCHsXUfP5+6o51xsnF8TcGZArfExDURrweO7h8lW2Gz/s/3Rhsmk
         6nNgE2JqGj2i7a7My+tPU8VZp8NZTd7SiKsSc0hoPs6aDYNeeuzmOmiuoZXP2yRnK6KS
         gKlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694531793; x=1695136593;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=huKCk2g0BNIHM38+AvbfGWcHeU/DmBmWJoZhqWvPsM4=;
        b=XU2ZpZWtokVodPWHwPORB9QxB8N+/e2JOpGJtfAnHYY4fEZmZGMy9r0MydXrG6wK13
         Zu6brUREvrevMZA1SqwQ/d2R5myhIJ7OC1sZVzSLQd+fcP/OyK0XObucHpSDxLPpCZ4y
         8h/h8ofOVQnFQGG4DQDHm7A04+/PpgzpIQc9rAHm+WN2lMlrHoVUTaeZuvB7gT8ZnGxy
         h2lYkmSpMQnNaKMkRU02K67llWCqYHsznZJA47baKDz80BvuLWLdNnad4Wyu5KDj+Mw0
         x49J6oqHuzJ39l9YaFUL2ElPdf+eJNUkAJ8YPXQWJh0EhWLCPTgAeinsie6Uy3fVI0a9
         gkNQ==
X-Gm-Message-State: AOJu0Yx5hZNFUUj0tpczlkBo4w0Mu+LAEnL3z9RKeMtJzMoZqPyCkw1l
        fl6YjwTUnwuuxxGFhEoaL+UIJwnMhRAXysZUHPynXZykp8zTdvlz17SncMJjyItehXH6Bsy90NT
        5BjqpwYrp4FeoOcKYzjQVVnfclqfxPJ04QgWMKH8TlmYXEvB4q/zNGDI=
X-Google-Smtp-Source: AGHT+IGmlLu47hxXQnTWd7rLTnheFI+x83cIVvm4q1qUWWGb4JZIClZADrikyh+gkHn+VgZrYenETdYNOg==
X-Received: from keirf-cvd.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:23a8])
 (user=keirf job=sendgmr) by 2002:a05:6000:118f:b0:313:f8d6:8884 with SMTP id
 g15-20020a056000118f00b00313f8d68884mr146316wrx.11.1694531793602; Tue, 12 Sep
 2023 08:16:33 -0700 (PDT)
Date:   Tue, 12 Sep 2023 15:16:22 +0000
In-Reply-To: <20230912151623.2558794-1-keirf@google.com>
Mime-Version: 1.0
References: <20230912151623.2558794-1-keirf@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230912151623.2558794-3-keirf@google.com>
Subject: [PATCH 2/3] virtio/pci: Treat PCI ISR as a set of bit flags
From:   Keir Fraser <keirf@google.com>
To:     kvm@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Keir Fraser <keirf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The PCI ISR is defined in the virtio spec as a set of flags which can
be bitwise ORed together. Therefore we should avoid clearing
previously-set flags.

Signed-off-by: Keir Fraser <keirf@google.com>
---
 virtio/pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virtio/pci.c b/virtio/pci.c
index 7a206be..74bc9a4 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -239,7 +239,7 @@ int virtio_pci__signal_vq(struct kvm *kvm, struct virtio_device *vdev, u32 vq)
 		else
 			kvm__irq_trigger(kvm, vpci->gsis[vq]);
 	} else {
-		vpci->isr = VIRTIO_IRQ_HIGH;
+		vpci->isr |= VIRTIO_IRQ_HIGH;
 		kvm__irq_line(kvm, vpci->legacy_irq_line, VIRTIO_IRQ_HIGH);
 	}
 	return 0;
@@ -263,7 +263,7 @@ int virtio_pci__signal_config(struct kvm *kvm, struct virtio_device *vdev)
 		else
 			kvm__irq_trigger(kvm, vpci->config_gsi);
 	} else {
-		vpci->isr = VIRTIO_PCI_ISR_CONFIG;
+		vpci->isr |= VIRTIO_PCI_ISR_CONFIG;
 		kvm__irq_line(kvm, vpci->legacy_irq_line, VIRTIO_IRQ_HIGH);
 	}
 
-- 
2.42.0.283.g2d96d420d3-goog

