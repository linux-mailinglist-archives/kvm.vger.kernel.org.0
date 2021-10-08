Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A4C42686A
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 13:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240151AbhJHLEh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 07:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239954AbhJHLEg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 07:04:36 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3166AC061570;
        Fri,  8 Oct 2021 04:02:41 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id c29so7925823pfp.2;
        Fri, 08 Oct 2021 04:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HZ0UMHO87j49x91nYlKX9DeZFDQ7q4eqUqMnNd1895o=;
        b=bqNMT1tzwQQv0g1Ep650XhgHiUPuWSF0XuYonaB74NJrJnKZEwpv11Ju+huP+rrdGq
         dzlqQnxZH+d6UR0UmnLomIdAOOGHbtqztn0N7LNJGLKsHt0mY3Y2SCZ32ZLyfXU0Hqs4
         n6ycqJYLdovK22FL1DBUAo1AXLXwbzOpaQzWW9nDKpl+/MGGKqPQrvAnxXMg602p5uHs
         NvprEZC/WHDteeUhJh2bO1ftlpWJRUkQR/JwXiREgjnn4ddoKqpaU79FVJ5BECoLYj1d
         rDsF5y211e0LRiUuEV1bpN0tgyU1RG4QCbu36QUnHjWe8Q6dKupYqWz/C5sIkxq7XjsI
         0ahw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=HZ0UMHO87j49x91nYlKX9DeZFDQ7q4eqUqMnNd1895o=;
        b=RF693BTv7SuOZm/mo9BlQD16TGh91FyZf3Z/R9G27zIRSCcWLfHQZGMIejgQjaW/7r
         /BDzHpygnKdiM9eTzMmegftk4Qqab2B0SnYoff9LAxXtU27tqzcuvYeRKFCZRoygk0mb
         smXksI6AzIwA4dQ4fSsAjkrmo2VNFw311WDNAFyS9kAA3ZmRkDeRcTZTIuc8mOcm2qFZ
         TbeZbelw20S2DmQR0p7PwXslz7IrpdNT/LiqYisKJx6EB0fRNkSazboN4+sDFlFABwvM
         l4g/4ZpdjF1raJ4LyGXCCeHdd4maeQFBoqNlmPgt9iTZULyLXLkJm+yhFCE6R9mnBbRO
         Sy1w==
X-Gm-Message-State: AOAM531PltEsgx+zcaCB+fDE7Nlo3O0pm5ItVFpgaelUrtTPnZgsKh4U
        gu78xT0cEVXiG+PINK514so=
X-Google-Smtp-Source: ABdhPJy4iAY5CM/1Kdeb/0UKFrsJpAYaAdRPrWuxU8iJsRE8CVZDpw6RHlQJLdDXa/nh8OcrxvPyBQ==
X-Received: by 2002:a62:1786:0:b0:445:1a9c:952a with SMTP id 128-20020a621786000000b004451a9c952amr9828321pfx.39.1633690960659;
        Fri, 08 Oct 2021 04:02:40 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id x21sm2336927pfa.186.2021.10.08.04.02.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Oct 2021 04:02:40 -0700 (PDT)
Subject: Re: [PATCH 2/3] KVM: vPMU: Fill get_msr MSR_CORE_PERF_GLOBAL_OVF_CTRL
 w/ 0
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>
References: <1633687054-18865-1-git-send-email-wanpengli@tencent.com>
 <1633687054-18865-2-git-send-email-wanpengli@tencent.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Message-ID: <58d59149-669f-7990-4f68-05b32ed693b5@gmail.com>
Date:   Fri, 8 Oct 2021 19:02:31 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1633687054-18865-2-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

cc Andi,

On 8/10/2021 5:57 pm, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> SDM section 18.2.3 mentioned that:
> 
>    "IA32_PERF_GLOBAL_OVF_CTL MSR allows software to clear overflow indicator(s) of
>     any general-purpose or fixed-function counters via a single WRMSR."
> 
> It is R/W mentioned by SDM, we read this msr on bare-metal during perf testing,
> the value is always 0 for CLX/SKX boxes on hands. Let's fill get_msr
> MSR_CORE_PERF_GLOBAL_OVF_CTRL w/ 0 as hardware behavior.
> 
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> Btw, xen also fills get_msr MSR_CORE_PERF_GLOBAL_OVF_CTRL 0.
> 
>   arch/x86/kvm/vmx/pmu_intel.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 10cc4f65c4ef..47260a8563f9 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -365,7 +365,7 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		msr_info->data = pmu->global_ctrl;
>   		return 0;
>   	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
> -		msr_info->data = pmu->global_ovf_ctrl;
> +		msr_info->data = 0;

Tested-by: Like Xu <likexu@tencent.com>

Further, better to drop 'u64 global_ovf_ctrl' directly.

>   		return 0;
>   	default:
>   		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
> 
