Return-Path: <kvm+bounces-31598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 11B8A9C5164
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 10:03:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1D448B2D7DD
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 08:43:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD66A212194;
	Tue, 12 Nov 2024 08:40:09 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F06920BB23;
	Tue, 12 Nov 2024 08:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731400809; cv=none; b=X+l9uBMhCWHG4GYPNzqdM8iqtA4tr+AjmR7/DyHe3oC2BG28YLDHyRFFShbWJQHzvE6lEX98APhpvEV8dkaSrjguOhrb8bsrDVZ/ZM5DNtgjtj0MF2qyl8zWdjPNCK6oRyjzMtw+q8c+XRQMRAEGrJevQxtm6AWvIOS8CgENSZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731400809; c=relaxed/simple;
	bh=TdNm9lt7INn6v6tFtBGy259qRCJfD0xoMjjyaXHVgMI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ShIFCAPGUUckCbN3XlcaWHoDS/jSiGM6fYRRAqGC45qy2yzVHfdwg2BuiAVXnWFK+lxUaG6F3thPUzPDGMXKXVLgICrzS3r1NooxztDDkUmA/cy5XESlHZJCPk7JMQylo4HqHv7NCqo13WQ2hBK4EPyW7dM5GyIWtgRek1hnfOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Xnfsj655Kz6K6sp;
	Tue, 12 Nov 2024 16:36:57 +0800 (CST)
Received: from frapeml100006.china.huawei.com (unknown [7.182.85.201])
	by mail.maildlp.com (Postfix) with ESMTPS id 7E2D6140C72;
	Tue, 12 Nov 2024 16:40:03 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml100006.china.huawei.com (7.182.85.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 12 Nov 2024 09:40:03 +0100
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Tue, 12 Nov 2024 09:40:03 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: liulongfang <liulongfang@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>, "Jonathan
 Cameron" <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH v15 3/4] hisi_acc_vfio_pci: register debugfs for hisilicon
 migration driver
Thread-Topic: [PATCH v15 3/4] hisi_acc_vfio_pci: register debugfs for
 hisilicon migration driver
Thread-Index: AQHbNNV2zCpG8rxQT0i37T+GTvsNQLKzUpKA
Date: Tue, 12 Nov 2024 08:40:03 +0000
Message-ID: <1c0a2990bc6243b281d53177bc30cc92@huawei.com>
References: <20241112073322.54550-1-liulongfang@huawei.com>
 <20241112073322.54550-4-liulongfang@huawei.com>
In-Reply-To: <20241112073322.54550-4-liulongfang@huawei.com>
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
> Sent: Tuesday, November 12, 2024 7:33 AM
> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
> Subject: [PATCH v15 3/4] hisi_acc_vfio_pci: register debugfs for hisilico=
n
> migration driver
>=20
>=20
> +static void hisi_acc_vfio_debug_init(struct hisi_acc_vf_core_device
> *hisi_acc_vdev)
> +{
> +	struct vfio_device *vdev =3D &hisi_acc_vdev->core_device.vdev;
> +	struct hisi_acc_vf_migration_file *migf =3D NULL;
> +	struct dentry *vfio_dev_migration =3D NULL;
> +	struct dentry *vfio_hisi_acc =3D NULL;

Nit, I think we can get rid of these NULL initializations.

If you have time, please consider respin (sorry, missed this in earlier rev=
iews.)

Thanks,
Shameer

