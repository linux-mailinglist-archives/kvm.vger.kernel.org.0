Return-Path: <kvm+bounces-28603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C340B999EC0
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 10:09:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 623832848F8
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 08:09:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47C3020ADE3;
	Fri, 11 Oct 2024 08:09:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BC61CDA31;
	Fri, 11 Oct 2024 08:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728634172; cv=none; b=qCzjDBY+8tGZAimqeUQSlQ13B8cTB6whBB1XuLhmuHx6rVtOpKMVM1O9vMOutNEjXBfyMMHCEAUj1plw7olix1yC3Btwnx0WaKrYSUCNOXf26ruRtuOt8Wjef1lSg9w1yQWsZhdNX4bzhGmreEwN+ykVDjTIS0tazy+3Kh3GSQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728634172; c=relaxed/simple;
	bh=AdashH52wwCwy8N71iUO2XZjU04DU4pbYNNd/eIOTVk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lwvjZvBB4H2jRkGZv7gy0l/HMKEd6HszDjazVE1tP9pB3yOejgyhlZWCG5OLG1iAwoo6MMXmWWVMmcwYKqtz8P2bSfHNcGBCfJ2tDXLremjIz7kH5Y53VQWVhavzN7VMSWauH0FZ9YhL4IWJ+grXJmQW+kLGdfQgxxuP4VSx0n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XPzmH5N6Zz6JB8F;
	Fri, 11 Oct 2024 16:09:03 +0800 (CST)
