Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C824974E510
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 05:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbjGKDC5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 23:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231298AbjGKDCP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 23:02:15 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FFE11BCB;
        Mon, 10 Jul 2023 20:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689044506; x=1720580506;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6B2ssMaZqxYuqId22oB4ezjv68M759mAB05IH5aiNnY=;
  b=B9ZQuriKGI3BumNqpxXEzuj8x9qqPednvqTviuXMMQcV1AzEFKLz+sz7
   7VFIPKB8J6MeT07Y790tAzhX9Z2OyRZPivKopLLgHJXVDBKpVucxxBxZA
   bGeUAaukAyv5qmwiKd6jZc4oGW+paZnB7H1JiYYtA43qU4cDKev9+OZJx
   N3t4EW2kop4G/g0HmhXjTYaL9nkmDMLeC9qBBk2jzd6FFuo+d1tBW4fa3
   UybtrC8gq556X7lHwE6Zhe+VmX/pOSBZdmaENbSknbaG/Hlw7meO8+XXV
   a+pD0LOnzZTcRvOptGHmKqx4j8IoqRKemwWS7epaakOpeXrXXwTIHoMtv
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="361973260"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="361973260"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2023 19:59:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="724250954"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="724250954"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga007.fm.intel.com with ESMTP; 10 Jul 2023 19:59:56 -0700
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
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com, zhenzhong.duan@intel.com,
        clegoate@redhat.com
Subject: [PATCH v14 26/26] docs: vfio: Add vfio device cdev description
Date:   Mon, 10 Jul 2023 19:59:28 -0700
Message-Id: <20230711025928.6438-27-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230711025928.6438-1-yi.l.liu@intel.com>
References: <20230711025928.6438-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This gives notes for userspace applications on device cdev usage.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 Documentation/driver-api/vfio.rst | 139 ++++++++++++++++++++++++++++++
 1 file changed, 139 insertions(+)

diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
index 363e12c90b87..633d11c7fa71 100644
--- a/Documentation/driver-api/vfio.rst
+++ b/Documentation/driver-api/vfio.rst
@@ -239,6 +239,137 @@ group and can access them as follows::
 	/* Gratuitous device reset and go... */
 	ioctl(device, VFIO_DEVICE_RESET);
 
