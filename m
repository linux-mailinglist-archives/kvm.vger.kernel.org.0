Return-Path: <kvm+bounces-43334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CD05A897D4
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 11:25:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E318168FFD
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 09:25:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0787D2820CE;
	Tue, 15 Apr 2025 09:25:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B40205AA3;
	Tue, 15 Apr 2025 09:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744709115; cv=none; b=N5chTOBx/wCV+hPQpyXcciG+zUSYYEZ+YbC2oRoYVSThYpqBd7JKhhu7NMxc4qpKoIDCu2TTUr3OwSB0BJra+gyHKSl9ClA1Dykiq92CylUojQh1GKXBV5Iq4wEMLVggbY1Qk4JwGVQVxbEVXegQGkdjfteiyn4NDQgKvjWnroE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744709115; c=relaxed/simple;
	bh=STTgkUZueXTcQfp5TF055dGrFMr6LZZxoaECsIO7+w8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=l940ufOKh9pf8ziE+lgf6oGyeE2P4HiXpp/vKgo5btww+oB6hyEtwFeYjoal4Z9ezg5z6nF65+ajvdVVY9zTyUhuf7MvN22fPCZ/vL8ERTFwq42Vcz+sO7XZ9c4SMGUjn8LIaDpGr5aGsF5ZMq1QJy8I7NO0VPfv1DcKY8XOhC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ZcJcl5Vhqz6L58S;
	Tue, 15 Apr 2025 17:23:51 +0800 (CST)
Received: from frapeml500007.china.huawei.com (unknown [7.182.85.172])
	by mail.maildlp.com (Postfix) with ESMTPS id 4098F1407DB;
	Tue, 15 Apr 2025 17:25:09 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml500007.china.huawei.com (7.182.85.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 15 Apr 2025 11:25:08 +0200
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Tue, 15 Apr 2025 11:25:08 +0200
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: liulongfang <liulongfang@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>, "Jonathan
 Cameron" <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH v7 6/6] hisi_acc_vfio_pci: update function return values.
Thread-Topic: [PATCH v7 6/6] hisi_acc_vfio_pci: update function return values.
Thread-Index: AQHbqpZ//2t0kcEhp0OCOF/DXXF6prOkeeyQ
Date: Tue, 15 Apr 2025 09:25:08 +0000
Message-ID: <ed4f09039ffb45f3a3d5b418c92ae6ad@huawei.com>
References: <20250411035907.57488-1-liulongfang@huawei.com>
 <20250411035907.57488-7-liulongfang@huawei.com>
In-Reply-To: <20250411035907.57488-7-liulongfang@huawei.com>
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
> Subject: [PATCH v7 6/6] hisi_acc_vfio_pci: update function return values.
>=20
> In this driver file, many functions call sub-functions and use ret
> to store the error code of the sub-functions.
> However, instead of directly returning ret to the caller, they use a
> converted error code, which prevents the end-user from clearly
> understanding the root cause of the error.
> Therefore, the code needs to be modified to directly return the error
> code from the sub-functions.
>=20
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---
>  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index d12a350440d3..c63e302ac092 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -392,7 +392,7 @@ static int vf_qm_check_match(struct
> hisi_acc_vf_core_device *hisi_acc_vdev,
>  	ret =3D vf_qm_version_check(vf_data, dev);
>  	if (ret) {
>  		dev_err(dev, "failed to match ACC_DEV_MAGIC\n");
> -		return -EINVAL;
> +		return ret;
>  	}
>=20
>  	if (vf_data->dev_id !=3D hisi_acc_vdev->vf_dev->device) {
> @@ -404,7 +404,7 @@ static int vf_qm_check_match(struct
> hisi_acc_vf_core_device *hisi_acc_vdev,
>  	ret =3D qm_get_vft(vf_qm, &vf_qm->qp_base);
>  	if (ret <=3D 0) {
>  		dev_err(dev, "failed to get vft qp nums\n");
> -		return -EINVAL;
> +		return ret;
>  	}
>=20
>  	if (ret !=3D vf_data->qp_num) {
> @@ -501,7 +501,7 @@ static int vf_qm_load_data(struct
> hisi_acc_vf_core_device *hisi_acc_vdev,
>  	ret =3D qm_write_regs(qm, QM_VF_STATE, &vf_data->vf_qm_state, 1);
>  	if (ret) {
>  		dev_err(dev, "failed to write QM_VF_STATE\n");
> -		return -EINVAL;
> +		return ret;
>  	}
>  	hisi_acc_vdev->vf_qm_state =3D vf_data->vf_qm_state;
>=20
> @@ -542,7 +542,7 @@ static int vf_qm_read_data(struct hisi_qm *vf_qm,
> struct acc_vf_data *vf_data)
>=20
>  	ret =3D qm_get_regs(vf_qm, vf_data);
>  	if (ret)
> -		return -EINVAL;
> +		return ret;
>=20
>  	/* Every reg is 32 bit, the dma address is 64 bit. */
>  	vf_data->eqe_dma =3D vf_data->qm_eqc_dw[QM_XQC_ADDR_HIGH];
> @@ -556,13 +556,13 @@ static int vf_qm_read_data(struct hisi_qm
> *vf_qm, struct acc_vf_data *vf_data)
>  	ret =3D qm_get_sqc(vf_qm, &vf_data->sqc_dma);
>  	if (ret) {
>  		dev_err(dev, "failed to read SQC addr!\n");
> -		return -EINVAL;
> +		return ret;
>  	}
>=20
>  	ret =3D qm_get_cqc(vf_qm, &vf_data->cqc_dma);
>  	if (ret) {
>  		dev_err(dev, "failed to read CQC addr!\n");
> -		return -EINVAL;
> +		return ret;
>  	}
>=20
>  	return 0;
> @@ -588,7 +588,7 @@ static int vf_qm_state_save(struct
> hisi_acc_vf_core_device *hisi_acc_vdev,
>=20
>  	ret =3D vf_qm_read_data(vf_qm, vf_data);
>  	if (ret)
> -		return -EINVAL;
> +		return ret;
>=20
>  	migf->total_length =3D sizeof(struct acc_vf_data);
>  	/* Save eqc and aeqc interrupt information */
> @@ -1379,7 +1379,7 @@ static int hisi_acc_vf_debug_check(struct seq_file
> *seq, struct vfio_device *vde
>  	ret =3D qm_wait_dev_not_ready(vf_qm);
>  	if (ret) {
>  		seq_puts(seq, "VF device not ready!\n");
> -		return -EBUSY;
> +		return ret;
>  	}
>=20
>  	return 0;

Any reason you avoided few other instances here?

1. qemu_set_regs() --> hisi_qm_wait_mb_ready() -->ret -EBUSY;
2. vf_qm_cache_wb() ret -EINVAL on -ETIMEOUT.

With the above addressed,

Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Thanks,
Shameer


