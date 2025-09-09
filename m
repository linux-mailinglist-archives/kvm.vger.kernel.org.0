Return-Path: <kvm+bounces-57156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 42CF7B508A8
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 00:02:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7AA825E7727
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 22:01:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C11A28369A;
	Tue,  9 Sep 2025 22:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NJbqlac2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5121626FD97;
	Tue,  9 Sep 2025 22:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757455217; cv=none; b=NZOy5cK75/cngFrVyeMCwnlK1xIorlRe2gfa9yvRNf6XJC8swZj5oYTvRpd3BHFI6WWPR8C2/2XuaDQ5wc8V1VTOmPDoEiLEfJ3loKm9+dsg6Hd2/V195TDDpyl7jCVR8B/lFPyelQode4ErjOdUGmgouuFTnq5URvWjl5WNvj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757455217; c=relaxed/simple;
	bh=IkacwfdlFmsVBWA5lp9RHRN9qNWyVF239IiYhl7cN/A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Xw9abhe882ZDG47tX+N0D/0waKzvI1nYPJygmUW9MKzgqf7X/ooRBin1T3klw2jy+K+k7AnX2XN8hofhhjpl8Gwr2hQcVaSaLgfXORVOgO0pFi5aYxbeS4J8DV5nWA74Dk96DgaQBSSc5qIT+KqX6Q9IJptQi9376YOtWSj6E2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NJbqlac2; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757455214; x=1788991214;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=IkacwfdlFmsVBWA5lp9RHRN9qNWyVF239IiYhl7cN/A=;
  b=NJbqlac2ijvaEKmWXHyv4XoUg/z45C2a+ypJ3MhQzyp5H4zvMf7JPiKU
   jw98n30+kuBszcgqo6WHKc50jPM6dNlGkO1E+qRJ/Uz1A9/GciJlKoNWi
   9yrqqWcfWiNM/AfTbOQ+Xh1hgSynKnzgGWwqc3dqPpalEsAPuaSCRlb1L
   Mrt1AqJItFGCxwFVm3/zNKYLo14OyyEYtLaAEYUH+6hkXMIrzeEQk0EKm
   QI5lTPMEqrs3H8EbgsC8xJ1AcoWoC8QXBGuRhjI+xfr11PF6I22NODvI5
   XYYz88pEaZ7vZ4K6aHHPJQIiK2PxYAp8MoOuGj9wItEu62U7qucSZH3Dd
   g==;
X-CSE-ConnectionGUID: qTz99/puTi2xdxYrabm/YQ==
X-CSE-MsgGUID: ekUZm7huTy+cfsnhsDI4gw==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="63584674"
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="63584674"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 15:00:09 -0700
X-CSE-ConnectionGUID: MSEoKOxQTeeZ4gO7PkzmHg==
X-CSE-MsgGUID: tFveJ0vuSka+U/FRA2sJMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="172780972"
Received: from orcnseosdtjek.jf.intel.com (HELO [10.166.28.70]) ([10.166.28.70])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 15:00:08 -0700
From: Jacob Keller <jacob.e.keller@intel.com>
Date: Tue, 09 Sep 2025 14:57:55 -0700
Subject: [PATCH RFC net-next 6/7] ice-vfio-pci: add ice VFIO PCI live
 migration driver
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250909-e810-live-migration-jk-migration-tlv-v1-6-4d1dc641e31f@intel.com>
References: <20250909-e810-live-migration-jk-migration-tlv-v1-0-4d1dc641e31f@intel.com>
In-Reply-To: <20250909-e810-live-migration-jk-migration-tlv-v1-0-4d1dc641e31f@intel.com>
To: Tony Nguyen <anthony.l.nguyen@intel.com>, 
 Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
 Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
 Alex Williamson <alex.williamson@redhat.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, 
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, 
 Kevin Tian <kevin.tian@intel.com>, Jakub Kicinski <kuba@kernel.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
 kvm@vger.kernel.org, linux-hardening@vger.kernel.org, 
 Jacob Keller <jacob.e.keller@intel.com>, 
 Aleksandr Loktionov <aleksandr.loktionov@intel.com>
