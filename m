Return-Path: <kvm+bounces-34136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BA8059F791E
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 11:03:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 07C5216D5C3
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 10:02:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6064322256E;
	Thu, 19 Dec 2024 10:01:54 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC97222568;
	Thu, 19 Dec 2024 10:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734602513; cv=none; b=jR2a17uRHwA6paX3C0yA/v1R+lnPgsQn/Mqd4ikCh4dqeXLNUceV8GvtA0RKRy2Ipp0vbiBr7WZSbTmozL4nrENkQivtoLev3LTsu+zFIzuiHCdkqHttQ8VILpGAZsvrMmbZK7LWV2dVEq33L0Gp5fSfQKQcKVx800F3IeQ1iic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734602513; c=relaxed/simple;
	bh=jZIQujhrzpF88cFsNA5aYOgOk/UYFHiZiyKbJpaLwsU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=T13UI2sab3n7j1ixyJ8or+X8N7fTyzUDzXm6REoP7WZtrwdg6e7gumyK+Q8JR3jmb+zti3DwIT6LsezQVTJ8vDlsSDZUrROUEPEIiO5jlwZudG7qSPK4KcE99LpPMqlakRgiPM9iyddGllrImhqN7V2SHt/an9NSaVqN6DMEhy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4YDQwM5LKHz6HJgC;
	Thu, 19 Dec 2024 17:58:11 +0800 (CST)
Received: from frapeml100008.china.huawei.com (unknown [7.182.85.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 0FB24140133;
	Thu, 19 Dec 2024 18:01:50 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml100008.china.huawei.com (7.182.85.131) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 19 Dec 2024 11:01:49 +0100
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Thu, 19 Dec 2024 11:01:49 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: liulongfang <liulongfang@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>, "Jonathan
 Cameron" <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH v2 4/5] hisi_acc_vfio_pci: bugfix the problem of
 uninstalling driver
Thread-Topic: [PATCH v2 4/5] hisi_acc_vfio_pci: bugfix the problem of
 uninstalling driver
Thread-Index: AQHbUfdXF9fcgrR0EEaxzuZgh8D7aLLtUWHA
Date: Thu, 19 Dec 2024 10:01:49 +0000
Message-ID: <743007b791a34489b34d78328e895062@huawei.com>
References: <20241219091800.41462-1-liulongfang@huawei.com>
 <20241219091800.41462-5-liulongfang@huawei.com>
In-Reply-To: <20241219091800.41462-5-liulongfang@huawei.com>
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
> Sent: Thursday, December 19, 2024 9:18 AM
> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
> Subject: [PATCH v2 4/5] hisi_acc_vfio_pci: bugfix the problem of uninstal=
ling
> driver
>=20
> In a live migration scenario. If the number of VFs at the destination is
> greater than the source, the recovery operation will fail and qemu will n=
ot
> be able to complete the process and exit after shutting down the device F=
D.
>=20
> This will cause the driver to be unable to be unloaded normally due to
> abnormal reference counting of the live migration driver caused by the
> abnormal closing operation of fd.
>=20
> Fixes:b0eed085903e("hisi_acc_vfio_pci: Add support for VFIO live
> migration")
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---
>  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index c057c0e24693..8d9e07ebf4fd 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -1501,6 +1501,7 @@ static void hisi_acc_vfio_pci_close_device(struct
> vfio_device *core_vdev)
>  	struct hisi_acc_vf_core_device *hisi_acc_vdev =3D
> hisi_acc_get_vf_dev(core_vdev);
>  	struct hisi_qm *vf_qm =3D &hisi_acc_vdev->vf_qm;
>=20
> +	hisi_acc_vf_disable_fds(hisi_acc_vdev);
>  	mutex_lock(&hisi_acc_vdev->open_mutex);
>  	hisi_acc_vdev->dev_opened =3D false;
>  	iounmap(vf_qm->io_base);

Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Thanks,
Shameer