+IOMMUFD and vfio_iommu_type1
+----------------------------
+
+IOMMUFD is the new user API to manage I/O page tables from userspace.
+It intends to be the portal of delivering advanced userspace DMA
+features (nested translation [5]_, PASID [6]_, etc.) while also providing
+a backwards compatibility interface for existing VFIO_TYPE1v2_IOMMU use
+cases.  Eventually the vfio_iommu_type1 driver, as well as the legacy
+vfio container and group model is intended to be deprecated.
+
+The IOMMUFD backwards compatibility interface can be enabled two ways.
+In the first method, the kernel can be configured with
+CONFIG_IOMMUFD_VFIO_CONTAINER, in which case the IOMMUFD subsystem
+transparently provides the entire infrastructure for the VFIO
+container and IOMMU backend interfaces.  The compatibility mode can
+also be accessed if the VFIO container interface, ie. /dev/vfio/vfio is
+simply symlink'd to /dev/iommu.  Note that at the time of writing, the
+compatibility mode is not entirely feature complete relative to
+VFIO_TYPE1v2_IOMMU (ex. DMA mapping MMIO) and does not attempt to
+provide compatibility to the VFIO_SPAPR_TCE_IOMMU interface.  Therefore
+it is not generally advisable at this time to switch from native VFIO
+implementations to the IOMMUFD compatibility interfaces.
+
+Long term, VFIO users should migrate to device access through the cdev
+interface described below, and native access through the IOMMUFD
+provided interfaces.
+
+VFIO Device cdev
+----------------
+
+Traditionally user acquires a device fd via VFIO_GROUP_GET_DEVICE_FD
+in a VFIO group.
+
+With CONFIG_VFIO_DEVICE_CDEV=y the user can now acquire a device fd
+by directly opening a character device /dev/vfio/devices/vfioX where
+"X" is the number allocated uniquely by VFIO for registered devices.
+cdev interface does not support noiommu devices, so user should use
+the legacy group interface if noiommu is wanted.
+
+The cdev only works with IOMMUFD.  Both VFIO drivers and applications
+must adapt to the new cdev security model which requires using
+VFIO_DEVICE_BIND_IOMMUFD to claim DMA ownership before starting to
+actually use the device.  Once BIND succeeds then a VFIO device can
+be fully accessed by the user.
+
+VFIO device cdev doesn't rely on VFIO group/container/iommu drivers.
+Hence those modules can be fully compiled out in an environment
+where no legacy VFIO application exists.
+
+So far SPAPR does not support IOMMUFD yet.  So it cannot support device
+cdev either.
+
+vfio device cdev access is still bound by IOMMU group semantics, ie. there
+can be only one DMA owner for the group.  Devices belonging to the same
+group can not be bound to multiple iommufd_ctx or shared between native
+kernel and vfio bus driver or other driver supporting the driver_managed_dma
+flag.  A violation of this ownership requirement will fail at the
+VFIO_DEVICE_BIND_IOMMUFD ioctl, which gates full device access.
+
+Device cdev Example
+-------------------
+
+Assume user wants to access PCI device 0000:6a:01.0::
+
+	$ ls /sys/bus/pci/devices/0000:6a:01.0/vfio-dev/
+	vfio0
+
+This device is therefore represented as vfio0.  The user can verify
+its existence::
+
+	$ ls -l /dev/vfio/devices/vfio0
+	crw------- 1 root root 511, 0 Feb 16 01:22 /dev/vfio/devices/vfio0
+	$ cat /sys/bus/pci/devices/0000:6a:01.0/vfio-dev/vfio0/dev
+	511:0
+	$ ls -l /dev/char/511\:0
+	lrwxrwxrwx 1 root root 21 Feb 16 01:22 /dev/char/511:0 -> ../vfio/devices/vfio0
+
+Then provide the user with access to the device if unprivileged
+operation is desired::
+
+	$ chown user:user /dev/vfio/devices/vfio0
+
+Finally the user could get cdev fd by::
+
+	cdev_fd = open("/dev/vfio/devices/vfio0", O_RDWR);
+
+An opened cdev_fd doesn't give the user any permission of accessing
+the device except binding the cdev_fd to an iommufd.  After that point
+then the device is fully accessible including attaching it to an
+IOMMUFD IOAS/HWPT to enable userspace DMA::
+
+	struct vfio_device_bind_iommufd bind = {
+		.argsz = sizeof(bind),
+		.flags = 0,
+	};
+	struct iommu_ioas_alloc alloc_data  = {
+		.size = sizeof(alloc_data),
+		.flags = 0,
+	};
+	struct vfio_device_attach_iommufd_pt attach_data = {
+		.argsz = sizeof(attach_data),
+		.flags = 0,
+	};
+	struct iommu_ioas_map map = {
+		.size = sizeof(map),
+		.flags = IOMMU_IOAS_MAP_READABLE |
+			 IOMMU_IOAS_MAP_WRITEABLE |
+			 IOMMU_IOAS_MAP_FIXED_IOVA,
+		.__reserved = 0,
+	};
+
+	iommufd = open("/dev/iommu", O_RDWR);
+
+	bind.iommufd = iommufd;
+	ioctl(cdev_fd, VFIO_DEVICE_BIND_IOMMUFD, &bind);
+
+	ioctl(iommufd, IOMMU_IOAS_ALLOC, &alloc_data);
+	attach_data.pt_id = alloc_data.out_ioas_id;
+	ioctl(cdev_fd, VFIO_DEVICE_ATTACH_IOMMUFD_PT, &attach_data);
+
+	/* Allocate some space and setup a DMA mapping */
+	map.user_va = (int64_t)mmap(0, 1024 * 1024, PROT_READ | PROT_WRITE,
+				    MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);
+	map.iova = 0; /* 1MB starting at 0x0 from device view */
+	map.length = 1024 * 1024;
+	map.ioas_id = alloc_data.out_ioas_id;;
+
+	ioctl(iommufd, IOMMU_IOAS_MAP, &map);
+
+	/* Other device operations as stated in "VFIO Usage Example" */
+
 VFIO User API
 -------------------------------------------------------------------------------
 
@@ -566,3 +697,11 @@ This implementation has some specifics:
 				\-0d.1
 
 	00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 90)
+
+.. [5] Nested translation is an IOMMU feature which supports two stage
+   address translations.  This improves the address translation efficiency
+   in IOMMU virtualization.
+
+.. [6] PASID stands for Process Address Space ID, introduced by PCI
+   Express.  It is a prerequisite for Shared Virtual Addressing (SVA)
+   and Scalable I/O Virtualization (Scalable IOV).
-- 
2.34.1