X-Mailer: b4 0.15-dev-c61db
X-Developer-Signature: v=1; a=openpgp-sha256; l=25059;
 i=jacob.e.keller@intel.com; h=from:subject:message-id;
 bh=IkacwfdlFmsVBWA5lp9RHRN9qNWyVF239IiYhl7cN/A=;
 b=owGbwMvMwCWWNS3WLp9f4wXjabUkhowDi9MUJJ4qCGXdXvTpwKrC5ZueyMYf9NT5/kfYz2xH1
 ZNbSz41dpSyMIhxMciKKbIoOISsvG48IUzrjbMczBxWJpAhDFycAjARiQsM/0NKFohfOfxGdeH/
 zv1ZVrHxLv93ffsw/YilwYy3cbfOdt9gZDg40cTBL6bqz47zE5L/3BFS432pn560UebT/Uc7Wkr
 e3GUGAA==
X-Developer-Key: i=jacob.e.keller@intel.com; a=openpgp;
 fpr=204054A9D73390562AEC431E6A965D3E6F0F28E8

Add the ice-vfio-pci driver module which enables live migration support via
the vfio_migration_ops for the ice E800 series hardware.

To use this module, you can create VFs in the usual way and then unbind
them from iavf, and bind them to ice-vfio-pci:

  echo 2 >/sys/class/net/enp175s0f0np0/device/sriov_numvfs

  echo "0000:af:01.0" >/sys/bus/pci/drivers/iavf/unbind
  echo "0000:af:01.1" >/sys/bus/pci/drivers/iavf/unbind

  modprobe ice_vfio_pci

  echo "8086 1889" >/sys/bus/pci/drivers/ice-vfio-pci/new_id

I've tested with QEMU using the "enable-migration=on" and
"x-pre-copy-dirty-page-tracking=off" settings, as we do not currently
support dirty page tracking.

The initial host QEMU instance is launched as usual, while the target QEMU
instance is launched with the -incoming tcp:localhost:4444 option.

To initiate migration you can issue the migration command from the QEMU
console:

  migrate tcp:localhost:4444

The ice-vfio-pci driver connects to the ice driver using the interface
defined in <linux/net/intel/ice_migration.h>. The migration driver
initializes by calling ice_migration_init_dev(). To save device state, the
VF is paused using ice_migration_suspend_dev(), and then state is captured
by ice_migration_save_devstate().

Some information about the VF must be saved during device suspend, as
otherwise the data could be lost when stopping the device.

For this reason, the ice_migration_suspend_dev() function takes a boolean
indicating whether state should be saved. The VFIO migration state machine
must suspend the initial device when stopping, but also suspends the target
device when resuming. In the resume case, we do not need to save the state,
so this can be elided when the VFIO state machine is transitioning to the
resuming state.

Note that full support is not functional until the PCI .reset_done handler
is implemented in a following change. This was split out in order to better
callout and explain the locking mechanism due to the complexity required to
avoid ABBA locking violations.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
---
 drivers/vfio/pci/ice/main.c   | 699 ++++++++++++++++++++++++++++++++++++++++++
 MAINTAINERS                   |   7 +
 drivers/vfio/pci/Kconfig      |   2 +
 drivers/vfio/pci/Makefile     |   2 +
 drivers/vfio/pci/ice/Kconfig  |   8 +
 drivers/vfio/pci/ice/Makefile |   4 +
 6 files changed, 722 insertions(+)

