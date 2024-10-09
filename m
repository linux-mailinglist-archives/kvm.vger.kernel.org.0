Return-Path: <kvm+bounces-28234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F3D6D9969B1
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 14:13:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AC4DB1F245E8
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 12:13:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A55E192D95;
	Wed,  9 Oct 2024 12:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b="As2AU/x6";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="mWofEBXw"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8328319006F;
	Wed,  9 Oct 2024 12:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728475975; cv=none; b=NS2ZYDkwEbIXiqn/pqJK6ZgcxIj4bXkQX/iOz09LBl7UkzoNtrKSkhf3RD6GVjgkcimE2d90ZQBlhUGH9l0FdtIblK7HGusxT8kYLsWsklx3vT86JYOMwP5isVbmErb47dzOBCCWoWqufsaYN5o63OvCugdZT/kux1KHPoUocmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728475975; c=relaxed/simple;
	bh=VLgf5DQWYoicEad4+8ZjHT6h10QRS8XVrGx+7qaGKT8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mzmKy1sQe/8R4s7RltdIsxFaX2Fw4GRw2e8YFWm41ezQeQ/WHBBHKxHkRtdwyvfPW5poVb+22Hk3qjbfFjrcdZDJvI+bNjGCnAxcS3bwj0JlQLC3enk+EoDyP80n6IGHcgwHgED5dKeiu1cjYeLth7sAKzfsE043dyxOkvjaGHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name; spf=pass smtp.mailfrom=shutemov.name; dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b=As2AU/x6; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=mWofEBXw; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shutemov.name
