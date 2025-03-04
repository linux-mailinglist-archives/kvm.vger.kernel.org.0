Return-Path: <kvm+bounces-40023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 72F56A4DDE0
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 13:27:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 798AF3B2EA8
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 12:27:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61625202C2D;
	Tue,  4 Mar 2025 12:27:06 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2EA78F4C;
	Tue,  4 Mar 2025 12:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741091225; cv=none; b=nDvBiPOrbGLSIWz6K/2mjshuhCrOUd9C7UsgVzj7HcaPFjL2GU8k0rkjTfxWZ3Dd28AH7sw6L66DM7M213VHlWY0jT4SvTDRGu/gNNf6vdUt6+6vHGy/UipuvEYZRkFK92HwgRlv659XDTB/+E3SViJAJ3k2zJk22PxmvAU5HIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741091225; c=relaxed/simple;
	bh=VZwo7yIopqaSoCkScnbhAKG3Hk9pFePeDrDhz1+e4Xg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=u1huOQNuAMEqTbB36c7F2uwb0cpDNeUqArXVTjU9Od8pg5S1rTAubYwUMO4+D/90485UClsEhd2e1IXIYqXVVyWs3rndTJl7l+yZmYqU298hOeBkqQdSkP48Bf5wIxxFXq6nRm4KPKEfhcQOi+vHcMQcnrAAViJehn72zmsayOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Z6Zc45k1Yz6M4c3;
	Tue,  4 Mar 2025 20:24:04 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 612E7140415;
	Tue,  4 Mar 2025 20:27:00 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 4 Mar 2025 13:27:00 +0100
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Tue, 4 Mar 2025 13:27:00 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: liulongfang <liulongfang@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>, "Jonathan
 Cameron" <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH v2 0/3] update live migration configuration region
Thread-Topic: [PATCH v2 0/3] update live migration configuration region
Thread-Index: AQHbjP24f+s3bC9JCk6yB9EQqmW997Ni5NVQ
Date: Tue, 4 Mar 2025 12:26:59 +0000
Message-ID: <0b5399e306f841b794120e6ca91c1edd@huawei.com>
References: <20250304120528.63605-1-liulongfang@huawei.com>
In-Reply-To: <20250304120528.63605-1-liulongfang@huawei.com>
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
> Sent: Tuesday, March 4, 2025 12:05 PM
> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
> Subject: [PATCH v2 0/3] update live migration configuration region
>=20
> On the new hardware platform, the configuration register space
> of the live migration function is set on the PF, while on the
> old platform, this part is placed on the VF.
>=20
> Change v1 -> v2
> 	Delete the vf_qm_state read operation in Pre_Copy

If I understand correctly, previously this was discussed in your bug fix se=
ries here,
https://lore.kernel.org/all/fa8cd8c1cdbe4849b445ffd8f4894515@huawei.com/

And why we are having it here in this new hardware support series now?

Could we please move all the existing bug fixes in one series and support f=
or
new platform in another series, please.

Thanks,
Shameer


