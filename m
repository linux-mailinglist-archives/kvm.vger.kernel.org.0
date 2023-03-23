Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4E2C6C6279
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 09:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbjCWI43 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 04:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbjCWI4H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 04:56:07 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 066C311153
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 01:56:00 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id y15so26753024lfa.7
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 01:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112; t=1679561758;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8aQFSBV7h0iJ/Ot8CCFDKFNyg9WyXqt+415qf5mDeMg=;
        b=4jlVh85hxuEA4jugxqNFa4o11Im6i9Xd5TdLgqR1KqUKo7WqSCHlliALtEtzsc/Hwx
         v6ntXa/nTmnpgriigwfvCzSOiYAxug328wd5lwDa60lDuO4mV7GjaEJ1HxFQYWj9Dvvw
         QxCEqrv5KOfJ0H67qwQkT/16lt8vEC3yA4F+hXI/0nSiUsH4edpkzeC/6F4LcE42Tb3c
         ewefabQ8BZiYHAxdUbE7wqMKFYwZ5V4P8NVtCBd3nny4x1LU1+KyM/Ckr1+Kh4dJYbIu
         Yg0j+AbPfYhgR2id5ZabAlXwRiFfxYA0RQraSnhZK7V+ifyaAl2R/ChW/rMg/41rLu1o
         nNmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679561758;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8aQFSBV7h0iJ/Ot8CCFDKFNyg9WyXqt+415qf5mDeMg=;
        b=pnAcRQ+GqZmqo3M0iN1eeoA96bQC9Olt3g3Zuf2JHXqQ6vIjR7cGWqJL9YTfHFQg3B
         Rzn1BVngP+wyxZL6pHM4coldgYj3uO/s1kjJ4baE16vTauLTEG7ec+CZzCGZPjHXvRIC
         8ZF6TtmoxbH6/9X6RJPCArBJ5Syi3zWstS+1YcKkUsN1BgX/sqZx9QjuhK3GtDofigM7
         0QVKovvGCh/5L6vGiVCRRjTP2QZzzU9D3mjaGybBBVtds9Z4+RHIMWly8GCp03VgOw0T
         vFBfDV2BjK7co0DF0ASFE09rRfL0+h+lhZ7WvJDk6FVj5cvEmRS2kTIbsBReOOaLFH2a
         9s5A==
X-Gm-Message-State: AO0yUKXNbRFpoZU/l/BZGuXHJ6G1Tze7ru/JReG5Fa8/FGEeC0+38idc
        ZWiK4+p8lFfvrVCeUDOfvane9g==
X-Google-Smtp-Source: AK7set8wnTc1nNplEH8m6f7uX4tXhqvBqvU/RBuMoK6Bkt3FbPoz14EDbIuuz0ryViOI8RirRxKygg==
X-Received: by 2002:a19:740e:0:b0:4e8:49ff:8df8 with SMTP id v14-20020a19740e000000b004e849ff8df8mr3160785lfe.61.1679561758274;
        Thu, 23 Mar 2023 01:55:58 -0700 (PDT)
Received: from vp-pc.. ([109.252.122.203])
        by smtp.gmail.com with ESMTPSA id g7-20020a19ac07000000b004e846175329sm2852439lfc.202.2023.03.23.01.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 01:55:58 -0700 (PDT)
From:   Viktor Prutyanov <viktor@daynix.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     cohuck@redhat.com, pasic@linux.ibm.com, farman@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, yan@daynix.com, viktor@daynix.com
Subject: [PATCH v5] virtio: add VIRTIO_F_NOTIFICATION_DATA feature support
Date:   Thu, 23 Mar 2023 11:55:51 +0300
Message-Id: <20230323085551.2346411-1-viktor@daynix.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
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

Add support for this feature for MMIO, channel I/O and modern PCI
transports.

