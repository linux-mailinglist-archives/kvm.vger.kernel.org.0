Return-Path: <kvm+bounces-23197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 77EE994778F
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 10:52:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E91691F22450
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 08:52:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7132F14D71A;
	Mon,  5 Aug 2024 08:51:51 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9CE13D503;
	Mon,  5 Aug 2024 08:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722847911; cv=none; b=GuYQxZil/77aX653hPIRjsDQLKkZOORvsghWfegULgyYbvlvhanhp0NxDHy7BC8WZCmySNmVm8JsAY526GoA/9KYNSRasHDF6GZVH3ZMhbssOXlSFrCXibFZVXpBivio9YIvZ9UFa0PJRSApAoSLB+JZ9/1PXFyq2tFa4Na5Rug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722847911; c=relaxed/simple;
	bh=SEe/4KyJYtUU6wWSjIO7qRdxeVplUeNtGPe+pVPxnGY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bNgn6U1VAaUJ6hDxiBMzppNm4JbZHjJMYHjSY26JqgRrtialMUDvAVjZDp8u9hCl1QrGfbh20Y0Dgo7sRWwGA+p0pNY/zxz+DnrzbLmxIz3/hSWneQRhoLTKEXVYoGbFMzvdFYHzA6WYrTBe+lVSwviKLt1Xqb8kWeMiooutABE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4WcqqM0zbdz6K9F6;
	Mon,  5 Aug 2024 16:49:03 +0800 (CST)
