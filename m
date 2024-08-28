Return-Path: <kvm+bounces-25263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BBF5962B11
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 17:04:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 94CAEB24725
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 15:04:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D2D2189BAA;
	Wed, 28 Aug 2024 15:04:19 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF1A1A2554;
	Wed, 28 Aug 2024 15:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724857458; cv=none; b=j5quXJGC02VDm6RQ3/I78nEGWmRJthbCV3+XUu6M/sATWs5Kg5RXvKSEsRQ4rh2V2xbe4lXCJ/bzlIjb3DWEEnDdNnSNiPcTuOlqsfb+8xGfmnHGt0alq7stlJ27YyNvtRnfFItmNBeUMPHWjlL7F4V7I3Mb6oPR6SB7AgwjtCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724857458; c=relaxed/simple;
	bh=iSt6hRvf7mUc+tQgIeMMAEq9LXEcO6VQ4JqYp5VpW/M=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SVZVfAlAXxaxycaLUWgkj+t3Zzf/n3GvU/XUz7U3p0vnLAb8Gc5K1bAaKfYkwh9TG77J0vc5L2CDJxs1eqTdP5ePEdfAFqUriQiCUOkyp7mlTs2Q91WXD24rxpNeGI7mNnsoUrHdHdzsusfphnbumSPt0PZ5s6/8lbZhzsdN9hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Wv6yz1ch0z6FH1Z;
	Wed, 28 Aug 2024 23:00:11 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id E0C4F14038F;
	Wed, 28 Aug 2024 23:04:12 +0800 (CST)
Received: from localhost (10.203.177.66) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 28 Aug
 2024 16:04:12 +0100
Date: Wed, 28 Aug 2024 16:04:11 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Alexey Kardashevskiy <aik@amd.com>
CC: <kvm@vger.kernel.org>, <iommu@lists.linux.dev>,
	<linux-coco@lists.linux.dev>, <linux-pci@vger.kernel.org>, "Suravee
 Suthikulpanit" <suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, Dan Williams <dan.j.williams@intel.com>,
	<pratikrajesh.sampat@amd.com>, <michael.day@amd.com>, <david.kaplan@amd.com>,
	<dhaval.giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, "Michael Roth" <michael.roth@amd.com>, Alexander
 Graf <agraf@suse.de>, "Nikunj A Dadhania" <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, "Lukas Wunner" <lukas@wunner.de>
Subject: Re: [RFC PATCH 07/21] pci/tdisp: Introduce tsm module
Message-ID: <20240828160411.00002f93@Huawei.com>
In-Reply-To: <20240823132137.336874-8-aik@amd.com>
References: <20240823132137.336874-1-aik@amd.com>
	<20240823132137.336874-8-aik@amd.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500001.china.huawei.com (7.191.163.213) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

On Fri, 23 Aug 2024 23:21:21 +1000
Alexey Kardashevskiy <aik@amd.com> wrote:

> The module responsibilities are:
> 1. detect TEE support in a device and create nodes in the device's sysfs
> entry;
> 2. allow binding a PCI device to a VM for passing it through in a trusted
> manner;
> 3. store measurements/certificates/reports and provide access to those for
> the userspace via sysfs.
> 
> This relies on the platform to register a set of callbacks,
> for both host and guest.
> 
> And tdi_enabled in the device struct.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>



Main thing missing here is a sysfs ABI doc.

Otherwise, some random comments as I get my head around it.

Jonathan


> diff --git a/include/linux/tsm.h b/include/linux/tsm.h
> new file mode 100644
> index 000000000000..d48eceaf5bc0
> --- /dev/null
> +++ b/include/linux/tsm.h
> @@ -0,0 +1,263 @@
...


