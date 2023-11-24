Return-Path: <kvm+bounces-2424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 00F8E7F6EEA
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 09:51:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B92562817C7
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 08:51:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 913518BFA;
	Fri, 24 Nov 2023 08:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF6A1BD;
	Fri, 24 Nov 2023 00:51:14 -0800 (PST)
Received: from kwepemm600007.china.huawei.com (unknown [172.30.72.53])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Sc7rb4SNRzSh5p;
	Fri, 24 Nov 2023 16:46:55 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 24 Nov 2023 16:51:11 +0800
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.035;
 Fri, 24 Nov 2023 08:51:09 +0000
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Brett Creeley <brett.creeley@amd.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>, liulongfang
	<liulongfang@huawei.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: RE: [PATCH vfio 2/2] hisi_acc_vfio_pci: Destroy the
 [state|reset]_mutex on release
Thread-Topic: [PATCH vfio 2/2] hisi_acc_vfio_pci: Destroy the
 [state|reset]_mutex on release
Thread-Index: AQHaHXtMt7sx3BVFf0S8PgAhqyIeL7CJKt8A
Date: Fri, 24 Nov 2023 08:51:09 +0000
Message-ID: <00df3a24ff594c409eb2ab92d20733f5@huawei.com>
References: <20231122193634.27250-1-brett.creeley@amd.com>
 <20231122193634.27250-3-brett.creeley@amd.com>
In-Reply-To: <20231122193634.27250-3-brett.creeley@amd.com>
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
X-CFilter-Loop: Reflected



> -----Original Message-----
> From: Brett Creeley [mailto:brett.creeley@amd.com]
> Sent: 22 November 2023 19:37
> To: jgg@ziepe.ca; yishaih@nvidia.com; liulongfang
> <liulongfang@huawei.com>; Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>; kevin.tian@intel.com;
> alex.williamson@redhat.com; kvm@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Cc: shannon.nelson@amd.com; brett.creeley@amd.com
> Subject: [PATCH vfio 2/2] hisi_acc_vfio_pci: Destroy the [state|reset]_mu=
tex
> on release
>=20
> The [state|reset]_mutex are initialized in vfio init, but
> never destroyed. This isn't required as mutex_destroy()
> doesn't do anything unless lock debugging is enabled.
> However, for completeness, fix it by implementing a
> driver specific release function.
>=20
> No fixes tag is added as it doesn't seem worthwhile
> for such a trivial and debug only change.
>=20
> Signed-off-by: Brett Creeley <brett.creeley@amd.com>

Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Thanks.

> ---
>  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index 2c049b8de4b4..dc1e376e1b8a 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -1358,10 +1358,20 @@ static int
> hisi_acc_vfio_pci_migrn_init_dev(struct vfio_device *core_vdev)
>  	return vfio_pci_core_init_dev(core_vdev);
>  }
>=20
> +static void hisi_acc_vfio_pci_migrn_release_dev(struct vfio_device
> *core_vdev)
> +{
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =3D
> container_of(core_vdev,
> +			struct hisi_acc_vf_core_device, core_device.vdev);
> +
> +	mutex_destroy(&hisi_acc_vdev->reset_mutex);
> +	mutex_destroy(&hisi_acc_vdev->state_mutex);
> +	vfio_pci_core_release_dev(core_vdev);
> +}
> +
>  static const struct vfio_device_ops hisi_acc_vfio_pci_migrn_ops =3D {
>  	.name =3D "hisi-acc-vfio-pci-migration",
>  	.init =3D hisi_acc_vfio_pci_migrn_init_dev,
> -	.release =3D vfio_pci_core_release_dev,
> +	.release =3D hisi_acc_vfio_pci_migrn_release_dev,
>  	.open_device =3D hisi_acc_vfio_pci_open_device,
>  	.close_device =3D hisi_acc_vfio_pci_close_device,
>  	.ioctl =3D hisi_acc_vfio_pci_ioctl,
> --
> 2.17.1


