Return-Path: <kvm+bounces-15862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C58958B12CC
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 20:47:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7D1841F25A20
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 18:47:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CAD71BF37;
	Wed, 24 Apr 2024 18:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="P9h75dPI"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3436B1772F;
	Wed, 24 Apr 2024 18:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713984422; cv=none; b=jPox2JiXvorbM0fgtU7yJhJ5hdV5NGCWXMzg35t5R8Tq4m6jGDnGRlsHdMXxMEIhGYYlHHdexOGSAHGoI0eV4qCU1nAZ0Z6L63cYne9KeFFvcMW4anZQXDlcwCPKAPS6BHauAxAgP2R0E8GZVswNE1CKRXRj//lLvbOlbxuN3OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713984422; c=relaxed/simple;
	bh=R99aO0G4C4tvy39lrwNWT9qRBl7d5x4sktKYwiBMh08=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eNBqFar6vtcU85JCUKDyqCaP5osTnKULusvZfEw+46UqLts9YmBJqwG/wHUyhk7lsTic4RenV65oVMV4i4NiQrhm9viQtS0eMTl/JJrjufRVc8trmDupi3SQrowOIuuwxzETtqX+lrao0Ps8ikP8PqQgxz5RK+JfQLNd157rAnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=P9h75dPI; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 1481C40E00C7;
	Wed, 24 Apr 2024 18:46:58 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 9TgzoTgZmhK5; Wed, 24 Apr 2024 18:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1713984414; bh=RLpabNxR4gGiC8iZOFYg5sG6e8hVLDbCHs9kLLbABtY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P9h75dPI/mx5pnSPDDQiSXL9pN3TWtTigX0Sm7sOUfMU0jnBPq43KeLerU1+SrIvY
	 pgraqvsnmPkmG6RTlpEuTZDOUIxo/cx7jdqEkiNhAdeLmZ567SbJfXdQIibccb6qF3
	 he6hv6NhQZnMhD1Hesnw9quD1Ob2TiAuyblF9dC/C+dFLFnYHkKG13EkjetnmWwoYX
	 83mRWOS+o5PMq9wMrfWt07GKEGDQ8o6LuDFPx8HkJR1od5MRBJJMGt0YGtK5GSE1hp
	 96BgBQfyLVyMgvpqh9CFd8/dZ2a/FT0Gv/Ueg+I1GHzNCLHXkDBfiso55GlLyREn8z
	 bjHgTg7l1iOFG/1pGuV3gaeSCl20b1w+lgXPYYHyiZzz7bCYBasi94EKr2fQTaxBp3
	 qiQNc/tqhUz3rI2M1yLQYEK5oOcMNYm+DXhNVwD8dLbz9bbHeni9SA7g+XFaTIOw/k
	 Hk3TGEnQ6l9W7OBtabjIlKpz1pe1uz3FdqwXa44lA+43TBgxzBh4h0o2j7WAg6so7W
	 FX7dXkNH4Z7veWc0D9ftL7jkeUkbtDUO6qmw5bUieXduOepyUJhT48HVYBjeij2xy6
	 4DCPNhEU4Kw2qJ5qJPw1qbn8B9jIBMAGQD6qlqvb/S7VZG1XlZtvNGJyDQ9uD8ozuv
	 gJf7lbDiaxaikAR5ozd0cqh4=
Received: from zn.tnic (pd953020b.dip0.t-ipconnect.de [217.83.2.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 479E340E0177;
	Wed, 24 Apr 2024 18:46:46 +0000 (UTC)
Date: Wed, 24 Apr 2024 20:46:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
	KVM <kvm@vger.kernel.org>, Ashish Kalra <ashish.kalra@amd.com>,
	Joerg Roedel <joro@8bytes.org>, Michael Roth <michael.roth@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 5/5] x86/CPU/AMD: Track SNP host status with
 cc_platform_*()
Message-ID: <20240424184640.GFZilTkCX42j5sPu-o@fat_crate.local>
References: <20240327154317.29909-1-bp@alien8.de>
 <20240327154317.29909-6-bp@alien8.de>
 <f6bb6f62-c114-4a82-bbaf-9994da8999cd@linux.microsoft.com>
 <20240328134109.GAZgVzdfQob43XAIr9@fat_crate.local>
 <ac4f34a0-036a-48b9-ab56-8257700842fc@linux.microsoft.com>
 <20240328153914.GBZgWPIvLT6EXAPJci@fat_crate.local>
 <aecd56a4-0a88-4162-95ef-47561631f16e@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aecd56a4-0a88-4162-95ef-47561631f16e@linux.microsoft.com>

On Thu, Apr 04, 2024 at 07:07:26PM +0200, Jeremi Piotrowski wrote:
> On 28/03/2024 16:39, Borislav Petkov wrote:
> > On Thu, Mar 28, 2024 at 03:24:29PM +0100, Jeremi Piotrowski wrote:
> >> It's not but if you set it before the check it will be set for all AMD
> >> systems, even if they are neither CC hosts nor CC guests.
> > 
> > That a problem?
> > 
> 
> No problem now but I did find it odd that cc_vendor will now always be set for AMD but
> not for Intel. For Intel the various checks would automatically return true. Something
> to look out for in the future when adding CC_ATTR's - no one can assume that the checks
> will only run when actively dealing with confidential computing.

Right, I haven't made up my mind fully here yet... setting cc_vendor
*only* when running as some sort of a confidential computing guest kinda
makes sense.

And if it is not set, then that can be used to catch cases where the
cc_* helpers are used outside of confidential computing cases...

Do we want those assertions? I don't know...

> I see your point about the disable needing to happen late - but then how about we remove
> the setup_clear_cpu_cap(X86_FEATURE_SEV_SNP) too? No code depends on it any more and it would
> help my cause as well.
> 
> > So we need a test for "am I a nested SNP hypervisor?"
> > 
> > So, can your thing clear X86_FEATURE_HYPERVISOR and thus "emulate"
> > baremetal?
> > 
> 
> Can't do that... it is a VM and hypervisor detection and various paravirt interfaces depend on
> X86_FEATURE_HYPERVISOR.

Right, but "your cause" as you call it above looks like a constant
whack'a'mole game everytime we change something in the kernel when
enabling those things and that breaks your cause.

Do you really want that?

Or would you prefer to define your nested solution properly and then
have upstream code support it like the next well-defined coco platform
instead?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

