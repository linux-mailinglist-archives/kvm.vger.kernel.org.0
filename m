Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B62F79D495
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 17:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236313AbjILPQo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 11:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236270AbjILPQm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 11:16:42 -0400
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D932F1BB
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 08:16:37 -0700 (PDT)
Received: by mail-wr1-x44a.google.com with SMTP id ffacd0b85a97d-31aed15ce6fso3553979f8f.3
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 08:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694531796; x=1695136596; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FDBjc8Im/9KAKESp/lLrvFpvxpkV7sdZwugiSM3Gs/k=;
        b=k8BL/UeFPcpzDflZ10yfiJE0dRXZE4x/da7mHqswQTNcpBezDY2OjNNYVedaFrhDib
         WsjeTEolKC/fmDpmNMBDxSuMKz+4zlGdOj85FmK4oLM/X30QoQN+H/fSX3nCeQpoDHmy
         7omPsBO1VwmKeoZu6X9pl8jNUHIblyfB+iGrrEBPyZu/zAsnRXRYByo//7rBob1IH7+j
         EhjxRPe+Im5SCqI/dLQn7slhM3hM7ZoBIqZCoKJIzzZ816K9ILLm3z53yePrERyaYmtt
         2eMInypuZzCB7DPkmR4HuFy6sl2iwN1dHZjC03ypDoi+r9pZj6pOxXEmK9fAw8fYBuGo
         Ca8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694531796; x=1695136596;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FDBjc8Im/9KAKESp/lLrvFpvxpkV7sdZwugiSM3Gs/k=;
        b=g/RKIfD2Aey7iRd4sa6WgsemMX3xQV1VKV52/4D2vXkAW9/6IShMBQBbPQy3n6TP2Y
         dU7piJy0ejzYTWEejbT7iU3rjNzt6tAFQeomo07KqCunHYilSecsOSOLc/0gBJVJfdu8
         zKFr8R+nPzjxx6JXmJ1q5UA1GFG3z/oI2ahIoik+Z3xBmzk7dQaMtKeBqVx1Sd5PGeRf
         B4ArcoLZ9ezgbkV+4uIQdMyfK8guQbpjfEsAWgJHdtTf94ln+/xyv1mxT0+UoCBWf35q
         ZybTNmhZ+dup1ogM7WpwumQ5182zlXb2LOnmwfJGm9K4B6wSOEzcfk9XUdfWFOwtAQ5r
         1AxA==
X-Gm-Message-State: AOJu0YwBHj7XJrUVk5gtCx3uR1WIzTvTg3XFRCunQXhxF5X0MIEKvoR5
        RwfZpiX7tre9Ldv1yUhupVjbLoHE9U0H3fYNbS27RvLJVVsWyrx6UWDPBpb8+XJBfatT7kGn+FF
        njuJFkvfavcjYVciBL9QyNjhQx23ibiOtiGv0Y5ffZl9r8w40ZlLdF5s=
X-Google-Smtp-Source: AGHT+IGhfsNqinwNcE/SuhOX7TrjdPzE2djzHmGMbFBCgY9RGfFM94X87qOj3NK79McSS0T4ayclqiAIdQ==
X-Received: from keirf-cvd.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:23a8])
 (user=keirf job=sendgmr) by 2002:adf:d049:0:b0:31f:8875:e17a with SMTP id
 v9-20020adfd049000000b0031f8875e17amr106145wrh.10.1694531796350; Tue, 12 Sep
 2023 08:16:36 -0700 (PDT)
Date:   Tue, 12 Sep 2023 15:16:23 +0000
In-Reply-To: <20230912151623.2558794-1-keirf@google.com>
Mime-Version: 1.0
References: <20230912151623.2558794-1-keirf@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230912151623.2558794-4-keirf@google.com>
Subject: [PATCH 3/3] virtio/pci: Use consistent naming for the PCI ISR bit flags
From:   Keir Fraser <keirf@google.com>
To:     kvm@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Keir Fraser <keirf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Avoid using VIRTIO_IRQ_{HIGH,LOW} which belong to a different
namespace.  Instead define VIRTIO_PCI_ISR_QUEUE as a logical extension
of the VIRTIO_PCI_ISR_* namespace. Since this bit flag is missing from
a header imported verbatim from Linux, define it directly in pci.c.

Signed-off-by: Keir Fraser <keirf@google.com>
---
 virtio/pci-legacy.c | 2 +-
 virtio/pci.c        | 5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/virtio/pci-legacy.c b/virtio/pci-legacy.c
index 5804796..02a8f8c 100644
--- a/virtio/pci-legacy.c
+++ b/virtio/pci-legacy.c
@@ -61,7 +61,7 @@ static bool virtio_pci__data_in(struct kvm_cpu *vcpu, struct virtio_device *vdev
 	case VIRTIO_PCI_ISR:
 		ioport__write8(data, vpci->isr);
 		kvm__irq_line(kvm, vpci->legacy_irq_line, VIRTIO_IRQ_LOW);
-		vpci->isr = VIRTIO_IRQ_LOW;
+		vpci->isr = 0;
 		break;
 	default:
 		ret = virtio_pci__specific_data_in(kvm, vdev, data, size, offset);
diff --git a/virtio/pci.c b/virtio/pci.c
index 74bc9a4..8a34cec 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -14,6 +14,9 @@
 #include <assert.h>
 #include <string.h>
 
+/* The bit of the ISR which indicates a queue change. */
+#define VIRTIO_PCI_ISR_QUEUE	0x1
+
 int virtio_pci__add_msix_route(struct virtio_pci *vpci, u32 vec)
 {
 	int gsi;
@@ -239,7 +242,7 @@ int virtio_pci__signal_vq(struct kvm *kvm, struct virtio_device *vdev, u32 vq)
 		else
 			kvm__irq_trigger(kvm, vpci->gsis[vq]);
 	} else {
-		vpci->isr |= VIRTIO_IRQ_HIGH;
+		vpci->isr |= VIRTIO_PCI_ISR_QUEUE;
 		kvm__irq_line(kvm, vpci->legacy_irq_line, VIRTIO_IRQ_HIGH);
 	}
 	return 0;
-- 
2.42.0.283.g2d96d420d3-goog

