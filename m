Return-Path: <kvm+bounces-44182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 435A7A9B1D9
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 17:14:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 689D9467FFF
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 15:14:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00DB21AF0B7;
	Thu, 24 Apr 2025 15:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nyOoccWe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A2614F9EB
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 15:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745507642; cv=none; b=T4ENZ3iHa3jNbkz6Wg4C719g9nHYf5Gok2Dq3NQd54hf4FbXEkcLeiVmckENFFCsgBp0IN3cNrWMEz2vVgZKuw8hJe28tu7e/qhVni5MurVFa5/JMyUHgBRH1LAfhikJ0AeMGdNHXKMEV1RQnHgyNI+BzyEu1moMn4hSGtVpo1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745507642; c=relaxed/simple;
	bh=wVEPg+cfudgIjOoKZg2o4CMPdWU7kLCH8cmSYnxtedE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CxJpBDaUtNxtHXIlpV3yN1B4wDEnURC2lz0PkE9mhgxn/dY0TyNdnNdrIhLTP+QS7wKmZFkA8IMUEcCUoIgnVuBgqTajWwGzRVmUcDdavjNdJYyiLTT+yNGVLBwXB1dU3XYCLmMZrS/uXZknxsl5hdlzg/ZMb0WcLtlKDQvgtSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nyOoccWe; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745507640; x=1777043640;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wVEPg+cfudgIjOoKZg2o4CMPdWU7kLCH8cmSYnxtedE=;
  b=nyOoccWeyWL8WRsZ6SmeLDuQZqvqSfixSeX3A2ScPjef2VNihzPsNYnv
   lyVRG/RcBmvd3cBOQGhODPIewaSF7fK/uBM+9nLkz6uhlq6/1TtwWEATJ
   b1qX43Ra4v/Fx94ob5qB+dHdyWHi/cDEZyxFWVZBJRePgIlG8VGsytrvy
   z1RL3rutA/DYUzAkBZjCNYPkbYeRlveAX8EKF2+xe59FANDf4Qw3bcX0o
   ODCmvQzit9pLKJ0dLWH6zMveT0FBJdNsH0P1Imefx7zFFhuhdSx+eeNQ5
   DvGmbmyeuKfYly8pTn3M3tSj2iWE6a4xnArqqPp3s3YMz8KW/qPbgvHfA
   w==;
X-CSE-ConnectionGUID: O2pw9WcLSCuYMcDjUJfxYQ==
X-CSE-MsgGUID: Wy0nlCMYR6GX3WlJXnrv+A==
X-IronPort-AV: E=McAfee;i="6700,10204,11413"; a="46862387"
X-IronPort-AV: E=Sophos;i="6.15,236,1739865600"; 
   d="scan'208";a="46862387"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2025 08:13:58 -0700
X-CSE-ConnectionGUID: DtSyRNrSQXisMdzPRaLvTQ==
X-CSE-MsgGUID: ACKkrOv0RtyU64ls1gCrQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,236,1739865600"; 
   d="scan'208";a="169860765"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa001.jf.intel.com with ESMTP; 24 Apr 2025 08:13:54 -0700
Date: Thu, 24 Apr 2025 23:34:49 +0800
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
Subject: Re: [PATCH 1/5] qapi/qom: Introduce kvm-pmu-filter object
Message-ID: <aApaGdY/kawZIp8N@intel.com>
References: <20250409082649.14733-1-zhao1.liu@intel.com>
 <20250409082649.14733-2-zhao1.liu@intel.com>
 <87tt6d4usx.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tt6d4usx.fsf@pond.sub.org>

> > diff --git a/qapi/kvm.json b/qapi/kvm.json
> > new file mode 100644
> > index 000000000000..1861d86a9726
> > --- /dev/null
> > +++ b/qapi/kvm.json
> > @@ -0,0 +1,84 @@
> > +# -*- Mode: Python -*-
> > +# vim: filetype=python
> > +#
> > +# Copyright (C) 2025 Intel Corporation.
> > +#
> > +# Author: Zhao Liu <zhao1.liu@intel.com>
> > +#
> > +# SPDX-License-Identifier: GPL-2.0-or-later
> > +
> > +##
> > +# == KVM
> > +##
> 
> There's KVM-specific stuff elsewhere in the schema.  Some if of it
> should probably be moved here.  Can you have a look?  This is not a
> demand; it's fine if you can't.  If you can: separate patch preceding
> this one to create kvm.json and move stuff there.

