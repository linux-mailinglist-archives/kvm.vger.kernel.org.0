Return-Path: <kvm+bounces-71538-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aLb9H73UnGkJLAQAu9opvQ
	(envelope-from <kvm+bounces-71538-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 23:29:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3065717E5AC
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 23:29:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id F3F12302DA87
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 22:29:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3559537B3EC;
	Mon, 23 Feb 2026 22:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QrgUXPz7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27F337A49F
	for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 22:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771885750; cv=none; b=TWYjQlbfIZHi7EAF5sI8V01GYghqN/GVmYL/JdHllSpdO+60AoS7RPFa1S4xFHKiN1hq8URZNYUi0GguzOXqeJ0f7faqn8/nls2N2TTN1/iNJrAIhAE/RoDbVOmGlPyP7pNongGRLDd1dOulgNt1lU9UZSMcrO8JpuBTThg9gYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771885750; c=relaxed/simple;
	bh=zp/3mJbTXt9chphlhOhh0vUdkxG2FImWipP7I3QMw/Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lykPpXj08YJn9Ua+43BBJDkwPyDr2ASWbRJ0iz0RI1a5x2waHVRdpdi0unyHJP646/ryFQSXpknM3yDI9Ua7htwWEpcPpXsX3zY/M3kQ1EjaXj8xQRoPWG7ZPfAyy/BvZ/sqTDHrjGZeFLvoBWU+7OXhRbdxJK4dE0AJ4nvdDho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QrgUXPz7; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2a76b39587aso30035ad.0
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 14:29:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771885748; x=1772490548; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=C8f6dXcdZJeSJ2qE0ghvpNFkqtAaZ6dotEKElaryP78=;
        b=QrgUXPz741VrxDq8WoLm7VwcZOPYdwuw9NPWaoJQwKuTj+rMZIRiSPJ/68B9D3sdwz
         Drupo6zRkkPKrrRQ6Hyebke+klAG1bt/jFS/FIDJtqrbQqTLZzZhzAro7uOVEVnuiGVD
         fpOc3uskGjeFmQnz86lieR6tH+FiYP4pFp4p8GvU/MMS52lzoMdX24aibNM4j5AKD9TK
         a+08bLx5ST8Aee3Jb+joi4LqL4POr6ZM0T+bRBzy+QC7m4OX1lNIHwDTFbMXMiM2/T6b
         fNFA3JJxRR/GK9135wfa9Xe6tPQH0A+Dnl3yMVxKYyGmXNZAfROEynaUNqFNl+ZNt9z/
         WsMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771885748; x=1772490548;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C8f6dXcdZJeSJ2qE0ghvpNFkqtAaZ6dotEKElaryP78=;
        b=F7xQDwevTH/lu1p12TeQQWP5FQ1hXP5+e5uVIc1Hz0PL8dGF//CptWwG+cI0aUWlPP
         3blUBswdfTku1Zf2hMSdv1eMdBBGyaGKhpoq+pGX/TM9GhJMt5BQpK5evwatH7fpVH5b
         jDY88TT3Ldh0c3XplwqFUuwjCFzXOEEML2v+xfXChHw12dpfThjIAhzPLg4AtZL4rmbr
         I8lqryzl0gdANPfawwnTZljON1DeZj0WPTH7DCvsw8LhHZPgO6ez69ZU3frIs4A7L6C3
         cvKJksFCdGIRLDoHB3Kh/GqZdbJQw1051kcIbNqp/wKuSmDappIiy2mTMr/5MC69fUyh
         covQ==
X-Forwarded-Encrypted: i=1; AJvYcCXtpvC7KP54B/V4D91cznv+U5CaTFQBnHIA7NPSghxu8yWP0DkkmtIaDdGnmbNG2S6jMMo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7Bb9i9cpQDUs0mGldY4izKNwvZOVJMsk++K8DAm3WaBb80pN6
	mHeGqDwa5WxCOPH+11lPNwmU0b13vDwfQSYSQ2Tw1sS2BuBp4Z60CH1RB3C9mMV29g==
X-Gm-Gg: ATEYQzzhagSyZ3tr8BxuFGndEIABZPhSQAMvV/LqsiXrsC4ao6XLifGksIH29tPPDWv
	TuYiRqwBhSCmsj1KG/a8bTMjWg8f5KWXplmGoIgkHHLoz78hNZXT+gGfHSwMZsJqfhW/6UV4lqF
	BAiNEZ7ZVfmiSYHsihsxhsrlgg2iBN2IccTtfsI0QORLFiItxWIZ5AZFcW9zKvX9puB0ne4Yy1Z
	ekoB3G+1RKNSbqZaYuQPSbVgaPJXxrKb0iuDlT9JA4XFnIyW8Q+kfohqQHJGMLNfVHeseAx2MI9
	FHypw6DfDKWYENJ3A5BFeNCkFcW6KVXlDCyaDZLL2a0S3dPOTYHFG8qc9slw5xMioxfciVSqVU2
	997hDSRkppsQvnQinTcNsxPU2jZmBkZ+XiN19cflk4dfG3b8lgy4b9QOZT/zJWzL1wNnqa5XKzq
	hqyirijTRPdNipSulPkLfhWhvCo5o/lbRL0cSbd2pkVmosv+kJfJkL+0ph8gUBzQ==
X-Received: by 2002:a17:902:ec89:b0:2a9:5ef5:399b with SMTP id d9443c01a7336-2ada3497c30mr138295ad.19.1771885747713;
        Mon, 23 Feb 2026 14:29:07 -0800 (PST)
Received: from google.com (168.136.83.34.bc.googleusercontent.com. [34.83.136.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-826dd8ba11bsm8507152b3a.50.2026.02.23.14.29.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 14:29:07 -0800 (PST)
Date: Mon, 23 Feb 2026 22:29:03 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, 
	Alistair Popple <apopple@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankit Agrawal <ankita@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>, 
	Vipin Sharma <vipinsh@google.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 05/22] vfio/pci: Preserve vfio-pci device files across
 Live Update
Message-ID: <qshnqqtfg7clbcqoq45ei55wt6xt4z4xtwv5ehjyjxwq47cwng@n3vd3lxigcs6>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-6-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260129212510.967611-6-dmatlack@google.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71538-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[shazbot.org,nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[44];
	DKIM_TRACE(0.00)[google.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[skhawaja@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3065717E5AC
X-Rspamd-Action: no action

On Thu, Jan 29, 2026 at 09:24:52PM +0000, David Matlack wrote:
>From: Vipin Sharma <vipinsh@google.com>
>
>Implement the live update file handler callbacks to preserve a vfio-pci
>device across a Live Update. Subsequent commits will enable userspace to
>then retrieve this file after the Live Update.
>
>Live Update support is scoped only to cdev files (i.e. not
>VFIO_GROUP_GET_DEVICE_FD files).
>
>State about each device is serialized into a new ABI struct
>vfio_pci_core_device_ser. The contents of this struct are preserved
>across the Live Update to the next kernel using a combination of
>Kexec-Handover (KHO) to preserve the page(s) holding the struct and the
>Live Update Orchestrator (LUO) to preserve the physical address of the
>struct.
>
>For now the only contents of struct vfio_pci_core_device_ser the
>device's PCI segment number and BDF, so that the device can be uniquely
>identified after the Live Update.
>
>Require that userspace disables interrupts on the device prior to
>freeze() so that the device does not send any interrupts until new
>interrupt handlers have been set up by the next kernel.
>
>Reset the device and restore its state in the freeze() callback. This
>ensures the device can be received by the next kernel in a consistent
>state. Eventually this will be dropped and the device can be preserved
>across in a running state, but that requires further work in VFIO and
>the core PCI layer.
>
>Note that LUO holds a reference to this file when it is preserved. So
>VFIO is guaranteed that vfio_df_device_last_close() will not be called
>on this device no matter what userspace does.
>
>Signed-off-by: Vipin Sharma <vipinsh@google.com>
>Co-developed-by: David Matlack <dmatlack@google.com>
>Signed-off-by: David Matlack <dmatlack@google.com>
>---
> drivers/vfio/pci/vfio_pci.c            |  2 +-
> drivers/vfio/pci/vfio_pci_liveupdate.c | 84 +++++++++++++++++++++++++-
> drivers/vfio/pci/vfio_pci_priv.h       |  2 +
> drivers/vfio/vfio.h                    | 13 ----
> drivers/vfio/vfio_main.c               | 10 +--
> include/linux/kho/abi/vfio_pci.h       | 15 +++++
> include/linux/vfio.h                   | 28 +++++++++
> 7 files changed, 129 insertions(+), 25 deletions(-)
>
>diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
>index 19e88322af2c..0260afb9492d 100644
>--- a/drivers/vfio/pci/vfio_pci.c
>+++ b/drivers/vfio/pci/vfio_pci.c
>@@ -125,7 +125,7 @@ static int vfio_pci_open_device(struct vfio_device *core_vdev)
> 	return 0;
> }
>
>-static const struct vfio_device_ops vfio_pci_ops = {
>+const struct vfio_device_ops vfio_pci_ops = {
> 	.name		= "vfio-pci",
> 	.init		= vfio_pci_core_init_dev,
> 	.release	= vfio_pci_core_release_dev,
>diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
>index b84e63c0357b..f01de98f1b75 100644
>--- a/drivers/vfio/pci/vfio_pci_liveupdate.c
>+++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
>@@ -8,25 +8,104 @@
>
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>
>+#include <linux/kexec_handover.h>
> #include <linux/kho/abi/vfio_pci.h>
> #include <linux/liveupdate.h>
> #include <linux/errno.h>
>+#include <linux/vfio.h>
>
> #include "vfio_pci_priv.h"
>
> static bool vfio_pci_liveupdate_can_preserve(struct liveupdate_file_handler *handler,
> 					     struct file *file)
> {
>-	return false;
>+	struct vfio_device_file *df = to_vfio_device_file(file);
>+
>+	if (!df)
>+		return false;
>+
>+	/* Live Update support is limited to cdev files. */
>+	if (df->group)
>+		return false;
>+
>+	return df->device->ops == &vfio_pci_ops;
> }
>
> static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
> {
>-	return -EOPNOTSUPP;
>+	struct vfio_device *device = vfio_device_from_file(args->file);
>+	struct vfio_pci_core_device_ser *ser;
>+	struct vfio_pci_core_device *vdev;
>+	struct pci_dev *pdev;
>+
>+	vdev = container_of(device, struct vfio_pci_core_device, vdev);
>+	pdev = vdev->pdev;
>+
>+	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM))
>+		return -EINVAL;
>+
>+	if (vfio_pci_is_intel_display(pdev))
>+		return -EINVAL;
>+
>+	ser = kho_alloc_preserve(sizeof(*ser));
>+	if (IS_ERR(ser))
>+		return PTR_ERR(ser);
>+
>+	ser->bdf = pci_dev_id(pdev);
>+	ser->domain = pci_domain_nr(pdev->bus);
>+
>+	args->serialized_data = virt_to_phys(ser);
>+	return 0;
> }
>
> static void vfio_pci_liveupdate_unpreserve(struct liveupdate_file_op_args *args)
> {
>+	kho_unpreserve_free(phys_to_virt(args->serialized_data));
>+}
>+
>+static int vfio_pci_liveupdate_freeze(struct liveupdate_file_op_args *args)
>+{
>+	struct vfio_device *device = vfio_device_from_file(args->file);
>+	struct vfio_pci_core_device *vdev;
>+	struct pci_dev *pdev;
>+	int ret;
>+
>+	vdev = container_of(device, struct vfio_pci_core_device, vdev);
>+	pdev = vdev->pdev;
>+
>+	guard(mutex)(&device->dev_set->lock);
>+
>+	/*
>+	 * Userspace must disable interrupts on the device prior to freeze so
>+	 * that the device does not send any interrupts until new interrupt
>+	 * handlers have been established by the next kernel.
>+	 */
>+	if (vdev->irq_type != VFIO_PCI_NUM_IRQS) {
>+		pci_err(pdev, "Freeze failed! Interrupts are still enabled.\n");
>+		return -EINVAL;
>+	}
>+
>+	pci_dev_lock(pdev);
>+
>+	ret = pci_load_saved_state(pdev, vdev->pci_saved_state);
>+	if (ret)
>+		goto out;
>+
>+	/*
>+	 * Reset the device and restore it back to its original state before
>+	 * handing it to the next kernel.
>+	 *
>+	 * Eventually both of these should be dropped and the device should be
>+	 * kept running with its current state across the Live Update.
>+	 */
>+	if (vdev->reset_works)
>+		ret = __pci_reset_function_locked(pdev);
>+
>+	pci_restore_state(pdev);
>+
>+out:
>+	pci_dev_unlock(pdev);
>+	return ret;
> }
>
> static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
>@@ -42,6 +121,7 @@ static const struct liveupdate_file_ops vfio_pci_liveupdate_file_ops = {
> 	.can_preserve = vfio_pci_liveupdate_can_preserve,
> 	.preserve = vfio_pci_liveupdate_preserve,
> 	.unpreserve = vfio_pci_liveupdate_unpreserve,
>+	.freeze = vfio_pci_liveupdate_freeze,
> 	.retrieve = vfio_pci_liveupdate_retrieve,
> 	.finish = vfio_pci_liveupdate_finish,
> 	.owner = THIS_MODULE,
>diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
>index 68966ec64e51..d3da79b7b03c 100644
>--- a/drivers/vfio/pci/vfio_pci_priv.h
>+++ b/drivers/vfio/pci/vfio_pci_priv.h
>@@ -11,6 +11,8 @@
> /* Cap maximum number of ioeventfds per device (arbitrary) */
> #define VFIO_PCI_IOEVENTFD_MAX		1000
>
>+extern const struct vfio_device_ops vfio_pci_ops;
>+
> struct vfio_pci_ioeventfd {
> 	struct list_head	next;
> 	struct vfio_pci_core_device	*vdev;
>diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
>index 50128da18bca..6b89edbbf174 100644
>--- a/drivers/vfio/vfio.h
>+++ b/drivers/vfio/vfio.h
>@@ -16,17 +16,6 @@ struct iommufd_ctx;
> struct iommu_group;
> struct vfio_container;
>
>-struct vfio_device_file {
>-	struct vfio_device *device;
>-	struct vfio_group *group;
>-
>-	u8 access_granted;
>-	u32 devid; /* only valid when iommufd is valid */
>-	spinlock_t kvm_ref_lock; /* protect kvm field */
>-	struct kvm *kvm;
>-	struct iommufd_ctx *iommufd; /* protected by struct vfio_device_set::lock */
>-};
>-
> void vfio_device_put_registration(struct vfio_device *device);
> bool vfio_device_try_get_registration(struct vfio_device *device);
> int vfio_df_open(struct vfio_device_file *df);
>@@ -34,8 +23,6 @@ void vfio_df_close(struct vfio_device_file *df);
> struct vfio_device_file *
> vfio_allocate_device_file(struct vfio_device *device);
>
>-extern const struct file_operations vfio_device_fops;
>-
> #ifdef CONFIG_VFIO_NOIOMMU
> extern bool vfio_noiommu __read_mostly;
> #else
>diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
>index f7df90c423b4..276f615f0c28 100644
>--- a/drivers/vfio/vfio_main.c
>+++ b/drivers/vfio/vfio_main.c
>@@ -1436,15 +1436,7 @@ const struct file_operations vfio_device_fops = {
> 	.show_fdinfo	= vfio_device_show_fdinfo,
> #endif
> };
>-
>-static struct vfio_device *vfio_device_from_file(struct file *file)
>-{
>-	struct vfio_device_file *df = file->private_data;
>-
>-	if (file->f_op != &vfio_device_fops)
>-		return NULL;
>-	return df->device;
>-}
>+EXPORT_SYMBOL_GPL(vfio_device_fops);
>
> /**
>  * vfio_file_is_valid - True if the file is valid vfio file
>diff --git a/include/linux/kho/abi/vfio_pci.h b/include/linux/kho/abi/vfio_pci.h
>index 37a845eed972..9bf58a2f3820 100644
>--- a/include/linux/kho/abi/vfio_pci.h
>+++ b/include/linux/kho/abi/vfio_pci.h
>@@ -9,6 +9,9 @@
> #ifndef _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H
> #define _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H
>
>+#include <linux/compiler.h>
>+#include <linux/types.h>
>+
> /**
>  * DOC: VFIO PCI Live Update ABI
>  *
>@@ -25,4 +28,16 @@
>
> #define VFIO_PCI_LUO_FH_COMPATIBLE "vfio-pci-v1"
>
>+/**
>+ * struct vfio_pci_core_device_ser - Serialized state of a single VFIO PCI
>+ * device.
>+ *
>+ * @bdf: The device's PCI bus, device, and function number.
>+ * @domain: The device's PCI domain number (segment).
>+ */
>+struct vfio_pci_core_device_ser {
>+	u16 bdf;
>+	u16 domain;
>+} __packed;
>+
> #endif /* _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H */
>diff --git a/include/linux/vfio.h b/include/linux/vfio.h
>index e90859956514..9aa1587fea19 100644
>--- a/include/linux/vfio.h
>+++ b/include/linux/vfio.h
>@@ -81,6 +81,34 @@ struct vfio_device {
> #endif
> };
>
>+struct vfio_device_file {
>+	struct vfio_device *device;
>+	struct vfio_group *group;
>+
>+	u8 access_granted;
>+	u32 devid; /* only valid when iommufd is valid */
>+	spinlock_t kvm_ref_lock; /* protect kvm field */
>+	struct kvm *kvm;
>+	struct iommufd_ctx *iommufd; /* protected by struct vfio_device_set::lock */
>+};
>+
>+extern const struct file_operations vfio_device_fops;
>+
>+static inline struct vfio_device_file *to_vfio_device_file(struct file *file)
>+{
>+	if (file->f_op != &vfio_device_fops)
>+		return NULL;
>+
>+	return file->private_data;
>+}
>+
>+static inline struct vfio_device *vfio_device_from_file(struct file *file)
>+{
>+	struct vfio_device_file *df = to_vfio_device_file(file);
>+
>+	return df ? df->device : NULL;
>+}
>+
> /**
>  * struct vfio_device_ops - VFIO bus driver device callbacks
>  *
>-- 
>2.53.0.rc1.225.gd81095ad13-goog
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>

