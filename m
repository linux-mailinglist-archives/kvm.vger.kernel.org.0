Return-Path: <kvm+bounces-54959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35BE9B2BB49
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 10:00:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CAC543AE76A
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 08:00:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 212D83112BF;
	Tue, 19 Aug 2025 08:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="kFpOfBYp"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308FE30F818;
	Tue, 19 Aug 2025 08:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755590405; cv=none; b=ZkO522eSKK1QfiH9cbkpLucl99a7xk/FSmXGb807rgHWhBKSz/bFG8EnolVQqJN16LXSPyS6kYZnhh+TXYmw/Inn5W6bVWzCojYaUDmXpgGkZ4losXESdkHrReYDFJZT1U2m6PJ0tNiDddFYoO4LGxP+W/nB5rl7okODWl81pzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755590405; c=relaxed/simple;
	bh=wfpbrorY23l3/fQ6h0rPo3D2UzogLe/Q8BwP914Hi5s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r55QSmevqRjp3yZ2jA5C/gy/E0sWb4Bx9hAYf+zxwv3nMN2CzRcIzfFKrYyGgUvhpJJsV7wJoVFYbBE4hb5ayhkm/JPB/+C9CZHUlH7Hv8fDjY6BvY/Nq+Pxg/Ti8FK5fjYgbX2XeLQk+EuT9pdvBsKRqutSm/GFpRuym2p1Z08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=kFpOfBYp; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 12EF340E0176;
	Tue, 19 Aug 2025 07:59:58 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id lIfyCsu2oAOh; Tue, 19 Aug 2025 07:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1755590393; bh=fPv298C70ys2MQghFIdYDN0L2uGa15B8zIq8FzRAKp4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kFpOfBYp9X4UZr76YQvwI7iGazNLlUy0YxdNelqbjA60U1fJmKAnrDxyo9+T0yRMd
	 h4yEc8kwy+n8M7Jt99/6WxzOAa+dXPVOI1cK0mCAF9t8BK8nIeLnZToSSbVfP1Vnep
	 vWrOzb79AXB1eT61W3dkramcYu6NqEAAQqtytJopBN0LIneIByDfCpUg1j4QXkiFgn
	 Y63wHWxZMLRZDR7PberJ4R6YYpRUUZOq61Sxu2eebBwA3ER83z94/2G6BN8gEVAnkW
	 CuizGc/ARgVBveTLB939xKJpq5bheeoT1aUQn7zGhq2lh3AjcNVMA5324SUTfbie+5
	 Ct4bXTRgVdIseYRpOEuLimFLg79vPvdy8WslMlVsE0Gtm9ZEVs6sy2IKFNEDgxy24f
	 44SL+NbrGXK+W6iK5PsK+Ypi55IZCkkRV0ypSskkGBr/yu4+vEAr4PNRBhp5rNYEZw
	 mrQQRMFW33ooIuU5kSirjf1+gzWHH3S9Gjn5UvT1Qdb7nNkMi71Kbfc9O3HYKXO9eP
	 hJ3xF3Rohjqx9CAD0lOsuviiXyD0EcJefyL2sUHjF+U7GCK1cTynv424LQVN56YWYN
	 8c0E+NA2rcli0lgjCl9SPOiGm25R5gqCquI3Aqei2lEaw73ZgAWdDLkhN8Y/weWBmp
	 fHsFWcvoempRs7lc3/wBYtjI=
Received: from zn.tnic (pd953092e.dip0.t-ipconnect.de [217.83.9.46])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 55C1C40E0194;
	Tue, 19 Aug 2025 07:59:26 +0000 (UTC)
Date: Tue, 19 Aug 2025 09:59:19 +0200
From: Borislav Petkov <bp@alien8.de>
To: Kim Phillips <kim.phillips@amd.com>
Cc: "Kalra, Ashish" <ashish.kalra@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, Neeraj.Upadhyay@amd.com,
	aik@amd.com, akpm@linux-foundation.org, ardb@kernel.org,
	arnd@arndb.de, corbet@lwn.net, dave.hansen@linux.intel.com,
	davem@davemloft.net, hpa@zytor.com, john.allen@amd.com,
	kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	michael.roth@amd.com, mingo@redhat.com, nikunj@amd.com,
	paulmck@kernel.org, pbonzini@redhat.com, rostedt@goodmis.org,
	seanjc@google.com, tglx@linutronix.de, thomas.lendacky@amd.com,
	x86@kernel.org
Subject: Re: [PATCH v7 0/7] Add SEV-SNP CipherTextHiding feature support
Message-ID: <20250819075919.GAaKQu135vlUGjqe80@fat_crate.local>
References: <cover.1752869333.git.ashish.kalra@amd.com>
 <20250811203025.25121-1-Ashish.Kalra@amd.com>
 <aKBDyHxaaUYnzwBz@gondor.apana.org.au>
 <f2fc55bb-3fc4-4c45-8f0a-4995e8bf5890@amd.com>
 <51f0c677-1f9f-4059-9166-82fb2ed0ecbb@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51f0c677-1f9f-4059-9166-82fb2ed0ecbb@amd.com>

On Mon, Aug 18, 2025 at 02:38:38PM -0500, Kim Phillips wrote:
> I have pending comments on patch 7:

If you're so hell-bent on doing your improvements on-top or aside of them, you
take his patch, add your stuff ontop or rewrite it, test it and then you send
it out and say why yours is better.

Then the maintainer decides.

There's no need to debate ad absurdum - you simply offer your idea and the
maintainer decides which one is better. As it has always been done.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

