Return-Path: <kvm+bounces-17306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B73EB8C3D5E
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 10:35:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DACAC1C21471
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 08:35:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23F08147C8A;
	Mon, 13 May 2024 08:35:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F414D9F2;
	Mon, 13 May 2024 08:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715589324; cv=none; b=o6TIFzqJcXI9Z4OEnHqAkhXqGOVPguz6JoD3hbFPmwoNqQgDFYWQKoTxcrqLkzLgiOm/fjTKyPaltsZ0972KiulM1Nfwks6nm3bq3+5cN8aNXV+bREZtb4LRz4lsBzREbEzR3qobkhJndnJ73OrCE8uQESeMiUG4fXsIyGOgx7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715589324; c=relaxed/simple;
	bh=QCf36tZtXXXjt922Hu7+FbrZmPbJUcU8bAE6NBRi73I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Hi7I8i8vFGYsRkHBHMQrGfvrRjLl7MLV7psSk+5FpgRT3kLNKFn2YAPShn0wgQv65ljTuqu2+IVBCrazv6eq89gPDGykj6RfcGZTeyLN7baExG/usHxxpBqUlWvLW3PgHeGNy4waVZG87q3v+cbo1Mp1Go+g6EodMfOK3osY5zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4VdCTR0vKxz6K9FL;
	Mon, 13 May 2024 16:34:35 +0800 (CST)
