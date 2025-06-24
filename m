Return-Path: <kvm+bounces-50454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F05CFAE5D70
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 09:10:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7CECD16FEC8
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 07:10:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C320525334B;
	Tue, 24 Jun 2025 07:10:07 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD3F335BA;
	Tue, 24 Jun 2025 07:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750749007; cv=none; b=I54WHSVYufGh+7G0drQTF4Z48C9b44VNMdrcrg0OExowoLSK76wOXHutnrdugpEZHOHbEibvyuLkyfGtlgeqFAOPLpg8jfW8KzYpktnflxMdyefgl4qVe5yAVuUicl1Xguc5ijKrOWHvJ9gvZSHFul+lDmwBwGyLH1pXhhwhd8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750749007; c=relaxed/simple;
	bh=KMvPW7OLB7Siy5biU5OiQT+dXvvVkWpkUR7VJEzstE4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aj6MVhVUljH6MT2YcbDgIAg7lfjrGzpTsseBinUJYl82Pn69yZkneUi/ll1L7ngTFojOUoWJst+lzdWV5WwQmApvQVW9ODKoIbWF08Iaj25hi3+GF/B0IExOQpOjFNMBBStWmUdyjpifHBttAMWOCJq1zhNwjE/AKwfhWpwzZn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4bRGKC0pCFz6DBDg;
	Tue, 24 Jun 2025 15:09:19 +0800 (CST)
Received: from frapeml100008.china.huawei.com (unknown [7.182.85.131])
	by mail.maildlp.com (Postfix) with ESMTPS id EA603140426;
	Tue, 24 Jun 2025 15:10:02 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml100008.china.huawei.com (7.182.85.131) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 24 Jun 2025 09:10:02 +0200
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Tue, 24 Jun 2025 09:10:02 +0200
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: liulongfang <liulongfang@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>, "Jonathan
 Cameron" <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH v4 3/3] migration: adapt to new migration configuration
Thread-Topic: [PATCH v4 3/3] migration: adapt to new migration configuration
Thread-Index: AQHb2dHLAbqqxFlAV0CRiOD0YrU0U7QR+alg
Date: Tue, 24 Jun 2025 07:10:02 +0000
Message-ID: <45acec4593174305ac84a0fb37df36be@huawei.com>
References: <20250610063251.27526-1-liulongfang@huawei.com>
 <20250610063251.27526-4-liulongfang@huawei.com>
