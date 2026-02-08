Return-Path: <kvm+bounces-70564-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qP6hB6j8iGmT0AQAu9opvQ
	(envelope-from <kvm+bounces-70564-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 08 Feb 2026 22:14:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8265A10A2A9
	for <lists+kvm@lfdr.de>; Sun, 08 Feb 2026 22:14:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C66C830078B1
	for <lists+kvm@lfdr.de>; Sun,  8 Feb 2026 21:14:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 885BD303C87;
	Sun,  8 Feb 2026 21:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="JT4LW8lV"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4842494F0;
	Sun,  8 Feb 2026 21:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770585249; cv=none; b=BB3g458mKu9OGXoNku1OezwaW27g0M/GiKHZdD1D0zt17VMa8qSLNc/LA3sXMVgAi+cGHWctbOqchUANuMYhF8KTY88ZXCxf2eDcleoNl+/kZD4UnMTk67O0YnjYk13jYup3PU1LozCF6FVhrgLMRqGtSFKsN149RKPakf0GxpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770585249; c=relaxed/simple;
	bh=JtnHGLd90Ife3zRkphE55gZyWLeMY62lP/vOI8EBkK4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hBT7AUkFHrlOys5HhRKccRINbCaThgSwjWnS6uT+aRMHFxK+3emaSdkZlUKTrvHUbs3r/VZRhOvA+3qwt2cChNEGHOZTFFp+5RyTgh/sRBl2li0r48E4Hq3StUi8RcDCDtStj/hGsUvz9OKcU+lJzVCOMsMbCelbFRTgOycLRqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=JT4LW8lV; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id EDC5640E02FA;
	Sun,  8 Feb 2026 21:14:05 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id uLISVvQqA1PA; Sun,  8 Feb 2026 21:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1770585240; bh=AqwAOuvbrNHIwy2LEOneCle/toAHeJqLfxEn6QnnuXk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JT4LW8lVBsbu9/4N6QuVYPjrimaPN3Hj5CzoxN3LJ4KHStPXgVZaH3LKKPjNOu66F
	 KnuiNd7moXYLHuEd9JlzSL8XryVkpopYP+mGOK/UXcP52D9+Y6ZCvnQizZswg3yDDS
	 SnYlP6xvW8b3z7h/g8gXtnsD7Btiqyr9PX06H9riI/TD4GwJKcuEVtYA4gEgxXRpAk
	 ggqXi9PPKVfx1omRRweSIfadwlYGfKCeJgYoTidtjytwtcl544tgCvczhu4P1zamTw
	 Hq0ttjk8YVPgSlzuZET6FfPfcMqWpfJMXmxjteN3mTB0PWpJMr53rwIUjMXF0ZpJUE
	 jW1woa1zV0s+KrbOvR+lIQfEDT7eM8z4e7bg4MdQzuMHRmy2kRTndPDl4zs1kl90ny
	 Xevq1cgh38UzXoGCb57w3on6ep2CFo5Oz5VUyzUEvhe0Q45EfnU9kLqO75TI0S0ZIR
	 AclSNIj8JXe9lTGrtE3f9SkmWu9VJWOvWM3CDIXsAmB1ftnkD+Xh3I/daaGFQS01Rx
	 Irv81qlq7I5QmpsrM9tkJ1lqREP8FNKR8vjpPf+g39Y1cN+38WBfQ5lu0TQ8x418lN
	 VYwQS0I7RP9Dynd0suyFgVzGAHRFaWYNFue7Y9UVDWmr1FIfiGG/q9j1MWSwJyoYiz
	 XyIOhBxOgX4QyZnyrquQBQAg=
Received: from zn.tnic (pd95306e3.dip0.t-ipconnect.de [217.83.6.227])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 7704140E02F7;
	Sun,  8 Feb 2026 21:13:48 +0000 (UTC)
Date: Sun, 8 Feb 2026 22:13:42 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jim Mattson <jmattson@google.com>
Cc: Carlos =?utf-8?B?TMOzcGV6?= <clopez@suse.de>, seanjc@google.com,
	kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>,
	Babu Moger <bmoger@amd.com>
Subject: Re: [PATCH] KVM: x86: synthesize TSA CPUID bits via SCATTERED_F()
Message-ID: <20260208211342.GBaYj8hhtYM-lYfq-X@fat_crate.local>
References: <20260208164233.30405-1-clopez@suse.de>
 <20260208182849.GAaYjV4Vh8i0kznTEK@fat_crate.local>
 <CALMp9eQmwsND7whnvVof1i=OsCdo6wcwBWyDRwS3Ud69WkKf-g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALMp9eQmwsND7whnvVof1i=OsCdo6wcwBWyDRwS3Ud69WkKf-g@mail.gmail.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[alien8.de,none];
	R_DKIM_ALLOW(-0.20)[alien8.de:s=alien8];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70564-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	DKIM_TRACE(0.00)[alien8.de:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bp@alien8.de,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.997];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[alien8.de:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8265A10A2A9
X-Rspamd-Action: no action

On Sun, Feb 08, 2026 at 12:50:18PM -0800, Jim Mattson wrote:
> > /*
> >  * Synthesized Feature - For features that are synthesized into boot_cpu_data,
> >  * i.e. may not be present in the raw CPUID, but can still be advertised to
> >  * userspace.  Primarily used for mitigation related feature flags.
> >                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >  */
> > #define SYNTHESIZED_F(name)
> >
> > > +             SCATTERED_F(TSA_SQ_NO),
> > > +             SCATTERED_F(TSA_L1_NO),
> >
> > And scattered are of the same type.
> >
> > Sean, what's the subtle difference here?
> 
> SYNTHESIZED_F() sets the bit unconditionally. SCATTERED_F() propagates
> the bit (if set) from the host's cpufeature flags.

Yah, and I was hinting at the scarce documentation.

SYNTHESIZED_F() is "Primarily used for mitigation related feature flags."
SCATTERED_F() is "For features that are scattered by cpufeatures.h."

And frankly, I don't understand why there needs to be a difference whether the
feature is scattered or synthesized. If the flag is set on baremetal, then it
is and it being set, denotes what it means. And if it is not set, then it
means the absence of that feature.

It is that simple.

Then it becomes a decision of the hypervisor whether to expose it to the guest
or not.

Not whether it is synthesized or scattered.

But maybe I'm missing an aspect which is important for virt...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

