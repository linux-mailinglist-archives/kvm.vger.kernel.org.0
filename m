Return-Path: <kvm+bounces-5728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A593B8257C0
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 17:10:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CBEAC1C231FF
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 16:10:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58CC52E85A;
	Fri,  5 Jan 2024 16:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="e8XnFhLY"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A412E823;
	Fri,  5 Jan 2024 16:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id ECF8C40E0196;
	Fri,  5 Jan 2024 16:10:03 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id PCgHEbNop059; Fri,  5 Jan 2024 16:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1704471000; bh=hbXwqK0OxWvMXMXdG0rzK29hIKNQYHBM1ksrUbaSRh8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e8XnFhLYTn6wVrhB1oGHnnkiaLQNzGw27kCQ4orbXRtpPWQN15Ikeeb6dC9FMNT4V
	 08nbNNLdbuVqBsBVhLz8851dcrm8x3p+EW8GeJZlvbVieJDeTUvKCndfl3vUZCCZOY
	 VgENpIcUhA/q6LjhAknzz6vJYImadJXtK1CwOtySrs4Fqwrx3v3/r3LmYpre2akl2w
	 3zpgn4xYZKZIL+9BghPvkYG6YRQc5ENXxIiK2TnxekY7MdkOtVz6vvhRL48aSxro/Z
	 udKGIB0rzsmvT8y17GVwNigHycw2JCnHQMUNafy6TkuejfCkrrJTBzgnvpFavsmDG6
	 prZ0tRSDWIOyk98VQ0cl1MjsQ7mjAwFKG+ckDcgRmr2CsFKHOqRBV29c84oNDuGPx1
	 Wi42yvALu9FM4FCo5kSzTAz9kkS9EUCG71a4hFuZg02xr4RGRNUDXTVO0nKU9MRjwp
	 CFWa3Yl/jANlvdO9Ifub/VFbSe2aWXSSHP12uQbsyHbf9Pl1RyDTStobt/vTQ0tVo4
	 VHHoSzXuujKIcOJUG7vDL5EvoN0KDvfhNXQv7p8auEiMAwO2hYJBc4SFoCONRsjmSs
	 m1R+FAUvbMPZ5Kw5EFfRb1+UnZT4xoBaSEAWhC0/GS3Z4skpS4mHLzoJxA6ygZpZQg
	 MDWi7EbMfM4VPffbtRq7L0VM=
Received: from zn.tnic (pd9530f8c.dip0.t-ipconnect.de [217.83.15.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 445DA40E016C;
	Fri,  5 Jan 2024 16:09:21 +0000 (UTC)
Date: Fri, 5 Jan 2024 17:09:16 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc: Michael Roth <michael.roth@amd.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
	thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
	pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
	jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
	slp@redhat.com, pgonda@google.com, peterz@infradead.org,
	srinivas.pandruvada@linux.intel.com, rientjes@google.com,
	tobin@ibm.com, vbabka@suse.cz, kirill@shutemov.name,
	ak@linux.intel.com, tony.luck@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v1 04/26] x86/sev: Add the host SEV-SNP initialization
 support
Message-ID: <20240105160916.GDZZgprE8T6xbbHJ9E@fat_crate.local>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-5-michael.roth@amd.com>
 <f60c5fe0-9909-468d-8160-34d5bae39305@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f60c5fe0-9909-468d-8160-34d5bae39305@linux.microsoft.com>

On Thu, Jan 04, 2024 at 12:05:27PM +0100, Jeremi Piotrowski wrote:
> Is there a really good reason to perform the snp_probe_smptable_info() check at this
> point (instead of in snp_rmptable_init). snp_rmptable_init will also clear the cap
> on failure, and bsp_init_amd() runs too early to allow for the kernel to allocate the
> rmptable itself. I pointed out in the previous review that kernel allocation of rmptable
> is necessary in SNP-host capable VMs in Azure.

What does that even mean?

That function is doing some calculations after reading two MSRs. What
can possibly go wrong?!

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

