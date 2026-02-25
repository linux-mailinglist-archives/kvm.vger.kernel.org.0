Return-Path: <kvm+bounces-71864-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oNkZErk6n2kSZgQAu9opvQ
	(envelope-from <kvm+bounces-71864-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 19:08:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A724219C0A5
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 19:08:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E8A53315D9C5
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 18:06:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 485BA2EC081;
	Wed, 25 Feb 2026 18:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lV5K2XPX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DF82E3397;
	Wed, 25 Feb 2026 18:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772042761; cv=none; b=o65WNUlhG6Tb7FxKGY0U9ulLdyGiWDThVu2TfjbboZLtvf/A5sRdTnOUfjI12Zd27dAv5qzmU/ldUqcHHut45MpU8TYcw21VXvIchRkpauImE3XCneWXd47fqw6wflXDtkD86Ho8zeHpENKW4uNzQPrHYM13BCncefeBTlmcous=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772042761; c=relaxed/simple;
	bh=YB6d0VUqMffIUrv91jAOHnTGBUBEMBtpj9+Ww1jhiJc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y3DKXVG6mTayoHCJd59lfU7mTuAQrmYMQR3DhAJjFDtWBd2CkuGXIU/5WK1jvULg9YVevSYV8IDD49vZ2xjn5xfNnS1S7cQfurRhUSdOW1tgfUS31zYxmzUKqa8JdxClP75BR+jGg+eqQpSfJpFXSbuw7Ie80Bts22zJd75UOA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lV5K2XPX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95425C116D0;
	Wed, 25 Feb 2026 18:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772042761;
	bh=YB6d0VUqMffIUrv91jAOHnTGBUBEMBtpj9+Ww1jhiJc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lV5K2XPXMHCr52eBxVhUjKUYmk825lbHp6fxibfqCvS5SE2fZ1V7NJZGialt9+fwi
	 /Voqv5LNKkoXdV26NRujTM2PEXWcYS8aTig8epWkjnPdHXrT+KtJkeh/a48XSUcYk7
	 D3TBY8UPKvLH/taMKTEGWEJlPVOJQiaLl45nzIe4d4vD2i/1mx+CEQ3K1fQGfUQBH+
	 MCYRbxHpXBdSiI7/u6ZVthdCUumzFVDgck3MhVz6cVL2SwWr4cmUHrPA3Xj828MG3R
	 DLJoqY0B4movPtbIGTqEyRMO8YFe8HJ3VCzKJ2CVxqvNUVZXi1DS7DtIaYNzLr9jVv
	 Xo03vDAoozRTQ==
Date: Wed, 25 Feb 2026 11:05:57 -0700
From: Tycho Andersen <tycho@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 3/4] crypto/ccp: support setting RAPL_DIS in SNP_INIT_EX
Message-ID: <aZ86BZWi-GLiHvmt@tycho.pizza>
References: <20260223162900.772669-1-tycho@kernel.org>
 <20260223162900.772669-4-tycho@kernel.org>
 <aZyC89v9JAVEPeLt@google.com>
 <aZzRVXp_E3cMcgtX@tycho.pizza>
 <aZ3k01UObX03Sv-n@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ3k01UObX03Sv-n@google.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71864-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	DKIM_TRACE(0.00)[kernel.org:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tycho@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tycho.pizza:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A724219C0A5
X-Rspamd-Action: no action

On Tue, Feb 24, 2026 at 09:50:11AM -0800, Sean Christopherson wrote:
> On Mon, Feb 23, 2026, Tycho Andersen wrote:
> > On Mon, Feb 23, 2026 at 08:40:19AM -0800, Sean Christopherson wrote:
> > > On Mon, Feb 23, 2026, Tycho Andersen wrote:
> > > > From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> > > > 
> > > > The kernel allows setting the RAPL_DIS policy bit, but had no way to set
> > > 
> > > Please actually say what RAPL_DIS is and does, and explain why this is the
> > > correct approach.  I genuinely have no idea what the impact of this patch is,
> > > (beyond disabling something, obviously).
> > 
> > Sure, the easiest thing is probably to quote the firmware PDF:
> > 
> >     Some processors support the Running Average Power Limit (RAPL)
> >     feature which provides information about power utilization of
> >     software. RAPL can be disabled using the RAPL_DIS flag in
> >     SNP_INIT_EX to disable RAPL while SNP firmware is in the INIT
> >     state. Guests may require that RAPL is disabled by using the
> >     POLICY.RAPL_DIS guest policy flag.
> 
> Ah, I assume this about disabling RAPL to mitigate a potential side channel?  If
> so, please call that out in the changelog.
> 
> And does this disable RAPL for _everything_?  Or does it just disable RAPL for
> SNP VMs?  If it's the former, then burying this in drivers/crypto/ccp/sev-dev.c
> feels wrong.

Presumably you're right on both counts, but I've asked our firmware
team to clarify exactly what happens.

I guess that means it should be kvm-amd.rapl_disable?

Thanks,

Tycho

