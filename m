Return-Path: <kvm+bounces-22224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 44B4093C07C
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 12:59:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 02CD01F2255D
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 10:59:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9A751991A1;
	Thu, 25 Jul 2024 10:59:09 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B807CF16
	for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 10:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721905149; cv=none; b=jdimCAozuarsQwoN7G10jZmDsj7PMhI+vjdqBY/2g1n0IkXicFAHVvt5HUv3jNjIfsg6x1MfXnlx2rKDTbLbByZBDksVrqEbKQOdHXu9+WAKW6reGikfsP7Rchj7YmeslMDenDHxhVNfWdY+NPNxuM/5PVk7bZCfqfvcES0EsnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721905149; c=relaxed/simple;
	bh=DtEsrJr+qWbmvpUvKTdjzB74uP6Rps+CtU+eJRsqEBA=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dr/xG1Ma4GhNADOirpZ2a7Z8uGKQa/dbBG4i2KD0mNLVCoppSCRpnmT0Bf1THH0yPRh90iVVxBlaWfPNFYpNdKj8kA3Lgnd5U7a9MQUJTDuhnrp37puD9P6gwCLfy9NnSl3KlwD5hfmJvLEUm51AbAckCGPpCzXiHDZddNf3Uj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=Huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4WV79d5jBwz6K9Gq;
	Thu, 25 Jul 2024 18:56:37 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id B2103140594;
	Thu, 25 Jul 2024 18:59:03 +0800 (CST)
Received: from localhost (10.203.174.77) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Thu, 25 Jul
 2024 11:59:03 +0100
Date: Thu, 25 Jul 2024 11:59:02 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Markus Armbruster <armbru@redhat.com>
CC: Zhao Liu <zhao1.liu@intel.com>, <berrange@redhat.com>, Eduardo Habkost
	<eduardo@habkost.net>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?ISO-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>, Yanan Wang
	<wangyanan55@huawei.com>, "Michael S.Tsirkin " <mst@redhat.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Richard Henderson
	<richard.henderson@linaro.org>, Eric Blake <eblake@redhat.com>, "Marcelo
 Tosatti" <mtosatti@redhat.com>, Alex =?ISO-8859-1?Q?Benn=E9e?=
	<alex.bennee@linaro.org>, Peter Maydell <peter.maydell@linaro.org>, "Sia Jee
 Heng" <jeeheng.sia@starfivetech.com>, <qemu-devel@nongnu.org>,
	<kvm@vger.kernel.org>, <qemu-riscv@nongnu.org>, <qemu-arm@nongnu.org>,
	"Zhenyu Wang" <zhenyu.z.wang@intel.com>, Dapeng Mi
	<dapeng1.mi@linux.intel.com>, Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [PATCH 2/8] qapi/qom: Introduce smp-cache object
Message-ID: <20240725115902.000037e4@Huawei.com>
In-Reply-To: <20240725115059.000016c5@Huawei.com>
References: <20240704031603.1744546-1-zhao1.liu@intel.com>
	<20240704031603.1744546-3-zhao1.liu@intel.com>
	<87wmld361y.fsf@pond.sub.org>
	<Zp5tBHBoeXZy44ys@intel.com>
	<87h6cfowei.fsf@pond.sub.org>
	<ZqEV8uErCn+QkOw8@intel.com>
	<871q3hua56.fsf@pond.sub.org>
	<20240725115059.000016c5@Huawei.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100006.china.huawei.com (7.191.160.224) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

On Thu, 25 Jul 2024 11:50:59 +0100
Jonathan Cameron <Jonathan.Cameron@Huawei.com> wrote:

Resending as this bounced due (I think) to an address typo.

> Hi Markus, Zhao Liu
> 
> From the ARM server side this is something I want to see as well.
> So I can comment on why we care.
> 
> > >> This series adds a way to configure caches.
> > >> 
> > >> Structure of the configuration data: a list
> > >> 
> > >>     [{"name": N, "topo": T}, ...]
> > >> 
> > >> where N can be "l1d", "l1i", "l2", or "l3",
> > >>   and T can be "invalid", "thread", "core", "module", "cluster",
> > >>                "die", "socket", "book", "drawer", or "default".
> > >> 
> > >> What's the use case?  The commit messages don't tell.    
> > >
> > > i386 has the default cache topology model: l1 per core/l2 per core/l3
> > > per die.
> > >
> > > Cache topology affects scheduler performance, e.g., kernel's cluster
> > > scheduling.
> > >
> > > Of course I can hardcode some cache topology model in the specific cpu
> > > model that corresponds to the actual hardware, but for -cpu host/max,
> > > the default i386 cache topology model has no flexibility, and the
> > > host-cpu-cache option doesn't have enough fine-grained control over the
> > > cache topology.
> > >
> > > So I want to provide a way to allow user create more fleasible cache
> > > topology. Just like cpu topology.    
> > 
> > 
> > So the use case is exposing a configurable cache topology to the guest
> > in order to increase performance.  Performance can increase when the
> > configured virtual topology is closer to the physical topology than a
> > default topology would be.  This can be the case with CPU host or max.
> > 
> > Correct?  
> 
> That is definitely why we want it on arm64 where this info fills in
> the topology we can't get from the CPU registers.
> (we should have patches on top of this to send out shortly).
> 
> As a side note we also need this for MPAM emulation for TCG
> (any maybe eventually paravirtualized MPAM) as this is needed
> to build the right PPTT to describe the caches which we then
> query to figure out association of MPAM controls with particularly
> caches.
> 
> Size configuration is something we'll need down the line (presenting
> only part of an L3 may make sense if it's shared by multiple VMs
> or partitioned with MPAM) but that's a future question.
> 
> 
> >   
> > >> Why does that use case make no sense without SMP?    
> > >
> > > As the example I mentioned, for Intel hyrbid architecture, P cores has
> > > l2 per core and E cores has l2 per module. Then either setting the l2
> > > topology level as core nor module, can emulate the real case.
> > >
> > > Even considering the more extreme case of Intel 14th MTL CPU, where
> > > some E cores have L3 and some don't even have L3. As well as the last
> > > time you and Daniel mentioned that in the future we could consider
> > > covering more cache properties such as cache size. But the l3 size can
> > > be different in the same system, like AMD's x3D technology. So
> > > generally configuring properties for @name in a list can't take into
> > > account the differences of heterogeneous caches with the same @name.
> > >
> > > Hope my poor english explains the problem well. :-)    
> > 
> > I think I understand why you want to configure caches.  My question was
> > about the connection to SMP.
> > 
> > Say we run a guest with a single core, no SMP.  Could configuring caches
> > still be useful then?  
> 
> Probably not useful to configure topology (sizes are a separate question)
> - any sensible default should be fine.
> 
> Jonathan
> 
> 


