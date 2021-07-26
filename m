Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B908B3D6994
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 00:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233774AbhGZVyg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 17:54:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42015 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232876AbhGZVyf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Jul 2021 17:54:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627338903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pgpmDMm0CnqdpOlFLaXq6nbjjRIJeH3bENX23ACSG+U=;
        b=Y581NGOAvOn/0E06XH/cEOUqMXS10ZPP5HiYyu/mqIXAKXnh/Jrn80BjTWY7cGSERHjhn+
        EY0Tbn9y3AqqFBdufkNJ94AmZ/jNA0KJK5IsaHRsmxohtpoOEw+Jn5ctjavKUXfdSG4nP8
        hJIvuC/zOg3JoPk37UGIZ/ILk691Zps=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-sEtwapryMOO7Iz-KhhHClw-1; Mon, 26 Jul 2021 18:35:01 -0400
X-MC-Unique: sEtwapryMOO7Iz-KhhHClw-1
Received: by mail-ej1-f69.google.com with SMTP id o17-20020a1709063591b02905127dfeb6c7so2489090ejb.16
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 15:35:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pgpmDMm0CnqdpOlFLaXq6nbjjRIJeH3bENX23ACSG+U=;
        b=kB4bGFiMoaORkgNocj1N8h38su4Q5wlK/Jt0y6/KbXsSE+oAXdI9nxqIUI9tZa942G
         9su/MxmYG9sVbLW4WUQYWPS9aX5wdFbAMqtnQ6UY43RQU59CCOLijZjqpdbR/0eJTolL
         wB4BN86DJUPVOvW9n/mMzcW8jQGOvj6sxanUKLf12PBf83SYcrmbXmYoKY1tPY5gB/vo
         BfHG95k81RoHoffntLwxvynq7o9H4Zek6SBOzB7VCR92SSKdGE38mL/me7G2kGHEaaLZ
         UzdzWE0OwpyWLUpni0B6OJXPeduxCDjFeqtYfZcGiuVJmUqayznn9g16p3NwgkoDO3dK
         LKOg==
X-Gm-Message-State: AOAM530jPh4vp5SW9b6WrumAzI1knUBvJ4MQ3NplFKtmnezj7vJjCC9i
        3gzO0IsbYeW134j1fyIOd3bkvgF2BsYPQcnYfC5x8zwkFilxnzEfJ3k1uWjyRq2wkCv0G1Kujty
        L1rXR029SsZSF
X-Received: by 2002:a05:6402:274f:: with SMTP id z15mr9980872edd.21.1627338900490;
        Mon, 26 Jul 2021 15:35:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyheT6CXMKsyG9MAn5wWchu1Q1SBbVv37i0TfxgebxJqCaNB+oLDXUf5DnZFls1/KaB0zGLCA==
X-Received: by 2002:a05:6402:274f:: with SMTP id z15mr9980858edd.21.1627338900296;
        Mon, 26 Jul 2021 15:35:00 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id jy17sm281162ejc.112.2021.07.26.15.34.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 15:34:59 -0700 (PDT)
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Sean Christopherson <seanjc@google.com>
References: <20210713142023.106183-1-mlevitsk@redhat.com>
 <20210713142023.106183-6-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 5/8] KVM: x86: APICv: fix race in
 kvm_request_apicv_update on SVM
Message-ID: <e8acf99c-0e3b-f0cc-c8ad-53074420d734@redhat.com>
Date:   Tue, 27 Jul 2021 00:34:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210713142023.106183-6-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/07/21 16:20, Maxim Levitsky wrote:
> +	mutex_lock(&vcpu->kvm->apicv_update_lock);
> +
>  	vcpu->arch.apicv_active = kvm_apicv_activated(vcpu->kvm);
>  	kvm_apic_update_apicv(vcpu);
>  	static_call(kvm_x86_refresh_apicv_exec_ctrl)(vcpu);
> @@ -9246,6 +9248,8 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
>  	 */
>  	if (!vcpu->arch.apicv_active)
>  		kvm_make_request(KVM_REQ_EVENT, vcpu);
> +
> +	mutex_unlock(&vcpu->kvm->apicv_update_lock);

Does this whole piece of code need the lock/unlock?  Does it work and/or 
make sense to do the unlock immediately after mutex_lock()?  This makes 
it clearer that the mutex is being to synchronize against the requestor.

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index ed4d1581d502..ba5d5d9ebc64 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -943,6 +943,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
>   	mutex_init(&kvm->irq_lock);
>   	mutex_init(&kvm->slots_lock);
>   	mutex_init(&kvm->slots_arch_lock);
> +	mutex_init(&kvm->apicv_update_lock);
>   	INIT_LIST_HEAD(&kvm->devices);
>   
>   	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
> 

Please add comments above fields that are protected by this lock 
(anything but apicv_inhibit_reasons?), and especially move it to kvm->arch.

Paolo

