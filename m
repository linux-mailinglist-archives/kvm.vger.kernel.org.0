Return-Path: <kvm+bounces-53823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 402F1B17B26
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 04:16:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 953DD1C27CB1
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 02:17:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EDDA1531C8;
	Fri,  1 Aug 2025 02:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EOoKQ7ZG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40C020326;
	Fri,  1 Aug 2025 02:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754014604; cv=none; b=sm91M/G1d78bpDI/bubgl65eBPN8e9D0jk54RNGEARC0W8ZNtPs3s1YYtPRVNdERVLqI+Z/ocaS6t5sXOjA+J6TrVHWqdHxKEg7IBg3rDdP4RbnvS+bJdTDPZ/hLHGWKq3weuOhismTPrYauFjClQvdGENKXxVIVk3+9HxtMyqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754014604; c=relaxed/simple;
	bh=8DsDuKyLSQ6J57SR4sqDq8FfwCscM9sDogsCD6oZntI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R/i0uPCE6zQO/vlKovzTzIQ3BULK1u8nb7TU4KSJ7HSK9dSOTeLit+Q7yr7YEXgtJnDT6iEmiQgnWuZLV2x85xmvr4Hh4lcvoFMoQDCuXljzg//NPtYgcvy2T5vF+GKNU/8Amenu0S8rYT78eCtk23ZK0DNfgJTejVWIK2IQp4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EOoKQ7ZG; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754014603; x=1785550603;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8DsDuKyLSQ6J57SR4sqDq8FfwCscM9sDogsCD6oZntI=;
  b=EOoKQ7ZGmFaaIaugfWLzUnITkHXDXcQ1GoFVfZRZW6s00WciClOeoHms
   cfowI8PVBAuZ7OsPzPet3UXihBNHNMl/PzWJa5GfvZc9iKZkOEP7xpQOM
   Esha355Bmcyb8E5r9u7SKm+x4lYEXsW9Gd3Ag9oH4kxo4+mCHuPO05MGx
   HWfUAj5nOBMZGLJreFvBvnIyMH6zTFJ3i1EqWCkMI237f+nXyRsJ3iYgb
   9V/CPqJqdxOluoFUanUXELzkXPI7QMtGxr/t2rPXht19+Tqv+tFtDqCii
   zQ20n1OPw1Ce66f/KX7bTsvTc+x4UOOl51IV4N5A2vSrQhUWWa+/Aoy8K
   w==;
X-CSE-ConnectionGUID: Jkt07b8YRZqAwWd1I9yl7w==
X-CSE-MsgGUID: 34/cXtoaRfq+GxipeiI9fA==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="56052515"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="56052515"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 19:16:42 -0700
X-CSE-ConnectionGUID: RB3PguwuTm6Umpo4iIRG8A==
X-CSE-MsgGUID: ZDI7glPKRA2D2P6X66I1Pw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="164222086"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa010.fm.intel.com with ESMTP; 31 Jul 2025 19:16:37 -0700
Date: Fri, 1 Aug 2025 10:07:13 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: dan.j.williams@intel.com
Cc: Chao Gao <chao.gao@intel.com>, linux-coco@lists.linux.dev,
	x86@kernel.org, kvm@vger.kernel.org, seanjc@google.com,
	pbonzini@redhat.com, eddie.dong@intel.com,
	kirill.shutemov@intel.com, dave.hansen@intel.com,
	kai.huang@intel.com, isaku.yamahata@intel.com,
	elena.reshetova@intel.com, rick.p.edgecombe@intel.com,
	Farrah Chen <farrah.chen@intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 07/20] x86/virt/tdx: Expose SEAMLDR information via
 sysfs
Message-ID: <aIwhUb3z9/cgsMwb@yilunxu-OptiPlex-7050>
References: <20250523095322.88774-1-chao.gao@intel.com>
 <20250523095322.88774-8-chao.gao@intel.com>
 <aIhUVyJVQ+rhRB4r@yilunxu-OptiPlex-7050>
 <688bd9a164334_48e5100f1@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <688bd9a164334_48e5100f1@dwillia2-xfh.jf.intel.com.notmuch>

