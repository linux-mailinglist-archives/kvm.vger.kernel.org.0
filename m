Return-Path: <kvm+bounces-29641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DDEAE9AE5EB
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 15:19:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B1D31C21C74
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 13:19:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A07AD1E0B6F;
	Thu, 24 Oct 2024 13:19:01 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE6B1DFEF;
	Thu, 24 Oct 2024 13:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729775941; cv=none; b=sJVlGrDOI347kA5H8zYoGUx56TSNAwUE99X7ghbdadV3EBOujhx/9ORJAWOpnQ2EaDxFMJwfJ9ZTx5FYYzEpSgCSP+u33jqJt6QVbrdqMczXakXFnBHjMl2bb3V+S/OK0QmzPweDoOoPW94j06Jid2fNS2m4NbobunxK/kF738M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729775941; c=relaxed/simple;
	bh=YcI0gpogsC9zVPR1+j6BU7Ky+gbLnmdXSrdNoIDTGXI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RwQSPBaO58csHvS9CcqsZP65UXstSBZtQHhwA/mKj+wz0XP4H4l2c38/Opdlr7QxD/J50FA2zxiPKfbPQkF72wjqfbrLfS1egq/IqvO0Td25r6ivO+WaI3PSdQT4wY1ZxwoNn7YD56R+h8yGfICA6turAph4INPPDIwwktng3oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XZ5wP2kskz6LDYZ;
	Thu, 24 Oct 2024 21:14:13 +0800 (CST)
Received: from frapeml100008.china.huawei.com (unknown [7.182.85.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 72738140D26;
	Thu, 24 Oct 2024 21:18:55 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml100008.china.huawei.com (7.182.85.131) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 24 Oct 2024 15:18:55 +0200
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Thu, 24 Oct 2024 15:18:55 +0200
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: liulongfang <liulongfang@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>, "Jonathan
 Cameron" <jonathan.cameron@huawei.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH v10 0/4] debugfs to hisilicon migration driver
Thread-Topic: [PATCH v10 0/4] debugfs to hisilicon migration driver
Thread-Index: AQHbH2oB0l11SSHpU0u1ubTVKcydHLKV7z/g
Date: Thu, 24 Oct 2024 13:18:55 +0000
Message-ID: <3ede2cf97ffd4dd6948aa06084a09d2d@huawei.com>
References: <20241016012308.14108-1-liulongfang@huawei.com>
In-Reply-To: <20241016012308.14108-1-liulongfang@huawei.com>
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

Hi Alex,

> -----Original Message-----
> From: liulongfang <liulongfang@huawei.com>
> Sent: Wednesday, October 16, 2024 2:23 AM
> To: alex.williamson@redhat.com; jgg@nvidia.com; Shameerali Kolothum
> Thodi <shameerali.kolothum.thodi@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linuxarm@openeuler.org; liulongfang <liulongfang@huawei.com>
> Subject: [PATCH v10 0/4] debugfs to hisilicon migration driver
>=20
> Add a debugfs function to the hisilicon migration driver in VFIO to
> provide intermediate state values and data during device migration.
>=20
> When the execution of live migration fails, the user can view the
> status and data during the migration process separately from the
> source and the destination, which is convenient for users to analyze
> and locate problems.

Could you please take another look at this series as it looks like almost t=
here.

Thanks,
Shameer


