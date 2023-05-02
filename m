Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB356F44F5
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 15:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234100AbjEBN1P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 09:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234074AbjEBN1M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 09:27:12 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2068B6181
        for <kvm@vger.kernel.org>; Tue,  2 May 2023 06:27:09 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-4f0037de1d1so4485924e87.0
        for <kvm@vger.kernel.org>; Tue, 02 May 2023 06:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google; t=1683034027; x=1685626027;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KQ9fhPJG2Y/6Knf/bB3jEwtwDnnjW9NY0l1i398fVX8=;
        b=YrshEjVnjE6RpscFe00p3aqOjgUK/CJMpQZrP+7dXsRf4XjN8EDtCWChZs2HvFfHxA
         vHcx+ZaSerEsZn8BgacGkXx+58a35VllAtCYy4eN2o/wvX3s0dBIxb9Ub3ianZWMbiDv
         51dZrQjEAs7xaFFDaQZAlPRSWnuPmYmHAMQWcireomnG0eCKkRw+jKhndFvupREzNuJw
         Gl7LnjoZyBPNXos8d9Hj0Kpgcm5GFCEgBpHIV4n24BbDWXFwSuBLphWSKiLCPvMjdqnW
         wNYVux6kS3Zxrct8UnlABQgQA02zP8rxl0uxgVrONNTI6WN2zZCzYWH/QDSKCntYHXFp
         wNJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683034027; x=1685626027;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KQ9fhPJG2Y/6Knf/bB3jEwtwDnnjW9NY0l1i398fVX8=;
        b=EpxEOwSoNVEvo8w+oxccxedqO7EyMUsy51npNo3lL/BO5phyFIWuLEmqkgnQjQp7PY
         hoz5hKCa1KdYTYqEs4rba0IgPVddZye23vFLEn4n0LI1YtLRZSydWjm5gDKM1B8UrqOU
         55Y5T6Jm+eXqAtKWqdHfHnJv9aeIgagKvucm2tnkFzbRp9VE6d5Sf2vM7OxXCqUNLGmh
         FAzosyLqUZ6WMi6QobwzbXcGZ1On9csWCmM5bHs3jYuOSZMjiCCwV/PAasnE/kmFYeUF
         6QEIfy6lMHwbEVz0oTd2Q24mUEStueKECIrx3cbE00paaSLk6vpvB0QwK2dcYTHQIxS0
         prNg==
X-Gm-Message-State: AC+VfDzyLc++QjStqfh+7FWy++NYV+bcwcEGOqUmE3KDCJdX3vBY7Vjx
        SBcp6e3aqyLgv2WG0HxwF/PMTw==
X-Google-Smtp-Source: ACHHUZ6xIH36cull7lATgnlY9kxs50FaMkcO1K6T346X1BrKVWY2yXbZ2oWOwu0Y8+l7uY7Hx7M0zQ==
X-Received: by 2002:a19:ac43:0:b0:4f1:1de7:1aac with SMTP id r3-20020a19ac43000000b004f11de71aacmr1810249lfc.20.1683034027281;
        Tue, 02 May 2023 06:27:07 -0700 (PDT)
Received: from jazctssd.c.googlers.com.com (138.58.228.35.bc.googleusercontent.com. [35.228.58.138])
        by smtp.gmail.com with ESMTPSA id l17-20020ac24a91000000b00498f67cbfa9sm5372301lfp.22.2023.05.02.06.27.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 06:27:06 -0700 (PDT)
From:   Grzegorz Jaszczyk <jaz@semihalf.com>
X-Google-Original-From: Grzegorz Jaszczyk <jaszczyk@google.com>
To:     linux-kernel@vger.kernel.org, alex.williamson@redhat.com
Cc:     dmy@semihalf.com, tn@semihalf.com, dbehr@google.com,
        dbehr@chromium.org, upstream@semihalf.com, dtor@google.com,
        jgg@ziepe.ca, kevin.tian@intel.com, cohuck@redhat.com,
        abhsahu@nvidia.com, yishaih@nvidia.com, yi.l.liu@intel.com,
        kvm@vger.kernel.org, libvir-list@redhat.com,
        Grzegorz Jaszczyk <jaz@semihalf.com>
Subject: [PATCH v3] vfio/pci: Propagate ACPI notifications to user-space via eventfd
Date:   Tue,  2 May 2023 13:27:00 +0000
Message-ID: <20230502132700.654528-1-jaszczyk@google.com>
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Grzegorz Jaszczyk <jaz@semihalf.com>

