Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 426272FA833
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 19:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407330AbhARSBl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 13:01:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55460 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407426AbhARSBP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 13:01:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610992788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T2HNFh4tGmunTdtcHPmXNaPVbvrJW2x+rSByPsYMLmg=;
        b=S5kk7S1ovNjt5X3SLyCVfiO0Lfr876kp8hUbQ3eIKEFvwAQtIdC64Za5SG3Vl3/q/y6stU
        mdpP0Ob022WyOKiLgVCVihGF2R9//dCXdFc7IoLjVmzNO9EPEeFJbYyA2f47J2S1FJtcyA
        v5PpV1PdSNuZKEbJgWqRFzO+993oCbk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-ZH6OfCkVOte8IL274CIMnQ-1; Mon, 18 Jan 2021 12:59:47 -0500
X-MC-Unique: ZH6OfCkVOte8IL274CIMnQ-1
Received: by mail-ed1-f71.google.com with SMTP id u17so8201683edi.18
        for <kvm@vger.kernel.org>; Mon, 18 Jan 2021 09:59:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T2HNFh4tGmunTdtcHPmXNaPVbvrJW2x+rSByPsYMLmg=;
        b=gwWbEBsZLBVyyaQt7mkiuD/p+tn7LhaVkcLpMs9M1If66ONvVW/sldf6g07O+HBSZT
         c8yWAURZ6l8w+seO6jtxaMxhDAtVSwTbE6lNCeJPS7iWshsCJ69gsPmKIfhnQINrPCmb
         lWurHcI+GfPoff/LuUrovo49ppy6dqcMztw/BtQ4pm60bNSXwWXg5pBXUcVyCABerQe1
         JYbfrCcJMV1yFALt3jlAYAcu5G9VazdMiDVkXaDtYs+h/Kw0b6aUsGXhRpcJr6nEgknx
         4MTNtLeknGb9r7D/eUh8xddObgaplTX2J8I0JjgNHrQ1wjIEjOtyPX+rM+PIEf8KS6Nf
         WbLg==
X-Gm-Message-State: AOAM531/uBOZwq5bC9q9eBortUl9Zkz69pH8DsD/p6WiZrcsZh05JpXY
        pfBmWvpk8J4X5seuTc1btr+UPVGkGfq7+MHB9mUuBsa+CA4T+PF69oL/lRDLxaukNLhPM/Ds7P2
        JBTyG78YdqGT4
X-Received: by 2002:a05:6402:3510:: with SMTP id b16mr486885edd.242.1610992786135;
        Mon, 18 Jan 2021 09:59:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyA7xCdJb5UE0ciBeFtJ9lz3e0ooEmAyU4lBg8uFTIMUoWQdwOCLaoyinlppLP4Jo7SmRAPhA==
X-Received: by 2002:a05:6402:3510:: with SMTP id b16mr486870edd.242.1610992785978;
        Mon, 18 Jan 2021 09:59:45 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id he38sm9395037ejc.96.2021.01.18.09.59.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 09:59:45 -0800 (PST)
Subject: Re: [PATCH] x86/sev: Add AMD_SEV_ES_GUEST Kconfig for including
 SEV-ES support
To:     Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20210116002517.548769-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d4deb3ba-5c72-f61c-5040-0571822297c6@redhat.com>
Date:   Mon, 18 Jan 2021 18:59:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210116002517.548769-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/01/21 01:25, Sean Christopherson wrote:
> 
> @@ -1527,12 +1527,14 @@ config AMD_MEM_ENCRYPT
>  	select DYNAMIC_PHYSICAL_MASK
>  	select ARCH_USE_MEMREMAP_PROT
>  	select ARCH_HAS_FORCE_DMA_UNENCRYPTED
> -	select INSTRUCTION_DECODER
>  	help
>  	  Say yes to enable support for the encryption of system memory.
>  	  This requires an AMD processor that supports Secure Memory
>  	  Encryption (SME).
>  
> +	  This also enables support for running as a Secure Encrypted
> +	  Virtualization (SEV) guest.
> +
>  config AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT
>  	bool "Activate AMD Secure Memory Encryption (SME) by default"
>  	default y
> @@ -1547,6 +1549,15 @@ config AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT
>  	  If set to N, then the encryption of system memory can be
>  	  activated with the mem_encrypt=on command line option.
>  
> +config AMD_SEV_ES_GUEST
> +	bool "AMD Secure Encrypted Virtualization - Encrypted State (SEV-ES) Guest support"
> +	depends on AMD_MEM_ENCRYPT
> +	select INSTRUCTION_DECODER
> +	help
> +	  Enable support for running as a Secure Encrypted Virtualization -
> +	  Encrypted State (SEV-ES) Guest.  This enables SEV-ES boot protocol
> +	  changes, #VC handling, SEV-ES specific hypercalls, etc...
> +

Queued, thanks.

Paolo

