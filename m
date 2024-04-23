Return-Path: <kvm+bounces-15664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FD768AE802
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 15:23:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C36A1C21F5F
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 13:23:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B49FA136E01;
	Tue, 23 Apr 2024 13:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="ZBHlAvAk"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D82C135A78;
	Tue, 23 Apr 2024 13:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713878592; cv=none; b=SDaSYZYM+KtMKbTpq0kAA1+F/plYKmTiuhDzZPhccIiEEatPlbUcr/1ea+9RHOcZDFxScPIzIoGQzz9N2lKYVjGSQ2VfkdxHQGlWqk802Kw9D/7GzjS5II4bCHUtBJr9rnM933Z6B5q6lORU9M/hOM+aWZ55DMjnk/qA3mW4u2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713878592; c=relaxed/simple;
	bh=MpB1vGpcm8vPdDQxwuDpXFCLiB9Rpr/rHRL0DsgP2jY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QXaTtTF5JA4X6obVmaV8Dv9Rx4rXfbZQTKYSC67TdNv/217fl0ZPxspnGkAW/mUsFbtd0lzNTWpH3laerv4QtaV3rLrTuzgqHw80mSblxMqfX06BX36n9kyFTiloZRpTZlFZ3j1/b2hWL3sV7MjAfqzCAZIixLBDUS2oArtKpPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=ZBHlAvAk; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id AE62440E0192;
	Tue, 23 Apr 2024 13:23:08 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id oWWHdYJ-hwo5; Tue, 23 Apr 2024 13:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1713878585; bh=/hW7sIjmt3vV+F8wtAYDHFfbBByCE0rEdpHRFcL6KBg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZBHlAvAk3/n1/l5FQAePQDZqz4DRvfyt2+Ikz3kv3NCRkRVFco4zetzFiHlang6re
	 dhNEu0xh5pxXB5I1lGLlv0Ji+z733bzTGFXrbMvAWbE0wb4qKklcNYVZN7muzgBk0B
	 b5Ho6T/x01nm80Ekei4un+kTNPKfp3BkExe/lzczqB3/uZ7pIGQudpQxEDinKARi/P
	 8LsesHMKHhzkXzSVMxRlpOd5NoFVrBft5G7fgFmvouLJOKOuBuLVC+dRrX+D9Rs9KL
	 M8rTZy37epXhiUcKlQXPlNU2R8PpSRRjV+mJ3Fc8OjjAL8XC8RyYXxh+sK6QWyYphn
	 8r4xV92ZtK7AguUpAoTn3vLysNv5PrRspz1z9KOEUvsbMdNegsJ3Rm5e+rgu7jGqQg
	 tqFacbucPpakAsXkaTcmmRBhI62x5Gr7SquK4NH4X9omGTYzyfXyht5uG6QhVcBNZn
	 cLD3NkSBJmUPQWMlwI73AwgD09Cz+3icRUKQB4xTEmp7T20OeXOxx3GgXNkbAT6qF/
	 W0vfYJphE/fYwYRpj9YDhuUv7NQDGPENPsLM+89EVvRxlYRS1RRkTfEZN+XDKnhHvd
	 idixrL5iNFwuXsWyijKOly15AvrFJuxQsBsG61W9ia4a0exdNe12/WqBZXwL4wvaI1
	 rxvOR9fG64aM2OVw+6ZBAFJY=
Received: from zn.tnic (pd953020b.dip0.t-ipconnect.de [217.83.2.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C70A840E00B2;
	Tue, 23 Apr 2024 13:22:53 +0000 (UTC)
Date: Tue, 23 Apr 2024 15:22:52 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v8 07/16] x86/sev: Move and reorganize sev guest request
 api
Message-ID: <20240423132252.GJZie2LGgVszU_XejZ@fat_crate.local>
References: <20240215113128.275608-1-nikunj@amd.com>
 <20240215113128.275608-8-nikunj@amd.com>
 <20240422131459.GAZiZi0wUtpx2r0M6-@fat_crate.local>
 <eadcab6f-b533-49e3-9aec-dc06036327f5@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <eadcab6f-b533-49e3-9aec-dc06036327f5@amd.com>

On Tue, Apr 23, 2024 at 09:56:38AM +0530, Nikunj A. Dadhania wrote:
> Yes, I had tried that compilation/guest boot does not break at this
> stage.  That was the reason for intermixing movement and code change.
>
> Let me give a second stab at this and I will try just to make sure
> compilation does not break.

Yes, you can also do preparatory changes which get removed later, if
that helps.

It is perfectly fine to have a couple more patches preparing and doing
the move which are trivial to review and verify vs one combo patch which
makes you stare at it a long time and you're still not sure it doesn't
change something...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

