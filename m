Return-Path: <kvm+bounces-18797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 063908FB829
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 17:55:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 298751C24993
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 15:55:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFB1213A25B;
	Tue,  4 Jun 2024 15:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G3GpS1Mp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAEE9148858
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 15:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717516407; cv=none; b=OVnsH+xR060LmC31n7Gy8XEEDcF925ESZe15+Yppy2R8D/nZs2h2dhWfgT8R4AKRyCtBks4NVRWBLg8iRV0bI9hMyq+HKOltwpVGFfXCSGQ1xyhpMMBtqPD1W9e3gkBzzmdte13JxQtG3SS7hxrDdXctqJXp7ev3/lrQHm1mht8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717516407; c=relaxed/simple;
	bh=IBh4cRZ5Gd6TO3btnDYuVa+tLMDOJq9bXCSjiq19S8g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oN9yjF5t5YuHNiA7Lwabh7uMxwpKE5Wpcw5TAiZoTfXt4qqdCKPhqfdPYjuA+Mod6DUGbSgKODZ3dTs/BIS3u1qtewK+kZb6rsyUeSyOfqU62jTg62zvaOh7Qhnd2f5RQ+Cq0NKyWZDUf/SmdDmPqUdIRQ8N/Awtws0kcnLRclw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G3GpS1Mp; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717516405; x=1749052405;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=IBh4cRZ5Gd6TO3btnDYuVa+tLMDOJq9bXCSjiq19S8g=;
  b=G3GpS1MpgkxIt+tqeEFmm+YLwxrTCw/7xdleblmBgLMbOxcaPlIwT9ik
   c2ByhGoMhatG8t3prpEEKjYmJBfHQYN425KegN0FrwMXedBAS8OP2/Qdz
   6SIkbbXrT31AKsVx8UqXc2AghhbYh/Dy76UWq/IFfebm5egxTVD+VgoIW
   zfAhUXNt4JMxE/65WlHeLH1gUPeKPwWosvIA2wic50d5jaE4HF2rfoWHM
   qpzFG2DqaWXZ3Z1ux211R1wq45/f2pfJcGkR6KymT86ikgJBAMZ+LXNQg
   sQK/xvh3cAsgnVoFH5RVeKnIx965q7FD3CK/ZOug+mxfDZPYq4tLOk/CJ
   g==;
X-CSE-ConnectionGUID: ghcxTwfqTA+w0BYPPb+XXA==
X-CSE-MsgGUID: cpLdKvlxSReLey9nR3jSNg==
X-IronPort-AV: E=McAfee;i="6600,9927,11093"; a="31571566"
X-IronPort-AV: E=Sophos;i="6.08,214,1712646000"; 
   d="scan'208";a="31571566"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2024 08:53:24 -0700
X-CSE-ConnectionGUID: ksKFdK+nR9iExjBaDjLmig==
X-CSE-MsgGUID: 1nv681oTSPinEBAr57ciog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,214,1712646000"; 
   d="scan'208";a="60472787"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa002.fm.intel.com with ESMTP; 04 Jun 2024 08:53:19 -0700
Date: Wed, 5 Jun 2024 00:08:45 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
	Markus Armbruster <armbru@redhat.com>
Cc: Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [RFC v2 3/7] hw/core: Add cache topology options in -smp
Message-ID: <Zl88DYwLE3ScDF5F@intel.com>
References: <20240530101539.768484-1-zhao1.liu@intel.com>
 <20240530101539.768484-4-zhao1.liu@intel.com>
 <87sext9jfo.fsf@pond.sub.org>
 <Zl7fHop_GaiJt6AE@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zl7fHop_GaiJt6AE@redhat.com>

Hi Markus and Daniel,

(I replied to both of you because I discussed the idea of cache object
at the end)

