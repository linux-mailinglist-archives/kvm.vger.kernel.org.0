Return-Path: <kvm+bounces-28162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C76DF995F2A
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 07:45:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 813A1283255
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 05:45:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16DD61684AE;
	Wed,  9 Oct 2024 05:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m0jUZrVw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458B315380B
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 05:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728452727; cv=none; b=YQ7bnOZmeyuyix9UdM4FvZ2GG2NNK1MnP9tNDiRKwwNe859nvShbZdU3XRzBPETecEDer9LSBay/5Od4+7MjKuwCOafG7qoINgTM8oBrCZF3yfS2xKmbP8kYfiWqa7j40kxMCbdw7L/AtO/AuXx27+7RoVcSM9ubZpOfVSpoauA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728452727; c=relaxed/simple;
	bh=9pYDTK3HR96Un6CzOse/eSqGpHwAG/V7ph9HU0V5qWk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B+P/wJUlqWLA0m0lxufoZgk+gA+rRekEnV4Pf1YVQgcP3ik0jC8vxU/Os8nQaksm2rdM7h/a2zL4gXd7bAULjlpmjoGcwfLPtyCKiBCK+S/foMeyNrYDAPXSKQZZCScv0WzNLFAp4bQQy2S3mOoNiG6l6P40ldO95vfaOCuhHLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m0jUZrVw; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728452725; x=1759988725;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9pYDTK3HR96Un6CzOse/eSqGpHwAG/V7ph9HU0V5qWk=;
  b=m0jUZrVwE+1EiTEXQtRWpKn5cPBFHNaxov2DfXasnhYYBPJefYPo4gNF
   Xe0fHAaljjcRZoGLGBZ8qfiiIl2faEHMhG5mfz5eZZJsFfcxpMMr1Qemb
   XV0DXsHEOY4So3d5Gv+KU9SXB0ZPdG3SZgdh9tZlYJGEgdeQCMK2iK2mZ
   +ZGPpuZkNWpyrIfa5zwlYsX98s/Zhyk7hqzpADEqs4krCIToi9m+9F89D
   qbQFi+jV19BRzqyPoKMTofkDIZCMsXIdePBAxc5d4f9/n19qz5V1gMwCK
   OgHgFPh0/eUl5MRwZiz7xy/FrbJjdzih3LwRWdDuX3yCgjBOcLe/PbCRB
   w==;
X-CSE-ConnectionGUID: 9EqM4oeWTSulqha8LWctFA==
X-CSE-MsgGUID: AeUM3tXNS0C4LOY22OpI7Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11219"; a="27545680"
X-IronPort-AV: E=Sophos;i="6.11,189,1725346800"; 
   d="scan'208";a="27545680"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2024 22:45:24 -0700
X-CSE-ConnectionGUID: 3vUy2zWBQcSZlfFJZ2+OXQ==
X-CSE-MsgGUID: Vhs2SIyzQkyn0HaVgqI5jg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,189,1725346800"; 
   d="scan'208";a="76446635"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa010.fm.intel.com with ESMTP; 08 Oct 2024 22:45:18 -0700
Date: Wed, 9 Oct 2024 14:01:30 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Daniel P =?utf-8?B?LiBCZXJyYW5n77+9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?utf-8?B?TWF0aGlldS1EYXVk77+9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Sergio Lopez <slp@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Paul Durrant <paul@xen.org>,
	"Edgar E . Iglesias" <edgar.iglesias@gmail.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Alex =?utf-8?B?QmVubu+/vWU=?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [RFC v2 00/12] Introduce Hybrid CPU Topology via Custom Topology
 Tree
Message-ID: <ZwYcOuZAt7qX5ci3@intel.com>
References: <20240919061128.769139-1-zhao1.liu@intel.com>
 <20241008113038.00007ee4@Huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241008113038.00007ee4@Huawei.com>

Hi Jonathan,

Thank you for looking at here!

On Tue, Oct 08, 2024 at 11:30:38AM +0100, Jonathan Cameron wrote:
> Date: Tue, 8 Oct 2024 11:30:38 +0100
> From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
> Subject: Re: [RFC v2 00/12] Introduce Hybrid CPU Topology via Custom
>  Topology Tree
> X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
> 
> On Thu, 19 Sep 2024 14:11:16 +0800
> Zhao Liu <zhao1.liu@intel.com> wrote:
> 
> 
> > -smp maxsockets=1,maxdies=1,maxmodules=2,maxcores=2,maxthreads=2
> > -machine pc,custom-topo=on \
> > -device cpu-socket,id=sock0 \
> > -device cpu-die,id=die0,bus=sock0 \
> > -device cpu-module,id=mod0,bus=die0 \
> > -device cpu-module,id=mod1,bus=die0 \
> > -device x86-intel-core,id=core0,bus=mod0 \
> > -device x86-intel-atom,id=core1,bus=mod1 \
> > -device x86-intel-atom,id=core2,bus=mod1 \
> > -device host-x86_64-cpu,id=cpu0,socket-id=0,die-id=0,module-id=0,core-id=0,thread-id=0 \
> > -device host-x86_64-cpu,id=cpu1,socket-id=0,die-id=0,module-id=0,core-id=0,thread-id=1 \
> > -device host-x86_64-cpu,id=cpu2,socket-id=0,die-id=0,module-id=1,core-id=0,thread-id=0 \
> > -device host-x86_64-cpu,id=cpu3,socket-id=0,die-id=0,module-id=1,core-id=1,thread-id=0
> 
> I quite like this as a way of doing the configuration but that needs
> some review from others.

Thanks!

> Peter, Alex, do you think this scheme is flexible enough to ultimately
> allow us to support this for arm? 

I was also hoping that being generic enough would benefit ARM.

> > 
> > This does not accommodate hybrid topologies. Therefore, we introduce
> > max* parameters: maxthreads/maxcores/maxmodules/maxdies/maxsockets
> > (for x86), to predefine the topology framework for the machine. These
> > parameters also constrain subsequent custom topologies, ensuring the
> > number of child devices under each parent device does not exceed the
> > specified max limits.
> 
> To my thinking this seems like a good solution even though it's a
> bunch more smp parameters.
> 
> What does this actually mean for hotplug of CPUs?  What cases work
> with this setup?

My solution for this does not change the current CPU hotplug, because the
current cpu hotplug only needs to consider smp.cpus and smp.maxcpus.

But when a cpu is plugged in, machine needs to make sure that plugging
into the core doesn't break the maxthreads limit. Similarly, if one wants
to support hotplugging at the socket/die/core granularity, he will need
to make sure that the new topology meets the limits set by the max
parameters, which are the equivalent of preemptively leaving some empty
holes that can be utilized by hotplug.

> > Therefore, once user wants to customize topology by "-machine
> > custom-topo=on", the machine, that supports custom topology, will skip
> > the default topology creation as well as the default CPU creation.
> 
> Seems sensible to me.

Thank you! Glad to have your support.

Regards,
Zhao


