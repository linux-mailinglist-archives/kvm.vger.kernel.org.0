Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E99C96ED271
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 18:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbjDXQ2K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 12:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbjDXQ2J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 12:28:09 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77570D8
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 09:28:03 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id 2adb3069b0e04-4eed6ddcae1so20110225e87.0
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 09:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google; t=1682353682; x=1684945682;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=49YU0UBzI3fzNDCk6NyV1dRCTEX7zuCbdpSF7dqpODM=;
        b=L6X61pl5WTAMYQPj6Ub9F2IQHylYEfCr5+2DPsYpdJw+DqGaSETMPpsyTZuR208MRs
         BSIPQRhLuPqwR5qwOs69ox7cTi4nMsMTY9OU7Yhjw7y/AZCDdmq1yzb7JbwSs/THOlDe
         S3cfhe2dgCF0uNAfuuXxM/z3vI6jrrMmfYKhgzd4St3/Zvcmekcy5SzlKNp7KifduEyA
         o4uQ1Gk024qOq5S2qfJNZSsRM6SRttjHq7aNKCLc3AaMkZmh6v5zP+6LmT+3kBFWCev6
         L+66VVqIMAPGzxxOwUFm/k1I50hjMf9gPHd/l4QwtfJBJ4aieVtQ5hNW8nF2F437/uw1
         D3pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682353682; x=1684945682;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=49YU0UBzI3fzNDCk6NyV1dRCTEX7zuCbdpSF7dqpODM=;
        b=XO4WnPoZtTpqC02A5qinRr+pcxtqfnH+eESFpYS+5IivoKnwWTfSQN5R5bDMbw8rwh
         PwdqfaLi0mEpv2Sf68V/ciVMxlY8+G5pjIkbg+4qLzVjyBOnUGIN6AcRDW/HWrzwlRc8
         ABH8QErG1AjLvl9gNb5/9WpxVZdnGEG7YnyKHqrwmtH57lbEIsSAao5w/IJ9W8Xanf2P
         x96AIIOkzeCpyc6EOHKskLmEe81Mkg0PqYpA8hm1rAYt/q1Mu+IpGgBMhNKMEEc3UXYf
         IR3LG+srOe0mUWvGiiNzjZM+x3u6XEWnPN3AQ6MBTWoczFJooe/AlVRf4yE37wtEUxy2
         5v/w==
X-Gm-Message-State: AAQBX9cD0zucH0VuykrcOLyIx2FqrDK+JRt2/Sn29gggSC+19x18rQlQ
        iHXMqBbugcVNbzGaYG5cUj750w==
X-Google-Smtp-Source: AKy350bcvjK/XnUrwqG7eEa5N8IHq7Q/4CTWvkmJyldWqxC9HHbdguEcSef41S8h8qCRli+FIB5vSA==
X-Received: by 2002:ac2:414e:0:b0:4ed:d7f8:bdc3 with SMTP id c14-20020ac2414e000000b004edd7f8bdc3mr3896576lfi.28.1682353681642;
        Mon, 24 Apr 2023 09:28:01 -0700 (PDT)
Received: from jazctssd.c.googlers.com.com (138.58.228.35.bc.googleusercontent.com. [35.228.58.138])
        by smtp.gmail.com with ESMTPSA id c15-20020a05651221af00b004edd2dc9a09sm1728048lft.258.2023.04.24.09.28.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 09:28:00 -0700 (PDT)
From:   Grzegorz Jaszczyk <jaz@semihalf.com>
To:     linux-kernel@vger.kernel.org, alex.williamson@redhat.com
Cc:     dmy@semihalf.com, tn@semihalf.com, dbehr@google.com,
        dbehr@chromium.org, upstream@semihalf.com, dtor@google.com,
        jgg@ziepe.ca, kevin.tian@intel.com, cohuck@redhat.com,
        abhsahu@nvidia.com, yishaih@nvidia.com, yi.l.liu@intel.com,
        kvm@vger.kernel.org, libvir-list@redhat.com,
        Grzegorz Jaszczyk <jaz@semihalf.com>
Subject: [PATCH v2] vfio/pci: Propagate ACPI notifications to user-space via eventfd
Date:   Mon, 24 Apr 2023 16:27:48 +0000
Message-ID: <20230424162748.2711945-1-jaz@semihalf.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
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
 drivers/vfio/pci/vfio_pci_core.c | 215 +++++++++++++++++++++++++++++++
 include/linux/vfio_pci_core.h    |  11 ++
 include/uapi/linux/vfio.h        |  15 +++
 3 files changed, 241 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index a5ab416cf476..ba8c49217875 100644
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
+void vfio_pci_acpi_notify_close_device(struct vfio_pci_core_device *vdev)
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
+void vfio_pci_acpi_notify_close_device(struct vfio_pci_core_device *vdev) {}
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
 
@@ -882,6 +949,152 @@ int vfio_pci_core_register_dev_region(struct vfio_pci_core_device *vdev,
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
+	__poll_t events;
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
+	events = vfs_poll(acpi_notify_trigger_file, &acpi_notify->pt);
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
@@ -1398,6 +1611,8 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
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
2.40.0.634.g4ca3ef3211-goog

