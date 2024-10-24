Return-Path: <kvm+bounces-29659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 785DD9AEB66
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 18:06:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 232451F21E3D
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 16:06:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BBF51F76A9;
	Thu, 24 Oct 2024 16:06:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CFCA158A31;
	Thu, 24 Oct 2024 16:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729785989; cv=none; b=oWYxqqJuh0MHZl7Oci1XnExQ0y+L5w334g8fVe1pH00NLD/WIU4F3qxS8N8nX/Cv52QR/S5VeCUSxf8oADZMgN5VSzOGnb9ADn+kaINnijGY0Ix/7N8x0ArGxTAOjDJxDaZa6ARBa8m0fAXh9qNEQsHNtms+2Xgo81x+X3A07hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729785989; c=relaxed/simple;
	bh=kaZBkio4UH/+/ON9NRJBBr0xVx14/nXK7f1ZHT8Lb74=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sESfTsxf62FPczjK0omJbIqODuH6wV8mAi5hHrvyJHqaxhQNZDQn8RpP2cqialTs34YUgrW0ffom8O70HyMMN4BfzF+9Wm5imqxvIlz7BJFcZJkaEAIPbQMnpHD5bfLna2quc1WGiWd6HmGWwgppJQOcyGtYPwsVlwyvVfFchbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XZ9js1JzXz6K9K7;
	Fri, 25 Oct 2024 00:05:21 +0800 (CST)
Received: from frapeml100007.china.huawei.com (unknown [7.182.85.133])
	by mail.maildlp.com (Postfix) with ESMTPS id 6B1191404F5;
	Fri, 25 Oct 2024 00:06:22 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml100007.china.huawei.com (7.182.85.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 24 Oct 2024 18:06:22 +0200
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Thu, 24 Oct 2024 18:06:22 +0200
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: liulongfang <liulongfang@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, Jonathan Cameron <jonathan.cameron@huawei.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linuxarm@openeuler.org"
	<linuxarm@openeuler.org>
Subject: RE: [PATCH v10 0/4] debugfs to hisilicon migration driver
Thread-Topic: [PATCH v10 0/4] debugfs to hisilicon migration driver
Thread-Index: AQHbH2oB0l11SSHpU0u1ubTVKcydHLKV7z/ggAAC9oCAACrmAA==
Date: Thu, 24 Oct 2024 16:06:22 +0000
Message-ID: <5d0a9221a3b84ea88d2f77197f913091@huawei.com>
References: <20241016012308.14108-1-liulongfang@huawei.com>
 <3ede2cf97ffd4dd6948aa06084a09d2d@huawei.com>
 <20241024152749.GB6956@nvidia.com>
In-Reply-To: <20241024152749.GB6956@nvidia.com>
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
> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, October 24, 2024 4:28 PM
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: liulongfang <liulongfang@huawei.com>; alex.williamson@redhat.com;
> Jonathan Cameron <jonathan.cameron@huawei.com>;
> kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linuxarm@openeuler.org
> Subject: Re: [PATCH v10 0/4] debugfs to hisilicon migration driver
>=20
> On Thu, Oct 24, 2024 at 01:18:55PM +0000, Shameerali Kolothum Thodi
> wrote:
> > > Add a debugfs function to the hisilicon migration driver in VFIO to
> > > provide intermediate state values and data during device migration.
> > >
> > > When the execution of live migration fails, the user can view the
> > > status and data during the migration process separately from the
> > > source and the destination, which is convenient for users to analyze
> > > and locate problems.
> >
> > Could you please take another look at this series as it looks like almo=
st
> there.
>=20
> Why are we so keen to do this? Nobody else needed a complex debugfs for
> their live migration?

I don't think it is that complex debugfs.  Longfang has found this very hel=
pful in
testing and debug with hardware.=20

And hopefully this can be expanded in future with different hardware revisi=
ons.

Thanks,
Shameer

