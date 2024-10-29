Return-Path: <kvm+bounces-29941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8463D9B48A7
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 12:52:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B63C21C22265
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 11:52:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EA8F20515E;
	Tue, 29 Oct 2024 11:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b="FyNbLPGe";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Uvjp9qkR"
X-Original-To: kvm@vger.kernel.org
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03103193436;
	Tue, 29 Oct 2024 11:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730202729; cv=none; b=MamJiuD+EvLyeK7CoaLHx0b0aNNyJhcDRk8VoPPoSTHFrIhnjx+fCoMFo45uB7JeJUAieQ8d0bGz8bT6rNZOG4kCH0J+r2wSSWyd7MZ3KdAo1QizAA4ikacifAcgn5XcbI7r6uacrAL/qLXfQ+2BI6gl3jmllBNuAMMnjvq++8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730202729; c=relaxed/simple;
	bh=EePsdlQCjfO0TVcbow170r/ucXdnWMHPP9KAlcgpwSg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dnza0n7Lqvp4dKVmOx2z6hFa4yc72e2xkXJ5ZtZgA9S+owfsUBB8DKr8lpINcupZdis9T55rrfE0a3wnj35OC9tqQcnnd5RZH9PlzPVTDXBimFvQMzQpaHAEhyoDODD7teSFDVS6kT4H7QvYmHMNPs5hNbaEnBL2XT+KC0FYWBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name; spf=pass smtp.mailfrom=shutemov.name; dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b=FyNbLPGe; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Uvjp9qkR; arc=none smtp.client-ip=103.168.172.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shutemov.name