Signed-off-by: Viktor Prutyanov <viktor@daynix.com>
---
 v5: replace ternary operator with if-else
 v4: remove VP_NOTIFY macro and legacy PCI support, add
    virtio_ccw_kvm_notify_with_data to virtio_ccw
 v3: support feature in virtio_ccw, remove VM_NOTIFY, use avail_idx_shadow,
    remove byte swap, rename to vring_notification_data
 v2: reject the feature in virtio_ccw, replace __le32 with u32

 Tested with disabled VIRTIO_F_NOTIFICATION_DATA on qemu-system-s390x
 (virtio-blk-ccw), qemu-system-riscv64 (virtio-blk-device,
 virtio-rng-device), qemu-system-x86_64 (virtio-blk-pci, virtio-net-pci)
 to make sure nothing is broken.
 Tested with enabled VIRTIO_F_NOTIFICATION_DATA on 64-bit RISC-V Linux
 and my hardware implementation of virtio-rng with MMIO.

 drivers/s390/virtio/virtio_ccw.c   | 22 +++++++++++++++++++---
 drivers/virtio/virtio_mmio.c       | 18 +++++++++++++++++-
 drivers/virtio/virtio_pci_modern.c | 17 ++++++++++++++++-
 drivers/virtio/virtio_ring.c       | 17 +++++++++++++++++
 include/linux/virtio_ring.h        |  2 ++
 include/uapi/linux/virtio_config.h |  6 ++++++
 6 files changed, 77 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index 954fc31b4bc7..9a9c5d34454c 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -391,7 +391,7 @@ static void virtio_ccw_drop_indicator(struct virtio_ccw_device *vcdev,
 	ccw_device_dma_free(vcdev->cdev, thinint_area, sizeof(*thinint_area));
 }
 
-static bool virtio_ccw_kvm_notify(struct virtqueue *vq)
+static inline bool virtio_ccw_do_kvm_notify(struct virtqueue *vq, u32 data)
 {
 	struct virtio_ccw_vq_info *info = vq->priv;
 	struct virtio_ccw_device *vcdev;
@@ -402,12 +402,22 @@ static bool virtio_ccw_kvm_notify(struct virtqueue *vq)
 	BUILD_BUG_ON(sizeof(struct subchannel_id) != sizeof(unsigned int));
 	info->cookie = kvm_hypercall3(KVM_S390_VIRTIO_CCW_NOTIFY,
 				      *((unsigned int *)&schid),
-				      vq->index, info->cookie);
+				      data, info->cookie);
 	if (info->cookie < 0)
 		return false;
 	return true;
 }
 
