Return-Path: <kvm+bounces-12824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4174988E2D5
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 14:34:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC7F92A57BE
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 13:34:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B521E176FCA;
	Wed, 27 Mar 2024 12:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cJT9jP30"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7AB176FB6;
	Wed, 27 Mar 2024 12:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711542192; cv=none; b=obuuqkB27ztFKbCniDQ5uk/eiCzuujKUkBUvqIK9+rZJqeJrL1DNoppwshy9zKALKOC1k9wIRDTW6y8zpspC1Kro9jD6RM4Ehsgl2XglM2IG0qjotgAX9hhzwsdJDMXx+tFDLEeMAecnKGvI2VOJ7vf6HLKs+4tuSUtcoyRmwic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711542192; c=relaxed/simple;
	bh=eLFQbR/r/tzkwHIq38YbW6Iq3e32kOr/3TLdPsCSwEw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=npVmq7IsrM2lu2XGuX9i47+kLnjikFjXbUTo/dci/DYJo7OgGwaIw5RpuYpNNwp5caB6PaPumyFfULZeU1JjjK1vpuZCHrAbggN7roy9ZMi6xgxOqrVjMQwq60JxrUq+Y9pQ2UgrgDgaH7wvGkD7EFEC9rZbcYwywOWi6W8qGOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cJT9jP30; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868B6C433F1;
	Wed, 27 Mar 2024 12:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711542192;
	bh=eLFQbR/r/tzkwHIq38YbW6Iq3e32kOr/3TLdPsCSwEw=;
	h=From:To:Cc:Subject:Date:From;
	b=cJT9jP307IwlGx1sUL+9xTq1lT3SLfBYbqAsbVNgEWWyOoLcD2L2t42kONZMOiJCB
	 HMD99xqb9l4+EeL/BBUm8uDva1d5CxZZt11/ugHhFAMSrbuY1zrgenu+CETPrnH3Ef
	 qtoIo4VzZnrBYSaRgW5w9qls0WWijpEcAkdK0nEf5s8n43xwMVbTKU8ZLOfwLGcD9W
	 T1pZLgdEcQqIABTl46E8qLO1ohvx71NItDOqWvx2f5BefMWAJ3yJICM6SYf1oV5YNj
	 V29fPNRBA1ZCjrQc8NKjQeqQPyMJ+KKZ8ptSoJ/5/RP5eJ/hUl3yv5wXGkhJAVoC5/
	 fqlB1pQDJ8sGg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	alex.williamson@redhat.com
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: FAILED: Patch "vfio/pci: Lock external INTx masking ops" failed to apply to 5.4-stable tree
Date: Wed, 27 Mar 2024 08:23:10 -0400
Message-ID: <20240327122310.2838282-1-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 810cd4bb53456d0503cc4e7934e063835152c1b7 Mon Sep 17 00:00:00 2001
From: Alex Williamson <alex.williamson@redhat.com>
Date: Fri, 8 Mar 2024 16:05:23 -0700
Subject: [PATCH] vfio/pci: Lock external INTx masking ops

Mask operations through config space changes to DisINTx may race INTx
configuration changes via ioctl.  Create wrappers that add locking for
paths outside of the core interrupt code.

In particular, irq_type is updated holding igate, therefore testing
is_intx() requires holding igate.  For example clearing DisINTx from
config space can otherwise race changes of the interrupt configuration.

This aligns interfaces which may trigger the INTx eventfd into two
camps, one side serialized by igate and the other only enabled while
INTx is configured.  A subsequent patch introduces synchronization for
the latter flows.

Cc:  <stable@vger.kernel.org>
Fixes: 89e1f7d4c66d ("vfio: Add PCI device driver")
Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Link: https://lore.kernel.org/r/20240308230557.805580-3-alex.williamson@redhat.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 34 +++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 136101179fcbd..75c85eec21b3c 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -99,13 +99,15 @@ static void vfio_send_intx_eventfd(void *opaque, void *unused)
 }
 
 /* Returns true if the INTx vfio_pci_irq_ctx.masked value is changed. */
-bool vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
+static bool __vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	struct vfio_pci_irq_ctx *ctx;
 	unsigned long flags;
 	bool masked_changed = false;
 
+	lockdep_assert_held(&vdev->igate);
+
 	spin_lock_irqsave(&vdev->irqlock, flags);
 
 	/*
@@ -143,6 +145,17 @@ bool vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
 	return masked_changed;
 }
 
+bool vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
+{
+	bool mask_changed;
+
+	mutex_lock(&vdev->igate);
+	mask_changed = __vfio_pci_intx_mask(vdev);
+	mutex_unlock(&vdev->igate);
+
+	return mask_changed;
+}
+
 /*
  * If this is triggered by an eventfd, we can't call eventfd_signal
  * or else we'll deadlock on the eventfd wait queue.  Return >0 when
@@ -194,12 +207,21 @@ static int vfio_pci_intx_unmask_handler(void *opaque, void *unused)
 	return ret;
 }
 
-void vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev)
+static void __vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev)
 {
+	lockdep_assert_held(&vdev->igate);
+
 	if (vfio_pci_intx_unmask_handler(vdev, NULL) > 0)
 		vfio_send_intx_eventfd(vdev, NULL);
 }
 
+void vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev)
+{
+	mutex_lock(&vdev->igate);
+	__vfio_pci_intx_unmask(vdev);
+	mutex_unlock(&vdev->igate);
+}
+
 static irqreturn_t vfio_intx_handler(int irq, void *dev_id)
 {
 	struct vfio_pci_core_device *vdev = dev_id;
@@ -563,11 +585,11 @@ static int vfio_pci_set_intx_unmask(struct vfio_pci_core_device *vdev,
 		return -EINVAL;
 
 	if (flags & VFIO_IRQ_SET_DATA_NONE) {
-		vfio_pci_intx_unmask(vdev);
+		__vfio_pci_intx_unmask(vdev);
 	} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
 		uint8_t unmask = *(uint8_t *)data;
 		if (unmask)
-			vfio_pci_intx_unmask(vdev);
+			__vfio_pci_intx_unmask(vdev);
 	} else if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
 		struct vfio_pci_irq_ctx *ctx = vfio_irq_ctx_get(vdev, 0);
 		int32_t fd = *(int32_t *)data;
@@ -594,11 +616,11 @@ static int vfio_pci_set_intx_mask(struct vfio_pci_core_device *vdev,
 		return -EINVAL;
 
 	if (flags & VFIO_IRQ_SET_DATA_NONE) {
-		vfio_pci_intx_mask(vdev);
+		__vfio_pci_intx_mask(vdev);
 	} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
 		uint8_t mask = *(uint8_t *)data;
 		if (mask)
-			vfio_pci_intx_mask(vdev);
+			__vfio_pci_intx_mask(vdev);
 	} else if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
 		return -ENOTTY; /* XXX implement me */
 	}
-- 
2.43.0





