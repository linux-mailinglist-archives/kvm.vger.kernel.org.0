Return-Path: <kvm+bounces-28896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 183BA99EE38
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 15:54:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6B92A1F22FA5
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 13:54:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB9521B218A;
	Tue, 15 Oct 2024 13:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HYJUyb6E"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640521FC7D1;
	Tue, 15 Oct 2024 13:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729000466; cv=none; b=MT70uUZqasvVk3MrxT2H5lbSb3DFGrDsllTM9XVuUUobHwFrSWxOiJasx4kbp6vmNSdmSljh7mI07SUZI+aDavSk6EpIPv/CwxuJCJbtKmiu3aY/OO0orfkfWHx0P6RZcL44cOVstgr0Mcb+hgRCw5Kje6840NsAx44z5KdZZeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729000466; c=relaxed/simple;
	bh=o0S1qVw0y5bambm4KtSzE6iXeatOB6ZyfvSnqPbiKlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ueAdJkRsgpEp4DuDpgWpBHCCyFKN+fjk26N/dOiFmAC8UFOcyFuekqOnubhqA0grRHhkrmGzBstTFKUDD1vRX5G7aNv3S3BTmuXx7CJHOg5GAtoXwPHuzLd+dKWHdAEiD5c6EjwsC5LYyVAZQWY+t4YosoHheWzfylUBz0WCDPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HYJUyb6E; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729000464; x=1760536464;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=o0S1qVw0y5bambm4KtSzE6iXeatOB6ZyfvSnqPbiKlw=;
  b=HYJUyb6EU59ay88FrUEzsmYUsL7rl0LKQOgZjMzWxHsc3TMTy0lVDouY
   OVEHbrF9raiDDA4IEWrQwnZL3xxO9dYX3+EhS0/rWYtezWWYz8KzWWMGz
   u6duLFwpr9OXCCdNEoiGnOA8OyP+JkM7yAx14bKRPa6vIAaJHVeQG9LHt
   UIWw6H3u+AiJYCENRbo1kOYY5IpDXXzrC3plo3Etmk4Ig3eY/FUUiA9RY
   n7W9GOdl8U8REgry5xfgNqe3fmlsZK//egGB+goriwDBEjO4UMMJEVzwM
   QKlT9jIc6yW4H4gGKAg13KPoPkQm3z5JnqtzANURqBMzNnMArPjcS+EHj
   Q==;
X-CSE-ConnectionGUID: QjxFZpZ1TuS5VxYfz8PgRw==
X-CSE-MsgGUID: UFjbuBYBQLKTFWCPZP1U+A==
X-IronPort-AV: E=McAfee;i="6700,10204,11225"; a="38970599"
X-IronPort-AV: E=Sophos;i="6.11,205,1725346800"; 
   d="scan'208";a="38970599"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2024 06:54:23 -0700
X-CSE-ConnectionGUID: MIMMorjKTj2y+QkHdIM62Q==
X-CSE-MsgGUID: /a2NuIqcRz2b7CHSyAsSVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,205,1725346800"; 
   d="scan'208";a="77518082"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa006.fm.intel.com with ESMTP; 15 Oct 2024 06:54:20 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 80749329; Tue, 15 Oct 2024 16:54:19 +0300 (EEST)
Date: Tue, 15 Oct 2024 16:54:19 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: =?utf-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Binbin Wu <binbin.wu@intel.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH] x86/kvm: Override default caching mode for SEV-SNP and
 TDX
Message-ID: <sr2au3c5me6nexco46sqmld25nxonpg4ry3vf7ody5yw6dyjpc@m77cc2nnksdp>
References: <20241015095818.357915-1-kirill.shutemov@linux.intel.com>
 <294ce9a5-09b8-4248-85ad-18bdea479c73@suse.com>
 <3ae51aac-085a-44f6-9f6f-565c7c5687ad@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3ae51aac-085a-44f6-9f6f-565c7c5687ad@intel.com>

On Tue, Oct 15, 2024 at 06:14:29AM -0700, Dave Hansen wrote:
> On 10/15/24 03:12, Jürgen Groß wrote:
> >>
> >> +    /* Set WB as the default cache mode for SEV-SNP and TDX */
> >> +    mtrr_overwrite_state(NULL, 0, MTRR_TYPE_WRBACK);
> > 
> > Do you really want to do this for _all_ KVM guests?
> > 
> > I'd expect this call to be conditional on TDX or SEV-SNP.
> 
> I was confused by this as well.
> 
> Shouldn't mtrr_overwrite_state() be named something more like:
> 
> 	guest_force_mtrr_state()
> 
> or something?
> 
> The mtrr_overwrite_state() comment is pretty good, but it looks quite
> confusing from the caller.

I can submit a following up patch with rename if it is fine.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