Sure! That's what I should have done, and I'll be back to follow up on
this discussion when I get something new.

> > +
> > +##
> > +# === PMU stuff (KVM related)
> 
> The KVM subsection contains just this subsubsection.  Awkward.  Can we
> do without this subsubsection now?  We can always add it later, when we
> have enough KVM stuff to warrant structuring it into subsubsections.

Thanks! I agree. As I commit to do above, if I find others about KVM,
we can add this subsection you suggested below :-).

> If we decide we want it:
> 
>    # === KVM performance monitor unit (PMU)

Good name.

> > +##
> > +
> > +##
> > +# @KvmPmuFilterAction:
> > +#
> > +# Actions that KVM PMU filter supports.
> > +#
> > +# @deny: disable the PMU event/counter in KVM PMU filter.
> > +#
> > +# @allow: enable the PMU event/counter in KVM PMU filter.
> > +#
> > +# Since 10.1
> > +##
> > +{ 'enum': 'KvmPmuFilterAction',
> > +  'data': ['allow', 'deny'] }
> > +
> > +##
> > +# @KvmPmuEventFormat:
> 
> Maybe KvmPmuFilterEventFormat?  Or is that too long?

For another 2 formats: 'x86-select-umask' and 'x86-masked-entry', their
enum value names already have 7 words:

 - KVM_PMU_EVENT_FORMAT_X86_SELECT_UMASK
 - KVM_PMU_EVENT_FORMAT_X86_MASKED_ENTRY

With "Filter" in name,

 - KVM_PMU_FILTER_EVENT_FORMAT_X86_SELECT_UMASK
 - KVM_PMU_FILTER_EVENT_FORMAT_X86_MASKED_ENTRY

Look still okay. I'll rename it.

> > +#
> > +# Encoding formats of PMU event that QEMU/KVM supports.
> > +#
> > +# @raw: the encoded event code that KVM can directly consume.
> 
> Suggest
> 
>    # @raw: raw KVM PMU event code.

Concise. I agree.

> > +#
> > +# Since 10.1
> > +##
> > +{ 'enum': 'KvmPmuEventFormat',
> > +  'data': ['raw'] }
> > +
> > +##
> > +# @KvmPmuRawEvent:
> 
> Maybe KvmPmuFilterEventRaw?  Or is that too long?

KvmPmuFilterEventRaw is fine (not too long).

> > +#
> > +# Raw PMU event code.
> > +#
> > +# @code: the raw value that has been encoded, and QEMU could deliver
> > +#     to KVM directly.
> 
> Suggest
> 
>    ##
>    # @KvmPmuRawEvent
>    #
>    # @code: raw KVM PMU event code, to be passed verbatim to KVM.

Thanks for polishing it up, it looks much better.

> > +#
> > +# Since 10.1
> > +##
> > +{ 'struct': 'KvmPmuRawEvent',
> > +  'data': { 'code': 'uint64' } }
> > +
> > +##
> > +# @KvmPmuFilterEvent:
> > +#
> > +# PMU event filtered by KVM.
> 
> Suggest
> 
>    # A KVM PMU event specification.

Sure.

> > +#
> > +# @format: PMU event format.
> > +#
> > +# Since 10.1
> > +##
> > +{ 'union': 'KvmPmuFilterEvent',
> > +  'base': { 'format': 'KvmPmuEventFormat' },
> > +  'discriminator': 'format',
> > +  'data': { 'raw': 'KvmPmuRawEvent' } }
> > +
> > +##
> > +# @KvmPmuFilterProperties:
> > +#
> > +# Properties of KVM PMU Filter.
> > +#
> > +# @action: action that KVM PMU filter will take for selected PMU events.
> > +#
> > +# @events: list of selected PMU events.
> 
> Here's my try:
> 
>    # Properties of kvm-pmu-filter objects.  A kvm-pmu-filter object
>    # restricts the guest's access to the PMU with either an allowlist or
>    # a denylist.
>    #
>    # @action: whether @events is an allowlist or a denylist.
>    #
>    # @events: list of KVM PMU event specifications.

Thank you very much! Your description is very accurate.

Regards,
Zhao


