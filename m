Return-Path: <kvm+bounces-51743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C715AAFC4F3
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 10:02:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6FEAC7ADCA2
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 08:01:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BCB829E0E0;
	Tue,  8 Jul 2025 08:02:37 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F0119E992;
	Tue,  8 Jul 2025 08:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751961756; cv=none; b=Ykt2kC81zy/B64qn2Td+p6ReOp8dn4tPY7ACQYp7Rd3wWlSV733q89KDaaa/NoHHTWzcDDm41qgVkc2Orr61RpFO2CxfjiYPHcHH9VCUOH7to9qwdH+izQzLq5+IXxeAvZORccwsc428y1A82pKT+SjwZaW54rw8wnPEGUyJ6/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751961756; c=relaxed/simple;
	bh=Ip/ceLRcmHB11jnSHSgNcmXyNQAOXLOnMhj4htH0Xdg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GJBcVpce3IGlHbKYOdRZ5sO9gXnM6khvB/1K8No3OK80SBSd4Cvx+1bOR3AcFzgxaYn/y0Ccos62p/mqDLxXOtV/W5NH6k/u3iRYKzbyQtv+xB2ZaC9/JP1gai3DVsymKKNri3HR2RhtdDaoBMt7a14Kfk/2iGGjjsPNpFT28N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4bbtpt6bVJz6DB3Z;
	Tue,  8 Jul 2025 16:01:26 +0800 (CST)
Received: from frapeml100005.china.huawei.com (unknown [7.182.85.132])
	by mail.maildlp.com (Postfix) with ESMTPS id 8B8E414037D;
	Tue,  8 Jul 2025 16:02:30 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml100005.china.huawei.com (7.182.85.132) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 8 Jul 2025 10:02:30 +0200
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Tue, 8 Jul 2025 10:02:30 +0200
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: liulongfang <liulongfang@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>, "Jonathan
 Cameron" <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH v5 1/3] migration: update BAR space size
Thread-Topic: [PATCH v5 1/3] migration: update BAR space size
Thread-Index: AQHb6ZyiIbxhA+WcnUGIDd/3hhMH97Qn6S1w
Date: Tue, 8 Jul 2025 08:02:30 +0000
Message-ID: <b9579c5738f64e9c8e6488cc0492ee17@huawei.com>
References: <20250630085402.7491-1-liulongfang@huawei.com>
 <20250630085402.7491-2-liulongfang@huawei.com>
In-Reply-To: <20250630085402.7491-2-liulongfang@huawei.com>
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
> Sent: Monday, June 30, 2025 9:54 AM
> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
> Subject: [PATCH v5 1/3] migration: update BAR space size
>=20
> On new platforms greater than QM_HW_V3, the live migration
> configuration
> region is moved from VF to PF. The VF's own configuration space is
> restored to the complete 64KB, and there is no need to divide the
> size of the BAR configuration space equally.
>=20
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---

See one minor comment below.

LGTM:
Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 36 ++++++++++++++-----
>  1 file changed, 27 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index 2149f49aeec7..1ddc9dbadb70 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -1250,6 +1250,28 @@ static struct hisi_qm *hisi_acc_get_pf_qm(struct
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
> +	 * On the old QM_HW_V3 device, the ACC VF device BAR2
> +	 * region encompasses both functional register space
> +	 * and migration control register space.
> +	 * only the functional region should be report to Guest.
> +	 *
> +	 * On the new HW device, the migration control register
> +	 * has been moved to the PF device BAR2 region.
> +	 * The VF device BAR2 is entirely functional register space.
> +	 */

Nit: May be move the above comment about new HW to the below
check  is better.

> +	if (hisi_acc_vdev->pf_qm->ver =3D=3D QM_HW_V3)
> +		return (pci_resource_len(vdev->pdev, index) >> 1);
> +
> +	return pci_resource_len(vdev->pdev, index);
> +}
> +
>  static int hisi_acc_pci_rw_access_check(struct vfio_device *core_vdev,
>  					size_t count, loff_t *ppos,
>  					size_t *new_count)
> @@ -1260,8 +1282,9 @@ static int hisi_acc_pci_rw_access_check(struct
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
> @@ -1282,8 +1305,9 @@ static int hisi_acc_vfio_pci_mmap(struct
> vfio_device *core_vdev,
>  	index =3D vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
>  	if (index =3D=3D VFIO_PCI_BAR2_REGION_INDEX) {
>  		u64 req_len, pgoff, req_start;
> -		resource_size_t end =3D pci_resource_len(vdev->pdev, index) /
> 2;
> +		resource_size_t end;
>=20
> +		end =3D hisi_acc_get_resource_len(vdev, index);
>  		req_len =3D vma->vm_end - vma->vm_start;
>  		pgoff =3D vma->vm_pgoff &
>  			((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
> @@ -1330,7 +1354,6 @@ static long hisi_acc_vfio_pci_ioctl(struct
> vfio_device *core_vdev, unsigned int
>  	if (cmd =3D=3D VFIO_DEVICE_GET_REGION_INFO) {
>  		struct vfio_pci_core_device *vdev =3D
>  			container_of(core_vdev, struct vfio_pci_core_device,
> vdev);
> -		struct pci_dev *pdev =3D vdev->pdev;
>  		struct vfio_region_info info;
>  		unsigned long minsz;
>=20
> @@ -1345,12 +1368,7 @@ static long hisi_acc_vfio_pci_ioctl(struct
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


