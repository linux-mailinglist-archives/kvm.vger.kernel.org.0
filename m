Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABEA3367E0F
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 11:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235819AbhDVJpJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 05:45:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22077 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235528AbhDVJpH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Apr 2021 05:45:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619084672;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h0G7pM2R9si+lvjUV7LsvGy2ePKi+CLd1W8alu5Na6E=;
        b=GQYGPgGxuZR1KtNQHrkSIOK44gaY5d/mHAqUhONxZ/hQDf22uunk1Q+KZevzvwmrKqgOTb
        I728YB0XO0YOtRGlC+piRDdChzsI/gFC/uPe5YYB0HNBFs5c/mZlDc38fBZD/tcwyKG5iz
        3O4i5tolkXO4+iaFcsR8nfdK7a+IJec=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-NQ0tUsoGNlOlkcTU3LzhGg-1; Thu, 22 Apr 2021 05:44:30 -0400
X-MC-Unique: NQ0tUsoGNlOlkcTU3LzhGg-1
Received: by mail-ed1-f69.google.com with SMTP id p16-20020a0564021550b029038522733b66so8371644edx.11
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 02:44:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h0G7pM2R9si+lvjUV7LsvGy2ePKi+CLd1W8alu5Na6E=;
        b=Xrf9m7clsCOqHR9BPoMiFjyHmAZ96wvCyRV5JJHcEGv21iaBq2K6HBXv7V0ErI/EJL
         4mjQzs2tMfT4wtBu2iXV6EsPbMCZGOVf/H3Jz8w1EDeGVnjBsmMEx0TijBoU2Kk3po9l
         ixEG8ry8+/JPwmfHU1lHpwymVfNkFIWWDjlgV6AR79HML7p/XAAexDRPvVkUkzO14KA0
         KVPKtM9aFAbbYQObMZ+DxoTm4gyMz5mjJzN1pB/zllp0avtimU9UCsDSO1vl+q+8DIBh
         VbK44VmqG6T2foQhjtHnqnkCl/qAbkf0apGTTvIue6n+ZogjDJekS/vXUgPy1ZdNl3Mq
         d9jg==
X-Gm-Message-State: AOAM532KFqdJYYUp9NZTl29QdNGpWQuTdXXSBBBBjAT1+NtUjTb/IMqM
        Pfb5zlCWiCY9ttuzLwbbNsYkmkSVjKPvTW75zS7X18APAjrIYD9ayuOwXi4WdXeGEWHytV/I7qE
        2/2cQkffzegGpX1tpmE8AlWKuSln8AgQ8xDWM4ZcNCZ04skyq7zt9r0jOgvinMK7T
X-Received: by 2002:aa7:c789:: with SMTP id n9mr2761595eds.352.1619084669328;
        Thu, 22 Apr 2021 02:44:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJybUMOCC4ZxRCjHgxSk50KCXkc1B9buXPpHXOtD6tTI3a8s7kzHkaCrc7UUvjFy3+CpDSDwqg==
X-Received: by 2002:aa7:c789:: with SMTP id n9mr2761574eds.352.1619084669130;
        Thu, 22 Apr 2021 02:44:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id a21sm1524350ejk.15.2021.04.22.02.44.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 02:44:28 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 01/14] x86/cstart: Don't use MSR_GS_BASE in
 32-bit boot code
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <20210422030504.3488253-1-seanjc@google.com>
 <20210422030504.3488253-2-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <14655957-cf88-4abc-889b-d03387661a47@redhat.com>
Date:   Thu, 22 Apr 2021 11:44:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210422030504.3488253-2-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/04/21 05:04, Sean Christopherson wrote:
> Load the per-cpu GS.base for 32-bit build by building a temporary GDT
> and loading a "real" segment.  Using MSR_GS_BASE is wrong and broken,
> it's a 64-bit only MSR and does not exist on 32-bit CPUs.  The current
> code works only because 32-bit KVM VMX incorrectly disables interception
> of MSR_GS_BASE, and no one runs KVM on an actual 32-bit physical CPU,
> i.e. the MSR exists in hardware and so everything "works".
> 
> 32-bit KVM SVM is not buggy and correctly injects #GP on the WRMSR, i.e.
> the tests have never worked on 32-bit SVM.
> 
> Fixes: dfe6cb6 ("Add 32 bit smp initialization code")
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Relying on the descriptor cache is quite ugly but the only alternative 
are setting up extra segments in the GDT or having per-CPU GDTs (which 
I'd rather avoid).

Paolo

> ---
>   x86/cstart.S | 28 +++++++++++++++++++++++-----
>   1 file changed, 23 insertions(+), 5 deletions(-)
> 
> diff --git a/x86/cstart.S b/x86/cstart.S
> index 489c561..91970a2 100644
> --- a/x86/cstart.S
> +++ b/x86/cstart.S
> @@ -89,13 +89,31 @@ mb_flags = 0x0
>   	.long mb_magic, mb_flags, 0 - (mb_magic + mb_flags)
>   mb_cmdline = 16
>   
> -MSR_GS_BASE = 0xc0000101
> -
>   .macro setup_percpu_area
>   	lea -4096(%esp), %eax
> -	mov $0, %edx
> -	mov $MSR_GS_BASE, %ecx
> -	wrmsr
> +
> +	mov %eax, %edx
> +	shl $16, %edx
> +	or  $0xffff, %edx
> +	mov %edx, 0x10(%eax)
> +
> +	mov %eax, %edx
> +	and $0xff000000, %edx
> +	mov %eax, %ecx
> +	shr $16, %ecx
> +	and $0xff, %ecx
> +	or  %ecx, %edx
> +	or  $0x00cf9300, %edx
> +	mov %edx, 0x14(%eax)
> +
> +	movw $0x17, 0(%eax)
> +	mov %eax, 2(%eax)
> +	lgdtl (%eax)
> +
> +	mov $0x10, %ax
> +	mov %ax, %gs
> +
> +	lgdtl gdt32_descr
>   .endm
>   
>   .macro setup_segments
> 

