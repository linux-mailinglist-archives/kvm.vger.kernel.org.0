Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB7154A9569
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 09:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357158AbiBDIop (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 03:44:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:41631 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235300AbiBDIon (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 03:44:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643964282;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JSXXZMvxTAeyP3S0r+Ks4UhLpFafhFdowxAGjtjRy2g=;
        b=hBzP21mvYV9sl4xesJP3ypH3UjdKpTXZSQCcf6FTqbCnVguyiN2rctyH0/j6rxtk2LNmE0
        N/0qw6BxTK4y5EjuB9Vip58d+g8YABJDOMaRHGQsPebRv3GdqdRKkP9yWKc5E6iG1WTFQN
        Ood7vhtLqmkGMc/x2WbN1KMORULB4XY=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-241-ZiwGH71RMyWMzXRrynWRCw-1; Fri, 04 Feb 2022 03:44:41 -0500
X-MC-Unique: ZiwGH71RMyWMzXRrynWRCw-1
Received: by mail-ej1-f71.google.com with SMTP id ka12-20020a170907990c00b006c41c582397so736512ejc.11
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 00:44:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JSXXZMvxTAeyP3S0r+Ks4UhLpFafhFdowxAGjtjRy2g=;
        b=7n7CaegCFNRgZ15GoXcAI36FXNncl+Gw3KZgZ8tZQenVs+vnoeteVJ/jB0xjHzVZww
         ySeJdTn4eRLy9GLdzFQbSuq0njJbjs9wF/Y8HT3lLZ/Uf4GhTVAuI3YNJk18hbLmvR0V
         QYL1ZkKfYMqoh9pLeXr1sCEs0PVGE08g1nvJV2Gy3g0yqCJJmYY3UHQljiSyG5jXIr88
         bFi5OlhIgBYJF1kQtUUnmCsztJrIw6IFyVyf0r8LlSbbygWjxz+n2x9v1zVmJuF2vWNI
         5RHBY8ePaKlqTQEk23XFWZVx4h4CiNHoB7Oo32Lj/fwjmF4vYtvU1YWN47pCY0Dwmbmh
         emTQ==
X-Gm-Message-State: AOAM530yencSeXbsz+OPcm6kSSQRggSIkoq/lwJdJQYT7Grl05GT70Za
        ZBFBgI4qpgOE6syGtvh1g4nVwE+Obb6Xuxga4pgViGE6Q6k+EJWHE4Uta+uxjCNvPXteGw+xq0n
        VDer1/yzqV5ny
X-Received: by 2002:a17:906:cf9d:: with SMTP id um29mr1593139ejb.740.1643964280520;
        Fri, 04 Feb 2022 00:44:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzrBb8qSWfvHCkcX6vg3kOkU39WM9zLKB1e5IZ5jKbJN4IUNPKePZ8wX7AV2MD2ThLi6jmLIQ==
X-Received: by 2002:a17:906:cf9d:: with SMTP id um29mr1593126ejb.740.1643964280281;
        Fri, 04 Feb 2022 00:44:40 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id a11sm546641edv.76.2022.02.04.00.44.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Feb 2022 00:44:39 -0800 (PST)
Message-ID: <3874109c-d086-f657-6452-0cab7fc0c29e@redhat.com>
Date:   Fri, 4 Feb 2022 09:44:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] KVM: x86: Use ERR_PTR_USR() to return -EFAULT as a __user
 pointer
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220202005157.2545816-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220202005157.2545816-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/2/22 01:51, Sean Christopherson wrote:
> Use ERR_PTR_USR() when returning -EFAULT from kvm_get_attr_addr(), sparse
> complains about implicitly casting the kernel pointer from ERR_PTR() into
> a __user pointer.
> 
>>> arch/x86/kvm/x86.c:4342:31: sparse: sparse: incorrect type in return expression
>     (different address spaces) @@     expected void [noderef] __user * @@     got void * @@
>     arch/x86/kvm/x86.c:4342:31: sparse:     expected void [noderef] __user *
>     arch/x86/kvm/x86.c:4342:31: sparse:     got void *
>>> arch/x86/kvm/x86.c:4342:31: sparse: sparse: incorrect type in return expression
>     (different address spaces) @@     expected void [noderef] __user * @@     got void * @@
>     arch/x86/kvm/x86.c:4342:31: sparse:     expected void [noderef] __user *
>     arch/x86/kvm/x86.c:4342:31: sparse:     got void *
> 
> No functional change intended.
> 
> Fixes: 56f289a8d23a ("KVM: x86: Add a helper to retrieve userspace address from kvm_device_attr")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/x86.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fec3dd4f0718..b533aab98172 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -90,6 +90,8 @@
>   u64 __read_mostly kvm_mce_cap_supported = MCG_CTL_P | MCG_SER_P;
>   EXPORT_SYMBOL_GPL(kvm_mce_cap_supported);
>   
> +#define  ERR_PTR_USR(e)  ((void __user *)ERR_PTR(e))
> +
>   #define emul_to_vcpu(ctxt) \
>   	((struct kvm_vcpu *)(ctxt)->vcpu)
>   
> @@ -4340,7 +4342,7 @@ static inline void __user *kvm_get_attr_addr(struct kvm_device_attr *attr)
>   	void __user *uaddr = (void __user*)(unsigned long)attr->addr;
>   
>   	if ((u64)(unsigned long)uaddr != attr->addr)
> -		return ERR_PTR(-EFAULT);
> +		return ERR_PTR_USR(-EFAULT);
>   	return uaddr;
>   }
>   
> @@ -11684,8 +11686,6 @@ void kvm_arch_sync_events(struct kvm *kvm)
>   	kvm_free_pit(kvm);
>   }
>   
> -#define  ERR_PTR_USR(e)  ((void __user *)ERR_PTR(e))
> -
>   /**
>    * __x86_set_memory_region: Setup KVM internal memory slot
>    *
> 
> base-commit: b2d2af7e5df37ee3a9ba6b405bdbb7691a5c2dfc

Queued, thanks.

Paolo

