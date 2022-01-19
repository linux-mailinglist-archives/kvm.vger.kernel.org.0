Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A6F49400A
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 19:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356842AbiASSh5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 13:37:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:47779 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1356723AbiASShz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Jan 2022 13:37:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642617475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yEREuIwhli7iJjgFoyBi+FO+07r4F6yeofjnLnMk0U8=;
        b=LIbir6FQ2mxNJqG95L+m2hbJigaYPq+7UhKORcHpx49QXOfZorbEeWUOcFVYsq+09P0mZi
        B7tEtDcE99V3fhJTUbkLeldkhby0GPo3wvZG/VUyF+qx++RZMC8HuvszyA9t3+/fUBUJNX
        2v5BaxREyVfqyepwXJ8sUyl8jHMd9o0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-367-RuX0CmDnNtOs8Qh9oZNvIw-1; Wed, 19 Jan 2022 13:37:54 -0500
X-MC-Unique: RuX0CmDnNtOs8Qh9oZNvIw-1
Received: by mail-wm1-f69.google.com with SMTP id a3-20020a05600c348300b0034a0dfc86aaso4775063wmq.6
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 10:37:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yEREuIwhli7iJjgFoyBi+FO+07r4F6yeofjnLnMk0U8=;
        b=JIS3A9IUuqczKngHifDC+atFmKPM0i1Zr8Oa+fqXx1QBye1rzbs05mIUHDgb07FAsi
         ITDqAcYbZ8mY5e6iQJy6KX54N+lwrQTqhQqvTXoFiZ2tCLiebie6ODeUP9O0aXvdRl9s
         jRqyoCji8AypHuxtTIe/9w1VZz/92EQJuShT83cJrTizvQvt43jHE4HAGbeAOlEGVJKH
         tfdXvBfklRu+rj3fC2ybiBC4jjdLUSmjU6J12zvL8D6VBKmRD+bUKxkmAbA+JXk5MqZN
         gdBX9GfluEaivJ1oUgWLtobw9F3CIoOaMmVPG8zLW1Ysaafix3VkOX56htDCpq2JrYC9
         p03A==
X-Gm-Message-State: AOAM533l00X5MGMa2IfKXVmKXi19upW17zaZqmgaq/E1pkDYyJKqQChn
        1ZSnqcnL4Q6qN5Q/gzsjSIFkcgGv9tK6/nlzCmty9dwah74hKqaUR7I7tKO6ncERdXH7cAFgXlz
        qrjWkIg96hR7i
X-Received: by 2002:a5d:4404:: with SMTP id z4mr14188676wrq.227.1642617472731;
        Wed, 19 Jan 2022 10:37:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwyZFHgQhMucWDMGC5Bo4G9movDj4dSOqUphWsssCtw3O4y8rH0o4YVhpuc6L5s8ueVVP9c5g==
X-Received: by 2002:a5d:4404:: with SMTP id z4mr14188657wrq.227.1642617472536;
        Wed, 19 Jan 2022 10:37:52 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id n14sm590533wri.101.2022.01.19.10.37.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jan 2022 10:37:51 -0800 (PST)
Message-ID: <d4b47a8e-77f2-eef2-2245-bdc7eaf8f57f@redhat.com>
Date:   Wed, 19 Jan 2022 19:37:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] selftests: kvm/x86: Fix the warning in
 lib/x86_64/processor.c
Content-Language: en-US
To:     Jinrong Liang <ljr.kernel@gmail.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220119140325.59369-1-cloudliang@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220119140325.59369-1-cloudliang@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/19/22 15:03, Jinrong Liang wrote:
> From: Jinrong Liang <cloudliang@tencent.com>
> 
> The following warning appears when executing
> make -C tools/testing/selftests/kvm
> 
> In file included from lib/x86_64/processor.c:11:
> lib/x86_64/processor.c: In function ':
> include/x86_64/processor.h:290:2: warning: 'ecx' may be used uninitialized in this
> function [-Wmaybe-uninitialized]
>    asm volatile("cpuid"
>    ^~~
> lib/x86_64/processor.c:1523:21: note: 'ecx' was declared here
>    uint32_t eax, ebx, ecx, edx, max_ext_leaf;
> 
> Just initialize ecx to remove this warning.
> 
> Fixes: c8cc43c1eae2 ("selftests: KVM: avoid failures due to reserved
> HyperTransport region")
> 
> Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
> ---
>   tools/testing/selftests/kvm/lib/x86_64/processor.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 59dcfe1967cc..4a4c7945cf3e 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -1520,7 +1520,7 @@ unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
>   {
>   	const unsigned long num_ht_pages = 12 << (30 - vm->page_shift); /* 12 GiB */
>   	unsigned long ht_gfn, max_gfn, max_pfn;
> -	uint32_t eax, ebx, ecx, edx, max_ext_leaf;
> +	uint32_t eax, ebx, ecx = 0, edx, max_ext_leaf;
>   
>   	max_gfn = (1ULL << (vm->pa_bits - vm->page_shift)) - 1;
>   

A separate assignment of "ecx = 0" is slightly more conforming to the 
coding standards.  Queued nevertheless, thanks.

Paolo

