Return-Path: <kvm+bounces-1222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78E917E5BD9
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 17:59:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7E71EB20FD7
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 16:59:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C58B30349;
	Wed,  8 Nov 2023 16:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XPWK41NJ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5A51944D
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 16:59:43 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64BA01FFA
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 08:59:43 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d9caf486775so8232073276.2
        for <kvm@vger.kernel.org>; Wed, 08 Nov 2023 08:59:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699462782; x=1700067582; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XpEPwj1+3M0yPZeVquG+vKJ0idoDjxiUbhXJ8UOhbv8=;
        b=XPWK41NJ9TP55vaeDEW2CT2aoqip51D1Wxgzh9niv3qPYTbggkIAnTWPUA/ipAbpCI
         zQ/H0ERgHA1Ag6evaNHjKRoaY5K41wFKS4ZtftcNRKilR9Lm7N7vatAljEFFZAktKRvY
         Y0FGXdypJCyqfYL6FiUBPNb5whllsbXRiRpbnnzodj8KCuppIJZCobxXf4e8oeBHEKk9
         ZJP4yv6ZT+roRS0V8e6X8zMqRMBbMu5KRWdeLUlAFxFz0rIR5fxFd8PelzUQtHChoHDp
         MjFzulTvHZlRdC1qows4uqHyNzT1pV8sCGc4bgFAJ8CKTmqoaNXuapgJvOuvW3iDipoX
         n1pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699462782; x=1700067582;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XpEPwj1+3M0yPZeVquG+vKJ0idoDjxiUbhXJ8UOhbv8=;
        b=YEz5FlyPwp3awH8P52jVAcxCibbyo3RdY4zxkZJL1Wh/+Vyfq2E/OCZS3SOfFND4NR
         YDCcJRsYrARw0+RmEFk6fFvlt1rYUe9eL5mP+gk9abiHpyi6yb+Eo783sC4IHKM0Oi3N
         xR7HuWPBFuj/Pcj/ly68RuPoc7RNKvG7NxkyYUBBznrAb0vvCqRATUc4dcoRz4lbW8d0
         cZC71lQewfqu4CQKKtcW/i0ZnCmLHkbiEQbm2zQ4/SGU6uxgYsVmwy2L/CULNCMhhdZC
         FWhG4XTBuOiPcMd8dBF3fQYodqo0jyVLLu4jyK/h7wl4aTK5EZldmb9YOq+Lt/Fwx8BC
         ZYzg==
X-Gm-Message-State: AOJu0YwX2xCsu4Xs2TV7fbTz6ttIZiD6iybX3ediHQlt1PWOOp79pIjx
	IZD6GT0cCoDEVRT7aT9ppmV/Ts+rHm4=
X-Google-Smtp-Source: AGHT+IFJxSqbqH04V4CdJrSt2ML48nciNEkXKyUcY0n7jXVYIpLnHLDjSshRNYH2nl7Ej/GNN7RSKDGvir0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d384:0:b0:d9a:c27e:5f37 with SMTP id
 e126-20020a25d384000000b00d9ac27e5f37mr43658ybf.3.1699462782601; Wed, 08 Nov
 2023 08:59:42 -0800 (PST)
Date: Wed, 8 Nov 2023 08:59:41 -0800
In-Reply-To: <20231108111806.92604-19-nsaenz@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231108111806.92604-1-nsaenz@amazon.com> <20231108111806.92604-19-nsaenz@amazon.com>
Message-ID: <ZUu-fZl3ZK2Vy8M8@google.com>
Subject: Re: [RFC 18/33] KVM: x86: Decouple kvm_get_memory_attributes() from
 struct kvm's mem_attr_array
From: Sean Christopherson <seanjc@google.com>
To: Nicolas Saenz Julienne <nsaenz@amazon.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, pbonzini@redhat.com, vkuznets@redhat.com, 
	anelkz@amazon.com, graf@amazon.com, dwmw@amazon.co.uk, jgowans@amazon.com, 
	corbert@lwn.net, kys@microsoft.com, haiyangz@microsoft.com, 
	decui@microsoft.com, x86@kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 08, 2023, Nicolas Saenz Julienne wrote:
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 631fd532c97a..4242588e3dfb 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2385,9 +2385,10 @@ static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
>  }
>  
>  #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> -static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
> +static inline unsigned long
> +kvm_get_memory_attributes(struct xarray *mem_attr_array, gfn_t gfn)

Do not wrap before the function name.  Linus has a nice explanation/rant on this[*].

[*] https://lore.kernel.org/all/CAHk-=wjoLAYG446ZNHfg=GhjSY6nFmuB_wA8fYd5iLBNXjo9Bw@mail.gmail.com