On Thu, Jul 31, 2025 at 02:01:21PM -0700, dan.j.williams@intel.com wrote:
> Xu Yilun wrote:
> > > +static const struct attribute_group *tdx_subsys_groups[] = {
> > > +	SEAMLDR_GROUP,
> > > +	NULL,
> > > +};
> > > +
> > >  static void tdx_subsys_init(void)
> > >  {
> > >  	struct tdx_tsm *tdx_tsm;
> > >  	int err;
> > >  
> > > +	err = get_seamldr_info();
> > > +	if (err) {
> > > +		pr_err("failed to get seamldr info %d\n", err);
> > > +		return;
> > > +	}
> > > +
> > >  	/* Establish subsystem for global TDX module attributes */
> > > -	err = subsys_virtual_register(&tdx_subsys, NULL);
> > > +	err = subsys_virtual_register(&tdx_subsys, tdx_subsys_groups);
> > >  	if (err) {
> > >  		pr_err("failed to register tdx_subsys %d\n", err);
> > >  		return;
> > 
> > As mentioned, TDX Connect also uses this virtual TSM device. And I tend
> > to extend it to TDX guest, also make the guest TSM management run on
> > the virtual device which represents the TDG calls and TDG_VP_VM calls.
> > 
> > So I'm considering extract the common part of tdx_subsys_init() out of
> > TDX host and into a separate file, e.g.
> > 
> > ---
> > 
> > +source "drivers/virt/coco/tdx-tsm/Kconfig"
> > +
> >  config TSM
> >         bool
> > diff --git a/drivers/virt/coco/Makefile b/drivers/virt/coco/Makefile
> > index c0c3733be165..a54d3cb5b4e9 100644
> > --- a/drivers/virt/coco/Makefile
> > +++ b/drivers/virt/coco/Makefile
> > @@ -10,3 +10,4 @@ obj-$(CONFIG_INTEL_TDX_GUEST) += tdx-guest/
> >  obj-$(CONFIG_ARM_CCA_GUEST)    += arm-cca-guest/
> >  obj-$(CONFIG_TSM)              += tsm-core.o
> >  obj-$(CONFIG_TSM_GUEST)                += guest/
> > +obj-y                          += tdx-tsm/
> > diff --git a/drivers/virt/coco/tdx-tsm/Kconfig b/drivers/virt/coco/tdx-tsm/Kconfig
> > new file mode 100644
> > index 000000000000..768175f8bb2c
> > --- /dev/null
> > +++ b/drivers/virt/coco/tdx-tsm/Kconfig
> > @@ -0,0 +1,2 @@
> > +config TDX_TSM_BUS
> > +       bool
> > diff --git a/drivers/virt/coco/tdx-tsm/Makefile b/drivers/virt/coco/tdx-tsm/Makefile
> > new file mode 100644
> > index 000000000000..09f0ac08988a
> > --- /dev/null
> > +++ b/drivers/virt/coco/tdx-tsm/Makefile
> > @@ -0,0 +1 @@
> > +obj-$(CONFIG_TDX_TSM_BUS) += tdx-tsm-bus.o
> 
> Just name it bus.c.

I'm about to make the change but I see there is already tdx-guest misc
virtual device in Guest OS:

  What:		/sys/devices/virtual/misc/tdx_guest/xxxx

And if we add another tdx_subsys, we have:

  What:		/sys/devices/virtual/tdx/xxxx

Do we really want 2 virtual devices? What's their relationship? I can't
figure out.

So I'm considering reuse the misc/tdx_guest device as a tdx root device
in guest. And that removes the need to have a common tdx tsm bus.

What do you think?

> 
> > ---
> > 
> > And put the tdx_subsys_init() in tdx-tsm-bus.c. We need to move host
> > specific initializations out of tdx_subsys_init(), e.g. seamldr_group &
> > seamldr fw upload.
> 
> Just to be clear on the plan here as I think this TD Preserving set
> should land before we start upstreamming any TDX Connect bits.
> 
> - Create drivers/virt/coco/tdx-tsm/bus.c for registering the tdx_subsys.
>   The tdx_subsys has sysfs attributes like "version" (host and guest
>   need this, but have different calls to get at the information) and
>   "firmware" (only host needs that). So the common code will take sysfs
>   groups passed as a parameter.
> 
> - The "tdx_tsm" device which is unused in this patch set can be

It is used in this patch, Chao creates tdx module 'version' attr on this
device. But I assume you have different opinion: tdx_subsys represents
the whole tdx_module and should have the 'version', and tdx_tsm is a
sub device dedicate for TDX Connect, is it?

Thanks,
Yilun

>   registered on the "tdx" bus to move feature support like TDX Connect
>   into a typical driver model.
> 
> So the change for this set is create a bus.c that is host/guest
> agnostic, drop the tdx_tsm device and leave that to the TDX Connect
> patches to add back. 
> 
> The TDX Connect pathes will register the tdx_tsm device near where the
> bus is registered for the host and guest cases.
> 
> Concerns?
> 
> In the meantime, until this set lands in tip we can work out the
> organization in tsm.git#staging.