Received: from phl-compute-05.internal (phl-compute-05.phl.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 7C10011401F0;
	Wed,  9 Oct 2024 08:12:52 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Wed, 09 Oct 2024 08:12:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1728475972; x=
	1728562372; bh=1G2ufhqAtTTJr0ijP6Iqp6WR089GbQN3jXP+OQjZo8k=; b=A
	s2AU/x6dHFIAayJfE2Oa2IjzvBk8P9fRPpSYV2GvtI2h6SP2lsedqgCOHjD4+mQe
	RuhJvApJkhJbVW2WBSH/uI4PktoFJOdoDLZuVrSkM39kU9yVWql3PIzOHfURp6Zt
	dD35VdhJjX78EUTZIm/8tgChhvUcJmE7Lv8kYXIEUk4Wgrd4z1mQ6ACnTsVDH9rj
	eyQSVy7QMwHJ9B8HepFSOjX//OoDDgFlC7zUwyTKeeKS0AQJfNY8FTDaDZvPYhtr
	CajC93/LjxmKwUcnQLNgYJdSHoxaVEHAOkHm2BflyvQ+QovaX2b5vMaicneI0i25
	z9CoI9KPXE0/1sQatOy+w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1728475972; x=1728562372; bh=1G2ufhqAtTTJr0ijP6Iqp6WR089G
	bQN3jXP+OQjZo8k=; b=mWofEBXwYEavECxPZKisbi3jl2WsIUNLw1qTQIQsxZ7A
	ZxNLZksj5JGKYVwVRtT67Z7JfPlOjHa+NW/63+XwJpesX6KMZmAIcYQz4w34Fy1W
	q+woK3KnPqm5tyKuh0ooa7SgFUu+Yb/+JCSTc6qndIDif1mrb7LzFpfD55dCDUJU
	ALg14SShWoghH2nSJfR/O1iPw8qltnhkjQs6ZRONruWHXjBCFv7ghOLY6o0eVl86
	6FxI96WbEeR3VfCjY+Xpo2CuRt+Q+cAo4Cc3wSgY/X50kpzrlV0Di4dA+J+K+V//
	bt7os6f1OAwHPSyIhfMY1uYS5cTH7wvxUASeh20JuA==
X-ME-Sender: <xms:Q3MGZ4KqF57KsCarxDuP64ma2X2ZGZ22vgcr30gS8NsGSwWyVXOkJg>
    <xme:Q3MGZ4KBEscvW1hGLAfHdE0MwxzcYqJ9kkadNalK7aT-SabJbcRd0Bm92RoiVEazo
    JpBPXkFsHM0s_7DklY>
X-ME-Received: <xmr:Q3MGZ4tIdHp69SskVtdZQ_H9dc0WcJqWKSBMDmWCmgOH0L1xzyCcyKh7y-t3OJiv2rmd_g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdeffedgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvden
    ucfhrhhomhepfdfmihhrihhllhcutedrucfuhhhuthgvmhhovhdfuceokhhirhhilhhlse
    hshhhuthgvmhhovhdrnhgrmhgvqeenucggtffrrghtthgvrhhnpeffvdevueetudfhhfff
    veelhfetfeevveekleevjeduudevvdduvdelteduvefhkeenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhesshhhuhhtvghmohhv
    rdhnrghmvgdpnhgspghrtghpthhtohepudekpdhmohguvgepshhmthhpohhuthdprhgtph
    htthhopegsphesrghlihgvnhekrdguvgdprhgtphhtthhopehnvggvrhgrjhdruhhprggu
    hhihrgihsegrmhgurdgtohhmpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvgh
    gvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepthhglhigsehlihhnuhhtrhhonhhi
    gidruggvpdhrtghpthhtohepmhhinhhgohesrhgvughhrghtrdgtohhmpdhrtghpthhtoh
    epuggrvhgvrdhhrghnshgvnheslhhinhhugidrihhnthgvlhdrtghomhdprhgtphhtthho
    pehthhhomhgrshdrlhgvnhgurggtkhihsegrmhgurdgtohhmpdhrtghpthhtohepnhhikh
    hunhhjsegrmhgurdgtohhmpdhrtghpthhtohepshgrnhhtohhshhdrshhhuhhklhgrsegr
    mhgurdgtohhm
X-ME-Proxy: <xmx:Q3MGZ1Yxt0vjUO52GSYw_oitRqFqtKjN-y5105rA0LHePNuxhSkIkw>
    <xmx:Q3MGZ_YJ3x6G0vzuzgVdxOlnmU1mS-rgp5h_mMpDmz3-V4bwHb7ABQ>
    <xmx:Q3MGZxDemIuTxSOQKe0WobfhdYAF9kq36ge9PbU3b3wULhJ3qod9Dw>
    <xmx:Q3MGZ1Z-9tBYL28V_YDYQsNQVMFb4oB2Ijgvjvz2gGpZWTzlD7L2kQ>
    <xmx:RHMGZ8RrwtyPUn_IMj0Y6cul1h4Nt-l2kFF9eS7qkeiXU2ULXwTPUEea>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 9 Oct 2024 08:12:45 -0400 (EDT)
Date: Wed, 9 Oct 2024 15:12:41 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Borislav Petkov <bp@alien8.de>
Cc: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, 
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com, 
	Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, 
	x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com, 
	pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [RFC 01/14] x86/apic: Add new driver for Secure AVIC
Message-ID: <wb6tvf6ausm23cq4cexwdncz5tfj52ftrrdhhvrge53za3egcf@ayitc4dd6itr>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-2-Neeraj.Upadhyay@amd.com>
 <sng54pb3ck25773jnajmnci3buczq4tnvuofht6rnqbfqpu77s@vucyk6py2wyf>
 <20241009104234.GFZwZeGsJA-VoHSkxj@fat_crate.local>
 <7vgwuvktoqzt5ue3zmnjssjqccqahr75osn4lrdnoxrhmqp5f6@p5cy6ypkchdv>
 <20241009112216.GHZwZnaI89RBEcEELU@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241009112216.GHZwZnaI89RBEcEELU@fat_crate.local>

On Wed, Oct 09, 2024 at 01:22:16PM +0200, Borislav Petkov wrote:
> On Wed, Oct 09, 2024 at 02:03:48PM +0300, Kirill A. Shutemov wrote:
> > I would rather convert these three attributes to synthetic X86_FEATUREs
> > next to X86_FEATURE_TDX_GUEST. I suggested it once.
> 
> And back then I answered that splitting the coco checks between a X86_FEATURE
> and a cc_platform ones is confusing. Which ones do I use, X86_FEATURE or
> cc_platform?
> 
> Oh, for SNP or TDX I use cpu_feature_enabled() but in generic code I use
> cc_platform.
> 
> Sounds confusing to me.

If you use SNP or TDX check in generic code something is wrong. Abstraction
is broken somewhere. Generic code doesn't need to know concrete implementation.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