Received: from phl-compute-06.internal (phl-compute-06.phl.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id D7F8F13801BC;
	Tue, 29 Oct 2024 07:52:05 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Tue, 29 Oct 2024 07:52:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1730202725; x=
	1730289125; bh=pT0cokq8mro75dv3kWKLfvuiOd1qYe4GXZIeStMWHnE=; b=F
	yNbLPGeKXheWI03Uh/0QmaLLPMiWqKcYf27z4byy8Po+YasipA+IrVvMjA5IgEgJ
	yInBZFIFvzIVvUz4BoOIquL3yadB5umlDfiak108PwWWlO2HQ5Vk3UNwrqavm1sp
	IRHs3HgEEmE1qrKyocMREC46nWczQNmSfQpiJt/xP1c9QHswLE3uMz/bSdm8RuU4
	rlxwi8A+a3/WGI851lwC1NLkIbbjw7F+sKmS7P7EyFS46Ukhsd5BjOl2SPC23a9j
	4bFWk7F7mWPrFw5jmfhU+vnVgEn3embLexgP/EOeVfZiqOdmls7RmQeK+bA78dlp
	333PRNDUQs+8Jq8rKoRsw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1730202725; x=1730289125; bh=pT0cokq8mro75dv3kWKLfvuiOd1qYe4GXZI
	eStMWHnE=; b=Uvjp9qkRq3No8qWqEKklWaXBKO5QyYigSuggijWkqlWOJ/9Zqo5
	cHR26xe+MPLzeIPcAryBxW282vZihVyfcK9J5fR8/qUKs3XU03wcHK8rhg9fr6wW
	9M38ocCdVRqDokZ2PvPt1bAKhJpvx+l54QhBbgCQuVio6W0ttzEdQTZqjd8OCAMT
	YxmuBNK+p+yEvgg3XN5NjLTLIIZCCG1Xr///V6QSYEaOhgyGNXAbxhpPVnWl3gT3
	grK1zMpG06blbP4HPVs/L6wwm2qJ3GoXL4bmaUy7DISgusCx6lht6A0vQoIlSvuI
	VoRGmyADSvZunt/Fd3K5jvcZ/Kfl9+i7cag==
X-ME-Sender: <xms:ZcwgZyulk_Xk_QsUEfxcwMkgqRC_oR9J2VgKUCcBy9mLjvBaL7nr_A>
    <xme:ZcwgZ3cR3AuWsXI28jkRCQkGcSgcGLZTNzcA-WVHuFL8DHLRUh7nBnulkzjy_s7CC
    TfLGQJ3EiuM1doXOxQ>
X-ME-Received: <xmr:ZcwgZ9yxeAfiY_D6047KmFtSc95g4zxCJnSb0aU9RF3hqudk3wztRsGVWM97geGAXfsxlg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdekuddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvden
    ucfhrhhomhepfdfmihhrihhllhcutedrucfuhhhuthgvmhhovhdfuceokhhirhhilhhlse
    hshhhuthgvmhhovhdrnhgrmhgvqeenucggtffrrghtthgvrhhnpeffvdevueetudfhhfff
    veelhfetfeevveekleevjeduudevvdduvdelteduvefhkeenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhesshhhuhhtvghmohhv
    rdhnrghmvgdpnhgspghrtghpthhtohepudekpdhmohguvgepshhmthhpohhuthdprhgtph
    htthhopehnvggvrhgrjhdruhhprgguhhihrgihsegrmhgurdgtohhmpdhrtghpthhtohep
    sghpsegrlhhivghnkedruggvpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvgh
    gvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepthhglhigsehlihhnuhhtrhhonhhi
    gidruggvpdhrtghpthhtohepmhhinhhgohesrhgvughhrghtrdgtohhmpdhrtghpthhtoh
    epuggrvhgvrdhhrghnshgvnheslhhinhhugidrihhnthgvlhdrtghomhdprhgtphhtthho
    pehthhhomhgrshdrlhgvnhgurggtkhihsegrmhgurdgtohhmpdhrtghpthhtohepnhhikh
    hunhhjsegrmhgurdgtohhmpdhrtghpthhtohepshgrnhhtohhshhdrshhhuhhklhgrsegr
    mhgurdgtohhm
X-ME-Proxy: <xmx:ZcwgZ9PO4qE8UTbVBbkmMx6r-TeqtQvrFa8ERBJPag_ijSAxylKbtw>
    <xmx:ZcwgZy9mK5TD-U0ZsKcGgUC252CRvrLwUmtlDSR-F9B1TaYNovCXRg>
    <xmx:ZcwgZ1VYg4pJs7uW5kt44Ann9mxplejjaGP6rMKPdMw1rlVzKUCqeQ>
    <xmx:ZcwgZ7eLQpLoqk5zzTy6lnY-G4taPCPE6cvkwkANhB95Q8JNkQZH1w>
    <xmx:ZcwgZ13-GcRCz78Wl9CFjVhJLzprNsyyvyOr40n_HN2OsNNHBwliftf5>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 29 Oct 2024 07:51:59 -0400 (EDT)
Date: Tue, 29 Oct 2024 13:51:55 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, 
	Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, 
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, 
	peterz@infradead.org, seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [RFC 00/14] AMD: Add Secure AVIC Guest Support
Message-ID: <submtt3ajyq54jyyywf3pb36nto27ojtuchjvhzycrplvfzrke@sieiu6mqa6xi>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <vo2oavwp2p4gbenistkq2demqtorisv24zjq2jgotuw6i5i7oy@uq5k2wcg3j5z>
 <378fb9dd-dfb9-48aa-9304-18367a60af58@amd.com>
 <ramttkbttoyswpl7fkz25jwsxs4iuoqdogfllp57ltigmgb3vd@txz4azom56ej>
 <20241029094711.GAZyCvH-ZMHskXAwuv@fat_crate.local>
 <708594f6-78d3-4877-9a1e-b37c55ad0d39@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <708594f6-78d3-4877-9a1e-b37c55ad0d39@amd.com>

On Tue, Oct 29, 2024 at 03:54:24PM +0530, Neeraj Upadhyay wrote:
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index aeda74bf15e6..08156ac4ec6c 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -1163,6 +1163,9 @@ void disable_local_APIC(void)
>         if (!apic_accessible())
>                 return;
> 
> +       if (apic->teardown)
> +               apic->teardown();
> +
>         apic_soft_disable();
> 
>  #ifdef CONFIG_X86_32

Hm. I think it will call apic->teardown() for all but the one CPU that
does kexec. I believe we need to disable SAVIC for all CPUs.

Have you tested the case when the target kernel doesn't support SAVIC and
tries to use a new interrupt vector on the boot CPU? I think it will
break.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