To allow pass-through devices receiving ACPI notifications, permit to
register ACPI notify handler (via introduced new ioctl) for a given
device. The handler role is to receive and propagate such ACPI
notifications to the user-space through the user provided eventfd. This
allows VMM to receive and propagate them further to the VM, where the
actual driver for pass-through device resides and can react to device
specific notifications accordingly.

The eventfd usage ensures VMM and device isolation: it allows to use a
dedicated channel associated with the device for such events, such that
the VMM has direct access.

Since the eventfd counter is used as ACPI notification value
placeholder, the eventfd signaling needs to be serialized in order to
not end up with notification values being coalesced. Therefore ACPI
notification values are buffered and signalized one by one, when the
previous notification value has been consumed.

Signed-off-by: Grzegorz Jaszczyk <jaz@semihalf.com>
---
Changelog v2..v3:
- Fix compilation warnings when building with "W=1"
Changelog v1..v2:
- The v2 implementation is actually completely different then v1:
  instead of using acpi netlink events for propagating ACPI
  notifications to the user space take advantage of eventfd, which can
  provide better VMM and device isolation: it allows to use a dedicated
  channel associated with the device for such events, such that the VMM
  has direct access.
- Using eventfd counter as notification value placeholder was suggested
  in v1 and requires additional serialization logic introduced in v2.
- Since the vfio-pci supports non-ACPI platforms address !CONFIG_ACPI
  case.
- v1 discussion: https://patchwork.kernel.org/project/kvm/patch/20230307220553.631069-1-jaz@semihalf.com/
---
 drivers/vfio/pci/vfio_pci_core.c | 214 +++++++++++++++++++++++++++++++
 include/linux/vfio_pci_core.h    |  11 ++
 include/uapi/linux/vfio.h        |  15 +++
 3 files changed, 240 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index a5ab416cf476..2d6101e89fde 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -10,6 +10,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/acpi.h>
 #include <linux/aperture.h>
 #include <linux/device.h>
 #include <linux/eventfd.h>
@@ -679,6 +680,70 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_disable);
 
+struct notification_queue {
+	int notification_val;
+	struct list_head notify_val_next;
+};
+
+#if IS_ENABLED(CONFIG_ACPI)
+static void vfio_pci_core_acpi_notify(acpi_handle handle, u32 event, void *data)
+{
+	struct vfio_pci_core_device *vdev = (struct vfio_pci_core_device *)data;
+	struct vfio_acpi_notification *acpi_notify = vdev->acpi_notification;
+	struct notification_queue *entry;
+
+	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return;
+
+	entry->notification_val = event;
+	INIT_LIST_HEAD(&entry->notify_val_next);
+
+	mutex_lock(&acpi_notify->notification_list_lock);
+	list_add_tail(&entry->notify_val_next, &acpi_notify->notification_list);
+	mutex_unlock(&acpi_notify->notification_list_lock);
+
+	schedule_work(&acpi_notify->acpi_notification_work);
+}
+
+static void vfio_pci_acpi_notify_close_device(struct vfio_pci_core_device *vdev)
+{
+	struct vfio_acpi_notification *acpi_notify = vdev->acpi_notification;
+	struct pci_dev *pdev = vdev->pdev;
+	struct acpi_device *adev = ACPI_COMPANION(&pdev->dev);
+	struct notification_queue *entry, *entry_tmp;
+	u64 cnt;
+
+	if (!acpi_notify || !acpi_notify->acpi_notify_trigger)
+		return;
+
+	acpi_remove_notify_handler(adev->handle, ACPI_DEVICE_NOTIFY,
+				   vfio_pci_core_acpi_notify);
+
+	eventfd_ctx_remove_wait_queue(acpi_notify->acpi_notify_trigger,
+				      &acpi_notify->wait, &cnt);
+
+	flush_work(&acpi_notify->acpi_notification_work);
+
+	mutex_lock(&acpi_notify->notification_list_lock);
+	list_for_each_entry_safe(entry, entry_tmp,
+				 &acpi_notify->notification_list,
+				 notify_val_next) {
+		list_del(&entry->notify_val_next);
+		kfree(entry);
+	}
+	mutex_unlock(&acpi_notify->notification_list_lock);
+
+	eventfd_ctx_put(acpi_notify->acpi_notify_trigger);
+
+	kfree(acpi_notify);
+
+	vdev->acpi_notification = NULL;
+}
+#else
+static void vfio_pci_acpi_notify_close_device(struct vfio_pci_core_device *vdev) {}
+#endif /* CONFIG_ACPI */
+
 void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 {
 	struct vfio_pci_core_device *vdev =
@@ -705,6 +770,8 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 		vdev->req_trigger = NULL;
 	}
 	mutex_unlock(&vdev->igate);
