Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 863EE325314
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 17:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233511AbhBYQHT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 11:07:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45189 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233501AbhBYQGs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Feb 2021 11:06:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614269120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ovFMJvcRLAIdbXAQ8NZaWzc1s4GiFyLOYmDRZ23G+WE=;
        b=jTgEa16a1EvakEUxB41/QYB52RoLiIeOXZfX6cvVwcr/3oaLLdLiURawWbMZbIjCrflZ7v
        FPKoQrmuxdzdyKFJyRp12nAXUx4ortQl/gga/F6PX0e10AZmG9U0v4/UdY3XDWUYFJ+QVZ
        ni9/cgvHY73zDzOGRtBTmyb1MnNhOgY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-huV6pzJ5PpudHua8xrgLTw-1; Thu, 25 Feb 2021 11:05:18 -0500
X-MC-Unique: huV6pzJ5PpudHua8xrgLTw-1
Received: by mail-ed1-f71.google.com with SMTP id u2so2979343edj.20
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 08:05:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ovFMJvcRLAIdbXAQ8NZaWzc1s4GiFyLOYmDRZ23G+WE=;
        b=JutqLK/ezoiCKJ5PRTDuZfSCNweDV4hA9xT7VsOzX/hUpIEWZztPu7UgPFnuaIm1J4
         o0cuw0I34X2FEX0JqcJMP0V6okX4M7nM+Q7SYQcIvrpee0hyC4N8Tg46z3JYxqXXaVx8
         27gJ2ZeTaEa+GhCyJ1arUBLuHnr2RALCmOvi/kloswzqQBgeliFpSVSP1ldl0I4OcPjj
         8Ng352XQFvT3JPxOuiU5OmjWtyKcD8dRcGZIjw2Wb410UacYUUHGdMJVjufZyni8Dc5E
         ePrankxRnLJ8cbhkFZAEh7MdMIKMZkxrlZNXFG3JpLUy6bRwelvsJVLVuXsiPpAg6vZj
         RuRQ==
X-Gm-Message-State: AOAM532/BicGjKqsJVy3xGbCN3A7DiNIdIi8if9VHOKWsF0XqVtPJ0Ui
        rMpRJjNmhH1WBUZcO+reCheSaeR90zYM4dmP5izfRn39iqM6BXBBvGbwgx3MFFmI4IFO9IO6o1O
        VSoZjOFL+t5fv
X-Received: by 2002:a17:907:1b12:: with SMTP id mp18mr3406354ejc.128.1614269117317;
        Thu, 25 Feb 2021 08:05:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz+9u1IOVp8bmIzUQGXU2jmcvoQW9cC/C8Q7UxGbukt4Sa3TUJK0O1uhRPc5PMU3q9Qs1on8w==
X-Received: by 2002:a17:907:1b12:: with SMTP id mp18mr3406326ejc.128.1614269117046;
        Thu, 25 Feb 2021 08:05:17 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id a7sm3674377edr.29.2021.02.25.08.05.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Feb 2021 08:05:16 -0800 (PST)
Subject: Re: [PATCH 3/4] KVM: x86: pending exception must be be injected even
 with an injected event
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20210225154135.405125-1-mlevitsk@redhat.com>
 <20210225154135.405125-4-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <358e284b-957a-388b-9729-9ee82b4fd8e3@redhat.com>
Date:   Thu, 25 Feb 2021 17:05:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210225154135.405125-4-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/02/21 16:41, Maxim Levitsky wrote:
> Injected events should not block a pending exception, but rather,
> should either be lost or be delivered to the nested hypervisor as part of
> exitintinfo/IDT_VECTORING_INFO
> (if nested hypervisor intercepts the pending exception)
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>

Does this already fix some of your new test cases?

Paolo

> ---
>   arch/x86/kvm/svm/nested.c | 7 ++++++-
>   arch/x86/kvm/vmx/nested.c | 9 +++++++--
>   2 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 881e3954d753b..4c82abce0ea0c 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1024,7 +1024,12 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
>   	}
>   
>   	if (vcpu->arch.exception.pending) {
> -		if (block_nested_events)
> +		/*
> +		 * Only pending nested run can block an pending exception
> +		 * Otherwise an injected NMI/interrupt should either be
> +		 * lost or delivered to the nested hypervisor in EXITINTINFO
> +		 * */
> +		if (svm->nested.nested_run_pending)
>                           return -EBUSY;
>   		if (!nested_exit_on_exception(svm))
>   			return 0;
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index b34e284bfa62a..20ed1a351b2d9 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3810,9 +3810,14 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
>   
>   	/*
>   	 * Process any exceptions that are not debug traps before MTF.
> +	 *
> +	 * Note that only pending nested run can block an pending exception
> +	 * Otherwise an injected NMI/interrupt should either be
> +	 * lost or delivered to the nested hypervisor in EXITINTINFO
>   	 */
> +
>   	if (vcpu->arch.exception.pending && !vmx_pending_dbg_trap(vcpu)) {
> -		if (block_nested_events)
> +		if (vmx->nested.nested_run_pending)
>   			return -EBUSY;
>   		if (!nested_vmx_check_exception(vcpu, &exit_qual))
>   			goto no_vmexit;
> @@ -3829,7 +3834,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
>   	}
>   
>   	if (vcpu->arch.exception.pending) {
> -		if (block_nested_events)
> +		if (vmx->nested.nested_run_pending)
>   			return -EBUSY;
>   		if (!nested_vmx_check_exception(vcpu, &exit_qual))
>   			goto no_vmexit;
> 

