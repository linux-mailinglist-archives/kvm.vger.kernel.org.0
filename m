Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B269A2B0C1B
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 19:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgKLSBh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Nov 2020 13:01:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgKLR7K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Nov 2020 12:59:10 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88836C061A49
        for <kvm@vger.kernel.org>; Thu, 12 Nov 2020 09:59:09 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id q5so5247370pfk.6
        for <kvm@vger.kernel.org>; Thu, 12 Nov 2020 09:59:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PuUUU3p4QVu/Pg/pLrotXd8fVuKl/UFHWCvdQMnFV/A=;
        b=QtWpuolFjfwWayF+iM+Kx5bF9ELZg3e0z2vz7ZE3EnonI8SqN9JDCJ7amklQIUFErC
         5phfYVRzX+u8RVLCwrLIHaUy9bLTY/IitELKWrf2iZa6Z4SoSIE9NOvVM/CrXWx+2I4H
         g0k2q4p3Bu82m1zXEtFMFYmReiUmBmgQM9tlU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PuUUU3p4QVu/Pg/pLrotXd8fVuKl/UFHWCvdQMnFV/A=;
        b=awulOsso5FuYhEc4PAkNmzcc2Zuwz0cAJCR8JZOrjjiIXmxAxHc0BBueUsc8p5isjC
         uzSbZy5bGxG5IwYN7GOTob+5mr1GCAaotxeR4rbjnY/m7OhvD5IXF3x4Egigog2ukZkI
         0D5MVZHrKsvdpoBO5a1d/ywygoLkiXf2cnPAUZjLXvvlNt7hbVXkc0pfJoueA1UbVaeG
         xmu9C/jvaRQ20FcktDUDnNVDCynLrk3D6fZg55UQDFJJENg4+Jx1p140FZc0q/114Apq
         6zlyaNs0biyzwC35i5iL25cB2/1vUPx3Hk2pyc5tTluU0MwNM+ZsfBCpocnbS6H3XAic
         oRIA==
X-Gm-Message-State: AOAM532S1Uz68unJiib7EZLDTlqCQSUL66M/shu4RbhHiJgZEnrzoPxx
        jZRGy8fW7vb75eX3VJLXp0u76A==
X-Google-Smtp-Source: ABdhPJy1GJBC7yz+eSn937IoFvW91G5+hjuiJAzTKYCu6D5Yy1VQny5ExJzX6Osa660WGp7YCp6G7A==
X-Received: by 2002:a63:a65:: with SMTP id z37mr518139pgk.361.1605203948839;
        Thu, 12 Nov 2020 09:59:08 -0800 (PST)
Received: from rahul_yocto_ubuntu18.ibn.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id r6sm7237894pjd.39.2020.11.12.09.59.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 09:59:08 -0800 (PST)
From:   Vikas Gupta <vikas.gupta@broadcom.com>
To:     eric.auger@redhat.com, alex.williamson@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     vikram.prakash@broadcom.com, srinath.mannam@broadcom.com,
        Vikas Gupta <vikas.gupta@broadcom.com>
Subject: [RFC v1 1/3] vfio/platform: add support for msi
Date:   Thu, 12 Nov 2020 23:28:50 +0530
Message-Id: <20201112175852.21572-2-vikas.gupta@broadcom.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201112175852.21572-1-vikas.gupta@broadcom.com>
References: <20201105060257.35269-1-vikas.gupta@broadcom.com>
 <20201112175852.21572-1-vikas.gupta@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000031832305b3ecab97"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--00000000000031832305b3ecab97

MSI support for platform devices.

Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
---
 drivers/vfio/platform/vfio_platform_common.c  |  84 ++++++-
 drivers/vfio/platform/vfio_platform_irq.c     | 238 +++++++++++++++++-
 drivers/vfio/platform/vfio_platform_private.h |  23 ++
 3 files changed, 331 insertions(+), 14 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index c0771a9567fb..226aa8083751 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -26,6 +26,10 @@
 #define VFIO_PLATFORM_IS_ACPI(vdev) ((vdev)->acpihid != NULL)
 
 static LIST_HEAD(reset_list);
