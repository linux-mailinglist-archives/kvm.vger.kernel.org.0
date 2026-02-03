Return-Path: <kvm+bounces-70095-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mAP/GXRygmnBUgMAu9opvQ
	(envelope-from <kvm+bounces-70095-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 23:11:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D8514DF1AA
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 23:10:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6FDC830B0539
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 22:10:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 397D5376BCC;
	Tue,  3 Feb 2026 22:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l4L4wvoX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64AA3372B49
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 22:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770156596; cv=none; b=jde/QRj6t7mbMbcwVMj42EqMO+KBoWe6KM9ZFaaXzXgFU5NUBOibJIy1ow6jpHGmUX6OhZCOw/LMlRqvo583OfzsePcx5IQgIRm/AA284v5bh3AqvrlPznOYUv/9JFkNx2cWehMfZbf1dJfsz0zYmZJJTMKWmmbl5xY/IDzSJXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770156596; c=relaxed/simple;
	bh=EPIDbGh/tMkEW2OK2vMYjXt9eMqNUMuuIlOKoX9JYrk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PjBiVlX2b8usVpJB7r6PMwni6m6F+hA57s/CPyDNGyadCEfr9IA0HIxzRiDwTB0Bjz3nqWB1AGbop4tNMf3ZlBn5+uwp0dGINElvRJHPlg7v8nmcoll8Ciy++DKyHWX6KXcBMmZWzVhnQY+jNIFQTDvZx2nljDuRthklf8gnAeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l4L4wvoX; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--skhawaja.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82317005ee6so3167814b3a.0
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 14:09:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770156594; x=1770761394; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ngtugd2l6eNG/KJf2LKmJyyZZ0IPLWVKkgim2iKhMrs=;
        b=l4L4wvoXQ5xebiAMnnRyo3Ueu9aUV9AJrWW7fUWUkgigqqTMxNwplMFD8F16iXNe9e
         kZNYLershX3fs+11irSn9JAzeISrUD/NR3JojHq+flmN8a3vi9OhiqBeO7HtZFoCNUhf
         yIKo6O3H8FC/7Eym1MPMqFiWioumReVjhBfxQ4gRxznuFsuYIr2LKUzCyvVMlP1CGN/n
         RU7F7NqZUtD/aLvHWcvyuNfABPllGTVd5puUMtCq4Gh8cvs61gIkhwklR1MoF6jLVVxi
         thdYlIGgr7YA9NpZ87Tj7C3vs8m/awjAkgX201Z9MQ9xUJm3n0SfwcUv0OkgucXIeYEn
         ba7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770156594; x=1770761394;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ngtugd2l6eNG/KJf2LKmJyyZZ0IPLWVKkgim2iKhMrs=;
        b=TvvWF3m+o4ghZ8eestH9NgUbfEZv4qZIgqBDzAPde1M7Rm5Vn6J09a+vJKOemzK06D
         DT/IehU1rVjqKVv3rogLVlLtzB613SJkF5hYvtLoKTKe0hDncgv5jDrvlmZD/D8Qab75
         EP7vQBqUKQF/XosXuTP+TpMtACcGkLThl1QKzBSLlAYcsyrs4kkpSbPs+Omzf8YUorHD
         2wyJ3tBXSEEZv76k8IUyiK7hgxNq6O70yGiiWMj57LhFo89lknEyL891JDUFkfW6dqQs
         IXIFvReraPwAc/LZ1y1YQRXUw5Akw7apgY/gwJ2LGeT/tnBqpdR0u9TTkcx9ERhNWZtJ
         09xw==
X-Forwarded-Encrypted: i=1; AJvYcCUCVpPbtL2FiJU70WXGaYBAoFjb/8FPLla79THL0jv+89Lg0CY52dz8NrwS9UuEFbYJkTk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7CPzkN69GKAccAHRIhSKhObYLCJXFuc9Cn7XVyeZUIzjAdFny
	UMl1Rwx2RVZp9Sv4ZeC39VhY5u0UCaQ5xu/t3ByncsKtDSFwjr8zL/+DspzBHfskSKRhHbAi3MU
	VpK3fMhVq6Fh7ew==
X-Received: from pfde20.prod.google.com ([2002:aa7:8c54:0:b0:823:1513:f42d])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:a226:b0:823:30a1:d5ba with SMTP id d2e1a72fcca58-8241c6751aemr879693b3a.51.1770156593706;
 Tue, 03 Feb 2026 14:09:53 -0800 (PST)
Date: Tue,  3 Feb 2026 22:09:36 +0000
In-Reply-To: <20260203220948.2176157-1-skhawaja@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260203220948.2176157-1-skhawaja@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260203220948.2176157-3-skhawaja@google.com>
Subject: [PATCH 02/14] iommu: Implement IOMMU core liveupdate skeleton
From: Samiullah Khawaja <skhawaja@google.com>
To: David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Samiullah Khawaja <skhawaja@google.com>, Robin Murphy <robin.murphy@arm.com>, 
	Kevin Tian <kevin.tian@intel.com>, Alex Williamson <alex@shazbot.org>, Shuah Khan <shuah@kernel.org>, 
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Saeed Mahameed <saeedm@nvidia.com>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Parav Pandit <parav@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>, William Tu <witu@nvidia.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	David Matlack <dmatlack@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Pranjal Shrivastava <praan@google.com>, Vipin Sharma <vipinsh@google.com>, 
	YiFei Zhu <zhuyifei@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70095-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[26];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[skhawaja@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D8514DF1AA
X-Rspamd-Action: no action

Add IOMMU domain ops that can be implemented by the IOMMU drivers if
they support IOMMU domain preservation across liveupdate. The new IOMMU
domain preserve, unpreserve and restore APIs call these ops to perform
respective live update operations.

Similarly add IOMMU ops to preserve/unpreserve a device. These can be
implemented by the IOMMU drivers that support preservation of devices
that have their IOMMU domains preserved. During device preservation the
state of the associated IOMMU is also preserved. The device can only be
preserved if the attached iommu domain is preserved and the associated
iommu supports preservation.

The preserved state of the device and IOMMU needs to be fetched during
shutdown and boot in the next kernel. Add APIs that can be used to fetch
the preserved state of a device and IOMMU. The APIs will only be used
during shutdown and after liveupdate so no locking needed.

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 drivers/iommu/iommu.c      |   3 +
 drivers/iommu/liveupdate.c | 326 +++++++++++++++++++++++++++++++++++++
 include/linux/iommu-lu.h   | 119 ++++++++++++++
 include/linux/iommu.h      |  32 ++++
 4 files changed, 480 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 4926a43118e6..c0632cb5b570 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -389,6 +389,9 @@ static struct dev_iommu *dev_iommu_get(struct device *dev)
 
 	mutex_init(&param->lock);
 	dev->iommu = param;
+#ifdef CONFIG_IOMMU_LIVEUPDATE
+	dev->iommu->device_ser = NULL;
+#endif
 	return param;
 }
 
diff --git a/drivers/iommu/liveupdate.c b/drivers/iommu/liveupdate.c
index 6189ba32ff2c..83eb609b3fd7 100644
--- a/drivers/iommu/liveupdate.c
+++ b/drivers/iommu/liveupdate.c
@@ -11,6 +11,7 @@
 #include <linux/liveupdate.h>
 #include <linux/iommu-lu.h>
 #include <linux/iommu.h>
+#include <linux/pci.h>
 #include <linux/errno.h>
 
 static void iommu_liveupdate_restore_objs(u64 next)
@@ -175,3 +176,328 @@ int iommu_liveupdate_unregister_flb(struct liveupdate_file_handler *handler)
 	return liveupdate_unregister_flb(handler, &iommu_flb);
 }
 EXPORT_SYMBOL(iommu_liveupdate_unregister_flb);
