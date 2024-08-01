Return-Path: <kvm+bounces-22914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C71A944821
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 11:25:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D7D61F29625
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 09:25:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E271189BA7;
	Thu,  1 Aug 2024 09:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RunV0jCD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82506189BA1
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 09:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722504083; cv=none; b=EideAnyUO8f0xjThejip1oq6bBEzpK8SBvxSMUTUGtNK7/ZoyMW0WvxHVVKwzZh7rh38qt++ZCAxsEOxClNQ6z7ZxuYleGGusn25FCRw3wBcqIVOZZkUbH62AvhLSCsn+EkxMF/0HJfXNVVOfwOSsHTeobnD08CIst05guuXe94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722504083; c=relaxed/simple;
	bh=Xmg/968fCVUCGZYT797Z9jjQKkMZwiEQFs2Df4qxxrw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YXG0rPyjMRwCJjReCX2v6SJzRqYzu5cf5rH4B8d8cR5yHNaqGtzt4mYnZj3VLyrPADDNlTCFXda2aNCCVBrhdEd1to3hXN8golH3DkgDCrDxYS/2lzI00me3HzPzQkiYKO6lhtmZxV3DkovMtEte7C17L3YE6Ga8qq+pzsYa92Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RunV0jCD; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722504082; x=1754040082;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Xmg/968fCVUCGZYT797Z9jjQKkMZwiEQFs2Df4qxxrw=;
  b=RunV0jCDp13wMvsQ1YB4AlT/RhCoqAblWtuLVU0rCrY28gyOX7Wgz9d2
   TCHX7chJEheVVbS0uRS8yoM42SfVAgyjZQEeabdqt0iUbGHMq5ao8Pwth
   Wa46Jd1efqD3iKGwJ67d/l+8Em2dbyVzuq8acEl1ekjr8w55KGp9niu+a
   oxkB1LGd5zuVRwS67S9dOYC+xQ0XdHeBeGOvo6DCTBkOytP9BFnnHiPkU
   hh7JPfygSh1uEGAv/3XrVMLKejqiwR4+jRX1dQ0fGNLgDSoIhM64THXRI
   I+qBdhq5eeWQCe2PhhANIQ+a1GndvC5T/Htn5B120U36qaJFy3MfBmJfz
   A==;
X-CSE-ConnectionGUID: 8LbtIdw+TnCMCxO5HDU++A==
X-CSE-MsgGUID: aeDc6bNbRdCz4EXOeLY78A==
X-IronPort-AV: E=McAfee;i="6700,10204,11150"; a="20385173"
X-IronPort-AV: E=Sophos;i="6.09,254,1716274800"; 
   d="scan'208";a="20385173"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2024 02:21:21 -0700
X-CSE-ConnectionGUID: D84dmaN6SuK0K8x9jJDrlw==
X-CSE-MsgGUID: YCFLQ0uPTG+Bm5RJ5hwSpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,254,1716274800"; 
   d="scan'208";a="59787927"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa005.jf.intel.com with ESMTP; 01 Aug 2024 02:21:16 -0700
Date: Thu, 1 Aug 2024 17:37:03 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
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
Subject: Re: [PATCH 8/8] qemu-options: Add the description of smp-cache object
Message-ID: <ZqtXP9MViOlyhEsu@intel.com>
References: <20240704031603.1744546-1-zhao1.liu@intel.com>
 <20240704031603.1744546-9-zhao1.liu@intel.com>
 <87r0bl35ug.fsf@pond.sub.org>
 <Zp5vxtXWDeHAdPok@intel.com>
 <87bk2nnev2.fsf@pond.sub.org>
 <ZqEN1kZaQcuY4UPG@intel.com>
 <87le1psuv3.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87le1psuv3.fsf@pond.sub.org>