+
+	vfio_pci_acpi_notify_close_device(vdev);
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_close_device);
 
@@ -882,6 +949,151 @@ int vfio_pci_core_register_dev_region(struct vfio_pci_core_device *vdev,
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_register_dev_region);
 
+#if IS_ENABLED(CONFIG_ACPI)
+static int vfio_pci_eventfd_wakeup(wait_queue_entry_t *wait, unsigned int mode,
+				   int sync, void *key)
+{
+	struct vfio_acpi_notification *acpi_notify =
+		container_of(wait, struct vfio_acpi_notification, wait);
+	__poll_t flags = key_to_poll(key);
+
+	/*
+	 * eventfd_read signalize EPOLLOUT at the end of its function - this
+	 * means previous eventfd with its notification value was consumed so
+	 * the next notification can be signalized now if pending - schedule
+	 * proper work.
+	 */
+	if (flags & EPOLLOUT) {
+		mutex_unlock(&acpi_notify->notification_lock);
+		schedule_work(&acpi_notify->acpi_notification_work);
+	}
+
+	return 0;
+}
+
+static void vfio_pci_ptable_queue_proc(struct file *file,
+				       wait_queue_head_t *wqh, poll_table *pt)
+{
+	struct vfio_acpi_notification *acpi_notify =
+		container_of(pt, struct vfio_acpi_notification, pt);
+
+	add_wait_queue(wqh, &acpi_notify->wait);
+}
+
+static void acpi_notification_work_fn(struct work_struct *work)
+{
+	struct vfio_acpi_notification *acpi_notify;
+	struct notification_queue *entry;
+
+	acpi_notify = container_of(work, struct vfio_acpi_notification,
+				   acpi_notification_work);
+
+	mutex_lock(&acpi_notify->notification_list_lock);
+	if (list_empty(&acpi_notify->notification_list) || !acpi_notify->acpi_notify_trigger)
+		goto out;
+
+	/*
+	 * If the previous eventfd was not yet consumed by user-space lets hold
+	 * on and exit. The notification function will be rescheduled when
+	 * signaling eventfd will be possible (when the EPOLLOUT will be
+	 * signalized and unlocks notify_events).
+	 */
+	if (!mutex_trylock(&acpi_notify->notification_lock))
+		goto out;
+
+	entry = list_first_entry(&acpi_notify->notification_list,
+				 struct notification_queue, notify_val_next);
+
+	list_del(&entry->notify_val_next);
+	mutex_unlock(&acpi_notify->notification_list_lock);
+
+	eventfd_signal(acpi_notify->acpi_notify_trigger, entry->notification_val);
+
+	kfree(entry);
+
+	return;
+out:
+	mutex_unlock(&acpi_notify->notification_list_lock);
+}
+
+static int vfio_pci_ioctl_acpi_notify_eventfd(struct vfio_pci_core_device *vdev, struct
+				       vfio_irq_info __user *arg)
+{
+	struct file *acpi_notify_trigger_file;
+	struct vfio_acpi_notification *acpi_notify;
+	struct pci_dev *pdev = vdev->pdev;
+	struct acpi_device *adev = ACPI_COMPANION(&pdev->dev);
+	struct vfio_acpi_notify_eventfd entry;
+	struct eventfd_ctx *efdctx;
+	acpi_status status;
+
+	if (!adev)
+		return -ENODEV;
+
+	if (copy_from_user(&entry, arg, sizeof(entry)))
+		return -EFAULT;
+
+	if (entry.notify_eventfd < 0)
+		return -EINVAL;
+
+	efdctx = eventfd_ctx_fdget(entry.notify_eventfd);
+	if (IS_ERR(efdctx))
+		return PTR_ERR(efdctx);
+
+	vdev->acpi_notification = kzalloc(sizeof(*acpi_notify), GFP_KERNEL);
+	if (!vdev->acpi_notification)
+		return -ENOMEM;
+
+	acpi_notify = vdev->acpi_notification;
+
+	INIT_WORK(&acpi_notify->acpi_notification_work, acpi_notification_work_fn);
+	INIT_LIST_HEAD(&acpi_notify->notification_list);
+
+	acpi_notify->acpi_notify_trigger = efdctx;
+
+	mutex_init(&acpi_notify->notification_lock);
+
+	/*
+	 * Install custom wake-up handler to be notified whenever underlying
+	 * eventfd is consumed by the user-space.
+	 */
+	init_waitqueue_func_entry(&acpi_notify->wait, vfio_pci_eventfd_wakeup);
+	init_poll_funcptr(&acpi_notify->pt, vfio_pci_ptable_queue_proc);
+
+	acpi_notify_trigger_file = eventfd_fget(entry.notify_eventfd);
+	vfs_poll(acpi_notify_trigger_file, &acpi_notify->pt);
+
+	status = acpi_install_notify_handler(adev->handle, ACPI_DEVICE_NOTIFY,
+					vfio_pci_core_acpi_notify, (void *)vdev);
+
+	if (ACPI_FAILURE(status)) {
+		u64 cnt;
+
+		pci_err(pdev, "Failed to install notify handler: %s",
+			acpi_format_exception(status));
+
+		eventfd_ctx_remove_wait_queue(acpi_notify->acpi_notify_trigger,
+					      &acpi_notify->wait, &cnt);
+
+		flush_work(&acpi_notify->acpi_notification_work);
+
+		eventfd_ctx_put(acpi_notify->acpi_notify_trigger);
+
+		kfree(acpi_notify);
+
+		return -ENODEV;
+	}
+
+	return 0;
+}
+#else
+static int vfio_pci_ioctl_acpi_notify_eventfd(struct vfio_pci_core_device *vdev, struct
+				       vfio_irq_info __user *arg)
+{
+	return -ENODEV;
+}
+#endif /* CONFIG_ACPI */
+
 static int vfio_pci_ioctl_get_info(struct vfio_pci_core_device *vdev,
 				   struct vfio_device_info __user *arg)
 {
@@ -1398,6 +1610,8 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 		return vfio_pci_ioctl_reset(vdev, uarg);
 	case VFIO_DEVICE_SET_IRQS:
 		return vfio_pci_ioctl_set_irqs(vdev, uarg);
+	case VFIO_ACPI_NOTIFY_EVENTFD:
+		return vfio_pci_ioctl_acpi_notify_eventfd(vdev, uarg);
 	default:
 		return -ENOTTY;
 	}
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 367fd79226a3..3711e8a1c6f0 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -49,6 +49,16 @@ struct vfio_pci_region {
 	u32				flags;
 };
 