+
+int iommu_for_each_preserved_device(iommu_preserved_device_iter_fn fn,
+				    void *arg)
+{
+	struct iommu_lu_flb_obj *obj;
+	struct devices_ser *devices;
+	int ret, i, idx;
+
+	ret = liveupdate_flb_get_incoming(&iommu_flb, (void **)&obj);
+	if (ret)
+		return -ENOENT;
+
+	devices = __va(obj->ser->devices_phys);
+	for (i = 0, idx = 0; i < obj->ser->nr_devices; ++i, ++idx) {
+		if (idx >= MAX_DEVICE_SERS) {
+			devices = __va(devices->objs.next_objs);
+			idx = 0;
+		}
+
+		if (devices->devices[idx].obj.deleted)
+			continue;
+
+		ret = fn(&devices->devices[idx], arg);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(iommu_for_each_preserved_device);
+
+static inline bool device_ser_match(struct device_ser *match,
+				    struct pci_dev *pdev)
+{
+	return match->devid == pci_dev_id(pdev) && match->pci_domain == pci_domain_nr(pdev->bus);
+}
+
+struct device_ser *iommu_get_device_preserved_data(struct device *dev)
+{
+	struct iommu_lu_flb_obj *obj;
+	struct devices_ser *devices;
+	int ret, i, idx;
+
+	if (!dev_is_pci(dev))
+		return NULL;
+
+	ret = liveupdate_flb_get_incoming(&iommu_flb, (void **)&obj);
+	if (ret)
+		return NULL;
+
+	devices = __va(obj->ser->devices_phys);
+	for (i = 0, idx = 0; i < obj->ser->nr_devices; ++i, ++idx) {
+		if (idx >= MAX_DEVICE_SERS) {
+			devices = __va(devices->objs.next_objs);
+			idx = 0;
+		}
+
+		if (devices->devices[idx].obj.deleted)
+			continue;
+
+		if (device_ser_match(&devices->devices[idx], to_pci_dev(dev))) {
+			devices->devices[idx].obj.incoming = true;
+			return &devices->devices[idx];
+		}
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL(iommu_get_device_preserved_data);
+
+struct iommu_ser *iommu_get_preserved_data(u64 token, enum iommu_lu_type type)
+{
+	struct iommu_lu_flb_obj *obj;
+	struct iommus_ser *iommus;
+	int ret, i, idx;
+
+	ret = liveupdate_flb_get_incoming(&iommu_flb, (void **)&obj);
+	if (ret)
+		return NULL;
+
+	iommus = __va(obj->ser->iommus_phys);
+	for (i = 0, idx = 0; i < obj->ser->nr_iommus; ++i, ++idx) {
+		if (idx >= MAX_IOMMU_SERS) {
+			iommus = __va(iommus->objs.next_objs);
+			idx = 0;
+		}
+
+		if (iommus->iommus[idx].obj.deleted)
+			continue;
+
+		if (iommus->iommus[idx].token == token &&
+		    iommus->iommus[idx].type == type)
+			return &iommus->iommus[idx];
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL(iommu_get_preserved_data);
+
+static int reserve_obj_ser(struct iommu_objs_ser **objs_ptr, u64 max_objs)
+{
+	struct iommu_objs_ser *next_objs, *objs = *objs_ptr;
+	int idx;
+
+	if (objs->nr_objs == max_objs) {
+		next_objs = kho_alloc_preserve(PAGE_SIZE);
+		if (IS_ERR(next_objs))
+			return PTR_ERR(next_objs);
+
+		objs->next_objs = virt_to_phys(next_objs);
+		objs = next_objs;
+		*objs_ptr = objs;
+		objs->nr_objs = 0;
+		objs->next_objs = 0;
+	}
+
+	idx = objs->nr_objs++;
+	return idx;
+}
+
+int iommu_domain_preserve(struct iommu_domain *domain, struct iommu_domain_ser **ser)
+{
+	struct iommu_domain_ser *domain_ser;
+	struct iommu_lu_flb_obj *flb_obj;
+	int idx, ret;
+
+	if (!domain->ops->preserve)
+		return -EOPNOTSUPP;
+
+	ret = liveupdate_flb_get_outgoing(&iommu_flb, (void **)&flb_obj);
+	if (ret)
+		return ret;
+
+	guard(mutex)(&flb_obj->lock);
+	idx = reserve_obj_ser((struct iommu_objs_ser **)&flb_obj->iommu_domains,
+			      MAX_IOMMU_DOMAIN_SERS);
+	if (idx < 0)
+		return idx;
+
+	domain_ser = &flb_obj->iommu_domains->iommu_domains[idx];
+	idx = flb_obj->ser->nr_domains++;
+	domain_ser->obj.idx = idx;
+	domain_ser->obj.ref_count = 1;
+
+	ret = domain->ops->preserve(domain, domain_ser);
+	if (ret) {
+		domain_ser->obj.deleted = true;
+		return ret;
+	}
+
+	domain->preserved_state = domain_ser;
+	*ser = domain_ser;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(iommu_domain_preserve);
+
+void iommu_domain_unpreserve(struct iommu_domain *domain)
+{
+	struct iommu_domain_ser *domain_ser;
+	struct iommu_lu_flb_obj *flb_obj;
+	int ret;
+
+	if (!domain->ops->unpreserve)
+		return;
+
+	ret = liveupdate_flb_get_outgoing(&iommu_flb, (void **)&flb_obj);
+	if (ret)
+		return;
+
+	guard(mutex)(&flb_obj->lock);
+
+	/*
+	 * There is no check for attached devices here. The correctness relies
+	 * on the Live Update Orchestrator's session lifecycle. All resources
+	 * (iommufd, vfio devices) are preserved within a single session. If the
+	 * session is torn down, the .unpreserve callbacks for all files will be
+	 * invoked, ensuring a consistent cleanup without needing explicit
+	 * refcounting for the serialized objects here.
+	 */
+	domain_ser = domain->preserved_state;
+	domain->ops->unpreserve(domain, domain_ser);
+	domain_ser->obj.deleted = true;
+	domain->preserved_state = NULL;
+}
+EXPORT_SYMBOL_GPL(iommu_domain_unpreserve);
+
+static int iommu_preserve_locked(struct iommu_device *iommu)
+{
+	struct iommu_lu_flb_obj *flb_obj;
+	struct iommu_ser *iommu_ser;
+	int idx, ret;
+
+	if (!iommu->ops->preserve)
+		return -EOPNOTSUPP;
+
+	if (iommu->outgoing_preserved_state) {
+		iommu->outgoing_preserved_state->obj.ref_count++;
+		return 0;
+	}
+
+	ret = liveupdate_flb_get_outgoing(&iommu_flb, (void **)&flb_obj);
+	if (ret)
+		return ret;
+
+	idx = reserve_obj_ser((struct iommu_objs_ser **)&flb_obj->iommus,
+			      MAX_IOMMU_SERS);
+	if (idx < 0)
+		return idx;
+
+	iommu_ser = &flb_obj->iommus->iommus[idx];
+	idx = flb_obj->ser->nr_iommus++;
+	iommu_ser->obj.idx = idx;
+	iommu_ser->obj.ref_count = 1;
+
+	ret = iommu->ops->preserve(iommu, iommu_ser);
+	if (ret)
+		iommu_ser->obj.deleted = true;
+
+	iommu->outgoing_preserved_state = iommu_ser;
+	return ret;
+}
+
+static void iommu_unpreserve_locked(struct iommu_device *iommu)
+{
+	struct iommu_ser *iommu_ser = iommu->outgoing_preserved_state;
+
+	iommu_ser->obj.ref_count--;
+	if (iommu_ser->obj.ref_count)
+		return;
+
+	iommu->outgoing_preserved_state = NULL;
+	iommu->ops->unpreserve(iommu, iommu_ser);
+	iommu_ser->obj.deleted = true;
+}
+
+int iommu_preserve_device(struct iommu_domain *domain,
+			  struct device *dev, u64 token)
+{
+	struct iommu_lu_flb_obj *flb_obj;
+	struct device_ser *device_ser;
+	struct dev_iommu *iommu;
+	struct pci_dev *pdev;
+	int ret, idx;
+
+	if (!dev_is_pci(dev))
+		return -EOPNOTSUPP;
+
+	if (!domain->preserved_state)
+		return -EINVAL;
+
+	pdev = to_pci_dev(dev);
+	iommu = dev->iommu;
+	if (!iommu->iommu_dev->ops->preserve_device ||
+	    !iommu->iommu_dev->ops->preserve)
+		return -EOPNOTSUPP;
+
+	ret = liveupdate_flb_get_outgoing(&iommu_flb, (void **)&flb_obj);
+	if (ret)
+		return ret;
+
+	guard(mutex)(&flb_obj->lock);
+	idx = reserve_obj_ser((struct iommu_objs_ser **)&flb_obj->devices,
+			      MAX_DEVICE_SERS);
+	if (idx < 0)
+		return idx;
+
+	device_ser = &flb_obj->devices->devices[idx];
+	idx = flb_obj->ser->nr_devices++;
+	device_ser->obj.idx = idx;
+	device_ser->obj.ref_count = 1;
+
+	ret = iommu_preserve_locked(iommu->iommu_dev);
+	if (ret) {
+		device_ser->obj.deleted = true;
+		return ret;
+	}
+
+	device_ser->domain_iommu_ser.domain_phys = __pa(domain->preserved_state);
+	device_ser->domain_iommu_ser.iommu_phys = __pa(iommu->iommu_dev->outgoing_preserved_state);
+	device_ser->devid = pci_dev_id(pdev);
+	device_ser->pci_domain = pci_domain_nr(pdev->bus);
+	device_ser->token = token;
+
+	ret = iommu->iommu_dev->ops->preserve_device(dev, device_ser);
+	if (ret) {
+		device_ser->obj.deleted = true;
+		iommu_unpreserve_locked(iommu->iommu_dev);
+		return ret;
+	}
+
+	dev->iommu->device_ser = device_ser;
+	return 0;
+}
+
+void iommu_unpreserve_device(struct iommu_domain *domain, struct device *dev)
+{
+	struct iommu_lu_flb_obj *flb_obj;
+	struct device_ser *device_ser;
+	struct dev_iommu *iommu;
+	struct pci_dev *pdev;
+	int ret;
+
+	if (!dev_is_pci(dev))
+		return;
+
+	pdev = to_pci_dev(dev);
+	iommu = dev->iommu;
+	if (!iommu->iommu_dev->ops->unpreserve_device ||
+	    !iommu->iommu_dev->ops->unpreserve)
+		return;
+
+	ret = liveupdate_flb_get_outgoing(&iommu_flb, (void **)&flb_obj);
+	if (WARN_ON(ret))
+		return;
+
+	guard(mutex)(&flb_obj->lock);
+	device_ser = dev_iommu_preserved_state(dev);
+	if (WARN_ON(!device_ser))
+		return;
+
+	iommu->iommu_dev->ops->unpreserve_device(dev, device_ser);
+	dev->iommu->device_ser = NULL;
+
+	iommu_unpreserve_locked(iommu->iommu_dev);
+}
diff --git a/include/linux/iommu-lu.h b/include/linux/iommu-lu.h
index 59095d2f1bb2..48c07514a776 100644
--- a/include/linux/iommu-lu.h
+++ b/include/linux/iommu-lu.h
@@ -8,9 +8,128 @@
 #ifndef _LINUX_IOMMU_LU_H
 #define _LINUX_IOMMU_LU_H
 
+#include <linux/device.h>
+#include <linux/iommu.h>
 #include <linux/liveupdate.h>
 #include <linux/kho/abi/iommu.h>
 
+typedef int (*iommu_preserved_device_iter_fn)(struct device_ser *ser,
+					      void *arg);
+#ifdef CONFIG_IOMMU_LIVEUPDATE
+static inline void *dev_iommu_preserved_state(struct device *dev)
+{
+	struct device_ser *ser;
+
+	if (!dev->iommu)
+		return NULL;
+
+	ser = dev->iommu->device_ser;
+	if (ser && !ser->obj.incoming)
+		return ser;
+
+	return NULL;
+}
+
+static inline void *dev_iommu_restored_state(struct device *dev)
+{
+	struct device_ser *ser;
+
+	if (!dev->iommu)
+		return NULL;
+
+	ser = dev->iommu->device_ser;
+	if (ser && ser->obj.incoming)
+		return ser;
+
+	return NULL;
+}
+
+static inline void *iommu_domain_restored_state(struct iommu_domain *domain)
+{
+	struct iommu_domain_ser *ser;
+
+	ser = domain->preserved_state;
+	if (ser && ser->obj.incoming)
+		return ser;
+
+	return NULL;
+}
+
+static inline int dev_iommu_restore_did(struct device *dev, struct iommu_domain *domain)
+{
+	struct device_ser *ser = dev_iommu_restored_state(dev);
+
+	if (ser && iommu_domain_restored_state(domain))
+		return ser->domain_iommu_ser.did;
+
+	return -1;
+}
+
+int iommu_for_each_preserved_device(iommu_preserved_device_iter_fn fn,
+				    void *arg);
+struct device_ser *iommu_get_device_preserved_data(struct device *dev);
+struct iommu_ser *iommu_get_preserved_data(u64 token, enum iommu_lu_type type);
+int iommu_domain_preserve(struct iommu_domain *domain, struct iommu_domain_ser **ser);
+void iommu_domain_unpreserve(struct iommu_domain *domain);
+int iommu_preserve_device(struct iommu_domain *domain,
+			  struct device *dev, u64 token);
+void iommu_unpreserve_device(struct iommu_domain *domain, struct device *dev);
+#else
+static inline void *dev_iommu_preserved_state(struct device *dev)
+{
+	return NULL;
+}
+
+static inline void *dev_iommu_restored_state(struct device *dev)
+{
+	return NULL;
+}
+
+static inline int dev_iommu_restore_did(struct device *dev, struct iommu_domain *domain)
+{
+	return -1;
+}
+
+static inline void *iommu_domain_restored_state(struct iommu_domain *domain)
+{
+	return NULL;
+}
+
+static inline int iommu_for_each_preserved_device(iommu_preserved_device_iter_fn fn, void *arg)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline struct device_ser *iommu_get_device_preserved_data(struct device *dev)
+{
+	return NULL;
+}
+
+static inline struct iommu_ser *iommu_get_preserved_data(u64 token, enum iommu_lu_type type)
+{
+	return NULL;
+}
+
+static inline int iommu_domain_preserve(struct iommu_domain *domain, struct iommu_domain_ser **ser)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void iommu_domain_unpreserve(struct iommu_domain *domain)
+{
+}
+
+static inline int iommu_preserve_device(struct iommu_domain *domain,
+					struct device *dev, u64 token)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void iommu_unpreserve_device(struct iommu_domain *domain, struct device *dev)
+{
+}
+#endif
+
 int iommu_liveupdate_register_flb(struct liveupdate_file_handler *handler);
 int iommu_liveupdate_unregister_flb(struct liveupdate_file_handler *handler);
 
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 54b8b48c762e..bd949c1ce7c5 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -14,6 +14,8 @@
 #include <linux/err.h>
 #include <linux/of.h>
 #include <linux/iova_bitmap.h>
+#include <linux/atomic.h>
+#include <linux/kho/abi/iommu.h>
 #include <uapi/linux/iommufd.h>
 
 #define IOMMU_READ	(1 << 0)
@@ -248,6 +250,10 @@ struct iommu_domain {
 			struct list_head next;
 		};
 	};
+
+#ifdef CONFIG_IOMMU_LIVEUPDATE
+	struct iommu_domain_ser *preserved_state;
+#endif
 };
 
 static inline bool iommu_is_dma_domain(struct iommu_domain *domain)
@@ -647,6 +653,10 @@ __iommu_copy_struct_to_user(const struct iommu_user_data *dst_data,
  *               resources shared/passed to user space IOMMU instance. Associate
  *               it with a nesting @parent_domain. It is required for driver to
  *               set @viommu->ops pointing to its own viommu_ops
+ * @preserve_device: Preserve state of a device for liveupdate.
+ * @unpreserve_device: Unpreserve state that was preserved earlier.
+ * @preserve: Preserve state of iommu translation hardware for liveupdate.
+ * @unpreserve: Unpreserve state of iommu that was preserved earlier.
  * @owner: Driver module providing these ops
  * @identity_domain: An always available, always attachable identity
  *                   translation.
@@ -703,6 +713,11 @@ struct iommu_ops {
 			   struct iommu_domain *parent_domain,
 			   const struct iommu_user_data *user_data);
 
+	int (*preserve_device)(struct device *dev, struct device_ser *device_ser);
+	void (*unpreserve_device)(struct device *dev, struct device_ser *device_ser);
+	int (*preserve)(struct iommu_device *iommu, struct iommu_ser *iommu_ser);
+	void (*unpreserve)(struct iommu_device *iommu, struct iommu_ser *iommu_ser);
+
 	const struct iommu_domain_ops *default_domain_ops;
 	struct module *owner;
 	struct iommu_domain *identity_domain;
@@ -749,6 +764,11 @@ struct iommu_ops {
  *                           specific mechanisms.
  * @set_pgtable_quirks: Set io page table quirks (IO_PGTABLE_QUIRK_*)
  * @free: Release the domain after use.
+ * @preserve: Preserve the iommu domain for liveupdate.
+ *            Returns 0 on success, a negative errno on failure.
+ * @unpreserve: Unpreserve the iommu domain that was preserved earlier.
+ * @restore: Restore the iommu domain after liveupdate.
+ *           Returns 0 on success, a negative errno on failure.
  */
 struct iommu_domain_ops {
 	int (*attach_dev)(struct iommu_domain *domain, struct device *dev,
@@ -779,6 +799,9 @@ struct iommu_domain_ops {
 				  unsigned long quirks);
 
 	void (*free)(struct iommu_domain *domain);
+	int (*preserve)(struct iommu_domain *domain, struct iommu_domain_ser *ser);
+	void (*unpreserve)(struct iommu_domain *domain, struct iommu_domain_ser *ser);
+	int (*restore)(struct iommu_domain *domain, struct iommu_domain_ser *ser);
 };
 
 /**
@@ -790,6 +813,8 @@ struct iommu_domain_ops {
  * @singleton_group: Used internally for drivers that have only one group
  * @max_pasids: number of supported PASIDs
  * @ready: set once iommu_device_register() has completed successfully
+ * @outgoing_preserved_state: preserved iommu state of outgoing kernel for
+ * liveupdate.
  */
 struct iommu_device {
 	struct list_head list;
@@ -799,6 +824,10 @@ struct iommu_device {
 	struct iommu_group *singleton_group;
 	u32 max_pasids;
 	bool ready;
+
+#ifdef CONFIG_IOMMU_LIVEUPDATE
+	struct iommu_ser *outgoing_preserved_state;
+#endif
 };
 
 /**
@@ -853,6 +882,9 @@ struct dev_iommu {
 	u32				pci_32bit_workaround:1;
 	u32				require_direct:1;
 	u32				shadow_on_flush:1;
+#ifdef CONFIG_IOMMU_LIVEUPDATE
+	struct device_ser		*device_ser;
+#endif
 };
 
 int iommu_device_register(struct iommu_device *iommu,
-- 
2.53.0.rc2.204.g2597b5adb4-goog


