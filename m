Return-Path: <kvm+bounces-7976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7651F8495AF
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 09:52:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D2EF281197
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 08:52:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29E5B11CAE;
	Mon,  5 Feb 2024 08:52:19 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E6211706;
	Mon,  5 Feb 2024 08:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707123138; cv=none; b=JY8yPmwoae5bl+ijOIodDUI96Aw/V9W9cmp+ywW55WbVLJBSAfgDmeg/giH7JzdxQppSTT7xTImEohPxWoxxu6Ogqo030Oje68oHiP/OtecJz2y8GnM3MeYRDBIx68fA2RaVaeWc9BdMWBz/sIxc7eDefCdCP3aCyI5TAuijxdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707123138; c=relaxed/simple;
	bh=dFCb3IEvT5eKHDAlCGgb4jVCqCUkw4KSxuQSZGxpkCY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EWicylinzbwjB0QgUZntYSZPpUg8w1RQcHfqsfWjY4DjZhDR/E1lWtF+Hwf0wNOIHimL6c0X59GSghaaLIOho+Yb7kDVwNHZ/9EkvI9ZxgNCRs1grfZbebQJZ8XoU6xKJjS0WlBtv3Gqbby/LQF4qbruO1d6ChL7shUFApS/s7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4TT0RC1dKNz6G80H;
	Mon,  5 Feb 2024 16:48:55 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id BA564141CC7;
	Mon,  5 Feb 2024 16:52:06 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 5 Feb 2024 08:52:06 +0000
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.035;
 Mon, 5 Feb 2024 08:52:06 +0000
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: liulongfang <liulongfang@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>, "Jonathan
 Cameron" <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH v2 2/3] hisi_acc_vfio_pci: register debugfs for hisilicon
 migration driver
Thread-Topic: [PATCH v2 2/3] hisi_acc_vfio_pci: register debugfs for hisilicon
 migration driver
Thread-Index: AQHaV0i5tkBUAixO9Ua7YSFPSmzxI7D7aQpQ
Date: Mon, 5 Feb 2024 08:52:06 +0000
Message-ID: <0337a36286244e28b26895b24a7b36d3@huawei.com>
References: <20240204085610.17720-1-liulongfang@huawei.com>
 <20240204085610.17720-3-liulongfang@huawei.com>
