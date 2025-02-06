Return-Path: <kvm+bounces-37462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 43B62A2A4B1
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 10:36:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7982D7A1BB4
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 09:35:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07B61227B91;
	Thu,  6 Feb 2025 09:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IcJJowGG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B90922619A
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 09:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738834510; cv=none; b=nKcLkMdaNRUy/+PnDTxks5Y/47CTvbIEDDck4p6sUIjiz4WdweduvtlCLDD6tPz0FZgGc/z86Jo/mLLCDhWFcZklkGEPDzeDJTlK4DHs8tUOOn5vyHSjozgMqs2rBxJ3caEQW2f/AOGrLBvKUtQcY9I229iUZ2jOfYxoo5VC9/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738834510; c=relaxed/simple;
	bh=SbzsFpxSlqt0LRVCVphwfchnZcpRBWTRP4V0UBxDljg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G8VKxYpn/Ia3ZHkJRhUsuyGC4DXqZKsKaSZn5joeq/QBOqga9oygv4xOA0TyhmkaQubB3b4OPUrlmyS/HAwqp5+21pVUYgpLO0BvopdJRrBekBjarfc0EghsUIaqXcYyI358UZk+xvJ+B4SelQnCugB9QsqJSGzO6WJCmYUmMZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IcJJowGG; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738834508; x=1770370508;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SbzsFpxSlqt0LRVCVphwfchnZcpRBWTRP4V0UBxDljg=;
  b=IcJJowGGcq6pLclLSWDg6Mf/wiX3tLTaF8tEWCqfRz2HfN/ew4qekgKD
   9KJHhmL0RJwQ8kzd8wcnTlQShci99I0l9eAoSpySbbBNFp+cgWjvUkaiM
   B6sjW0IE5FIC08ELzBNdnNC/m7TiOjpTYI1wDIYWDpGcTITSppjwvCOBv
   SlW5DPUpRDw2wDQZxiHV0zPXLoF+QMEsPg5C8fRZjSx+WRQJmIJvD9u6k
   XT+lcZSlFp8rwwEy6SoMU6hmR4jR2/dSnj2a2/flU5XpvkFMGbV6o8LYt
   mq1v79WHrnag8GH4PXhostJWaOjLzxdXdvp7jeg+ISe4kdHqE+zPtlVxq
   w==;
X-CSE-ConnectionGUID: Yns/o7BWRfKhtR5A08HCWQ==
X-CSE-MsgGUID: dgJlccH6Rla4c4tChfmXjA==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="61905381"
X-IronPort-AV: E=Sophos;i="6.13,264,1732608000"; 
   d="scan'208";a="61905381"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2025 01:35:08 -0800
X-CSE-ConnectionGUID: 2gIBkdsDS86vB5dYK1Hsqw==
X-CSE-MsgGUID: Mm5+m0RnTiC1gkfud4HxFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="142041740"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa001.fm.intel.com with ESMTP; 06 Feb 2025 01:35:03 -0800
Date: Thu, 6 Feb 2025 17:54:32 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>, Eric Auger <eauger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>,
	Sebastian Ott <sebott@redhat.com>, Gavin Shan <gshan@redhat.com>,
	qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
	Dapeng Mi <dapeng1.mi@intel.com>, Yi Lai <yi1.lai@intel.com>
Subject: Re: [RFC v2 3/5] i386/kvm: Support event with select & umask format
 in KVM PMU filter
Message-ID: <Z6SG2NLxxhz4adlV@intel.com>
References: <20250122090517.294083-1-zhao1.liu@intel.com>
 <20250122090517.294083-4-zhao1.liu@intel.com>
 <87zfj01z8x.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zfj01z8x.fsf@pond.sub.org>

On Wed, Feb 05, 2025 at 11:07:10AM +0100, Markus Armbruster wrote:
> Date: Wed, 05 Feb 2025 11:07:10 +0100
> From: Markus Armbruster <armbru@redhat.com>
> Subject: Re: [RFC v2 3/5] i386/kvm: Support event with select & umask
>  format in KVM PMU filter
> 
> Zhao Liu <zhao1.liu@intel.com> writes:
> 
> > The select&umask is the common way for x86 to identify the PMU event,
> > so support this way as the "x86-default" format in kvm-pmu-filter
> > object.
> 
> So, format 'raw' lets you specify the PMU event code as a number, wheras
> 'x86-default' lets you specify it as select and umask, correct?

Yes!

> Why do we want both?

This 2 formats are both wildly used in x86(for example, in perf tool).

x86 documents usually specify the umask and select fields.

But raw format could also be applied for ARM since ARM just uses a number
to encode event.

> > Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> 
> [...]
> 
> > diff --git a/qapi/kvm.json b/qapi/kvm.json
> > index d51aeeba7cd8..93b869e3f90c 100644
> > --- a/qapi/kvm.json
> > +++ b/qapi/kvm.json
> > @@ -27,11 +27,13 @@
> >  #
> >  # @raw: the encoded event code that KVM can directly consume.
> >  #
> > +# @x86-default: standard x86 encoding format with select and umask.
> 
> Why is this named -default?

Intel and AMD both use umask+select to encode events, but this format
doesn't have a name... so I call it `default`, or what about
"x86-umask-select"?

> > +#
> >  # Since 10.0
> >  ##
> >  { 'enum': 'KVMPMUEventEncodeFmt',
> >    'prefix': 'KVM_PMU_EVENT_FMT',
> > -  'data': ['raw'] }
> > +  'data': ['raw', 'x86-default'] }
> >  
> >  ##
> >  # @KVMPMURawEvent:
> > @@ -46,6 +48,25 @@
> >  { 'struct': 'KVMPMURawEvent',
> >    'data': { 'code': 'uint64' } }
> >  
> > +##
> > +# @KVMPMUX86DefalutEvent:
> 
> Default, I suppose.

Thanks!

> > +#
> > +# x86 PMU event encoding with select and umask.
> > +# raw_event = ((select & 0xf00UL) << 24) | \
> > +#              (select) & 0xff) | \
> > +#              ((umask) & 0xff) << 8)
> 
> Sphinx rejects this with "Unexpected indentation."
> 
> Is the formula needed here?

I tried to explain the relationship between raw format and umask+select.

Emm, where do you think is the right place to put the document like
this?

...

> > +##
> > +# @KVMPMUX86DefalutEventVariant:
> > +#
> > +# The variant of KVMPMUX86DefalutEvent with the string, rather than
> > +# the numeric value.
> > +#
> > +# @select: x86 PMU event select field.  This field is a 12-bit
> > +#     unsigned number string.
> > +#
> > +# @umask: x86 PMU event umask field. This field is a uint8 string.
> 
> Why are these strings?  How are they parsed into numbers?

In practice, the values associated with PMU events (code for arm, select&
umask for x86) are often expressed in hexadecimal. Further, from linux
perf related information (tools/perf/pmu-events/arch/*/*/*.json), x86/
arm64/riscv/nds32/powerpc all prefer the hexadecimal numbers and only
s390 uses decimal value.

Therefore, it is necessary to support hexadecimal in order to honor PMU
conventions.

However, unfortunately, standard JSON (RFC 8259) does not support
hexadecimal numbers. So I can only consider using the numeric string in
the QAPI and then parsing it to a number.

I parse this string into number by qemu_strtou64().


