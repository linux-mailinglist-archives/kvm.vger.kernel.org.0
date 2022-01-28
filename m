Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D0849FCA7
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 16:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242016AbiA1PR0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 10:17:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:60602 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344522AbiA1PRX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Jan 2022 10:17:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643383043;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B+4SyMhuYjgUIEdNZ7ziPDUu6V9n9YlAEf3lZkpwc1s=;
        b=TT8Xp4gh3zHxfJyvBJ41Qk1igkyzwYBf9+JFogm5tGM6akaHPNHixhExnFvAuIjvSl2hyU
        O7T1Cmc82unBQVyRJo2eIPgam57PlVugJljQxUrsaL7LAaTfE3PSjju3TpeEcvEukdbix7
        WHJwDHyqvJneFxnW3W0xWyFubXz3hhY=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-357-YVWowbXgOr-TAVqswMff5g-1; Fri, 28 Jan 2022 10:17:21 -0500
X-MC-Unique: YVWowbXgOr-TAVqswMff5g-1
Received: by mail-ej1-f70.google.com with SMTP id v2-20020a1709062f0200b006a5f725efc1so3014130eji.23
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 07:17:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=B+4SyMhuYjgUIEdNZ7ziPDUu6V9n9YlAEf3lZkpwc1s=;
        b=C82nheFHih+VlgB/u8Z3MvcHuyd9leEmTDLeIVSi1G/c/1Fij/EuESX6FO6+KVUgco
         abI3EnHZKQDpX14sdZ0LFpxI2OkD+hZWfuB7GshvQ0B/b3AleVRP+C/T6FG6hPwQ/ESI
         GX8W2AQDRNk7PfVc05n4SMrctV9nmw5Hz/y07Kxmk12WFPVoo9UVnlVa3SyqMByg+kb+
         Ho+aX/cUFYf2L31JseIHMDYwBQgSDx/y1Qe+mrqGixos5yx0+kI4pMUZc0Fv8CUhRS76
         u6kBlDMeAOIXuhc17lEdFX+Es8MVIK/48GOHRUbqmZy+hoSWbMaPMS/6HcZaEW/vHXq+
         HlvA==
X-Gm-Message-State: AOAM532GtwxJbEz13vmh+4f/uWoKkEOIYbnSV32OlZ0lvg3As1GJBamz
        IXdpDcg9C6iiq6WgBXxNQpf6Osw44LxxyxgE01M4XoTy47Yn8Q7Dw0Wn00cvk3nc6hxVLM/pDDV
        sU458lfkyxUfZ
X-Received: by 2002:a17:907:97c9:: with SMTP id js9mr7100689ejc.216.1643383040127;
        Fri, 28 Jan 2022 07:17:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzQrEIxmdb869XlcJXV5GjKMYeT47z1MiIhOYP4j90slWPmc7DrQPPAndA9o3p1i+vBHvQxIg==
X-Received: by 2002:a17:907:97c9:: with SMTP id js9mr7100665ejc.216.1643383039870;
        Fri, 28 Jan 2022 07:17:19 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id jt14sm10164479ejc.32.2022.01.28.07.17.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Jan 2022 07:17:19 -0800 (PST)
Message-ID: <3f5d9eb7-7ad7-ae08-c31d-a41eef6659e4@redhat.com>
Date:   Fri, 28 Jan 2022 16:17:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [kvm-unit-tests PATCH 3/3] x86: Define wrtsc(tsc) as
 wrmsr(MSR_IA32_TSC, tsc)
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
References: <20220127215548.2016946-1-jmattson@google.com>
 <20220127215548.2016946-3-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220127215548.2016946-3-jmattson@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/27/22 22:55, Jim Mattson wrote:
> Remove some inline assembly code duplication and opportunistically
> replace the magic constant, "0x10," with "MSR_IA32_TSC."
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>   lib/x86/processor.h | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index fe5add548261..117032a4895c 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -592,9 +592,7 @@ static inline unsigned long long rdtscp(u32 *aux)
>   
>   static inline void wrtsc(u64 tsc)
>   {
> -	unsigned a = tsc, d = tsc >> 32;
> -
> -	asm volatile("wrmsr" : : "a"(a), "d"(d), "c"(0x10));
> +	wrmsr(MSR_IA32_TSC, tsc);
>   }
>   
>   static inline void irq_disable(void)

Queued all three, thanks.

Paolo

