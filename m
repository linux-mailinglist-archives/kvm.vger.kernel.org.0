Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4821F6BCFC2
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 13:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbjCPMm3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 08:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbjCPMm1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 08:42:27 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47BCCB0B99;
        Thu, 16 Mar 2023 05:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678970544; x=1710506544;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5VOwMbZ7NFEp3Vz3lWCBa2rwgc7032UbcA9JSi84oFw=;
  b=PKPVLC3qtPzSd9lh+0OEdioQxPJRET9bELqHs0zmVgnQErJp/BQmZA8X
   BOhF7J0Rp+1+qjxZQ3HGBfxjsA/CC4FpQMjGvVUsdWJroTrsKE0VUEhuj
   g4S789RnC77YKnJSqk6PVNZoq4kOFL6H68bUfe8QxLjy/pyORLvJkzV6N
   elAp+9QkLQ+IwQeGh0WCpeybDSx1rAEz5XbflGRcSSD2swfPy+yUn6ej5
   T2eYL9EpsJqWCWY5agMx7YEr2d08FfYmkbVhN+zxnwKKTlRSyOwIy9Xw4
   ChNpnjdhz2hjbOSfCroJ2hqVFgMbDznz+xaOZ9J9orw9gfD3rr7wVq8rh
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="321812081"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="321812081"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 05:42:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="1009207959"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="1009207959"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga005.fm.intel.com with ESMTP; 16 Mar 2023 05:42:11 -0700
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com, kevin.tian@intel.com
Cc:     joro@8bytes.org, robin.murphy@arm.com, cohuck@redhat.com,
        eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
        mjrosato@linux.ibm.com, chao.p.peng@linux.intel.com,
        yi.l.liu@intel.com, yi.y.sun@linux.intel.com, peterx@redhat.com,
        jasowang@redhat.com, shameerali.kolothum.thodi@huawei.com,
        lulu@redhat.com, suravee.suthikulpanit@amd.com,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com
Subject: [PATCH 4/7] vfio/pci: Renaming for accepting device fd in hot reset path
Date:   Thu, 16 Mar 2023 05:41:53 -0700
Message-Id: <20230316124156.12064-5-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230316124156.12064-1-yi.l.liu@intel.com>
References: <20230316124156.12064-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No functional change is intended.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 55 ++++++++++++++++----------------
 1 file changed, 28 insertions(+), 27 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index b68fcba67a4b..b6b5624c8b15 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -177,10 +177,10 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
 	}
 }
 
-struct vfio_pci_group_info;
+struct vfio_pci_file_info;
 static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set);
 static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
