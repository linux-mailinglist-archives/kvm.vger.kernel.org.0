Return-Path: <kvm+bounces-34840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DDFC4A0658A
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 20:45:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8532F18892B1
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 19:45:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61740201262;
	Wed,  8 Jan 2025 19:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="IPDldci8"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDC722611;
	Wed,  8 Jan 2025 19:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736365544; cv=none; b=cOOIng/jLs1PCUxJFVdoGiCojkrLXzfdBCled5iO0gTlCV7kVc1TbbZLCzhRViRIK8/Si5BkcU4n7Eb7rZurUxxnBi1Mjk+e0t5um/76MUJU3z58/zG8ynqnnceSdHKqPHJla/VCgC/BRFly7E4DAqrcMd3GAhw5SzN+iiTcZmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736365544; c=relaxed/simple;
	bh=ESNIhBVidArw1PzHx6nFQNXSzGZ8ukWaPMDbnFED78U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=crGOW3JJpTOw1TFEIlyphHJ/6sDqN9A5Llr1fEudFuV2tUDAzcQ9TcLcXzs/HtHAOz3P1Nk+j84RVq6zF0F3z9HTAYzxo493ScDPSCKksZZgLNWs66oQUZ8LwRS+6XgGwWuQAbV5faVgcRCtTlDFH9zHEjseLahPiAfZYwYweMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=IPDldci8; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 073C640E0289;
	Wed,  8 Jan 2025 19:45:40 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 7-Febcck8mql; Wed,  8 Jan 2025 19:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1736365535; bh=x610/Zndo4IGnCTdF90flcGR1Vy2KvG9JPGuM4xgiXg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IPDldci8dIqF0HYhoyvz6nR1FRz/rWBfNYMNGr/Gl0nlQkGqmcvIf9XQrj4A+tkYC
	 vkDj2WjbdHyLCQbf3weOZDAqJAWd4hu75dPYVopmN6BsfmStlfBhsdR7nHhqQBWdFD
	 L31sMhOtQweEFctcY2kEBkmYKuaUupOsiMRCmG2XND0kVJPXiHrkk3YAUgWlwyD4wp
	 hzYcasM+E4rOG0EPKTJbBPLbbkOf79wFwrWS8TxYnDKuSlGs9WCZx+2H3koe4WihzI
	 uza6ZhA3daCrRbNrpcWghut4ggmCn/FsEQJjGl+yTJl6ULKGX3+zML6DD2UyUFRPLU
	 TRUjV+qCxMAsmQBlSGfrS+cP/+1XnIvCVQD0pnRZf1tMi65FPACdfA6WCyn4Xz5yb6
	 EgiockRI9S2LC3W5a7/js6Yg+WXbLg1pnv6BUxJKDTxAFgQGkSbm1zvToMx7plY47R
	 tuut/ryS4224LJEkyrBMPPxsOqU3226wq9c1I5yVXjfCBOcq10oa3b3Rpd42WZibeG
	 swBfI7sJtLNGFE7Tqhl9JXRFInGiS+qYX9nCtCNtnLF+PCRy70/S+CFoDoeB5xypF2
	 i6jppCjN5qGRw5/gzBZGmDyjMUWFxR9PkSCMasTzSX8fDgC/qJXeEYeJja7KdDz/h0
	 QiQrmVjVOWs8Iktb6uz9OQqQ=
Received: from zn.tnic (p200300eA971f938F329C23FffEa6A903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:938f:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7605E40E01F9;
	Wed,  8 Jan 2025 19:45:26 +0000 (UTC)
Date: Wed, 8 Jan 2025 20:45:20 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Borislav Petkov <bp@kernel.org>, X86 ML <x86@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	KVM <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] x86/bugs: KVM: Add support for SRSO_MSR_FIX
Message-ID: <20250108194520.GIZ37V0OVGLtRAWSF_@fat_crate.local>
References: <20241216173142.GDZ2Bj_uPBG3TTPYd_@fat_crate.local>
 <Z2B2oZ0VEtguyeDX@google.com>
 <20241230111456.GBZ3KAsLTrVs77UmxL@fat_crate.local>
 <Z35_34GTLUHJTfVQ@google.com>
 <20250108154901.GFZ36ebXAZMFZJ7D8t@fat_crate.local>
 <Z36zWVBOiBF4g-mW@google.com>
 <20250108181434.GGZ37AiioQkcYbqugO@fat_crate.local>
 <CALMp9eTwao7qWsmVTDgqW_KdjMKeRBYp1JpfN2Xyj+qVyLwHbA@mail.gmail.com>
 <20250108191447.GHZ37Op2mdA5Zu6aKM@fat_crate.local>
 <CALMp9eS1H3pYOmQSE9qPFF2Pk2uvN_hUde=+5sZikBGjAjb+aw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALMp9eS1H3pYOmQSE9qPFF2Pk2uvN_hUde=+5sZikBGjAjb+aw@mail.gmail.com>

On Wed, Jan 08, 2025 at 11:43:14AM -0800, Jim Mattson wrote:
> > We don't need safe-RET with SRSO_USER_KERNEL_NO=1. And there's no safe-RET for
> > virt only. So IBPB-on-VMEXIT is the next best thing. The good thing is, those
> > machines have BpSpecReduce too so you won't be doing IBPB-on-VMEXIT either but
> > what we're talking about here - BpSpecReduce.
> 
> I'm suggesting that IBPB-on-VMexit is probably the *worst* thing.

I know what you're suggesting and I don't think so but I'd need to look at the
numbers.

> If it weren't for BpSpecReduce, I would want safe-RET for virt only.

Read my reply again.

> (Well, if it weren't for ASI, I would want that, anyway.)

I'm sure Brendan is waiting for reviews there.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

