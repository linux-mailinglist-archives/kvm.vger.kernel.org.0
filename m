Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69FA9135BE5
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 15:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731904AbgAIO5k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 09:57:40 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:42830 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728737AbgAIO5j (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jan 2020 09:57:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578581858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gDGiLHLaS/+Io2Phnnfgd/F37FeteIfvFFEQMfXM9RA=;
        b=I4vxO4kvES6dyJp5GiiSzsDObNjvHp0j4hy8RSvzfW0CN1JF9lxD593H9eC98Tk2Bhe/gZ
        +num04urfX6sZ0+n+oXUrIcUCHTRreqQDi11C1RZhsukR2gptTRjH+On0fcQYIfSdFQq7x
        MYdTeVVX2GjllxUqGUVwGKUHEgSe7hA=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-JBvgo9C2MTuTk0hsVIUiFg-1; Thu, 09 Jan 2020 09:57:37 -0500
X-MC-Unique: JBvgo9C2MTuTk0hsVIUiFg-1
Received: by mail-qv1-f71.google.com with SMTP id v5so4250765qvn.21
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 06:57:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gDGiLHLaS/+Io2Phnnfgd/F37FeteIfvFFEQMfXM9RA=;
        b=H1zPXitV4HzVekxKQ/O3Kf9Oh70lxDhh0TKB4+2yB5e5dPqG7Gwl7zkT3aHJ4aqhvj
         fCI0AvM4iZT28LXfF/Q7krgOrkjIk6TJM9Eom2Hni9A0RGfNMqrK3jc15XmIEYVxL1tU
         boutkVjdi/LYeqSFvUrxgTQCW0xZyAoj8vWKdiDwqh4Y3Ko8x3xZ8vY+10h+Za+zl6Oc
         y+2FWr9bcPDp6A7JbxOopNgbpzttnsqxzRf91CdDToV/D/C3MkOB9X2BpHvo+r/fhOSZ
         KoTfjLF2boZd44Hvkh1NfdAg8dnePR6Pa8dEFw7o+FqN9o4UxgrzYWIA35+QQNfgNMKU
         AOJw==
X-Gm-Message-State: APjAAAWd/TkpKehRjQaJ+U39ReTkiYvIYhxHVEYOzZLlXgCzNj/eSrpE
        98aw9W2CUmQdKSCumZKp515TDXFBHwFX6TEGvPYoCS4Dt21qZ9Z66ICc1dTcgDpz0yVdwxwaDlf
        3sM/l+nmlJaYS
X-Received: by 2002:a05:620a:102e:: with SMTP id a14mr9510823qkk.159.1578581855559;
        Thu, 09 Jan 2020 06:57:35 -0800 (PST)
X-Google-Smtp-Source: APXvYqw9fW22cpWNa0ej5q9Tvxem01vg3v97AmZT7K2M9MRr1qsTUoG9MFfgUMx1bfEecySbeqsNlQ==
X-Received: by 2002:a05:620a:102e:: with SMTP id a14mr9510799qkk.159.1578581855290;
        Thu, 09 Jan 2020 06:57:35 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id q2sm3124179qkm.5.2020.01.09.06.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 06:57:33 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Christophe de Dinechin <dinechin@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Kevin <kevin.tian@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, peterx@redhat.com,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: [PATCH v3 01/21] vfio: introduce vfio_iova_rw to read/write a range of IOVAs
Date:   Thu,  9 Jan 2020 09:57:09 -0500
Message-Id: <20200109145729.32898-2-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200109145729.32898-1-peterx@redhat.com>
References: <20200109145729.32898-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yan Zhao <yan.y.zhao@intel.com>

vfio_iova_rw will read/write a range of userspace memory (starting form
device iova to iova + len -1) into a kenrel buffer without pinning the
userspace memory.

TODO: vfio needs to mark the iova dirty if vfio_iova_rw(write) is
called.

Cc: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 drivers/vfio/vfio.c             | 45 ++++++++++++++++++
 drivers/vfio/vfio_iommu_type1.c | 81 +++++++++++++++++++++++++++++++++
 include/linux/vfio.h            |  5 ++
 3 files changed, 131 insertions(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index c8482624ca34..36e91e647ed5 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1961,6 +1961,51 @@ int vfio_unpin_pages(struct device *dev, unsigned long *user_pfn, int npage)
 }
 EXPORT_SYMBOL(vfio_unpin_pages);
 
+/*
+ * Read/Write a range of userspace IOVAs for a device into/from a kernel
+ * buffer without pinning the userspace memory
+ * @dev [in]  : device
+ * @iova [in] : base IOVA of a userspace buffer
+ * @data [in] : pointer to kernel buffer
+ * @len [in]  : kernel buffer length
+ * @write     : indicate read or write
+ * Return error on failure or 0 on success.
+ */
+int vfio_iova_rw(struct device *dev, unsigned long iova, void *data,
+		   unsigned long len, bool write)
+{
+	struct vfio_container *container;
+	struct vfio_group *group;
+	struct vfio_iommu_driver *driver;
+	int ret = 0;
+
+	if (!dev || !data || len <= 0)
+		return -EINVAL;
+
+	group = vfio_group_get_from_dev(dev);
+	if (!group)
+		return -ENODEV;
+
+	ret = vfio_group_add_container_user(group);
+	if (ret)
+		goto out;
+
+	container = group->container;
+	driver = container->iommu_driver;
+
+	if (likely(driver && driver->ops->iova_rw))
+		ret = driver->ops->iova_rw(container->iommu_data,
+					   iova, data, len, write);
+	else
+		ret = -ENOTTY;
+
+	vfio_group_try_dissolve_container(group);
+out:
+	vfio_group_put(group);
+	return ret;
+}
+EXPORT_SYMBOL(vfio_iova_rw);
+
 static int vfio_register_iommu_notifier(struct vfio_group *group,
 					unsigned long *events,
 					struct notifier_block *nb)
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 2ada8e6cdb88..aee191077235 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -27,6 +27,7 @@
 #include <linux/iommu.h>
 #include <linux/module.h>
 #include <linux/mm.h>
+#include <linux/mmu_context.h>
 #include <linux/rbtree.h>
 #include <linux/sched/signal.h>
 #include <linux/sched/mm.h>
@@ -2326,6 +2327,85 @@ static int vfio_iommu_type1_unregister_notifier(void *iommu_data,
 	return blocking_notifier_chain_unregister(&iommu->notifier, nb);
 }
 
+static int next_segment(unsigned long len, int offset)
+{
+	if (len > PAGE_SIZE - offset)
+		return PAGE_SIZE - offset;
+	else
+		return len;
+}
+
+static int vfio_iommu_type1_rw_iova_seg(struct vfio_iommu *iommu,
+					  unsigned long iova, void *data,
+					  unsigned long seg_len,
+					  unsigned long offset,
+					  bool write)
+{
+	struct mm_struct *mm;
+	unsigned long vaddr;
+	struct vfio_dma *dma;
+	bool kthread = current->mm == NULL;
+	int ret = 0;
+
+	dma = vfio_find_dma(iommu, iova, PAGE_SIZE);
+	if (!dma)
+		return -EINVAL;
+
+	mm = get_task_mm(dma->task);
+
+	if (!mm)
+		return -ENODEV;
+
+	if (kthread)
+		use_mm(mm);
+	else if (current->mm != mm) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	vaddr = dma->vaddr + iova - dma->iova + offset;
+
+	ret = write ? __copy_to_user((void __user *)vaddr,
+			data, seg_len) :
+		__copy_from_user(data, (void __user *)vaddr,
+				seg_len);
+	if (ret)
+		ret = -EFAULT;
+
+	if (kthread)
+		unuse_mm(mm);
+out:
+	mmput(mm);
+	return ret;
+}
+
+static int vfio_iommu_type1_iova_rw(void *iommu_data, unsigned long iova,
+				    void *data, unsigned long len, bool write)
+{
+	struct vfio_iommu *iommu = iommu_data;
+	int offset = iova & ~PAGE_MASK;
+	int seg_len;
+	int ret = 0;
+
+	iova = iova & PAGE_MASK;
+
+	mutex_lock(&iommu->lock);
+	while ((seg_len = next_segment(len, offset)) > 0) {
+		ret = vfio_iommu_type1_rw_iova_seg(iommu, iova, data,
+						   seg_len, offset, write);
+		if (ret)
+			break;
+
+		offset = 0;
+		len -= seg_len;
+		data += seg_len;
+		iova += PAGE_SIZE;
+	}
+
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
 static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
 	.name			= "vfio-iommu-type1",
 	.owner			= THIS_MODULE,
@@ -2338,6 +2418,7 @@ static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
 	.unpin_pages		= vfio_iommu_type1_unpin_pages,
 	.register_notifier	= vfio_iommu_type1_register_notifier,
 	.unregister_notifier	= vfio_iommu_type1_unregister_notifier,
+	.iova_rw		= vfio_iommu_type1_iova_rw,
 };
 
 static int __init vfio_iommu_type1_init(void)
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index e42a711a2800..7bf18a31bbcf 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -82,6 +82,8 @@ struct vfio_iommu_driver_ops {
 					     struct notifier_block *nb);
 	int		(*unregister_notifier)(void *iommu_data,
 					       struct notifier_block *nb);
+	int		(*iova_rw)(void *iommu_data, unsigned long iova,
+				   void *data, unsigned long len, bool write);
 };
 
 extern int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);
@@ -107,6 +109,9 @@ extern int vfio_pin_pages(struct device *dev, unsigned long *user_pfn,
 extern int vfio_unpin_pages(struct device *dev, unsigned long *user_pfn,
 			    int npage);
 
+extern int vfio_iova_rw(struct device *dev, unsigned long iova, void *data,
+			unsigned long len, bool write);
+
 /* each type has independent events */
 enum vfio_notify_type {
 	VFIO_IOMMU_NOTIFY = 0,
-- 
2.24.1

