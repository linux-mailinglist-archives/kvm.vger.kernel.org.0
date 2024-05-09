Return-Path: <kvm+bounces-17111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AFEC8C0D9F
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 11:38:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA75D28384F
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 09:38:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE64014AD14;
	Thu,  9 May 2024 09:37:56 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75D514A623;
	Thu,  9 May 2024 09:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715247476; cv=none; b=WKSG9RIjEJbIZPx5d4o+uC6eEWdovyYqA3VAEsLccyx3JLlhXmkYX2Db72KiLZ0GWpyXN0vc5gx9kPCsH3QszeddqK1wHxN5+bAN1hXH0i8o8knaJA4Dlh1bwHXHM5rO+6ehZCtsIDAPdLX1Z3rtGmd4jPyYMlrvlTmF3q1nICk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715247476; c=relaxed/simple;
	bh=nCmtM3PPtkCoXwwU+/6RNPeQ2uQPktbAwJaR92+1eFU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=e53yxBn6LP3OrlJHZkE+uYaud30mamzW0R2XEG/Qb1N9AexFQ2kpILoVb3Sb1NDuYbOvRjAoFWY7XsQOHsAl2I6AZMv+9VulfMdkmTM327moVqv9flVDteS0TKgoL9sKM7nqfFQegTu/v+swzD6N76BunvPas0aGkOgn7tIzWZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4VZn0g0sP6z67byP;
	Thu,  9 May 2024 17:34:43 +0800 (CST)
Received: from lhrpeml500001.china.huawei.com (unknown [7.191.163.213])
	by mail.maildlp.com (Postfix) with ESMTPS id 84B831404F4;
	Thu,  9 May 2024 17:37:51 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml500001.china.huawei.com (7.191.163.213) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 9 May 2024 10:37:51 +0100
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.039;
 Thu, 9 May 2024 10:37:51 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Alex Williamson <alex.williamson@redhat.com>, liulongfang
	<liulongfang@huawei.com>
CC: "jgg@nvidia.com" <jgg@nvidia.com>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH v6 2/5] hisi_acc_vfio_pci: modify the register location of
 the XQC address
Thread-Topic: [PATCH v6 2/5] hisi_acc_vfio_pci: modify the register location
 of the XQC address
Thread-Index: AQHalxSYiMUGo9i0CEeMRf9rOEDS3LGFqjoAgAXIF4CAAET0AIABOcaAgACzG4CAAQ/SgA==
Date: Thu, 9 May 2024 09:37:51 +0000
Message-ID: <ed07017d74f147b28a069660100e3ad1@huawei.com>
References: <20240425132322.12041-1-liulongfang@huawei.com>
	<20240425132322.12041-3-liulongfang@huawei.com>
	<20240503101138.7921401f.alex.williamson@redhat.com>
	<bc4fd179-265a-cbd8-afcb-358748ece897@huawei.com>
	<20240507063552.705cb1b6.alex.williamson@redhat.com>
	<3911fd96-a872-c352-b0ab-0eb2ae982037@huawei.com>
 <20240508115957.1c13dd12.alex.williamson@redhat.com>
In-Reply-To: <20240508115957.1c13dd12.alex.williamson@redhat.com>
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
> Sent: Wednesday, May 8, 2024 7:00 PM
> To: liulongfang <liulongfang@huawei.com>
> Cc: jgg@nvidia.com; Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; linuxarm@openeuler.org
> Subject: Re: [PATCH v6 2/5] hisi_acc_vfio_pci: modify the register locati=
on of
> the XQC address

[...]
=20
> > HiSilicon accelerator equipment can perform general services after
> completing live migration.
> > This kind of business is executed through the user mode driver and only
> needs to use SQE and CQE.
> >
> > At the same time, this device can also perform kernel-mode services in =
the
> VM through the crypto
> > subsystem. This kind of service requires the use of EQE.
> >
> > Finally, if the device is abnormal, the driver needs to perform a devic=
e
> reset, and AEQE needs to
> > be used in this case.
> >
> > Therefore, a complete device live migration function needs to ensure th=
at
> device functions are
> > normal in all these scenarios.
> > Therefore, this data still needs to be migrated.
>=20
> Ok, I had jumped to an in-kernel host driver in reference to "kernel
> mode" rather than a guest kernel.  Migrating with bad data only affects
> the current configuration of the device, reloading a guest driver to
> update these registers or a reset of the device would allow proper
> operation of the device, correct?

Yes, after talking to Longfang, the device RAS will trigger a reset and
would function after reset.

>=20
> But I think this still isn't really a complete solution, we know
> there's a bug in the migration data stream, so not only would we fix
> the data stream, but I think we should also take measures to prevent
> loading a known bad data stream.  AIUI migration of this device while
> running in kernel mode (ie. a kernel driver within a guest VM) is
> broken.  Therefore, the least we can do in a new kernel, knowing that
> there was previously a bug in the migration data stream, is to fail to
> load that migration data because it risks this scenario where the
> device is broken after migration.  Shouldn't we then also increment a
> migration version field in the data stream to block migrations that
> risk this breakage, or barring that, change the magic data field to
> prevent the migration?  Thanks,

Ok. We could add a new ACC_DEV_MAGIC_V2 and prevent the migration
in vf_qm_check_match(). The only concern here is that, it will completely
block old kernel to new kernel migration and since we can recover the
device after the reset whether it is too restrictive or not.

Thanks,
Shameer

