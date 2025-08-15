Return-Path: <kvm+bounces-54812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48CBAB28783
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 23:06:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B7EF1B660B0
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 21:05:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F08EF23FC41;
	Fri, 15 Aug 2025 21:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="DvLML2BZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850F9DF71;
	Fri, 15 Aug 2025 21:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755291998; cv=none; b=ZJCeju8NXgHvkPiX+nSAxe/PQLqfXTmXLpapVKzMhiE6B2jaQoLVBL2IDzDH6sI8kg2c+4qMcquoeeDUN4F5s78pCUPEnse0QU/7LZJgxg4E0UlGYHlRSG5yx2nhmEMKIfOR7je0BRqoOUtZFBIsnkQkcaSA2qom8hvht/ORETI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755291998; c=relaxed/simple;
	bh=NAkG8uNPuBjiRKU2ZLHNxEhFL0M5wJph8yZCZtbRGIE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z8FgM5cLgwl1cM8d0Tka89zlgoDbRwx26F27AgtXiZO730zKt1AZD3UocFpxmL1Aai7lU+C8Nnh1UkSIV8X9sVpdWVjO5kS57My4Kx/byTZZaJ64HwVTQmQoDjviVhbDoJWNp5r1eFI0nhyCWWhl6zJD5fD3e0cPefbMeAeEcLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=DvLML2BZ; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id B456D40E01AB;
	Fri, 15 Aug 2025 21:06:31 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id WwUoz-xiBvLy; Fri, 15 Aug 2025 21:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1755291988; bh=qcmvscoEUWBdt1tu+Rr26PL+x4+QNmeO2l7jiVR3K5E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DvLML2BZcoAoR0C6J2IvM8RaGRwtmW7m+CFGp4RRnWefY25aMPPnbpLL3N/lcQSZ3
	 JBSxgbNFBOyKHVZW4cVpNLZSRfpQJv9KmTLA3CCgnC5cDYeNdvwySl8/L45Pea+y4g
	 oQ1XoGMhOTtjxSu829OF2+xaFFR0nP7LTtB21Q/TJFLIl8Se3M4tebXb2ri/3x8KJz
	 gBJBteL4YEEdPnxi35v3mBMj6UGRVDcJcIx8i+/qkFg/zLZLXkw4oVtMjdmOgKP67Y
	 il9/KM+3NI3nJ3yQUdvqv4fAwE9tvzPeL99EupU9z2rMVm0bwRgYFuIC+oOWY/Tpsy
	 UuAxbPJmeDqHqfZodp3m/puAfGnY/xfagjEALm/ydzVrznOcEm1G2NqQ4Sv/Ir0UpJ
	 fMnPHzzxteigS7FNYzHHS1KK0kDonSaP1njoL2UpP0e6kBMkMqChrLG2rhtImKPcnC
	 bmf9bWuWQOood+hdCkRfbegG+u35kvbQkEHDgGp8192UpjiRtw3o0dTKNHkxY82jK3
	 GEbKIEdBS0Q1me67deK9JsuMtQGiVnRfmpyNdn8hnrC5iGtuGWQklmR1JFRtieMde2
	 PSzgJHZwlbhVA3NZwtmwq2yb0FuyPbpN5qS2Kt4akjVUWaUNn6ya9vF/zWyfDmB/Dv
	 omYL8OWaeze2or4RiIBOMhiU=
Received: from zn.tnic (pd953092e.dip0.t-ipconnect.de [217.83.9.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2081340E0176;
	Fri, 15 Aug 2025 21:06:06 +0000 (UTC)
Date: Fri, 15 Aug 2025 23:05:59 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Upadhyay, Neeraj" <neeraj.upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org,
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com,
	naveen.rao@amd.com, francescolavra.fl@gmail.com,
	tiala@microsoft.com
Subject: Re: [PATCH v9 02/18] x86/apic: Initialize Secure AVIC APIC backing
 page
Message-ID: <20250815210559.GIaJ-hN2LMGQQyqVtI@fat_crate.local>
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
 <20250811094444.203161-3-Neeraj.Upadhyay@amd.com>
 <20250815102537.GCaJ8LIZodp1yY39QA@fat_crate.local>
 <7395fc42-5af1-4e26-9e39-8e7213ac5f7b@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7395fc42-5af1-4e26-9e39-8e7213ac5f7b@amd.com>

On Fri, Aug 15, 2025 at 06:46:55PM +0530, Upadhyay, Neeraj wrote:
> There are four new functions. So, do I need to put them in new
> arch/x86/coco/sev/savic.c file?
> 
> savic_register_gpa()
> savic_unregister_gpa()
> savic_ghcb_msr_read()
> savic_ghcb_msr_write()

Lemme go through the set first.

Those last two, for example: we're adding more MSR handling routines related
to SEV and this is slowly getting out of hand.  But lemme look first.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

