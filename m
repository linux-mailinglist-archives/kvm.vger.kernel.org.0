Return-Path: <kvm+bounces-34488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AE149FFAA4
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 15:57:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AD6227A188B
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 14:57:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C03B1B3944;
	Thu,  2 Jan 2025 14:57:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DE6CA6B
	for <kvm@vger.kernel.org>; Thu,  2 Jan 2025 14:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735829840; cv=none; b=m5FhoF0L9Spj2B3zIF80eE0PIPq9iH5XIGncj999W+GahaTaEkE1W8cW7Pn6PbnhRXaNCGNPgSg8Et7GduUtEvCO0/pPDhGlU6IjD1+62gQbDQCOImSazD9Q+VwhvauueQIhDmDl1Jm3kiGno3RRtJUMbPf4gZvwMRzH0AzRVMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735829840; c=relaxed/simple;
	bh=Wfqf6k8TcmHlgaowCQNLnhKGAkSKu8+xbAw9uYDrdPg=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oL5n3BSukxBTX3H+/Gv4bTa6PWniUEy025zFzIMQl1bwb23qsRLLy2GiTfaiXoAe906dCIq8RMWDxvV3iz3VpBnv4ULrJIsuhlaYSa0bY7srP1/YBgjUnNcCMzqlZ/x1qIkryujs5bDF1QtVXBIqFHuIjWm/t9x5PPCnaFrck88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4YP8t30vRNz6K6lF;
	Thu,  2 Jan 2025 22:56:27 +0800 (CST)
Received: from frapeml500003.china.huawei.com (unknown [7.182.85.28])
	by mail.maildlp.com (Postfix) with ESMTPS id 2115B1401F3;
	Thu,  2 Jan 2025 22:57:16 +0800 (CST)
Received: from localhost (10.47.73.182) by frapeml500003.china.huawei.com
 (7.182.85.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Thu, 2 Jan
 2025 15:57:15 +0100
Date: Thu, 2 Jan 2025 14:57:08 +0000
From: Alireza Sanaee <alireza.sanaee@huawei.com>
To: Zhao Liu <zhao1.liu@intel.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, "Daniel P . =?ISO-8859-1?Q?Berran?=
 =?ISO-8859-1?Q?g=E9?=" <berrange@redhat.com>, Igor Mammedov
	<imammedo@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, "Marcel
 Apfelbaum" <marcel.apfelbaum@gmail.com>, Philippe =?ISO-8859-1?Q?Mathieu-D?=
 =?ISO-8859-1?Q?aud=E9?= <philmd@linaro.org>, Yanan Wang
	<wangyanan55@huawei.com>, "Michael S . Tsirkin" <mst@redhat.com>, "Richard
 Henderson" <richard.henderson@linaro.org>, Jonathan Cameron
	<Jonathan.Cameron@huawei.com>, Sia Jee Heng <jeeheng.sia@starfivetech.com>,
	<qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, <robh@kernel.org>
Subject: Re: [PATCH v6 0/4] i386: Support SMP Cache Topology
Message-ID: <20250102145708.0000354f@huawei.com>
In-Reply-To: <Z2t2DuMBYb2mioB0@intel.com>
References: <20241219083237.265419-1-zhao1.liu@intel.com>
	<44212226-3692-488b-8694-935bd5c3a333@redhat.com>
	<Z2t2DuMBYb2mioB0@intel.com>
Organization: Huawei
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100003.china.huawei.com (7.191.160.210) To
 frapeml500003.china.huawei.com (7.182.85.28)

On Wed, 25 Dec 2024 11:03:42 +0800
Zhao Liu <zhao1.liu@intel.com> wrote:

> > > About smp-cache
> > > ===============
> > > 
> > > The API design has been discussed heavily in [3].
> > > 
> > > Now, smp-cache is implemented as a array integrated in -machine.
> > > Though -machine currently can't support JSON format, this is the
> > > one of the directions of future.
> > > 
> > > An example is as follows:
> > > 
> > > smp_cache=smp-cache.0.cache=l1i,smp-cache.0.topology=core,smp-cache.1.cache=l1d,smp-cache.1.topology=core,smp-cache.2.cache=l2,smp-cache.2.topology=module,smp-cache.3.cache=l3,smp-cache.3.topology=die
> > > 
> > > "cache" specifies the cache that the properties will be applied
> > > on. This field is the combination of cache level and cache type.
> > > Now it supports "l1d" (L1 data cache), "l1i" (L1 instruction
> > > cache), "l2" (L2 unified cache) and "l3" (L3 unified cache).
> > > 
> > > "topology" field accepts CPU topology levels including "thread",
> > > "core", "module", "cluster", "die", "socket", "book", "drawer"
> > > and a special value "default".  
> > 
> > Looks good; just one thing, does "thread" make sense?  I think that
> > it's almost by definition that threads within a core share all
> > caches, but maybe I'm missing some hardware configurations.  
> 
> Hi Paolo, merry Christmas. Yes, AFAIK, there's no hardware has thread
> level cache.

Hi Zhao and Paolo,

While the example looks OK to me, and makes sense. But would be curious
to know more scenarios where I can legitimately see benefit there.

I am wrestling with this point on ARM too. If I were to
have device trees describing caches in a way that threads get their own
private caches then this would not be possible to be
described via device tree due to spec limitations (+CCed Rob) if I
understood correctly.

Thanks,
Alireza

> 
> I considered the thread case is that it could be used for vCPU
> scheduling optimization (although I haven't rigorously tested the
> actual impact). Without CPU affinity, tasks in Linux are generally
> distributed evenly across different cores (for example, vCPU0 on Core
> 0, vCPU1 on Core 1). In this case, the thread-level cache settings
> are closer to the actual situation, with vCPU0 occupying the L1/L2 of
> Host core0 and vCPU1 occupying the L1/L2 of Host core1.
> 
> 
>   ©°©¤©¤©¤©´        ©°©¤©¤©¤©´
>   vCPU0        vCPU1
>   ©¦   ©¦        ©¦   ©¦
>   ©¸©¤©¤©¤©¼        ©¸©¤©¤©¤©¼
>  ©°©°©¤©¤©¤©´©°©¤©¤©¤©´©´ ©°©°©¤©¤©¤©´©°©¤©¤©¤©´©´
>  ©¦©¦T0 ©¦©¦T1 ©¦©¦ ©¦©¦T2 ©¦©¦T3 ©¦©¦
>  ©¦©¸©¤©¤©¤©¼©¸©¤©¤©¤©¼©¦ ©¦©¸©¤©¤©¤©¼©¸©¤©¤©¤©¼©¦
>  ©¸©¤©¤©¤©¤C0©¤©¤©¤©¤©¼ ©¸©¤©¤©¤©¤C1©¤©¤©¤©¤©¼
> 
> 
> The L2 cache topology affects performance, and cluster-aware
> scheduling feature in the Linux kernel will try to schedule tasks on
> the same L2 cache. So, in cases like the figure above, setting the L2
> cache to be per thread should, in principle, be better.
> 
> Thanks,
> Zhao
> 
> 