Received: from frapeml500007.china.huawei.com (unknown [7.182.85.172])
	by mail.maildlp.com (Postfix) with ESMTPS id A0DDC140581;
	Fri, 11 Oct 2024 16:09:26 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml500007.china.huawei.com (7.182.85.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 11 Oct 2024 10:09:26 +0200
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Fri, 11 Oct 2024 10:09:26 +0200
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: liulongfang <liulongfang@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>, "Jonathan
 Cameron" <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH v9 3/4] hisi_acc_vfio_pci: register debugfs for hisilicon
 migration driver
Thread-Topic: [PATCH v9 3/4] hisi_acc_vfio_pci: register debugfs for hisilicon
 migration driver
Thread-Index: AQHbBcQkh6V22o+1AUK1m5LoEXCq+rKBW/sQ
Date: Fri, 11 Oct 2024 08:09:26 +0000
Message-ID: <25ff48eaa1194484b5b4ef016d01191c@huawei.com>
References: <20240913095502.22940-1-liulongfang@huawei.com>
 <20240913095502.22940-4-liulongfang@huawei.com>
In-Reply-To: <20240913095502.22940-4-liulongfang@huawei.com>
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
> Sent: Friday, September 13, 2024 10:55 AM
> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
> Subject: [PATCH v9 3/4] hisi_acc_vfio_pci: register debugfs for hisilicon
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
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 204 ++++++++++++++++++
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |   7 +
>  2 files changed, 211 insertions(+)
>=20
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index a8c53952d82e..da9f5b9e6c5b 100644
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
> @@ -1294,6 +1309,181 @@ static long hisi_acc_vfio_pci_ioctl(struct
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

Still not very sure this vf_qm ready() check actually helps or not? What gu=
arantee
is there that the qm will stay Ready after this call?  Any read/write after=
wards
will eventually fail if it is not ready  later for some reason, right?=20
Perhaps helps in early detection and bails out.

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
> +	struct acc_vf_data *vf_data =3D NULL;
> +	int ret;
> +
> +	vf_data =3D kzalloc(sizeof(struct acc_vf_data), GFP_KERNEL);
> +	if (!vf_data)
> +		return -ENOMEM;\

You could move the allocation after the below checks and to just before
vf_qm_read_data().

> +
> +	mutex_lock(&hisi_acc_vdev->open_mutex);
> +	ret =3D hisi_acc_vf_debug_check(seq, vdev);
> +	if (ret) {
> +		mutex_unlock(&hisi_acc_vdev->open_mutex);
> +		goto migf_err;
> +	}
> +
> +	mutex_lock(&hisi_acc_vdev->state_mutex);
> +	vf_data->vf_qm_state =3D hisi_acc_vdev->vf_qm_state;
> +	ret =3D vf_qm_read_data(&hisi_acc_vdev->vf_qm, vf_data);
> +	if (ret) {
> +		mutex_unlock(&hisi_acc_vdev->open_mutex);
> +		mutex_unlock(&hisi_acc_vdev->state_mutex);

I think it is better to unlock in the reverse order. Also probably you can =
move
the unlocks to a  goto area.

> +		goto migf_err;
> +	}
> +
> +	mutex_unlock(&hisi_acc_vdev->open_mutex);
> +	mutex_unlock(&hisi_acc_vdev->state_mutex);

Same as above.

> +	seq_hex_dump(seq, "Dev Data:", DUMP_PREFIX_OFFSET, 16, 1,
> +			(unsigned char *)vf_data,
> +			vf_data_sz, false);
> +
> +	seq_printf(seq,
> +		 "acc device:\n"
> +		 "guest driver load: %u\n"
> +		 "data size: %lu\n",
> +		 hisi_acc_vdev->vf_qm_state,
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
> +			(unsigned char *)&debug_migf->vf_data,
> +			vf_data_sz, false);
> +
> +	seq_printf(seq,
> +		 "acc device:\n"
> +		 "guest driver load: %u\n"
> +		 "device opened: %d\n"
> +		 "migrate data length: %lu\n",
> +		 hisi_acc_vdev->vf_qm_state,
> +		 hisi_acc_vdev->dev_opened,
> +		 debug_migf->total_length);
> +
> +	return 0;
> +}
> +
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
> +				  hisi_acc_vf_dev_read);
> +	debugfs_create_devm_seqfile(dev, "migf_data", vfio_hisi_acc,
> +				  hisi_acc_vf_migf_read);
> +	debugfs_create_devm_seqfile(dev, "cmd_state", vfio_hisi_acc,
> +				  hisi_acc_vf_debug_cmd);
> +}
> +
> +static void hisi_acc_vf_debugfs_exit(struct hisi_acc_vf_core_device
> *hisi_acc_vdev)
> +{
> +	if (hisi_acc_vdev->debug_migf) {
> +		kfree(hisi_acc_vdev->debug_migf);
> +		hisi_acc_vdev->debug_migf =3D NULL;
> +	}
> +}
> +
>  static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
>  {
>  	struct hisi_acc_vf_core_device *hisi_acc_vdev =3D
> hisi_acc_get_vf_dev(core_vdev);
> @@ -1305,12 +1495,16 @@ static int hisi_acc_vfio_pci_open_device(struct
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
> @@ -1322,7 +1516,10 @@ static void hisi_acc_vfio_pci_close_device(struct
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
> @@ -1342,6 +1539,7 @@ static int hisi_acc_vfio_pci_migrn_init_dev(struct
> vfio_device *core_vdev)
>  	hisi_acc_vdev->pf_qm =3D pf_qm;
>  	hisi_acc_vdev->vf_dev =3D pdev;
>  	mutex_init(&hisi_acc_vdev->state_mutex);
> +	mutex_init(&hisi_acc_vdev->open_mutex);
>=20
>  	core_vdev->migration_flags =3D VFIO_MIGRATION_STOP_COPY |
> VFIO_MIGRATION_PRE_COPY;
>  	core_vdev->mig_ops =3D &hisi_acc_vfio_pci_migrn_state_ops;
> @@ -1413,6 +1611,9 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev
> *pdev, const struct pci_device
>  	ret =3D vfio_pci_core_register_device(&hisi_acc_vdev->core_device);
>  	if (ret)
>  		goto out_put_vdev;
> +
> +	if (ops =3D=3D &hisi_acc_vfio_pci_migrn_ops)
> +		hisi_acc_vfio_debug_init(hisi_acc_vdev);

I think there was a comment earlier on this. Still not sure why it is not p=
ossible to
move ops =3D=3D &hisi_acc_vfio_pci_migrn_ops check inside hisi_acc_vfio_deb=
ug_init().

>  	return 0;
>=20
>  out_put_vdev:
> @@ -1423,8 +1624,11 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev
> *pdev, const struct pci_device
>  static void hisi_acc_vfio_pci_remove(struct pci_dev *pdev)
>  {
>  	struct hisi_acc_vf_core_device *hisi_acc_vdev =3D
> hisi_acc_drvdata(pdev);
> +	struct vfio_device *vdev =3D &hisi_acc_vdev->core_device.vdev;
>=20
>  	vfio_pci_core_unregister_device(&hisi_acc_vdev->core_device);
> +	if (vdev->ops =3D=3D &hisi_acc_vfio_pci_migrn_ops)
> +		hisi_acc_vf_debugfs_exit(hisi_acc_vdev);

Do we need to do vdev->ops =3D=3D &hisi_acc_vfio_pci_migrn_ops check here?

Since we are checking
   hisi_acc_vdev->debug_migf inside the exit function, which I think is onl=
y
set when the ops =3D=3D migrn_ops. Right?

Thanks,
Shameer


