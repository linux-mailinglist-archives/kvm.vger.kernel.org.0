Return-Path: <kvm+bounces-28060-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BA42992A52
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 13:37:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9892CB2294D
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 11:37:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06D301D2229;
	Mon,  7 Oct 2024 11:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PynCCTF1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B97101C4
	for <kvm@vger.kernel.org>; Mon,  7 Oct 2024 11:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728301025; cv=none; b=eca6tW6hzTyJHSj7sFVu4Rg2LR5EYyvSLsi4e15R40D8TrAKMZsV1TEleOl//u3ZQ7iakaoHuJ35U2VrBdgW4KFtrvGG4vHcva1/nCDxtLEeTZwHhDJa8x5+Nue7rT5L/MFBmCLxZiWp9C91XpIxclWY3YxPZRjZyZvCXVVLmKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728301025; c=relaxed/simple;
	bh=jaVghokLkYagComBJOIsqVtMl7fwxtcDqAjAsloR16M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=grZ8s4HTdaa59S0KRtrS4ELp5sSYmHNgBLSepvt/UpDrxLesURZ60Y+xh7g/9TXcr6yh6o2MRaH9fVoynJKmqOiW+gKnJcR800D1N5HST/wQNkcqeM7OftNfRXqfrMSKfxhTuqebigeMg68KUxRqqputFuvnk4O6ZWZK11DsmV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PynCCTF1; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728301023; x=1759837023;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jaVghokLkYagComBJOIsqVtMl7fwxtcDqAjAsloR16M=;
  b=PynCCTF1oUTkHO17PhfTJHVy25v5beq68hwv/MpLOgE46MzsJvzqWi7K
   mzqCcaPTOTMF8Pi2BdWZudsyHp1OC9R75ewwpZGK1zdtEqrboch/uRngt
   C0uoFWVBNCl1X1MpLSBTYLPGv0MtUu0AygzqmRc6o61kTXZKIXeRe8rt2
   0xprKZ713+tGeAWoRjOLBETTFSoQli/kn7NdE8Y6G2jF4diYRtrw+Wndf
   4MNIHD+XlrdwOMZn2ZU/KYFFLOOF8bjbcsqH6vdCS8kmFvhL7W3607yI9
   Un0aQQpbfhZeBT0OUU6c57MrcLJkhjBovIG2k+k/7zyY4SI+S5DZUV6hy
   g==;
X-CSE-ConnectionGUID: 8Ub2MuRxQFiQGMZq5Vh1QQ==
X-CSE-MsgGUID: kEbDLTE/TEuKfVDCHJXvzQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11217"; a="31237677"
X-IronPort-AV: E=Sophos;i="6.11,184,1725346800"; 
   d="scan'208";a="31237677"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2024 04:37:03 -0700
X-CSE-ConnectionGUID: 0/ZcA+bqQ8i8F/qPbC/qAA==
X-CSE-MsgGUID: b1Gs2tQfTSqj5/6woMuvZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,184,1725346800"; 
   d="scan'208";a="98764773"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa002.fm.intel.com with ESMTP; 07 Oct 2024 04:36:57 -0700
Date: Mon, 7 Oct 2024 19:53:08 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S.Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Sia Jee Heng <jeeheng.sia@starfivetech.com>,
	Alireza Sanaee <alireza.sanaee@huawei.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v2 7/7] i386/pc: Support cache topology in -machine for
 PC machine
Message-ID: <ZwPLpOt/DIvNO70f@intel.com>
References: <20240908125920.1160236-1-zhao1.liu@intel.com>
 <20240908125920.1160236-8-zhao1.liu@intel.com>
 <20240917101631.00003dcb@Huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240917101631.00003dcb@Huawei.com>

