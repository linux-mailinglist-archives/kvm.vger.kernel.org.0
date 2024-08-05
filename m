Return-Path: <kvm+bounces-23199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DC454947800
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 11:11:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 09D181C21399
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 09:11:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF01A14F9F7;
	Mon,  5 Aug 2024 09:11:17 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8028013DDC2;
	Mon,  5 Aug 2024 09:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722849077; cv=none; b=e76qi0loHuIVmab5UwD0JY/pCOk0YJiDmThKiaEYeQYdOobSTZyMAcms+a67Pm6YO78CQUe05N5VWxzQ8QGzpF7djrkG6g7K4Lgi+aRYscBrdnCE30IukN9r8lL4Qc2cwE/jbu4vLbSDQUm0wjRw49s59Le+NNPRlTZmx5oYe4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722849077; c=relaxed/simple;
	bh=zzP+981JgxGaQFjBoXGMDLT4udKj63Kccc7PsEuUFyY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=s9vl7ISIeOj6S3i5Fmeb9BwSq+pOq3QL46B+EIMsuiSUd/wCaIy2JdcM1ooXdOotMMVJlzB49YZUF5s1wqT5Rg7BCp8hFXZ+dRRff3ihiu29+6HYByTxhRv6IdL9ScE1bAT0v+pCjw6wRKzxLwgDEmaA1hLcOm0VcJligYCgBh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4WcrGL6BXRz6K5ps;
	Mon,  5 Aug 2024 17:08:58 +0800 (CST)
Received: from lhrpeml500006.china.huawei.com (unknown [7.191.161.198])
	by mail.maildlp.com (Postfix) with ESMTPS id ACA49140D37;
	Mon,  5 Aug 2024 17:11:11 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml500006.china.huawei.com (7.191.161.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 5 Aug 2024 10:11:01 +0100
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.039;
 Mon, 5 Aug 2024 10:11:01 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: liulongfang <liulongfang@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>, "Jonathan
 Cameron" <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH v7 1/4] hisi_acc_vfio_pci: extract public functions for
 container_of
Thread-Topic: [PATCH v7 1/4] hisi_acc_vfio_pci: extract public functions for
 container_of
Thread-Index: AQHa4nr6lxq8E7VAXkGR9QxSpzP8NLIYaYnw
Date: Mon, 5 Aug 2024 09:11:01 +0000
Message-ID: <342ae840f5064d92b569b521b30ddae8@huawei.com>
References: <20240730121438.58455-1-liulongfang@huawei.com>
 <20240730121438.58455-2-liulongfang@huawei.com>
In-Reply-To: <20240730121438.58455-2-liulongfang@huawei.com>
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
> Subject: [PATCH v7 1/4] hisi_acc_vfio_pci: extract public functions for
> container_of
>=20
> In the current driver, vdev is obtained from struct
> hisi_acc_vf_core_device through the container_of function.
> This method is used in many places in the driver. In order to
> reduce this repetitive operation, It was extracted into
> a public function.
>=20
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---

LGTM,

Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Thanks,
Shameer

>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 21 ++++++++++---------
>  1 file changed, 11 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index 9a3e97108ace..45351be8e270 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -630,6 +630,12 @@ static void hisi_acc_vf_disable_fds(struct
> hisi_acc_vf_core_device *hisi_acc_vde
>  	}
>  }
>=20
> +static struct hisi_acc_vf_core_device *hisi_acc_get_vf_dev(struct
> vfio_device *vdev)
> +{
> +	return container_of(vdev, struct hisi_acc_vf_core_device,
> +			    core_device.vdev);
> +}
> +
>  static void hisi_acc_vf_reset(struct hisi_acc_vf_core_device *hisi_acc_v=
dev)
>  {
>  	hisi_acc_vdev->vf_qm_state =3D QM_NOT_READY;
> @@ -1033,8 +1039,7 @@ static struct file *
>  hisi_acc_vfio_pci_set_device_state(struct vfio_device *vdev,
>  				   enum vfio_device_mig_state new_state)
>  {
> -	struct hisi_acc_vf_core_device *hisi_acc_vdev =3D container_of(vdev,
> -			struct hisi_acc_vf_core_device, core_device.vdev);
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =3D
> hisi_acc_get_vf_dev(vdev);
>  	enum vfio_device_mig_state next_state;
>  	struct file *res =3D NULL;
>  	int ret;
> @@ -1075,8 +1080,7 @@ static int
>  hisi_acc_vfio_pci_get_device_state(struct vfio_device *vdev,
>  				   enum vfio_device_mig_state *curr_state)
>  {
> -	struct hisi_acc_vf_core_device *hisi_acc_vdev =3D container_of(vdev,
> -			struct hisi_acc_vf_core_device, core_device.vdev);
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =3D
> hisi_acc_get_vf_dev(vdev);
>=20
>  	mutex_lock(&hisi_acc_vdev->state_mutex);
>  	*curr_state =3D hisi_acc_vdev->mig_state;
> @@ -1280,8 +1284,7 @@ static long hisi_acc_vfio_pci_ioctl(struct vfio_dev=
ice
> *core_vdev, unsigned int
>=20
>  static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
>  {
> -	struct hisi_acc_vf_core_device *hisi_acc_vdev =3D
> container_of(core_vdev,
> -			struct hisi_acc_vf_core_device, core_device.vdev);
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =3D
> hisi_acc_get_vf_dev(core_vdev);
>  	struct vfio_pci_core_device *vdev =3D &hisi_acc_vdev->core_device;
>  	int ret;
>=20
> @@ -1304,8 +1307,7 @@ static int hisi_acc_vfio_pci_open_device(struct
> vfio_device *core_vdev)
>=20
>  static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev=
)
>  {
> -	struct hisi_acc_vf_core_device *hisi_acc_vdev =3D
> container_of(core_vdev,
> -			struct hisi_acc_vf_core_device, core_device.vdev);
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =3D
> hisi_acc_get_vf_dev(core_vdev);
>  	struct hisi_qm *vf_qm =3D &hisi_acc_vdev->vf_qm;
>=20
>  	iounmap(vf_qm->io_base);
> @@ -1320,8 +1322,7 @@ static const struct vfio_migration_ops
> hisi_acc_vfio_pci_migrn_state_ops =3D {
>=20
>  static int hisi_acc_vfio_pci_migrn_init_dev(struct vfio_device *core_vde=
v)
>  {
> -	struct hisi_acc_vf_core_device *hisi_acc_vdev =3D
> container_of(core_vdev,
> -			struct hisi_acc_vf_core_device, core_device.vdev);
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =3D
> hisi_acc_get_vf_dev(core_vdev);
>  	struct pci_dev *pdev =3D to_pci_dev(core_vdev->dev);
>  	struct hisi_qm *pf_qm =3D hisi_acc_get_pf_qm(pdev);
>=20
> --
> 2.24.0


