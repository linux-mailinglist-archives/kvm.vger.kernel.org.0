Return-Path: <kvm+bounces-69879-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mJ+SEhvdgGnMBwMAu9opvQ
	(envelope-from <kvm+bounces-69879-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 18:21:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BAC4ECF862
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 18:21:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 20BA5305244D
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 17:13:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 548DA3859EC;
	Mon,  2 Feb 2026 17:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="RrMbrKv+"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E8A2309AA;
	Mon,  2 Feb 2026 17:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770052373; cv=none; b=uVWl4d1OOXBkJFJSOpA4PvkyqA2E4tYg8I+d/v3w7C5t7rVZP7QtKpXQwQ+dXtrVX+jV9YeKbcctUqw9ToyUuzcp/ark8KwmMGdkcxudrm+OKec3+wxEqemdBpAjVSOFqx/7Q7uzCYle4jl2hSGGP+7J9RS8mxxW28dvnndwQOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770052373; c=relaxed/simple;
	bh=0suJ9RR4oxWjLccnVHbgEvcDnZX8EFMhToKmLnljTdw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XfCGl4l2WsU0+NIhXuKqdG8dMY3nqRPrtg7Q/j6twhvz916tWdlitzx2ZGvT546q2vznj7GowCTwlsXBb7J3XWGYdShQa3MTYBXr3lnyqwbqGWpDgiGtWuGa0UU16s2fuc5mc3vBqXrx0qKLCgigW50cte+93BcTTookiPr+Wf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=RrMbrKv+; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 48AC940E01A2;
	Mon,  2 Feb 2026 17:12:48 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id jO-KhsHOD73k; Mon,  2 Feb 2026 17:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1770052364; bh=d/bb4KwgGH6RVuLCLy6qYqxmx0zaCVcVm4+UuESfx8Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RrMbrKv+sGp6UvI9DkMnN5FW5Igq9Tsh11kxDpWsjaRxgbLI0n6/0EV2D/uWikHe+
	 bvCZAtf+IfSKbEEHr4pWTaS1QwBYXv6rMaW19nVSAvYRXRzGvH8S64Zcn2EjjPfHNX
	 DiiAjKr3sfYoLDAnXkIJi+zOHa8b82W2s6AUEY0gtb3isaxio0LYej9Vv5v7Bj1xsX
	 JWIJ1XSh0lyAoB0wH5V4lGMD6n4C9x9N3AFvlULkaph0TixQme2LjHbucN6qbUulIq
	 EdXieenY9U5bPHLBc2JSGl3rbBkh5DWjxtQ1eR09Qw1+lLUWynq5msxxUS0/UIwr+p
	 zLpgUdT0Yz6TuDX0nTBqSvWhInv6N+CjtkfwUITqMq9DsE0AtuKfDAQViEb330eBM8
	 g4zn5AdbvpOBsq3ssxdXSXautLRkhVU5Fj5FxiwEPwM0c5lb8m0P/6FC6JcEy4KN4O
	 GqKeKSYVhRqQolQK/Rq+dS3iRQNvpnqzZfdawpU4U4BKSbEPFQxOZhTpI9fNgjP5bb
	 sm98jzvh5N3GXUAnzZ3l96qrNddORXAHnjNECcenWoQ4g7Q/3VMPT5JXHCwSJq1BPi
	 oczFlxv3B/m2Q4HoRcpC7q451lcA7YSkEDNGsPybVfNe3YJ4npAhzh+Z+mtZyUcj+Z
	 F0S8SX9HOFVwBSsw5Pp7VWU0=
Received: from zn.tnic (pd953023b.dip0.t-ipconnect.de [217.83.2.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 7FB3B40E035C;
	Mon,  2 Feb 2026 17:12:30 +0000 (UTC)
Date: Mon, 2 Feb 2026 18:12:23 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Kim Phillips <kim.phillips@amd.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-coco@lists.linux.dev, x86@kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Naveen Rao <naveen.rao@amd.com>,
	David Kaplan <david.kaplan@amd.com>, stable@kernel.org
Subject: Re: [PATCH 1/2] KVM: SEV: IBPB-on-Entry guest support
Message-ID: <20260202171223.GBaYDa9z7sKO9q3Q9a@fat_crate.local>
References: <20260128192312.GQaXpiIL4YFmQB2LKL@fat_crate.local>
 <e7acf7ed-103b-46aa-a1f6-35bb6292d30f@amd.com>
 <20260129105116.GBaXs7pBF-k4x_5_W1@fat_crate.local>
 <f42e878a-d56f-413d-87e1-19acdc6de690@amd.com>
 <20260130123252.GAaXyk9DJEAiQeDyeh@fat_crate.local>
 <2295adbc-835f-4a84-934b-b7aba65137a8@amd.com>
 <20260130154534.GCaXzSHgkEFnk5mX14@fat_crate.local>
 <6556bacb-2e81-4aa8-92e4-0ff8642f4ec9@amd.com>
 <20260202154936.GAaYDHkOMpjFpoBe5m@fat_crate.local>
 <3392d89c-ebf5-48f2-b498-a7dc532a0493@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3392d89c-ebf5-48f2-b498-a7dc532a0493@amd.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[alien8.de,none];
	R_DKIM_ALLOW(-0.20)[alien8.de:s=alien8];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69879-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	DKIM_TRACE(0.00)[alien8.de:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bp@alien8.de,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BAC4ECF862
X-Rspamd-Action: no action

On Mon, Feb 02, 2026 at 10:09:19AM -0600, Tom Lendacky wrote:
> But I can see that getting stale because it isn't required to be updated
> for features that don't require an implementation in order for the guest
> to boot successfully. Whereas the SNP_FEATURES_IMPL_REQ is set with
> known values that require an implementation and all the reserved bits
> set. So it takes actual updating to get one of those features to work
> that are represented in that bitmap.

Ok, I guess we can rename that define SNP_FEATURES_IMPL to denote is the
counterpart of SNP_FEATURES_IMPL_REQ, so to speak.

@Kim, you can send a new version with the define renamed.

Due to it being too close to the merge window, it'll wait for after and then
it can go to stable later but I don't think that's a problem.

> That will tell us what the guest is running with, not what it can run with.

hm, ok, let's think about this more then. I don't have a clear use case for
a this-is-what-a-SNP-guest-can-run-with so let's deal with that later...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

