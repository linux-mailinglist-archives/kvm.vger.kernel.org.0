Return-Path: <kvm+bounces-51611-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68E5CAF9B48
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 21:46:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B1D69586CE7
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 19:46:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79F8021B9C5;
	Fri,  4 Jul 2025 19:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="otjJEI8r"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625FD6A8D2
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 19:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751658393; cv=none; b=ratn4ucJxfKXe5uMA77l2RgTHffzrBGn0lyQ3ewl6ukeIU7qoj2asXcRLMlp2qflft4OedCMwJD7Em/UfQgZap8KrmyqXJvTLtxS0g+Sm8zguNEqDYnOX4p+ACCx/qY6Kt68AVMEWk7R4R1mlQwpujEOV3sYADDUCf2gIRjBNf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751658393; c=relaxed/simple;
	bh=Cz5o5jdZk1UsVK7l+hF5hjL+kmroRZbpDpggHIKg10Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YAapnA78gOS8ME4ZaHxLv7EskjO/TVFvCNzSk0ore7LmvfLbd0yUe17uyzPDy0+goXnE6p9oilUsyNn6V5yV5NhIpiZdd4FVlJQf66wVoCrCITlhwRMKzP5p+AYz1eF5tsvybZEB9OREGxGkj5J0SzlEeoRURCojouXQxRheUZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=otjJEI8r; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 662A93F946
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 19:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1751658389;
	bh=VLrA3L+1opa6K3kyWseF7FHmwqIbcBLyJ0FYSjgmPjU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type;
	b=otjJEI8rNeCO1Q+zaB+U5fSLRvKrYkI5zq+uuTGSTToJYDTqasqya4UHJnuRuKvJL
	 qMYo4qVXcJ+KcNEl0G1XGADBPWRbGxJsgPJ1XTw1663Em9CU42IZgnP35XuBw8K9Zv
	 CqFbLn3oBuY9dfNLwucJIHSu0MALr/wTs4mrhX9kpAogBpfK5EQVYLkA85oeYcDxOf
	 5ikrRV5zZM2cPhMN9QGBVOnXSenRJAWGm/qZ6HLroROmX1PZ5LorX5jqzeqkW5nxiy
	 rQjLwvIyIbis/JiF6/ZPh/mdCG6wC6OTBGiTv1cWGAtl69e0MuqVoh75XpRcPwnuV/
	 qdzG5Ib91F4Nw==
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-ae0b629918eso141869166b.0
        for <kvm@vger.kernel.org>; Fri, 04 Jul 2025 12:46:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751658385; x=1752263185;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VLrA3L+1opa6K3kyWseF7FHmwqIbcBLyJ0FYSjgmPjU=;
        b=SH42sYc2ZxfrRgc/htLuxZooTeAtLCE95/8RS+e6M2IiH4vzQn63tKHco0i13CLXsN
         00kC3M86fyozePvUi3uYFXVg21MEw11DD0NMmWv7yGSX2TcQmmBR5e+NlOVnuVXDEPus
         rD/L29WZoa2fZvLk9cDgPGcxJda/i3P6DU7uszavBy912FKCAtgo7HWtFA9auDvF1mTa
         vTIyFZUTqfjRICgma6WdyJAUs4MdLfwglk2BI1XVhEovsIEpY/dSY5PkusulfwiQVFy3
         e3tG5b8Uhv9DzbfadpOO/zAwzhGlWyOpbhQr9MMLsAbL95jA+8/ZZJy92ZUluyZeLXOO
         c3Aw==
X-Forwarded-Encrypted: i=1; AJvYcCUtUXBUoQtFOMta937lIp49dkZHvFte19nfK0Ar0M7Zp9+Lncb1A3NEqlzbcxqouh/CZ1A=@vger.kernel.org
X-Gm-Message-State: AOJu0YzbA1ULF5Lf85u/xdu5c3z+SjaZ9rINCSsvlvZpbw/lYy8m3v4W
	k0I0K36WOyI1mbetHkM44fvBBsqsR1SL+WQGgpdKrnXDvycQheFmD6y739neJFnEfIEKeBxYgWn
	PFnKaSODRdAh2fQedny2d/Gh1jdqVChaehnELUSEwZ2Ep++/dxDJJUHDXpCR0rD+KUHn7iQ==
