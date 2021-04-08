Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE169358297
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 14:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbhDHMAc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 08:00:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28305 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230434AbhDHMAb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Apr 2021 08:00:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617883220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4jNA22ts4sXV+GUF1Wj8QCzAfhn+4bY8EmKVJ9s6OPc=;
        b=i371BRCXf0ydmnYZgOpsWYKoI/4+mE1pw/idYPInLqjCs+q2TUR81JuvaG0lNd0Amx/kKp
        fTRSorl49OHo0QHvw74C3r7Me5CheFrmOsatpqbzfralYlMAMvVMrAPFQUZoRcNlHKru7B
        tmGSvaQZGq0D0iJuYX9L543lNG1gfEg=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-hpfYGHYFMC6SzoSRyLD0Ow-1; Thu, 08 Apr 2021 08:00:17 -0400
X-MC-Unique: hpfYGHYFMC6SzoSRyLD0Ow-1
Received: by mail-ed1-f69.google.com with SMTP id q12so913555edv.9
        for <kvm@vger.kernel.org>; Thu, 08 Apr 2021 05:00:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4jNA22ts4sXV+GUF1Wj8QCzAfhn+4bY8EmKVJ9s6OPc=;
        b=VqvMetTfnHUxarVk8IL3xNUKYDt4pRGG1jNGlHjt+9zW7VuIH89a9x6EX+ZeNJ9jTy
         j6YmZdEBEF4v6wEVXfBioCnDFL7BufgJZXryhn8SBbGn74qscDgkf0bPEWY4eOjxWVbL
         si8vdCss+91uPyfN6apnkt30kRwsvSsu1w4ZhAmNXCFDQrSTQLLjWPj1PNtSqyRxltg0
         ikRuNt+NCzfl5ZM+mxvfLXIVvsfCjXMUiKnTOsYsLhHAgM+f7DsqHfBWmcLzQTPEDBy5
         647GsOoLBeKPqdAfzH/Y1fTUphFswQUcge832iRzox5ubYjYqP3BQVm2QN1Nn4osOPbu
         MdHw==
X-Gm-Message-State: AOAM530I5Oi3NLSq7nBtvUV/NfjPg5pqpDgoy7hvCpVP4xRSpVyxbIPd
        bfwMrBaz0zNLwTWJPocU6DIfu2aPBJCI8fZgVqcpCyIsUrRGR1/qEnc7pFb7xUjg+B7T/yS/m2w
        AH4GnwFQc9/Fw
X-Received: by 2002:a17:906:2594:: with SMTP id m20mr9661470ejb.124.1617883214265;
        Thu, 08 Apr 2021 05:00:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwCaXWiCiY1qRqSDTSV8wOLTIbsQEr6KIundxcbgi9SLmCTjbsZRz+/AN4KDzZ5Shtv+a3bng==
X-Received: by 2002:a17:906:2594:: with SMTP id m20mr9661393ejb.124.1617883213903;
        Thu, 08 Apr 2021 05:00:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id a9sm4209509eda.13.2021.04.08.05.00.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Apr 2021 05:00:13 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: Explicitly use GFP_KERNEL_ACCOUNT for 'struct
 kvm_vcpu' allocations
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <kernellwp@gmail.com>
References: <20210406190740.4055679-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bf29a3f3-cb55-dbfd-36da-708cc67d1d1a@redhat.com>
Date:   Thu, 8 Apr 2021 14:00:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210406190740.4055679-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/04/21 21:07, Sean Christopherson wrote:
> Use GFP_KERNEL_ACCOUNT when allocating vCPUs to make it more obvious that
> that the allocations are accounted, to make it easier to audit KVM's
> allocations in the future, and to be consistent with other cache usage in
> KVM.
> 
> When using SLAB/SLUB, this is a nop as the cache itself is created with
> SLAB_ACCOUNT.
> 
> When using SLOB, there are caveats within caveats.  SLOB doesn't honor
> SLAB_ACCOUNT, so passing GFP_KERNEL_ACCOUNT will result in vCPU
> allocations now being accounted.   But, even that depends on internal
> SLOB details as SLOB will only go to the page allocator when its cache is
> depleted.  That just happens to be extremely likely for vCPUs because the
> size of kvm_vcpu is larger than the a page for almost all combinations of
> architecture and page size.  Whether or not the SLOB behavior is by
> design is unknown; it's just as likely that no SLOB users care about
> accounding and so no one has bothered to implemented support in SLOB.
> Regardless, accounting vCPU allocations will not break SLOB+KVM+cgroup
> users, if any exist.
> 
> Cc: Wanpeng Li <kernellwp@gmail.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> 
> v2: Drop the Fixes tag and rewrite the changelog since this is a nop when
>      using SLUB or SLAB. [Wanpeng]
> 
>   virt/kvm/kvm_main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 0a481e7780f0..580f98386b42 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3192,7 +3192,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>   	if (r)
>   		goto vcpu_decrement;
>   
> -	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
> +	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL_ACCOUNT);
>   	if (!vcpu) {
>   		r = -ENOMEM;
>   		goto vcpu_decrement;
> 

Queued, thanks.

Paolo