+struct vfio_acpi_notification {
+	struct eventfd_ctx	*acpi_notify_trigger;
+	struct work_struct	acpi_notification_work;
+	struct list_head	notification_list;
+	struct mutex		notification_list_lock;
+	struct mutex		notification_lock;
+	poll_table		pt;
+	wait_queue_entry_t	wait;
+};
+
 struct vfio_pci_core_device {
 	struct vfio_device	vdev;
 	struct pci_dev		*pdev;
@@ -96,6 +106,7 @@ struct vfio_pci_core_device {
 	struct mutex		vma_lock;
 	struct list_head	vma_list;
 	struct rw_semaphore	memory_lock;
+	struct vfio_acpi_notification	*acpi_notification;
 };
 
 /* Will be exported for vfio pci drivers usage */
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 0552e8dcf0cb..d4b602d8f4b2 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1622,6 +1622,21 @@ struct vfio_iommu_spapr_tce_remove {
 };
 #define VFIO_IOMMU_SPAPR_TCE_REMOVE	_IO(VFIO_TYPE, VFIO_BASE + 20)
 
+/**
+ * VFIO_ACPI_NOTIFY_EVENTFD - _IOW(VFIO_TYPE, VFIO_BASE + 21, struct vfio_acpi_notify_eventfd)
+ *
+ * Register ACPI notify handler for a given device which will allow to receive
+ * and propagate ACPI notifications to the user-space through the user provided
+ * eventfd.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+struct vfio_acpi_notify_eventfd {
+	__s32 notify_eventfd;
+	__u32 reserved;
+};
+#define VFIO_ACPI_NOTIFY_EVENTFD	_IO(VFIO_TYPE, VFIO_BASE + 21)
+
 /* ***************************************************************** */
 
 #endif /* _UAPIVFIO_H */
-- 
2.40.1.495.gc816e09b53d-goog

