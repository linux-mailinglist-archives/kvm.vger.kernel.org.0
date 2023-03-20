Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 765C66C258E
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 00:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbjCTXVd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 19:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbjCTXVb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 19:21:31 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FED298DC
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 16:21:24 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id y15so16958554lfa.7
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 16:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112; t=1679354483;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3X3Wo8kaCRJDM7ExahQjScqguoeAMDFbv3b6OF2IHsM=;
        b=5ZXhR8OUvwUecoP6ePQpd7hi8mK9KgbL85DM6o3EhXzFeEVZTe5tLfERM+kfrENQd9
         dyH+UFzeBk+/dquagk6DIrfNtcNB5dzJb+s+XSPq8I+zBMsfdOTxiA0svwhT16Ez2qFt
         D1+GAwavmpkT8LM9CqFceLaK6gvbXiwLnpZBjLdouRTj8Odwptk01fFfoLMF8qdIp9B6
         hBvyGrFNCuDB8p/oD2InSxPOBJmn6a8BfphhxE0CtBY4jJcYd/QSTGyW48uLEOWGE5QO
         HYQO0tciI76/ajGSRFXCJGMhB+/h98DILLGjeCGjDud+ndlD2JOWsJtN1gQLvhHdRsp9
         48jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679354483;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3X3Wo8kaCRJDM7ExahQjScqguoeAMDFbv3b6OF2IHsM=;
        b=sCd32mLx8StSE2SWqIpyiPlJL7U3g4lrhTR/eeVXQnuxWaUXpWwnVe94Vs+qMoI4Vk
         5uItXlBHO3XSimZYBujhpN3WGYQC8YppdJ6gOqT/XOYqpKYXZqXNYxHBZnUFxPJYcBT8
         0XV1X78vYHh6z/CqUzV7JtYZPqDDD9l3tRY4azLwzeQeIrcIVFKMvAinbG0mthRJnAPs
         yxH8Zml7qN37aUpjtEeWFD9dXtYK4FElv494E2uSNtA3kZ+oLNcyL6tk+62NATcCnaDe
         K1H7H6aV5ruzQ/sLbZQekCrlJpizjsowfaLljMNW9iiIp6hGOH8BYxrTa0TeXfN3fc7p
         FIQg==
X-Gm-Message-State: AO0yUKX2Hh1zG2T/2rlUlVH8yFFBeSfcUZFvT3SmEAS3Lp5r6/UN7uql
        I0Xke5lO55a4RkWHtbay8Q7alQ==
X-Google-Smtp-Source: AK7set/6hFUyBsZ8bln6K3lw88Z/CZWZGYS7gRw+Mng8nWKO1z/oJ4ZU9/x2ssykXtUV55QwqN1LtQ==
X-Received: by 2002:a19:5211:0:b0:4df:7cc4:d1f3 with SMTP id m17-20020a195211000000b004df7cc4d1f3mr200427lfb.20.1679354482680;
        Mon, 20 Mar 2023 16:21:22 -0700 (PDT)
Received: from vp-pc.. ([109.252.122.203])
        by smtp.gmail.com with ESMTPSA id q12-20020ac25a0c000000b004d7d13387b5sm1875918lfn.116.2023.03.20.16.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 16:21:22 -0700 (PDT)
From:   Viktor Prutyanov <viktor@daynix.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     cohuck@redhat.com, pasic@linux.ibm.com, farman@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, yan@daynix.com, viktor@daynix.com
Subject: [PATCH v2] virtio: add VIRTIO_F_NOTIFICATION_DATA feature support
Date:   Tue, 21 Mar 2023 02:21:15 +0300
Message-Id: <20230320232115.1940587-1-viktor@daynix.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to VirtIO spec v1.2, VIRTIO_F_NOTIFICATION_DATA feature
indicates that the driver passes extra data along with the queue
notifications.

In a split queue case, the extra data is 16-bit available index. In a
packed queue case, the extra data is 1-bit wrap counter and 15-bit
available index.

Add support for this feature for MMIO and PCI transports. Channel I/O
transport will not accept this feature.

Signed-off-by: Viktor Prutyanov <viktor@daynix.com>
---

 v2: reject the feature in virtio_ccw, replace __le32 with u32

 drivers/s390/virtio/virtio_ccw.c   |  4 +---
 drivers/virtio/virtio_mmio.c       | 15 ++++++++++++++-
 drivers/virtio/virtio_pci_common.c | 10 ++++++++++
 drivers/virtio/virtio_pci_common.h |  4 ++++
 drivers/virtio/virtio_pci_legacy.c |  2 +-
 drivers/virtio/virtio_pci_modern.c |  2 +-
 drivers/virtio/virtio_ring.c       | 17 +++++++++++++++++
 include/linux/virtio_ring.h        |  2 ++
 include/uapi/linux/virtio_config.h |  6 ++++++
 9 files changed, 56 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index a10dbe632ef9..d72a59415527 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -789,9 +789,7 @@ static u64 virtio_ccw_get_features(struct virtio_device *vdev)
 
 static void ccw_transport_features(struct virtio_device *vdev)
 {
-	/*
-	 * Currently nothing to do here.
-	 */
+	__virtio_clear_bit(vdev, VIRTIO_F_NOTIFICATION_DATA);
 }
 
 static int virtio_ccw_finalize_features(struct virtio_device *vdev)
diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index 3ff746e3f24a..0e13da17fe0a 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -285,6 +285,19 @@ static bool vm_notify(struct virtqueue *vq)
 	return true;
 }
 
