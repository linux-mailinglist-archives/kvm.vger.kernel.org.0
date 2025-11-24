Return-Path: <kvm+bounces-64446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C3B13C82C87
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 00:10:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A53F634BAC2
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 23:10:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFE253358B7;
	Mon, 24 Nov 2025 23:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ldDo57Yw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3BE33556B;
	Mon, 24 Nov 2025 23:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025765; cv=none; b=XXX1n/2qmwt+fW3vruWRj2cs6UdOKzvfUsWAxP1tp4bFG3TaWrPse9t/SDZfNim8Ni1OwfLjEfTzY4hwyvPbb+xnb/EwL8YfeD5sgkxSFscMyrAUlyJvO3g2v5muIsX2OSeMNFuSWQgDw7ARHUHx+xH8c+YtdlElIk+uMBaHhC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025765; c=relaxed/simple;
	bh=kpJ0rTdSBASsD7kh2aTN70GasYDEm2gY4fMHi0sTPvw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uG6ZdoIXqCEqwABRJeFlXsu1TK7QNmOBzzBlx/Ygpys4IPzdnzx4JWYuC95qo/W8FBrxbbhPHEhK3gWWl1u58AYwZI0ENAUfOspXlFcTIRfDsBjVev8k2YUpoHunYKTWzDIRRAaoP804JbWwYQWpdhYTr1BzczDNo4BqtIsYF0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ldDo57Yw; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764025764; x=1795561764;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kpJ0rTdSBASsD7kh2aTN70GasYDEm2gY4fMHi0sTPvw=;
  b=ldDo57YwrpXDXLjPllKUq1YFAmZTKNP8knU1pGseVVdV0h0FHxJoD2dk
   q+LiGWj7ycyZZCr/BZqMdW5Yoh9qaYxXnUEBr7vz7uHD4i425hI+44Ujp
   6vGdwLxfEX9H71X8putTLfyNrP2NWlcwPaidS7dT7eA0hIfrPqF3LyBwS
   +hubVjsraFtIemjMWPB03Sjkpla4H1LiLjYBAbEEzkwakSklLqpJQDaxY
   NLCs6f72ZejY6oS9vI5HHnjmk4oxiJTYByOdfJ5k9dww5Vz8K2383OpZn
   U1phqK3nSvXFdg/3CN2kgFAjDr/KSA4Gq+O2kKzqaE2qc4jdceR0udmix
   w==;
X-CSE-ConnectionGUID: l3aBkJa7TIGNbGzisR4Czg==
X-CSE-MsgGUID: 3GMrFH9qR02qVUYzy/YBhA==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="76722588"
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="76722588"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 15:09:23 -0800
X-CSE-ConnectionGUID: pWMf5jKmSsCN6LozrYofRA==
X-CSE-MsgGUID: jV6XtRJQQkK9lzJ+vR8Dng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="192122435"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 15:09:23 -0800
Date: Mon, 24 Nov 2025 15:09:17 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Nikolay Borisov <nik.borisov@suse.com>
Cc: x86@kernel.org, David Kaplan <david.kaplan@amd.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: Re: [PATCH v4 06/11] x86/vmscape: Move mitigation selection to a
 switch()
Message-ID: <20251124230917.7wxvux5s6j6f5tuz@desk>
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
 <20251119-vmscape-bhb-v4-6-1adad4e69ddc@linux.intel.com>
 <c8d197cb-bd8d-42b0-a32b-8d8f77c96567@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8d197cb-bd8d-42b0-a32b-8d8f77c96567@suse.com>

On Fri, Nov 21, 2025 at 04:27:05PM +0200, Nikolay Borisov wrote:
> 
> 
> On 11/20/25 08:19, Pawan Gupta wrote:
> > This ensures that all mitigation modes are explicitly handled, while
> > keeping the mitigation selection for each mode together. This also prepares
> > for adding BHB-clearing mitigation mode for VMSCAPE.
> > 
> > Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> > ---
> >   arch/x86/kernel/cpu/bugs.c | 22 ++++++++++++++++++----
> >   1 file changed, 18 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> > index 1e9b11198db0fe2483bd17b1327bcfd44a2c1dbf..233594ede19bf971c999f4d3cc0f6f213002c16c 100644
> > --- a/arch/x86/kernel/cpu/bugs.c
> > +++ b/arch/x86/kernel/cpu/bugs.c
> > @@ -3231,17 +3231,31 @@ early_param("vmscape", vmscape_parse_cmdline);
> >   static void __init vmscape_select_mitigation(void)
> >   {
> > -	if (!boot_cpu_has_bug(X86_BUG_VMSCAPE) ||
> > -	    !boot_cpu_has(X86_FEATURE_IBPB)) {
> > +	if (!boot_cpu_has_bug(X86_BUG_VMSCAPE)) {
> >   		vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
> >   		return;
> >   	}
> > -	if (vmscape_mitigation == VMSCAPE_MITIGATION_AUTO) {
> > -		if (should_mitigate_vuln(X86_BUG_VMSCAPE))
> > +	if ((vmscape_mitigation == VMSCAPE_MITIGATION_AUTO) &&
> > +	    !should_mitigate_vuln(X86_BUG_VMSCAPE))
> > +		vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
> > +
> > +	switch (vmscape_mitigation) {
> > +	case VMSCAPE_MITIGATION_NONE:
> > +		break;
> > +
> > +	case VMSCAPE_MITIGATION_IBPB_ON_VMEXIT:
> > +	case VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER:
> > +		if (!boot_cpu_has(X86_FEATURE_IBPB))
> > +			vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
> > +		break;
> > +
> > +	case VMSCAPE_MITIGATION_AUTO:
> > +		if (boot_cpu_has(X86_FEATURE_IBPB))
> >   			vmscape_mitigation = VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER;
> 
> 
> IMO this patch is a net-negative because as per my reply to patch 9 you have
> effectively a dead branch:
> 
> The clear BHB_CLEAR_USER one, however it turns out you have yet another one:
> VMSCAPE_MITIGATION_IBPB_ON_VMEXIT as it's only ever set in
> vmscape_update_mitigation() which executes after '_select()' as well and

Removed VMSCAPE_MITIGATION_IBPB_ON_VMEXIT.

> additionally you duplicate the FEATURE_IBPB check.

FEATURE_IBPB check is still needed for VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER.
I don't think we can drop that.

> So I think either dropping it or removing the superfluous branches is in
> order.
> 
> >   		else
> >   			vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
> > +		break;
> >   	}
> >   }
> > 
> 

