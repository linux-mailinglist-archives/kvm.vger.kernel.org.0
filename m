Return-Path: <kvm+bounces-63744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F4D2C70A75
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 19:32:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5F9DA4E64BC
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 18:27:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BD47353893;
	Wed, 19 Nov 2025 18:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G+bYkD8p"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D53530F7EB;
	Wed, 19 Nov 2025 18:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763576818; cv=none; b=EdU/Ex7hR2VDxCTIvvftkwD3XpxCUd07efvm2ISsSqBjZvYVqYZhgqpmNNNvswEVBZTGYOeSM5SqRS3VKMJtyAYDEXByaiKtI9uHDgtwiLUDBBPDuEUUmitn8rnNazl4Ry3f12lQ26IG9Q7iTVTaibSO2bCY1iZrMj6t2kl5gLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763576818; c=relaxed/simple;
	bh=ydqk1zv1aAihO5SSB68AsfgAtMsD+3rhWRTo9COVYrQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CC5rMu5S2oOx8PCtL2IhEnYyJKjVq+SnX7EDmVmLRL4mjKulyGwECdXGPCZt+n5GSB+YkTsRs91RXg82dBXIjPhQE5sUI8obOFi9PELhx5ULNjvSvABvhDGL63EV197/waksIf0Oq6L9Bt9yUYEmyCHNUMzJWOqcKpy0cRnoeYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G+bYkD8p; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763576814; x=1795112814;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ydqk1zv1aAihO5SSB68AsfgAtMsD+3rhWRTo9COVYrQ=;
  b=G+bYkD8p0I/X+CXAoNAJzOAUNIBTk72T51DbDjaY05c1XbmGLuxTR5jo
   5I7nNWJiEWWejEDZPX8AkriVVAEZ7ec2n6ySpjB8L733FmHCz7syDjC3d
   DBkRjqtJoa62dBJQbpd7RardSTPMYNcNgw9K5RrpwMv0KVdYVmwnhPYka
   bH+tqtwnuxDd04JWLbF8c6kWcdVFRcFj7Dc+XI1Yx5r2r4jDssqqVPnYX
   8anwHtmQM1JbP7XnN+kIGFS+8jf9RnvT4a5aqegLbxxT7s9SqpMY05wYR
   yXAd2TVWUa/yfbu6jkkq7JVi7pj4pAF0xazM4GMpp/Y8DA1aNKs1AzTB9
   w==;
X-CSE-ConnectionGUID: QO74aEjSS/isZFWtnkIpwg==
X-CSE-MsgGUID: u8BG3HChQi6jiM6r7jcQYA==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="65669431"
X-IronPort-AV: E=Sophos;i="6.19,316,1754982000"; 
   d="scan'208";a="65669431"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 10:26:50 -0800
X-CSE-ConnectionGUID: rOrtJwGkRhyK4ZivvabKpA==
X-CSE-MsgGUID: iecTPBZdQlSZqxiDD+I5/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,316,1754982000"; 
   d="scan'208";a="214494578"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 10:26:49 -0800
Date: Wed, 19 Nov 2025 10:26:42 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Nikolay Borisov <nik.borisov@suse.com>
Cc: Dave Hansen <dave.hansen@intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: Re: [PATCH v3 2/3] x86/vmscape: Replace IBPB with branch history
 clear on exit to userspace
Message-ID: <20251119182622.nkhxgkdpdapeof6o@desk>
References: <20251027-vmscape-bhb-v3-0-5793c2534e93@linux.intel.com>
 <20251027-vmscape-bhb-v3-2-5793c2534e93@linux.intel.com>
 <b808c532-44aa-47a0-8fb8-2bdf5b27c3e4@intel.com>
 <20251106234055.ftahbvqxrfzjwr6t@desk>
 <6a7ad323-657d-4cda-83e2-58492394f44c@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a7ad323-657d-4cda-83e2-58492394f44c@suse.com>

On Wed, Nov 19, 2025 at 12:33:05PM +0200, Nikolay Borisov wrote:
> 
> 
> On 11/7/25 01:40, Pawan Gupta wrote:
> > [ I drafted the reply this this email earlier, but forgot to send it, sorry. ]
> > 
> > On Mon, Nov 03, 2025 at 12:31:09PM -0800, Dave Hansen wrote:
> > > On 10/27/25 16:43, Pawan Gupta wrote:
> > > > IBPB mitigation for VMSCAPE is an overkill for CPUs that are only affected
> > > > by the BHI variant of VMSCAPE. On such CPUs, eIBRS already provides
> > > > indirect branch isolation between guest and host userspace. But, a guest
> > > > could still poison the branch history.
> > > 
> > > This is missing a wee bit of background about how branch history and
> > > indirect branch prediction are involved in VMSCAPE.
> > 
> > Adding more background to this.
> > 
> > > > To mitigate that, use the recently added clear_bhb_long_loop() to isolate
> > > > the branch history between guest and userspace. Add cmdline option
> > > > 'vmscape=on' that automatically selects the appropriate mitigation based
> > > > on the CPU.
> > > 
> > > Is "=on" the right thing here as opposed to "=auto"?
> > 
> > v1 had it as =auto, David Kaplan made a point that for attack vector controls
> > "auto" means "defer to attack vector controls":
> > 
> >    https://lore.kernel.org/all/LV3PR12MB9265B1C6D9D36408539B68B9941EA@LV3PR12MB9265.namprd12.prod.outlook.com/
> > 
> >    "Maybe a better solution instead is to add a new option 'vmscape=on'.
> > 
> >    If we look at the other most recently added bugs like TSA and ITS, neither
> >    have an explicit 'auto' cmdline option.  But they do have 'on' cmdline
> >    options.
> > 
> >    The difference between 'auto' and 'on' is that 'auto' defers to the attack
> >    vector controls while 'on' means 'enable this mitigation if the CPU is
> >    vulnerable' (as opposed to 'force' which will enable it even if not
> >    vulnerable).
> > 
> >    An explicit 'vmscape=on' could give users an option to ensure the
> >    mitigation is used (regardless of attack vectors) and could choose the best
> >    mitigation (BHB clear if available, otherwise IBPB).
> 
> I thought the whole idea of attack vectors was because the gazillion options
> for gazillion mitigation became untenable over time. Now, what you are
> saying is - on top of the simplification, let's add yet more options to
> override the attack vectors o_O. IMO, having 'force' is sufficient to cover
> scenarios where people really want this mitigation - either because they
> know better, or because they want to test something.

Agree with that in general. It all boils down to: Is there are use case
where people would want to use attack vector controls but want to override
one specific mitigation?

> Force also covers the "on" case, so let's leave it at "on" for attack vector
> support, and 'force' for everything else

Force covers the "on" case with a caveat that it also forces the BUG on
unaffected CPUs.

Given that attack vectors do allow all other mitigations to override the
attack vector settings, VMSCAPE should be no different. Or else we
introduce a change to let attack vectors reign all mitigations.


