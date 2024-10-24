Return-Path: <kvm+bounces-29639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 67BFB9AE5C8
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 15:13:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 12E4C1F24C72
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 13:13:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9397B1D89F4;
	Thu, 24 Oct 2024 13:12:53 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78DD914A0AA;
	Thu, 24 Oct 2024 13:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729775573; cv=none; b=utXW0hEfvPG69oFcTyMb7tys4+ISMTrw3a8LiLcoYQjb/LAO5tuc5wG8YWvrmkwDtpDElgx/XYTvl15hD5hpt2dKNZ9DdfjvguM8zxT8n5wtjlgN6t07oeSYWloDbQKXiN5DejFm1stMPduohtarf7abrtjhzupy3mVfdlPYbmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729775573; c=relaxed/simple;
	bh=8l3sQCRA1mxKLjgOc2P2jT7SosiRDno8PcJZwww8RT0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=C6vldgzt3Xe31nAUEuHDMtJ352nq+h/ruJvKBI1XgKRncz4Ffe+efK3SiTExK9klExRVyV15Wi0ApFyhI8F24SNkaGj/nN/NyaIpgIoxXFDYPpMBpXPP3g662x5BNWylEC2nffPiwoOq/FK4BsrfnZigZjUZ5XoQqbwnyhR6DyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XZ5sX60Kdz6D8vG;
	Thu, 24 Oct 2024 21:11:44 +0800 (CST)
Received: from frapeml100006.china.huawei.com (unknown [7.182.85.201])
	by mail.maildlp.com (Postfix) with ESMTPS id B8C7714058E;
	Thu, 24 Oct 2024 21:12:45 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml100006.china.huawei.com (7.182.85.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 24 Oct 2024 15:12:45 +0200
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Thu, 24 Oct 2024 15:12:45 +0200
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: liulongfang <liulongfang@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>, "Jonathan
 Cameron" <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH v10 3/4] hisi_acc_vfio_pci: register debugfs for hisilicon
 migration driver
Thread-Topic: [PATCH v10 3/4] hisi_acc_vfio_pci: register debugfs for
 hisilicon migration driver
Thread-Index: AQHbH2o4p0+8feS/EU+UAnkXuipALLKV7BAg
Date: Thu, 24 Oct 2024 13:12:45 +0000
Message-ID: <bedd3623de984a6fafd24a2c85f6c05e@huawei.com>
References: <20241016012308.14108-1-liulongfang@huawei.com>
 <20241016012308.14108-4-liulongfang@huawei.com>
In-Reply-To: <20241016012308.14108-4-liulongfang@huawei.com>
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
> Sent: Wednesday, October 16, 2024 2:23 AM
> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
> Subject: [PATCH v10 3/4] hisi_acc_vfio_pci: register debugfs for hisilico=
n
> migration driver

[..]
=20
> @@ -1342,6 +1538,7 @@ static int hisi_acc_vfio_pci_migrn_init_dev(struct
> vfio_device *core_vdev)
>  	hisi_acc_vdev->pf_qm =3D pf_qm;
>  	hisi_acc_vdev->vf_dev =3D pdev;
>  	mutex_init(&hisi_acc_vdev->state_mutex);
> +	mutex_init(&hisi_acc_vdev->open_mutex);
>=20
>  	core_vdev->migration_flags =3D VFIO_MIGRATION_STOP_COPY |
> VFIO_MIGRATION_PRE_COPY;
>  	core_vdev->mig_ops =3D &hisi_acc_vfio_pci_migrn_state_ops;
> @@ -1413,6 +1610,9 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev
> *pdev, const struct pci_device
>  	ret =3D vfio_pci_core_register_device(&hisi_acc_vdev->core_device);
>  	if (ret)
>  		goto out_put_vdev;
> +
> +	if (ops =3D=3D &hisi_acc_vfio_pci_migrn_ops)
> +		hisi_acc_vfio_debug_init(hisi_acc_vdev);

As commented earlier, the ops check can be moved to the debug_init() functi=
on=20
and you can remove ops check for the debug_exit() below. You may have to
rearrange the functions to avoid the compiler error you mentioned in previo=
us
version to do so.

>  	return 0;
>=20
>  out_put_vdev:
> @@ -1423,8 +1623,11 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev
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

As mentioned above remove the ops check here.

With the above ones checked and  fixed,
Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

