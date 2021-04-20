Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6993655B9
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 11:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbhDTJsU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 05:48:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33415 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231438AbhDTJsM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 05:48:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618912061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bVDi/lRKyldoeNVBBM3pbdbQ6CqtTOJB+nDOMn2FFKA=;
        b=DrGxl6CAGqRwJOSdmzbR0aVIkGFRxttwe2FX84HgtUPfn0hvvNJRzpwmNrCSrzUKtnTs1+
        qyE6iUuHEhRTyhWtfrVxbCu+GCa11kPkjKK5C7ruA/gjCHibRpAJWvufMZnvIvUlD0MsXk
        6ejpIAbn0WrI8W19moUsSFLxEDbBl4U=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-602--kDqja4bPq2-rrV-wBxu4w-1; Tue, 20 Apr 2021 05:47:39 -0400
X-MC-Unique: -kDqja4bPq2-rrV-wBxu4w-1
Received: by mail-ed1-f72.google.com with SMTP id o4-20020a0564024384b0290378d45ecf57so12917209edc.12
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 02:47:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bVDi/lRKyldoeNVBBM3pbdbQ6CqtTOJB+nDOMn2FFKA=;
        b=JXgEFeNfGhv4aE/jq+kv8dmUbiYa5Mv4xwKzS5wFJYAzEGqnQEVLGD5A+tPV7CzXJy
         ZKawwal/AdX7ONfOCbHr3tdU9qfT9yQPsP9OPCH0Mj0+thMvUDTtm4IW2zgJWbNPKR9m
         zrrjcw1ZWLdWRNa973r5weyFxY1IU3tEZv82ss5PQt6jKGgCvxC/sM97BIiw29hBe4WN
         B15mU55ZJcftS0Ieu13ooPXENc+PTJdtX/y7f3PuUFHwqlYWVm0B9+e3J5zBc6icXEj9
         GO5gm0kg+pdatYbyujPZ0DJ91uEWMfa/LLOZU9nha7dNmNZ7myjXzaOEh1iFZp3b0m7b
         4byQ==
X-Gm-Message-State: AOAM531X1JSkpNMgKh7xra4nDV5DnEbUu3AEgptPguG3/zShUuLP/GXP
        vg5yRDP9UDg/Ak8x5rNN5R5PS37Cstt5+UGFjMz9TInPy2x2KC6WgpQSygwmnqiePKvWLNtPXPO
        SA2SJNBbgpx4/
X-Received: by 2002:a05:6402:5149:: with SMTP id n9mr30497688edd.195.1618912056826;
        Tue, 20 Apr 2021 02:47:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhMZrQSldyakYEaZC6AS5CmQFDfgNlHmxgl3WD87k/fK3UEyKkefZ5a1EsyFol8jgK2bTY2w==
X-Received: by 2002:a05:6402:5149:: with SMTP id n9mr30497674edd.195.1618912056670;
        Tue, 20 Apr 2021 02:47:36 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z4sm13927171edb.97.2021.04.20.02.47.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 02:47:36 -0700 (PDT)
Subject: Re: [PATCH v13 10/12] KVM: x86: Introduce new
 KVM_FEATURE_SEV_LIVE_MIGRATION feature & Custom MSR.
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
References: <cover.1618498113.git.ashish.kalra@amd.com>
 <3232806199b2f4b307d28f6fd4f756d487b4e482.1618498113.git.ashish.kalra@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <34df8458-3dbf-d03d-d7f6-56e7e6abfb2a@redhat.com>
Date:   Tue, 20 Apr 2021 11:47:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <3232806199b2f4b307d28f6fd4f756d487b4e482.1618498113.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/04/21 17:58, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Add new KVM_FEATURE_SEV_LIVE_MIGRATION feature for guest to check
> for host-side support for SEV live migration. Also add a new custom
> MSR_KVM_SEV_LIVE_MIGRATION for guest to enable the SEV live migration
> feature.
> 
> MSR is handled by userspace using MSR filters.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Reviewed-by: Steve Rutherford <srutherford@google.com>

