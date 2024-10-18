Return-Path: <kvm+bounces-29156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A4539A390B
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 10:47:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC0E41C24DD3
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 08:47:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9A5C18F2FA;
	Fri, 18 Oct 2024 08:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IAN4Z1j1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCFF18EFDC
	for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 08:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729241263; cv=none; b=brpON13hxkk6JVa9go9R4HJ13tjvLKJ45cyybgEoQkhbpAy6hfpIXiW1NviciSIB62ggH4BAUkTb3yXmhtqsPfgzsvGqijgC+AUpt9oYjbRAj4PPgBMgzN4sDEbyzjrSy6Q2W3NL0VNMMV625sxRuuiFsASLMBeoL6RfwB7sBUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729241263; c=relaxed/simple;
	bh=plBfgMHQMuI+dLmqLkuBbIQUiwBm4swhKQlf4bzVhk8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UVinEKnFsPRsxXpWAiVyiziYkPBv/Oa2ai7k9OP/F8VVhXyWR8aKVWMHIJWvBmTU4aPhFgVj8nVNw/QlPQjYjApwIOJqYrxi3g3UaStyKmcGHxbpVHakFA7G97VNzqu76dkEFuLcNAypBDFODijZ/kJBuj0dHZ2SZzqTtzeNVuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IAN4Z1j1; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729241261; x=1760777261;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=plBfgMHQMuI+dLmqLkuBbIQUiwBm4swhKQlf4bzVhk8=;
  b=IAN4Z1j11zuqGU0ob44KkSJrpWlZdp8dPzk7f4GojtoxdraKOXBsHGc0
   8jd/zut9CIbq+dg+VsyR8QXiU4LAcFTOa2x2j4aDwdgwZpfZ+ZU5yt2QX
   owcY1JsXLSaIpZJaxF4noeAEjC5vv7e1poS0W0aLg43zuEaywEA5oFES8
   qywXpOJyzA9mQSjxJgFiD88fgL572apOMRYeZ5i6qfZbKF7VJPUZyfPEV
   LTxPB70I/cwJLcSTPfATR+Tf2+kRuui1gmb9eszPGG7dzU6i6+66ybLKJ
   +/lSxmcXstzeDAVIdhhdy6V071YdcvSsRZjTwzGNVhholJ0M+aSKMoS1D
   w==;
X-CSE-ConnectionGUID: UpLIx/NGSTakxp+Mj717pA==
X-CSE-MsgGUID: ljeE+uCgQzOGpmjHLPMymw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="39306045"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="39306045"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2024 01:47:40 -0700
X-CSE-ConnectionGUID: 1X6bbWVLRPKGDBLVB3+qyQ==
X-CSE-MsgGUID: 0qGpU8v8T3qusDQ6TdvBUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,213,1725346800"; 
   d="scan'208";a="102105838"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa002.fm.intel.com with ESMTP; 18 Oct 2024 01:47:35 -0700
Date: Fri, 18 Oct 2024 17:03:51 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc: Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v3 6/7] i386/pc: Support cache topology in -machine for
 PC machine
Message-ID: <ZxIkdyJ2ysibi74R@intel.com>
References: <20241012104429.1048908-1-zhao1.liu@intel.com>
 <20241012104429.1048908-7-zhao1.liu@intel.com>
 <ZxEs3DGGgCqGT5yK@redhat.com>
 <ZxHcsPyqT6MLJ9hG@intel.com>
 <ZxIVC-XQaMqOy6Fw@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZxIVC-XQaMqOy6Fw@redhat.com>