In-Reply-To: <20240204085610.17720-3-liulongfang@huawei.com>
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
> Sent: Sunday, February 4, 2024 8:56 AM
> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
> Subject: [PATCH v2 2/3] hisi_acc_vfio_pci: register debugfs for hisilicon
> migration driver
>=20
> On the debugfs framework of VFIO, if the CONFIG_VFIO_DEBUGFS macro is
> enabled, the debug function is registered for the live migration driver
> of the HiSilicon accelerator device.
>=20
> After registering the HiSilicon accelerator device on the debugfs
> framework of live migration of vfio, a directory file "hisi_acc"
> of debugfs is created, and then three debug function files are
> created in this directory:
>=20
>    vfio
>     |
>     +---<dev_name1>
>     |    +---migration
>     |        +--state
>     |        +--hisi_acc
>     |            +--attr
>     |            +--data
>     |            +--save
>     |            +--cmd_state
>     |
>     +---<dev_name2>
>          +---migration
>              +--state
>              +--hisi_acc
>                  +--attr
>                  +--data
>                  +--save
>                  +--cmd_state
>=20
> data file: used to get the migration data from the driver
> attr file: used to get device attributes parameters from the driver
> save file: used to read the data of the live migration device and save
> it to the driver.
> cmd_state: used to get the cmd channel state for the device.
>=20
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 197 ++++++++++++++++++
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  11 +
>  2 files changed, 208 insertions(+)
>=20
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index 00a22a990eb8..e51bbb41c2b3 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -15,6 +15,7 @@
>  #include <linux/anon_inodes.h>
>=20
>  #include "hisi_acc_vfio_pci.h"
> +#include "../../vfio.h"
>=20
>  /* Return 0 on VM acc device ready, -ETIMEDOUT hardware timeout */
>  static int qm_wait_dev_not_ready(struct hisi_qm *qm)
> @@ -606,6 +607,18 @@ hisi_acc_check_int_state(struct
> hisi_acc_vf_core_device *hisi_acc_vdev)
>  	}
>  }
>=20
> +static void hisi_acc_vf_migf_save(struct hisi_acc_vf_migration_file
> *dst_migf,

Can we please rename this to indicate the debug, similar to other debugfs s=
upport
functions here, something like hisi_acc_vf_debug_migf_save()?

> +	struct hisi_acc_vf_migration_file *src_migf)
> +{
> +	if (!dst_migf)
> +		return;
> +
> +	dst_migf->disabled =3D false;

Is this set to true anywhere for debugfs migf ?

> +	dst_migf->total_length =3D src_migf->total_length;
> +	memcpy(&dst_migf->vf_data, &src_migf->vf_data,
> +		    sizeof(struct acc_vf_data));
> +}
> +
>  static void hisi_acc_vf_disable_fd(struct hisi_acc_vf_migration_file *mi=
gf)
>  {
>  	mutex_lock(&migf->lock);
> @@ -618,12 +631,16 @@ static void hisi_acc_vf_disable_fd(struct
> hisi_acc_vf_migration_file *migf)
>  static void hisi_acc_vf_disable_fds(struct hisi_acc_vf_core_device
> *hisi_acc_vdev)
>  {
>  	if (hisi_acc_vdev->resuming_migf) {
> +		hisi_acc_vf_migf_save(hisi_acc_vdev->debug_migf,
> +						hisi_acc_vdev-
> >resuming_migf);
>  		hisi_acc_vf_disable_fd(hisi_acc_vdev->resuming_migf);
>  		fput(hisi_acc_vdev->resuming_migf->filp);
>  		hisi_acc_vdev->resuming_migf =3D NULL;
>  	}
>=20
>  	if (hisi_acc_vdev->saving_migf) {
> +		hisi_acc_vf_migf_save(hisi_acc_vdev->debug_migf,
> +						hisi_acc_vdev->saving_migf);
>  		hisi_acc_vf_disable_fd(hisi_acc_vdev->saving_migf);
>  		fput(hisi_acc_vdev->saving_migf->filp);
>  		hisi_acc_vdev->saving_migf =3D NULL;
> @@ -1156,6 +1173,7 @@ static int hisi_acc_vf_qm_init(struct
> hisi_acc_vf_core_device *hisi_acc_vdev)
>  	if (!vf_qm->io_base)
>  		return -EIO;
>=20
> +	mutex_init(&hisi_acc_vdev->enable_mutex);
>  	vf_qm->fun_type =3D QM_HW_VF;
>  	vf_qm->pdev =3D vf_dev;
>  	mutex_init(&vf_qm->mailbox_lock);
> @@ -1306,6 +1324,176 @@ static long hisi_acc_vfio_pci_ioctl(struct
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
> +	struct hisi_acc_vf_migration_file *migf =3D hisi_acc_vdev->debug_migf;
> +
> +	if (!vdev->mig_ops || !migf) {
> +		seq_printf(seq, "%s\n", "device does not support live
> migration!");
> +		return -EINVAL;
> +	}
> +
> +	/**
> +	 * When the device is not opened, the io_base is not mapped.
> +	 * The driver cannot perform device read and write operations.
> +	 */
> +	if (atomic_read(&hisi_acc_vdev->dev_opened) !=3D DEV_OPEN) {
> +		seq_printf(seq, "%s\n", "device not opened!");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int hisi_acc_vf_debug_cmd(struct seq_file *seq, void *data)
> +{
> +	struct device *vf_dev =3D seq->private;
> +	struct vfio_pci_core_device *core_device =3D dev_get_drvdata(vf_dev);
> +	struct vfio_device *vdev =3D &core_device->vdev;
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =3D
> hisi_acc_get_vf_dev(vdev);
> +	struct hisi_qm *vf_qm =3D &hisi_acc_vdev->vf_qm;
> +	u64 value;
> +	int ret;
> +
> +	mutex_lock(&hisi_acc_vdev->enable_mutex);
> +	ret =3D hisi_acc_vf_debug_check(seq, vdev);
> +	if (ret) {
> +		mutex_unlock(&hisi_acc_vdev->enable_mutex);
> +		return 0;
> +	}
> +
> +	ret =3D qm_wait_dev_not_ready(vf_qm);
> +	if (ret) {
> +		mutex_unlock(&hisi_acc_vdev->enable_mutex);
> +		seq_printf(seq, "%s\n", "VF device not ready!");
> +		return 0;
> +	}
> +
> +	value =3D readl(vf_qm->io_base + QM_MB_CMD_SEND_BASE);
> +	mutex_unlock(&hisi_acc_vdev->enable_mutex);
> +	seq_printf(seq, "%s:0x%llx\n", "mailbox cmd channel state is OK",
> value);
> +
> +	return 0;
> +}
> +
> +static int hisi_acc_vf_debug_save(struct seq_file *seq, void *data)
> +{
> +	struct device *vf_dev =3D seq->private;
> +	struct vfio_pci_core_device *core_device =3D dev_get_drvdata(vf_dev);
> +	struct vfio_device *vdev =3D &core_device->vdev;
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =3D
> hisi_acc_get_vf_dev(vdev);
> +	struct hisi_acc_vf_migration_file *migf =3D hisi_acc_vdev->debug_migf;
> +	int ret;
> +
> +	mutex_lock(&hisi_acc_vdev->enable_mutex);
> +	ret =3D hisi_acc_vf_debug_check(seq, vdev);
> +	if (ret) {
> +		mutex_unlock(&hisi_acc_vdev->enable_mutex);
> +		return 0;
> +	}
> +
> +	ret =3D vf_qm_state_save(hisi_acc_vdev, migf);

Are you sure this will not interfere with the core migration APIs as we are=
 not
holding the state_mutex?. I think Alex also raised a similar concern previo=
usly.=20
Applies to other debugfs interfaces here as well. Please check.


> +	if (ret) {
> +		mutex_unlock(&hisi_acc_vdev->enable_mutex);
> +		seq_printf(seq, "%s\n", "failed to save device data!");
> +		return 0;
> +	}
> +	mutex_unlock(&hisi_acc_vdev->enable_mutex);
> +	seq_printf(seq, "%s\n", "successful to save device data!");
> +
> +	return 0;
> +}
> +
> +static int hisi_acc_vf_data_read(struct seq_file *seq, void *data)
> +{
> +	struct device *vf_dev =3D seq->private;
> +	struct vfio_pci_core_device *core_device =3D dev_get_drvdata(vf_dev);
> +	struct vfio_device *vdev =3D &core_device->vdev;
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =3D
> hisi_acc_get_vf_dev(vdev);
> +	struct hisi_acc_vf_migration_file *debug_migf =3D hisi_acc_vdev-
> >debug_migf;
> +	size_t vf_data_sz =3D offsetofend(struct acc_vf_data, padding);
> +
> +	if (debug_migf && debug_migf->total_length)
> +		seq_hex_dump(seq, "Mig Data:", DUMP_PREFIX_OFFSET, 16,
> 1,
> +				(unsigned char *)&debug_migf->vf_data,
> +				vf_data_sz, false);
> +	else
> +		seq_printf(seq, "%s\n", "device not migrated!");
> +
> +	return 0;
> +}
> +
> +static int hisi_acc_vf_attr_read(struct seq_file *seq, void *data)
> +{
> +	struct device *vf_dev =3D seq->private;
> +	struct vfio_pci_core_device *core_device =3D dev_get_drvdata(vf_dev);
> +	struct vfio_device *vdev =3D &core_device->vdev;
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =3D
> hisi_acc_get_vf_dev(vdev);
> +	struct hisi_acc_vf_migration_file *debug_migf =3D hisi_acc_vdev-
> >debug_migf;
> +
> +	if (debug_migf && debug_migf->total_length) {
> +		seq_printf(seq,
> +			 "acc device:\n"
> +			 "device  state: %d\n"
> +			 "device  ready: %u\n"
> +			 "data    valid: %d\n"
> +			 "data     size: %lu\n",
> +			 hisi_acc_vdev->mig_state,
> +			 hisi_acc_vdev->vf_qm_state,
> +			 debug_migf->disabled,
> +			 debug_migf->total_length);
> +	} else {
> +		seq_printf(seq, "%s\n", "device not migrated!");
> +	}
> +
> +	return 0;
> +}
> +
> +static int hisi_acc_vfio_debug_init(struct hisi_acc_vf_core_device
> *hisi_acc_vdev)
> +{
> +	struct vfio_device *vdev =3D &hisi_acc_vdev->core_device.vdev;
> +	struct dentry *vfio_dev_migration =3D NULL;
> +	struct dentry *vfio_hisi_acc =3D NULL;
> +	struct device *dev =3D vdev->dev;
> +	void *migf =3D NULL;
> +
> +	if (!debugfs_initialized())
> +		return 0;
> +
> +	migf =3D kzalloc(sizeof(struct hisi_acc_vf_migration_file), GFP_KERNEL)=
;
> +	if (!migf)
> +		return -ENOMEM;
> +	hisi_acc_vdev->debug_migf =3D migf;
> +
> +	vfio_dev_migration =3D debugfs_lookup("migration", vdev-
> >debug_root);
> +	if (!vfio_dev_migration) {
> +		kfree(migf);
> +		dev_err(dev, "failed to lookup migration debugfs file!\n");
> +		return -ENODEV;
> +	}
> +
> +	vfio_hisi_acc =3D debugfs_create_dir("hisi_acc", vfio_dev_migration);
> +	debugfs_create_devm_seqfile(dev, "data", vfio_hisi_acc,
> +				  hisi_acc_vf_data_read);
> +	debugfs_create_devm_seqfile(dev, "attr", vfio_hisi_acc,
> +				  hisi_acc_vf_attr_read);
> +	debugfs_create_devm_seqfile(dev, "cmd_state", vfio_hisi_acc,
> +				  hisi_acc_vf_debug_cmd);
> +	debugfs_create_devm_seqfile(dev, "save", vfio_hisi_acc,
> +				  hisi_acc_vf_debug_save);
> +
> +	return 0;
> +}
> +
> +static void hisi_acc_vf_debugfs_exit(struct hisi_acc_vf_core_device
> *hisi_acc_vdev)
> +{
> +	if (!debugfs_initialized())
> +		return;
> +
> +	kfree(hisi_acc_vdev->debug_migf);
> +}
> +
>  static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
>  {
>  	struct hisi_acc_vf_core_device *hisi_acc_vdev =3D
> hisi_acc_get_vf_dev(core_vdev);
> @@ -1323,9 +1511,11 @@ static int hisi_acc_vfio_pci_open_device(struct
> vfio_device *core_vdev)
>  			return ret;
>  		}
>  		hisi_acc_vdev->mig_state =3D VFIO_DEVICE_STATE_RUNNING;
> +		atomic_set(&hisi_acc_vdev->dev_opened, DEV_OPEN);
>  	}
>=20
>  	vfio_pci_core_finish_enable(vdev);
> +
>  	return 0;
>  }
>=20
> @@ -1334,7 +1524,10 @@ static void hisi_acc_vfio_pci_close_device(struct
> vfio_device *core_vdev)
>  	struct hisi_acc_vf_core_device *hisi_acc_vdev =3D
> hisi_acc_get_vf_dev(core_vdev);
>  	struct hisi_qm *vf_qm =3D &hisi_acc_vdev->vf_qm;
>=20
> +	atomic_set(&hisi_acc_vdev->dev_opened, DEV_CLOSE);
> +	mutex_lock(&hisi_acc_vdev->enable_mutex);
>  	iounmap(vf_qm->io_base);
> +	mutex_unlock(&hisi_acc_vdev->enable_mutex);
>  	vfio_pci_core_close_device(core_vdev);
>  }
>=20
> @@ -1425,6 +1618,9 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev
> *pdev, const struct pci_device
>  	ret =3D vfio_pci_core_register_device(&hisi_acc_vdev->core_device);
>  	if (ret)
>  		goto out_put_vdev;
> +
> +	if (ops =3D=3D &hisi_acc_vfio_pci_migrn_ops)
> +		hisi_acc_vfio_debug_init(hisi_acc_vdev);
>  	return 0;
>=20
>  out_put_vdev:
> @@ -1437,6 +1633,7 @@ static void hisi_acc_vfio_pci_remove(struct pci_dev
> *pdev)
>  	struct hisi_acc_vf_core_device *hisi_acc_vdev =3D
> hisi_acc_drvdata(pdev);
>=20
>  	vfio_pci_core_unregister_device(&hisi_acc_vdev->core_device);
> +	hisi_acc_vf_debugfs_exit(hisi_acc_vdev);
>  	vfio_put_device(&hisi_acc_vdev->core_device.vdev);
>  }
>=20
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> index dcabfeec6ca1..283bd8acdc42 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> @@ -49,6 +49,11 @@
>  #define QM_EQC_DW0		0X8000
>  #define QM_AEQC_DW0		0X8020
>=20
> +enum acc_dev_state {
> +	DEV_CLOSE =3D 0x0,
> +	DEV_OPEN,
> +};

Do we really need this enum as you can directly use 0 or 1?

Thanks,
Shameer

> +
>  struct acc_vf_data {
>  #define QM_MATCH_SIZE offsetofend(struct acc_vf_data, qm_rsv_state)
>  	/* QM match information */
> @@ -113,5 +118,11 @@ struct hisi_acc_vf_core_device {
>  	spinlock_t reset_lock;
>  	struct hisi_acc_vf_migration_file *resuming_migf;
>  	struct hisi_acc_vf_migration_file *saving_migf;
> +
> +	/* To make sure the device is enabled */
> +	struct mutex enable_mutex;
> +	atomic_t dev_opened;
> +	/* For debugfs */
> +	struct hisi_acc_vf_migration_file *debug_migf;
>  };
>  #endif /* HISI_ACC_VFIO_PCI_H */
> --
> 2.24.0


