Return-Path: <kvm+bounces-13488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ED87C8977AF
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 20:00:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ACA3E1F2BFB6
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 18:00:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA833153810;
	Wed,  3 Apr 2024 18:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="dynqlT9j"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C46B153597;
	Wed,  3 Apr 2024 18:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712167218; cv=none; b=TLQRuQkHb5ovvLO4h0v5/aiwryfVMPbiz8ocWOJjmL2X+ChrqJ7y/89ILhA2vy9WM+rPKoyLHiKoVRGCpfeD/cQTVuuko0bG2FMmWQMIsopvC7vCA85I6F4XEf+ju0oIKlxcY/pV4XN/WVWs2/6noQutTJ2B0oszJsZRw2CfdU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712167218; c=relaxed/simple;
	bh=VqGrJmgUqHkU2achafaEzEb7xtlhP6ee/PmCCK6EUE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kVn78zxOawH2hQvlFX5yJrg8VN4GQNSnezhdJT678dSOgBZhIKAAdk/6ENc6vfR/0yIbRnuihcGJ4nF+VB4APXGRGHCnjcJzvwLIawyUuFboC5Q8ckV11hukIdj32wNOI8EhP3kes0l6G22493KbT+pSMf+4nOf3PxlXVhIjaME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=dynqlT9j; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 890A540E01A2;
	Wed,  3 Apr 2024 18:00:08 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 5d1qRHPWTj3J; Wed,  3 Apr 2024 18:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1712167204; bh=OHMjQM2vpY+riS5KwQTOhuL5twECwVPIrdHEm8svf7E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dynqlT9jQmHLQR6wkVHMyVBZc0pG6NkJz7KMh8IALQ8wVBVVajFqXVDkSq3iBB4Rl
	 +iGBE710dkVHlrN6FQByE5C/fqdzHlhuTQEMGNiPYIvruXIH0XG51T29mchRS9+ham
	 /TBMyPcBauV/4akz8loNGrtYzBBCV0YJwzsUc6jEn8B0bPystKvZugHwsppWGPYnzh
	 jTUfSB9Zbr+Ibhj2lbUfbaX2Qjfbm50WOADKiVpEt9Pcz/53m+xl/i0Np66gM6uSz0
	 yfA2w4bYj6eHpilZ6ubSO0E+JaNqVOQxASHDjvll45EGnhrYD+7LoPxNpXv5PNLvlI
	 1MHodiuF0Sauge5Pcrd2lAzaAoLaP9VNWQycJ2SYm+JfTb/6n9uaUs0GqW21v9S/7a
	 SuIX/i7J4H3Ui/glh8Pi7DlywlQGiSu3X1tAJkk0W56g4fUUy2VB4Cvumv/KWWeeqs
	 VIVYf0hyXG9fFZ3hz193dm0wjeucJNzsJZTwfqCqiBx7n7huuEGKTzJ+vgRR/TUMDs
	 Ei4tU7o9CslwuLJnSwzw2jy9aeQuddxMZeulYV6b4pQ26DrW3fCgJKri9Gtr3z4QE9
	 Wu+IvQe1CcZuPOHgWfk/MfknWWVnIVyyBSEH2ta2vw9UD4+BgCBH/BXMqn8dHq1uxB
	 IpDPTsIWPIABrbKmrpNOLbpU=
Received: from zn.tnic (p5de8ecf7.dip0.t-ipconnect.de [93.232.236.247])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7198C40E019C;
	Wed,  3 Apr 2024 17:59:56 +0000 (UTC)
Date: Wed, 3 Apr 2024 19:59:50 +0200
From: Borislav Petkov <bp@alien8.de>
To: Nikolay Borisov <nik.borisov@suse.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
	KVM <kvm@vger.kernel.org>, Ashish Kalra <ashish.kalra@amd.com>,
	Joerg Roedel <joro@8bytes.org>, Michael Roth <michael.roth@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 2/5] x86/alternatives: Catch late X86_FEATURE modifiers
Message-ID: <20240403175950.GKZg2ZFnCaE1BeRpTQ@fat_crate.local>
References: <20240327154317.29909-1-bp@alien8.de>
 <20240327154317.29909-3-bp@alien8.de>
 <540c12cb-f42d-469d-b3de-a52155298dda@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <540c12cb-f42d-469d-b3de-a52155298dda@suse.com>

On Wed, Mar 27, 2024 at 05:57:01PM +0200, Nikolay Borisov wrote:
> nit: While cleaning this bit mind if you also switch alternatives_patched to
> a bool?

Busy as hell right now. But I take patches ontop. :-)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