X-Gm-Gg: ASbGncsBrX4F7D2M/9EXKRNaGPN3QnA6N/mAiZm4UseuWz5laSMjIkd2O5DgCJ+SXyP
	oKkL3VGrUQWXCk41qwsOQH8YmMRHiefc8raCFr0TmMEMsVerY+0b3rDhjKH/0+96/1mKnweFAoY
	0rXDi5tJZEXCj319Y6ZeH3Vmi/Ie/HObyZ1qFcWbVdG6kzjy7NuGYlElqg23C0iYeQkFojM0M76
	sPiKPQcB5xU2jCqQJRqzmteNhl7EByn3QpNuR9dxGRKf6oqKByKAf4JVTnGL/RIbOLyg6E21OWp
	pLnHh/dJHzAdHNmCmIhrglQbwUpZkvn0qnqJdNz2TZUhJbKX2hT0f/JgBGapv/5uMGHUT6edt1W
	F9Lgyu9yARDk=
X-Received: by 2002:a17:906:f5a7:b0:ae1:f1e0:8730 with SMTP id a640c23a62f3a-ae3fe78fd44mr368751966b.57.1751658384969;
        Fri, 04 Jul 2025 12:46:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGbsxPqPhYYSbtLZBKO2k3ZdPJhfdbdyy0/f6vKPhOggzCylZPnmMjp2Q8zbaJhX5YMtK8lng==
X-Received: by 2002:a17:906:f5a7:b0:ae1:f1e0:8730 with SMTP id a640c23a62f3a-ae3fe78fd44mr368750466b.57.1751658384601;
        Fri, 04 Jul 2025 12:46:24 -0700 (PDT)
Received: from ?IPV6:2a02:3035:6e0:a37c:f324:1674:f46a:492? ([2a02:3035:6e0:a37c:f324:1674:f46a:492])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae3f6ac5643sm221184466b.74.2025.07.04.12.46.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jul 2025 12:46:23 -0700 (PDT)
Message-ID: <42c6f9d7-ac1a-4f74-8b0b-ac8fb02de0b0@canonical.com>
Date: Fri, 4 Jul 2025 21:46:22 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] RISC-V: KVM: Disable vstimecmp before exiting to
 user-space
To: Anup Patel <apatel@ventanamicro.com>, Atish Patra <atish.patra@linux.dev>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 Emil Renner Berthing <emil.renner.berthing@canonical.com>
References: <20250704153838.6575-1-apatel@ventanamicro.com>
 <20250704153838.6575-2-apatel@ventanamicro.com>
Content-Language: en-US
From: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
In-Reply-To: <20250704153838.6575-2-apatel@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04.07.25 17:38, Anup Patel wrote:
> If VS-timer expires when no VCPU running on a host CPU then WFI
> executed by such host CPU will be effective NOP resulting in no
> power savings. This is as-per RISC-V Privileged specificaiton
> which says: "WFI is also required to resume execution for locally
> enabled interrupts pending at any privilege level, regardless of
> the global interrupt enable at each privilege level."
> 
> To address the above issue, vstimecmp CSR must be set to -1UL over
> here when VCPU is scheduled-out or exits to user space.
> 
> Fixes: 8f5cb44b1bae ("RISC-V: KVM: Support sstc extension")
> Fixes: cea8896bd936 ("RISC-V: KVM: Fix kvm_riscv_vcpu_timer_pending() for Sstc")
> Reported-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
> Closes: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2112578
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>

Anup and Atish, thanks a lot for investigating.

I built upstream kernel 6.14.9 with the patches of this series and that 
resolved the problem reported in Launchpad bug report 2112578.

Tested-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>

> ---
>   arch/riscv/kvm/vcpu_timer.c | 16 ++++++++++++++++
>   1 file changed, 16 insertions(+)
> 
> diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
> index ff672fa71fcc..85a7262115e1 100644
> --- a/arch/riscv/kvm/vcpu_timer.c
> +++ b/arch/riscv/kvm/vcpu_timer.c
> @@ -345,8 +345,24 @@ void kvm_riscv_vcpu_timer_save(struct kvm_vcpu *vcpu)
>   	/*
>   	 * The vstimecmp CSRs are saved by kvm_riscv_vcpu_timer_sync()
>   	 * upon every VM exit so no need to save here.
> +	 *
> +	 * If VS-timer expires when no VCPU running on a host CPU then
> +	 * WFI executed by such host CPU will be effective NOP resulting
> +	 * in no power savings. This is because as-per RISC-V Privileged
> +	 * specificaiton: "WFI is also required to resume execution for
> +	 * locally enabled interrupts pending at any privilege level,
> +	 * regardless of the global interrupt enable at each privilege
> +	 * level."
> +	 *
> +	 * To address the above issue, vstimecmp CSR must be set to -1UL
> +	 * over here when VCPU is scheduled-out or exits to user space.
>   	 */
>   
> +	csr_write(CSR_VSTIMECMP, -1UL);
> +#if defined(CONFIG_32BIT)
> +	csr_write(CSR_VSTIMECMPH, -1UL);
> +#endif
> +
>   	/* timer should be enabled for the remaining operations */
>   	if (unlikely(!t->init_done))
>   		return;