> +/* Physical device descriptor responsible for IDE/TDISP setup */
> +struct tsm_dev {
> +	struct kref kref;
> +	const struct attribute_group *ag;
> +	struct pci_dev *pdev; /* Physical PCI function #0 */
> +	struct tsm_spdm spdm;
> +	struct mutex spdm_mutex;

Kind of obvious, but still good to document what data this is protecting.

> +
> +	u8 tc_mask;
> +	u8 cert_slot;
> +	u8 connected;
> +	struct {
> +		u8 enabled:1;
> +		u8 enable:1;
> +		u8 def:1;
> +		u8 dev_ide_cfg:1;
> +		u8 dev_tee_limited:1;
> +		u8 rootport_ide_cfg:1;
> +		u8 rootport_tee_limited:1;
> +		u8 id;
> +	} selective_ide[256];
> +	bool ide_pre;
> +
> +	struct tsm_blob *meas;
> +	struct tsm_blob *certs;
> +
> +	void *data; /* Platform specific data */
> +};
> +

> diff --git a/drivers/virt/coco/tsm.c b/drivers/virt/coco/tsm.c
> new file mode 100644
> index 000000000000..e90455a0267f
> --- /dev/null
> +++ b/drivers/virt/coco/tsm.c
...

>
> +struct tsm_tdi *tsm_tdi_get(struct device *dev)
> +{
> +	struct tsm_tdi *tdi = dev->tdi;
> +
> +	return tdi;
	return dev->tdi;
seems fine to me.

> +}
> +EXPORT_SYMBOL_GPL(tsm_tdi_get);
> +
> +static int spdm_forward(struct tsm_spdm *spdm, u8 type)
> +{
> +	struct pci_doe_mb *doe_mb;
> +	int rc;
> +
> +	if (type == PCI_DOE_PROTOCOL_SECURED_CMA_SPDM)
> +		doe_mb = spdm->doe_mb_secured;
> +	else if (type == PCI_DOE_PROTOCOL_CMA_SPDM)
> +		doe_mb = spdm->doe_mb;
> +	else
> +		return -EINVAL;
> +
> +	if (!doe_mb)
> +		return -EFAULT;
> +
> +	rc = pci_doe(doe_mb, PCI_VENDOR_ID_PCI_SIG, type,
> +		     spdm->req, spdm->req_len, spdm->rsp, spdm->rsp_len);
> +	if (rc >= 0)
	if (rc < 0)
		return rc;

	spdm->rsp_len = rc;
	
	return 0;

> +		spdm->rsp_len = rc;
> +
> +	return rc;
> +}
> +

> +
> +static int tsm_ide_refresh(struct tsm_dev *tdev, void *private_data)
> +{
> +	int ret;
> +
> +	if (!tsm.ops->ide_refresh)
> +		return -EPERM;
> +
> +	mutex_lock(&tdev->spdm_mutex);
guard() and early returns.

> +	while (1) {
> +		ret = tsm.ops->ide_refresh(tdev, private_data);
> +		if (ret <= 0)
> +			break;
> +
> +		ret = spdm_forward(&tdev->spdm, ret);
> +		if (ret < 0)
> +			break;
> +	}
> +	mutex_unlock(&tdev->spdm_mutex);
> +
> +	return ret;
> +}
> +
> +static void tsm_tdi_reclaim(struct tsm_tdi *tdi, void *private_data)
> +{
> +	int ret;
> +
> +	if (WARN_ON(!tsm.ops->tdi_reclaim))
> +		return;
> +
> +	mutex_lock(&tdi->tdev->spdm_mutex);
guard() and early returns.

> +	while (1) {
> +		ret = tsm.ops->tdi_reclaim(tdi, private_data);
> +		if (ret <= 0)
> +			break;
> +
> +		ret = spdm_forward(&tdi->tdev->spdm, ret);
> +		if (ret < 0)
> +			break;
> +	}
> +	mutex_unlock(&tdi->tdev->spdm_mutex);
> +}


