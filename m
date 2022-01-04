Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D30483A49
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 02:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbiADB7N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jan 2022 20:59:13 -0500
Received: from mga05.intel.com ([192.55.52.43]:37557 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229757AbiADB7M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jan 2022 20:59:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641261552; x=1672797552;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QSJSuixQj2c2RVpXtE8IShxwGNkHMzp6PO0/hCqGO3I=;
  b=jUj3T7vnm9j+nNohbkRaWcTJdkiqeoeI2ZWV06arPhlKCfXgxSrIp+Ph
   58IReFiURxbs0KzLX2sYxg7U1jlz8M7XngJ0a54brJHuNTLAwd78IFUvE
   fr/sGZfkqds52KhmLDKmVw68iif/Lg3JkPGD50wTZe4bEbmabbekq/IGI
   rhx9u06pQiCjMpUQH6MAjCFOmkR/+HHkRVeld0o//4Y4y07wx7JTF9vVf
   4hZY0OnF5ZHFI6GfIYewHLMQQwjpZcC9VHUeuMrUQL/3CcDtFB95pYOYO
   I43DF7WfNbM/LzuGpfrycQwNOL/pBSQuS6Mb7AJtWQvfW2SaDowgs+2jO
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10216"; a="328482055"
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="328482055"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2022 17:59:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="667573411"
Received: from allen-box.sh.intel.com ([10.239.159.118])
  by fmsmga001.fm.intel.com with ESMTP; 03 Jan 2022 17:58:54 -0800
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>
Cc:     Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v5 14/14] iommu: Remove iommu group changes notifier
Date:   Tue,  4 Jan 2022 09:56:44 +0800
Message-Id: <20220104015644.2294354-15-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220104015644.2294354-1-baolu.lu@linux.intel.com>
References: <20220104015644.2294354-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The iommu group changes notifer is not referenced in the tree. Remove it
to avoid dead code.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 include/linux/iommu.h | 23 -------------
 drivers/iommu/iommu.c | 75 -------------------------------------------
 2 files changed, 98 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 568f285468cf..408a6d2b3034 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -403,13 +403,6 @@ static inline void iommu_iotlb_gather_init(struct iommu_iotlb_gather *gather)
 	};
 }
 
-#define IOMMU_GROUP_NOTIFY_ADD_DEVICE		1 /* Device added */
-#define IOMMU_GROUP_NOTIFY_DEL_DEVICE		2 /* Pre Device removed */
-#define IOMMU_GROUP_NOTIFY_BIND_DRIVER		3 /* Pre Driver bind */
-#define IOMMU_GROUP_NOTIFY_BOUND_DRIVER		4 /* Post Driver bind */
-#define IOMMU_GROUP_NOTIFY_UNBIND_DRIVER	5 /* Pre Driver unbind */
-#define IOMMU_GROUP_NOTIFY_UNBOUND_DRIVER	6 /* Post Driver unbind */
-
 extern int bus_set_iommu(struct bus_type *bus, const struct iommu_ops *ops);
 extern int bus_iommu_probe(struct bus_type *bus);
 extern bool iommu_present(struct bus_type *bus);
