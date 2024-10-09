Return-Path: <kvm+bounces-28230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EAE499967F7
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 13:04:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 28A001C2290B
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 11:04:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2CE01917C2;
	Wed,  9 Oct 2024 11:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b="SyrxhV8W";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="MbosoE6u"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF7D1C68F;
	Wed,  9 Oct 2024 11:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728471842; cv=none; b=XW+QcMDt3BZCdx1MrhZLlus8Vh2VIiEyE+QnFg5ZGCruRqKRG9Kz7dpBwFIt3ZnBX7IIGHldZqH/JP5a38gCiNWKtaCXJ+nvZbnaztevagaAbCpZJDotkJv7gDBnLAZki1wVpTRDrTr4kH809aZbhoBO5rs22dZdOUULxWFRtV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728471842; c=relaxed/simple;
	bh=46KSu3I7HPDFM5TysvcbzMjnE/OsD7wd/6EaPKMDOjg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fy5oj863BtYy8xTnJ8yJOCKWwG1fOxNdSDLfYvVr0vrmqr+/eioLjOpyzQnEDhnnyPrIw54t1m0LRewj71jhYnVULUnTneboyXtujCZupZGPNUOydnCKLekIUlFTf1jfWpDV1/cdWmYPutqD7mj5sx8FWxd3QK1nJBCT9HI8Me0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name; spf=pass smtp.mailfrom=shutemov.name; dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b=SyrxhV8W; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=MbosoE6u; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shutemov.name
Received: from phl-compute-03.internal (phl-compute-03.phl.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id BDC1E11402B9;
	Wed,  9 Oct 2024 07:03:59 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Wed, 09 Oct 2024 07:03:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1728471839; x=
	1728558239; bh=6OKyW496BkbkGgcATIsbd85ETsMnr154XgFBJtz+ll0=; b=S
	yrxhV8WyktoITF/JrvkZUKdya6uFV5EOlOXNLDjYuznHMD9sOanBxWmtTtFHVHvR
	HqhYIn2fTeLQAa2GNaqKAxLfMDpCWZiacI6bNgv3LaQxNUQi+TD1DummmUBM9t5p
	PlGH4GAvw1kZPidokjeRlr0SZJxVeOIvGERC4PmVdSVLRf4nkYDlEc5Fqri2HfDd
	yA6fFyU3lnsbQXUXDVz9EcIlZfK4vD7YYvceA1lPHmHf+Efl9icKHIvvOrFrRjek
	Y/iO4cmi10ybItM2YTnNzSmBboS/7F6oa/tYzV0YTIjCIgvTcaKHh9ciH7dCJVm5
	rOe7zlmFBXYiA5zeApniQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1728471839; x=1728558239; bh=6OKyW496BkbkGgcATIsbd85ETsMn
	r154XgFBJtz+ll0=; b=MbosoE6uVQMYVwpXVngkyo/yx1E6X6G11IIRZfNSdnj2
	aCQ+OsTj1lheiptWAyoBAq7H7ugeJB85zsWEOAIo/DMB2S87x+U3BJcMVFi6m16L
	KvQPbR4cJo8TZSxR+mre0/RuqMj6i5ly4sfDM/iX8cwZyKQ9qtF7NhGnrhGt3dMi
	qVqU2HKPmX4WMxzaFsqr7UanMY7yzdSdc2XR5vJWK0aasC2Nl1lezeB15vhnffOK
	aHAvKVAxS33BFJ8Lj/JeRH1dbPGi5VoGggxTWLUmVHnngZ6GGsFBuYeThIySlKmL
	4Fo3U6ubyP6AQljCzgYJIY4VCAjeAOOQs+Q2hzpezA==
X-ME-Sender: <xms:H2MGZz4YL8uMLm8jG5sdpMqUL6-OIkje12ykmGDnu3Y3o5-cG-aQFQ>
    <xme:H2MGZ44i8zcuRC9vSoPD_kMLPWmpKVoQ1UT84JSV02_cOXA-9FCkIOPOp3uChod2u
    N0jEw2hzBTTg0HdBcg>
X-ME-Received: <xmr:H2MGZ6ei2TnUegPRApjar93SJY3oEKzjpSVhv3KQyWHdu_McG7zhEXyiMxbQWCe2Dquldw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdeffedgfeejucetufdoteggodetrfdotf
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
X-ME-Proxy: <xmx:H2MGZ0K3ozJZBusu0m-d9mvVI4uaIATE06Mesr9RafFHvIj7DNDCOQ>
    <xmx:H2MGZ3IXdg88DuasyPU1PIfhSAMSCzYHXYlgKtHLERIW5F1tB5o6Kw>
    <xmx:H2MGZ9wDV6jAxMDU9PHIgWWtlF_a3G0nFRgQX0_Sf1IHBOXXrWzAhQ>
    <xmx:H2MGZzLe8aPQqb3OK1pop4jd14G5QpHcsZjACaUaZK5Sqm4KvaaeVw>
    <xmx:H2MGZ8BjaRWAwGK1-iem-Uri5mjQ30CdYx7dTzxHtaBNz8wCzpobuLTI>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 9 Oct 2024 07:03:53 -0400 (EDT)
Date: Wed, 9 Oct 2024 14:03:48 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Borislav Petkov <bp@alien8.de>
Cc: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, 
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com, 
	Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, 
	x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com, 
	pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [RFC 01/14] x86/apic: Add new driver for Secure AVIC
Message-ID: <7vgwuvktoqzt5ue3zmnjssjqccqahr75osn4lrdnoxrhmqp5f6@p5cy6ypkchdv>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-2-Neeraj.Upadhyay@amd.com>
 <sng54pb3ck25773jnajmnci3buczq4tnvuofht6rnqbfqpu77s@vucyk6py2wyf>
 <20241009104234.GFZwZeGsJA-VoHSkxj@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241009104234.GFZwZeGsJA-VoHSkxj@fat_crate.local>

On Wed, Oct 09, 2024 at 12:42:34PM +0200, Borislav Petkov wrote:
> Do you have a better idea which is cleaner than what we do now?

I would rather convert these three attributes to synthetic X86_FEATUREs
next to X86_FEATURE_TDX_GUEST. I suggested it once.

> Yes yes, cc_platform reports aspects of the coco platform to generic code but
> nothing stops the x86 code from calling those interfaces too, for simplicity
> reasons.

I don't see why it is any simpler than having a synthetic X86_FEATURE.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

