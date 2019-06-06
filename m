Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F25DA3737B
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 13:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbfFFLxh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 07:53:37 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34695 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfFFLxh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 07:53:37 -0400
Received: by mail-wr1-f68.google.com with SMTP id e16so2121445wrn.1
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 04:53:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Kcw2eitPBsnk1lUWFm8LCwt8R5Oq7PsZekBJkOXcnM8=;
        b=QCBFTIy5Gw0QjBkt3S6ALq2DYRw+RxD3+JVgfyhc0dRQrtyjs3o2MccACJ+B6yZ7qM
         DbElD+TxESF2A/Lks5nlu3x+3dle6Jn1nSGggdlCkPD2mzQ1/G78OyapvftB5WoHHHrk
         4mLLzhZ7IX6WLPOVeokmcnoNXy4DBE2kFQL6AqzbcolruQKBKdyI/V44Z4Qe/JtaRnq0
         CWXdhA442HjhpS0WtPSMY3gBcXRpBK068qTc7awDps1OHsCKFSIL3hqr4hdaDtT9tbMO
         xV831xQHo/aKkmaDGy1HgwZ7M2yP0Tz70O38hgXjdds7BL1+UvIfvTRlGcRFMFjSDMju
         eYeQ==
X-Gm-Message-State: APjAAAXjpJJF3ATC2/31KWxNNzlJE3Ey+p53GUhKxC1NWgH3jWO3OMZU
        0cd/ZhNmh7I19ennEdNnOmqL/w==
X-Google-Smtp-Source: APXvYqzvBQtVhLg2YESyms7yapgGIPgP/71w0VZjSO93jVhK3KfJeArIhG93fJ3k2gNrWJBU2TLsAw==
X-Received: by 2002:adf:ee49:: with SMTP id w9mr6346952wro.112.1559822015432;
        Thu, 06 Jun 2019 04:53:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id z17sm1537206wru.21.2019.06.06.04.53.33
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 04:53:34 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: Use DR_TRAP_BITS instead of hard-coded 15
To:     Liran Alon <liran.alon@oracle.com>, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Cc:     Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
References: <20190605225447.12192-1-liran.alon@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8026de82-45d5-8419-0ef7-026bd146c1ee@redhat.com>
Date:   Thu, 6 Jun 2019 13:53:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190605225447.12192-1-liran.alon@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/06/19 00:54, Liran Alon wrote:
> Make all code consistent with kvm_deliver_exception_payload() by using
> appropriate symbolic constant instead of hard-coded number.
> 
> Reviewed-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> ---
>  arch/x86/kvm/emulate.c | 2 +-
>  arch/x86/kvm/vmx/vmx.c | 4 ++--
>  arch/x86/kvm/x86.c     | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index d0d5dd44b4f4..199cd2cf7254 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -4260,7 +4260,7 @@ static int check_dr_read(struct x86_emulate_ctxt *ctxt)
>  		ulong dr6;
>  
>  		ctxt->ops->get_dr(ctxt, 6, &dr6);
> -		dr6 &= ~15;
> +		dr6 &= ~DR_TRAP_BITS;
>  		dr6 |= DR6_BD | DR6_RTM;
>  		ctxt->ops->set_dr(ctxt, 6, dr6);
>  		return emulate_db(ctxt);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index b93e36ddee5e..f64bcbb03906 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4521,7 +4521,7 @@ static int handle_exception(struct kvm_vcpu *vcpu)
>  		dr6 = vmcs_readl(EXIT_QUALIFICATION);
>  		if (!(vcpu->guest_debug &
>  		      (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP))) {
> -			vcpu->arch.dr6 &= ~15;
> +			vcpu->arch.dr6 &= ~DR_TRAP_BITS;
>  			vcpu->arch.dr6 |= dr6 | DR6_RTM;
>  			if (is_icebp(intr_info))
>  				skip_emulated_instruction(vcpu);
> @@ -4766,7 +4766,7 @@ static int handle_dr(struct kvm_vcpu *vcpu)
>  			vcpu->run->exit_reason = KVM_EXIT_DEBUG;
>  			return 0;
>  		} else {
> -			vcpu->arch.dr6 &= ~15;
> +			vcpu->arch.dr6 &= ~DR_TRAP_BITS;
>  			vcpu->arch.dr6 |= DR6_BD | DR6_RTM;
>  			kvm_queue_exception(vcpu, DB_VECTOR);
>  			return 1;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 83aefd759846..db9dc011965b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6381,7 +6381,7 @@ static bool kvm_vcpu_check_breakpoint(struct kvm_vcpu *vcpu, int *r)
>  					   vcpu->arch.db);
>  
>  		if (dr6 != 0) {
> -			vcpu->arch.dr6 &= ~15;
> +			vcpu->arch.dr6 &= ~DR_TRAP_BITS;
>  			vcpu->arch.dr6 |= dr6 | DR6_RTM;
>  			kvm_queue_exception(vcpu, DB_VECTOR);
>  			*r = EMULATE_DONE;
> 

Queued, thanks.

Paolo