diff --git a/drivers/vfio/pci/ice/main.c b/drivers/vfio/pci/ice/main.c
new file mode 100644
index 000000000000..161053ba383c
--- /dev/null
+++ b/drivers/vfio/pci/ice/main.c
@@ -0,0 +1,699 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2018-2025 Intel Corporation */
+
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/file.h>
+#include <linux/pci.h>
+#include <linux/vmalloc.h>
+#include <linux/vfio_pci_core.h>
+#include <linux/net/intel/ice_migration.h>
+#include <linux/anon_inodes.h>
+
+/**
+ * struct ice_vfio_pci_migration_file - Migration payload file contents
+ * @filp: the file pointer for communicating with user space
+ * @lock: mutex protecting the migration file access
+ * @payload_length: length of the migration payload
+ * @disabled: if true, the migration file descriptor has been disabled
+ * @mig_data: buffer holding migration payload
+ *
+ * When saving device state, the payload length is calculated ahead of time
+ * and the buffer is sized appropriately. The receiver sets payload_length to
+ * SZ_128K which should be sufficient space for any migration.
+ */
+struct ice_vfio_pci_migration_file {
+	struct file *filp;
+	struct mutex lock;
+	size_t payload_length;
+	bool disabled:1;
+	u8 mig_data[] __counted_by(payload_length);
+};
+
+/**
+ * struct ice_vfio_pci_device - Migration driver structure
+ * @core_device: The core device being operated on
+ * @mig_info: Migration information
+ * @state_mutex: mutex protecting the migration state
+ * @resuming_migf: Migration file containing data for the resuming VF
+ * @saving_migf: Migration file used to store data from saving VF
+ * @mig_state: the current migration state of the device
+ */
+struct ice_vfio_pci_device {
+	struct vfio_pci_core_device core_device;
+	struct vfio_device_migration_info mig_info;
+	struct mutex state_mutex;
+	struct ice_vfio_pci_migration_file *resuming_migf;
+	struct ice_vfio_pci_migration_file *saving_migf;
+	enum vfio_device_mig_state mig_state;
+};
+
+#define to_ice_vdev(dev) \
+	container_of((dev), struct ice_vfio_pci_device, core_device.vdev)
+
+/**
+ * ice_vfio_pci_load_state - VFIO device state reloading
+ * @ice_vdev: pointer to ice-vfio-pci core device structure
+ *
+ * Load device state. This function is called when the userspace VFIO uAPI
+ * consumer wants to load the device state info from VFIO migration region and
+ * load them into the device. This function should make sure all the device
+ * state info is loaded successfully. As a result, return value is mandatory
+ * to be checked.
+ *
+ * Return: 0 on success, or a negative error code on failure.
+ */
+static int __must_check
+ice_vfio_pci_load_state(struct ice_vfio_pci_device *ice_vdev)
+{
+	struct ice_vfio_pci_migration_file *migf = ice_vdev->resuming_migf;
+	struct pci_dev *pdev = ice_vdev->core_device.pdev;
+
+	return ice_migration_load_devstate(pdev,
+					   migf->mig_data,
+					   migf->payload_length);
+}
+
+/**
+ * ice_vfio_pci_save_state - VFIO device state saving
+ * @ice_vdev: pointer to ice-vfio-pci core device structure
+ * @migf: pointer to migration file
+ *
+ * Snapshot the device state and save it. This function is called when the
+ * VFIO uAPI consumer wants to snapshot the current device state and saves
+ * it into the VFIO migration region. This function should make sure all
+ * of the device state info is collected and saved successfully. As a
+ * result, return value is mandatory to be checked.
+ *
+ * Return: 0 on success, or a negative error code on failure.
+ */
+static int __must_check
+ice_vfio_pci_save_state(struct ice_vfio_pci_device *ice_vdev,
+			struct ice_vfio_pci_migration_file *migf)
+{
+	struct pci_dev *pdev = ice_vdev->core_device.pdev;
+
+	return ice_migration_save_devstate(pdev,
+					   migf->mig_data,
+					   migf->payload_length);
+}
+
+/**
+ * ice_vfio_migration_init - Initialization for live migration function
+ * @ice_vdev: pointer to ice-vfio-pci core device structure
+ *
+ * Return: 0 on success, or a negative error code on failure.
+ */
+static int ice_vfio_migration_init(struct ice_vfio_pci_device *ice_vdev)
+{
+	struct pci_dev *pdev = ice_vdev->core_device.pdev;
+
+	return ice_migration_init_dev(pdev);
+}
+
+/**
+ * ice_vfio_migration_uninit - Cleanup for live migration function
+ * @ice_vdev: pointer to ice-vfio-pci core device structure
+ */
+static void ice_vfio_migration_uninit(struct ice_vfio_pci_device *ice_vdev)
+{
+	struct pci_dev *pdev = ice_vdev->core_device.pdev;
+
+	ice_migration_uninit_dev(pdev);
+}
+
+/**
+ * ice_vfio_pci_disable_fd - Close migration file
+ * @migf: pointer to ice-vfio-pci migration file
+ */
+static void ice_vfio_pci_disable_fd(struct ice_vfio_pci_migration_file *migf)
+{
+	guard(mutex)(&migf->lock);
+
+	migf->disabled = true;
+	migf->payload_length = 0;
+	migf->filp->f_pos = 0;
+}
+
+/**
+ * ice_vfio_pci_disable_fds - Close migration files of ice-vfio-pci device
+ * @ice_vdev: pointer to ice-vfio-pci core device structure
+ */
+static void ice_vfio_pci_disable_fds(struct ice_vfio_pci_device *ice_vdev)
+{
+	if (ice_vdev->resuming_migf) {
+		ice_vfio_pci_disable_fd(ice_vdev->resuming_migf);
+		fput(ice_vdev->resuming_migf->filp);
+		ice_vdev->resuming_migf = NULL;
+	}
+	if (ice_vdev->saving_migf) {
+		ice_vfio_pci_disable_fd(ice_vdev->saving_migf);
+		fput(ice_vdev->saving_migf->filp);
+		ice_vdev->saving_migf = NULL;
+	}
+}
+
+/**
+ * ice_vfio_pci_open_device - VFIO .open_device callback
+ * @vdev: the VFIO device to open
+ *
+ * Called when a VFIO device is probed by VFIO uAPI. Initializes the VFIO
+ * device and sets up the migration state.
+ *
+ * Return: 0 on success, or a negative error code on failure.
+ */
+static int ice_vfio_pci_open_device(struct vfio_device *vdev)
+{
+	struct vfio_pci_core_device *core_vdev;
+	struct ice_vfio_pci_device *ice_vdev;
+	int ret;
+
+	ice_vdev = to_ice_vdev(vdev);
+	core_vdev = &ice_vdev->core_device;
+
+	ret = vfio_pci_core_enable(core_vdev);
+	if (ret)
+		return ret;
+
+	ret = ice_vfio_migration_init(ice_vdev);
+	if (ret) {
+		vfio_pci_core_disable(core_vdev);
+		return ret;
+	}
+	ice_vdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
+	vfio_pci_core_finish_enable(core_vdev);
+
+	return 0;
+}
+
+/**
+ * ice_vfio_pci_close_device - VFIO .close_device callback
+ * @vdev: the VFIO device to close
+ *
+ * Called when a VFIO device fd is closed. Destroys migration state.
+ */
+static void ice_vfio_pci_close_device(struct vfio_device *vdev)
+{
+	struct ice_vfio_pci_device *ice_vdev = to_ice_vdev(vdev);
+
+	ice_vfio_pci_disable_fds(ice_vdev);
+	vfio_pci_core_close_device(vdev);
+	ice_vfio_migration_uninit(ice_vdev);
+}
+
+/**
+ * ice_vfio_pci_release_file - Release ice-vfio-pci migration file
+ * @inode: pointer to inode
+ * @filp: pointer to the file to release
+ *
+ * Return: 0.
+ */
+static int ice_vfio_pci_release_file(struct inode *inode, struct file *filp)
+{
+	struct ice_vfio_pci_migration_file *migf = filp->private_data;
+
+	ice_vfio_pci_disable_fd(migf);
+	mutex_destroy(&migf->lock);
+	vfree(migf);
+	return 0;
+}
+
+/**
+ * ice_vfio_pci_save_read - Save migration file data to user space
+ * @filp: pointer to migration file
+ * @buf: pointer to user space buffer
+ * @len: data length to be saved
+ * @pos: must be 0
+ *
+ * Return: length of the saved data, or a negative error code on failure.
+ */
+static ssize_t ice_vfio_pci_save_read(struct file *filp, char __user *buf,
+				      size_t len, loff_t *pos)
+{
+	struct ice_vfio_pci_migration_file *migf = filp->private_data;
+	loff_t *off = &filp->f_pos;
+	ssize_t done = 0;
+	int ret;
+
+	if (pos)
+		return -ESPIPE;
+
+	guard(mutex)(&migf->lock);
+
+	if (*off > migf->payload_length)
+		return -EINVAL;
+
+	if (migf->disabled)
+		return -ENODEV;
+
+	len = min_t(size_t, migf->payload_length - *off, len);
+	if (len) {
+		ret = copy_to_user(buf, migf->mig_data + *off, len);
+		if (ret)
+			return -EFAULT;
+
+		*off += len;
+		done = len;
+	}
+
+	return done;
+}
+
+static const struct file_operations ice_vfio_pci_save_fops = {
+	.owner = THIS_MODULE,
+	.read = ice_vfio_pci_save_read,
+	.release = ice_vfio_pci_release_file,
+};
+
+/**
+ * ice_vfio_pci_stop_copy - Create migration file and save migration state
+ * @ice_vdev: pointer to ice-vfio-pci core device structure
+ *
+ * Return: pointer to the migration file structure, or an error pointer on
+ *         failure.
+ */
+static struct ice_vfio_pci_migration_file *
+ice_vfio_pci_stop_copy(struct ice_vfio_pci_device *ice_vdev)
+{
+	struct pci_dev *pdev = ice_vdev->core_device.pdev;
+	struct ice_vfio_pci_migration_file *migf;
+	size_t payload_length;
+	int ret;
+
+	payload_length = ice_migration_get_required_size(pdev);
+	if (!payload_length)
+		return ERR_PTR(-EIO);
+
+	migf = vzalloc(struct_size(migf, mig_data, payload_length));
+	if (!migf)
+		return ERR_PTR(-ENOMEM);
+
+	migf->payload_length = payload_length;
+	migf->filp = anon_inode_getfile("ice_vfio_pci_mig",
+					&ice_vfio_pci_save_fops, migf,
+					O_RDONLY);
+	if (IS_ERR(migf->filp)) {
+		ret = PTR_ERR(migf->filp);
+		goto err_free_migf;
+	}
+
+	stream_open(migf->filp->f_inode, migf->filp);
+	mutex_init(&migf->lock);
+
+	ret = ice_vfio_pci_save_state(ice_vdev, migf);
+	if (ret)
+		goto err_put_migf_filp;
+
+	return migf;
+
+err_put_migf_filp:
+	fput(migf->filp);
+err_free_migf:
+	vfree(migf);
+
+	return ERR_PTR(ret);
+}
+
+/**
+ * ice_vfio_pci_resume_write - Copy migration file data from user space
+ * @filp: pointer to migration file
+ * @buf: pointer to user space buffer
+ * @len: data length to be copied
+ * @pos: must be 0
+ *
+ * Return: length of the data copied, or a negative error code on failure.
+ */
+static ssize_t ice_vfio_pci_resume_write(struct file *filp,
+					 const char __user *buf,
+					 size_t len, loff_t *pos)
+{
+	struct ice_vfio_pci_migration_file *migf = filp->private_data;
+	loff_t *off = &filp->f_pos;
+	loff_t requested_length;
+	ssize_t done = 0;
+	int ret;
+
+	if (pos)
+		return -ESPIPE;
+
+	if (*off < 0 ||
+	    check_add_overflow((loff_t)len, *off, &requested_length))
+		return -EINVAL;
+
+	if (requested_length > migf->payload_length)
+		return -ENOMEM;
+
+	guard(mutex)(&migf->lock);
+
+	if (migf->disabled)
+		return -ENODEV;
+
+	ret = copy_from_user(migf->mig_data + *off, buf, len);
+	if (ret)
+		return -EFAULT;
+
+	*off += len;
+	done = len;
+	migf->payload_length += len;
+
+	return done;
+}
+
+static const struct file_operations ice_vfio_pci_resume_fops = {
+	.owner = THIS_MODULE,
+	.write = ice_vfio_pci_resume_write,
+	.release = ice_vfio_pci_release_file,
+};
+
+/**
+ * ice_vfio_pci_resume - Create resuming migration file
+ * @ice_vdev: pointer to ice-vfio-pci core device structure
+ *
+ * Return: pointer to the migration file handler, or an error pointer on
+ *         failure.
+ */
+static struct ice_vfio_pci_migration_file *
+ice_vfio_pci_resume(struct ice_vfio_pci_device *ice_vdev)
+{
+	struct ice_vfio_pci_migration_file *migf;
+
+	migf = vzalloc(struct_size(migf, mig_data, SZ_128K));
+	if (!migf)
+		return ERR_PTR(-ENOMEM);
+
+	migf->payload_length = SZ_128K;
+	migf->filp = anon_inode_getfile("ice_vfio_pci_mig",
+					&ice_vfio_pci_resume_fops, migf,
+					O_WRONLY);
+	if (IS_ERR(migf->filp)) {
+		int ret = PTR_ERR(migf->filp);
+
+		vfree(migf);
+
+		return ERR_PTR(ret);
+	}
+
+	stream_open(migf->filp->f_inode, migf->filp);
+	mutex_init(&migf->lock);
+
+	return migf;
+}
+
+/**
+ * ice_vfio_pci_step_device_state_locked - Process device state change
+ * @ice_vdev: pointer to ice-vfio-pci core device structure
+ * @new: new device state
+ * @final: final device state
+ *
+ * Return: pointer to the migration file handler or NULL on success, or an
+ *         error pointer on failure.
+ */
+static struct file *
+ice_vfio_pci_step_device_state_locked(struct ice_vfio_pci_device *ice_vdev,
+				      enum vfio_device_mig_state new,
+				      enum vfio_device_mig_state final)
+{
+	enum vfio_device_mig_state cur = ice_vdev->mig_state;
+	struct pci_dev *pdev = ice_vdev->core_device.pdev;
+	int ret;
+
+	if (cur == VFIO_DEVICE_STATE_RUNNING && new == VFIO_DEVICE_STATE_RUNNING_P2P) {
+		bool save_state = final != VFIO_DEVICE_STATE_RESUMING;
+
+		/* The ice driver needs to keep track of some state which
+		 * would otherwise be lost when suspending the device. It only
+		 * needs this state if the device later transitions into
+		 * STOP_COPY, which copies the device state for migration.
+		 * The transition from RUNNING to RUNNING_P2P also occurs as
+		 * part of transitioning into the RESUME state.
+		 *
+		 * Avoid saving the device state if its known to be
+		 * unnecessary.
+		 */
+		ice_migration_suspend_dev(pdev, save_state);
+		return NULL;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_RUNNING_P2P && new == VFIO_DEVICE_STATE_STOP)
+		return NULL;
+
+	if (cur == VFIO_DEVICE_STATE_STOP && new == VFIO_DEVICE_STATE_STOP_COPY) {
+		struct ice_vfio_pci_migration_file *migf;
+
+		migf = ice_vfio_pci_stop_copy(ice_vdev);
+		if (IS_ERR(migf))
+			return ERR_CAST(migf);
+		get_file(migf->filp);
+		ice_vdev->saving_migf = migf;
+		return migf->filp;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_STOP_COPY && new == VFIO_DEVICE_STATE_STOP) {
+		ice_vfio_pci_disable_fds(ice_vdev);
+		return NULL;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_STOP && new == VFIO_DEVICE_STATE_RESUMING) {
+		struct ice_vfio_pci_migration_file *migf;
+
+		migf = ice_vfio_pci_resume(ice_vdev);
+		if (IS_ERR(migf))
+			return ERR_CAST(migf);
+		get_file(migf->filp);
+		ice_vdev->resuming_migf = migf;
+		return migf->filp;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_RESUMING && new == VFIO_DEVICE_STATE_STOP)
+		return NULL;
+
+	if (cur == VFIO_DEVICE_STATE_STOP && new == VFIO_DEVICE_STATE_RUNNING_P2P) {
+		ret = ice_vfio_pci_load_state(ice_vdev);
+		if (ret)
+			return ERR_PTR(ret);
+		ice_vfio_pci_disable_fds(ice_vdev);
+		return NULL;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_RUNNING_P2P && new == VFIO_DEVICE_STATE_RUNNING)
+		return NULL;
+
+	/*
+	 * vfio_mig_get_next_state() does not use arcs other than the above
+	 */
+	WARN_ON(true);
+	return ERR_PTR(-EINVAL);
+}
+
+/**
+ * ice_vfio_pci_set_device_state - Configure the device state
+ * @vdev: pointer to VFIO device
+ * @new_state: device state
+ *
+ * Return: 0 on success, or a negative error code on failure.
+ */
+static struct file *
+ice_vfio_pci_set_device_state(struct vfio_device *vdev,
+			      enum vfio_device_mig_state new_state)
+{
+	struct ice_vfio_pci_device *ice_vdev = to_ice_vdev(vdev);
+	enum vfio_device_mig_state next_state;
+	struct file *res = NULL;
+	int ret;
+
+	mutex_lock(&ice_vdev->state_mutex);
+
+	while (new_state != ice_vdev->mig_state) {
+		ret = vfio_mig_get_next_state(vdev, ice_vdev->mig_state,
+					      new_state, &next_state);
+		if (ret) {
+			res = ERR_PTR(ret);
+			break;
+		}
+
+		res = ice_vfio_pci_step_device_state_locked(ice_vdev,
+							    next_state,
+							    new_state);
+		if (IS_ERR(res))
+			break;
+
+		ice_vdev->mig_state = next_state;
+		if (WARN_ON(res && new_state != ice_vdev->mig_state)) {
+			fput(res);
+			res = ERR_PTR(-EINVAL);
+			break;
+		}
+	}
+
+	mutex_unlock(&ice_vdev->state_mutex);
+
+	return res;
+}
+
+/**
+ * ice_vfio_pci_get_device_state - Get device state
+ * @vdev: pointer to VFIO device
+ * @curr_state: device state
+ *
+ * Return: 0.
+ */
+static int ice_vfio_pci_get_device_state(struct vfio_device *vdev,
+					 enum vfio_device_mig_state *curr_state)
+{
+	struct ice_vfio_pci_device *ice_vdev = to_ice_vdev(vdev);
+
+	mutex_lock(&ice_vdev->state_mutex);
+
+	*curr_state = ice_vdev->mig_state;
+
+	mutex_unlock(&ice_vdev->state_mutex);
+
+	return 0;
+}
+
+/**
+ * ice_vfio_pci_get_data_size - Get estimated migration data size
+ * @vdev: pointer to VFIO device
+ * @stop_copy_length: migration data size
+ *
+ * Return: 0.
+ */
+static int ice_vfio_pci_get_data_size(struct vfio_device *vdev,
+				      unsigned long *stop_copy_length)
+{
+	*stop_copy_length = SZ_128K;
+	return 0;
+}
+
+static const struct vfio_migration_ops ice_vfio_pci_migrn_state_ops = {
+	.migration_set_state = ice_vfio_pci_set_device_state,
+	.migration_get_state = ice_vfio_pci_get_device_state,
+	.migration_get_data_size = ice_vfio_pci_get_data_size,
+};
+
+/**
+ * ice_vfio_pci_core_init_dev - initialize VFIO device
+ * @vdev: pointer to VFIO device
+ *
+ * Return: 0.
+ */
+static int ice_vfio_pci_core_init_dev(struct vfio_device *vdev)
+{
+	struct ice_vfio_pci_device *ice_vdev = to_ice_vdev(vdev);
+
+	mutex_init(&ice_vdev->state_mutex);
+
+	vdev->migration_flags =
+		VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_P2P;
+	vdev->mig_ops = &ice_vfio_pci_migrn_state_ops;
+
+	return vfio_pci_core_init_dev(vdev);
+}
+
+/**
+ * ice_vfio_pci_core_release_dev - Release VFIO device
+ * @vdev: pointer to VFIO device
+ */
+static void ice_vfio_pci_core_release_dev(struct vfio_device *vdev)
+{
+	struct ice_vfio_pci_device *ice_vdev = to_ice_vdev(vdev);
+
+	mutex_destroy(&ice_vdev->state_mutex);
+
+	vfio_pci_core_release_dev(vdev);
+}
+
+static const struct vfio_device_ops ice_vfio_pci_ops = {
+	.name		= "ice-vfio-pci",
+	.init		= ice_vfio_pci_core_init_dev,
+	.release	= ice_vfio_pci_core_release_dev,
+	.open_device	= ice_vfio_pci_open_device,
+	.close_device	= ice_vfio_pci_close_device,
+	.device_feature = vfio_pci_core_ioctl_feature,
+	.read		= vfio_pci_core_read,
+	.write		= vfio_pci_core_write,
+	.ioctl		= vfio_pci_core_ioctl,
+	.mmap		= vfio_pci_core_mmap,
+	.request	= vfio_pci_core_request,
+	.match		= vfio_pci_core_match,
+	.bind_iommufd	= vfio_iommufd_physical_bind,
+	.unbind_iommufd	= vfio_iommufd_physical_unbind,
+	.attach_ioas	= vfio_iommufd_physical_attach_ioas,
+	.detach_ioas	= vfio_iommufd_physical_detach_ioas,
+};
+
+/**
+ * ice_vfio_pci_probe - Device initialization routine
+ * @pdev: PCI device information struct
+ * @id: entry in ice_vfio_pci_table
+ *
+ * Return: 0 on success, or a negative error code on failure.
+ */
+static int
+ice_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct ice_vfio_pci_device *ice_vdev;
+	int ret;
+
+	ice_vdev = vfio_alloc_device(ice_vfio_pci_device, core_device.vdev,
+				     &pdev->dev, &ice_vfio_pci_ops);
+	if (!ice_vdev)
+		return -ENOMEM;
+
+	dev_set_drvdata(&pdev->dev, &ice_vdev->core_device);
+
+	ret = vfio_pci_core_register_device(&ice_vdev->core_device);
+	if (ret)
+		goto out_free;
+
+	return 0;
+
+out_free:
+	vfio_put_device(&ice_vdev->core_device.vdev);
+	return ret;
+}
+
+/**
+ * ice_vfio_pci_remove - Device removal routine
+ * @pdev: PCI device information struct
+ */
+static void ice_vfio_pci_remove(struct pci_dev *pdev)
+{
+	struct ice_vfio_pci_device *ice_vdev = dev_get_drvdata(&pdev->dev);
+
+	vfio_pci_core_unregister_device(&ice_vdev->core_device);
+	vfio_put_device(&ice_vdev->core_device.vdev);
+}
+
+/* ice_pci_tbl - PCI Device ID Table
+ *
+ * Wildcard entries (PCI_ANY_ID) should come last
+ * Last entry must be all 0s
+ *
+ * { Vendor ID, Device ID, SubVendor ID, SubDevice ID,
+ *   Class, Class Mask, private data (not used) }
+ */
+static const struct pci_device_id ice_vfio_pci_table[] = {
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_INTEL, 0x1889) },
+	{}
+};
+MODULE_DEVICE_TABLE(pci, ice_vfio_pci_table);
+
+static const struct pci_error_handlers ice_vfio_pci_core_err_handlers = {
+	.error_detected = vfio_pci_core_aer_err_detected,
+};
+
+static struct pci_driver ice_vfio_pci_driver = {
+	.name			= "ice-vfio-pci",
+	.id_table		= ice_vfio_pci_table,
+	.probe			= ice_vfio_pci_probe,
+	.remove			= ice_vfio_pci_remove,
+	.err_handler            = &ice_vfio_pci_core_err_handlers,
+	.driver_managed_dma	= true,
+};
+
+module_pci_driver(ice_vfio_pci_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("ICE VFIO PCI - User Level meta-driver for Intel E800 device family");
diff --git a/MAINTAINERS b/MAINTAINERS
index b81595e9ea95..512808140ebe 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -26477,6 +26477,13 @@ L:	kvm@vger.kernel.org
 S:	Maintained
 F:	drivers/vfio/pci/hisilicon/
 
+VFIO ICE PCI DRIVER
+M:	Jacob Keller <jacob.e.keller@intel.com>
+L:	kvm@vger.kernel.org
+S:	Supported
+F:	drivers/vfio/pci/ice/
+F:	include/linux/net/intel/ice_migration.h
+
 VFIO MEDIATED DEVICE DRIVERS
 M:	Kirti Wankhede <kwankhede@nvidia.com>
 L:	kvm@vger.kernel.org
diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 2b0172f54665..74e0fb571936 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -67,4 +67,6 @@ source "drivers/vfio/pci/nvgrace-gpu/Kconfig"
 
 source "drivers/vfio/pci/qat/Kconfig"
 
+source "drivers/vfio/pci/ice/Kconfig"
+
 endmenu
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index cf00c0a7e55c..721b01ad3a2e 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -19,3 +19,5 @@ obj-$(CONFIG_VIRTIO_VFIO_PCI) += virtio/
 obj-$(CONFIG_NVGRACE_GPU_VFIO_PCI) += nvgrace-gpu/
 
 obj-$(CONFIG_QAT_VFIO_PCI) += qat/
+
+obj-$(CONFIG_ICE_VFIO_PCI) += ice/
diff --git a/drivers/vfio/pci/ice/Kconfig b/drivers/vfio/pci/ice/Kconfig
new file mode 100644
index 000000000000..3e8f5d6e60dc
--- /dev/null
+++ b/drivers/vfio/pci/ice/Kconfig
@@ -0,0 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config ICE_VFIO_PCI
+	tristate "VFIO support for Intel(R) Ethernet Connection E800 Series"
+	depends on ICE
+	select VFIO_PCI_CORE
+	help
+	  This provides migration support for Intel(R) Ethernet connection E800
+	  series devices using the VFIO framework.
diff --git a/drivers/vfio/pci/ice/Makefile b/drivers/vfio/pci/ice/Makefile
new file mode 100644
index 000000000000..5b8df8234b31
--- /dev/null
+++ b/drivers/vfio/pci/ice/Makefile
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_ICE_VFIO_PCI) += ice-vfio-pci.o
+ice-vfio-pci-y := main.o
+

-- 
2.51.0.rc1.197.g6d975e95c9d7


