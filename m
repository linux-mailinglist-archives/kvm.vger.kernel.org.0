Return-Path: <kvm+bounces-30704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 345259BC875
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 09:57:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E7D56282ECF
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 08:57:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08D9D1D2B0F;
	Tue,  5 Nov 2024 08:55:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEEC41D26EA;
	Tue,  5 Nov 2024 08:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730796958; cv=none; b=FXKV9atlELIyG2bO7fVBPp/ekgp30k2bwC20G/EN+zW4a57J699ORhw/DbJOHAh5oOlj2hOkgA7ug7PsWbQJwlYh27Nfxg20r6eLBByj67BRGNZ8kpi/V52J1z8JJzAqfK/1IAtzd8DvXX+ETdN4cLppwqoKXUYEBLrWBohbahg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730796958; c=relaxed/simple;
	bh=tZ2HBCBwJ12WhcIXBC02sjAqyO4cta4FFBr6GDHI5N4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Y0AT31rvQ7uCyYLOjakedmuRxRR6RetiULXtqK50ZhnhaBCxiWbBV1TOOgq9GXo1JEQ9gOIlcPrsArqHSXKG8m0lNRu3IJF1W+IuMZiRhCUuQo9cShaq6+kRI0yzOKySBAUSDYfYVHkM6X29d81IIwX+WjYXtCi8GsvfJ82L8rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XjMck6q8yz6LDfS;
	Tue,  5 Nov 2024 16:55:50 +0800 (CST)
Received: from frapeml500005.china.huawei.com (unknown [7.182.85.13])
	by mail.maildlp.com (Postfix) with ESMTPS id B7A621400CB;
	Tue,  5 Nov 2024 16:55:51 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml500005.china.huawei.com (7.182.85.13) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 5 Nov 2024 09:55:51 +0100
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Tue, 5 Nov 2024 09:55:51 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: liulongfang <liulongfang@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>, "Jonathan
 Cameron" <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH v12 3/4] hisi_acc_vfio_pci: register debugfs for hisilicon
 migration driver
Thread-Topic: [PATCH v12 3/4] hisi_acc_vfio_pci: register debugfs for
 hisilicon migration driver
Thread-Index: AQHbLzZ9E+Ip5Nj6eEy59hj6TfvRZ7KoVfVA
Date: Tue, 5 Nov 2024 08:55:51 +0000
Message-ID: <fc776543a1d14531b28b5fa693925518@huawei.com>
References: <20241105035254.24636-1-liulongfang@huawei.com>
 <20241105035254.24636-4-liulongfang@huawei.com>
In-Reply-To: <20241105035254.24636-4-liulongfang@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0



> -----Original Message-----
> From: liulongfang <liulongfang@huawei.com>
> Sent: Tuesday, November 5, 2024 3:53 AM
> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
> Subject: [PATCH v12 3/4] hisi_acc_vfio_pci: register debugfs for hisilico=
n
> migration driver

Hi,

Few minor comments below. Please don't re-spin just for these yet.
Please wait for others to review as well.

Thanks,
Shameer

> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index a8c53952d82e..7728c9745b9d 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -627,15 +627,30 @@ static void hisi_acc_vf_disable_fd(struct
> hisi_acc_vf_migration_file *migf)
>  	mutex_unlock(&migf->lock);
>  }
>=20
> +static void hisi_acc_debug_migf_copy(struct hisi_acc_vf_core_device
> *hisi_acc_vdev,
> +	struct hisi_acc_vf_migration_file *src_migf)

Alignment should match open parenthesis here.