> +static int tsm_tdi_status(struct tsm_tdi *tdi, void *private_data, struct tsm_tdi_status *ts)
> +{
> +	struct tsm_tdi_status tstmp = { 0 };
> +	int ret;
> +
> +	if (WARN_ON(!tsm.ops->tdi_status))
> +		return -EPERM;
> +
> +	mutex_lock(&tdi->tdev->spdm_mutex);
Perhaps scoped_guard() if it doesn't make sense to set *ts on error
(see below).
> +	while (1) {
> +		ret = tsm.ops->tdi_status(tdi, private_data, &tstmp);
> +		if (ret <= 0)
> +			break;
> +
> +		ret = spdm_forward(&tdi->tdev->spdm, ret);
> +		if (ret < 0)
> +			break;
> +	}
> +	mutex_unlock(&tdi->tdev->spdm_mutex);
> +
> +	*ts = tstmp;
Want to set this even on error?
> +
> +	return ret;
> +}


> +static ssize_t tsm_meas_show(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	struct tsm_dev *tdev = tsm_dev_get(dev);
> +	ssize_t n = 0;
> +
> +	if (!tdev->meas) {
> +		n = sysfs_emit(buf, "none\n");
> +	} else {
> +		if (!n)
Always true.

> +			n = tsm_meas_gen(tdev->meas, buf, PAGE_SIZE);
> +		if (!n)
> +			n = blob_show(tdev->meas, buf);
> +	}
> +
> +	tsm_dev_put(tdev);
> +	return n;
> +}
> +
> +static DEVICE_ATTR_RO(tsm_meas);

> +
> +static struct attribute *host_dev_attrs[] = {
> +	&dev_attr_tsm_cert_slot.attr,
> +	&dev_attr_tsm_tc_mask.attr,
> +	&dev_attr_tsm_dev_connect.attr,
> +	&dev_attr_tsm_sel_stream.attr,
> +	&dev_attr_tsm_ide_refresh.attr,
> +	&dev_attr_tsm_certs.attr,
> +	&dev_attr_tsm_meas.attr,
> +	&dev_attr_tsm_dev_status.attr,
> +	NULL,
That final comma not needed as we'll never add anything after
this.

> +};
> +static const struct attribute_group host_dev_group = {
> +	.attrs = host_dev_attrs,
> +};


> +
> +static ssize_t tsm_report_show(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	struct tsm_tdi *tdi = tsm_tdi_get(dev);
> +	ssize_t n = 0;
> +
> +	if (!tdi->report) {
> +		n = sysfs_emit(buf, "none\n");
> +	} else {
> +		if (!n)

Always true.

> +			n = tsm_report_gen(tdi->report, buf, PAGE_SIZE);
> +		if (!n)
> +			n = blob_show(tdi->report, buf);
> +	}
> +
> +	return n;

in all cases this is only set once and if set nothing else
happens. Just return directly at those.

> +}