Let's leave the MSR out for now and rename the feature to 
KVM_FEATURE_HC_PAGE_ENC_STATUS.

Paolo

> ---
>   Documentation/virt/kvm/cpuid.rst     |  5 +++++
>   Documentation/virt/kvm/msr.rst       | 12 ++++++++++++
>   arch/x86/include/uapi/asm/kvm_para.h |  4 ++++
>   arch/x86/kvm/cpuid.c                 |  3 ++-
>   4 files changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
> index cf62162d4be2..0bdb6cdb12d3 100644
> --- a/Documentation/virt/kvm/cpuid.rst
> +++ b/Documentation/virt/kvm/cpuid.rst
> @@ -96,6 +96,11 @@ KVM_FEATURE_MSI_EXT_DEST_ID        15          guest checks this feature bit
>                                                  before using extended destination
>                                                  ID bits in MSI address bits 11-5.
>   
> +KVM_FEATURE_SEV_LIVE_MIGRATION     16          guest checks this feature bit before
> +                                               using the page encryption state
> +                                               hypercall to notify the page state
> +                                               change
> +
>   KVM_FEATURE_CLOCKSOURCE_STABLE_BIT 24          host will warn if no guest-side
>                                                  per-cpu warps are expected in
>                                                  kvmclock
> diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
> index e37a14c323d2..020245d16087 100644
> --- a/Documentation/virt/kvm/msr.rst
> +++ b/Documentation/virt/kvm/msr.rst
> @@ -376,3 +376,15 @@ data:
>   	write '1' to bit 0 of the MSR, this causes the host to re-scan its queue
>   	and check if there are more notifications pending. The MSR is available
>   	if KVM_FEATURE_ASYNC_PF_INT is present in CPUID.
> +
> +MSR_KVM_SEV_LIVE_MIGRATION:
> +        0x4b564d08
> +
> +	Control SEV Live Migration features.
> +
> +data:
> +        Bit 0 enables (1) or disables (0) host-side SEV Live Migration feature,
> +        in other words, this is guest->host communication that it's properly
> +        handling the shared pages list.
> +
> +        All other bits are reserved.
> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> index 950afebfba88..f6bfa138874f 100644
> --- a/arch/x86/include/uapi/asm/kvm_para.h
> +++ b/arch/x86/include/uapi/asm/kvm_para.h
> @@ -33,6 +33,7 @@
>   #define KVM_FEATURE_PV_SCHED_YIELD	13
>   #define KVM_FEATURE_ASYNC_PF_INT	14
>   #define KVM_FEATURE_MSI_EXT_DEST_ID	15
> +#define KVM_FEATURE_SEV_LIVE_MIGRATION	16
>   
>   #define KVM_HINTS_REALTIME      0
>   
> @@ -54,6 +55,7 @@
>   #define MSR_KVM_POLL_CONTROL	0x4b564d05
>   #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
>   #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
> +#define MSR_KVM_SEV_LIVE_MIGRATION	0x4b564d08
>   
>   struct kvm_steal_time {
>   	__u64 steal;
> @@ -136,4 +138,6 @@ struct kvm_vcpu_pv_apf_data {
>   #define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
>   #define KVM_PV_EOI_DISABLED 0x0
>   
> +#define KVM_SEV_LIVE_MIGRATION_ENABLED BIT_ULL(0)
> +
>   #endif /* _UAPI_ASM_X86_KVM_PARA_H */
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 6bd2f8b830e4..4e2e69a692aa 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -812,7 +812,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>   			     (1 << KVM_FEATURE_PV_SEND_IPI) |
>   			     (1 << KVM_FEATURE_POLL_CONTROL) |
>   			     (1 << KVM_FEATURE_PV_SCHED_YIELD) |
> -			     (1 << KVM_FEATURE_ASYNC_PF_INT);
> +			     (1 << KVM_FEATURE_ASYNC_PF_INT) |
> +			     (1 << KVM_FEATURE_SEV_LIVE_MIGRATION);
>   
>   		if (sched_info_on())
>   			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
> 