On Thu, Jul 25, 2024 at 11:07:12AM +0200, Markus Armbruster wrote:
> Date: Thu, 25 Jul 2024 11:07:12 +0200
> From: Markus Armbruster <armbru@redhat.com>
> Subject: Re: [PATCH 8/8] qemu-options: Add the description of smp-cache
>  object
> 
> Zhao Liu <zhao1.liu@intel.com> writes:
> 
> > Hi Markus and Daniel,
> >
> > I have the questions about the -object per cache implementation:
> >
> > On Wed, Jul 24, 2024 at 02:39:29PM +0200, Markus Armbruster wrote:
> >> Date: Wed, 24 Jul 2024 14:39:29 +0200
> >> From: Markus Armbruster <armbru@redhat.com>
> >> Subject: Re: [PATCH 8/8] qemu-options: Add the description of smp-cache
> >>  object
> >> 
> >> Zhao Liu <zhao1.liu@intel.com> writes:
> >> 
> >> > Hi Markus,
> >> >
> >> > On Mon, Jul 22, 2024 at 03:37:43PM +0200, Markus Armbruster wrote:
> >> >> Date: Mon, 22 Jul 2024 15:37:43 +0200
> >> >> From: Markus Armbruster <armbru@redhat.com>
> >> >> Subject: Re: [PATCH 8/8] qemu-options: Add the description of smp-cache
> >> >>  object
> >> >> 
> >> >> Zhao Liu <zhao1.liu@intel.com> writes:
> >> >> 
> >> >> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> >> >> 
> >> >> This patch is just documentation.  The code got added in some previous
> >> >> patch.  Would it make sense to squash this patch into that previous
> >> >> patch?
> >> >
> >> > OK, I'll merge them.
> >> >
> >> >> > ---
> >> >> > Changes since RFC v2:
> >> >> >  * Rewrote the document of smp-cache object.
> >> >> >
> >> >> > Changes since RFC v1:
> >> >> >  * Use "*_cache=topo_level" as -smp example as the original "level"
> >> >> >    term for a cache has a totally different meaning. (Jonathan)
> >> >> > ---
> >> >> >  qemu-options.hx | 58 +++++++++++++++++++++++++++++++++++++++++++++++++
> >> >> >  1 file changed, 58 insertions(+)
> >> >> >
> >> >> > diff --git a/qemu-options.hx b/qemu-options.hx
> >> >> > index 8ca7f34ef0c8..4b84f4508a6e 100644
> >> >> > --- a/qemu-options.hx
> >> >> > +++ b/qemu-options.hx
> >> >> > @@ -159,6 +159,15 @@ SRST
> >> >> >          ::
> >> >> >  
> >> >> >              -machine cxl-fmw.0.targets.0=cxl.0,cxl-fmw.0.targets.1=cxl.1,cxl-fmw.0.size=128G,cxl-fmw.0.interleave-granularity=512
> >> >> > +
> >> >> > +    ``smp-cache='id'``
> >> >> > +        Allows to configure cache property (now only the cache topology level).
> >> >> > +
> >> >> > +        For example:
> >> >> > +        ::
> >> >> > +
> >> >> > +            -object '{"qom-type":"smp-cache","id":"cache","caches":[{"name":"l1d","topo":"core"},{"name":"l1i","topo":"core"},{"name":"l2","topo":"module"},{"name":"l3","topo":"die"}]}'
> >> >> > +            -machine smp-cache=cache
> >> >> >  ERST
> >> >> >  
> >> >> >  DEF("M", HAS_ARG, QEMU_OPTION_M,
> >> >> > @@ -5871,6 +5880,55 @@ SRST
> >> >> >          ::
> >> >> >  
> >> >> >              (qemu) qom-set /objects/iothread1 poll-max-ns 100000
> >> >> > +
> >> >> > +    ``-object '{"qom-type":"smp-cache","id":id,"caches":[{"name":cache_name,"topo":cache_topo}]}'``
> >> >> > +        Create an smp-cache object that configures machine's cache
> >> >> > +        property. Currently, cache property only include cache topology
> >> >> > +        level.
> >> >> > +
> >> >> > +        This option must be written in JSON format to support JSON list.
> >> >> 
> >> >> Why?
> >> >
> >> > I'm not familiar with this, so I hope you could educate me if I'm wrong.
> >> >
> >> > All I know so far is for -object that defining a list can only be done in
> >> > JSON format and not with a numeric index like a keyval based option, like:
> >> >
> >> > -object smp-cache,id=cache0,caches.0.name=l1i,caches.0.topo=core: Parameter 'caches' is missing
> >> >
> >> > the above doesn't work.
> >> >
> >> > Is there any other way to specify a list in command line?
> >> 
> >> The command line is a big, sprawling mess :)
> >> 
> >> -object supports either a JSON or a QemuOpts argument.  *Not* keyval!
> >> 
> >> Both QemuOpts and keyval parse something like KEY=VALUE,...  Keyval
> >> supports arrays and objects via dotted keys.  QemuOpts doesn't natively
> >> support arrays and objects, but its users can hack around that
> >> limitation in various ways.  -object doesn't.  So you're right, it's
> >> JSON or bust here.
> >> 
> >> However, if we used one object per cache instead, we could get something
> >> like
> >> 
> >>     -object smp-cache,name=l1d,...
> >>     -object smp-cache,name=l1u,...
> >>     -object smp-cache,name=l2,...
> >>     ...
> >
> > Current, I use -object to create a smp_cache object, and link it to
> > MachineState by -machine,smp-cache=obj_id.
> >
> > Then for the objects per cache, how could I link them to machine?
> >
> > Is it possible that I create something static in smp_cache.c and expose
> > all the cache information to machine through some interface?
> 
> Good questions.  However, before we head deeper into the weeds here, I
> feel we should discuss the things below.  And before we do that, I need
> a clear understanding of the use case.  Elsewhere in this thread, I just
> described the use case as I understand it.  Please reply there.  I'll
> then come back to this message.
> 
> [...]

Jonathan and I provided different use cases for x86 and Arm. Could we
come back here to continue the discussion? :)

Thanks,
Zhao



