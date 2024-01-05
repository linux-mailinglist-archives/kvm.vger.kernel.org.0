Return-Path: <kvm+bounces-5738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3744D825978
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 18:54:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AB4621F241ED
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 17:54:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 435A134546;
	Fri,  5 Jan 2024 17:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="PVIJiCp4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7697B2E85B
	for <kvm@vger.kernel.org>; Fri,  5 Jan 2024 17:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-781be0ccd30so125191585a.1
        for <kvm@vger.kernel.org>; Fri, 05 Jan 2024 09:53:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1704477221; x=1705082021; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=miRb0rXpWLb9jsTXLzk36Q4Oua5evPe+9mfQTaGdXj0=;
        b=PVIJiCp4xSU42jvaKzNsEvgcjQ4ZpqrexRntLWYZtSPmH18zdnMaDtd2mgXKnT2JMm
         vrOLgVXaUR46CGKuwKM107j+x6xG+zrVuVmi4gb+2WYblTzxpF5EYHR1cKoueB7z6l+B
         2K9AayjS11r17Spl9/CYh4LvnAEckblA5AcF2ngUTRoqXO/Z0h1/yecX79KcdZmETfp0
         xzVGBcTgSz13cEIeAvAhAgkL3SqD79MD4su0hC4pw/59KKbowIVJJcOg5GRnOQxbk0dZ
         rU3XUyt56kNgGdAWW6h7BXHlsg1JhNPCrzB8z6rp4EKgAGMx63kTIJwCICsaVv8vbbop
         cWFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704477221; x=1705082021;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=miRb0rXpWLb9jsTXLzk36Q4Oua5evPe+9mfQTaGdXj0=;
        b=AjZvWSOLZX/F0rWoiRgHDR24mv2atSEjtLR9mP54Nvj0Bn66d0OdUKNqrYeIL54SHw
         7F7TrF6b8o9VejuL9yFEym7Jqa8m6PjSW8g/67/UmutmLM4dFDs7Fc6biwpPta8pjOc0
         14LHwLlELVsPdvRZ0xM+0vKl+upGqex1nG2itW9IKtWXEbV2wN827UQrt7ieBI5omGVT
         un4dHvNrrUjLokt/qv7Ofk09ZEjCi1Pa/aZeGeK6qXUsVgFZJg2Clt8cEwk9KZA0nxWT
         H5WE+ZuButPDydkvPuScC883q/zIZPL16Buc18sgzsFCNd74kQs6ck1KFEMGgZpY3mJX
         a4Rg==
X-Gm-Message-State: AOJu0YwP+uG/fm+Kh2yQVS5h3/a660+w53WZ4gs3RjZ3Jiuj40q5MxCW
	pPz9FMjMQVXAO+b/Ec/M150rT49p5EZBJg==
X-Google-Smtp-Source: AGHT+IGCN+T44qrgo6UkyBazOh1o48d2ZcobTN86dpi+/kaYtJEFnysKgJ7G5TwzHG1++RItZhDUPg==
X-Received: by 2002:a05:620a:4798:b0:781:1411:9383 with SMTP id dt24-20020a05620a479800b0078114119383mr2669210qkb.94.1704477221299;
        Fri, 05 Jan 2024 09:53:41 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id c10-20020a37e10a000000b007815a43d297sm746129qkm.40.2024.01.05.09.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jan 2024 09:53:40 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1rLoO3-001UdP-Ju;
	Fri, 05 Jan 2024 13:53:39 -0400
Date: Fri, 5 Jan 2024 13:53:39 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Nicolin Chen <nicolinc@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Longfang Liu <liulongfang@huawei.com>,
	Yan Zhao <yan.y.zhao@intel.com>, iommu@lists.linux.dev,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 14/14] iommu: Track iopf group instead of last fault
Message-ID: <20240105175339.GI50608@ziepe.ca>
References: <20231220012332.168188-1-baolu.lu@linux.intel.com>
 <20231220012332.168188-15-baolu.lu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231220012332.168188-15-baolu.lu@linux.intel.com>

