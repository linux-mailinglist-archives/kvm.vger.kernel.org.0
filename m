Return-Path: <kvm+bounces-58882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88397BA493E
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 18:15:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B0917166F0F
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 16:15:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30242242D9A;
	Fri, 26 Sep 2025 16:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UVAV3roX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8861E86E;
	Fri, 26 Sep 2025 16:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758903308; cv=none; b=EX1bLeh0n8DfBfj9CTp/oAaJ9n/KnpGq4yywVRznXoC6LFteIqn5DRogCsfvjeWOa8fNP0VGTmVdGrdjTyUpJw6BLQgrr8SqljzLQwsycQnGKVcWpc+7v4mU0NS++t+nQ9mU+556JR3GJ/yS9i868pEwu1RY8UxnLf+xmcv/+bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758903308; c=relaxed/simple;
	bh=t8AR7WOEUiw4ZcKxM0KTMnm2QVHmdvH9/aVeNZGSDKM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U089W/7JixIAXHh7BnPkZOE+qBBlSBkKxGnnS8jQ/02bdxjnsXt/MfQpsQ32D//KyuGYcuq6ZI9P+TSyZGHJ4zQsBl7jYv50dkg/bpGJ1a0OJ9nbTQnGuP6C57Im1avIhN7J7pcnYPJhDif+3Bs9lDMQKAxY8W6IW57Cn7AtrMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UVAV3roX; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758903306; x=1790439306;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=t8AR7WOEUiw4ZcKxM0KTMnm2QVHmdvH9/aVeNZGSDKM=;
  b=UVAV3roXsv6/aRXLhs+VdigiyBkMJjN4oPagr7scTaZ706z0oOcXR4+V
   yvvqO/Zsti5UPOsRHAaMTLSyThk7pEjMIVj7mnumSLGQyFdSzHYWCxD3Y
   9NpPfeQlZKfb8rW70w7C0mHRe7uZVMjwCSW44d8sIOvAL9fU7mpGCwbW0
   Gf8YQJu1xNd8rrwLnUNpeGWJrVVl4Ej1c8U5Lx3kJMlNfyWpQ0EI/cqDE
   +oU1v6Mpg1MRNUbXl0E2HcLKbVvbEIBzzVzhMIwm28e3US4kmeZLj21AN
   miLSB5mAB8W5QVz1Rf4zQspBb69fY2Ilcd3V8gxXTlbzKIMIFxRiERuA5
   g==;
X-CSE-ConnectionGUID: RDKGXL9gS0eU+uIrpOkw7g==
X-CSE-MsgGUID: oE+XToLtTxKdBmBRFycjPQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11565"; a="63874064"
X-IronPort-AV: E=Sophos;i="6.18,295,1751266800"; 
   d="scan'208";a="63874064"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2025 09:15:05 -0700
X-CSE-ConnectionGUID: Ccy6wmMuTkmsb6CfkjBy6w==
X-CSE-MsgGUID: 991VO/fiRdCxwDb1dEahCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,295,1751266800"; 
   d="scan'208";a="182917743"
Received: from puneetse-mobl.amr.corp.intel.com (HELO desk) ([10.124.221.28])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2025 09:15:05 -0700
Date: Fri, 26 Sep 2025 09:14:59 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: "Kaplan, David" <David.Kaplan@amd.com>
Cc: "x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: Re: [PATCH 2/2] x86/vmscape: Replace IBPB with branch history clear
 on exit to userspace
Message-ID: <20250926161459.gdcdag4gr6imeyfk@desk>
References: <20250924-vmscape-bhb-v1-0-da51f0e1934d@linux.intel.com>
 <20250924-vmscape-bhb-v1-2-da51f0e1934d@linux.intel.com>
 <LV3PR12MB9265478E85AA940EF6EA4D7D941FA@LV3PR12MB9265.namprd12.prod.outlook.com>
 <20250925220251.qfn3w6rukhqr4lcs@desk>
 <LV3PR12MB9265B1C6D9D36408539B68B9941EA@LV3PR12MB9265.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <LV3PR12MB9265B1C6D9D36408539B68B9941EA@LV3PR12MB9265.namprd12.prod.outlook.com>

On Fri, Sep 26, 2025 at 01:39:37PM +0000, Kaplan, David wrote:
> > > > --- a/Documentation/admin-guide/kernel-parameters.txt
> > > > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > > > @@ -8048,9 +8048,11 @@
> > > >
> > > >                         off             - disable the mitigation
> > > >                         ibpb            - use Indirect Branch Prediction Barrier
> > > > -                                         (IBPB) mitigation (default)
> > > > +                                         (IBPB) mitigation
> > > >                         force           - force vulnerability detection even on
> > > >                                           unaffected processors
> > > > +                       auto            - (default) automatically select IBPB
> > > > +                                         or BHB clear mitigation based on CPU
> > >
> > > Many of the other bugs (like srso, l1tf, bhi, etc.) do not have explicit
> > > 'auto' options as 'auto' is implied by the lack of an explicit option.
> > > Is there really value in creating an explicit 'auto' option here?
> >
> > Hmm, so to get the BHB clear mitigation do we advise the users to remove
> > the vmscape= parameter? That feels a bit weird to me. Also, with
> > CONFIG_MITIGATION_VMSCAPE=n a user can get IBPB mitigation with
> > vmscape=ibpb, but there is no way to get the BHB clear mitigation.
> >
> 
> Maybe a better solution instead is to add a new option 'vmscape=on'.
> 
> If we look at the other most recently added bugs like TSA and ITS,
> neither have an explicit 'auto' cmdline option.  But they do have 'on'
> cmdline options.
> 
> The difference between 'auto' and 'on' is that 'auto' defers to the
> attack vector controls while 'on' means 'enable this mitigation if the
> CPU is vulnerable' (as opposed to 'force' which will enable it even if
> not vulnerable).
> 
> An explicit 'vmscape=on' could give users an option to ensure the
> mitigation is used (regardless of attack vectors) and could choose the
> best mitigation (BHB clear if available, otherwise IBPB).
> 
> I'd still advise users to not specify any option here unless they know
> what they're doing.  But an 'on' option would arguably be more consistent
> with the other recent bugs and maybe meets the needs you're after?

Sounds good to me. I'll update the patch.

