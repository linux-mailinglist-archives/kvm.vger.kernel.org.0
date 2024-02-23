Return-Path: <kvm+bounces-9569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 85398861C24
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 19:50:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 940BF1C21348
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 18:50:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4DAC143C59;
	Fri, 23 Feb 2024 18:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="Ege2p+oD"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB0C46B8;
	Fri, 23 Feb 2024 18:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708714239; cv=none; b=kmX6SIDjcqUApJ4Kz0jx/wqUq7GfI8Mgva4zBsFQSirlW3B47c3qwPGremh8RaC00k5Rbn7gXwWBff+/9Zz88dbraF1FCBW0annYi5HIQ6udS7jpCzeZolQS97GxcHjAOkyJHRwe406eXIcqyoDzSsKYqqlPhrYGlO1fkFnvRG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708714239; c=relaxed/simple;
	bh=CbS81EADETkEOw8skLpfg0hsWieEW0zTscrTCNG9WHw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mTrG8RM5EnsCouH2c7DAyRUlDWPt1Oxruu1g2aUeANcJxZFpVnytS5OwcUhK9K57pS0b7d40AuqMEYJrwtvniDpQnkRPaZIWtWauoWwBXUZHGaW4KpLpVVr90Vc2hTyy+f3erXdEzIrhTN31+dBQl4JTntzQW96BCyFQ+8IT0o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=Ege2p+oD; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.187] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.17.2/8.17.1) with ESMTPSA id 41NInxGj709628
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Fri, 23 Feb 2024 10:50:00 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 41NInxGj709628
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024021201; t=1708714200;
	bh=+mX04zt36tgBBWaFAzsLEsVevv9fney8bDWskZu8MLA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ege2p+oDbHy2Dx3O1Uk2+HkADp1VMRRc3HJJVzfKbA9onapwSSLN5f58W47SmQf14
	 0nK3Bbd0PPdFsvtbbHf6HHIvyaypZsvmXc1dxQ4Z6bc+YMx186R3Hh6h7pIJ9FCiSy
	 SuYQeH4COWYOhg3H9io2DKwNrw6CHZKQyfFJ9Ane8kOMK81TFALulNULugfyPm3jJk
	 aj7LwbVnoMBExAUfmuB+muIqb0iH4Vak/2n9xk+lGlLg/sn0m3huUy55B5rlDrm727
	 /nMyF/3lOMg6STmeGrwf8jDlTFo69nsvpG0DaGaS2ODvaAW26MWYOJVIOJ4RPdnW2V
	 WFpHvwz8I26bA==
Message-ID: <f3c5ce55-a227-4d24-b565-c1255ea44b65@zytor.com>
Date: Fri, 23 Feb 2024 10:49:57 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86: irq: unconditionally define KVM interrupt vectors
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: x86@kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20240223102229.627664-1-pbonzini@redhat.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <20240223102229.627664-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/23/2024 2:22 AM, Paolo Bonzini wrote:
> Unlike arch/x86/kernel/idt.c, FRED support chose to remove the #ifdefs
> from the .c files and concentrate them in the headers, where unused
> handlers are #define'd to NULL.
> 
> However, the constants for KVM's 3 posted interrupt vectors are still
> defined conditionally in irq_vectors.h.  In the tree that FRED support was
> developed on, this is innocuous because CONFIG_HAVE_KVM was effectively
> always set.  With the cleanups that recently went into the KVM tree to
> remove CONFIG_HAVE_KVM, the conditional became IS_ENABLED(CONFIG_KVM).
> This causes a linux-next compilation failure in FRED code, when
> CONFIG_KVM=n.
> 
> In preparation for the merging of FRED in Linux 6.9, define the interrupt
> vector numbers unconditionally.
> 
> Cc: x86@kernel.org
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Suggested-by: Xin Li (Intel) <xin@zytor.com>
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/include/asm/irq_vectors.h | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
> index 3f73ac3ed3a0..d18bfb238f66 100644
> --- a/arch/x86/include/asm/irq_vectors.h
> +++ b/arch/x86/include/asm/irq_vectors.h
> @@ -84,11 +84,9 @@
>   #define HYPERVISOR_CALLBACK_VECTOR	0xf3
>   
>   /* Vector for KVM to deliver posted interrupt IPI */
> -#if IS_ENABLED(CONFIG_KVM)
>   #define POSTED_INTR_VECTOR		0xf2
>   #define POSTED_INTR_WAKEUP_VECTOR	0xf1
>   #define POSTED_INTR_NESTED_VECTOR	0xf0
> -#endif
>   
>   #define MANAGED_IRQ_SHUTDOWN_VECTOR	0xef
>   

Thank you very much!
     Xin


