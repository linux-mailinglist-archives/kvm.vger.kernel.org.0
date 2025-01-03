Return-Path: <kvm+bounces-34529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C81B4A00A40
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 15:05:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 96DBD1611CC
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 14:05:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64FA91B983E;
	Fri,  3 Jan 2025 14:05:09 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A300417FE
	for <kvm@vger.kernel.org>; Fri,  3 Jan 2025 14:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735913108; cv=none; b=NpjMUD7hjTcQ711UxEILmXzSdjsRw/g/SUyt27QL/VKNsFD9mfJOjHQTzgGVMLH+OrQ3AqzDyR6WsJN+FUQamBNkPXvkgr5riodibzpE/V4DIwGhret7PVl8j2DBhx9FEuwbqWYXxBZ/m5L1CM1ldhCw5ggTt98c3+nudopJ9v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735913108; c=relaxed/simple;
	bh=EashV+UhamiDS57oqlEwZNNqB437lRGhsQMdLSWQBNE=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RDuvrS/ARxdSViujcVbmR9Y1ZsOVa7yVRFBIDBZt6Xy2rGKoUbpQq2uOkBvRiqLM1lSG9rx2VfqjmV6yB+PtKIDl5V/1WsgErwhMaBbRiPnnp4t0H3HJVdxUcG7bcUXXcVDE4tDIcsUikn6gaTYSnjkDpnCa3mVbyiKdoe6zDjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4YPlbG58ttz6K9LP;
	Fri,  3 Jan 2025 22:00:42 +0800 (CST)
Received: from frapeml500003.china.huawei.com (unknown [7.182.85.28])
	by mail.maildlp.com (Postfix) with ESMTPS id 68DF91406AC;
	Fri,  3 Jan 2025 22:05:04 +0800 (CST)