-				      struct vfio_pci_group_info *groups,
+				      struct vfio_pci_file_info *info,
 				      struct iommufd_ctx *iommufd_ctx);
 
 /*
@@ -800,7 +800,7 @@ static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
 	return 0;
 }
 
-struct vfio_pci_group_info {
+struct vfio_pci_file_info {
 	int count;
 	struct file **files;
 };
@@ -1257,14 +1257,14 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
 }
 
 static int
-vfio_pci_ioctl_pci_hot_reset_groups(struct vfio_pci_core_device *vdev,
-				    struct vfio_pci_hot_reset *hdr,
-				    bool slot,
-				    struct vfio_pci_hot_reset __user *arg)
+vfio_pci_ioctl_pci_hot_reset_files(struct vfio_pci_core_device *vdev,
+				   struct vfio_pci_hot_reset *hdr,
+				   bool slot,
+				   struct vfio_pci_hot_reset __user *arg)
 {
-	int32_t *group_fds;
+	int32_t *fds;
 	struct file **files;
-	struct vfio_pci_group_info info;
+	struct vfio_pci_file_info info;
 	int file_idx, count = 0, ret = 0;
 
 	/*
@@ -1281,17 +1281,17 @@ vfio_pci_ioctl_pci_hot_reset_groups(struct vfio_pci_core_device *vdev,
 	if (hdr->count > count)
 		return -EINVAL;
 
-	group_fds = kcalloc(hdr->count, sizeof(*group_fds), GFP_KERNEL);
+	fds = kcalloc(hdr->count, sizeof(*fds), GFP_KERNEL);
 	files = kcalloc(hdr->count, sizeof(*files), GFP_KERNEL);
-	if (!group_fds || !files) {
-		kfree(group_fds);
+	if (!fds || !files) {
+		kfree(fds);
 		kfree(files);
 		return -ENOMEM;
 	}
 
-	if (copy_from_user(group_fds, arg->group_fds,
-			   hdr->count * sizeof(*group_fds))) {
-		kfree(group_fds);
+	if (copy_from_user(fds, arg->group_fds,
+			   hdr->count * sizeof(*fds))) {
+		kfree(fds);
 		kfree(files);
 		return -EFAULT;
 	}
@@ -1301,7 +1301,7 @@ vfio_pci_ioctl_pci_hot_reset_groups(struct vfio_pci_core_device *vdev,
 	 * the reset
 	 */
 	for (file_idx = 0; file_idx < hdr->count; file_idx++) {
-		struct file *file = fget(group_fds[file_idx]);
+		struct file *file = fget(fds[file_idx]);
 
 		if (!file) {
 			ret = -EBADF;
@@ -1318,9 +1318,9 @@ vfio_pci_ioctl_pci_hot_reset_groups(struct vfio_pci_core_device *vdev,
 		files[file_idx] = file;
 	}
 
-	kfree(group_fds);
+	kfree(fds);
 
-	/* release reference to groups on error */
+	/* release reference to fds on error */
 	if (ret)
 		goto hot_reset_release;
 
@@ -1358,7 +1358,7 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 		return -ENODEV;
 
 	if (hdr.count)
-		return vfio_pci_ioctl_pci_hot_reset_groups(vdev, &hdr, slot, arg);
+		return vfio_pci_ioctl_pci_hot_reset_files(vdev, &hdr, slot, arg);
 
 	iommufd = vfio_iommufd_physical_ictx(&vdev->vdev);
 
@@ -2329,16 +2329,16 @@ const struct pci_error_handlers vfio_pci_core_err_handlers = {
 };
 EXPORT_SYMBOL_GPL(vfio_pci_core_err_handlers);
 
-static bool vfio_dev_in_groups(struct vfio_pci_core_device *vdev,
-			       struct vfio_pci_group_info *groups)
+static bool vfio_dev_in_files(struct vfio_pci_core_device *vdev,
+			      struct vfio_pci_file_info *info)
 {
 	unsigned int i;
 
-	if (!groups)
+	if (!info)
 		return false;
 
-	for (i = 0; i < groups->count; i++)
-		if (vfio_file_has_dev(groups->files[i], &vdev->vdev))
+	for (i = 0; i < info->count; i++)
+		if (vfio_file_has_dev(info->files[i], &vdev->vdev))
 			return true;
 	return false;
 }
@@ -2429,7 +2429,7 @@ static bool vfio_dev_in_iommufd_ctx(struct vfio_pci_core_device *vdev,
  * get each memory_lock.
  */
 static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
-				      struct vfio_pci_group_info *groups,
+				      struct vfio_pci_file_info *info,
 				      struct iommufd_ctx *iommufd_ctx)
 {
 	struct vfio_pci_core_device *cur_mem;
@@ -2469,7 +2469,8 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 		 * cannot race being opened by another user simultaneously.
 		 *
 		 * Otherwise all opened devices in the dev_set must be
-		 * contained by the set of groups provided by the user.
+		 * contained by the set of groups/devices provided by
+		 * the user.
 		 *
 		 * If user provides a zero-length array, then all the
 		 * opened devices must be bound to a same iommufd_ctx.
@@ -2478,7 +2479,7 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 		 * the calling device is in a singleton dev_set.
 		 */
 		if (cur_vma->vdev.open_count &&
-		    !vfio_dev_in_groups(cur_vma, groups) &&
+		    !vfio_dev_in_files(cur_vma, info) &&
 		    !vfio_dev_in_iommufd_ctx(cur_vma, iommufd_ctx) &&
 		    (dev_set->device_count > 1)) {
 			ret = -EINVAL;
-- 
2.34.1

