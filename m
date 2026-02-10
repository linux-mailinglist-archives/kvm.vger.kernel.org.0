Return-Path: <kvm+bounces-70782-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4IOtBxiQi2nYWAAAu9opvQ
	(envelope-from <kvm+bounces-70782-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 21:07:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BA05E11EE73
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 21:07:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4E36F301B03B
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 20:07:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C201F332ECC;
	Tue, 10 Feb 2026 20:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="U4W7KasF"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA38A215F7D;
	Tue, 10 Feb 2026 20:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770754058; cv=none; b=bOYf+E900Mb3+cQRK7lcilG2dbpfLAvjX2bKJ4hDwRLkMxg4n06lkJLQpvyLO8dCmmFEPiGYfMgp/3RUt9lc4J3ReoOqiGF3AbWwFVkxelH/pwJcHStQLvYLs6dLfVVPX1tg7fD9oToaKfXeBXLZdf+tU4PVli2+71kDzjTly88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770754058; c=relaxed/simple;
	bh=VhFJszymG5UsGrOAO76ZfmpDZA7cchBFqxn8sDmqZBs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sy/C/nq5061hcYycmExmWiX5aBQcH6mXfX+lA3pwj0Jax3Q1cMAkYGOBprAPtLHYnADebSpQH2VaBCeqwNIG5T4TOTy0pqOHhw8sqdbwZ9Gn9JqBIQNKelECxNloLy+/zaez4AZWeL90GhWxPz8Xwn06RRuJqsSZSn2EO3rbM/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=U4W7KasF; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 7215B40E0366;
	Tue, 10 Feb 2026 20:07:33 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 3vEh4xaYEgHU; Tue, 10 Feb 2026 20:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1770754050; bh=Sdope15o0UJIxClOXBEHvBOv7OhcfMkPCTgucnMwaBE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U4W7KasFRX/T2r6ukMaHv/0kLNMQFtSud+sok0c035o6mXBFOX+LthMN5XZsSFzMo
	 eVTYYj+xwDEaP8aH1b1yIhizL9qypT2N7hC9DpVgOUnuhB8dIsZsTmeoIpNHt1ZYbw
	 n+zLATUb+t3JFtWX4mEVkFRRgcAdSOWqn45wzRHZQ6r7qFPu9kMtXGf4M3qm9oAthK
	 a1gu/hOScAoRmHjxeHNh7XOtb6usSBDUEiWArA/XhSslZAmHdJcCSBXue8XjwNcPzf
	 gcC8w6QUvy1VmkSfNFFAVbaH9zxR8bymWkQBQOsgdcn+sLK40/ELfDJMBxmmqAHixY
	 b5Bw4xPpGZL+uAN430cOPbJ2xdZC4FlnUTThAb1wwde7KvSdWi4xc3dYlWgE/Lo7Kw
	 bZc/lY/e/3y7sJ6XzmJzwDfPwjLeFQD2UZGRjb2gH8XNQpsLBtVjtbEhw9IQxtCfVB
	 oc98ioNH/TVT6/apUhopoc1JXOemVDgRaJ7h5p6h+Y3O1jDFc4aBpv3c3ARZaxWMzy
	 dlTKpZFgS8BxFWmp4sE6fCi4336YCQdnben24W86LsqquHheFvizm/KiNqEMD6HKYr
	 MDRgQkjb5L5KReKGMOZU20etnss4WZ/Ey7NPFPLwaDQ3KuzXhNHrOMl3MYekiGCaVW
	 cthWktazeDn9SPY07pJ82xdc=
Received: from zn.tnic (pd95306e3.dip0.t-ipconnect.de [217.83.6.227])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id D71B440E0359;
	Tue, 10 Feb 2026 20:07:17 +0000 (UTC)
Date: Tue, 10 Feb 2026 21:07:11 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Carlos =?utf-8?B?TMOzcGV6?= <clopez@suse.de>,
	Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>,
	Babu Moger <bmoger@amd.com>
Subject: Re: [PATCH] KVM: x86: synthesize TSA CPUID bits via SCATTERED_F()
Message-ID: <20260210200711.GCaYuP74dOknGNV1DT@fat_crate.local>
References: <20260208182849.GAaYjV4Vh8i0kznTEK@fat_crate.local>
 <CALMp9eQmwsND7whnvVof1i=OsCdo6wcwBWyDRwS3Ud69WkKf-g@mail.gmail.com>
 <20260208211342.GBaYj8hhtYM-lYfq-X@fat_crate.local>
 <CALMp9eSVB=iRec2A0tmRzkTBa9zz4BVS8Lu79vUuRPrTawYFcQ@mail.gmail.com>
 <e19b9666-b224-4fbd-92c9-82c712916a07@suse.de>
 <aYn3_PhRvHPCJTo7@google.com>
 <20260209153243.GBaYn-G02QE86Fje7g@fat_crate.local>
 <aYoLcPkjJChCQM7E@google.com>
 <20260209174559.GDaYodVxWsiesiedLJ@fat_crate.local>
 <aYpNzX8KhnQTmzyH@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aYpNzX8KhnQTmzyH@google.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[alien8.de,none];
	R_DKIM_ALLOW(-0.20)[alien8.de:s=alien8];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70782-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bp@alien8.de,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[alien8.de:+];
	RCVD_COUNT_FIVE(0.00)[6];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[alien8.de:dkim,fat_crate.local:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BA05E11EE73
X-Rspamd-Action: no action

On Mon, Feb 09, 2026 at 01:12:45PM -0800, Sean Christopherson wrote:
> On Mon, Feb 09, 2026, Borislav Petkov wrote:
> > On Mon, Feb 09, 2026 at 08:29:36AM -0800, Sean Christopherson wrote:
> > > Nope.  KVM cares about what KVM can virtualize/emulate, and about helping userspace
> > > accurately represent the virtual CPU that will be enumerated to the guest.
> > 
> > So why don't you key on that in those macros instead of how they're defined?
> > 
> > 	EXPOSE_TO_GUEST_F()
> > 
> > and then underneath we can figure out how to expose them.
> 
> Huh?  That's what the macros do, they describe KVM's handling of the associated
> feature.  SYNTHESIZED is a bit weird because it bleeds some kernel details into
> KVM, but ultimately it's still KVM decision as to whether or not "forced" features
> can be synthesized for the guest.

My point is that you have to know *which* macro of all the available ones you
need to use, in order to expose the feature. This thread is a case-in-point
example about how it can get confusing. And it dudn't have to...

> 
> > We could have a helper table which determines what each feature is and how it
> > should interact with raw host CPUID or something slicker.
> > 
> > >   F               : Features that must be present in boot_cpu_data and raw CPUID
> > >   SCATTERED_F     : Same as F(), but are scattered by the kernel

Right, so what happens if we unscatter a leaf?

And why does it matter to KVM if the baremetal feature is scattered or not?
KVM should only care whether the kernel has set it or not.

> > >   X86_64_F        : Same as F(), but are restricted to 64-bit kernels
> > >   EMULATED_F      : Always supported; the feature is unconditionally emulated in software

And an emulated feature *can* be scattered or synthesized or whatever...

> > >   SYNTHESIZED_F   : Features that must be present in boot_cpu_data, but may or
> > >                     may not be in raw CPUID.  May also be scattered.

So which one do I use here?

This is the confusion I'm taking about.

> > >   PASSTHROUGH_F   : Features that must be present in raw CPUID, but may or may
> > >                     not be present in boot_cpu_data

Maybe there's a reason for it but why would the guest care if the feature is
present in raw CPUID or not? The hypervisor controls what the guest sees in
CPUID...

> > >   ALIASED_1_EDX_F : Features in 0x8000_0001.EDX that are duplicates of identical 0x1.EDX features
> > >   VENDOR_F        : Features that are controlled by vendor code, often because
> > >                     they are guarded by a vendor specific module param.  Rules
> > >                     vary, but typically they are handled like basic F() features
> > >   RUNTIME_F       : Features that KVM dynamically sets/clears at runtime, but that
> > >                     are never adveristed to userspace.  E.g. OSXSAVE and OSPKE.
> > 

Also, we're rewriting the whole CPUID handling on baremetal and someday the
CPUID table in the kernel will be the only thing you query - not the CPUID
insn. Then those names above become wrong/obsolete.

> > And for the time being, I'd love if this were somewhere in
> > arch/x86/kvm/cpuid.c so that it is clear how one should use those macros.
> 
> I'll a patch with the above and more guidance.
> 
> > The end goal of having the user not care about which macro to use would be the
> > ultimate, super-duper thing tho.
> 
> And impossible, for all intents and purposes.  The user/contributor/developer
> needs to define KVM's handling semantics *somehwere*. 

I still don't get this: why does KVM need to know whether a X86_FEATURE is
scattered or synthesized or whatnot?

> Sure, we could to that in a big array or something, but that's just
> a different way of dressing up the same pig.  All of this very much is an
> ugly pig, but it's the concepts and mechanics that are ugly and convoluted.

Well, if we're redoing how feature flags and CPUID leafs etc are being handled
on baremetal, why not extend that handling so that KVM can put info there too,
about each feature and how it is going to be exposed to the guest instead of
doing a whole bucket of _F() macros?

> E.g. if we define a giant array or table, the contributor will need to map the
> feature to one of the above macros.

We are on the way to a giant array/table anyway:

https://lore.kernel.org/r/20250905121515.192792-1-darwi@linutronix.de

> In other words, kvm_initialize_cpu_caps() _is_ the helper table.

$ git grep kvm_initialize_cpu_caps
$

I'm on current Linus/master.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

