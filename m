Return-Path: <kvm+bounces-228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AA22C7DD57E
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 18:52:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DADF41C20CD5
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 17:52:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B900210EE;
	Tue, 31 Oct 2023 17:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fw180t/y"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB96420B14
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 17:52:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8DD6F3
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698774735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hBI/XfTeVx6UUkeIftDiyCARDs2jjPZzB3PYsBCrIyo=;
	b=fw180t/ySipp6ticK2BelLswMl32Fc/pQQeq0XbuTnUkweVG9dt5SYaJvRGTYjQXmRsrqg
	bTdJXUnmWAuWTG8uCQzs/crtA1JWsNbP9HeZbQNBKbh3czWZJ862IrJkLD/FSWCwjp8FXt
	fqwfigmgOzKtbV3QjmY3xA8bg0v8Blk=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-646-sARadqgJPxy27blhIqEX_g-1; Tue, 31 Oct 2023 13:52:03 -0400
X-MC-Unique: sARadqgJPxy27blhIqEX_g-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-507cb169766so6488815e87.0
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:52:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698774720; x=1699379520;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hBI/XfTeVx6UUkeIftDiyCARDs2jjPZzB3PYsBCrIyo=;
        b=bZgab8/KxmEvhcbbiInPOczT0I4YDD/pUszdtfqG7ngs+gnYnX3SnXymn/gr5c62ul
         VSX8UXz3krJXokT7xrScm4oWLhBVwdAUej9jHz8NuvHUd+yaA8ZEo5vUbT3ntl0W8suq
         v7Avpx9x67SyBBHrikLd7DZiPNFkWM7IqrxkyyNsvz0oYVQG0RcMBBIbtDwrA+WYn9YD
         ibqF1tq1PzAWIKRBySc938HVnULX4qT0v8Qk8a7I8ZdJ/ANwk7DWU2XO6Mkeut4TyERR
         DPyAV9O3bO4eobgT5vSdGAqUOyuKUm2HMJZXfh6ZhuZNrBa/XEeUZaeGlsXZOch2gGc3
         xGsw==
X-Gm-Message-State: AOJu0YzcYkEfExGdaTySJqxhx8CQVshhHr+lx4W0hf2wb/3gOrxl+7nc
	4YLAg5lQCMzZvaV6ilBGng5k1dYkNhlTPe3BS1NktRSTwZ0UWKfWg56xlj0WZabp/i85omjYouP
	BowgCQs68llAZ4xE1skt7
X-Received: by 2002:ac2:5297:0:b0:502:afea:dfdd with SMTP id q23-20020ac25297000000b00502afeadfddmr9995689lfm.13.1698774720736;
        Tue, 31 Oct 2023 10:52:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEcFnla1lIfA/d2qFFhpzSBLsRjsScH33jS94JueL3Lmqbnb6cxPakrUEg+PZYcw2vVziy/ug==
X-Received: by 2002:ac2:5297:0:b0:502:afea:dfdd with SMTP id q23-20020ac25297000000b00502afeadfddmr9995679lfm.13.1698774720515;
        Tue, 31 Oct 2023 10:52:00 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id r13-20020a056000014d00b0032d8354fb43sm1994817wrx.76.2023.10.31.10.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Oct 2023 10:51:59 -0700 (PDT)
Message-ID: <fcc76a837a5f5eb4ed57b298a455694106d5c9c7.camel@redhat.com>
Subject: Re: [PATCH v6 15/25] KVM: x86: Add fault checks for guest CR4.CET
 setting
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com, 
	pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dave.hansen@intel.com, peterz@infradead.org, chao.gao@intel.com, 
	rick.p.edgecombe@intel.com, john.allen@amd.com
Date: Tue, 31 Oct 2023 19:51:57 +0200
In-Reply-To: <20230914063325.85503-16-weijiang.yang@intel.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
	 <20230914063325.85503-16-weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2023-09-14 at 02:33 -0400, Yang Weijiang wrote:
> Check potential faults for CR4.CET setting per Intel SDM requirements.
> CET can be enabled if and only if CR0.WP == 1, i.e. setting CR4.CET ==
> 1 faults if CR0.WP == 0 and setting CR0.WP == 0 fails if CR4.CET == 1.
> 
> Reviewed-by: Chao Gao <chao.gao@intel.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/x86.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a091764bf1d2..dda9c7141ea1 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1006,6 +1006,9 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
>  	    (is_64_bit_mode(vcpu) || kvm_is_cr4_bit_set(vcpu, X86_CR4_PCIDE)))
>  		return 1;
>  
> +	if (!(cr0 & X86_CR0_WP) && kvm_is_cr4_bit_set(vcpu, X86_CR4_CET))
> +		return 1;
> +
>  	static_call(kvm_x86_set_cr0)(vcpu, cr0);
>  
>  	kvm_post_set_cr0(vcpu, old_cr0, cr0);
> @@ -1217,6 +1220,9 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>  			return 1;
>  	}
>  
> +	if ((cr4 & X86_CR4_CET) && !kvm_is_cr0_bit_set(vcpu, X86_CR0_WP))
> +		return 1;
> +
>  	static_call(kvm_x86_set_cr4)(vcpu, cr4);
>  
>  	kvm_post_set_cr4(vcpu, old_cr4, cr4);

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky





