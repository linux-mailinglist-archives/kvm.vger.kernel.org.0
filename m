Return-Path: <kvm+bounces-70845-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iNB4BpeFjGmfqAAAu9opvQ
	(envelope-from <kvm+bounces-70845-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 14:35:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DFEB124CED
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 14:35:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 634283034645
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 13:32:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 773DA27B34E;
	Wed, 11 Feb 2026 13:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="IhQf8LnX"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B4F1FDA61;
	Wed, 11 Feb 2026 13:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770816776; cv=none; b=A4p1He3otYJ+jpaqeBd4CAkvDE0+Rknbdwr7Ba2glO4yrRTpeCH53H5nHslcpcgXjW1y42jqyQ4h6OSJCqy8ulWVkpl88u5fllqyFwI91Cg2m7vH4jf+QqjkS4Qlg8xS3MzR0ImZmeCUgXRtCBOkS3pgMIamO71TD/R8OZjcBAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770816776; c=relaxed/simple;
	bh=g/GetwdgXSD/xOBMKj8OrlB9rpaJVIJD4oSieh9mPtE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q+jfEyWdUG1/CaYt/WP92U5Rin59i/mUoefBr5F25S0evTK/B1mdtBc9aovVqOeQoEMtupGnRGY2nBiAyLRBUp0hw84LikesDbxpoVakA6OK4Na92UVrLasTi/taiq/GMNYF8EOdBVUyy+KNOyrVnLI7+6j+iNLjhT6AZQU6GEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=IhQf8LnX; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id C6E7E40E036A;
	Wed, 11 Feb 2026 13:32:51 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ZRhpbI53fyIZ; Wed, 11 Feb 2026 13:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1770816767; bh=+3hvh3COznYSlONvJ1K2yVwHlJ+zq2d4iHs6m3j8Gzw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IhQf8LnXD6E5YwFHuBLwZF4FU5+xYpNv5zljDwkg4/iM7NoImBhFEoMnTReW4Jrya
	 xmPdgsyA/b7OOLig4LMgWvz4NW0Jd9eNqQeAkR0hPhTW5mFRMCcL6GIrsQXc/XK1Vi
	 mjxGL1iy5VuVJ/TKBTB32yMBk8ke9qmtt0nmuZc7Hb8KkPcjwWZ4lebXioJ0s0qDZd
	 WmDjDxVOHSYrvVD+VsT62rkU//dBWSaE/lYouxrt7F66mAnCA05bp9n5yIj7RLFtyo
	 DcOtkheX31niVpVbeUsLKFi6bYBxqlnKZEkXxZ3D75GwaUWhgppxoPHFbXF4m7qY4o
	 jgADIlIJ7EvxF+mmtbNwL6PcnH/wLw1oWpRgbU4tU70OBwZQdwd5pj7vlj282FCdRB
	 D+xy0rvVKGq4pKIWjWNrwGoPNgxOV8LklbVB4nAgNqQIXrpxxIejDapXdOQReNWQcU
	 MFtUKMBOd9SkxpAKoClt9OJhIswlq8aESGeq1YLoGVy0WMNhaQErarRDjanKGbePJL
	 5cC53p6vK87DnVrb0RlrcIHJuDbKXrOx2mvQRAIJ7YcWMMICR1Zidz08R0n8x4sPAZ
	 Gk0PYvfMdEdQ9+A4xRJHkFdR/+E68cbTsj3mzdPtsP8AjcoU947xK3DSg41t7aV9h/
	 QM2kuuzqTrdVsaovcuxHwxYs=
Received: from zn.tnic (pd95306e3.dip0.t-ipconnect.de [217.83.6.227])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id A3F0040E0367;
	Wed, 11 Feb 2026 13:32:35 +0000 (UTC)
Date: Wed, 11 Feb 2026 14:32:26 +0100
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
Message-ID: <20260211133226.GCaYyE6u_IMik5DY4m@fat_crate.local>
References: <20260208211342.GBaYj8hhtYM-lYfq-X@fat_crate.local>
 <CALMp9eSVB=iRec2A0tmRzkTBa9zz4BVS8Lu79vUuRPrTawYFcQ@mail.gmail.com>
 <e19b9666-b224-4fbd-92c9-82c712916a07@suse.de>
 <aYn3_PhRvHPCJTo7@google.com>
 <20260209153243.GBaYn-G02QE86Fje7g@fat_crate.local>
 <aYoLcPkjJChCQM7E@google.com>
 <20260209174559.GDaYodVxWsiesiedLJ@fat_crate.local>
 <aYpNzX8KhnQTmzyH@google.com>
 <20260210200711.GCaYuP74dOknGNV1DT@fat_crate.local>
 <aYvD6IHpEgS0DZBT@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aYvD6IHpEgS0DZBT@google.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[alien8.de,none];
	R_DKIM_ALLOW(-0.20)[alien8.de:s=alien8];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70845-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bp@alien8.de,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[alien8.de:+];
	RCVD_COUNT_FIVE(0.00)[6];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[alien8.de:dkim,fat_crate.local:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6DFEB124CED
X-Rspamd-Action: no action

On Tue, Feb 10, 2026 at 03:48:56PM -0800, Sean Christopherson wrote:
> See above regarding scattered.  As for synthesized, KVM is paranoid and so by
> default, requires features to be supported by the host kernel *and* present in
> raw CPUID in order to advertise support to the guest.

Yes, it will check for X86_FEATURE to be and then look at CPUID.

> Because IMO, that would be a huge net negative.  I have zero desire to go lookup
> a table to figure out KVM's rules for supporting a given feature, and even less
> desire to have to route KVM-internal changes through a giant shared table.  I'm
> also skeptical that a table would provide as many safeguards as the macro magic,
> at least not without a lot more development.

Lemme cut to the chase because it seems to me like my point is not coming
across:

We're changing how CPUID is handled on baremetal. Consider how much trouble
there was and is between how the baremetal kernel handles CPUID features and
how KVM wants to handle them and how those should be independent but they
aren't and if we change baremetal handling - i.e., unscatter a leaf - we break
KVM, yadda yadda, and all the friction over the years.

Now we have the chance to define that cleanly and also accomodate KVM's needs.

As in, you add a CPUID flag in baremetal and then in the representation of
that flag in our internal structures, there are KVM-specific attributes which
are used by it to do that feature flag's representation to guests.

The new scheme will get rid of the scattered crap as it is not needed anymore
- we'll have the *whole* CPUID leaf hierarchy. Now wouldn't it be lovely to
have a

	.kvm_flags = EMULATED_F | X86_64_F ... RUNTIME_F

which is per CPUID feature bit and which KVM code queries?

SCATTERED_F, SYNTHESIZED_F, PASSTHROUGH_F become obsolete.

No need for those macros, adding new CPUID feature flags would mean simply
adding those .kvm_flags things which denote what KVM does with the feature.
Not how it is defined internally.

And then everything JustWorks(tm) naturally without having to deal with those
macros.

And you'd get rid of the KVM-only CPUID leafs too because everything will be
in one central place.

Now why wouldn't you want that wonderful and charming thing?!

:-)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