On Fri, Oct 18, 2024 at 08:58:03AM +0100, Daniel P. Berrangé wrote:
> Date: Fri, 18 Oct 2024 08:58:03 +0100
> From: "Daniel P. Berrangé" <berrange@redhat.com>
> Subject: Re: [PATCH v3 6/7] i386/pc: Support cache topology in -machine for
>  PC machine
> 
> On Fri, Oct 18, 2024 at 11:57:36AM +0800, Zhao Liu wrote:
> > Hi Daniel,
> > 
> > > > +    ``smp-cache.0.cache=cachename,smp-cache.0.topology=topologylevel``
> > > > +        Define cache properties for SMP system.
> > > > +
> > > > +        ``cache=cachename`` specifies the cache that the properties will be
> > > > +        applied on. This field is the combination of cache level and cache
> > > > +        type. It supports ``l1d`` (L1 data cache), ``l1i`` (L1 instruction
> > > > +        cache), ``l2`` (L2 unified cache) and ``l3`` (L3 unified cache).
> > > > +
> > > > +        ``topology=topologylevel`` sets the cache topology level. It accepts
> > > > +        CPU topology levels including ``thread``, ``core``, ``module``,
> > > > +        ``cluster``, ``die``, ``socket``, ``book``, ``drawer`` and a special
> > > > +        value ``default``. If ``default`` is set, then the cache topology will
> > > > +        follow the architecture's default cache topology model. If another
> > > > +        topology level is set, the cache will be shared at corresponding CPU
> > > > +        topology level. For example, ``topology=core`` makes the cache shared
> > > > +        by all threads within a core.
> > > > +
> > > > +        Example:
> > > > +
> > > > +        ::
> > > > +
> > > > +            -machine smp-cache.0.cache=l1d,smp-cache.0.topology=core,smp-cache.1.cache=l1i,smp-cache.1.topology=core
> > > 
> > > There are 4 cache types, l1d, l1i, l2, l3.
> > > 
> > > In this example you've only set properties for l1d, l1i caches.
> > > 
> > > What does this mean for l2 / l3 caches ?
> > 
> > Omitting "cache" will default to using the "default" level.
> > 
> > I think I should add the above description to the documentation.
> > 
> > > Are they reported as not existing, or are they to be reported at
> > > some built-in default topology level.
> > 
> > It's the latter.
> > 
> > If a machine doesn't support l2/l3, then QEMU will also report the error
> > like:
> > 
> > qemu-system-*: l2 cache topology not supported by this machine
> 
> Ok, that's good.
> 
> > > If the latter, how does the user know what that built-in default is, 
> > 
> > Currently, the default cache model for x86 is L1 per core, L2 per core,
> > and L3 per die. Similar to the topology levels, there is still no way to
> > expose this to users. I can descript default cache model in doc.
> > 
> > But I feel like we're back to the situation we discussed earlier:
> > "default" CPU topology support should be related to the CPU model, but
> > in practice, QEMU supports it at the machine level. The cache topology
> > depends on CPU topology support and can only continue to be added on top
> > of the machine.
> > 
> > So do you think we can add topology and cache information in CpuModelInfo
> > so that query-cpu-model-expansion can expose default CPU/cache topology
> > information to users?
> > 
> > This way, users can customize CPU/cache topology in -smp and
> > -machine smp-cache. Although the QMP command is targeted at the CPU model
> > while our CLI is at the machine level, at least we can expose the
> > information to users.
> > 
> > If you agree to expose the default topology/cache info in
> > query-cpu-model-expansion, can I work on this in a separate series? :)
> 
> Yeah, lets worry about that another day.
> 
> It it sufficient to just encourage users to always specify
> the full set of caches.

Thanks!

> > > Can we explicitly disable a l2/l3 cache, or must it always exists ?
> > 
> > Now we can't disable it through -machine smp-cache (while x86 CPU support
> > l3-cache=off), but as you mentioned, I can try using "invalid" to support
> > this scenario, which would be more general. Similarly, if you agree, I
> > can also add this support in a separate series.
> 
> If we decide to offer a way to disable caches, probably better to have
> a name like 'disabled' for such a setting, and yes, we don't need todo
> that now.

Yes, "disabled" is better.

Regards,
Zhao

 