+static bool virtio_ccw_kvm_notify(struct virtqueue *vq)
+{
+	return virtio_ccw_do_kvm_notify(vq, vq->index);
+}
+
+static bool virtio_ccw_kvm_notify_with_data(struct virtqueue *vq)
+{
+	return virtio_ccw_do_kvm_notify(vq, vring_notification_data(vq));
+}
+
 static int virtio_ccw_read_vq_conf(struct virtio_ccw_device *vcdev,
 				   struct ccw1 *ccw, int index)
 {
@@ -501,6 +511,12 @@ static struct virtqueue *virtio_ccw_setup_vq(struct virtio_device *vdev,
 	u64 queue;
 	unsigned long flags;
 	bool may_reduce;
+	bool (*notify)(struct virtqueue *vq);
+
+	if (__virtio_test_bit(vdev, VIRTIO_F_NOTIFICATION_DATA))
+		notify = virtio_ccw_kvm_notify_with_data;
+	else
+		notify = virtio_ccw_kvm_notify;
 
 	/* Allocate queue. */
 	info = kzalloc(sizeof(struct virtio_ccw_vq_info), GFP_KERNEL);
@@ -524,7 +540,7 @@ static struct virtqueue *virtio_ccw_setup_vq(struct virtio_device *vdev,
 	may_reduce = vcdev->revision > 0;
 	vq = vring_create_virtqueue(i, info->num, KVM_VIRTIO_CCW_RING_ALIGN,
 				    vdev, true, may_reduce, ctx,
-				    virtio_ccw_kvm_notify, callback, name);
+				    notify, callback, name);
 
 	if (!vq) {
 		/* For now, we fail if we can't get the requested size. */
diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index 3ff746e3f24a..7e87f745f68d 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -285,6 +285,16 @@ static bool vm_notify(struct virtqueue *vq)
 	return true;
 }
 
+static bool vm_notify_with_data(struct virtqueue *vq)
+{
+	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vq->vdev);
+	u32 data = vring_notification_data(vq);
+
+	writel(data, vm_dev->base + VIRTIO_MMIO_QUEUE_NOTIFY);
+
+	return true;
+}
+
 /* Notify all virtqueues on an interrupt. */
 static irqreturn_t vm_interrupt(int irq, void *opaque)
 {
@@ -368,6 +378,12 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned int in
 	unsigned long flags;
 	unsigned int num;
 	int err;
+	bool (*notify)(struct virtqueue *vq);
+
+	if (__virtio_test_bit(vdev, VIRTIO_F_NOTIFICATION_DATA))
+		notify = vm_notify_with_data;
+	else
+		notify = vm_notify;
 
 	if (!name)
 		return NULL;
@@ -397,7 +413,7 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned int in
 
 	/* Create the vring */
 	vq = vring_create_virtqueue(index, num, VIRTIO_MMIO_VRING_ALIGN, vdev,
-				 true, true, ctx, vm_notify, callback, name);
+				 true, true, ctx, notify, callback, name);
 	if (!vq) {
 		err = -ENOMEM;
 		goto error_new_virtqueue;
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index 9e496e288cfa..3bfc368b279e 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -288,6 +288,15 @@ static u16 vp_config_vector(struct virtio_pci_device *vp_dev, u16 vector)
 	return vp_modern_config_vector(&vp_dev->mdev, vector);
 }
 
+static bool vp_notify_with_data(struct virtqueue *vq)
+{
+	u32 data = vring_notification_data(vq);
+
+	iowrite32(data, (void __iomem *)vq->priv);
+
+	return true;
+}
+
 static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 				  struct virtio_pci_vq_info *info,
 				  unsigned int index,
@@ -301,6 +310,12 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 	struct virtqueue *vq;
 	u16 num;
 	int err;
+	bool (*notify)(struct virtqueue *vq);
+
+	if (__virtio_test_bit(&vp_dev->vdev, VIRTIO_F_NOTIFICATION_DATA))
+		notify = vp_notify_with_data;
+	else
+		notify = vp_notify;
 
 	if (index >= vp_modern_get_num_queues(mdev))
 		return ERR_PTR(-EINVAL);
@@ -321,7 +336,7 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 	vq = vring_create_virtqueue(index, num,
 				    SMP_CACHE_BYTES, &vp_dev->vdev,
 				    true, true, ctx,
-				    vp_notify, callback, name);
+				    notify, callback, name);
 	if (!vq)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 4c3bb0ddeb9b..837875cc3190 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -2752,6 +2752,21 @@ void vring_del_virtqueue(struct virtqueue *_vq)
 }
 EXPORT_SYMBOL_GPL(vring_del_virtqueue);
 
+u32 vring_notification_data(struct virtqueue *_vq)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+	u16 next;
+
+	if (vq->packed_ring)
+		next = (vq->packed.next_avail_idx & ~(1 << 15)) |
+			vq->packed.avail_wrap_counter << 15;
+	else
+		next = vq->split.avail_idx_shadow;
+
+	return next << 16 | _vq->index;
+}
+EXPORT_SYMBOL_GPL(vring_notification_data);
+
 /* Manipulates transport-specific feature bits. */
 void vring_transport_features(struct virtio_device *vdev)
 {
@@ -2771,6 +2786,8 @@ void vring_transport_features(struct virtio_device *vdev)
 			break;
 		case VIRTIO_F_ORDER_PLATFORM:
 			break;
+		case VIRTIO_F_NOTIFICATION_DATA:
+			break;
 		default:
 			/* We don't understand this bit. */
 			__virtio_clear_bit(vdev, i);
diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
index 8b95b69ef694..2550c9170f4f 100644
--- a/include/linux/virtio_ring.h
+++ b/include/linux/virtio_ring.h
@@ -117,4 +117,6 @@ void vring_del_virtqueue(struct virtqueue *vq);
 void vring_transport_features(struct virtio_device *vdev);
 
 irqreturn_t vring_interrupt(int irq, void *_vq);
+
+u32 vring_notification_data(struct virtqueue *_vq);
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

