Return-Path: <kvm+bounces-71131-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8PIQNDpak2k73wEAu9opvQ
	(envelope-from <kvm+bounces-71131-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 18:56:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 799B1146D3C
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 18:56:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3F38B300A33F
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 17:56:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E5B631196A;
	Mon, 16 Feb 2026 17:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Juskkyu4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD19A2D5410;
	Mon, 16 Feb 2026 17:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771264566; cv=none; b=ub/vXanAiaZ9afwvia2afR+onYj8nmF35UPIIgJmLspBmVduljCH62g3Blf9wHqpockRERzu0JFAaW42qsyajLMMozijkfyncErRe6JeyrNyOZgYbgU0b/sI3WLvPqlj9+DEqVBnHslM5+nnPR/OmwFCKDYdqqFgVok/JdaBFO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771264566; c=relaxed/simple;
	bh=ERCGwbyY1bFkmKGwHWKrXtrTgLjADaBxpidUngYJSQw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BpIFmKPtsLFliQihjtgg3hNQzXaaS6WyMWU3dLphNUacpOxp3HH5w0l8zr0/ZTGeHuIZT0O680uCUttv8KQ3jtTJbsdtBYYCcNpaIf6rUHafhF6ku8x4yvxG8pgYbB/nQPM1cKuf1HmtgFnw5EMA4Ubr+hE7E8CUqpUH+mrlbXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Juskkyu4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5217FC116C6;
	Mon, 16 Feb 2026 17:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771264566;
	bh=ERCGwbyY1bFkmKGwHWKrXtrTgLjADaBxpidUngYJSQw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Juskkyu4PhMtJRRrALXCQX062tnKt975IgYSRtZJX6mPz9cwEb8yGVTgDKrOSaYnm
	 dI5oLYwoH+qOQJM8LukRHoSRGk6fz5j0Vd87XSZt+/QhL3JJ68RqhR1BBcx4sS/uBr
	 080Cgf/ved1qRwSv/m+ZyRURyjeO0l9FQ3oaWTmWTq2tis6g9cVePXO//6hHA8XHzw
	 aCCLTigZaq8AxfHKwrA+FxQXL1bbYkyUPgdr2cx3n3IMviy10ky+SxLCW6ebSzmfN7
	 gWLP83d/4C3y1eBHc3Pp6tWceCwxLJ0SlFS6v16tb8hSKwM3a3marUNP6hvDgWLJwC
	 0nqw01++FjbAA==
Date: Mon, 16 Feb 2026 17:55:59 +0000
From: Mark Brown <broonie@kernel.org>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
	Fuad Tabba <tabba@google.com>, Mark Rutland <mark.rutland@arm.com>,
	Ben Horgan <ben.horgan@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v9 10/30] KVM: arm64: Document the KVM ABI for SME
Message-ID: <831bae38-3d8c-4846-b23e-464d70e94a5b@sirena.org.uk>
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org>
 <20251223-kvm-arm64-sme-v9-10-8be3867cb883@kernel.org>
 <CAFEAcA-nhHdwuQODmT4-dBCEuiut-jbHsCGVYByoMF77-UWbCg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="u9ZyI9Npf85AkB75"
Content-Disposition: inline
In-Reply-To: <CAFEAcA-nhHdwuQODmT4-dBCEuiut-jbHsCGVYByoMF77-UWbCg@mail.gmail.com>
X-Cookie: Beware the one behind you.
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-4.26 / 15.00];
	SIGNED_PGP(-2.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MIME_GOOD(-0.20)[multipart/signed,text/plain];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+,1:+,2:~];
	TAGGED_FROM(0.00)[bounces-71131-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[21];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[broonie@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 799B1146D3C
X-Rspamd-Action: no action


--u9ZyI9Npf85AkB75
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 09, 2026 at 03:18:43PM +0000, Peter Maydell wrote:
> On Tue, 23 Dec 2025 at 01:22, Mark Brown <broonie@kernel.org> wrote:

> A late reply, but I just noticed that the cover letter says:

> > Userspace access to ZA and (if configured) ZT0 is always available, they
> > will be zeroed when the guest runs if disabled in SVCR and the value
> > read will be zero if the guest stops with them disabled. This mirrors
> > the behaviour of the architecture, enabling access causes ZA and ZT0 to
> > be zeroed, while allowing access to SVCR, ZA and ZT0 to be performed in
> > any order.

> but the doc patch itself says:

> > +Access to the ZA and ZT0 registers is only available if SVCR.ZA is set
> > +to 1.

> Which one is the intention here ?

I guess the second if we're going with the approach of making everything
depend on the state of SVCR, it's less pressing to do so than with
SVCR.SM but it'd be consistent.  I'll update, thanks for spotting this.

--u9ZyI9Npf85AkB75
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmTWi4ACgkQJNaLcl1U
h9Co1gf/coUE4P4tuYn1rKP9lPsMEHvcfhSgIjltgex97NMRomE8Pls4cxLzQ43P
WgNP+OmJtv1S3MECmR5aGn68bapqqQhEvHefBIAEiklWX96VRYvx8xkMzBq+9XYN
pTvbPUuNghFiABfakJcYwkdmIdfe2WehVPxHQt4rXCgZTv02aRzhtxxo2dh8k4PQ
NuoG0BpSFW9oDLllEm6je8EkUxjWiwnAoMSYIRouopHI3/LapX+crbLqJZiEEg5s
kHKTgA+w6Ysm3tzmLRsIMkv02cb3xXi81Q/C99R9VcVtiiBJ6dDRBUcPkvLDT7u1
ajwfzwv1+T6Kfp4y+Q9FFrSe9dmsLQ==
=7KFU
-----END PGP SIGNATURE-----

--u9ZyI9Npf85AkB75--