> +static char *spdm_algos_to_str(u64 algos, char *buf, size_t len)
> +{
> +	size_t n = 0;
> +
> +	buf[0] = 0;
> +#define __ALGO(x) do {								\
> +		if ((n < len) && (algos & (1ULL << (TSM_TDI_SPDM_ALGOS_##x))))	\
> +			n += snprintf(buf + n, len - n, #x" ");			\
> +	} while (0)

Odd wrapping. I'd push the do { onto the next line and it will all look more normal.

> +
> +	__ALGO(DHE_SECP256R1);
> +	__ALGO(DHE_SECP384R1);
> +	__ALGO(AEAD_AES_128_GCM);
> +	__ALGO(AEAD_AES_256_GCM);
> +	__ALGO(ASYM_TPM_ALG_RSASSA_3072);
> +	__ALGO(ASYM_TPM_ALG_ECDSA_ECC_NIST_P256);
> +	__ALGO(ASYM_TPM_ALG_ECDSA_ECC_NIST_P384);
> +	__ALGO(HASH_TPM_ALG_SHA_256);
> +	__ALGO(HASH_TPM_ALG_SHA_384);
> +	__ALGO(KEY_SCHED_SPDM_KEY_SCHEDULE);
> +#undef __ALGO
> +	return buf;
> +}

> +
> +static ssize_t tsm_tdi_status_show(struct device *dev, struct device_attribute *attr, char *buf)
wrap
> +{

> +
> +static int tsm_tdi_init(struct tsm_dev *tdev, struct pci_dev *pdev)
> +{
> +	struct tsm_tdi *tdi;
> +	int ret = 0;
set in all paths that use it.

> +
> +	dev_info(&pdev->dev, "Initializing tdi\n");
> +	if (!tdev)
> +		return -ENODEV;
Is this defense needed?  Seems overkill given we just
got the tdev in all paths that lead here.

> +
> +	tdi = kzalloc(sizeof(*tdi), GFP_KERNEL);
> +	if (!tdi)
> +		return -ENOMEM;
> +
> +	/* tsm_dev_get() requires pdev->dev.tdi which is set later */
> +	if (!kref_get_unless_zero(&tdev->kref)) {
> +		ret = -EPERM;
> +		goto free_exit;
> +	}
> +
> +	if (tsm.ops->dev_connect)
> +		tdi->ag = &host_tdi_group;
> +	else
> +		tdi->ag = &guest_tdi_group;
> +
> +	ret = sysfs_create_link(&pdev->dev.kobj, &tdev->pdev->dev.kobj, "tsm_dev");
> +	if (ret)
> +		goto free_exit;
> +
> +	ret = device_add_group(&pdev->dev, tdi->ag);
> +	if (ret)
> +		goto sysfs_unlink_exit;
> +
> +	tdi->tdev = tdev;
> +	tdi->pdev = pci_dev_get(pdev);
> +
> +	pdev->dev.tdi_enabled = !pdev->is_physfn || tsm.physfn;
> +	pdev->dev.tdi = tdi;

As below, __free() + pointer steal will be neater here.

> +	pci_info(pdev, "TDI enabled=%d\n", pdev->dev.tdi_enabled);
> +
> +	return 0;
> +
> +sysfs_unlink_exit:
> +	sysfs_remove_link(&pdev->dev.kobj, "tsm_dev");
> +free_exit:
> +	kfree(tdi);
> +
> +	return ret;
> +}

> +static int tsm_dev_init(struct pci_dev *pdev, struct tsm_dev **ptdev)
> +{
> +	struct tsm_dev *tdev;
> +	int ret = 0;
> +
> +	dev_info(&pdev->dev, "Initializing tdev\n");

dev_dbg() for non RFC versions.

> +	tdev = kzalloc(sizeof(*tdev), GFP_KERNEL);
> +	if (!tdev)
> +		return -ENOMEM;
> +
> +	kref_init(&tdev->kref);
> +	tdev->tc_mask = tsm.tc_mask;
> +	tdev->cert_slot = tsm.cert_slot;
> +	tdev->pdev = pci_dev_get(pdev);
> +	mutex_init(&tdev->spdm_mutex);
> +
> +	if (tsm.ops->dev_connect)
> +		tdev->ag = &host_dev_group;
> +	else
> +		tdev->ag = &guest_dev_group;
> +
> +	ret = device_add_group(&pdev->dev, tdev->ag);
> +	if (ret)
> +		goto free_exit;
> +
> +	if (tsm.ops->dev_connect) {
> +		ret = -EPERM;
> +		tdev->pdev = pci_dev_get(pdev);
> +		tdev->spdm.doe_mb = pci_find_doe_mailbox(tdev->pdev,
> +							 PCI_VENDOR_ID_PCI_SIG,
> +							 PCI_DOE_PROTOCOL_CMA_SPDM);
> +		if (!tdev->spdm.doe_mb)
> +			goto pci_dev_put_exit;
Group not released
> +
> +		tdev->spdm.doe_mb_secured = pci_find_doe_mailbox(tdev->pdev,
> +								 PCI_VENDOR_ID_PCI_SIG,
> +								 PCI_DOE_PROTOCOL_SECURED_CMA_SPDM);
Long lines.  I'd wrap after =

> +		if (!tdev->spdm.doe_mb_secured)
> +			goto pci_dev_put_exit;
nor here.

> +	}
> +
> +	*ptdev = tdev;

Could use __free() magic for tdev and steal the ptr here.
Maybe not worth the effort though given you need the error block anyway.


> +	return 0;
> +
> +pci_dev_put_exit:
> +	pci_dev_put(pdev);
> +free_exit:
> +	kfree(tdev);
> +
> +	return ret;
> +}
> +
> +static void tsm_dev_free(struct kref *kref)
> +{
> +	struct tsm_dev *tdev = container_of(kref, struct tsm_dev, kref);
> +
> +	device_remove_group(&tdev->pdev->dev, tdev->ag);
> +
> +	if (tdev->connected)
> +		tsm_dev_reclaim(tdev, tsm.private_data);
> +
> +	dev_info(&tdev->pdev->dev, "Freeing TDEV\n");

dev_dbg() eventually but fine for RFC.

> +	pci_dev_put(tdev->pdev);
> +	kfree(tdev);
> +}
> +
> +static int tsm_alloc_device(struct pci_dev *pdev)
> +{
> +	int ret = 0;
> +
> +	/* It is guest VM == TVM */
> +	if (!tsm.ops->dev_connect) {
> +		if (pdev->devcap & PCI_EXP_DEVCAP_TEE_IO) {
> +			struct tsm_dev *tdev = NULL;
> +
> +			ret = tsm_dev_init(pdev, &tdev);
> +			if (ret)
> +				return ret;
> +
> +			ret = tsm_tdi_init(tdev, pdev);
> +			tsm_dev_put(tdev);
> +			return ret;
> +		}
> +		return 0;
> +	}
> +
> +	if (pdev->is_physfn && (PCI_FUNC(pdev->devfn) == 0) &&
> +	    (pdev->devcap & PCI_EXP_DEVCAP_TEE_IO)) {
> +		struct tsm_dev *tdev = NULL;
> +
Trivial but... One blank line 
> +
> +		ret = tsm_dev_init(pdev, &tdev);
> +		if (ret)
> +			return ret;
> +
> +		ret = tsm_tdi_init(tdev, pdev);
> +		tsm_dev_put(tdev);
> +		return ret;
> +	}
> +
> +	if (pdev->is_virtfn) {
> +		struct pci_dev *pf0 = pci_get_slot(pdev->physfn->bus,
> +						   pdev->physfn->devfn & ~7);
> +
> +		if (pf0 && (pf0->devcap & PCI_EXP_DEVCAP_TEE_IO)) {
> +			struct tsm_dev *tdev = tsm_dev_get(&pf0->dev);
> +
> +			ret = tsm_tdi_init(tdev, pdev);
> +			tsm_dev_put(tdev);
> +			return ret;
> +		}
> +	}
> +
> +	return 0;
> +}

> +
> +static struct notifier_block tsm_pci_bus_nb = {
> +	.notifier_call = tsm_pci_bus_notifier,
> +};
> +
> +static int __init tsm_init(void)
> +{
> +	int ret = 0;
> +
> +	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
> +	return ret;
> +}
> +
> +static void __exit tsm_cleanup(void)
> +{
> +}

These aren't needed. If it's a library module it will have
nothing to do on init / exit which is fine.
And we don't care about versions! If we do then the discoverability
of features etc is totally broken.


> +
> +void tsm_set_ops(struct tsm_ops *ops, void *private_data)
> +{
> +	struct pci_dev *pdev = NULL;
> +	int ret;
> +
> +	if (!tsm.ops && ops) {
> +		tsm.ops = ops;
> +		tsm.private_data = private_data;
> +
> +		for_each_pci_dev(pdev) {
> +			ret = tsm_alloc_device(pdev);
> +			if (ret)
> +				break;
> +		}
> +		bus_register_notifier(&pci_bus_type, &tsm_pci_bus_nb);
> +	} else {
> +		bus_unregister_notifier(&pci_bus_type, &tsm_pci_bus_nb);
> +		for_each_pci_dev(pdev)
> +			tsm_dev_freeice(&pdev->dev);
> +		tsm.ops = ops;
> +	}
> +}
> +EXPORT_SYMBOL_GPL(tsm_set_ops);
> +
> +int tsm_tdi_bind(struct tsm_tdi *tdi, u32 guest_rid, u64 vmid, u32 asid)
> +{
> +	int ret;
> +
> +	if (WARN_ON(!tsm.ops->tdi_bind))
> +		return -EPERM;
> +
> +	tdi->guest_rid = guest_rid;
> +	tdi->vmid = vmid;
> +	tdi->asid = asid;
> +
> +	mutex_lock(&tdi->tdev->spdm_mutex);

scoped_guard() may help here and in the good path at least
allow a direct return.

> +	while (1) {
> +		ret = tsm.ops->tdi_bind(tdi, guest_rid, vmid, asid, tsm.private_data);
> +		if (ret < 0)
> +			break;
> +
> +		if (!ret)
> +			break;
> +
> +		ret = spdm_forward(&tdi->tdev->spdm, ret);
> +		if (ret < 0)
> +			break;
> +	}
> +	mutex_unlock(&tdi->tdev->spdm_mutex);
> +
> +	if (ret) {

I'd have separate err_unlock label and error handling path.
This pattern is somewhat harder to read.

> +		tsm_tdi_unbind(tdi);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(tsm_tdi_bind);
> +
> +void tsm_tdi_unbind(struct tsm_tdi *tdi)
> +{
> +	tsm_tdi_reclaim(tdi, tsm.private_data);
> +	tdi->vmid = 0;
> +	tdi->asid = 0;
> +	tdi->guest_rid = 0;
> +}
> +EXPORT_SYMBOL_GPL(tsm_tdi_unbind);
> +
> +int tsm_guest_request(struct tsm_tdi *tdi, enum tsm_tdisp_state *state, void *req_data)
> +{
> +	int ret;
> +
> +	if (!tsm.ops->guest_request)
> +		return -EPERM;
> +
> +	mutex_lock(&tdi->tdev->spdm_mutex);
guard(mutex)(&tdi->tdev->spmd_mutex);

Then you can do returns on error or finish instead of breaking out
just to unlock.



> +	while (1) {
> +		ret = tsm.ops->guest_request(tdi, tdi->guest_rid, tdi->vmid, req_data,
> +					     state, tsm.private_data);
> +		if (ret <= 0)
> +			break;
> +
> +		ret = spdm_forward(&tdi->tdev->spdm, ret);
> +		if (ret < 0)
> +			break;
> +	}
> +	mutex_unlock(&tdi->tdev->spdm_mutex);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(tsm_guest_request);

> +
> +module_init(tsm_init);
Put these next to the relevant functions - or put the functions next to these.
> +module_exit(tsm_cleanup);
> +
> +MODULE_VERSION(DRIVER_VERSION);
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR(DRIVER_AUTHOR);
> +MODULE_DESCRIPTION(DRIVER_DESC);
> diff --git a/Documentation/virt/coco/tsm.rst b/Documentation/virt/coco/tsm.rst
> new file mode 100644
> index 000000000000..3be6e8491e42
> --- /dev/null
> +++ b/Documentation/virt/coco/tsm.rst

I'd break this out as a separate patch - mostly to shout "DOCS here - read them"
as otherwise they end up at the end of a long email no one scrolls through.

> @@ -0,0 +1,62 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +What it is
> +==========
> +
> +This is for PCI passthrough in confidential computing (CoCo: SEV-SNP, TDX, CoVE).
> +Currently passing through PCI devices to a CoCo VM uses SWIOTLB to pre-shared
> +memory buffers.
> +
> +PCIe IDE (Integrity and Data Encryption) and TDISP (TEE Device Interface Security
> +Protocol) are protocols to enable encryption over PCIe link and DMA to encrypted
> +memory. This doc is focused to DMAing to encrypted VM, the encrypted host memory is
> +out of scope.
> +
> +
> +Protocols
> +=========
> +
> +PCIe r6 DOE is a mailbox protocol to read/write object from/to device.
> +Objects are of plain SPDM or secure SPDM type. SPDM is responsible for authenticating
> +devices, creating a secure link between a device and TSM.
> +IDE_KM manages PCIe link encryption keys, it works on top of secure SPDM.
> +TDISP manages a passed through PCI function state, also works on top on secure SPDM.
> +Additionally, PCIe defines IDE capability which provides the host OS a way
> +to enable streams on the PCIe link.
> +
> +
> +TSM module
> +==========
> +
> +This is common place to trigger device authentication and keys management.
> +It exposes certificates/measurenets/reports/status via sysfs and provides control

measurements 

> +over the link (limited though by the TSM capabilities).
> +A platform is expected to register a specific set of hooks. The same module works
> +in host and guest OS, the set of requires platform hooks is quite different.
> +
> +
> +Flow
> +====
> +
> +At the boot time the tsm.ko scans the PCI bus to find and setup TDISP-cabable
> +devices; it also listens to hotplug events. If setup was successful, tsm-prefixed
> +nodes will appear in sysfs.
> +
> +Then, the user enables IDE by writing to /sys/bus/pci/devices/0000:e1:00.0/tsm_dev_connect
> +and this is how PCIe encryption is enabled.
> +
> +To pass the device through, a modifined VMM is required.
> +
> +In the VM, the same tsm.ko loads. In addition to the host's setup, the VM wants
> +to receive the report and enable secure DMA or/and secure MMIO, via some VM<->HV
> +protocol (such as AMD GHCB). Once this is done, a VM can access validated MMIO
> +with the Cbit set and the device can DMA to encrypted memory.
> +
> +
> +References
> +==========
> +
> +[1] TEE Device Interface Security Protocol - TDISP - v2022-07-27
> +https://members.pcisig.com/wg/PCI-SIG/document/18268?downloadRevision=21500
> +[2] Security Protocol and Data Model (SPDM)
> +https://www.dmtf.org/sites/default/files/standards/documents/DSP0274_1.2.1.pdf
> diff --git a/drivers/virt/coco/Kconfig b/drivers/virt/coco/Kconfig
> index 87d142c1f932..67a9c9daf96d 100644
> --- a/drivers/virt/coco/Kconfig
> +++ b/drivers/virt/coco/Kconfig
> @@ -7,6 +7,17 @@ config TSM_REPORTS
>  	select CONFIGFS_FS
>  	tristate
>  
> +config TSM
> +	tristate "Platform support for TEE Device Interface Security Protocol (TDISP)"
> +	default m

No defaulting to m.  People get grumpy when this stuff turns up on their embedded
distros with no hardware support.

> +	depends on AMD_MEM_ENCRYPT
> +	select PCI_DOE
> +	select PCI_IDE
> +	help
> +	  Add a common place for user visible platform support for PCIe TDISP.
> +	  TEE Device Interface Security Protocol (TDISP) from PCI-SIG,
> +	  https://pcisig.com/tee-device-interface-security-protocol-tdisp
> +
>  source "drivers/virt/coco/efi_secret/Kconfig"
>  
>  source "drivers/virt/coco/sev-guest/Kconfig"


