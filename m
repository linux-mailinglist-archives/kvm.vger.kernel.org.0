Return-Path: <kvm+bounces-29076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AD3F39A237F
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 15:19:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 58F651F2835C
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 13:19:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C63BA1DDC21;
	Thu, 17 Oct 2024 13:19:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E551DCB17
	for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 13:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729171173; cv=none; b=tfn1fgZEvMa5zqDXsqYr6qW2jUupYRDJ9eDqJbC3KYKvzZAzyS2L1eJQ936MLVvqwDAkMmN6z8BuWzXQV2yCWDyeJfrcGFu/hVyDqgj9os94fml7DgHckgvltViqbw8JAQsB6gfUwAyMTBGn/wMPLdfAP2zEH6GMdbJ2fLytolI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729171173; c=relaxed/simple;
	bh=ehgjvMn3KBU0L260VYluL1SN/mQEuIDcAVYwzHdqzG4=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G2X0CaRplMCdhaYzb4pSpvFSHwcZVb2KWTtRHfY//ecPdSYDXKmT047wZhW9IrWNt0dXFzgaarKqkn42N+bMPpk4gSi38axPMKaOW72p/4kaRQgVDMJRf0XU4KXZ8M4qF9MADJ9qm7bpcQv6wayC2K0FvJQeolbGgPjsoP9XvUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XTpLt2DRqz6JBTK;
	Thu, 17 Oct 2024 21:18:46 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 99CE81400DB;
	Thu, 17 Oct 2024 21:19:26 +0800 (CST)
Received: from localhost (10.126.174.164) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Thu, 17 Oct
 2024 15:19:25 +0200
Date: Thu, 17 Oct 2024 14:19:23 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Zhao Liu <zhao1.liu@intel.com>
CC: "Daniel P =?ISO-8859-1?Q?Berrang=E9?=" <berrange@redhat.com>, "Igor
 Mammedov" <imammedo@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Philippe =?ISO-8859-1?Q?Ma?=
 =?ISO-8859-1?Q?thieu-Daud=E9?= <philmd@linaro.org>, Yanan Wang
	<wangyanan55@huawei.com>, "Michael S.Tsirkin " <mst@redhat.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Richard Henderson
	<richard.henderson@linaro.org>, Eric Blake <eblake@redhat.com>, "Markus
 Armbruster" <armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, Alex
 =?ISO-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, Peter Maydell
	<peter.maydell@linaro.org>, Sia Jee Heng <jeeheng.sia@starfivetech.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>, <qemu-devel@nongnu.org>,
	<kvm@vger.kernel.org>, <qemu-riscv@nongnu.org>, <qemu-arm@nongnu.org>,
	"Zhenyu Wang" <zhenyu.z.wang@intel.com>, Dapeng Mi
	<dapeng1.mi@linux.intel.com>
Subject: Re: [PATCH v3 0/7] Introduce SMP Cache Topology
Message-ID: <20241017141923.00007f64@Huawei.com>
In-Reply-To: <20241012104429.1048908-1-zhao1.liu@intel.com>
References: <20241012104429.1048908-1-zhao1.liu@intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: lhrpeml500002.china.huawei.com (7.191.160.78) To
 frapeml500008.china.huawei.com (7.182.85.71)

RESEND (again, sorry) as didn't reach list.
Issue some stray " in various email addresses.

On Sat, 12 Oct 2024 18:44:22 +0800
Zhao Liu <zhao1.liu@intel.com> wrote:

> Hi all,
>=20
> Compared with v2 [1], the changes in v3 are quite minor, and most of
> patches (except for patch 1 and 7) have received Jonathan=E2=80=99s R/b (=
thanks
> Jonathan!).
>=20
> Meanwhile, ARM side has also worked a lot on the smp-cache based on
> this series [2], so I think we are very close to the final merge, to
> catch up with this cycle. :)

This would finally solve a long standing missing control for our
virtualization usecases (TCG and MPAM stuff is an added bonus),
so I'm very keen in this making 9.2 (and maybe even the ARM part
of things happen to move fast enough). Ali is out this week,
but should be back sometime next week. Looks like rebase of his
ARM patches on this should be simple!

I think this set mostly needs a QAPI review (perhaps from Markus?)

>=20
> This series is based on the commit 7e3b6d8063f2 ("Merge tag 'crypto-
> fixes-pull-request' of https://gitlab.com/berrange/qemu into staging").
>=20
> Background
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> The x86 and ARM (RISCV) need to allow user to configure cache properties
*laughs*. I definitely going to start emailing ARM folk with
ARM (RISCV) =20
:) =20


> (current only topology):
>  * For x86, the default cache topology model (of max/host CPU) does not
>    always match the Host's real physical cache topology. Performance can
>    increase when the configured virtual topology is closer to the
>    physical topology than a default topology would be.
>  * For ARM, QEMU can't get the cache topology information from the CPU
>    registers, then user configuration is necessary. Additionally, the
>    cache information is also needed for MPAM emulation (for TCG) to
>    build the right PPTT. (Originally from Jonathan)