Received: from lhrpeml100001.china.huawei.com (unknown [7.191.160.183])
	by mail.maildlp.com (Postfix) with ESMTPS id 1430E140B2A;
	Mon, 13 May 2024 16:35:11 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml100001.china.huawei.com (7.191.160.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 13 May 2024 09:35:10 +0100
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.039;
 Mon, 13 May 2024 09:35:10 +0100
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
Thread-Index: AQHalxSYiMUGo9i0CEeMRf9rOEDS3LGFqjoAgAXIF4CAAET0AIABOcaAgACzG4CAAQ/SgIAAR8IAgAXg5QCAABUFoA==
Date: Mon, 13 May 2024 08:35:10 +0000
Message-ID: <4e7f3027d07645aca80e811598d4ce21@huawei.com>
References: <20240425132322.12041-1-liulongfang@huawei.com>
 <20240425132322.12041-3-liulongfang@huawei.com>
 <20240503101138.7921401f.alex.williamson@redhat.com>
 <bc4fd179-265a-cbd8-afcb-358748ece897@huawei.com>
 <20240507063552.705cb1b6.alex.williamson@redhat.com>
 <3911fd96-a872-c352-b0ab-0eb2ae982037@huawei.com>
 <20240508115957.1c13dd12.alex.williamson@redhat.com>
 <ed07017d74f147b28a069660100e3ad1@huawei.com>
 <20240509082940.51a69feb.alex.williamson@redhat.com>
 <e63c0c85-7f3a-100c-5059-322268b3f517@huawei.com>
In-Reply-To: <e63c0c85-7f3a-100c-5059-322268b3f517@huawei.com>
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
> Sent: Monday, May 13, 2024 9:16 AM
> To: Alex Williamson <alex.williamson@redhat.com>; Shameerali Kolothum
> Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: jgg@nvidia.com; Jonathan Cameron <jonathan.cameron@huawei.com>;
> kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linuxarm@openeuler.org
> Subject: Re: [PATCH v6 2/5] hisi_acc_vfio_pci: modify the register locati=
on of
> the XQC address
>=20
> On 2024/5/9 22:29, Alex Williamson wrote:
> > On Thu, 9 May 2024 09:37:51 +0000
> > Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> wrote:
> >
> >>> -----Original Message-----
> >>> From: Alex Williamson <alex.williamson@redhat.com>
> >>> Sent: Wednesday, May 8, 2024 7:00 PM
> >>> To: liulongfang <liulongfang@huawei.com>
> >>> Cc: jgg@nvidia.com; Shameerali Kolothum Thodi
> >>> <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
> >>> <jonathan.cameron@huawei.com>; kvm@vger.kernel.org; linux-
> >>> kernel@vger.kernel.org; linuxarm@openeuler.org
> >>> Subject: Re: [PATCH v6 2/5] hisi_acc_vfio_pci: modify the register
> location of
> >>> the XQC address
> >>
> >> [...]
> >>
> >>>> HiSilicon accelerator equipment can perform general services after
> >>> completing live migration.
> >>>> This kind of business is executed through the user mode driver and o=
nly
> >>> needs to use SQE and CQE.
> >>>>
> >>>> At the same time, this device can also perform kernel-mode services =
in
> the
> >>> VM through the crypto
> >>>> subsystem. This kind of service requires the use of EQE.
> >>>>
> >>>> Finally, if the device is abnormal, the driver needs to perform a de=
vice
> >>> reset, and AEQE needs to
> >>>> be used in this case.
> >>>>
> >>>> Therefore, a complete device live migration function needs to ensure
> that
> >>> device functions are
> >>>> normal in all these scenarios.
> >>>> Therefore, this data still needs to be migrated.
> >>>
> >>> Ok, I had jumped to an in-kernel host driver in reference to "kernel
> >>> mode" rather than a guest kernel.  Migrating with bad data only affec=
ts
> >>> the current configuration of the device, reloading a guest driver to
> >>> update these registers or a reset of the device would allow proper
> >>> operation of the device, correct?
> >>
> >> Yes, after talking to Longfang, the device RAS will trigger a reset an=
d
> >> would function after reset.
> >>
> >>>
> >>> But I think this still isn't really a complete solution, we know
> >>> there's a bug in the migration data stream, so not only would we fix
> >>> the data stream, but I think we should also take measures to prevent
> >>> loading a known bad data stream.  AIUI migration of this device while
> >>> running in kernel mode (ie. a kernel driver within a guest VM) is
> >>> broken.  Therefore, the least we can do in a new kernel, knowing that
> >>> there was previously a bug in the migration data stream, is to fail t=
o
> >>> load that migration data because it risks this scenario where the
> >>> device is broken after migration.  Shouldn't we then also increment a
> >>> migration version field in the data stream to block migrations that
> >>> risk this breakage, or barring that, change the magic data field to
> >>> prevent the migration?  Thanks,
> >>
> >> Ok. We could add a new ACC_DEV_MAGIC_V2 and prevent the migration
> >> in vf_qm_check_match(). The only concern here is that, it will complet=
ely
> >> block old kernel to new kernel migration and since we can recover the
> >> device after the reset whether it is too restrictive or not.
> >
> > What's the impact to the running driver, kernel or userspace, if the
> > device is reset?  Migration is intended to be effectively transparent
>=20
> If the device is reset, the user's task needs to be restarted.
> If an exception has been detected, the best way is not to migrate.
>=20
> > to the driver.  If the driver stalls and needs to reset the device,
> > what has the migration driver accomplished versus an offline migration?
> >
> > If there's a way to detect from the migration data if the device is
> > running in kernel mode or user mode then you could potentially accept
> > and send v1 magic conditional that the device is in user mode and
> > require v2 magic for any migration where the device is in kernel mode.
> > This all adds complication though and seems like it has corner cases
> > where we might allow migration to an old kernel that might trap the
> > device there if the use case changes.
> >
>=20
> The driver does not support checking whether the device is running in
> kernel mode or user mode.
> Moreover, the device supports user-mode services and kernel-mode services
> to run at the same time.
>=20
> > Essentially it comes down to what should the migration experience be
> > and while restricting old->new and new->old migration is undesirable,
> > it seems old->old migration is effectively already broken anyway.  As
> > you consider a v2 magic, perhaps consider how the migration data
> > structure might be improved overall to better handle new features and
> > bugs.  Thanks,
> >
>=20
> We discussed a plan:
> Update ACC_DEV_MAGIC to ACC_DEV_MAGIC_VERSION and configure its
> last byte
> as version information:
>=20
> /* QM match information, last byte is version number */
> #define ACC_DEV_MAGIC_VERSION	0XACCDEVFEEDCAFE01

Oops..cant have V there. But the idea is replace magic with last byte
as version info which can be used in future for handling bugs/features
etc.

Thanks,
Shameer