+
+/* devices having MSI support */
+static LIST_HEAD(msi_list);
+
 static DEFINE_MUTEX(driver_lock);
 
 static vfio_platform_reset_fn_t vfio_platform_lookup_reset(const char *compat,
@@ -47,6 +51,26 @@ static vfio_platform_reset_fn_t vfio_platform_lookup_reset(const char *compat,
 	return reset_fn;
 }
 
+static bool vfio_platform_lookup_msi(struct vfio_platform_device *vdev)
+{
+	bool has_msi = false;
+	struct vfio_platform_msi_node *iter;
+
+	mutex_lock(&driver_lock);
+	list_for_each_entry(iter, &msi_list, link) {
+		if (!strcmp(iter->compat, vdev->compat) &&
+		    try_module_get(iter->owner)) {
+			vdev->msi_module = iter->owner;
+			vdev->of_get_msi = iter->of_get_msi;
+			vdev->of_msi_write = iter->of_msi_write;
+			has_msi = true;
+			break;
+		}
+	}
+	mutex_unlock(&driver_lock);
+	return has_msi;
+}
+
 static int vfio_platform_acpi_probe(struct vfio_platform_device *vdev,
 				    struct device *dev)
 {
@@ -126,6 +150,19 @@ static int vfio_platform_get_reset(struct vfio_platform_device *vdev)
 	return vdev->of_reset ? 0 : -ENOENT;
 }
 
+static int vfio_platform_get_msi(struct vfio_platform_device *vdev)
+{
+	bool has_msi;
+
+	has_msi = vfio_platform_lookup_msi(vdev);
+	if (!has_msi) {
+		request_module("vfio-msi:%s", vdev->compat);
+		has_msi = vfio_platform_lookup_msi(vdev);
+	}
+
+	return has_msi ? 0 : -ENOENT;
+}
+
 static void vfio_platform_put_reset(struct vfio_platform_device *vdev)
 {
 	if (VFIO_PLATFORM_IS_ACPI(vdev))
@@ -135,6 +172,12 @@ static void vfio_platform_put_reset(struct vfio_platform_device *vdev)
 		module_put(vdev->reset_module);
 }
 
+static void vfio_platform_put_msi(struct vfio_platform_device *vdev)
+{
+	if (vdev->of_get_msi)
+		module_put(vdev->msi_module);
+}
+
 static int vfio_platform_regions_init(struct vfio_platform_device *vdev)
 {
 	int cnt = 0, i;
@@ -313,6 +356,7 @@ static long vfio_platform_ioctl(void *device_data,
 
 		if (vfio_platform_has_reset(vdev))
 			vdev->flags |= VFIO_DEVICE_FLAGS_RESET;
+
 		info.flags = vdev->flags;
 		info.num_regions = vdev->num_regions;
 		info.num_irqs = vdev->num_irqs;
@@ -366,6 +410,7 @@ static long vfio_platform_ioctl(void *device_data,
 		struct vfio_irq_set hdr;
 		u8 *data = NULL;
 		int ret = 0;
+		int max;
 		size_t data_size = 0;
 
 		minsz = offsetofend(struct vfio_irq_set, count);
@@ -373,7 +418,12 @@ static long vfio_platform_ioctl(void *device_data,
 		if (copy_from_user(&hdr, (void __user *)arg, minsz))
 			return -EFAULT;
 
-		ret = vfio_set_irqs_validate_and_prepare(&hdr, vdev->num_irqs,
+		if (hdr.index >= vdev->num_irqs)
+			return -EINVAL;
+
+		max = vdev->irqs[hdr.index].count;
+
+		ret = vfio_set_irqs_validate_and_prepare(&hdr, max,
 						 vdev->num_irqs, &data_size);
 		if (ret)
 			return ret;
@@ -679,11 +729,15 @@ int vfio_platform_probe_common(struct vfio_platform_device *vdev,
 		return ret;
 	}
 
+	ret = vfio_platform_get_msi(vdev);
+	if (ret)
+		dev_info(vdev->device, "msi not supported\n");
+
 	group = vfio_iommu_group_get(dev);
 	if (!group) {
 		dev_err(dev, "No IOMMU group for device %s\n", vdev->name);
 		ret = -EINVAL;
-		goto put_reset;
+		goto put_msi;
 	}
 
 	ret = vfio_add_group_dev(dev, &vfio_platform_ops, vdev);
@@ -697,6 +751,8 @@ int vfio_platform_probe_common(struct vfio_platform_device *vdev,
 
 put_iommu:
 	vfio_iommu_group_put(group, dev);
+put_msi:
+	vfio_platform_put_msi(vdev);
 put_reset:
 	vfio_platform_put_reset(vdev);
 	return ret;
@@ -745,6 +801,30 @@ void vfio_platform_unregister_reset(const char *compat,
 }
 EXPORT_SYMBOL_GPL(vfio_platform_unregister_reset);
 
+void __vfio_platform_register_msi(struct vfio_platform_msi_node *node)
+{
+	mutex_lock(&driver_lock);
+	list_add(&node->link, &msi_list);
+	mutex_unlock(&driver_lock);
+}
+EXPORT_SYMBOL_GPL(__vfio_platform_register_msi);
+
+void vfio_platform_unregister_msi(const char *compat)
+{
+	struct vfio_platform_msi_node *iter, *temp;
+
+	mutex_lock(&driver_lock);
+	list_for_each_entry_safe(iter, temp, &msi_list, link) {
+		if (!strcmp(iter->compat, compat)) {
+			list_del(&iter->link);
+			break;
+		}
+	}
+
+	mutex_unlock(&driver_lock);
+}
+EXPORT_SYMBOL_GPL(vfio_platform_unregister_msi);
+
 MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR(DRIVER_AUTHOR);
diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index c5b09ec0a3c9..3ee736dcb3c5 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -8,10 +8,12 @@
 
 #include <linux/eventfd.h>
 #include <linux/interrupt.h>
+#include <linux/eventfd.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/vfio.h>
 #include <linux/irq.h>
+#include <linux/msi.h>
 
 #include "vfio_platform_private.h"
 
@@ -253,6 +255,176 @@ static int vfio_platform_set_irq_trigger(struct vfio_platform_device *vdev,
 	return 0;
 }
 
+/* MSI/MSIX */
+static irqreturn_t vfio_msihandler(int irq, void *arg)
+{
+	struct eventfd_ctx *trigger = arg;
+
+	eventfd_signal(trigger, 1);
+	return IRQ_HANDLED;
+}
+
+static void msi_write(struct msi_desc *desc, struct msi_msg *msg)
+{
+	struct device *dev = msi_desc_to_dev(desc);
+	struct vfio_device *device = dev_get_drvdata(dev);
+	struct vfio_platform_device *vdev = (struct vfio_platform_device *)
+						vfio_device_data(device);
+
+	vdev->of_msi_write(vdev, desc, msg);
+}
+
+static int vfio_msi_enable(struct vfio_platform_device *vdev, int nvec)
+{
+	int ret;
+	int msi_idx = 0;
+	struct msi_desc *desc;
+	struct device *dev = vdev->device;
+	int msi_off = vdev->num_irqs - 1;
+
+	/* Allocate platform MSIs */
+	ret = platform_msi_domain_alloc_irqs(dev, nvec, msi_write);
+	if (ret < 0)
+		return ret;
+
+	for_each_msi_entry(desc, dev) {
+		vdev->irqs[msi_off + msi_idx].hwirq = desc->irq;
+		msi_idx++;
+	}
+
+	vdev->num_msis = nvec;
+	vdev->config_msi = 1;
+
+	return 0;
+}
+
+static int vfio_msi_set_vector_signal(struct vfio_platform_device *vdev,
+				      int vector, int fd)
+{
+	struct eventfd_ctx *trigger;
+	int irq, ret;
+	int msi_off = vdev->num_irqs - 1;
+
+	if (vector < 0 || vector >= vdev->num_msis)
+		return -EINVAL;
+
+	irq = vdev->irqs[msi_off + vector].hwirq;
+
+	if (vdev->irqs[vector].trigger) {
+		free_irq(irq, vdev->irqs[vector].trigger);
+		kfree(vdev->irqs[vector].name);
+		eventfd_ctx_put(vdev->irqs[vector].trigger);
+		vdev->irqs[vector].trigger = NULL;
+	}
+
+	if (fd < 0)
+		return 0;
+
+	vdev->irqs[vector].name = kasprintf(GFP_KERNEL,
+					    "vfio-msi[%d]", vector);
+	if (!vdev->irqs[vector].name)
+		return -ENOMEM;
+
+	trigger = eventfd_ctx_fdget(fd);
+	if (IS_ERR(trigger)) {
+		kfree(vdev->irqs[vector].name);
+		return PTR_ERR(trigger);
+	}
+
+	ret = request_irq(irq, vfio_msihandler, 0,
+			  vdev->irqs[vector].name, trigger);
+	if (ret) {
+		kfree(vdev->irqs[vector].name);
+		eventfd_ctx_put(trigger);
+		return ret;
+	}
+
+	vdev->irqs[vector].trigger = trigger;
+
+	return 0;
+}
+
+static int vfio_msi_set_block(struct vfio_platform_device *vdev, unsigned int start,
+			      unsigned int count, int32_t *fds)
+{
+	int i, j, ret = 0;
+
+	if (start >= vdev->num_msis || start + count > vdev->num_msis)
+		return -EINVAL;
+
+	for (i = 0, j = start; i < count && !ret; i++, j++) {
+		int fd = fds ? fds[i] : -1;
+
+		ret = vfio_msi_set_vector_signal(vdev, j, fd);
+	}
+
+	if (ret) {
+		for (--j; j >= (int)start; j--)
+			vfio_msi_set_vector_signal(vdev, j, -1);
+	}
+
+	return ret;
+}
+
+static void vfio_msi_disable(struct vfio_platform_device *vdev)
+{
+	struct device *dev = vdev->device;
+
+	vfio_msi_set_block(vdev, 0, vdev->num_msis, NULL);
+	platform_msi_domain_free_irqs(dev);
+
+	vdev->config_msi = 0;
+	vdev->num_msis = 0;
+}
+
+static int vfio_set_msi_trigger(struct vfio_platform_device *vdev,
+				unsigned int index, unsigned int start,
+				unsigned int count, uint32_t flags, void *data)
+{
+	int i;
+
+	if (start + count > vdev->num_msis)
+		return -EINVAL;
+
+	if (!count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
+		vfio_msi_disable(vdev);
+		return 0;
+	}
+
+	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
+		s32 *fds = data;
+		int ret;
+
+		if (vdev->config_msi)
+			return vfio_msi_set_block(vdev, start, count,
+						  fds);
+		ret = vfio_msi_enable(vdev, start + count);
+		if (ret)
+			return ret;
+
+		ret = vfio_msi_set_block(vdev, start, count, fds);
+		if (ret)
+			vfio_msi_disable(vdev);
+
+		return ret;
+	}
+
+	for (i = start; i < start + count; i++) {
+		if (!vdev->irqs[i].trigger)
+			continue;
+		if (flags & VFIO_IRQ_SET_DATA_NONE) {
+			eventfd_signal(vdev->irqs[i].trigger, 1);
+		} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
+			u8 *bools = data;
+
+			if (bools[i - start])
+				eventfd_signal(vdev->irqs[i].trigger, 1);
+		}
+	}
+
+	return 0;
+}
+
 int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
 				 uint32_t flags, unsigned index, unsigned start,
 				 unsigned count, void *data)
@@ -261,16 +433,29 @@ int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
 		    unsigned start, unsigned count, uint32_t flags,
 		    void *data) = NULL;
 
-	switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
-	case VFIO_IRQ_SET_ACTION_MASK:
-		func = vfio_platform_set_irq_mask;
-		break;
-	case VFIO_IRQ_SET_ACTION_UNMASK:
-		func = vfio_platform_set_irq_unmask;
-		break;
-	case VFIO_IRQ_SET_ACTION_TRIGGER:
-		func = vfio_platform_set_irq_trigger;
-		break;
+	struct vfio_platform_irq *irq = &vdev->irqs[index];
+
+	if (!irq->is_msi) {
+		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
+		case VFIO_IRQ_SET_ACTION_MASK:
+			func = vfio_platform_set_irq_mask;
+			break;
+		case VFIO_IRQ_SET_ACTION_UNMASK:
+			func = vfio_platform_set_irq_unmask;
+			break;
+		case VFIO_IRQ_SET_ACTION_TRIGGER:
+			func = vfio_platform_set_irq_trigger;
+			break;
+		}
+	} else {
+		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
+		case VFIO_IRQ_SET_ACTION_MASK:
+		case VFIO_IRQ_SET_ACTION_UNMASK:
+			break;
+		case VFIO_IRQ_SET_ACTION_TRIGGER:
+			func = vfio_set_msi_trigger;
+			break;
+		}
 	}
 
 	if (!func)
@@ -282,11 +467,17 @@ int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
 int vfio_platform_irq_init(struct vfio_platform_device *vdev)
 {
 	int cnt = 0, i;
+	int msi_cnt = 0;
 
 	while (vdev->get_irq(vdev, cnt) >= 0)
 		cnt++;
 
-	vdev->irqs = kcalloc(cnt, sizeof(struct vfio_platform_irq), GFP_KERNEL);
+	if (vdev->of_get_msi)
+		msi_cnt = vdev->of_get_msi(vdev);
+	vdev->num_msis = msi_cnt;
+
+	vdev->irqs = kcalloc(cnt + msi_cnt, sizeof(struct vfio_platform_irq),
+			     GFP_KERNEL);
 	if (!vdev->irqs)
 		return -ENOMEM;
 
@@ -311,6 +502,21 @@ int vfio_platform_irq_init(struct vfio_platform_device *vdev)
 
 	vdev->num_irqs = cnt;
 
+	/*
+	 * MSI(s) are counted as '1' as far as number of IRQs
+	 * is concerned and it is at last index. We fill the
+	 * count in the first index of MSI(s).
+	 */
+	if (msi_cnt > 0) {
+		vdev->irqs[i].flags = VFIO_IRQ_INFO_EVENTFD;
+		vdev->irqs[i].count = msi_cnt;
+		vdev->irqs[i].hwirq = 0;
+		vdev->irqs[i].masked = false;
+		vdev->irqs[i].is_msi = true;
+
+		vdev->num_irqs++;
+	}
+
 	return 0;
 err:
 	kfree(vdev->irqs);
@@ -320,10 +526,18 @@ int vfio_platform_irq_init(struct vfio_platform_device *vdev)
 void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev)
 {
 	int i;
+	int non_msi_irqs = vdev->num_msis > 0 ?
+				 vdev->num_irqs - 1 : vdev->num_irqs;
 
-	for (i = 0; i < vdev->num_irqs; i++)
+	for (i = 0; i < non_msi_irqs; i++)
 		vfio_set_trigger(vdev, i, -1, NULL);
 
+	if (vdev->num_msis) {
+		vfio_set_msi_trigger(vdev, 0, 0, 0,
+				     VFIO_IRQ_SET_DATA_NONE, NULL);
+		vdev->num_msis = 0;
+	}
+
 	vdev->num_irqs = 0;
 	kfree(vdev->irqs);
 }
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index 289089910643..2aea445e1071 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -9,6 +9,7 @@
 
 #include <linux/types.h>
 #include <linux/interrupt.h>
+#include <linux/msi.h>
 
 #define VFIO_PLATFORM_OFFSET_SHIFT   40
 #define VFIO_PLATFORM_OFFSET_MASK (((u64)(1) << VFIO_PLATFORM_OFFSET_SHIFT) - 1)
@@ -26,6 +27,7 @@ struct vfio_platform_irq {
 	char			*name;
 	struct eventfd_ctx	*trigger;
 	bool			masked;
+	bool			is_msi;
 	spinlock_t		lock;
 	struct virqfd		*unmask;
 	struct virqfd		*mask;
@@ -46,13 +48,16 @@ struct vfio_platform_device {
 	u32				num_regions;
 	struct vfio_platform_irq	*irqs;
 	u32				num_irqs;
+	u32				num_msis;
 	int				refcnt;
 	struct mutex			igate;
 	struct module			*parent_module;
 	const char			*compat;
 	const char			*acpihid;
 	struct module			*reset_module;
+	struct module			*msi_module;
 	struct device			*device;
+	int				config_msi;
 
 	/*
 	 * These fields should be filled by the bus specific binder
@@ -65,11 +70,19 @@ struct vfio_platform_device {
 		(*get_resource)(struct vfio_platform_device *vdev, int i);
 	int	(*get_irq)(struct vfio_platform_device *vdev, int i);
 	int	(*of_reset)(struct vfio_platform_device *vdev);
+	u32	(*of_get_msi)(struct vfio_platform_device *vdev);
+	int	(*of_msi_write)(struct vfio_platform_device *vdev,
+				struct msi_desc *desc,
+				struct msi_msg *msg);
 
 	bool				reset_required;
 };
 
 typedef int (*vfio_platform_reset_fn_t)(struct vfio_platform_device *vdev);
+typedef u32 (*vfio_platform_get_msi_fn_t)(struct vfio_platform_device *vdev);
+typedef int (*vfio_platform_msi_write_fn_t)(struct vfio_platform_device *vdev,
+					    struct msi_desc *desc,
+					    struct msi_msg *msg);
 
 struct vfio_platform_reset_node {
 	struct list_head link;
@@ -78,6 +91,14 @@ struct vfio_platform_reset_node {
 	vfio_platform_reset_fn_t of_reset;
 };
 
+struct vfio_platform_msi_node {
+	struct list_head link;
+	char *compat;
+	struct module *owner;
+	vfio_platform_get_msi_fn_t of_get_msi;
+	vfio_platform_msi_write_fn_t of_msi_write;
+};
+
 extern int vfio_platform_probe_common(struct vfio_platform_device *vdev,
 				      struct device *dev);
 extern struct vfio_platform_device *vfio_platform_remove_common
@@ -94,6 +115,8 @@ extern int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
 extern void __vfio_platform_register_reset(struct vfio_platform_reset_node *n);
 extern void vfio_platform_unregister_reset(const char *compat,
 					   vfio_platform_reset_fn_t fn);
+void __vfio_platform_register_msi(struct vfio_platform_msi_node *n);
+void vfio_platform_unregister_msi(const char *compat);
 #define vfio_platform_register_reset(__compat, __reset)		\
 static struct vfio_platform_reset_node __reset ## _node = {	\
 	.owner = THIS_MODULE,					\
-- 
2.17.1


--00000000000031832305b3ecab97
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
2lQ6rFUP408r38ha7ieLj9GoHHitwSmKYwUIGObe2Y57xYNj855BF4wx44Z80uM2ugKCZwIDAQAB
o4IBzzCCAcswDgYDVR0PAQH/BAQDAgWgMIGeBggrBgEFBQcBAQSBkTCBjjBNBggrBgEFBQcwAoZB
aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NwZXJzb25hbHNpZ24yc2hhMmcz
b2NzcC5jcnQwPQYIKwYBBQUHMAGGMWh0dHA6Ly9vY3NwMi5nbG9iYWxzaWduLmNvbS9nc3BlcnNv
bmFsc2lnbjJzaGEyZzMwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0
dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwRAYDVR0fBD0w
OzA5oDegNYYzaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc3BlcnNvbmFsc2lnbjJzaGEyZzMu
Y3JsMCMGA1UdEQQcMBqBGHZpa2FzLmd1cHRhQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUnmgVV8btvFtO
FD3kFjPWxD/aB8MwDQYJKoZIhvcNAQELBQADggEBAGCcuBN7G3mbQ7xMF8g8Lpz6WE+UFmkSSqU3
FZLC2I92SA5lRIthcdz4AEgte6ywnef3+2mG7HWMoQ1wriSG5qLppAD02Uku6yRD52Sn67DB2Ozk
yhBJayurzUxN1+R5E/YZtj2fkNajS5+i85e83PZPvVJ8/WnseIADGvDoouWqK7mxU/p8hELdb3PW
JH2nMg39SpVAwmRqfs6mYtenpMwKtQd9goGkIFXqdSvOPATkbS1YIGtU2byLK+/1rIWPoKNmRddj
WOu/loxldI1sJa1tOHgtb93YpIe0HEmgxLGS0KEnbM+rn9vXNKCe+9n0PhxJIfqcf6rAtK0prRwr
Y2MxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDDTZ
lyNZkGMqSi5xbzANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgx5FxCYJVWHuJzfuV
NeoIeZcbhUlNQlMWdpu3kYWr5PUwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMTEyMTc1OTA5WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAE8hqXZGOOnB11ZWWte813psBdrdbaETflKb
H32teVng8lsNMYoiwYxQhjF+cjCBf/5NAsLo7lVGQSUgUfpBRI+6fGMYjaXJxx9qyjoaJ2pC8s8c
UnkMcUed04anlVfkp28m+kCDlrJgrUSxu2UY/rReVCRxgJ9d9t7BV4Q23gPyRDeXl8+BnNmQEi2+
3vNF0R8cCCs3L3p4eYg52JhpPRwPNPku+5kiCuRUd2glNDmup2EKn7zJrCf/RgmushjPkz7aypKp
DHgTXZD4lSQdRq2dcTo1RQ+Vuv5MtBcZAEqrWFZnSmgpQcyQ42NEx1Y/IukSz3tdhSswnGyEI7vZ
xvs=
--00000000000031832305b3ecab97--