On Tue, Jun 04, 2024 at 10:32:14AM +0100, Daniel P. Berrang¨¦ wrote:
> Date: Tue, 4 Jun 2024 10:32:14 +0100
> From: "Daniel P. Berrang¨¦" <berrange@redhat.com>
> Subject: Re: [RFC v2 3/7] hw/core: Add cache topology options in -smp
> 
> On Tue, Jun 04, 2024 at 10:54:51AM +0200, Markus Armbruster wrote:
> > Zhao Liu <zhao1.liu@intel.com> writes:
> > 
> > > Add "l1d-cache", "l1i-cache". "l2-cache", and "l3-cache" options in
> > > -smp to define the cache topology for SMP system.
> > >
> > > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> > 
> > [...]
> > 
> > > diff --git a/qapi/machine.json b/qapi/machine.json
> > > index 7ac5a05bb9c9..8fa5af69b1bf 100644
> > > --- a/qapi/machine.json
> > > +++ b/qapi/machine.json
> > > @@ -1746,6 +1746,23 @@
> > >  #
> > >  # @threads: number of threads per core
> > >  #
> > > +# @l1d-cache: topology hierarchy of L1 data cache. It accepts the CPU
> > > +#     topology enumeration as the parameter, i.e., CPUs in the same
> > > +#     topology container share the same L1 data cache. (since 9.1)
> > > +#
> > > +# @l1i-cache: topology hierarchy of L1 instruction cache. It accepts
> > > +#     the CPU topology enumeration as the parameter, i.e., CPUs in the
> > > +#     same topology container share the same L1 instruction cache.
> > > +#     (since 9.1)
> > > +#
> > > +# @l2-cache: topology hierarchy of L2 unified cache. It accepts the CPU
> > > +#     topology enumeration as the parameter, i.e., CPUs in the same
> > > +#     topology container share the same L2 unified cache. (since 9.1)
> > > +#
> > > +# @l3-cache: topology hierarchy of L3 unified cache. It accepts the CPU
> > > +#     topology enumeration as the parameter, i.e., CPUs in the same
> > > +#     topology container share the same L3 unified cache. (since 9.1)
> > > +#
> > >  # Since: 6.1
> > >  ##
> > 
> > The new members are all optional.  What does "absent" mean?  No such
> > cache?  Some default topology?

I suppose "absent" means using the the default arch-specific cache topo.

For example, x86 has its own default cache topo. my purpose in providing
this interface is to allow users to override the default (arch-specific)
cache topology.

Daniel suggested in cover letter's reply that I could add the value
¡°default¡±, I think omitting it would have the same effect as setting it
to ¡°default¡±, and omitting it shouldn't be regarded as disabling a
particular cache, since the interface is only about the topology!

> > Is this sufficiently general?  Do all machines of interest have a split
> > level 1 cache, a level 2 cache, and a level 3 cache?

The different cache support can be extended by such control fields in
MachineClass:

typedef struct {
    ...
    bool l1_separated_cache_supported;
    bool l2_unified_cache_supported;
    bool l3_unified_cache_supported;
} SMPCompatProps;

For example, if a machine with l1 unified cache appears, it can add the
"l1_unified_cache_supported", and add "l1" option in QAPI.

Then separate L1 cache has ¡°l1i¡± and ¡°l1d¡± options, and unified L1 cache
should have ¡°l1¡± option.

> Level 4 cache is apparently a thing
> 
> https://www.guru3d.com/story/intel-confirms-l4-cache-in-upcoming-meteor-lake-cpus/
> 
> but given that any new cache levels will require new code in QEMU to
> wire up, its not a big deal to add new properties at the same time.
> 
> That said see my reply just now to the cover letter, where I suggest
> we should have a "caches" property that takes an array of cache
> info objects.

Yes, I agree.

> > 
> > Is the CPU topology level the only cache property we'll want to
> > configure here?  If the answer isn't "yes", then we should perhaps wrap
> > it in an object, so we can easily add more members later.
> 
> Cache size is a piece of info I could see us wanting to express

For the simplicity and clarity, I think it's better to only cover
topology in -smp, including the current CPU topology and the cache
topology I'm working on.

I've thought about the idea of converting the cache into the device,
which in turn could define more properties for the cache.

This one is mostly in connection with the previous qom-topo idea (aka
abstracting CPU topology device [1]):

    -device cpu-socket,id=sock0 \
    -device cpu-die,id=die0,parent=sock0 \
    -device cpu-core,id=core0,parent=die0,nr-threads=2 \
    -device cpu-cache,id=cache0,parent=core0,level=l1,type=inst \
    -device cpu-cache,id=cache1,parent=core0,level=l1,type=data \
    -device cpu-cache,id=cache2,parent=core0,level=l2,type=unif \
    -device cpu-cache,id=cache3,parent=die0,level=l3,type=unif

Cache device idea was mainly to support hybrid cache topology, because
Intel client hybrid architecture has hybrid cache topology (on MTL,
compute die has a L3 and SOC die has no L3).

Based on such a cache device, we can define more properties for the
cache and also meet flexible topology requirements at the same time.

This cache device I had planned to implement after the cpu topo device.
It's a long and hard way to go, I wonder if this future I'm portraying
will alleviate your concerns about more cache properties support. ;-)

Soon I'm also planning to refresh the qom-topo series again, reducing
hack changes, deleting dead codes, etc. Maybe it shouldn't be called
qom-topo, because I want to display topology tree in qom path by
qdev_set_id().

[1]: https://lore.kernel.org/qemu-devel/20231130144203.2307629-1-zhao1.liu@linux.intel.com/

> > Two spaces between sentences for consistency, please.
> >

Sure, thanks!

Regards,
Zhao


