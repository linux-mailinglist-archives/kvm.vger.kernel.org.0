Return-Path: <kvm+bounces-31719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EC849C6A35
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 09:00:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3E1321F23879
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 08:00:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B70CE189BB3;
	Wed, 13 Nov 2024 08:00:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342B870812;
	Wed, 13 Nov 2024 08:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731484811; cv=none; b=F/c8mt0eE0s2DTeeUVw58x+F15BET0IHA+ZcjbaQ3SU2pK2p5Cc5wAaIqDRSXoE3MEvfNO3caEGwjeF065RmmhBL9VOxltQ2OGn353P1OoxEPcsau6Tq1Q9NpbeZ8rA/2KwMEEaIYdLU3rN+j9wkdp79czphrbK8KskfAusZ7Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731484811; c=relaxed/simple;
	bh=aS765XFTItMcRJkbpVxcI0MRacv9mL8nkDI51BJJaTU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uZgQrmJYksAXdkH2Qap7Dcv6to4zaFfdsoW93Nsy+OEAuWGww22ZhiNeLmDNm2ViY34lZh9KF6gW9mE8Im1Tk9wI8sxu5VvykDFd9TLJB5LFMD7Orh7rCBSoRkOmP022YhxG5dpi0BjmksPdaRcYN43mElVIPFmEaq3MO13ftdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XpG0L5fpFz6LDdN;
	Wed, 13 Nov 2024 15:59:46 +0800 (CST)
Received: from frapeml500007.china.huawei.com (unknown [7.182.85.172])
	by mail.maildlp.com (Postfix) with ESMTPS id 5C32F140519;
	Wed, 13 Nov 2024 15:59:59 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml500007.china.huawei.com (7.182.85.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 13 Nov 2024 08:59:59 +0100
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Wed, 13 Nov 2024 08:59:59 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: liulongfang <liulongfang@huawei.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linuxarm@openeuler.org"
	<linuxarm@openeuler.org>
Subject: RE: [PATCH v15 3/4] hisi_acc_vfio_pci: register debugfs for hisilicon
 migration driver
Thread-Topic: [PATCH v15 3/4] hisi_acc_vfio_pci: register debugfs for
 hisilicon migration driver
Thread-Index: AQHbNNV2zCpG8rxQT0i37T+GTvsNQLKzUpKAgADM14CAALnDEA==
Date: Wed, 13 Nov 2024 07:59:59 +0000
Message-ID: <506ba6eab1134f379f0cc1c52c2fd280@huawei.com>
References: <20241112073322.54550-1-liulongfang@huawei.com>
	<20241112073322.54550-4-liulongfang@huawei.com>
	<1c0a2990bc6243b281d53177bc30cc92@huawei.com>
 <20241112145043.50638012.alex.williamson@redhat.com>
In-Reply-To: <20241112145043.50638012.alex.williamson@redhat.com>
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
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, November 12, 2024 9:51 PM
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: liulongfang <liulongfang@huawei.com>; jgg@nvidia.com; Jonathan
> Cameron <jonathan.cameron@huawei.com>; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; linuxarm@openeuler.org
> Subject: Re: [PATCH v15 3/4] hisi_acc_vfio_pci: register debugfs for hisi=
licon
> migration driver
>=20
> On Tue, 12 Nov 2024 08:40:03 +0000
> Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> wrote:
>=20
> > > -----Original Message-----
> > > From: liulongfang <liulongfang@huawei.com>
> > > Sent: Tuesday, November 12, 2024 7:33 AM
> > > To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
> > > Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
> > > <jonathan.cameron@huawei.com>
> > > Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > > linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
> > > Subject: [PATCH v15 3/4] hisi_acc_vfio_pci: register debugfs for hisi=
licon
> > > migration driver
> > >
> > >
> > > +static void hisi_acc_vfio_debug_init(struct hisi_acc_vf_core_device
> > > *hisi_acc_vdev)
> > > +{
> > > +	struct vfio_device *vdev =3D &hisi_acc_vdev->core_device.vdev;
> > > +	struct hisi_acc_vf_migration_file *migf =3D NULL;
> > > +	struct dentry *vfio_dev_migration =3D NULL;
> > > +	struct dentry *vfio_hisi_acc =3D NULL;
> >
> > Nit, I think we can get rid of these NULL initializations.
>=20
> Yup, all three are unnecessary.
>=20
> > If you have time, please consider respin (sorry, missed this in earlier
> reviews.)
>=20
> If that's the only comment, I can fix that on commit if you want to add
> an ack/review conditional on that change.  Thanks,

Thanks Alex.

With the above nits addressed,

Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Shameer

