Return-Path: <kvm+bounces-34140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 878BC9F797B
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 11:24:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2716116AE72
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 10:24:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22671222591;
	Thu, 19 Dec 2024 10:23:52 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FC354727;
	Thu, 19 Dec 2024 10:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734603831; cv=none; b=swEnajh0kSvhEI1RZ4a8zQgsurqBFEt9rcADBk609wsQOpzSqfqHIDZqmsRKyxfZAMGe4nccI5YqcgZkAdYjxnkETq4RQuTo7u0d5HGZOKu/9XbZZtGR0A265G01cafSkiBIUjXe8UI0Hqy/ncaRaNktgTUiz9Ijf0XVeqN4gCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734603831; c=relaxed/simple;
	bh=ZdxTa2h/6vNejRbcAtm+GfYn9nPS74QPzDZQxSBKjsg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IYapPe2wtJpXLyauFTewG3D/r+8yjPUieYhFKYVcjX1bf4jGVowUsCLYfNtlX4PLRT5TXgtoU1qByd7srjTqdiz86Yylj6gLm2NpOqgwtu4rEHF7eF4FCZ6DOLAr+7/fiBMXyY/SOx2I4I5ACu6yvNtUPtGgBBWt9tXQPftfQ/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4YDRSc6RqYz6LD2q;
	Thu, 19 Dec 2024 18:22:40 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 0EC061400DB;
	Thu, 19 Dec 2024 18:23:47 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 19 Dec 2024 11:23:46 +0100
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Thu, 19 Dec 2024 11:23:46 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: liulongfang <liulongfang@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>, "Jonathan
 Cameron" <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH v2 0/5] bugfix some driver issues
Thread-Topic: [PATCH v2 0/5] bugfix some driver issues
Thread-Index: AQHbUfcNb4h9DrsuTEOkxIbeDob5qrLtVkDA
Date: Thu, 19 Dec 2024 10:23:46 +0000
Message-ID: <77c6242941f54360962705816d483444@huawei.com>
References: <20241219091800.41462-1-liulongfang@huawei.com>
In-Reply-To: <20241219091800.41462-1-liulongfang@huawei.com>
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

Hi Longfang,

> -----Original Message-----
> From: liulongfang <liulongfang@huawei.com>
> Sent: Thursday, December 19, 2024 9:18 AM
> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
> Subject: [PATCH v2 0/5] bugfix some driver issues
>=20
> As the test scenarios for the live migration function become
> more and more extensive. Some previously undiscovered driver
> issues were found.
> Update and fix through this patchset.
>=20

A changes history will be beneficial to understand what changed from v1.

Also I have a request.... As part of this series, could you please include =
the
below fix to this driver as well as we do have the same potential problem.

https://lore.kernel.org/all/20241021123843.42979-1-giovanni.cabiddu@intel.c=
om/

Thanks,
Shameer

> Longfang Liu (5):
>   hisi_acc_vfio_pci: fix XQE dma address error
>   hisi_acc_vfio_pci: add eq and aeq interruption restore
>   hisi_acc_vfio_pci: bugfix cache write-back issue
>   hisi_acc_vfio_pci: bugfix the problem of uninstalling driver
>   hisi_acc_vfio_pci: bugfix live migration function without VF device
>     driver
>=20
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 83 ++++++++++++++++---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  9 +-
>  2 files changed, 78 insertions(+), 14 deletions(-)
>=20
> --
> 2.24.0


