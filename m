Return-Path: <kvm+bounces-39264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AFAF4A45A13
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 10:26:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 267023AC8B9
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 09:26:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B31C9226CF6;
	Wed, 26 Feb 2025 09:26:13 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2924215189;
	Wed, 26 Feb 2025 09:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740561973; cv=none; b=WVqqoUNsKprQv3KPcYyxR8evjuJc8p9A/jR35aaLorNcXiEnKy4OdRHvSTWVELmMZ0R1Yz6BpD+OciptqlicmtPiRcCccnKcaMVgzh3gznhKjPSzVoUhYbUsOjRa8vWhgwm2QELGB7IOUL0OGmKjVDJm96P+UHRcMtu1HFt4lLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740561973; c=relaxed/simple;
	bh=snXsEhf+LNi9fdlosqnbK4Qm4UNaUVu8+oUbUR/A6+M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ce68aP8A0HTTc4W08baic+o3oINx26Lpf1Ak+qLubh20zDdD8P1SCf8E39bdHqQOgq0saNpbo3re6w3VjxtwceiuXYWS77C7/HtJm+mgHuK6KjhFup+R0xg7eI64OndqHt4m829ws/ajw7B06Oxrb3XQ0Igt6BajoyQz1TG4hbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Z2pvJ1wwcz6K9Fn;
	Wed, 26 Feb 2025 17:24:12 +0800 (CST)
Received: from frapeml500005.china.huawei.com (unknown [7.182.85.13])
	by mail.maildlp.com (Postfix) with ESMTPS id 72B0814097D;
	Wed, 26 Feb 2025 17:26:07 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml500005.china.huawei.com (7.182.85.13) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 26 Feb 2025 10:26:07 +0100
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Wed, 26 Feb 2025 10:26:07 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: liulongfang <liulongfang@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>, "Jonathan
 Cameron" <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH v4 5/5] hisi_acc_vfio_pci: bugfix live migration function
 without VF device driver
Thread-Topic: [PATCH v4 5/5] hisi_acc_vfio_pci: bugfix live migration function
 without VF device driver
Thread-Index: AQHbh07C3f9e7H+vQ0mq3v4m2vU4obNZTIOQ
Date: Wed, 26 Feb 2025 09:26:07 +0000
Message-ID: <fa8cd8c1cdbe4849b445ffd8f4894515@huawei.com>
References: <20250225062757.19692-1-liulongfang@huawei.com>
 <20250225062757.19692-6-liulongfang@huawei.com>
In-Reply-To: <20250225062757.19692-6-liulongfang@huawei.com>
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
> Sent: Tuesday, February 25, 2025 6:28 AM
> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
> Subject: [PATCH v4 5/5] hisi_acc_vfio_pci: bugfix live migration function
> without VF device driver
>=20
> If the driver of the VF device is not loaded in the Guest OS,
> then perform device data migration. The migrated data address will
> be NULL.

May be rephrase:

If the VF device driver is not loaded in the Guest OS and we attempt to
perform device data migration, the address of the migrated data will
be NULL.

> The live migration recovery operation on the destination side will
> access a null address value, which will cause access errors.
=20
> Therefore, live migration of VMs without added VF device drivers
> does not require device data migration.
> In addition, when the queue address data obtained by the destination
> is empty, device queue recovery processing will not be performed.
>=20
> Fixes: b0eed085903e ("hisi_acc_vfio_pci: Add support for VFIO live
> migration")
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---
>  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>=20
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index 3f0bcd855839..77872fc4cd34 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -440,6 +440,7 @@ static int vf_qm_get_match_data(struct
> hisi_acc_vf_core_device *hisi_acc_vdev,
>  				struct acc_vf_data *vf_data)
>  {
>  	struct hisi_qm *pf_qm =3D hisi_acc_vdev->pf_qm;
> +	struct hisi_qm *vf_qm =3D &hisi_acc_vdev->vf_qm;
>  	struct device *dev =3D &pf_qm->pdev->dev;
>  	int vf_id =3D hisi_acc_vdev->vf_id;
>  	int ret;
> @@ -466,6 +467,13 @@ static int vf_qm_get_match_data(struct
> hisi_acc_vf_core_device *hisi_acc_vdev,
>  		return ret;
>  	}
>=20
> +	/* Get VF driver insmod state */
> +	ret =3D qm_read_regs(vf_qm, QM_VF_STATE, &vf_data->vf_qm_state,
> 1);

We already have qm_wait_dev_not_ready() function that checks the QM_VF_STAT=
E.=20
Why can't we use that here?

Also we are getting this vf_qm_state already in vf_qm_state_save(). And you=
 don't
seem to check the vf_qm_state in vf_qm_check_match(). So why it is read=20
early in this function?


Thanks,
Shameer

> +	if (ret) {
> +		dev_err(dev, "failed to read QM_VF_STATE!\n");
> +		return ret;
> +	}
> +
>  	return 0;
>  }
>=20
> @@ -505,6 +513,12 @@ static int vf_qm_load_data(struct
> hisi_acc_vf_core_device *hisi_acc_vdev,
>  	qm->qp_base =3D vf_data->qp_base;
>  	qm->qp_num =3D vf_data->qp_num;
>=20
> +	if (!vf_data->eqe_dma || !vf_data->aeqe_dma ||
> +	    !vf_data->sqc_dma || !vf_data->cqc_dma) {
> +		dev_err(dev, "resume dma addr is NULL!\n");
> +		return -EINVAL;
> +	}
> +
>  	ret =3D qm_set_regs(qm, vf_data);
>  	if (ret) {
>  		dev_err(dev, "set VF regs failed\n");
> @@ -727,6 +741,9 @@ static int hisi_acc_vf_load_state(struct
> hisi_acc_vf_core_device *hisi_acc_vdev)
>  	struct hisi_acc_vf_migration_file *migf =3D hisi_acc_vdev-
> >resuming_migf;
>  	int ret;
>=20
> +	if (hisi_acc_vdev->vf_qm_state !=3D QM_READY)
> +		return 0;
> +
>  	/* Recover data to VF */
>  	ret =3D vf_qm_load_data(hisi_acc_vdev, migf);
>  	if (ret) {
> @@ -1530,6 +1547,7 @@ static int hisi_acc_vfio_pci_migrn_init_dev(struct
> vfio_device *core_vdev)
>  	hisi_acc_vdev->vf_id =3D pci_iov_vf_id(pdev) + 1;
>  	hisi_acc_vdev->pf_qm =3D pf_qm;
>  	hisi_acc_vdev->vf_dev =3D pdev;
> +	hisi_acc_vdev->vf_qm_state =3D QM_NOT_READY;
>  	mutex_init(&hisi_acc_vdev->state_mutex);
>  	mutex_init(&hisi_acc_vdev->open_mutex);
>=20
> --
> 2.24.0


