Return-Path: <kvm+bounces-43333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C835A8970C
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 10:46:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 08E84189DFD1
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 08:46:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44BD123D2B8;
	Tue, 15 Apr 2025 08:46:13 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363001624CE;
	Tue, 15 Apr 2025 08:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744706772; cv=none; b=mfWaDZBXkasH2YDbWL9dEQID9EYoQYe+A04ludapWIk6gO5MMh9yDd7ROToXlB8yRlJCC90CTMrfJqv+djB2ksRPDLZD7QO+JKhT+oUIzePhXf0oquVBNOP1Q4AgT+eMbf2l48VqG/5MrCbGvToLIr7YBA4kphFb7Sv5hg1dF/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744706772; c=relaxed/simple;
	bh=Zal1vB4/CjpCn4zhUmyPxGXyDUBEisOOVrm7EP6jMY8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=S1Zi6BEFatykpKsEC0ov1OjimSApgW7wbePulqe7eZBDUCc+JTt3K4Ko5pohjYeTUVlqVhEMoIov4GuhG0J7dxUwYveLOj83AO1+VGiX2g8RTSLBZZKGtmsWv/d1U1toufNl92Zz5WUppXULQbI8jeJR6DJI9FHisjERu50gmaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ZcHlj0MNdz6L569;
	Tue, 15 Apr 2025 16:44:49 +0800 (CST)
Received: from frapeml500007.china.huawei.com (unknown [7.182.85.172])
	by mail.maildlp.com (Postfix) with ESMTPS id 7039A1402C3;
	Tue, 15 Apr 2025 16:46:06 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml500007.china.huawei.com (7.182.85.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 15 Apr 2025 10:45:48 +0200
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Tue, 15 Apr 2025 10:45:48 +0200
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: liulongfang <liulongfang@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>, "Jonathan
 Cameron" <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH v7 5/6] hisi_acc_vfio_pci: bugfix live migration function
 without VF device driver
Thread-Topic: [PATCH v7 5/6] hisi_acc_vfio_pci: bugfix live migration function
 without VF device driver
Thread-Index: AQHbqpZtmI8lrzOcs0KGDh+tl2173rOkbyAA
Date: Tue, 15 Apr 2025 08:45:48 +0000
Message-ID: <937a11b53cca42ef94d8383608a10f59@huawei.com>
References: <20250411035907.57488-1-liulongfang@huawei.com>
 <20250411035907.57488-6-liulongfang@huawei.com>
In-Reply-To: <20250411035907.57488-6-liulongfang@huawei.com>
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
> Sent: Friday, April 11, 2025 4:59 AM
> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
> Subject: [PATCH v7 5/6] hisi_acc_vfio_pci: bugfix live migration function
> without VF device driver
>=20
> If the VF device driver is not loaded in the Guest OS and we attempt to
> perform device data migration, the address of the migrated data will
> be NULL.
> The live migration recovery operation on the destination side will
> access a null address value, which will cause access errors.
>=20
> Therefore, live migration of VMs without added VF device drivers
> does not require device data migration.
> In addition, when the queue address data obtained by the destination
> is empty, device queue recovery processing will not be performed.
>=20
> Fixes: b0eed085903e ("hisi_acc_vfio_pci: Add support for VFIO live
> migration")
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> Reviewed-by: Shameer Kolothum
> <shameerali.kolothum.thodi@huawei.com>
> ---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 22 +++++++++++++------
>  1 file changed, 15 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index cadc82419dca..d12a350440d3 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -426,13 +426,6 @@ static int vf_qm_check_match(struct
> hisi_acc_vf_core_device *hisi_acc_vdev,
>  		return -EINVAL;
>  	}
>=20
> -	ret =3D qm_write_regs(vf_qm, QM_VF_STATE, &vf_data->vf_qm_state,
> 1);
> -	if (ret) {
> -		dev_err(dev, "failed to write QM_VF_STATE\n");
> -		return ret;
> -	}
> -
> -	hisi_acc_vdev->vf_qm_state =3D vf_data->vf_qm_state;
>  	hisi_acc_vdev->match_done =3D true;
>  	return 0;
>  }
> @@ -498,6 +491,20 @@ static int vf_qm_load_data(struct
> hisi_acc_vf_core_device *hisi_acc_vdev,
>  	if (migf->total_length < sizeof(struct acc_vf_data))
>  		return -EINVAL;
>=20
> +	if (!vf_data->eqe_dma || !vf_data->aeqe_dma ||
> +	    !vf_data->sqc_dma || !vf_data->cqc_dma) {
> +		dev_info(dev, "resume dma addr is NULL!\n");
> +		hisi_acc_vdev->vf_qm_state =3D QM_NOT_READY;
> +		return 0;
> +	}


I am still not fully understood why we need the above check. The only case =
as
far as I can think of where this will happen is when the source VM Guest ha=
s
not loaded the ACC driver. And we do take care of that already using vf_qm_=
state and
checking total_length =3D=3D QM_MATCH_SIZE.

Have you seen this happening in any other scenario during your tests?

Thanks,
Shameer

> +
> +	ret =3D qm_write_regs(qm, QM_VF_STATE, &vf_data->vf_qm_state, 1);
> +	if (ret) {
> +		dev_err(dev, "failed to write QM_VF_STATE\n");
> +		return -EINVAL;
> +	}
> +	hisi_acc_vdev->vf_qm_state =3D vf_data->vf_qm_state;
> +
>  	qm->eqe_dma =3D vf_data->eqe_dma;
>  	qm->aeqe_dma =3D vf_data->aeqe_dma;
>  	qm->sqc_dma =3D vf_data->sqc_dma;
> @@ -1531,6 +1538,7 @@ static int hisi_acc_vfio_pci_migrn_init_dev(struct
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


