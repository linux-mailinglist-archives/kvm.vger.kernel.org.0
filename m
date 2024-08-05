Return-Path: <kvm+bounces-23198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 725C69477FE
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 11:09:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C6A21F225D5
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 09:09:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 948AD14E2D8;
	Mon,  5 Aug 2024 09:09:44 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A09145327;
	Mon,  5 Aug 2024 09:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722848984; cv=none; b=LPcjj2KxE+BRANzEFE9ULEWc2tP9uxvLJRdWkwZLI8peAQrF3WtNOAkwXnAZF0SlGlsCUElcmWUFk8Gs6iZU55OQhEXB91TpPt1OTgPK9gxR053HCY5HRfYth4ffahQL6QrtmGSp8EIkeez7K7s8tnPVTF4hse4kmkcMRlbVDag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722848984; c=relaxed/simple;
	bh=Wh0+7svowXmAXWq46ZrhJw2OehTiS0zjYYm8gA3e1hg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rT9e4//GcEq6b6SGnEepiFa67gZ2fk85UwjCH205ANhOC9EkN35Sw0LV8bNfbU9u2enhitZPrhcgKTi9nuVO/ZDFlwdQNYw/Ds+Hl5dyWddKEwKM8H5BBRm9GBeVmpEBQuTWZPHGkWzpMEyL+2Q+Wm3ukROvfAIdnVVZIPQ7Pi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4WcrCv0KCHz6K6QK;
	Mon,  5 Aug 2024 17:06:51 +0800 (CST)
Received: from lhrpeml500006.china.huawei.com (unknown [7.191.161.198])
	by mail.maildlp.com (Postfix) with ESMTPS id 6DEDD140C72;
	Mon,  5 Aug 2024 17:09:38 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml500006.china.huawei.com (7.191.161.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 5 Aug 2024 10:09:38 +0100
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.039;
 Mon, 5 Aug 2024 10:09:38 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: liulongfang <liulongfang@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>, "Jonathan
 Cameron" <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH v7 4/4] Documentation: add debugfs description for hisi
 migration
Thread-Topic: [PATCH v7 4/4] Documentation: add debugfs description for hisi
 migration
Thread-Index: AQHa4nsxdri5qkP6rUmrCjoljPKh17IYZMFw
Date: Mon, 5 Aug 2024 09:09:37 +0000
Message-ID: <6b13310df6df42faba08eb7335c4b33b@huawei.com>
References: <20240730121438.58455-1-liulongfang@huawei.com>
 <20240730121438.58455-5-liulongfang@huawei.com>
In-Reply-To: <20240730121438.58455-5-liulongfang@huawei.com>
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
> Sent: Tuesday, July 30, 2024 1:15 PM
> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
> Subject: [PATCH v7 4/4] Documentation: add debugfs description for hisi
> migration
>=20
> Add a debugfs document description file to help users understand
> how to use the hisilicon accelerator live migration driver's
> debugfs.
>=20
> Update the file paths that need to be maintained in MAINTAINERS
>=20
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---
>  .../ABI/testing/debugfs-hisi-migration        | 25 +++++++++++++++++++
>  1 file changed, 25 insertions(+)
>  create mode 100644 Documentation/ABI/testing/debugfs-hisi-migration
>=20
> diff --git a/Documentation/ABI/testing/debugfs-hisi-migration
> b/Documentation/ABI/testing/debugfs-hisi-migration
> new file mode 100644
> index 000000000000..053f3ebba9b1
> --- /dev/null
> +++ b/Documentation/ABI/testing/debugfs-hisi-migration
> @@ -0,0 +1,25 @@
> +What:
> 	/sys/kernel/debug/vfio/<device>/migration/hisi_acc/dev_data
> +Date:		Jul 2024
> +KernelVersion:  6.11
> +Contact:	Longfang Liu <liulongfang@huawei.com>
> +Description:	Read the configuration data and some status data
> +		required for device live migration. These data include device
> +		status data, queue configuration data, some task
> configuration
> +		data and device attribute data. The output format of the data
> +		is defined by the live migration driver.
> +
> +What:
> 	/sys/kernel/debug/vfio/<device>/migration/hisi_acc/migf_data
> +Date:		Jul 2024
> +KernelVersion:  6.11
> +Contact:	Longfang Liu <liulongfang@huawei.com>
> +Description:	Read the data from the last completed live migration.
> +		This data includes the same device status data as in
> "dev_data".
> +		And some device status data after the migration is
> completed.

Actually what info is different from dev_data here? Only that it is the
dev_data after a migration is attempted/completed, right?

Thanks,
Shameer

> +
> +What:
> 	/sys/kernel/debug/vfio/<device>/migration/hisi_acc/cmd_state
> +Date:		Jul 2024
> +KernelVersion:  6.11
> +Contact:	Longfang Liu <liulongfang@huawei.com>
> +Description:	Used to obtain the device command sending and receiving
> +		channel status. Returns failure or success logs based on the
> +		results.
> --
> 2.24.0


