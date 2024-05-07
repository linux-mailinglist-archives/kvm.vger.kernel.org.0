Return-Path: <kvm+bounces-16822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 11FF88BE0B2
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 13:10:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7DD751F21A00
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 11:10:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B23E1514F1;
	Tue,  7 May 2024 11:10:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490C115216D;
	Tue,  7 May 2024 11:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715080209; cv=none; b=dAIExXEklMVbUX8InvlYVxwq0VhkJ7GR1fTjowrDjgUFO1zXSCsdPT10MU4GOuao0Y0Y2Fm9qn2A55WhSzGLTBGuOq+bDgSf7noawP7v+XoC9yMB4HiZ8xwpyQuBAr2u2tCv3SuDpf49gGk2EIgJDEc1TOarMofVwvzRcGz5iw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715080209; c=relaxed/simple;
	bh=fqwAiVgdIG1/1mfzXlBpT/WZA7mbZC3oys8LNVsxBqE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=E05zT/tzvqAA8LBJoRdYGboSbmpcWWWwdKUOZaFdfHF+3hlAG15ShdNeauFqQj2amSEu00EQ/bhQ6Fn44PYITbJKu5PICziGseqdiYd5+WpD4Z5WOGalx7o4N/5az+RDBwfsJf8fwau9C37SEl1HCgrXinxhpnDTcqPT7zBFmOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4VYb846Tfjz6K7Gf;
	Tue,  7 May 2024 19:07:00 +0800 (CST)
Received: from lhrpeml100004.china.huawei.com (unknown [7.191.162.219])
	by mail.maildlp.com (Postfix) with ESMTPS id 2BB46140B33;
	Tue,  7 May 2024 19:10:03 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml100004.china.huawei.com (7.191.162.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 7 May 2024 12:10:02 +0100
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.039;
 Tue, 7 May 2024 12:10:02 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: liulongfang <liulongfang@huawei.com>, Alex Williamson
	<alex.williamson@redhat.com>
CC: "jgg@nvidia.com" <jgg@nvidia.com>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH v6 2/5] hisi_acc_vfio_pci: modify the register location of
 the XQC address
Thread-Topic: [PATCH v6 2/5] hisi_acc_vfio_pci: modify the register location
 of the XQC address
Thread-Index: AQHalxSYiMUGo9i0CEeMRf9rOEDS3LGFqjoAgAXIF4CAADztAA==
Date: Tue, 7 May 2024 11:10:02 +0000
Message-ID: <2bc044ee1f86407bb22c3244e152e106@huawei.com>
References: <20240425132322.12041-1-liulongfang@huawei.com>
 <20240425132322.12041-3-liulongfang@huawei.com>
 <20240503101138.7921401f.alex.williamson@redhat.com>
 <bc4fd179-265a-cbd8-afcb-358748ece897@huawei.com>
In-Reply-To: <bc4fd179-265a-cbd8-afcb-358748ece897@huawei.com>
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
> Sent: Tuesday, May 7, 2024 9:29 AM
> To: Alex Williamson <alex.williamson@redhat.com>
> Cc: jgg@nvidia.com; Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; linuxarm@openeuler.org
> Subject: Re: [PATCH v6 2/5] hisi_acc_vfio_pci: modify the register locati=
on of
> the XQC address
>=20
> On 2024/5/4 0:11, Alex Williamson wrote:
> > On Thu, 25 Apr 2024 21:23:19 +0800
> > Longfang Liu <liulongfang@huawei.com> wrote:
> >
> >> According to the latest hardware register specification. The DMA
> >> addresses of EQE and AEQE are not at the front of their respective
> >> register groups, but start from the second.
> >> So, previously fetching the value starting from the first register
> >> would result in an incorrect address.
> >>
> >> Therefore, the register location from which the address is obtained
> >> needs to be modified.
> >
> > How does this affect migration?  Has it ever worked?  Does this make
>=20
> The general HiSilicon accelerator task will only use SQE and CQE.
> EQE is only used when user running kernel mode task and uses interrupt mo=
de.
> AEQE is only used when user running task exceptions occur and software re=
set
> is required.
>=20
> The DMA addresses of these four queues are written to the device by the d=
evice
> driver through the mailbox command during driver initialization.
> The DMA addresses of EQE and AEQE are migrated through the device registe=
r.
>=20
> EQE and AEQE are not used in general task, after the live migration is
> completed,
> this DMA address error will not be found. until we added a new kernel-mod=
e test
> case
> that we discovered that this address was abnormal.
>=20
> > the migration data incompatible?
> >
>=20
> This address only affects the kernel mode interrupt mode task function an=
d
> device
> exception recovery function.
> They do not affect live migration functionality
>=20
> > Fixes: ???
>=20
> OK!

Hi,

Could you please add the Fixes tag and resend this separately if there are =
no
outstanding comments on this. This is not related to the debugfs support an=
yway.

Thanks,
Shameer

> Thanks.
> Longfang.
> >> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> >> ---
> >>  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 8 ++++----
> >>  drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h | 3 +++
> >>  2 files changed, 7 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> >> index 45351be8e270..0c7e31076ff4 100644
> >> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> >> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> >> @@ -516,12 +516,12 @@ static int vf_qm_state_save(struct
> hisi_acc_vf_core_device *hisi_acc_vdev,
> >>  		return -EINVAL;
> >>
> >>  	/* Every reg is 32 bit, the dma address is 64 bit. */
> >> -	vf_data->eqe_dma =3D vf_data->qm_eqc_dw[1];
> >> +	vf_data->eqe_dma =3D vf_data->qm_eqc_dw[QM_XQC_ADDR_HIGH];
> >>  	vf_data->eqe_dma <<=3D QM_XQC_ADDR_OFFSET;
> >> -	vf_data->eqe_dma |=3D vf_data->qm_eqc_dw[0];
> >> -	vf_data->aeqe_dma =3D vf_data->qm_aeqc_dw[1];
> >> +	vf_data->eqe_dma |=3D vf_data->qm_eqc_dw[QM_XQC_ADDR_LOW];
> >> +	vf_data->aeqe_dma =3D vf_data->qm_aeqc_dw[QM_XQC_ADDR_HIGH];
> >>  	vf_data->aeqe_dma <<=3D QM_XQC_ADDR_OFFSET;
> >> -	vf_data->aeqe_dma |=3D vf_data->qm_aeqc_dw[0];
> >> +	vf_data->aeqe_dma |=3D vf_data->qm_aeqc_dw[QM_XQC_ADDR_LOW];
> >>
> >>  	/* Through SQC_BT/CQC_BT to get sqc and cqc address */
> >>  	ret =3D qm_get_sqc(vf_qm, &vf_data->sqc_dma);
> >> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> >> index 5bab46602fad..f887ab98581c 100644
> >> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> >> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> >> @@ -38,6 +38,9 @@
> >>  #define QM_REG_ADDR_OFFSET	0x0004
> >>
> >>  #define QM_XQC_ADDR_OFFSET	32U
> >> +#define QM_XQC_ADDR_LOW	0x1
> >> +#define QM_XQC_ADDR_HIGH	0x2
> >> +
> >>  #define QM_VF_AEQ_INT_MASK	0x0004
> >>  #define QM_VF_EQ_INT_MASK	0x000c
> >>  #define QM_IFC_INT_SOURCE_V	0x0020
> >
> > .
> >