On Tue, Sep 17, 2024 at 10:16:31AM +0100, Jonathan Cameron wrote:
> Date: Tue, 17 Sep 2024 10:16:31 +0100
> From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
> Subject: Re: [PATCH v2 7/7] i386/pc: Support cache topology in -machine for
>  PC machine
> X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
> 
> On Sun,  8 Sep 2024 20:59:20 +0800
> Zhao Liu <zhao1.liu@intel.com> wrote:
> 
> > Allow user to configure l1d, l1i, l2 and l3 cache topologies for PC
> > machine.
> > 
> > Additionally, add the document of "-machine smp-cache" in
> > qemu-options.hx.
> > 
> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> > Tested-by: Yongwei Ma <yongwei.ma@intel.com>
>
> Trivial language suggestions.
> In general looks good to me.
> 
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> 
> Hopefully QOM maintainers and others will get to this soon. 
> I'd like Ali's ARM series to land this cycle as well
> as the lack of this support has been a pain point for us
> for a while.
>
> Jonathan

Thanks! I'll refresh a new version.

[snip]

> > diff --git a/qemu-options.hx b/qemu-options.hx
> > index d94e2cbbaeb1..3936ff3e77f9 100644
> > --- a/qemu-options.hx
> > +++ b/qemu-options.hx
> > @@ -39,7 +39,8 @@ DEF("machine", HAS_ARG, QEMU_OPTION_machine, \
> >      "                memory-encryption=@var{} memory encryption object to use (default=none)\n"
> >      "                hmat=on|off controls ACPI HMAT support (default=off)\n"
> >      "                memory-backend='backend-id' specifies explicitly provided backend for main RAM (default=none)\n"
> > -    "                cxl-fmw.0.targets.0=firsttarget,cxl-fmw.0.targets.1=secondtarget,cxl-fmw.0.size=size[,cxl-fmw.0.interleave-granularity=granularity]\n",
> > +    "                cxl-fmw.0.targets.0=firsttarget,cxl-fmw.0.targets.1=secondtarget,cxl-fmw.0.size=size[,cxl-fmw.0.interleave-granularity=granularity]\n"
> > +    "                smp-cache.0.cache=cachename,smp-cache.0.topology=topologylevel\n",
> 
> Now my cxl-fmw stuff has competition for most hideous element :)
> When we add a few more properties maybe we'll get an even longer line!

May JSON support can save us :). When I have time I will consider this.
Command line's keyval format is more convenient for configuring a single
element in an array.
 
> >      QEMU_ARCH_ALL)
> >  SRST
> >  ``-machine [type=]name[,prop=value[,...]]``
> > @@ -159,6 +160,31 @@ SRST
> >          ::
> >  
> >              -machine cxl-fmw.0.targets.0=cxl.0,cxl-fmw.0.targets.1=cxl.1,cxl-fmw.0.size=128G,cxl-fmw.0.interleave-granularity=512
> > +
> > +    ``smp-cache.0.cache=cachename,smp-cache.0.topology=topologylevel``
> > +        Define cache properties (now only the cache topology level) for SMP
> > +        system.
> 
> I'd drop the 'now only' bit.  Just means we have add noise updating that
> later.   It's easy enough to look down and see what is available anyway give
> the parameter docs follow immediately after this.

Agree.

> > +
> > +        ``cache=cachename`` specifies the cache that the properties will be
> > +        applied on. This field is the combination of cache level and cache
> > +        type. Currently it supports ``l1d`` (L1 data cache), ``l1i`` (L1
> 
> Drop the word Currently as I don't think it adds anything to he meaning.
> We are never going to add docs that say 'previously it supported' or 'in the
> future it will support'.
> 
> 	   "Supports ...
> 

Thanks! I will change to "It supports ..."

> > +        instruction cache), ``l2`` (L2 unified cache) and ``l3`` (L3 unified
> > +        cache).
> > +
> > +        ``topology=topologylevel`` sets the cache topology level. It accepts
> > +        CPU topology levels including ``thread``, ``core``, ``module``,
> > +        ``cluster``, ``die``, ``socket``, ``book``, ``drawer`` and a special
> > +        value ``default``. If ``default`` is set, then the cache topology will
> > +        follow the architecture's default cache topology model. If other CPU
> If another topology level is set
> 
> would be clearer.   I briefly read this as saying the topology for another CPU
> rather than a different value here.

Ah, yes, I agree.

> > +        topology level is set, the cache will be shared at corresponding CPU
> > +        topology level. For example, ``topology=core`` makes the cache shared
> > +        in a core.
> "by all threads within a core." perhaps?

Nice, it's more accurate.

Thanks,
Zhao


