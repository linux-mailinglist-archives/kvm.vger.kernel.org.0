Return-Path: <kvm+bounces-36749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50CE3A20789
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 10:41:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3812A7A35EF
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 09:40:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5978519A288;
	Tue, 28 Jan 2025 09:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kzzYQTKt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E742AC2ED;
	Tue, 28 Jan 2025 09:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738057247; cv=none; b=aTWoqeLH71ohyzleC8z3YipHWLWTNUuk/xd/Y8nIf3ObdlBZSS5x+4Xgo6XQX+GUN3v4xRF+AUgUDfaMgOjjTfNSsdVNqncWkeT632mI9lLcNsBPSmm3JhEb5J6UGTGsg0ez+cvbYJ75LaJBg5111e59+1US5VqKTlP00Py7L4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738057247; c=relaxed/simple;
	bh=r/nybymICXVoL0O6lcrG3Ve4Yga43SuQ1Q6D4qB2sKk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rTywhlEp0uOpQIxsTcu4d7ZHgXFftrRh/1mNKXAG0+NH8YtZO1PQL/du7kqDLyMnoRaaUNul5S12vgKSGy6pk0LMd2PMj5XsUcAmLmJ3z+wLV0YGdJff/91PUNzL9yczoMfg1Hyz42rcwql66hEF/O0paG+pS3E0PQGarXJZfWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kzzYQTKt; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738057246; x=1769593246;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=r/nybymICXVoL0O6lcrG3Ve4Yga43SuQ1Q6D4qB2sKk=;
  b=kzzYQTKtS0oqUCPqy2D08TWJd6yPW7Nvdn1ObXN9OS9NwRIi52F9lA4o
   jx1TyhVCOcQBBBSr5WJRoPdGZrU3Gn7dt6In/+6wu0oMSNrzm7iczS/11
   05FuaSPuJ9NXuQR9gH3bwEYDQgs+JFeps0SaDValaHsABZlvuHURpZyZW
   cvuHkJjJLtuQt1NF9KHkybUz/EWo/NWKshH4ICjZRcPligVSHqQuY5nz9
   QIaFJmR0JFpmA2Lj8S4SgzgGp2yWuNPQdPbkaKERzUsAXr+TEvHjPfyf7
   ZM3Fr6aHGBuqk9ZpRzHCrgoorAG/kIySdedYI+ou8z3wUeZEhr59XCRbf
   w==;
X-CSE-ConnectionGUID: K8sZrBN9TaKhsJYEAhvFrA==
X-CSE-MsgGUID: w4gVfhJlT/K4/xYY+g98Gw==
X-IronPort-AV: E=McAfee;i="6700,10204,11328"; a="42198984"
X-IronPort-AV: E=Sophos;i="6.13,240,1732608000"; 
   d="scan'208";a="42198984"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2025 01:40:46 -0800
X-CSE-ConnectionGUID: bm0e5hfbSSitif7G9zcL5A==
X-CSE-MsgGUID: jHI0vX10ThSPFWY4x2UYoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="131983449"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa002.fm.intel.com with ESMTP; 28 Jan 2025 01:40:42 -0800
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id AC03E1AC; Tue, 28 Jan 2025 11:40:40 +0200 (EET)
Date: Tue, 28 Jan 2025 11:40:40 +0200
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Binbin Wu <binbin.wu@intel.com>, 
	Juergen Gross <jgross@suse.com>, Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH] x86/kvm: Override default caching mode for SEV-SNP and
 TDX
Message-ID: <lcrinmkf33z3ubjzwhsdhpzibtso2b7s7wcjxspzuogyovojah@7ldxar23fffw>
References: <20241015095818.357915-1-kirill.shutemov@linux.intel.com>
 <Z5P_Rj4Uc82lJBDx@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z5P_Rj4Uc82lJBDx@google.com>

On Fri, Jan 24, 2025 at 12:59:50PM -0800, Sean Christopherson wrote:
> As a stopgap, rather than carry this CoCo hack, what if we add a synthetic feature
> flag that says it's ok to modify MTRRs without disabling caching?  I think that'll
> make TDX happy, and should avoid a long game of whack-a-mole.  Then longterm,
> figure out a clean way to eliminate accessing the "real" MTRRs entirely.

That's kina make sense to me. But I obviously didn't understand scale of the
mess around MTRRs and can only hope it will not break anything else. :/

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

