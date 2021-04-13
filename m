Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2E435E15C
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 16:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbhDMO1R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 10:27:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44463 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231856AbhDMO1Q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Apr 2021 10:27:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618324016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wBRPv3G5uNqKDsSO2MfNKj8YoTGefde97SCfUlwiDUw=;
        b=cc3cwT2WJPhaevOi9k10cDUc91ktri8/za5CS4ofPgteOe87ABupMeA4+uO8Jlydqh3PMh
        UYHgAVBdVtrLKo8ZEOSW482fusddBLKQ44nwOAUCcMvZeGvxoNJWHCXcOSjbqtIgzaWbKB
        DGQJu/E89FtZr230DH3+DTDNYQgDIjE=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-BHoqLJfqMiyc3HQ0HQx5Nw-1; Tue, 13 Apr 2021 10:26:55 -0400
X-MC-Unique: BHoqLJfqMiyc3HQ0HQx5Nw-1
Received: by mail-ej1-f72.google.com with SMTP id di5so5121034ejc.1
        for <kvm@vger.kernel.org>; Tue, 13 Apr 2021 07:26:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=wBRPv3G5uNqKDsSO2MfNKj8YoTGefde97SCfUlwiDUw=;
        b=f+4QbIwiEZkI9QYUiV23lINRbeiV/OzaQiZ6gD3y8W83A5xbNtTBVn+hJe358GtqfB
         jbn4OLSHFIZZbFMUk8fX/Qyg0v9aZxsz6L6G5tyKHjIFwRX/tjwtDJpqjkMEg0m6XqEC
         zxPf4+N0PCPFTr6eVi3Gy3FA3bvrN0Z+uyWCry95vCalxe6JrDlOkg0Vajc39iG4UGRc
         B6FsyjJ7eYOk1Vg/L+OKCU5rd2XttI4KMCd1x9fbSLla1eTRPfrmtARI/PtouSeNYPq0
         S+oJhI3j5e9V/+MANiUB6XPLcj/2BomdIGrd04aGzq3yCcMUSKtG5Eu6eiCOU1ZSIz5K
         DsLQ==
X-Gm-Message-State: AOAM532HrjVR4nWVjd7eC407zP6a14CLOONaB3/soTtvuT7Fydu2+Jsg
        AVqVOtBwWVrKvPFBetLxw7AurCYvYUEghgBwiJjicRqC5a3e2fey9qt/SKpMl4vYD5DmAiM7yl5
        X0mWdIQlz8I7c
X-Received: by 2002:a05:6402:344e:: with SMTP id l14mr35655737edc.184.1618324013943;
        Tue, 13 Apr 2021 07:26:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyl2wCg7G5ZLN6NTfXLLG6LDFnftmIdSKu81ij0nvsNsooVaOdHUB697PVzQlupmIvKSlGHzA==
X-Received: by 2002:a05:6402:344e:: with SMTP id l14mr35655703edc.184.1618324013808;
        Tue, 13 Apr 2021 07:26:53 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id nb29sm7767985ejc.118.2021.04.13.07.26.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 07:26:53 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Siddharth Chandrasekaran <sidcha@amazon.de>
Cc:     Alexander Graf <graf@amazon.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v2 4/4] KVM: hyper-v: Advertise support for fast XMM
 hypercalls
In-Reply-To: <5ec20918b06cad17cb43f04be212c5e21c18caea.1618244920.git.sidcha@amazon.de>
References: <cover.1618244920.git.sidcha@amazon.de>
 <5ec20918b06cad17cb43f04be212c5e21c18caea.1618244920.git.sidcha@amazon.de>
Date:   Tue, 13 Apr 2021 16:26:52 +0200
Message-ID: <87pmyy5kgj.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Siddharth Chandrasekaran <sidcha@amazon.de> writes:

> Now that all extant hypercalls that can use XMM registers (based on
> spec) for input/outputs are patched to support them, we can start
> advertising this feature to guests.
>
> Cc: Alexander Graf <graf@amazon.com>
> Cc: Evgeny Iakovlev <eyakovl@amazon.de>
> Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
> ---
>  arch/x86/include/asm/hyperv-tlfs.h | 7 ++++++-
>  arch/x86/kvm/hyperv.c              | 2 ++
>  2 files changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
> index e6cd3fee562b..716f12be411e 100644
> --- a/arch/x86/include/asm/hyperv-tlfs.h
> +++ b/arch/x86/include/asm/hyperv-tlfs.h
> @@ -52,7 +52,7 @@
>   * Support for passing hypercall input parameter block via XMM
>   * registers is available
>   */
> -#define HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE		BIT(4)
> +#define HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE		BIT(4)
>  /* Support for a virtual guest idle state is available */
>  #define HV_X64_GUEST_IDLE_STATE_AVAILABLE		BIT(5)
>  /* Frequency MSRs available */
> @@ -61,6 +61,11 @@
>  #define HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE		BIT(10)
>  /* Support for debug MSRs available */
>  #define HV_FEATURE_DEBUG_MSRS_AVAILABLE			BIT(11)
> +/*
> + * Support for returning hypercall ouput block via XMM
> + * registers is available
> + */
> +#define HV_X64_HYPERCALL_XMM_OUTPUT_AVAILABLE		BIT(15)
>  /* stimer Direct Mode is available */
>  #define HV_STIMER_DIRECT_MODE_AVAILABLE			BIT(19)
>  
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 1f9959aba70d..55838c266bcd 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -2254,6 +2254,8 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>  			ent->ebx |= HV_POST_MESSAGES;
>  			ent->ebx |= HV_SIGNAL_EVENTS;
>  
> +			ent->edx |= HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE;
> +			ent->edx |= HV_X64_HYPERCALL_XMM_OUTPUT_AVAILABLE;
>  			ent->edx |= HV_FEATURE_FREQUENCY_MSRS_AVAILABLE;
>  			ent->edx |= HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE;

With 'ouput' typo fixed,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

