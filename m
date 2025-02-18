Return-Path: <kvm+bounces-38420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B2674A399C0
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 11:59:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA149188C9BD
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 10:59:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D526223956F;
	Tue, 18 Feb 2025 10:58:51 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDCD13D51E;
	Tue, 18 Feb 2025 10:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739876331; cv=none; b=DCYYC2nrQRP9yuUgnvG1fpRu7uSJvCOiNu+U1Y1yjb6beVZS4mPUrpjJPIKNJwcsAWpwmxB3ydjTvOFQou3errL9ZyJk5RfEYRWDTxoTtZUemkrpseF8ZeWJQe+YYSWmJDkj7gJxc0g0/NTIQOpS7CpkKO/btKks0tUZUmXIQCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739876331; c=relaxed/simple;
	bh=iKnuvPAFyjaJZ2Hb2hiO75EaMpLf7xoMbImYdpyFDEE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=osGBK/QfDTuxYQml4ZCn0D9sBrniOpF3EX3TDquH+hMl3JZrdXPxPhGhkJB141bhr5us65RgX9Kt8nKGfjpQOPWB+A4cX0gSe/rRVn5cEYvA9QbXr0VPkCNvvjFyHaLjydBN3v+MhrSEaqN0doFUGJTmorugiXK/dJDhzvpXe7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4YxxLJ5lPjz6GD8S;
	Tue, 18 Feb 2025 18:57:12 +0800 (CST)
Received: from frapeml100008.china.huawei.com (unknown [7.182.85.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 4860E140B33;
	Tue, 18 Feb 2025 18:58:45 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml100008.china.huawei.com (7.182.85.131) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 18 Feb 2025 11:58:45 +0100
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Tue, 18 Feb 2025 11:58:45 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: liulongfang <liulongfang@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>, "Jonathan
 Cameron" <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH 3/3] migration: adapt to new migration configuration
Thread-Topic: [PATCH 3/3] migration: adapt to new migration configuration
Thread-Index: AQHbgasfpWViJMA7d0C64ALSy1cFErNM47rQ
Date: Tue, 18 Feb 2025 10:58:44 +0000
Message-ID: <23e896a0788f4fc59b25b58be059a0f8@huawei.com>
References: <20250218021507.40740-1-liulongfang@huawei.com>
 <20250218021507.40740-4-liulongfang@huawei.com>
In-Reply-To: <20250218021507.40740-4-liulongfang@huawei.com>
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
> Sent: Tuesday, February 18, 2025 2:15 AM
> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
> Subject: [PATCH 3/3] migration: adapt to new migration configuration
>=20
> On the new hardware platform, the migration region is moved from
> VF to PF. the driver also needs to be modified accordingly to adapt
> to the new hardware device.
>=20
> Use PF's io base directly on the new hardware platform. and no mmap
> operation is required.
> If it is on an old platform, the driver needs to be compatible with
> the old solution.


I see that you have used "new hardware platform" everywhere and I think
it is better we make it more specific, like QM_HW_V4?

Also it is not clear to me, what happens if you try migration between
QM_HW_V3 <--> QM_HW_V4? Is that going to be success or we are
failing it somewhere? I see only the dev_id check in vf_qm_check_match().

Thanks,
Shameer

> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 165 ++++++++++++------
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |   7 +
>  2 files changed, 119 insertions(+), 53 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index 599905dbb707..cf5a807c2199 100644
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
> @@ -238,20 +290,6 @@ static int qm_set_regs(struct hisi_qm *qm, struct
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
> @@ -470,6 +508,10 @@ static int vf_qm_load_data(struct
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
> @@ -544,6 +586,10 @@ static int vf_qm_state_save(struct
> hisi_acc_vf_core_device *hisi_acc_vdev,
>  		return ret;
>  	}
>=20
> +	ret =3D qm_get_xqc_regs(hisi_acc_vdev, vf_data);
> +	if (ret)
> +		return -EINVAL;
> +
>  	ret =3D vf_qm_read_data(vf_qm, vf_data);
>  	if (ret)
>  		return -EINVAL;
> @@ -1131,34 +1177,46 @@ static int hisi_acc_vf_qm_init(struct
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
> +		 * In the new HW platform, the migration function register
> space is in BAR2 of PF,
> +		 * and each VF occupies 8KB address space.
> +		 */
> +		vf_qm->io_base =3D pf_qm->io_base +
> QM_MIG_REGION_OFFSET +
> +				hisi_acc_vdev->vf_id *
> QM_MIG_REGION_SIZE;
> +		vf_qm->fun_type =3D QM_HW_PF;
> +	}
>  	vf_qm->pdev =3D vf_dev;
>  	mutex_init(&vf_qm->mailbox_lock);
>=20
> @@ -1488,7 +1546,8 @@ static void hisi_acc_vfio_pci_close_device(struct
> vfio_device *core_vdev)
>=20
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
> index 245d7537b2bc..b01eb54525d3 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> @@ -50,6 +50,13 @@
>  #define QM_EQC_DW0		0X8000
>  #define QM_AEQC_DW0		0X8020
>=20
> +#define QM_MIG_REGION_OFFSET	0x180000
> +#define QM_MIG_REGION_SIZE	0x2000
> +
> +#define QM_SUB_VERSION_ID		0x100210
> +#define QM_EQC_PF_DW0		0x1c00
> +#define QM_AEQC_PF_DW0		0x1c20
> +
>  struct acc_vf_data {
>  #define QM_MATCH_SIZE offsetofend(struct acc_vf_data, qm_rsv_state)
>  	/* QM match information */
> --
> 2.24.0


