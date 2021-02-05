Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 818223107DD
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 10:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbhBEJ3s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 04:29:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57313 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229835AbhBEJ1a (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Feb 2021 04:27:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612517163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nlcu3cb2XGllXsJ4Cjn3h9VHrxoAGbuybTGAlLoG1zc=;
        b=M+Bv9AI+uogVU2tulmKzps9rMUbaKg5t4KZYoh9CYKGq1lSeOyM6pe1z7g/CxQDB2qgr/z
        gwxMmAHIQg/hQfSFrTiLNYqXxjbBZJ6hFN2vNQmCwlxufXcsTnl+w3d2FtyGL6FrFeiouN
        TzDOM3CnKptBIeMMWOoflr+tCg3C8qQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-VNe1hhQmMT-Vpfoi8tuzWg-1; Fri, 05 Feb 2021 04:26:00 -0500
X-MC-Unique: VNe1hhQmMT-Vpfoi8tuzWg-1
Received: by mail-ed1-f70.google.com with SMTP id o8so6616883edh.12
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 01:26:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Nlcu3cb2XGllXsJ4Cjn3h9VHrxoAGbuybTGAlLoG1zc=;
        b=QjlYOCzYG8JSSa8PrB2fBugIP82Z8GYXjzdykJuav8U459XejFMHm8C+Vtymk1LL4p
         q01jiEZsLWV8hIDqlz0Rroud87df+/y+7sXshU9PaOPUQFwwtEZHhhtfFtsywwrYDgoL
         8obHSQUxRBdO5B5btFCOVbHyKyl0rj0Ra8AhO2ih5IulspgtTrBLZxfj9Iq3PFIPP/3M
         0uUN1djHwGvrP7DVzyGG4ZrOLrDHMx0nt4qS/T1fuc5DqB7p2d+L6jcY+NGYBLJ6MOjE
         BQoVGwdkB3BlVfeQB1Nt3Nn1pxbqvYlBZ6LMY/vHeNXmrmAxjO3VQhHwQclOK+XSUFt7
         R0bQ==
X-Gm-Message-State: AOAM531LII9hjsOnlNOAOuLraobw45yxgpMPhR2AM3b4gnWxFU8L/qwR
        AirQ1Z3lHwCrCGZK9xkONOEdzqzKsOOGSeVWMJVjTLa2Qa5w6hgdttvy/ns2VEOJWrms875uCyJ
        E4hfYs3zGVc86
X-Received: by 2002:aa7:d696:: with SMTP id d22mr2625247edr.361.1612517159044;
        Fri, 05 Feb 2021 01:25:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyBCgt1agj4Ikw/q7k012mueayWYguXKrdYnw9gpDmCVHElctmRa2drVchzijXjwZpd0XUn5A==
X-Received: by 2002:aa7:d696:: with SMTP id d22mr2625239edr.361.1612517158898;
        Fri, 05 Feb 2021 01:25:58 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u18sm3680337ejc.76.2021.02.05.01.25.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Feb 2021 01:25:58 -0800 (PST)
Subject: Re: [PATCH v4 2/5] KVM: X86: Expose PKS to guest
To:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "x86@kernel.org" <x86@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>
References: <20210205083706.14146-1-chenyi.qiang@intel.com>
 <20210205083706.14146-3-chenyi.qiang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8768ad06-e051-250d-93ec-fa4d684bc7b0@redhat.com>
Date:   Fri, 5 Feb 2021 10:25:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210205083706.14146-3-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/02/21 09:37, Chenyi Qiang wrote:
> 
> diff --git a/arch/x86/mm/pkeys.c b/arch/x86/mm/pkeys.c
> index 57718716cc70..8027f854c600 100644
> --- a/arch/x86/mm/pkeys.c
> +++ b/arch/x86/mm/pkeys.c
> @@ -390,3 +390,9 @@ void pks_key_free(int pkey)
>  	__clear_bit(pkey, &pks_key_allocation_map);
>  }
>  EXPORT_SYMBOL_GPL(pks_key_free);
> +
> +u32 get_current_pkrs(void)
> +{
> +	return this_cpu_read(pkrs_cache);
> +}
> +EXPORT_SYMBOL_GPL(get_current_pkrs);
> diff --git a/include/linux/pkeys.h b/include/linux/pkeys.h
> index bed0e293f13b..480429020f4c 100644
> --- a/include/linux/pkeys.h
> +++ b/include/linux/pkeys.h
> @@ -72,6 +72,10 @@ static inline void pks_mk_readwrite(int pkey)
>  {
>  	pr_err("%s is not valid without PKS support\n", __func__);
>  }
> +static inline u32 get_current_pkrs(void)
> +{
> +	return 0;
> +}
>  #endif /* ! CONFIG_ARCH_HAS_SUPERVISOR_PKEYS */
>  

This would need an ack from the x86 people.  Andy, Boris?

Paolo

