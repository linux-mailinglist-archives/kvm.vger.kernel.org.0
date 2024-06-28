Return-Path: <kvm+bounces-20696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DD2491C8DB
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 00:01:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F4FB1C23A2F
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 22:01:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9092132113;
	Fri, 28 Jun 2024 21:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="U/XwCeuB"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F4F12F5B6
	for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 21:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719611881; cv=none; b=dprLxCg8cz/+02NQ5/UjsyP95pYufw/LpJSZeyywOS465mikWokgWtxTVIHPp7jjUdARAiYbGvEHn4Fm4ZC/TehcEYshojsQ/jPTEG7vsq6FXZ7UlsH75HUTD06+6gp/QSGXB/IZsHGZ+n6xMDcnGo8PPebTXiC6vIz/k5VOBRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719611881; c=relaxed/simple;
	bh=zimJaIrAIqUoSxZ+VOwjIwOnQiR/wAf0mSWgqUbw/68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jP/BYJ/lfeyBJYXhM4i1/2CzirUUrE19Uf9wwmsKu8K2CPH4uRR9Ff4PWOQ4FcFZTdlBK+ByGRf/kqn6bbwyCjmbjfQLIJ98GGjzC80T/n4DNl0itUmGhwArtL9PIf3a0m/B+1/WvblAm38Dc0vkGBeMn3I5PmEUiezNiSZ/asA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=U/XwCeuB; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: changyuanl@google.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1719611876;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=71r73t8BLcU2HpTB1C169uYhfS6uPxsziyAI3xTubZc=;
	b=U/XwCeuBXe3g6Qcskm0fmzxVddeSpYtGvnWoFq2CuJVyPxPbbF7vtMw68HcJiybIad3W3M
	Z3A4tFA5S9yNh6ShcFnUik/1ViNnLsMTaY/G5Bo81jXJUaDhP7SSs8oXaFiEKJzP201Tf9
	g2ZoYOe46aQzi+ye73uO6BE8QbVJG8E=
X-Envelope-To: corbet@lwn.net
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: linux-doc@vger.kernel.org
Date: Fri, 28 Jun 2024 21:57:52 +0000
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Changyuan Lyu <changyuanl@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/3] Documentation: Fix typo `BFD`
Message-ID: <Zn8x4Fxr6JFq37Nw@linux.dev>
References: <20240623164542.2999626-1-changyuanl@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240623164542.2999626-1-changyuanl@google.com>
X-Migadu-Flow: FLOW_OUT

Hi Changyuan,

Thanks for the fixes. LGTM, but next time you have a multi-patch series
please include a cover letter. Helps with organizing the patch series
on the receiving end :)

On Sun, Jun 23, 2024 at 09:45:39AM -0700, Changyuan Lyu wrote:
> BDF is the acronym for Bus, Device, Function.
> 
> Signed-off-by: Changyuan Lyu <changyuanl@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index a71d91978d9ef..e623f072e9aca 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -1921,7 +1921,7 @@ flags:
>  
>  If KVM_MSI_VALID_DEVID is set, devid contains a unique device identifier
>  for the device that wrote the MSI message.  For PCI, this is usually a
> -BFD identifier in the lower 16 bits.
> +BDF identifier in the lower 16 bits.
>  
>  On x86, address_hi is ignored unless the KVM_X2APIC_API_USE_32BIT_IDS
>  feature of KVM_CAP_X2APIC_API capability is enabled.  If it is enabled,
> @@ -2986,7 +2986,7 @@ flags:
>  
>  If KVM_MSI_VALID_DEVID is set, devid contains a unique device identifier
>  for the device that wrote the MSI message.  For PCI, this is usually a
> -BFD identifier in the lower 16 bits.
> +BDF identifier in the lower 16 bits.
>  
>  On x86, address_hi is ignored unless the KVM_X2APIC_API_USE_32BIT_IDS
>  feature of KVM_CAP_X2APIC_API capability is enabled.  If it is enabled,
> -- 
> 2.45.2.741.gdbec12cfda-goog
> 

-- 
Thanks,
Oliver