+static bool vm_notify_with_data(struct virtqueue *vq)
+{
+	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vq->vdev);
+	u32 data = vring_fill_notification_data(vq);
+
+	writel(data, vm_dev->base + VIRTIO_MMIO_QUEUE_NOTIFY);
+
+	return true;
+}
+
+#define VM_NOTIFY(vdev) (__virtio_test_bit((vdev), VIRTIO_F_NOTIFICATION_DATA) \
+	? vm_notify_with_data : vm_notify)
+
 /* Notify all virtqueues on an interrupt. */
 static irqreturn_t vm_interrupt(int irq, void *opaque)
 {
@@ -397,7 +410,7 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned int in
 
 	/* Create the vring */
 	vq = vring_create_virtqueue(index, num, VIRTIO_MMIO_VRING_ALIGN, vdev,
-				 true, true, ctx, vm_notify, callback, name);
+			true, true, ctx, VM_NOTIFY(vdev), callback, name);
 	if (!vq) {
 		err = -ENOMEM;
 		goto error_new_virtqueue;
diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index a6c86f916dbd..535263abc2bd 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -43,6 +43,16 @@ bool vp_notify(struct virtqueue *vq)
 	/* we write the queue's selector into the notification register to
 	 * signal the other end */
 	iowrite16(vq->index, (void __iomem *)vq->priv);
+
+	return true;
+}
+
+bool vp_notify_with_data(struct virtqueue *vq)
+{
+	u32 data = vring_fill_notification_data(vq);
+
+	iowrite32(data, (void __iomem *)vq->priv);
+
 	return true;
 }
 
diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
index 23112d84218f..9a7212dcbb32 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -105,6 +105,7 @@ static struct virtio_pci_device *to_vp_device(struct virtio_device *vdev)
 void vp_synchronize_vectors(struct virtio_device *vdev);
 /* the notify function used when creating a virt queue */
 bool vp_notify(struct virtqueue *vq);
+bool vp_notify_with_data(struct virtqueue *vq);
 /* the config->del_vqs() implementation */
 void vp_del_vqs(struct virtio_device *vdev);
 /* the config->find_vqs() implementation */
@@ -114,6 +115,9 @@ int vp_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
 		struct irq_affinity *desc);
 const char *vp_bus_name(struct virtio_device *vdev);
 
+#define VP_NOTIFY(vdev) (__virtio_test_bit((vdev), VIRTIO_F_NOTIFICATION_DATA) \
+	? vp_notify : vp_notify_with_data)
+
 /* Setup the affinity for a virtqueue:
  * - force the affinity for per vq vector
  * - OR over all affinities for shared MSI
diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virtio_pci_legacy.c
index 2257f1b3d8ae..b98e994cae48 100644
--- a/drivers/virtio/virtio_pci_legacy.c
+++ b/drivers/virtio/virtio_pci_legacy.c
@@ -131,7 +131,7 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 	vq = vring_create_virtqueue(index, num,
 				    VIRTIO_PCI_VRING_ALIGN, &vp_dev->vdev,
 				    true, false, ctx,
-				    vp_notify, callback, name);
+				    VP_NOTIFY(&vp_dev->vdev), callback, name);
 	if (!vq)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index 9e496e288cfa..7fcd8af5af7e 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -321,7 +321,7 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 	vq = vring_create_virtqueue(index, num,
 				    SMP_CACHE_BYTES, &vp_dev->vdev,
 				    true, true, ctx,
-				    vp_notify, callback, name);
+				    VP_NOTIFY(&vp_dev->vdev), callback, name);
 	if (!vq)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 723c4e29e1d3..5e9e1800bb6e 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -2699,6 +2699,21 @@ void vring_del_virtqueue(struct virtqueue *_vq)
 }
 EXPORT_SYMBOL_GPL(vring_del_virtqueue);
 
+u32 vring_fill_notification_data(struct virtqueue *_vq)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+	u16 next;
+
+	if (vq->packed_ring)
+		next = (vq->packed.next_avail_idx & ~(1 << 15)) |
+			((u16)vq->packed.avail_wrap_counter << 15);
+	else
+		next = virtio16_to_cpu(_vq->vdev, vq->split.vring.avail->idx);
+
+	return ((u32)next << 16) | _vq->index;
+}
+EXPORT_SYMBOL_GPL(vring_fill_notification_data);
+
 /* Manipulates transport-specific feature bits. */
 void vring_transport_features(struct virtio_device *vdev)
 {
@@ -2718,6 +2733,8 @@ void vring_transport_features(struct virtio_device *vdev)
 			break;
 		case VIRTIO_F_ORDER_PLATFORM:
 			break;
+		case VIRTIO_F_NOTIFICATION_DATA:
+			break;
 		default:
 			/* We don't understand this bit. */
 			__virtio_clear_bit(vdev, i);
diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
index 8b8af1a38991..1f65d2f77012 100644
--- a/include/linux/virtio_ring.h
+++ b/include/linux/virtio_ring.h
@@ -101,4 +101,6 @@ void vring_del_virtqueue(struct virtqueue *vq);
 void vring_transport_features(struct virtio_device *vdev);
 
 irqreturn_t vring_interrupt(int irq, void *_vq);
+
+u32 vring_fill_notification_data(struct virtqueue *_vq);
 #endif /* _LINUX_VIRTIO_RING_H */
diff --git a/include/uapi/linux/virtio_config.h b/include/uapi/linux/virtio_config.h
index 3c05162bc988..2c712c654165 100644
--- a/include/uapi/linux/virtio_config.h
+++ b/include/uapi/linux/virtio_config.h
@@ -99,6 +99,12 @@
  */
 #define VIRTIO_F_SR_IOV			37
 
+/*
+ * This feature indicates that the driver passes extra data (besides
+ * identifying the virtqueue) in its device notifications.
+ */
+#define VIRTIO_F_NOTIFICATION_DATA	38
+
 /*
  * This feature indicates that the driver can reset a queue individually.
  */
-- 
2.35.1

