Return-Path: <kvm+bounces-24120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 566539517C9
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 11:36:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D6C15B23DA6
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 09:36:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4958814A4C3;
	Wed, 14 Aug 2024 09:35:53 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA8E139590;
	Wed, 14 Aug 2024 09:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723628152; cv=none; b=iT4jwX9LmdNAEDo3KvHfFBS70bT2tszTglhX6UY434G9Gut7uapQUvEYg8uqinVgtUHm6y65+SRWb3atRzjpd1tXM3qhvfIql+B1pD7e6LP4I32Ilglmz+qBSOhhsxqg/HvunOa/mrz3TbxxFYmFW9hCWq1O1LjthY7opPr2DpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723628152; c=relaxed/simple;
	bh=MSOQCrj9wCA/RfbouaPAXc8JM5QATuJnf3y9gXmCIM0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=da/mTseiw9QtvO8aAFx4TVXGctWkGodfB/Y2J6BD5L9wCt7Qmr/FOxbP+VTFQFCWjqV6KkyPsmvs9cCUC2vL64LVuWTJtxlRq5V7Qqf9ImtpLhArhNIJvZlj47pzNHzObf9A/EiO9ITHDRPxZAWfyXP9eh4gsRPP+IbD4gqBjns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4WkNN54Cfzz6K8yn;
	Wed, 14 Aug 2024 17:33:09 +0800 (CST)
Received: from lhrpeml100003.china.huawei.com (unknown [7.191.160.210])
	by mail.maildlp.com (Postfix) with ESMTPS id 5FE59140A35;
	Wed, 14 Aug 2024 17:35:47 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml100003.china.huawei.com (7.191.160.210) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 14 Aug 2024 10:35:47 +0100
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.039;
 Wed, 14 Aug 2024 10:35:47 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: liulongfang <liulongfang@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>, "Jonathan
 Cameron" <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH v8 4/4] Documentation: add debugfs description for hisi
 migration
Thread-Topic: [PATCH v8 4/4] Documentation: add debugfs description for hisi
 migration
Thread-Index: AQHa5/1vtg2O0BOBdUeZRhRC2k0A9rImindg
Date: Wed, 14 Aug 2024 09:35:46 +0000
Message-ID: <d3530c8dda504a22b983cccba0468382@huawei.com>
References: <20240806122928.46187-1-liulongfang@huawei.com>
 <20240806122928.46187-5-liulongfang@huawei.com>
In-Reply-To: <20240806122928.46187-5-liulongfang@huawei.com>
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
> Sent: Tuesday, August 6, 2024 1:29 PM
> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
> Subject: [PATCH v8 4/4] Documentation: add debugfs description for hisi
> migration
>=20
> Add a debugfs document description file to help users understand
> how to use the hisilicon accelerator live migration driver's
> debugfs.
>=20
> Update the file paths that need to be maintained in MAINTAINERS
>=20
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>

LGTM,

Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Thanks,
Shameer