On Wed, Dec 20, 2023 at 09:23:32AM +0800, Lu Baolu wrote:
>  /**
> - * iommu_handle_iopf - IO Page Fault handler
> - * @fault: fault event
> - * @iopf_param: the fault parameter of the device.
> + * iommu_report_device_fault() - Report fault event to device driver
> + * @dev: the device
> + * @evt: fault event data
>   *
> - * Add a fault to the device workqueue, to be handled by mm.
> + * Called by IOMMU drivers when a fault is detected, typically in a threaded IRQ
> + * handler. When this function fails and the fault is recoverable, it is the
> + * caller's responsibility to complete the fault.

This patch seems OK for what it does so:

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

However, this seems like a strange design, surely this function should
just call ops->page_response() when it can't enqueue the fault?

It is much cleaner that way, so maybe you can take this into a
following patch (along with the driver fixes to accomodate. (and
perhaps iommu_report_device_fault() should return void too)

Also iopf_group_response() should return void (another patch!),
nothing can do anything with the failure. This implies that
ops->page_response() must also return void - which is consistent with
what the drivers do, the failure paths are all integrity validations
of the fault and should be WARN_ON'd not return codes.

diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
index 7d11b74e4048e2..2715e24fd64234 100644
--- a/drivers/iommu/io-pgfault.c
+++ b/drivers/iommu/io-pgfault.c
@@ -39,7 +39,7 @@ static void iopf_put_dev_fault_param(struct iommu_fault_param *fault_param)
 		kfree_rcu(fault_param, rcu);
 }
 
-void iopf_free_group(struct iopf_group *group)
+static void __iopf_free_group(struct iopf_group *group)
 {
 	struct iopf_fault *iopf, *next;
 
@@ -50,6 +50,11 @@ void iopf_free_group(struct iopf_group *group)
 
 	/* Pair with iommu_report_device_fault(). */
 	iopf_put_dev_fault_param(group->fault_param);
+}
+
+void iopf_free_group(struct iopf_group *group)
+{
+	__iopf_free_group(group);
 	kfree(group);
 }
 EXPORT_SYMBOL_GPL(iopf_free_group);
@@ -97,14 +102,49 @@ static int report_partial_fault(struct iommu_fault_param *fault_param,
 	return 0;
 }
 
+static struct iopf_group *iopf_group_alloc(struct iommu_fault_param *iopf_param,
+					   struct iopf_fault *evt,
+					   struct iopf_group *abort_group)
+{
+	struct iopf_fault *iopf, *next;
+	struct iopf_group *group;
+
+	group = kzalloc(sizeof(*group), GFP_KERNEL);
+	if (!group) {
+		/*
+		 * We always need to construct the group as we need it to abort
+		 * the request at the driver if it cfan't be handled.
+		 */
+		group = abort_group;
+	}
+
+	group->fault_param = iopf_param;
+	group->last_fault.fault = evt->fault;
+	INIT_LIST_HEAD(&group->faults);
+	INIT_LIST_HEAD(&group->pending_node);
+	list_add(&group->last_fault.list, &group->faults);
+
+	/* See if we have partial faults for this group */
+	mutex_lock(&iopf_param->lock);
+	list_for_each_entry_safe(iopf, next, &iopf_param->partial, list) {
+		if (iopf->fault.prm.grpid == evt->fault.prm.grpid)
+			/* Insert *before* the last fault */
+			list_move(&iopf->list, &group->faults);
+	}
+	list_add(&group->pending_node, &iopf_param->faults);
+	mutex_unlock(&iopf_param->lock);
+
+	return group;
+}
+
 /**
  * iommu_report_device_fault() - Report fault event to device driver
  * @dev: the device
  * @evt: fault event data
  *
  * Called by IOMMU drivers when a fault is detected, typically in a threaded IRQ
- * handler. When this function fails and the fault is recoverable, it is the
- * caller's responsibility to complete the fault.
+ * handler. If this function fails then ops->page_response() was called to
+ * complete evt if required.
  *
  * This module doesn't handle PCI PASID Stop Marker; IOMMU drivers must discard
  * them before reporting faults. A PASID Stop Marker (LRW = 0b100) doesn't
@@ -143,22 +183,24 @@ int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
 {
 	struct iommu_fault *fault = &evt->fault;
 	struct iommu_fault_param *iopf_param;
-	struct iopf_fault *iopf, *next;
-	struct iommu_domain *domain;
+	struct iopf_group abort_group;
 	struct iopf_group *group;
 	int ret;
 
+/*
+  remove this too, it is pointless. The driver should only invoke this function on page_req faults.
 	if (fault->type != IOMMU_FAULT_PAGE_REQ)
 		return -EOPNOTSUPP;
+*/
 
 	iopf_param = iopf_get_dev_fault_param(dev);
-	if (!iopf_param)
+	if (WARN_ON(!iopf_param))
 		return -ENODEV;
 
 	if (!(fault->prm.flags & IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE)) {
 		ret = report_partial_fault(iopf_param, fault);
 		iopf_put_dev_fault_param(iopf_param);
-
+		/* A request that is not the last does not need to be ack'd */
 		return ret;
 	}
 
@@ -170,56 +212,34 @@ int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
 	 * will send a response to the hardware. We need to clean up before
 	 * leaving, otherwise partial faults will be stuck.
 	 */
