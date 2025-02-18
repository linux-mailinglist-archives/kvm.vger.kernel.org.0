Return-Path: <kvm+bounces-38418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 43492A398D3
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 11:29:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4A493B4567
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 10:20:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAE33233D89;
	Tue, 18 Feb 2025 10:20:41 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6CF22FADE;
	Tue, 18 Feb 2025 10:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739874041; cv=none; b=hQ6w9mX5b4jy2QU3fsr+ZcAfIRZyrZTqMApUhHLf97BIjhD6r8wBD688m8amwFbHwNPX5ZV/q6zChNQ6xbptB0PPNyoYAeWqK5VjT+ZUIjU6DE3QA/BxLdIwlhiIiqhbmHpaI0VdBiCkqH2xa/vS0W7rcyLW6Fr4uZEsjdD3yjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739874041; c=relaxed/simple;
	bh=W5bCXT3p/PTtNBuVBWzZ6J1KIs5mTmny8+WjeoIFbpo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qJK1pxIMqISOymhOZRyP9m7iMJ8C9s57xwft5KEKCwNsWE6zvMpS652cVGJt8pR93kT/PSrQjAm5qcymCPeZpsYDfA0AUhIlVKEaFwXL2RoHiNolyv8V7UQv+FQC49Y55eX5XqtZW69nQnLfKjxhdTIX+xVlcPNArfAwkjTboAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4YxwVH2zV7z6HJjg;
	Tue, 18 Feb 2025 18:19:03 +0800 (CST)
Received: from frapeml500005.china.huawei.com (unknown [7.182.85.13])
	by mail.maildlp.com (Postfix) with ESMTPS id E07291404C4;
	Tue, 18 Feb 2025 18:20:35 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml500005.china.huawei.com (7.182.85.13) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 18 Feb 2025 11:20:35 +0100
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Tue, 18 Feb 2025 11:20:35 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: liulongfang <liulongfang@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>, "Jonathan
 Cameron" <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH 1/3] migration: update BAR space size
Thread-Topic: [PATCH 1/3] migration: update BAR space size
Thread-Index: AQHbgar5930qKAnRUUuFbfnwN3ilM7NM134w
Date: Tue, 18 Feb 2025 10:20:35 +0000
Message-ID: <e756bb3a8ee94cf78a28231afb1eeb92@huawei.com>
References: <20250218021507.40740-1-liulongfang@huawei.com>
 <20250218021507.40740-2-liulongfang@huawei.com>
In-Reply-To: <20250218021507.40740-2-liulongfang@huawei.com>
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
> Subject: [PATCH 1/3] migration: update BAR space size
>=20
> On the new hardware platform, the live migration configuration region
> is moved from VF to PF. The VF's own configuration space is
> restored to the complete 64KB, and there is no need to divide the
> size of the BAR configuration space equally.
>=20
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 41 +++++++++++++++----
>  1 file changed, 32 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index 451c639299eb..599905dbb707 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -1195,6 +1195,33 @@ static struct hisi_qm *hisi_acc_get_pf_qm(struct
> pci_dev *pdev)
>  	return !IS_ERR(pf_qm) ? pf_qm : NULL;
>  }
>=20
> +static size_t hisi_acc_get_resource_len(struct vfio_pci_core_device *vde=
v,
> +					unsigned int index)
> +{
> +	struct hisi_acc_vf_core_device *hisi_acc_vdev =3D
> +			hisi_acc_drvdata(vdev->pdev);
> +
> +	/*
> +	 * ACC VF dev 64KB BAR2 region consists of both functional
> +	 * register space and migration control register space, each
> +	 * uses 32KB BAR2 region, on the system with more than 64KB
> +	 * page size, even if the migration control register space
> +	 * is written by VM, it will only affects the VF.
> +	 *
> +	 * In order to support the live migration function in the
> +	 * system with a page size above 64KB, the driver needs
> +	 * to ensure that the VF region size is aligned with the
> +	 * system page size.

I didn't get this. Are you referring to kernel with 64K page size? And this=
 is=20
for new hardware or QM_HW_V3 one?

> +	 *
> +	 * On the new hardware platform, the live migration control register
> +	 * has been moved from VF to PF.
> +	 */
> +	if (hisi_acc_vdev->pf_qm->ver =3D=3D QM_HW_V3)
> +		return (pci_resource_len(vdev->pdev, index) >> 1);
> +
> +	return pci_resource_len(vdev->pdev, index);
> +}
> +
>  static int hisi_acc_pci_rw_access_check(struct vfio_device *core_vdev,
>  					size_t count, loff_t *ppos,
>  					size_t *new_count)
> @@ -1205,8 +1232,9 @@ static int hisi_acc_pci_rw_access_check(struct
> vfio_device *core_vdev,
>=20
>  	if (index =3D=3D VFIO_PCI_BAR2_REGION_INDEX) {
>  		loff_t pos =3D *ppos & VFIO_PCI_OFFSET_MASK;
> -		resource_size_t end =3D pci_resource_len(vdev->pdev, index) /
> 2;
> +		resource_size_t end;
>=20
> +		end =3D hisi_acc_get_resource_len(vdev, index);
>  		/* Check if access is for migration control region */
>  		if (pos >=3D end)
>  			return -EINVAL;
> @@ -1227,8 +1255,9 @@ static int hisi_acc_vfio_pci_mmap(struct
> vfio_device *core_vdev,
>  	index =3D vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
>  	if (index =3D=3D VFIO_PCI_BAR2_REGION_INDEX) {
>  		u64 req_len, pgoff, req_start;
> -		resource_size_t end =3D pci_resource_len(vdev->pdev, index) /
> 2;
> +		resource_size_t end;
>=20
> +		end =3D PAGE_ALIGN(hisi_acc_get_resource_len(vdev, index));

So here, the whole BAR2 will be mapped to Guest in case of QM_HW_V3 &&
64K kernel as well, right?

Thanks,
Shameer

>  		req_len =3D vma->vm_end - vma->vm_start;
>  		pgoff =3D vma->vm_pgoff &
>  			((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
> @@ -1275,7 +1304,6 @@ static long hisi_acc_vfio_pci_ioctl(struct
> vfio_device *core_vdev, unsigned int
>  	if (cmd =3D=3D VFIO_DEVICE_GET_REGION_INFO) {
>  		struct vfio_pci_core_device *vdev =3D
>  			container_of(core_vdev, struct vfio_pci_core_device,
> vdev);
> -		struct pci_dev *pdev =3D vdev->pdev;
>  		struct vfio_region_info info;
>  		unsigned long minsz;
>=20
> @@ -1290,12 +1318,7 @@ static long hisi_acc_vfio_pci_ioctl(struct
> vfio_device *core_vdev, unsigned int
>  		if (info.index =3D=3D VFIO_PCI_BAR2_REGION_INDEX) {
>  			info.offset =3D
> VFIO_PCI_INDEX_TO_OFFSET(info.index);
>=20
> -			/*
> -			 * ACC VF dev BAR2 region consists of both
> functional
> -			 * register space and migration control register
> space.
> -			 * Report only the functional region to Guest.
> -			 */
> -			info.size =3D pci_resource_len(pdev, info.index) / 2;
> +			info.size =3D hisi_acc_get_resource_len(vdev,
> info.index);
>=20
>  			info.flags =3D VFIO_REGION_INFO_FLAG_READ |
>  					VFIO_REGION_INFO_FLAG_WRITE |
> --
> 2.24.0


