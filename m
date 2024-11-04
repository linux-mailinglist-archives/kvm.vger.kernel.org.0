Return-Path: <kvm+bounces-30462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 70C6A9BAEB7
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 09:56:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 363B8283257
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 08:56:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA2FF1ABEC7;
	Mon,  4 Nov 2024 08:56:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632AD1AB510;
	Mon,  4 Nov 2024 08:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730710589; cv=none; b=Prfjm5LIpiQnd+CCZqq3EwXkwW1R0+MHZrCYuuwk1U67sxyffT05/kVGOoMwQeQep7x95t/2ynYrw+EqcD1doD3rn81YFrB8eJ6s0WyUxN98NktMG7w6MqOfhSOCyHq2KjgqmpR/Dixcvg0FL9CTI2HLXxIssg6sf2xv7z4dzS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730710589; c=relaxed/simple;
	bh=ksUKJzxkBHp/ZUk9remqaGSesCQlE9k8+7etB29cbVY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZM1lYirGUk3MKD663F8lEmHvgiQ4E4TbGQOWNkNEhwfWNalzMfo8bCh11E3s38vSxueniA0LwQcEX+hnH/fWbcOU9/ukTO5/5HLhXeomhFdq2bzmAvnM+46tTzyoH00uowsV5KWJQuONU7+13wW1hXGZzSZyZqnIlRNMjGuc0fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XhlZ45SC1z6LDDk;
	Mon,  4 Nov 2024 16:51:24 +0800 (CST)
Received: from frapeml500006.china.huawei.com (unknown [7.182.85.219])
	by mail.maildlp.com (Postfix) with ESMTPS id AB5A7140864;
	Mon,  4 Nov 2024 16:56:23 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml500006.china.huawei.com (7.182.85.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 4 Nov 2024 09:56:18 +0100
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Mon, 4 Nov 2024 09:56:18 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: liulongfang <liulongfang@huawei.com>, Alex Williamson
	<alex.williamson@redhat.com>
CC: "jgg@nvidia.com" <jgg@nvidia.com>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH v11 3/4] hisi_acc_vfio_pci: register debugfs for hisilicon
 migration driver
Thread-Topic: [PATCH v11 3/4] hisi_acc_vfio_pci: register debugfs for
 hisilicon migration driver
Thread-Index: AQHbJrzKeGN2ukv9KEK1yDMX2/cverKhY3oAgAVbw4CAAApcAIAAFygQ
Date: Mon, 4 Nov 2024 08:56:18 +0000
Message-ID: <133e223b22df4ab4b4802163d0c42407@huawei.com>
References: <20241025090143.64472-1-liulongfang@huawei.com>
 <20241025090143.64472-4-liulongfang@huawei.com>
 <20241031160430.59f4b944.alex.williamson@redhat.com>
 <df5129f8-e9c2-b1c0-e2de-9211738d88c4@huawei.com>
 <019a0cab-76b7-a3c0-d93f-5384efea1f67@huawei.com>
In-Reply-To: <019a0cab-76b7-a3c0-d93f-5384efea1f67@huawei.com>
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
> Sent: Monday, November 4, 2024 8:31 AM
> To: Alex Williamson <alex.williamson@redhat.com>
> Cc: jgg@nvidia.com; Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; linuxarm@openeuler.org
> Subject: Re: [PATCH v11 3/4] hisi_acc_vfio_pci: register debugfs for hisi=
licon
> migration driver
[...]

> >>> +
> >>> +	seq_printf(seq,
> >>> +		 "acc device:\n"
> >>> +		 "guest driver load: %u\n"
> >>> +		 "device opened: %d\n"
> >>> +		 "migrate data length: %lu\n",
> >>> +		 hisi_acc_vdev->vf_qm_state,
> >>> +		 hisi_acc_vdev->dev_opened,
> >>> +		 debug_migf->total_length);
> >>
> >> This debugfs entry is described as returning the data from the last
> >> migration, but vf_qm_state and dev_opened are relative to the current
> >> device/guest driver state.  Both seem to have no relevance to the data
> >> in debug_migf.
> >>
> >
> > The benefit of dev_opened retention is that user can obtain the device
> status
> > during the cat migf_data operation.
> >
>=20
> I will remove dev_opened in the next version.
> And hisi_acc_vdev->vf_qm_state is changed to debug_migf-
> >vf_data.vf_qm_state
> Keep information about whether the device driver in the Guest OS is loade=
d
> when live migration occurs.

I think you already get that when you dump debug_migf->vf_data.
So not required.

Thanks,
Shameer


