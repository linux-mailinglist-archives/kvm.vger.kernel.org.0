Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0542E49B880
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 17:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352140AbiAYQVt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 11:21:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34294 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1354301AbiAYQQx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Jan 2022 11:16:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643127413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KX6Xm8xd5XItsATHw1pCIORe/qAqaOGR19jcipUdA5w=;
        b=QNi/hxCEl1L3/ArL2gq0owvghMN0eggEkJdO4WQh2RSAr3hi0v9skSERtzMh6s2IoMD+M+
        bUY9Y07lamSZjdf21mZZj707fUCLMWI8gke/4922ZPu9Bq3YC8Gg3A8n7VTGmSFwvXd9A3
        TVb4iPv19gn7TSDapPvexgenqw86Pok=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-374-h9qZmpsgPK2pO9I_VRZutg-1; Tue, 25 Jan 2022 11:16:47 -0500
X-MC-Unique: h9qZmpsgPK2pO9I_VRZutg-1
Received: by mail-ej1-f70.google.com with SMTP id p8-20020a1709060e8800b006b39ade8c12so3624219ejf.10
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 08:16:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KX6Xm8xd5XItsATHw1pCIORe/qAqaOGR19jcipUdA5w=;
        b=tjYIdG8Hyk9HWzRShPihGhOWDDJ20LZ+v/yhME9mzy1cE+wPZ8b3TCrC37vmpDYeib
         ofYSMUyiZA9TuREjwJCGbN05t29FMvsSHxtwgaW3yge/dMQ+yRj7bLU10HFd9mD0EpwR
         WFFnYZR782/K0GHukkw7z4fnBBH5BMRQKe9L6t2KEtbU2xRxP8CDQ/dvT7C8ol1g7nNi
         gw0Ve0YyfOPNcY84/BQbUGHBfctZYou+3s/OVIF08lJlvDWE9Gx7FJjPGwySzLsciqzJ
         eHXPj8TRgJLy/US4Xzub2U+mfAG0rC26m/nkiFzmzg6Ud5Lru1tbxA5Yaic5viqCgsPz
         IHDA==
X-Gm-Message-State: AOAM532nHz+ILiRkMrcQxg1zI8MKf5ofdn9LonpkgIrj39Tv5vcRMq2c
        BJ1ACxMwOEJ6pMMASNQ3RUqJFngC/KDOUoNF6h5KtnkUQnqM90jevmtfu9ggiKpEr5Bduo4PIfc
        +cKVdLjOLhdIn
X-Received: by 2002:a05:6402:190d:: with SMTP id e13mr11203148edz.6.1643127406123;
        Tue, 25 Jan 2022 08:16:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxJYPPNAkHsi7A2wclzej5ABIz4nD7f3K3+RXhrdQ+YdD37YBKS4eHmlYrgYxSqtYu/ydCyTQ==
X-Received: by 2002:a05:6402:190d:: with SMTP id e13mr11203123edz.6.1643127405862;
        Tue, 25 Jan 2022 08:16:45 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id i16sm6376175eja.8.2022.01.25.08.16.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 08:16:45 -0800 (PST)
Message-ID: <c8206916-a510-cc4d-3b41-1f1a7d650c84@redhat.com>
Date:   Tue, 25 Jan 2022 17:16:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 11/19] KVM: x86/svm: Remove unused "vector" of
 sev_vcpu_deliver_sipi_vector()
Content-Language: en-US
To:     Jinrong Liang <ljr.kernel@gmail.com>
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220125095909.38122-1-cloudliang@tencent.com>
 <20220125095909.38122-12-cloudliang@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220125095909.38122-12-cloudliang@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/25/22 10:59, Jinrong Liang wrote:
> From: Jinrong Liang <cloudliang@tencent.com>
> 
> The "struct kvm_vcpu *vcpu" parameter of sev_vcpu_deliver_sipi_vector()
> is not used, so remove it. No functional change intended.
> 
> Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
> ---
>   arch/x86/kvm/svm/sev.c | 2 +-
>   arch/x86/kvm/svm/svm.c | 2 +-
>   arch/x86/kvm/svm/svm.h | 2 +-
>   3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 0727ac7221d7..2fd1e91054b3 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2925,7 +2925,7 @@ void sev_es_prepare_guest_switch(unsigned int cpu)
>   	hostsa->xss = host_xss;
>   }
>   
> -void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
> +void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_svm *svm = to_svm(vcpu);
>   
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 3e75ae834412..aead235a90ee 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4348,7 +4348,7 @@ static void svm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
>   	if (!sev_es_guest(vcpu->kvm))
>   		return kvm_vcpu_deliver_sipi_vector(vcpu, vector);
>   
> -	sev_vcpu_deliver_sipi_vector(vcpu, vector);
> +	sev_vcpu_deliver_sipi_vector(vcpu);
>   }
>   
>   static void svm_vm_destroy(struct kvm *kvm)
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 0a749bbda738..61c96f4a7006 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -621,7 +621,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu);
>   int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
>   void sev_es_init_vmcb(struct vcpu_svm *svm);
>   void sev_es_vcpu_reset(struct vcpu_svm *svm);
> -void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
> +void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu);
>   void sev_es_prepare_guest_switch(unsigned int cpu);
>   void sev_es_unmap_ghcb(struct vcpu_svm *svm);
>   

For this one and patch 10, even if the argument is not used, the code 
seems more natural if it is there.  It is more of an implementation 
detail that it is not used.

Paolo