Received: from lhrpeml500006.china.huawei.com (unknown [7.191.161.198])
	by mail.maildlp.com (Postfix) with ESMTPS id B1F4A140B39;
	Mon,  5 Aug 2024 16:51:44 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml500006.china.huawei.com (7.191.161.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 5 Aug 2024 09:51:44 +0100
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.039;
 Mon, 5 Aug 2024 09:51:44 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: liulongfang <liulongfang@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>, "Jonathan
 Cameron" <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH v7 3/4] hisi_acc_vfio_pci: register debugfs for hisilicon
 migration driver
Thread-Topic: [PATCH v7 3/4] hisi_acc_vfio_pci: register debugfs for hisilicon
 migration driver
Thread-Index: AQHa4nseByZ7KbhcXUiElBAJYALc1LIYXf/w
Date: Mon, 5 Aug 2024 08:51:44 +0000
Message-ID: <d3df247106fb4d38b4b9cfbfc956f6dc@huawei.com>
References: <20240730121438.58455-1-liulongfang@huawei.com>
 <20240730121438.58455-4-liulongfang@huawei.com>
In-Reply-To: <20240730121438.58455-4-liulongfang@huawei.com>
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
> Sent: Tuesday, July 30, 2024 1:15 PM
> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
> Subject: [PATCH v7 3/4] hisi_acc_vfio_pci: register debugfs for hisilicon
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
>     |            +--dev_data
>     |            +--migf_data
>     |            +--cmd_state
>     |
>     +---<dev_name2>
>          +---migration
>              +--state
>              +--hisi_acc
>                  +--dev_data
>                  +--migf_data
>                  +--cmd_state
>=20
> dev_data file: read device data that needs to be migrated from the
> current device in real time
> migf_data file: read the migration data of the last live migration
> from the current driver.
> cmd_state: used to get the cmd channel state for the device.
>=20
> +----------------+        +--------------+       +---------------+
> | migration dev  |        |   src  dev   |       |   dst  dev    |
> +-------+--------+        +------+-------+       +-------+-------+
>         |                        |                       |
>         |                 +------v-------+       +-------v-------+
>         |                 |  saving_migf |       | resuming_migf |
>   read  |                 |     file     |       |     file      |
>         |                 +------+-------+       +-------+-------+
>         |                        |          copy         |
>         |                        +------------+----------+
>         |                                     |
> +-------v--------+                    +-------v--------+
> |   data buffer  |                    |   debug_migf   |
> +-------+--------+                    +-------+--------+
>         |                                     |
>    cat  |                                 cat |
> +-------v--------+                    +-------v--------+
> |   dev_data     |                    |   migf_data    |
> +----------------+                    +----------------+
>=20
> When accessing debugfs, user can obtain the most recent status data
> of the device through the "dev_data" file. It can read recent
> complete status data of the device. If the current device is being
> migrated, it will wait for it to complete.
> The data for the last completed migration function will be stored
> in debug_migf. Users can read it via "migf_data".
>=20
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 220 ++++++++++++++++++
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |   6 +
>  2 files changed, 226 insertions(+)
>=20
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index a8c53952d82e..ae8946901e73 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -627,15 +627,31 @@ static void hisi_acc_vf_disable_fd(struct
> hisi_acc_vf_migration_file *migf)
>  	mutex_unlock(&migf->lock);
>  }
>=20
> +static void hisi_acc_debug_migf_copy(struct hisi_acc_vf_core_device
> *hisi_acc_vdev,
> +	struct hisi_acc_vf_migration_file *src_migf)
> +{
> +	struct hisi_acc_vf_migration_file *dst_migf =3D hisi_acc_vdev-
> >debug_migf;
> +
> +	if (!dst_migf)
> +		return;
> +
> +	dst_migf->disabled =3D true;

This is always set to true, then why bother printing this as part of migf_d=
ata
below?.  See also comments on "disabled" below. Is there any value in givin=
g=20
this info to user?

> +	dst_migf->total_length =3D src_migf->total_length;
> +	memcpy(&dst_migf->vf_data, &src_migf->vf_data,
> +		sizeof(struct acc_vf_data));
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
> @@ -1294,6 +1310,201 @@ static long hisi_acc_vfio_pci_ioctl(struct
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
> +	if (!vdev->mig_ops) {
> +		seq_printf(seq, "%s\n", "device does not support live
> migration!\n");
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * When the device is not opened, the io_base is not mapped.
> +	 * The driver cannot perform device read and write operations.
> +	 */

I think it is better you make sure the lock is held in this function before
checking this. Use lockdep_assert_held(lock).

> +	if (!hisi_acc_vdev->dev_opened) {
> +		seq_printf(seq, "%s\n", "device not opened!\n");
> +		return -EINVAL;
> +	}
> +
> +	ret =3D qm_wait_dev_not_ready(vf_qm);
> +	if (ret) {
> +		seq_printf(seq, "%s\n", "VF device not ready!\n");
> +		return -EBUSY;
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
> +	mutex_lock(&hisi_acc_vdev->state_mutex);
> +	ret =3D hisi_acc_vf_debug_check(seq, vdev);
> +	if (ret) {
> +		mutex_unlock(&hisi_acc_vdev->state_mutex);
> +		return ret;
> +	}
> +
> +	value =3D readl(vf_qm->io_base + QM_MB_CMD_SEND_BASE);
> +	if (value =3D=3D QM_MB_CMD_NOT_READY) {
> +		mutex_unlock(&hisi_acc_vdev->state_mutex);
> +		seq_printf(seq, "mailbox cmd channel not ready!\n");
> +		return -EINVAL;
> +	}
> +	mutex_unlock(&hisi_acc_vdev->state_mutex);
> +	seq_printf(seq, "mailbox cmd channel ready!\n");
> +
> +	return 0;
> +}
> +
> +static int hisi_acc_vf_dev_read(struct seq_file *seq, void *data)
> +{
> +	struct device *vf_dev =3D seq->private;
> +	struct vfio_pci_core_device *core_device =3D dev_get_drvdata(vf_dev);
> +	struct vfio_device *vdev =3D &core_device->vdev;
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =3D
> hisi_acc_get_vf_dev(vdev);
> +	size_t vf_data_sz =3D offsetofend(struct acc_vf_data, padding);
> +	struct acc_vf_data *vf_data =3D NULL;
> +	bool migf_state;
> +	int ret;
> +
> +	vf_data =3D kzalloc(sizeof(struct acc_vf_data), GFP_KERNEL);
> +	if (!vf_data)
> +		return -ENOMEM;
> +
> +	mutex_lock(&hisi_acc_vdev->state_mutex);
> +	ret =3D hisi_acc_vf_debug_check(seq, vdev);
> +	if (ret) {
> +		mutex_unlock(&hisi_acc_vdev->state_mutex);
> +		goto migf_err;
> +	}
> +
> +	vf_data->vf_qm_state =3D hisi_acc_vdev->vf_qm_state;
> +	ret =3D vf_qm_read_data(&hisi_acc_vdev->vf_qm, vf_data);
> +	if (ret) {
> +		mutex_unlock(&hisi_acc_vdev->state_mutex);
> +		goto migf_err;
> +	}
> +
> +	if (hisi_acc_vdev->resuming_migf)
> +		migf_state =3D hisi_acc_vdev->resuming_migf->disabled;
> +	else if (hisi_acc_vdev->saving_migf)
> +		migf_state =3D hisi_acc_vdev->saving_migf->disabled;
> +	else
> +		migf_state =3D true;

I am still not sure what information we are getting from this "disabled". T=
he value=20
"true" means the migf file is released, isn't it? How is that equivalent to=
 report as "data
valid" below? Also "migf_state" is misleading here.

Thanks,
Shameer

> +	mutex_unlock(&hisi_acc_vdev->state_mutex);
> +
> +	seq_hex_dump(seq, "Dev Data:", DUMP_PREFIX_OFFSET, 16, 1,
> +			(unsigned char *)vf_data,
> +			vf_data_sz, false);
> +
> +	seq_printf(seq,
> +		 "acc device:\n"
> +		 "device  ready: %u\n"
> +		 "device  opened: %d\n"
> +		 "data    valid: %d\n"
> +		 "data     size: %lu\n",
> +		 hisi_acc_vdev->vf_qm_state,
> +		 hisi_acc_vdev->dev_opened,
> +		 migf_state,
> +		 sizeof(struct acc_vf_data));
> +
> +migf_err:
> +	kfree(vf_data);
> +
> +	return ret;
> +}
> +
> +static int hisi_acc_vf_migf_read(struct seq_file *seq, void *data)
> +{
> +	struct device *vf_dev =3D seq->private;
> +	struct vfio_pci_core_device *core_device =3D dev_get_drvdata(vf_dev);
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
> +		seq_printf(seq, "%s\n", "device not migrated!\n");
> +		return -EAGAIN;
> +	}
> +
> +	seq_hex_dump(seq, "Mig Data:", DUMP_PREFIX_OFFSET, 16, 1,
> +			(unsigned char *)&debug_migf->vf_data,
> +			vf_data_sz, false);
> +
> +	seq_printf(seq,
> +		 "acc device:\n"
> +		 "device  ready: %u\n"
> +		 "device  opened: %d\n"
> +		 "data    valid: %d\n"
> +		 "data     size: %lu\n",
> +		 hisi_acc_vdev->vf_qm_state,
> +		 hisi_acc_vdev->dev_opened,
> +		 debug_migf->disabled,
> +		 debug_migf->total_length);
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
> +	if (!debugfs_initialized() ||
> +	    !IS_ENABLED(CONFIG_VFIO_DEBUGFS))
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
> +		hisi_acc_vdev->debug_migf =3D NULL;
> +		dev_err(dev, "failed to lookup migration debugfs file!\n");
> +		return -ENODEV;
> +	}
> +
> +	vfio_hisi_acc =3D debugfs_create_dir("hisi_acc", vfio_dev_migration);
> +	debugfs_create_devm_seqfile(dev, "dev_data", vfio_hisi_acc,
> +				  hisi_acc_vf_dev_read);
> +	debugfs_create_devm_seqfile(dev, "migf_data", vfio_hisi_acc,
> +				  hisi_acc_vf_migf_read);
> +	debugfs_create_devm_seqfile(dev, "cmd_state", vfio_hisi_acc,
> +				  hisi_acc_vf_debug_cmd);
> +
> +	return 0;
> +}
> +
> +static void hisi_acc_vf_debugfs_exit(struct hisi_acc_vf_core_device
> *hisi_acc_vdev)
> +{
> +	if (!debugfs_initialized() ||
> +	    !IS_ENABLED(CONFIG_VFIO_DEBUGFS))
> +		return;
> +
> +	if (hisi_acc_vdev->debug_migf)
> +		kfree(hisi_acc_vdev->debug_migf);
> +}
> +
>  static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
>  {
>  	struct hisi_acc_vf_core_device *hisi_acc_vdev =3D
> hisi_acc_get_vf_dev(core_vdev);
> @@ -1311,9 +1522,11 @@ static int hisi_acc_vfio_pci_open_device(struct
> vfio_device *core_vdev)
>  			return ret;
>  		}
>  		hisi_acc_vdev->mig_state =3D VFIO_DEVICE_STATE_RUNNING;
> +		hisi_acc_vdev->dev_opened =3D true;
>  	}
>=20
>  	vfio_pci_core_finish_enable(vdev);
> +
>  	return 0;
>  }
>=20
> @@ -1322,7 +1535,10 @@ static void hisi_acc_vfio_pci_close_device(struct
> vfio_device *core_vdev)
>  	struct hisi_acc_vf_core_device *hisi_acc_vdev =3D
> hisi_acc_get_vf_dev(core_vdev);
>  	struct hisi_qm *vf_qm =3D &hisi_acc_vdev->vf_qm;
>=20
> +	mutex_lock(&hisi_acc_vdev->state_mutex);
> +	hisi_acc_vdev->dev_opened =3D false;
>  	iounmap(vf_qm->io_base);
> +	mutex_unlock(&hisi_acc_vdev->state_mutex);
>  	vfio_pci_core_close_device(core_vdev);
>  }
>=20
> @@ -1413,6 +1629,9 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev
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
> @@ -1425,6 +1644,7 @@ static void hisi_acc_vfio_pci_remove(struct pci_dev
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
> index 5bab46602fad..f86f3b88b09e 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> @@ -32,6 +32,7 @@
>  #define QM_SQC_VFT_BASE_MASK_V2		GENMASK(15, 0)
>  #define QM_SQC_VFT_NUM_SHIFT_V2		45
>  #define QM_SQC_VFT_NUM_MASK_V2		GENMASK(9, 0)
> +#define QM_MB_CMD_NOT_READY	0xffffffff
>=20
>  /* RW regs */
>  #define QM_REGS_MAX_LEN		7
> @@ -111,5 +112,10 @@ struct hisi_acc_vf_core_device {
>  	int vf_id;
>  	struct hisi_acc_vf_migration_file *resuming_migf;
>  	struct hisi_acc_vf_migration_file *saving_migf;
> +
> +	/* To make sure the device is opened */
> +	bool dev_opened;
> +	/* To save migration data */
> +	struct hisi_acc_vf_migration_file *debug_migf;
>  };
>  #endif /* HISI_ACC_VFIO_PCI_H */
> --
> 2.24.0


