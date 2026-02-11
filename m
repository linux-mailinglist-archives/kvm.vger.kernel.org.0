Return-Path: <kvm+bounces-70869-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yHD0IrSrjGl/sAAAu9opvQ
	(envelope-from <kvm+bounces-70869-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 17:17:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id AB038126090
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 17:17:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id CA3963004D9B
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:17:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C0DF33E355;
	Wed, 11 Feb 2026 16:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="BUpcMCMc"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E2D33BBD9;
	Wed, 11 Feb 2026 16:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770826669; cv=none; b=PH3r+D+9feixrUAQhuNSfCnF71HVVQdXJPHoo+Pixm+K4Tb7XQDL/wUtCebmKOkZM5KuN+Sp3c/WIpP0/vHChtIxh9n+Dswb6wLidrJqXji5EzjQ5hl5n0bZxlWw2gxjqsbSTCo1eIuV50Wl40X4tbmj5+L+jGCVnZ7fLfNFwUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770826669; c=relaxed/simple;
	bh=G6vXZebxCUsFeugdHjeu3HxyzUCne6VXw2l+HdBm2CQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WmWM+43vEb/rF5Wsdy7VD0dYaoFMHZ6HOmXkgaIDCSdfBfoVi1py3xNuAsTF6zETHPndZ8LK0iF1yct7H+C43UHEMHFyuUTU/A3oaRS4jDFNGPN1zxDHdpp5xAxBE2bSrzEHVZ6MHLfpOTz8jNJ9x8/xj6WXtnIA0r3NOkx75L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=BUpcMCMc; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 14D1C40E036D;
	Wed, 11 Feb 2026 16:17:45 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id BHJTouabZKCr; Wed, 11 Feb 2026 16:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1770826661; bh=XrtcAGAEaYhExKqgetxOyqBENSqsYNriDswh8kL4JF0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BUpcMCMcJ6dbfZjtWTD76drxsjG2KqygzsYi8k9TIa8czaY3azigv2gIjl5Qcj8FT
	 G9zdfhn0Ghsi5Ml4UEqi5JWktRNH2+HDJ82Vr/xHEDr0kZYXE3GrNDo0cXvxOD9Szc
	 Bhn1VICcbKr/6+GLzfDdBVRmMho7mgBnPSzPssA2GLFiaIHuXUHRVjtBHSeKXgZ4vw
	 xZlWIrJudG0f/oe0dWI0gcYiMpAFjqcgHUIuu8d6FZCYGc1LiRCKIlB/6QkFgRlKS2
	 0If7XAHvQEmV9zFDdd5pZpyQPTApAIKU0qcR2rYq9cxXx6CEg65PrzHwK638ArtP5S
	 1c5DetjKVON9A7uinDbnwDpI6cOvrGMkHOMxU7kQe3rLowkvFTVbWrwAjbhu35fZG+
	 LOBkuwLKzcrBSNgveOLWbnbXYV+44sq30bXC+2P8ZbkR1VfscmncysK9TbpayeTAeJ
	 ADV6ZK6lyXY3j8mButEEuhEM1k1z9DYcry1wMLlJhRB8a1oGWrt+tVF92bxL5W8nAl
	 8xhgC48X3xnWLwWYYvjQsZeXvM+Lqrfj18y76W7BWuvzRg5jWcr8z9Y+JCWjUrhDTx
	 9LbyexOb+2Uz5kaDXklHjVGVl8psXbepw+gDOLA9LkQvuafbdx6J1+va2iM+vOgEGC
	 /mSjlOgoFJDHewkMt2vJTu5Y=
Received: from zn.tnic (pd95306e3.dip0.t-ipconnect.de [217.83.6.227])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 684A340E0368;
	Wed, 11 Feb 2026 16:17:29 +0000 (UTC)
Date: Wed, 11 Feb 2026 17:17:23 +0100
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
Message-ID: <20260211161723.GDaYyrk9gZfONLoARz@fat_crate.local>
References: <e19b9666-b224-4fbd-92c9-82c712916a07@suse.de>
 <aYn3_PhRvHPCJTo7@google.com>
 <20260209153243.GBaYn-G02QE86Fje7g@fat_crate.local>
 <aYoLcPkjJChCQM7E@google.com>
 <20260209174559.GDaYodVxWsiesiedLJ@fat_crate.local>
 <aYpNzX8KhnQTmzyH@google.com>
 <20260210200711.GCaYuP74dOknGNV1DT@fat_crate.local>
 <aYvD6IHpEgS0DZBT@google.com>
 <20260211133226.GCaYyE6u_IMik5DY4m@fat_crate.local>
 <aYymNqGGnan7Ga1D@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aYymNqGGnan7Ga1D@google.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[alien8.de,none];
	R_DKIM_ALLOW(-0.20)[alien8.de:s=alien8];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70869-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bp@alien8.de,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[alien8.de:+];
	RCVD_COUNT_FIVE(0.00)[6];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,alien8.de:dkim]
X-Rspamd-Queue-Id: AB038126090
X-Rspamd-Action: no action

On Wed, Feb 11, 2026 at 07:54:30AM -0800, Sean Christopherson wrote:
> Those problems are _entirely_ limited to the fact that the kernel's feature tracking
> isn't 100% comprehensive.

Thus the rewrite. :)

> If the kernel tracks both raw CPUID *and* kernel caps, then KVM can use the
> table without having to (re)do CPUID when configuring KVM's feature set.  But
> KVM would still need to have processing for SYNTHESIZED_F, PASSTHROUGH_F, and F,
> to derive the correct state from the raw+kernel tables.

That's what I meant - the macros and the confusion which one to use would go
away.

> Because from my perspective, centralizing *everything* is all pain, no gain.  It
> would bleed KVM details into the broader kernel, unnecessarily limit KVM's ability
> to change how KVM emulates/virtualizes features, and require querying a lookaside
> table to understand KVM's rules/handling.  No thanks.

The point is not to limit KVM's ability but *augment* the internal
representation so that it *accomodates* KVM fully. But ok, your call.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

