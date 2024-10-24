Return-Path: <kvm+bounces-29640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF1CE9AE5CB
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 15:14:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81E01284C10
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 13:14:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71C981D89F8;
	Thu, 24 Oct 2024 13:14:34 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D63814A0AA;
	Thu, 24 Oct 2024 13:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729775673; cv=none; b=Acagm5vrOngw2BCKsDY5YGC/+TSMuyFm9H5qV2fnnlmtZz/m8SKcrvygEpd/mqQ4z1Yi/3y/EmEocdvKOmZsJyi2DBu1h5dFh0sZDrmsnpm7UwwSO9shaYIztKrDfJcJaIBYKHng7mXO15kdP7iflqIAWbuwYgMsgs4dOXdh5zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729775673; c=relaxed/simple;
	bh=Nxfs1d/lCKRe9KLLkMjIFYWHONkieDZywkbOKGK0e+Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=srzNiTj+Edkuyc3mYBlS/pwtKpg5BFy9g0DJGqmWX/I6CW0/pLbtyuz3M7bmXDxQnHFV+y/EhbLojSmsnUaxACVPh64+w4YuV1kAL0uZ/4AGArMAJ2KCcvEXyJPmIJsUQcdZnJ/IufYIiF7HNKPi8lw2G8ogSTMfulCCbrsYfTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XZ5tG05ygz6H6hD;
	Thu, 24 Oct 2024 21:12:22 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 61833140A9C;
	Thu, 24 Oct 2024 21:14:28 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 24 Oct 2024 15:14:28 +0200
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Thu, 24 Oct 2024 15:14:28 +0200
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: liulongfang <liulongfang@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>, "Jonathan
 Cameron" <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH v10 4/4] Documentation: add debugfs description for hisi
 migration
Thread-Topic: [PATCH v10 4/4] Documentation: add debugfs description for hisi
 migration
Thread-Index: AQHbH2pLbLDxkaSDjEeDUNxn7YvxxbKV7liQ
Date: Thu, 24 Oct 2024 13:14:27 +0000
Message-ID: <ed605351635849b79ae3ba28b47049b5@huawei.com>
References: <20241016012308.14108-1-liulongfang@huawei.com>
 <20241016012308.14108-5-liulongfang@huawei.com>
In-Reply-To: <20241016012308.14108-5-liulongfang@huawei.com>
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
> Sent: Wednesday, October 16, 2024 2:23 AM
> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
> Subject: [PATCH v10 4/4] Documentation: add debugfs description for hisi
> migration
>=20
> Add a debugfs document description file to help users understand
> how to use the hisilicon accelerator live migration driver's
> debugfs.
>=20
> Update the file paths that need to be maintained in MAINTAINERS
>=20
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>

LGTM:

Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Thanks,
Shameer

> ---
>  .../ABI/testing/debugfs-hisi-migration        | 25 +++++++++++++++++++
>  1 file changed, 25 insertions(+)
>  create mode 100644 Documentation/ABI/testing/debugfs-hisi-migration
>=20
> diff --git a/Documentation/ABI/testing/debugfs-hisi-migration
> b/Documentation/ABI/testing/debugfs-hisi-migration
> new file mode 100644
> index 000000000000..89e4fde5ec6a
> --- /dev/null
> +++ b/Documentation/ABI/testing/debugfs-hisi-migration
> @@ -0,0 +1,25 @@
> +What:
> 	/sys/kernel/debug/vfio/<device>/migration/hisi_acc/dev_data
> +Date:		Oct 2024
> +KernelVersion:  6.12
> +Contact:	Longfang Liu <liulongfang@huawei.com>
> +Description:	Read the configuration data and some status data
> +		required for device live migration. These data include device
> +		status data, queue configuration data, some task
> configuration
> +		data and device attribute data. The output format of the
> data
> +		is defined by the live migration driver.
> +
> +What:
> 	/sys/kernel/debug/vfio/<device>/migration/hisi_acc/migf_data
> +Date:		Oct 2024
> +KernelVersion:  6.12
> +Contact:	Longfang Liu <liulongfang@huawei.com>
> +Description:	Read the data from the last completed live migration.
> +		This data includes the same device status data as in
> "dev_data".
> +		The migf_data is the dev_data that is migrated.
> +
> +What:
> 	/sys/kernel/debug/vfio/<device>/migration/hisi_acc/cmd_state
> +Date:		Oct 2024
> +KernelVersion:  6.12
> +Contact:	Longfang Liu <liulongfang@huawei.com>
> +Description:	Used to obtain the device command sending and receiving
> +		channel status. Returns failure or success logs based on the
> +		results.
> --
> 2.24.0


