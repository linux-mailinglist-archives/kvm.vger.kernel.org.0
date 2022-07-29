Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89A9E584D7B
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 10:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235344AbiG2IjX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 04:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235312AbiG2IjT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 04:39:19 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24BBD82465;
        Fri, 29 Jul 2022 01:39:18 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id w10so4038610plq.0;
        Fri, 29 Jul 2022 01:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=2AbhP7nYSXJ/AwHwJRTqRpQ/jkqcGYTg4SSpWNa0cho=;
        b=cTPOeA4SNer+m/gzVeE7O8aiqdYLyPd0xJW13gu9Au9jVb0lnxPQE9p6pnVesSvgiP
         vAuToV1S8trG+5Rc4sx9PO/Iy+ZXrnDSAUpSLQ6h69NpdmALkIMmvqBENdEBuOAH46OD
         OWxA/AEdwjYAFDZ+n1Uz4helnj27lBNWiZ1T5pZiZabFQeqGIcpqxwIGKpHNnuTuSXgK
         RmEGJu0ZrPlTyFhzylF/I0kvUftrCmZGwxREbW2qLjO7Sufvbfhqqo5eGoEoLNKUWVq1
         Ck7DpuJm/jUlR28ZgHxuiC5tPnzLBHEApE8Cn3zvN5ZGblGYaFW5QONGRASCvX6Z4r+c
         d4eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2AbhP7nYSXJ/AwHwJRTqRpQ/jkqcGYTg4SSpWNa0cho=;
        b=2/PfmM5YUOGRje7rwULPJyOQ42ujabHs4sjNqSE4R5RvMqL/6+lKh+kA16zWy98MZI
         tE8IspkfdQwdfxdpPsAk+6rVclIvyY6sb/Nz3OBHAnzQUKFZ5BWLUIeGbb65y77PApeu
         APzO/x2Chy1MbDkeaomctsPP1/ItLKWJYL8t5z0KVtFyKbIOrtgfmlXhXs3EqaE+lu2+
         ck6TzL33jfEs8BpZNwT+M+c7d2pai3K/g2jStzG9Jms66MtK5KR+dhbNB9QPPNd3VrhV
         e13hi4mx9v6gCDXmxcpZz4qSTktnMncyv6DGXy3q5Zin5eXQ1FMP2xoIN0ledWDgSQTK
         Bcqg==
X-Gm-Message-State: ACgBeo0t99VorJxCElRldFCF6X1ytGc4GF6/Exlu+ftvxNXELvOvgrt6
        ggrXJg+VFJ6hzGuH0V7GcUidvtkMicQxYg==
X-Google-Smtp-Source: AA6agR6VLy0FI44h+215DMEk8iu1CRWcjFQblN+FTlbd6OKxYClom6nK0LRkzmfFffvmcSCrh7D0DQ==
X-Received: by 2002:a17:90a:5b0d:b0:1f3:137d:7927 with SMTP id o13-20020a17090a5b0d00b001f3137d7927mr2926251pji.18.1659083957512;
        Fri, 29 Jul 2022 01:39:17 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id x26-20020aa79a5a000000b00525521a288dsm2284407pfj.28.2022.07.29.01.39.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jul 2022 01:39:16 -0700 (PDT)
Message-ID: <5f93760c-cb93-2c58-11d7-f9ddef7f640c@gmail.com>
Date:   Fri, 29 Jul 2022 16:39:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH 2/3] KVM: VMX: Use proper type-safe functions for vCPU =>
 LBRs helpers
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220727233424.2968356-1-seanjc@google.com>
 <20220727233424.2968356-3-seanjc@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20220727233424.2968356-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/7/2022 7:34 am, Sean Christopherson wrote:
> Turn vcpu_to_lbr_desc() and vcpu_to_lbr_records() into functions in order
> to provide type safety, to document exactly what they return, and to

Considering the prevalence of similar practices, perhaps we (at least me)
need doc more benefits of "type safety" or the risks of not doing so.

> allow consuming the helpers in vmx.h.  Move the definitions as necessary
> (the macros "reference" to_vmx() before its definition).
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/vmx/vmx.h | 26 +++++++++++++++++---------
>   1 file changed, 17 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 286c88e285ea..690421b7d26c 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -6,6 +6,7 @@
>   
>   #include <asm/kvm.h>
>   #include <asm/intel_pt.h>
> +#include <asm/perf_event.h>
>   
>   #include "capabilities.h"
>   #include "kvm_cache_regs.h"
> @@ -91,15 +92,6 @@ union vmx_exit_reason {
>   	u32 full;
>   };
>   
> -#define vcpu_to_lbr_desc(vcpu) (&to_vmx(vcpu)->lbr_desc)
> -#define vcpu_to_lbr_records(vcpu) (&to_vmx(vcpu)->lbr_desc.records)

More targets can be found in the arch/x86/kvm/pmu.h:

#define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu)
#define pmu_to_vcpu(pmu)  (container_of((pmu), struct kvm_vcpu, arch.pmu))
#define pmc_to_pmu(pmc)   (&(pmc)->vcpu->arch.pmu)

> -
> -void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu);
> -bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu);
> -
> -int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu);
> -void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu);

Unrelated move, but no reason not to do so opportunistically.

> -
>   struct lbr_desc {
>   	/* Basic info about guest LBR records. */
>   	struct x86_pmu_lbr records;
> @@ -524,6 +516,22 @@ static inline struct vcpu_vmx *to_vmx(struct kvm_vcpu *vcpu)
>   	return container_of(vcpu, struct vcpu_vmx, vcpu);
>   }
>   
> +static inline struct lbr_desc *vcpu_to_lbr_desc(struct kvm_vcpu *vcpu)
> +{
> +	return &to_vmx(vcpu)->lbr_desc;
> +}
> +
> +static inline struct x86_pmu_lbr *vcpu_to_lbr_records(struct kvm_vcpu *vcpu)
> +{
> +	return &vcpu_to_lbr_desc(vcpu)->records;
> +}
> +
> +void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu);
> +bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu);
> +
> +int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu);
> +void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu);
> +
>   static inline unsigned long vmx_get_exit_qual(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_vmx *vmx = to_vmx(vcpu);
