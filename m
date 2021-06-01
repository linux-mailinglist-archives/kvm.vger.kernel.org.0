Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78090396EC5
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 10:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233450AbhFAIWt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 04:22:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33417 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233305AbhFAIWs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Jun 2021 04:22:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622535667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WReHxPda64zFpH85OA/SFzugrU65pXg0epyJmDyWUw0=;
        b=WPTP/Alq3FKsCJg+XsiY4d0Tk3jIdx/BiiQ/GHzp/iUpanMxuI3jCxsdeQJNqhMPRpLlUj
        6Lc45urPlPq0TuSo2J4aSY8yJUNyazETVcjml1c0KOj7gi9FeUDKIofzquPcDIKw3J3xF+
        ph5GT801P7C00MouiDA/TqL5recxzIs=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-WZcjYJoKNOy_JQti4egtbQ-1; Tue, 01 Jun 2021 04:21:06 -0400
X-MC-Unique: WZcjYJoKNOy_JQti4egtbQ-1
Received: by mail-ej1-f71.google.com with SMTP id z1-20020a1709068141b02903cd421d7803so3035327ejw.22
        for <kvm@vger.kernel.org>; Tue, 01 Jun 2021 01:21:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WReHxPda64zFpH85OA/SFzugrU65pXg0epyJmDyWUw0=;
        b=HOjt+Un9G/GhtnU0thhXozwrYmOFn0EAvigjZrkmZ73ctCphnkgAuXQKfZTgGmx1Up
         ZFp51orfSC1uWQg0R+ppySoIsfHw/ImxhIMLM1myNZn/a4L7kevhZXwBIVq1M+jiH3TB
         WWEvmbczCaL+EveF9w3ANjDwTde88B2HgYbda3eicqgKO6McuKTpf4NJ0+i8qruOJkm9
         v4b0XWN4koe0dcetGNcwyJm0H1+2ek/BAiPp4Bct9ooeebXCKwY4Zb34IqSTz+9h4Zbn
         e4EUocolN56Hj5vcvvM0WZoZgjXO8RhGtwKY8o1/PvX6MrlPAo7pzGCxjrzNGeXWKVvT
         LNKQ==
X-Gm-Message-State: AOAM5301bw+Q9ZbNTug/Wy8ijZa7vTw3bnpcbz4sSYNVXpa1W8Ds/4wg
        qqHTqtpNG9isSsoWHtAHEZQqPvAI7sXDQFJN3RuEVtDKJrnojDX55kA+7A3fIjpAUiE5fMf2UQG
        1UjDQf0n+dmO+
X-Received: by 2002:aa7:c7cc:: with SMTP id o12mr31049693eds.291.1622535664460;
        Tue, 01 Jun 2021 01:21:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxGx4WjZajKzfRVdcO3xdPUBoEbwZ8YN5yKtU7CehhauQj/wnCqLYgCI87BDDuWg2PYcGjN8w==
X-Received: by 2002:aa7:c7cc:: with SMTP id o12mr31049665eds.291.1622535664323;
        Tue, 01 Jun 2021 01:21:04 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id lv10sm7146890ejb.32.2021.06.01.01.21.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jun 2021 01:21:03 -0700 (PDT)
Subject: Re: [PATCH][next] KVM: x86: Fix fall-through warnings for Clang
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20210528200756.GA39320@embeddedor>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c1624e6f-1ca0-ac57-29c0-05d7c944ffc7@redhat.com>
Date:   Tue, 1 Jun 2021 10:21:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210528200756.GA39320@embeddedor>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/05/21 22:07, Gustavo A. R. Silva wrote:
> In preparation to enable -Wimplicit-fallthrough for Clang, fix a couple
> of warnings by explicitly adding break statements instead of just letting
> the code fall through to the next case.
> 
> Link: https://github.com/KSPP/linux/issues/115
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
> JFYI: We had thousands of these sorts of warnings and now we are down
>        to just 25 in linux-next. These are some of those last remaining
>        warnings.
> 
>   arch/x86/kvm/cpuid.c   | 1 +
>   arch/x86/kvm/vmx/vmx.c | 1 +
>   2 files changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 9a48f138832d..b4da665bb892 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -655,6 +655,7 @@ static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
>   		if (kvm_cpu_cap_has(X86_FEATURE_RDTSCP))
>   			entry->ecx = F(RDPID);
>   		++array->nent;
> +		break;
>   	default:
>   		break;
>   	}
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 4bceb5ca3a89..e7d98c3d398e 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6248,6 +6248,7 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
>   	switch (kvm_get_apic_mode(vcpu)) {
>   	case LAPIC_MODE_INVALID:
>   		WARN_ONCE(true, "Invalid local APIC state");
> +		break;
>   	case LAPIC_MODE_DISABLED:
>   		break;
>   	case LAPIC_MODE_XAPIC:
> 

Queued, thanks.

Paolo

