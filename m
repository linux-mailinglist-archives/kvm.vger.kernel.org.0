Return-Path: <kvm+bounces-25482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D844F965CCE
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 11:27:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 15FE81C22A67
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 09:27:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE9D517B508;
	Fri, 30 Aug 2024 09:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kR3VoGT/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C2A17B4F9;
	Fri, 30 Aug 2024 09:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725010009; cv=none; b=NmVsu7pzhNfAueMwRbvIghEDZN8vVFLsmT3pALe96xzlB/5VgNgTQweKcrs4psWEK5IeNoLlQWqFOSmEFKuv69dUbcACpQBXCAx+jG3FF7KpGOoieBCe+1T9RxtD2o6Jce9dGbMXXwWK0SDRpLigTBrkzSEp2rXFh9a/FhsBsww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725010009; c=relaxed/simple;
	bh=d1lKZfcFNMLtS+NIATo7ARmto+5szlP2zG9TPe9nl8s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cDfO0hXjyTTdLx1gj/DfMb6UGge50fjBmleiQe/Lvvq/x21DdqamAOvPp17/6fTNBovAptc9wh0f3yvH4s+Iw2914wGt2KgHwZoVDvvfhgZeI/KW3AWGc5A6A/Jiiz2D96P7xnAqWFol1YT3CCNMkJLAzJ/FYwo13oB1DEqFQKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kR3VoGT/; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725010008; x=1756546008;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=d1lKZfcFNMLtS+NIATo7ARmto+5szlP2zG9TPe9nl8s=;
  b=kR3VoGT/MDNnBnF/JnTNpHa7LcIm+C7HazqF05m2KqIUFs7T62FeK2Pi
   fOga9sEzXZ6RN0rP9ktxLoD5PgYFTOQqYv2/Rwo9+0WFHaWX34na5bIax
   YX7Xt00dYwk6zZ+rV7wbeuSPoZe7wyECe7YE2acNzzS0fOSPpHBp32U4e
   MBVpzmj5ZKgabt/RIZKuNzUtc/FhExqLryde2I56XVHuBqnTdwT603gJI
   Lzt0LVE9Eht/q+yYiQ90rLWuiZZac5bZZ6Xsk11eRzDuKDaZOJkCq+xxB
   fNSTg7Wftj9GyPG7GOXhoKmSWxFolhljt+o0gZOufimkW9lgR9TdbM+L8
   g==;
X-CSE-ConnectionGUID: hVptpyrqSx+dM6o2QqvdJQ==
X-CSE-MsgGUID: WOAwsBM6T6KdIuy4uUGa2w==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="23798370"
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="23798370"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 02:26:47 -0700
X-CSE-ConnectionGUID: Ouq5KDycS7ut6/aVCmNy+w==
X-CSE-MsgGUID: mRradrWRSPyWdR2Kaj+YSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="101358806"
Received: from sschumil-mobl2.ger.corp.intel.com (HELO tlindgre-MOBL1) ([10.245.246.63])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 02:26:39 -0700
Date: Fri, 30 Aug 2024 12:26:07 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org, kai.huang@intel.com,
	isaku.yamahata@gmail.com, xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: Re: [PATCH 13/25] KVM: TDX: create/destroy VM structure
Message-ID: <ZtGQLwB6wfi0BfNI@tlindgre-MOBL1>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-14-rick.p.edgecombe@intel.com>
 <Zr8AYgZfInrwpAND@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zr8AYgZfInrwpAND@yilunxu-OptiPlex-7050>

On Fri, Aug 16, 2024 at 03:31:46PM +0800, Xu Yilun wrote:
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 84cd9b4f90b5..a0954c3928e2 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -5,6 +5,7 @@
> >  #include "x86_ops.h"
> >  #include "mmu.h"
> >  #include "tdx.h"
> > +#include "tdx_ops.h"
> 
> I remember patch #4 says "C files should never include this header
> directly"
> 
>   +++ b/arch/x86/kvm/vmx/tdx_ops.h
>   @@ -0,0 +1,387 @@
>   +/* SPDX-License-Identifier: GPL-2.0 */
>   +/*
>   + * Constants/data definitions for TDX SEAMCALLs
>   + *
>   + * This file is included by "tdx.h" after declarations of 'struct
>   + * kvm_tdx' and 'struct vcpu_tdx'.  C file should never include
>   + * this header directly.
>   + */
> 
> maybe just remove it?

Yes doing patch to drop it thanks.

Tony