-	domain = get_domain_for_iopf(dev, fault);
-	if (!domain) {
-		ret = -EINVAL;
-		goto cleanup_partial;
-	}
-
-	group = kzalloc(sizeof(*group), GFP_KERNEL);
-	if (!group) {
+	group = iopf_group_alloc(iopf_param, evt, &abort_group);
+	if (group == &abort_group) {
 		ret = -ENOMEM;
-		goto cleanup_partial;
+		goto err_abort;
 	}
 
-	group->fault_param = iopf_param;
-	group->last_fault.fault = *fault;
-	INIT_LIST_HEAD(&group->faults);
-	INIT_LIST_HEAD(&group->pending_node);
-	group->domain = domain;
-	list_add(&group->last_fault.list, &group->faults);
-
-	/* See if we have partial faults for this group */
-	mutex_lock(&iopf_param->lock);
-	list_for_each_entry_safe(iopf, next, &iopf_param->partial, list) {
-		if (iopf->fault.prm.grpid == fault->prm.grpid)
-			/* Insert *before* the last fault */
-			list_move(&iopf->list, &group->faults);
+	group->domain = get_domain_for_iopf(dev, fault);
+	if (!group->domain) {
+		ret = -EINVAL;
+		goto err_abort;
 	}
-	list_add(&group->pending_node, &iopf_param->faults);
-	mutex_unlock(&iopf_param->lock);
 
-	ret = domain->iopf_handler(group);
-	if (ret) {
-		mutex_lock(&iopf_param->lock);
-		list_del_init(&group->pending_node);
-		mutex_unlock(&iopf_param->lock);
+	/*
+	 * On success iopf_handler must call iopf_group_response() and
+	 * iopf_free_group()
+	 */
+	ret = group->domain->iopf_handler(group);
+	if (ret)
+		goto err_abort;
+	return 0;
+
+err_abort:
+	iopf_group_response(group,
+			    IOMMU_PAGE_RESP_FAILURE); //?? right code?
+	if (group == &abort_group)
+		__iopf_free_group(group);
+	else
 		iopf_free_group(group);
-	}
-
-	return ret;
-
-cleanup_partial:
-	mutex_lock(&iopf_param->lock);
-	list_for_each_entry_safe(iopf, next, &iopf_param->partial, list) {
-		if (iopf->fault.prm.grpid == fault->prm.grpid) {
-			list_del(&iopf->list);
-			kfree(iopf);
-		}
-	}
-	mutex_unlock(&iopf_param->lock);
-	iopf_put_dev_fault_param(iopf_param);
-
 	return ret;
 }
 EXPORT_SYMBOL_GPL(iommu_report_device_fault);
@@ -262,7 +282,7 @@ EXPORT_SYMBOL_GPL(iopf_queue_flush_dev);
  *
  * Return 0 on success and <0 on error.
  */
-int iopf_group_response(struct iopf_group *group,
+void iopf_group_response(struct iopf_group *group,
 			enum iommu_page_response_code status)
 {
 	struct iommu_fault_param *fault_param = group->fault_param;
@@ -400,9 +420,9 @@ EXPORT_SYMBOL_GPL(iopf_queue_add_device);
  */
 void iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev)
 {
-	struct iopf_fault *iopf, *next;
+	struct iopf_fault *partial_iopf;
+	struct iopf_fault *next;
 	struct iopf_group *group, *temp;
-	struct iommu_page_response resp;
 	struct dev_iommu *param = dev->iommu;
 	struct iommu_fault_param *fault_param;
 	const struct iommu_ops *ops = dev_iommu_ops(dev);
@@ -416,15 +436,16 @@ void iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev)
 		goto unlock;
 
 	mutex_lock(&fault_param->lock);
-	list_for_each_entry_safe(iopf, next, &fault_param->partial, list)
-		kfree(iopf);
+	list_for_each_entry_safe(partial_iopf, next, &fault_param->partial, list)
+		kfree(partial_iopf);
 
 	list_for_each_entry_safe(group, temp, &fault_param->faults, pending_node) {
-		memset(&resp, 0, sizeof(struct iommu_page_response));
-		iopf = &group->last_fault;
-		resp.pasid = iopf->fault.prm.pasid;
-		resp.grpid = iopf->fault.prm.grpid;
-		resp.code = IOMMU_PAGE_RESP_INVALID;
+		struct iopf_fault *iopf = &group->last_fault;
+		struct iommu_page_response resp = {
+			.pasid = iopf->fault.prm.pasid,
+			.grpid = iopf->fault.prm.grpid,
+			.code = IOMMU_PAGE_RESP_INVALID
+		};
 
 		if (iopf->fault.prm.flags & IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID)
 			resp.flags = IOMMU_PAGE_RESP_PASID_VALID;

