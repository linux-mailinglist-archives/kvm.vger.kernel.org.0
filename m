Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF24F26666F
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 19:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgIKR1q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 13:27:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42467 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726157AbgIKR1T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 13:27:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599845237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=germb81mdbPxJ2sh80nFaxpLsRawudu0Nob2MSBfAQQ=;
        b=FnhT4jcwuceejf+y+0Or0YtPMsf92JA7WixkXYL0bNoOMHIdYgsfPObnf4DvAr1uYwFBm+
        cOc2+eEJoL1cMLiJf60wMvSGqt9ltY+9xFA+QyLPawJHTw9+XhDP7mdAG37niGucXLvf8T
        wGFZSYc4c0z7dOSuAyWUn/3UAW5jv+g=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-PRhj1oarN8qzRe8SdDKQ6g-1; Fri, 11 Sep 2020 13:27:16 -0400
X-MC-Unique: PRhj1oarN8qzRe8SdDKQ6g-1
Received: by mail-wm1-f72.google.com with SMTP id s19so1626947wme.2
        for <kvm@vger.kernel.org>; Fri, 11 Sep 2020 10:27:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=germb81mdbPxJ2sh80nFaxpLsRawudu0Nob2MSBfAQQ=;
        b=l52HZ76k0ZjqxIlQnqnsfTetLB3pNYf+PrveFvfECQqXgP3rf6yrEdh+uIXdqT8sL/
         +aAHK+rqB5FoS2OiHUtU5laX1reXlDNQGTHx4ZJ8GdgEu8A3iSFONe3hDaaeRxS9hlio
         gTPuAPLFxGKUZowOeGpEXrhceLk8Wc+JvgmQCMmWEETmV5xvdl+Ap6NdfnRebOJ20Ttl
         /3ynVjLXcl3UknbJ7xahsSGEALKNqDwyLRFz3n6Y9GjFKiOWEuSj+x6sPg2L8kWnyrt5
         C2ifGQUCXcYSgmWWOSzCtiC9shiVJWTLrFXxp/3ykYRKv7AaCwyOiit5zVBaLNBapKlZ
         Xx1Q==
X-Gm-Message-State: AOAM530l5hjki9cnQAazbRmln0jTccfeUjlgUc7Hj2GetZIwAwYncszD
        ScjckRkLKW0kIG0u9uI6wq9FMpwX8fKxlFAzAiHs5Z/v+2KXMHCfcr64yLuAw3aHotYd3V13rl+
        Ci3F4uucD2pVT
X-Received: by 2002:adf:ed05:: with SMTP id a5mr3055391wro.364.1599845234708;
        Fri, 11 Sep 2020 10:27:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy+714Ss/NtU7n/+81wJkJaafGSQ6jwDl3NWbZRIsM4cOwwvUkTxSTzyff5S0Xi1bh4AodWHA==
X-Received: by 2002:adf:ed05:: with SMTP id a5mr3055372wro.364.1599845234466;
        Fri, 11 Sep 2020 10:27:14 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id e18sm6500243wra.36.2020.09.11.10.27.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 10:27:13 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: always allow writing '0' to MSR_KVM_ASYNC_PF_EN
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20200911093147.484565-1-vkuznets@redhat.com>
 <20200911160455.GB4344@sjchrist-ice>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c3f4d7d4-59b1-088d-cc85-ccd55d9e2e79@redhat.com>
Date:   Fri, 11 Sep 2020 19:27:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200911160455.GB4344@sjchrist-ice>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/09/20 18:04, Sean Christopherson wrote:

> This doesn't actually verify that @data == 0.  kvm_pv_async_pf_enabled()
> returns true iff KVM_ASYNC_PF_ENABLED and KVM_ASYNC_PF_DELIVERY_AS_INT are
> set, e.g. this would allow setting one and not the other.  This also allows
> userspace to set vcpu->arch.apf.msr_en_val to an unsupported value, i.e.
> @data has already been propagated to the vcpu and isn't unwound.
> 
> Why not just pivot on @data when lapic_in_kernel() is false?  vcpu->arch.apic
> is immutable so there's no need to update apf.msr_en_val in either direction.
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 539ea1cd6020..36969d5ec291 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2735,7 +2735,7 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
>                 return 1;
> 
>         if (!lapic_in_kernel(vcpu))
> -               return 1;
> +               return data ? 1 : 0;
> 
>         vcpu->arch.apf.msr_en_val = data;
> 
> 
>> +		return 1;
>> +
>>  	if (kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.apf.data, gpa,
>>  					sizeof(u64)))
>>  		return 1;
>> -- 
>> 2.25.4
>>
> 

Committed this instead, though.

Paolo

