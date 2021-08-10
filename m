Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E173E808E
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 19:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234837AbhHJRuw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 13:50:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58710 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234940AbhHJRsH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 13:48:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628617664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eKwZewLNwIKw9eTm9yw5mCeEiy999huF3GYCsztRI6w=;
        b=QpX4dFcEoRda8wHi0l+jfckndBt5nk/SUi/rOFHzknr3hlJ8ZQ61nWzcy/F2r/FQRN5Hi/
        eGa7M9zt63/1jgFp3wZram/oMKLqerFgTkCVZW6APLJvRZwavGo5nAjfRe3ZK71ydQTme0
        SB1E00yGwCMN1PhEBBKw9HhsXTZa4CY=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-496-KEIejYtROHW4hPEBXK3pTA-1; Tue, 10 Aug 2021 13:47:41 -0400
X-MC-Unique: KEIejYtROHW4hPEBXK3pTA-1
Received: by mail-ej1-f72.google.com with SMTP id ne21-20020a1709077b95b029057eb61c6fdfso5888619ejc.22
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 10:47:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eKwZewLNwIKw9eTm9yw5mCeEiy999huF3GYCsztRI6w=;
        b=okflBmBLR5x2sUYZJlHFuxqizSBvsbr1yelCg8TcASur/dGF0k7U3Me/xsM/bbLUqi
         ehBcitnvsRe0pCB/SRsDSk+XQ38GAWq1+7Bza9vjuw7PbMDhbswvvHZwC5kvZadG1V8L
         D/4h3o3KoZ/nB1194zZMj4ENEu9TX0i+cWeb6hPYYOgZQDeTjlozbR0a5JDJMxBuAxcG
         mlcjUO5F8z4QL7u85LMIRuv4LsvT7RE0wtuX/GQ0f5Ib5Dcp7lHwYIqjUb4pGqPUgzvM
         VoYD4GQNQmxPybq2508Jq/+88KgOc58sOldEC/js7aneyrsDehhCztlH1qmQkvYMtSvw
         BOMw==
X-Gm-Message-State: AOAM530bu7O5P3WA/60rJFcbY/34B2rJyFbx7i6Ji3OX4Wtd30Hzg8AD
        j7cNTf22++Br5+HcUTLYbny5Oo7CuJbHVzJDvEj1n9ylu19euXidcqsXz0SEZOE80SEYYp7EhV8
        Ya+MMxIHqbRpO
X-Received: by 2002:a05:6402:3128:: with SMTP id dd8mr6456932edb.40.1628617659919;
        Tue, 10 Aug 2021 10:47:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz+ES4XSZWUizraO18WCMcWHJOOU0rhg3kEBHAyUa+hl1Ftwln9z4N1I5esSDtKj6taDpZdMQ==
X-Received: by 2002:a05:6402:3128:: with SMTP id dd8mr6456908edb.40.1628617659705;
        Tue, 10 Aug 2021 10:47:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id n13sm7133872ejk.97.2021.08.10.10.47.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 10:47:38 -0700 (PDT)
Subject: Re: [PATCH 2/5] KVM: x86: Clean up redundant CC macro definition
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210809093410.59304-1-likexu@tencent.com>
 <20210809093410.59304-3-likexu@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <26603f6e-f215-af19-1cf3-2e0022c20750@redhat.com>
Date:   Tue, 10 Aug 2021 19:47:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210809093410.59304-3-likexu@tencent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/08/21 11:34, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> With the exception of drivers/dma/pl330.c, the CC macro is defined and used
> in {svm, vmx}/nested.c, and the KVM_NESTED_VMENTER_CONSISTENCY_CHECK
> macro it refers to is defined in x86.h, so it's safe to move it into x86.h
> without intended functional changes.
> 
> Signed-off-by: Like Xu <likexu@tencent.com>

This one is just a shortcut that should not available outside nested.c, 
so I am not applying it.

Paolo

> ---
>   arch/x86/kvm/svm/nested.c | 2 --
>   arch/x86/kvm/vmx/nested.c | 2 --
>   arch/x86/kvm/x86.h        | 2 ++
>   3 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 5e13357da21e..57c288ba6ef0 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -29,8 +29,6 @@
>   #include "lapic.h"
>   #include "svm.h"
>   
> -#define CC KVM_NESTED_VMENTER_CONSISTENCY_CHECK
> -
>   static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
>   				       struct x86_exception *fault)
>   {
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 0d0dd6580cfd..404db7c854d2 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -22,8 +22,6 @@ module_param_named(enable_shadow_vmcs, enable_shadow_vmcs, bool, S_IRUGO);
>   static bool __read_mostly nested_early_check = 0;
>   module_param(nested_early_check, bool, S_IRUGO);
>   
> -#define CC KVM_NESTED_VMENTER_CONSISTENCY_CHECK
> -
>   /*
>    * Hyper-V requires all of these, so mark them as supported even though
>    * they are just treated the same as all-context.
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 6aac4a901b65..b8a024b0f91c 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -67,6 +67,8 @@ static __always_inline void kvm_guest_exit_irqoff(void)
>   	failed;								\
>   })
>   
> +#define CC KVM_NESTED_VMENTER_CONSISTENCY_CHECK
> +
>   #define KVM_DEFAULT_PLE_GAP		128
>   #define KVM_VMX_DEFAULT_PLE_WINDOW	4096
>   #define KVM_DEFAULT_PLE_WINDOW_GROW	2
> 