@@ -482,10 +475,6 @@ extern int iommu_group_for_each_dev(struct iommu_group *group, void *data,
 extern struct iommu_group *iommu_group_get(struct device *dev);
 extern struct iommu_group *iommu_group_ref_get(struct iommu_group *group);
 extern void iommu_group_put(struct iommu_group *group);
-extern int iommu_group_register_notifier(struct iommu_group *group,
-					 struct notifier_block *nb);
-extern int iommu_group_unregister_notifier(struct iommu_group *group,
-					   struct notifier_block *nb);
 extern int iommu_register_device_fault_handler(struct device *dev,
 					iommu_dev_fault_handler_t handler,
 					void *data);
@@ -885,18 +874,6 @@ static inline void iommu_group_put(struct iommu_group *group)
 {
 }
 
-static inline int iommu_group_register_notifier(struct iommu_group *group,
-						struct notifier_block *nb)
-{
-	return -ENODEV;
-}
-
-static inline int iommu_group_unregister_notifier(struct iommu_group *group,
-						  struct notifier_block *nb)
-{
-	return 0;
-}
-
 static inline
 int iommu_register_device_fault_handler(struct device *dev,
 					iommu_dev_fault_handler_t handler,
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index ff0c8c1ad5af..72a95dea688e 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -18,7 +18,6 @@
 #include <linux/errno.h>
 #include <linux/iommu.h>
 #include <linux/idr.h>
-#include <linux/notifier.h>
 #include <linux/err.h>
 #include <linux/pci.h>
 #include <linux/bitops.h>
@@ -40,7 +39,6 @@ struct iommu_group {
 	struct kobject *devices_kobj;
 	struct list_head devices;
 	struct mutex mutex;
-	struct blocking_notifier_head notifier;
 	void *iommu_data;
 	void (*iommu_data_release)(void *iommu_data);
 	char *name;
@@ -627,7 +625,6 @@ struct iommu_group *iommu_group_alloc(void)
 	mutex_init(&group->mutex);
 	INIT_LIST_HEAD(&group->devices);
 	INIT_LIST_HEAD(&group->entry);
-	BLOCKING_INIT_NOTIFIER_HEAD(&group->notifier);
 
 	ret = ida_simple_get(&iommu_group_ida, 0, 0, GFP_KERNEL);
 	if (ret < 0) {
@@ -902,10 +899,6 @@ int iommu_group_add_device(struct iommu_group *group, struct device *dev)
 	if (ret)
 		goto err_put_group;
 
-	/* Notify any listeners about change to group. */
-	blocking_notifier_call_chain(&group->notifier,
-				     IOMMU_GROUP_NOTIFY_ADD_DEVICE, dev);
-
 	trace_add_device_to_group(group->id, dev);
 
 	dev_info(dev, "Adding to iommu group %d\n", group->id);
@@ -947,10 +940,6 @@ void iommu_group_remove_device(struct device *dev)
 
 	dev_info(dev, "Removing from iommu group %d\n", group->id);
 
-	/* Pre-notify listeners that a device is being removed. */
-	blocking_notifier_call_chain(&group->notifier,
-				     IOMMU_GROUP_NOTIFY_DEL_DEVICE, dev);
-
 	mutex_lock(&group->mutex);
 	list_for_each_entry(tmp_device, &group->devices, list) {
 		if (tmp_device->dev == dev) {
@@ -1073,36 +1062,6 @@ void iommu_group_put(struct iommu_group *group)
 }
 EXPORT_SYMBOL_GPL(iommu_group_put);
 
-/**
- * iommu_group_register_notifier - Register a notifier for group changes
- * @group: the group to watch
- * @nb: notifier block to signal
- *
- * This function allows iommu group users to track changes in a group.
- * See include/linux/iommu.h for actions sent via this notifier.  Caller
- * should hold a reference to the group throughout notifier registration.
- */
-int iommu_group_register_notifier(struct iommu_group *group,
-				  struct notifier_block *nb)
-{
-	return blocking_notifier_chain_register(&group->notifier, nb);
-}
-EXPORT_SYMBOL_GPL(iommu_group_register_notifier);
-
-/**
- * iommu_group_unregister_notifier - Unregister a notifier
- * @group: the group to watch
- * @nb: notifier block to signal
- *
- * Unregister a previously registered group notifier block.
- */
-int iommu_group_unregister_notifier(struct iommu_group *group,
-				    struct notifier_block *nb)
-{
-	return blocking_notifier_chain_unregister(&group->notifier, nb);
-}
-EXPORT_SYMBOL_GPL(iommu_group_unregister_notifier);
-
 /**
  * iommu_register_device_fault_handler() - Register a device fault handler
  * @dev: the device
@@ -1651,14 +1610,8 @@ static int remove_iommu_group(struct device *dev, void *data)
 static int iommu_bus_notifier(struct notifier_block *nb,
 			      unsigned long action, void *data)
 {
-	unsigned long group_action = 0;
 	struct device *dev = data;
-	struct iommu_group *group;
 
-	/*
-	 * ADD/DEL call into iommu driver ops if provided, which may
-	 * result in ADD/DEL notifiers to group->notifier
-	 */
 	if (action == BUS_NOTIFY_ADD_DEVICE) {
 		int ret;
 
@@ -1669,34 +1622,6 @@ static int iommu_bus_notifier(struct notifier_block *nb,
 		return NOTIFY_OK;
 	}
 
-	/*
-	 * Remaining BUS_NOTIFYs get filtered and republished to the
-	 * group, if anyone is listening
-	 */
-	group = iommu_group_get(dev);
-	if (!group)
-		return 0;
-
-	switch (action) {
-	case BUS_NOTIFY_BIND_DRIVER:
-		group_action = IOMMU_GROUP_NOTIFY_BIND_DRIVER;
-		break;
-	case BUS_NOTIFY_BOUND_DRIVER:
-		group_action = IOMMU_GROUP_NOTIFY_BOUND_DRIVER;
-		break;
-	case BUS_NOTIFY_UNBIND_DRIVER:
-		group_action = IOMMU_GROUP_NOTIFY_UNBIND_DRIVER;
-		break;
-	case BUS_NOTIFY_UNBOUND_DRIVER:
-		group_action = IOMMU_GROUP_NOTIFY_UNBOUND_DRIVER;
-		break;
-	}
-
-	if (group_action)
-		blocking_notifier_call_chain(&group->notifier,
-					     group_action, dev);
-
-	iommu_group_put(group);
 	return 0;
 }
 
-- 
2.25.1