> +{
> +	struct hisi_acc_vf_migration_file *dst_migf =3D hisi_acc_vdev-
> >debug_migf;
> +
> +	if (!dst_migf)
> +		return;
> +
> +	dst_migf->total_length =3D src_migf->total_length;
> +	memcpy(&dst_migf->vf_data, &src_migf->vf_data,
> +		sizeof(struct acc_vf_data));

Here too, alignment not correct. It is better to run,
./scripts/checkpatch --strict on these patches if you haven't done already.

> +}
> +
>  static void hisi_acc_vf_disable_fds(struct hisi_acc_vf_core_device
> *hisi_acc_vdev)
>  {
>  	if (hisi_acc_vdev->resuming_migf) {
> +		hisi_acc_debug_migf_copy(hisi_acc_vdev, hisi_acc_vdev-
> >resuming_migf);
>  		hisi_acc_vf_disable_fd(hisi_acc_vdev->resuming_migf);
>  		fput(hisi_acc_vdev->resuming_migf->filp);
>  		hisi_acc_vdev->resuming_migf =3D NULL;
>  	}
>=20
>  	if (hisi_acc_vdev->saving_migf) {
> +		hisi_acc_debug_migf_copy(hisi_acc_vdev, hisi_acc_vdev-
> >saving_migf);
>  		hisi_acc_vf_disable_fd(hisi_acc_vdev->saving_migf);
>  		fput(hisi_acc_vdev->saving_migf->filp);
>  		hisi_acc_vdev->saving_migf =3D NULL;
> @@ -1294,6 +1309,129 @@ static long hisi_acc_vfio_pci_ioctl(struct
> vfio_device *core_vdev, unsigned int
>  	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
>  }
>=20
> +static int hisi_acc_vf_debug_check(struct seq_file *seq, struct vfio_dev=
ice
> *vdev)
> +{
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =3D
> hisi_acc_get_vf_dev(vdev);
> +	struct hisi_qm *vf_qm =3D &hisi_acc_vdev->vf_qm;
> +	int ret;
> +
> +	lockdep_assert_held(&hisi_acc_vdev->open_mutex);
> +	/*
> +	 * When the device is not opened, the io_base is not mapped.
> +	 * The driver cannot perform device read and write operations.
> +	 */
> +	if (!hisi_acc_vdev->dev_opened) {
> +		seq_printf(seq, "device not opened!\n");
> +		return -EINVAL;
> +	}
> +
> +	ret =3D qm_wait_dev_not_ready(vf_qm);
> +	if (ret) {
> +		seq_printf(seq, "VF device not ready!\n");
> +		return -EBUSY;
> +	}
> +
> +	return 0;
> +}
> +
> +static int hisi_acc_vf_debug_cmd(struct seq_file *seq, void *data)
> +{
> +	struct device *vf_dev =3D seq->private;
> +	struct vfio_pci_core_device *core_device =3D
> dev_get_drvdata(vf_dev);
> +	struct vfio_device *vdev =3D &core_device->vdev;
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =3D
> hisi_acc_get_vf_dev(vdev);
> +	struct hisi_qm *vf_qm =3D &hisi_acc_vdev->vf_qm;
> +	u64 value;
> +	int ret;
> +
> +	mutex_lock(&hisi_acc_vdev->open_mutex);
> +	ret =3D hisi_acc_vf_debug_check(seq, vdev);
> +	if (ret) {
> +		mutex_unlock(&hisi_acc_vdev->open_mutex);
> +		return ret;
> +	}
> +
> +	value =3D readl(vf_qm->io_base + QM_MB_CMD_SEND_BASE);
> +	if (value =3D=3D QM_MB_CMD_NOT_READY) {
> +		mutex_unlock(&hisi_acc_vdev->open_mutex);
> +		seq_printf(seq, "mailbox cmd channel not ready!\n");
> +		return -EINVAL;
> +	}
> +	mutex_unlock(&hisi_acc_vdev->open_mutex);
> +	seq_printf(seq, "mailbox cmd channel ready!\n");
> +
> +	return 0;
> +}
> +
> +static int hisi_acc_vf_dev_read(struct seq_file *seq, void *data)
> +{
> +	struct device *vf_dev =3D seq->private;
> +	struct vfio_pci_core_device *core_device =3D
> dev_get_drvdata(vf_dev);
> +	struct vfio_device *vdev =3D &core_device->vdev;
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =3D
> hisi_acc_get_vf_dev(vdev);
> +	size_t vf_data_sz =3D offsetofend(struct acc_vf_data, padding);
> +	struct acc_vf_data *vf_data;
> +	int ret;
> +
> +	mutex_lock(&hisi_acc_vdev->open_mutex);
> +	ret =3D hisi_acc_vf_debug_check(seq, vdev);
> +	if (ret) {
> +		mutex_unlock(&hisi_acc_vdev->open_mutex);
> +		return ret;
> +	}
> +
> +	mutex_lock(&hisi_acc_vdev->state_mutex);
> +	vf_data =3D kzalloc(sizeof(struct acc_vf_data), GFP_KERNEL);
> +	if (!vf_data) {
> +		ret =3D -ENOMEM;
> +		goto mutex_release;
> +	}
> +
> +	vf_data->vf_qm_state =3D hisi_acc_vdev->vf_qm_state;
> +	ret =3D vf_qm_read_data(&hisi_acc_vdev->vf_qm, vf_data);
> +	if (ret)
> +		goto migf_err;
> +
> +	seq_hex_dump(seq, "Dev Data:", DUMP_PREFIX_OFFSET, 16, 1,
> +		     (const void *)vf_data, vf_data_sz, false);
> +
> +	seq_printf(seq,
> +		   "guest driver load: %u\n"
> +		   "data size: %lu\n",
> +		   hisi_acc_vdev->vf_qm_state,
> +		   sizeof(struct acc_vf_data));

There was a suggestion to add a comment here to describe vf_qm_state better=
.
May be something like,

vf_qm_state here indicates whether the Guest has loaded the driver for the =
ACC VF
device or not.

> +
> +migf_err:
> +	kfree(vf_data);
> +mutex_release:
> +	mutex_unlock(&hisi_acc_vdev->state_mutex);
> +	mutex_unlock(&hisi_acc_vdev->open_mutex);
> +
> +	return ret;
> +}
> +
> +static int hisi_acc_vf_migf_read(struct seq_file *seq, void *data)
> +{
> +	struct device *vf_dev =3D seq->private;
> +	struct vfio_pci_core_device *core_device =3D
> dev_get_drvdata(vf_dev);
> +	struct vfio_device *vdev =3D &core_device->vdev;
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =3D
> hisi_acc_get_vf_dev(vdev);
> +	size_t vf_data_sz =3D offsetofend(struct acc_vf_data, padding);
> +	struct hisi_acc_vf_migration_file *debug_migf =3D hisi_acc_vdev-
> >debug_migf;
> +
> +	/* Check whether the live migration operation has been performed
> */
> +	if (debug_migf->total_length < QM_MATCH_SIZE) {
> +		seq_printf(seq, "device not migrated!\n");
> +		return -EAGAIN;
> +	}
> +
> +	seq_hex_dump(seq, "Mig Data:", DUMP_PREFIX_OFFSET, 16, 1,
> +		     (const void *)&debug_migf->vf_data, vf_data_sz, false);
> +	seq_printf(seq, "migrate data length: %lu\n", debug_migf-
> >total_length);
> +
> +	return 0;
> +}
> +
>  static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
>  {
>  	struct hisi_acc_vf_core_device *hisi_acc_vdev =3D
> hisi_acc_get_vf_dev(core_vdev);
> @@ -1305,12 +1443,16 @@ static int hisi_acc_vfio_pci_open_device(struct
> vfio_device *core_vdev)
>  		return ret;
>=20
>  	if (core_vdev->mig_ops) {
> +		mutex_lock(&hisi_acc_vdev->open_mutex);
>  		ret =3D hisi_acc_vf_qm_init(hisi_acc_vdev);
>  		if (ret) {
> +			mutex_unlock(&hisi_acc_vdev->open_mutex);
>  			vfio_pci_core_disable(vdev);
>  			return ret;
>  		}
>  		hisi_acc_vdev->mig_state =3D VFIO_DEVICE_STATE_RUNNING;
> +		hisi_acc_vdev->dev_opened =3D true;
> +		mutex_unlock(&hisi_acc_vdev->open_mutex);
>  	}
>=20
>  	vfio_pci_core_finish_enable(vdev);
> @@ -1322,7 +1464,10 @@ static void hisi_acc_vfio_pci_close_device(struct
> vfio_device *core_vdev)
>  	struct hisi_acc_vf_core_device *hisi_acc_vdev =3D
> hisi_acc_get_vf_dev(core_vdev);
>  	struct hisi_qm *vf_qm =3D &hisi_acc_vdev->vf_qm;
>=20
> +	mutex_lock(&hisi_acc_vdev->open_mutex);
> +	hisi_acc_vdev->dev_opened =3D false;
>  	iounmap(vf_qm->io_base);
> +	mutex_unlock(&hisi_acc_vdev->open_mutex);
>  	vfio_pci_core_close_device(core_vdev);
>  }
>=20
> @@ -1342,6 +1487,7 @@ static int hisi_acc_vfio_pci_migrn_init_dev(struct
> vfio_device *core_vdev)
>  	hisi_acc_vdev->pf_qm =3D pf_qm;
>  	hisi_acc_vdev->vf_dev =3D pdev;
>  	mutex_init(&hisi_acc_vdev->state_mutex);
> +	mutex_init(&hisi_acc_vdev->open_mutex);
>=20
>  	core_vdev->migration_flags =3D VFIO_MIGRATION_STOP_COPY |
> VFIO_MIGRATION_PRE_COPY;
>  	core_vdev->mig_ops =3D &hisi_acc_vfio_pci_migrn_state_ops;
> @@ -1387,6 +1533,48 @@ static const struct vfio_device_ops
> hisi_acc_vfio_pci_ops =3D {
>  	.detach_ioas =3D vfio_iommufd_physical_detach_ioas,
>  };
>=20
> +static void hisi_acc_vfio_debug_init(struct hisi_acc_vf_core_device
> *hisi_acc_vdev)
> +{
> +	struct vfio_device *vdev =3D &hisi_acc_vdev->core_device.vdev;
> +	struct dentry *vfio_dev_migration =3D NULL;
> +	struct dentry *vfio_hisi_acc =3D NULL;
> +	struct device *dev =3D vdev->dev;
> +	void *migf =3D NULL;
> +
> +	if (!debugfs_initialized() ||
> +	    !IS_ENABLED(CONFIG_VFIO_DEBUGFS))
> +		return;
> +
> +	if (vdev->ops !=3D &hisi_acc_vfio_pci_migrn_ops)
> +		return;
> +
> +	vfio_dev_migration =3D debugfs_lookup("migration", vdev-
> >debug_root);
> +	if (!vfio_dev_migration) {
> +		dev_err(dev, "failed to lookup migration debugfs file!\n");
> +		return;
> +	}
> +
> +	migf =3D kzalloc(sizeof(struct hisi_acc_vf_migration_file),
> GFP_KERNEL);
> +	if (!migf)
> +		return;
> +	hisi_acc_vdev->debug_migf =3D migf;
> +
> +	vfio_hisi_acc =3D debugfs_create_dir("hisi_acc", vfio_dev_migration);
> +	debugfs_create_devm_seqfile(dev, "dev_data", vfio_hisi_acc,
> +				    hisi_acc_vf_dev_read);
> +	debugfs_create_devm_seqfile(dev, "migf_data", vfio_hisi_acc,
> +				    hisi_acc_vf_migf_read);
> +	debugfs_create_devm_seqfile(dev, "cmd_state", vfio_hisi_acc,
> +				    hisi_acc_vf_debug_cmd);
> +}
> +
> +static void hisi_acc_vf_debugfs_exit(struct hisi_acc_vf_core_device
> *hisi_acc_vdev)
> +{
> +	/* If migrn_ops is not used, kfree(NULL) is valid */

The above comment is not required. Please remove.

> +	kfree(hisi_acc_vdev->debug_migf);
> +	hisi_acc_vdev->debug_migf =3D NULL;
> +}
> +


