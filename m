Return-Path: <kvm+bounces-30445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D08519BACDC
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 07:52:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0DCD71C20F36
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 06:52:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2248A18E04E;
	Mon,  4 Nov 2024 06:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="ezbALbJV"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E3218E04C
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 06:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730703133; cv=none; b=Sw4mslnJFNrIjaqk7RtlT1vwUNdQutCSxBINrkFE86e6ks/F7a/Yglr3Zl1s5m7/k5CUO86bUPpDMqE9IsZ9Z5YiEXlw8+E4VMEdORynkpRN4TYU3ITK74jU4NcUCz6N4y2yf1wsR6kkEnMYT+6UOOJ18lWeMsRagB+OFQSBTwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730703133; c=relaxed/simple;
	bh=kiv/XMDEoCHEhQr6YyvTbfvRLq4fdjJ9wLXODaw4jeA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YPtUA7QbHX+kpXNjmSQDXA16EcTd0B7ykE0QiGkGZ8M8MPhjuAZGGK2Pu1QnLTHupsAbZLopNRjPc7h7RKZOJpiQeQ1pVraxlv7QBJds9yR5l8ujHLSTQRv6+XtIhDnX6UyyKIpE0+SbRMb9W/uomXsmJrlZAP0VtWlKTjy1Evk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=ezbALbJV; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 93DC640E0263;
	Mon,  4 Nov 2024 06:52:08 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id jJZvCiCKsGd6; Mon,  4 Nov 2024 06:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1730703123; bh=yydbaFFm4dOuzObK6xHrob0aSN4LlaZeLQVKWu2JJ/A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ezbALbJVFCF8lhHcOchxjx9YSBvOwrs9UlkcguiRvxCJ0+m9OSmpwVUZwqiD2DGFa
	 veJmTQVf9GfNZMWz832oUuPN0TKRBwdc1cL+SEbVOygQRyBHvlHEgfx+nvAyUTjVTm
	 IexMQAFMeeKypVHamHOvyypojcchKnQY0tEPU4B1ifl3j39DDJBc8jDGfym0P07E3I
	 JoEC0c9wh75dQ9PCMHu9kR5tqjRTKirqtfqBrpoFc5fXMRGgd0veParI/yUZ01Ehh9
	 lzYpnoqh9l++sugJqbTXIn8O873NFHut4IOyKF7EAAVyid5gkjVf3FvzT9AVVSSXTv
	 fAv+38mQOsZqoDiXsX17kDNcqV2ULNpRMk5EPph6ymHmloRp6fm1AQZUhJS8chq/n2
	 zQHCmAk7nlV4MNZpUcc31v+s+MziKC1Ic8Bj030QAMdds1CSYRZQd+SokLfrbsB2nY
	 Kl+QzAXiIBGkJbsLWDEeRF2KdlyQGzKlWh8zPz0nHFfVFXtuBcUhHAyalCX+dKwCbN
	 2CrECKeQs8MHJ3HYnuVJ2b8EuOV/krOrVbuw1eE0p16MMCjPNsXcpR/nGEByrdeVeV
	 6m3NLVghuJCegZLHaqlaXYRS2rHC7hTltfKqQIl6doM/22Sn7K3bp/cNzNwovD4O5C
	 SpCZmlG5S86LhMzuL6Bhif1o=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 49A1640E0261;
	Mon,  4 Nov 2024 06:51:53 +0000 (UTC)
Date: Mon, 4 Nov 2024 07:51:47 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tao Su <tao1.su@linux.intel.com>
Cc: kvm@vger.kernel.org, x86@kernel.org, seanjc@google.com,
	pbonzini@redhat.com, dave.hansen@linux.intel.com,
	chao.gao@intel.com, xiaoyao.li@intel.com, jiaan.lu@intel.com,
	xuelian.guo@intel.com
Subject: Re: [PATCH 0/4] Advertise CPUID for new instructions in Clearwater
 Forest
Message-ID: <20241104065147.GAZyhvAyYCD0GdSMD5@fat_crate.local>
References: <20241104063559.727228-1-tao1.su@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241104063559.727228-1-tao1.su@linux.intel.com>

On Mon, Nov 04, 2024 at 02:35:55PM +0800, Tao Su wrote:
> Latest Intel platform Clearwater Forest has introduced new instructions
> for SHA512, SM3, SM4 and AVX-VNNI-INT16.
> 
> This patch set is for advertising these CPUIDs to userspace so that guests
> can query them directly. Since these new instructions can't be intercepted
> and only use xmm, ymm registers, host doesn't require to do additional
> enabling for guest.
> 
> These new instructions are already updated into SDM [1].
> 
> ---
> [1] https://cdrdv2.intel.com/v1/dl/getContent/671200

I'm willing to bet some money that this URL will become invalid in a while.

> Tao Su (4):
>   x86: KVM: Advertise SHA512 CPUID to userspace
>   x86: KVM: Advertise SM3 CPUID to userspace
>   x86: KVM: Advertise SM4 CPUID to userspace
>   KVM: x86: Advertise AVX-VNNI-INT16 CPUID to userspace

Why aren't those a single patch instead of 4 very similar ones?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