In-Reply-To: <20250610063251.27526-4-liulongfang@huawei.com>
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
> Sent: Tuesday, June 10, 2025 7:33 AM
> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
> Subject: [PATCH v4 3/3] migration: adapt to new migration configuration
>=20
> On the new hardware platform, the migration region has been
> relocated from the VF to the PF. The driver must also be modified
> accordingly to adapt to the new hardware device.
>=20
> Utilize the PF's I/O base directly on the new hardware platform,
> and no mmap operation is required. If it is on an old platform,
> the driver needs to be compatible with the old solution.
>=20
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 166 ++++++++++++------
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |   7 +
>  2 files changed, 120 insertions(+), 53 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index b16115f590fd..ab815fa4258c 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -125,6 +125,72 @@ static int qm_get_cqc(struct hisi_qm *qm, u64
> *addr)
>  	return 0;
>  }
>=20
> +static int qm_get_xqc_regs(struct hisi_acc_vf_core_device *hisi_acc_vdev=
,
> +			   struct acc_vf_data *vf_data)
> +{
> +	struct hisi_qm *qm =3D &hisi_acc_vdev->vf_qm;
> +	struct device *dev =3D &qm->pdev->dev;
> +	u32 eqc_addr, aeqc_addr;
> +	int ret;
> +
> +	if (qm->ver =3D=3D QM_HW_V3) {
> +		eqc_addr =3D QM_EQC_DW0;
> +		aeqc_addr =3D QM_AEQC_DW0;
> +	} else {
> +		eqc_addr =3D QM_EQC_PF_DW0;
> +		aeqc_addr =3D QM_AEQC_PF_DW0;
> +	}
> +
> +	/* QM_EQC_DW has 7 regs */
> +	ret =3D qm_read_regs(qm, eqc_addr, vf_data->qm_eqc_dw, 7);
> +	if (ret) {
> +		dev_err(dev, "failed to read QM_EQC_DW\n");
> +		return ret;
> +	}
> +
> +	/* QM_AEQC_DW has 7 regs */
> +	ret =3D qm_read_regs(qm, aeqc_addr, vf_data->qm_aeqc_dw, 7);
> +	if (ret) {
> +		dev_err(dev, "failed to read QM_AEQC_DW\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int qm_set_xqc_regs(struct hisi_acc_vf_core_device *hisi_acc_vdev=
,
> +			   struct acc_vf_data *vf_data)
> +{
> +	struct hisi_qm *qm =3D &hisi_acc_vdev->vf_qm;
> +	struct device *dev =3D &qm->pdev->dev;
> +	u32 eqc_addr, aeqc_addr;
> +	int ret;
> +
> +	if (qm->ver =3D=3D QM_HW_V3) {
> +		eqc_addr =3D QM_EQC_DW0;
> +		aeqc_addr =3D QM_AEQC_DW0;
> +	} else {
> +		eqc_addr =3D QM_EQC_PF_DW0;
> +		aeqc_addr =3D QM_AEQC_PF_DW0;
> +	}
> +
> +	/* QM_EQC_DW has 7 regs */
> +	ret =3D qm_write_regs(qm, eqc_addr, vf_data->qm_eqc_dw, 7);
> +	if (ret) {
> +		dev_err(dev, "failed to write QM_EQC_DW\n");
> +		return ret;
> +	}
> +
> +	/* QM_AEQC_DW has 7 regs */
> +	ret =3D qm_write_regs(qm, aeqc_addr, vf_data->qm_aeqc_dw, 7);
> +	if (ret) {
> +		dev_err(dev, "failed to write QM_AEQC_DW\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
>  static int qm_get_regs(struct hisi_qm *qm, struct acc_vf_data *vf_data)
>  {
>  	struct device *dev =3D &qm->pdev->dev;
> @@ -167,20 +233,6 @@ static int qm_get_regs(struct hisi_qm *qm, struct
> acc_vf_data *vf_data)
>  		return ret;
>  	}
>=20
> -	/* QM_EQC_DW has 7 regs */
> -	ret =3D qm_read_regs(qm, QM_EQC_DW0, vf_data->qm_eqc_dw, 7);
> -	if (ret) {
> -		dev_err(dev, "failed to read QM_EQC_DW\n");
> -		return ret;
> -	}
> -
> -	/* QM_AEQC_DW has 7 regs */
> -	ret =3D qm_read_regs(qm, QM_AEQC_DW0, vf_data->qm_aeqc_dw,
> 7);
> -	if (ret) {
> -		dev_err(dev, "failed to read QM_AEQC_DW\n");
> -		return ret;
> -	}
> -
>  	return 0;
>  }
>=20
> @@ -239,20 +291,6 @@ static int qm_set_regs(struct hisi_qm *qm, struct
> acc_vf_data *vf_data)
>  		return ret;
>  	}
>=20
> -	/* QM_EQC_DW has 7 regs */
> -	ret =3D qm_write_regs(qm, QM_EQC_DW0, vf_data->qm_eqc_dw, 7);
> -	if (ret) {
> -		dev_err(dev, "failed to write QM_EQC_DW\n");
> -		return ret;
> -	}
> -
> -	/* QM_AEQC_DW has 7 regs */
> -	ret =3D qm_write_regs(qm, QM_AEQC_DW0, vf_data->qm_aeqc_dw,
> 7);
> -	if (ret) {
> -		dev_err(dev, "failed to write QM_AEQC_DW\n");
> -		return ret;
> -	}
> -
>  	return 0;
>  }
>=20
> @@ -522,6 +560,10 @@ static int vf_qm_load_data(struct
> hisi_acc_vf_core_device *hisi_acc_vdev,
>  		return ret;
>  	}
>=20
> +	ret =3D qm_set_xqc_regs(hisi_acc_vdev, vf_data);
> +	if (ret)
> +		return ret;
> +
>  	ret =3D hisi_qm_mb(qm, QM_MB_CMD_SQC_BT, qm->sqc_dma, 0, 0);
>  	if (ret) {
>  		dev_err(dev, "set sqc failed\n");
> @@ -589,6 +631,10 @@ static int vf_qm_state_save(struct
> hisi_acc_vf_core_device *hisi_acc_vdev,
>  	vf_data->vf_qm_state =3D QM_READY;
>  	hisi_acc_vdev->vf_qm_state =3D vf_data->vf_qm_state;
>=20
> +	ret =3D qm_get_xqc_regs(hisi_acc_vdev, vf_data);
> +	if (ret)
> +		return ret;
> +
>  	ret =3D vf_qm_read_data(vf_qm, vf_data);
>  	if (ret)
>  		return ret;
> @@ -1186,34 +1232,47 @@ static int hisi_acc_vf_qm_init(struct
> hisi_acc_vf_core_device *hisi_acc_vdev)
>  {
>  	struct vfio_pci_core_device *vdev =3D &hisi_acc_vdev->core_device;
>  	struct hisi_qm *vf_qm =3D &hisi_acc_vdev->vf_qm;
> +	struct hisi_qm *pf_qm =3D hisi_acc_vdev->pf_qm;
>  	struct pci_dev *vf_dev =3D vdev->pdev;
>=20
> -	/*
> -	 * ACC VF dev BAR2 region consists of both functional register space
> -	 * and migration control register space. For migration to work, we
> -	 * need access to both. Hence, we map the entire BAR2 region here.
> -	 * But unnecessarily exposing the migration BAR region to the Guest
> -	 * has the potential to prevent/corrupt the Guest migration. Hence,
> -	 * we restrict access to the migration control space from
> -	 * Guest(Please see mmap/ioctl/read/write override functions).
> -	 *
> -	 * Please note that it is OK to expose the entire VF BAR if migration
> -	 * is not supported or required as this cannot affect the ACC PF
> -	 * configurations.
> -	 *
> -	 * Also the HiSilicon ACC VF devices supported by this driver on
> -	 * HiSilicon hardware platforms are integrated end point devices
> -	 * and the platform lacks the capability to perform any PCIe P2P
> -	 * between these devices.
> -	 */
> +	if (pf_qm->ver =3D=3D QM_HW_V3) {
> +		/*
> +		 * ACC VF dev BAR2 region consists of both functional
> register space
> +		 * and migration control register space. For migration to
> work, we
> +		 * need access to both. Hence, we map the entire BAR2
> region here.
> +		 * But unnecessarily exposing the migration BAR region to
> the Guest
> +		 * has the potential to prevent/corrupt the Guest migration.
> Hence,
> +		 * we restrict access to the migration control space from
> +		 * Guest(Please see mmap/ioctl/read/write override
> functions).
> +		 *
> +		 * Please note that it is OK to expose the entire VF BAR if
> migration
> +		 * is not supported or required as this cannot affect the ACC
> PF
> +		 * configurations.
> +		 *
> +		 * Also the HiSilicon ACC VF devices supported by this driver
> on
> +		 * HiSilicon hardware platforms are integrated end point
> devices
> +		 * and the platform lacks the capability to perform any PCIe
> P2P
> +		 * between these devices.
> +		 */
>=20
> -	vf_qm->io_base =3D
> -		ioremap(pci_resource_start(vf_dev,
> VFIO_PCI_BAR2_REGION_INDEX),
> -			pci_resource_len(vf_dev,
> VFIO_PCI_BAR2_REGION_INDEX));
> -	if (!vf_qm->io_base)
> -		return -EIO;
> +		vf_qm->io_base =3D
> +			ioremap(pci_resource_start(vf_dev,
> VFIO_PCI_BAR2_REGION_INDEX),
> +				pci_resource_len(vf_dev,
> VFIO_PCI_BAR2_REGION_INDEX));
> +		if (!vf_qm->io_base)
> +			return -EIO;
>=20
> -	vf_qm->fun_type =3D QM_HW_VF;
> +		vf_qm->fun_type =3D QM_HW_VF;
> +		vf_qm->ver =3D pf_qm->ver;
> +	} else {
> +		/*
> +		 * On the new HW device, the migration function register is


What is the "new HW device"? Please make it specific. Also I think you shou=
ld
check it specifically.

One  more question is what will happen if you try to migrate between a=20
QM_HW_V3 <--> QM_HW_V4? Will it succeed or do we need to block it?

Thanks,
Shameer

> placed
> +		 * in the BAR2 configuration region of the PF, and each VF
> device
> +		 * occupies 8KB of configuration space.
> +		 */
> +		vf_qm->io_base =3D pf_qm->io_base +
> QM_MIG_REGION_OFFSET +
> +				 hisi_acc_vdev->vf_id *
> QM_MIG_REGION_SIZE;
> +		vf_qm->fun_type =3D QM_HW_PF;
> +	}
>  	vf_qm->pdev =3D vf_dev;
>  	mutex_init(&vf_qm->mailbox_lock);
>=20
> @@ -1539,7 +1598,8 @@ static void hisi_acc_vfio_pci_close_device(struct
> vfio_device *core_vdev)
>  	hisi_acc_vf_disable_fds(hisi_acc_vdev);
>  	mutex_lock(&hisi_acc_vdev->open_mutex);
>  	hisi_acc_vdev->dev_opened =3D false;
> -	iounmap(vf_qm->io_base);
> +	if (vf_qm->ver =3D=3D QM_HW_V3)
> +		iounmap(vf_qm->io_base);
>  	mutex_unlock(&hisi_acc_vdev->open_mutex);
>  	vfio_pci_core_close_device(core_vdev);
>  }
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> index 91002ceeebc1..348f8bb5b42c 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> @@ -59,6 +59,13 @@
>  #define ACC_DEV_MAGIC_V1	0XCDCDCDCDFEEDAACC
>  #define ACC_DEV_MAGIC_V2	0xAACCFEEDDECADEDE
>=20
> +#define QM_MIG_REGION_OFFSET		0x180000
> +#define QM_MIG_REGION_SIZE		0x2000
> +
> +#define QM_SUB_VERSION_ID		0x100210
> +#define QM_EQC_PF_DW0			0x1c00
> +#define QM_AEQC_PF_DW0			0x1c20
> +
>  struct acc_vf_data {
>  #define QM_MATCH_SIZE offsetofend(struct acc_vf_data, qm_rsv_state)
>  	/* QM match information */
> --
> 2.24.0