Received: from localhost (10.47.74.248) by frapeml500003.china.huawei.com
 (7.182.85.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Fri, 3 Jan
 2025 15:05:03 +0100
Date: Fri, 3 Jan 2025 14:04:57 +0000
From: Alireza Sanaee <alireza.sanaee@huawei.com>
To: Zhao Liu <zhao1.liu@intel.com>
CC: Rob Herring <robh@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	"Daniel P . Berrang" <berrange@redhat.com>, Igor Mammedov
	<imammedo@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, "Marcel
 Apfelbaum" <marcel.apfelbaum@gmail.com>, Philippe Mathieu-Daud
	<philmd@linaro.org>, Yanan Wang <wangyanan55@huawei.com>, "Michael S .
 Tsirkin" <mst@redhat.com>, Richard Henderson <richard.henderson@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Sia Jee Heng
	<jeeheng.sia@starfivetech.com>, <qemu-devel@nongnu.org>,
	<kvm@vger.kernel.org>
Subject: Re: [PATCH v6 0/4] i386: Support SMP Cache Topology
Message-ID: <20250103140457.00004c4b@huawei.com>
In-Reply-To: <Z3efFsigJ6SxhqMf@intel.com>
References: <20241219083237.265419-1-zhao1.liu@intel.com>
	<44212226-3692-488b-8694-935bd5c3a333@redhat.com>
	<Z2t2DuMBYb2mioB0@intel.com>
	<20250102145708.0000354f@huawei.com>
	<CAL_JsqKeA4dSwO40VgARVAiVM=w1PU8Go8GJYv4v8Wri64UFbw@mail.gmail.com>
	<20250102180141.00000647@huawei.com>
	<Z3efFsigJ6SxhqMf@intel.com>
Organization: Huawei
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: lhrpeml100003.china.huawei.com (7.191.160.210) To
 frapeml500003.china.huawei.com (7.182.85.28)

On Fri, 3 Jan 2025 16:25:58 +0800
Zhao Liu <zhao1.liu@intel.com> wrote:

> On Thu, Jan 02, 2025 at 06:01:41PM +0000, Alireza Sanaee wrote:
> > Date: Thu, 2 Jan 2025 18:01:41 +0000
> > From: Alireza Sanaee <alireza.sanaee@huawei.com>
> > Subject: Re: [PATCH v6 0/4] i386: Support SMP Cache Topology
> > X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
> >=20
> > On Thu, 2 Jan 2025 11:09:51 -0600
> > Rob Herring <robh@kernel.org> wrote:
> >  =20
> > > On Thu, Jan 2, 2025 at 8:57=E2=80=AFAM Alireza Sanaee
> > > <alireza.sanaee@huawei.com> wrote: =20
> > > >
> > > > On Wed, 25 Dec 2024 11:03:42 +0800
> > > > Zhao Liu <zhao1.liu@intel.com> wrote:
> > > >   =20
> > > > > > > About smp-cache
> > > > > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > > > >
> > > > > > > The API design has been discussed heavily in [3].
> > > > > > >
> > > > > > > Now, smp-cache is implemented as a array integrated in
> > > > > > > -machine. Though -machine currently can't support JSON
> > > > > > > format, this is the one of the directions of future.
> > > > > > >
> > > > > > > An example is as follows:
> > > > > > >
> > > > > > > smp_cache=3Dsmp-cache.0.cache=3Dl1i,smp-cache.0.topology=3Dco=
re,smp-cache.1.cache=3Dl1d,smp-cache.1.topology=3Dcore,smp-cache.2.cache=3D=
l2,smp-cache.2.topology=3Dmodule,smp-cache.3.cache=3Dl3,smp-cache.3.topolog=
y=3Ddie
> > > > > > >
> > > > > > > "cache" specifies the cache that the properties will be
> > > > > > > applied on. This field is the combination of cache level
> > > > > > > and cache type. Now it supports "l1d" (L1 data cache),
> > > > > > > "l1i" (L1 instruction cache), "l2" (L2 unified cache) and
> > > > > > > "l3" (L3 unified cache).
> > > > > > >
> > > > > > > "topology" field accepts CPU topology levels including
> > > > > > > "thread", "core", "module", "cluster", "die", "socket",
> > > > > > > "book", "drawer" and a special value "default".   =20
> > > > > >
> > > > > > Looks good; just one thing, does "thread" make sense?  I
> > > > > > think that it's almost by definition that threads within a
> > > > > > core share all caches, but maybe I'm missing some hardware
> > > > > > configurations.=20
> > > > >
> > > > > Hi Paolo, merry Christmas. Yes, AFAIK, there's no hardware has
> > > > > thread level cache.   =20
> > > >
> > > > Hi Zhao and Paolo,
> > > >
> > > > While the example looks OK to me, and makes sense. But would be
> > > > curious to know more scenarios where I can legitimately see
> > > > benefit there.
> > > >
> > > > I am wrestling with this point on ARM too. If I were to
> > > > have device trees describing caches in a way that threads get
> > > > their own private caches then this would not be possible to be
> > > > described via device tree due to spec limitations (+CCed Rob)
> > > > if I understood correctly.   =20
> > >=20
> > > You asked me for the opposite though, and I described how you can
> > > share the cache. If you want a cache per thread, then you probably
> > > want a node per thread.
> > >=20
> > > Rob
> > >  =20
> >=20
> > Hi Rob,
> >=20
> > That's right, I made the mistake in my prior message, and you
> > recalled correctly. I wanted shared caches between two threads,
> > though I have missed your answer before, just found it.
> >  =20
>=20
> Thank you all!
>=20
> Alireza, do you know how to configure arm node through QEMU options?

Hi Zhao, do you mean the -smp param?
>=20
> However, IIUC, arm needs more effort to configure cache per thread (by
> configuring node topology)...In that case, since no one has explicitly
> requested the need for cache per thread, I can disable cache per
> thread for now. I can return an error for this scenario during the
> general smp-cache option parsing (in the future, if there is a real
> need, it can be easily re-enabled).
>=20
> Will drop cache per thread in the next version.
>=20
> Thanks,
> Zhao
>=20
>=20


