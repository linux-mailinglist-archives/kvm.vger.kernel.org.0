Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE6F4AEE12
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 10:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236794AbiBIJcp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 04:32:45 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:35676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235057AbiBIJa7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 04:30:59 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C9ABE0C5BE8;
        Wed,  9 Feb 2022 01:30:56 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id c5-20020a17090a1d0500b001b904a7046dso3003430pjd.1;
        Wed, 09 Feb 2022 01:30:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:organization:in-reply-to
         :content-transfer-encoding;
        bh=5JCf3O060kbSSop2cpb2bg0F0aVQnL4uVtK8Kp7eaR4=;
        b=dmQKEbuyufICCzb0Ducdg3ed34C/sqo8nRJ8SWwTzGmkjieQnq+ZeeT7dPZRpfrcsD
         T/+0l+4JDXlVvK6CZ2EkXNH8apkToMifh3sessYqh9jjU8zDXNWTNu2TPIoidk5Cgwl7
         SmFxgujepAQ8eW6uiE+c7PpfXX7dJHmc1xwf7GcaUDV4bwiZbDKa8QBMSA2QNmDZtZd3
         GQkl0NBeHp6PcLSwKRe5KcLwyVKpERlexruONsb5k2QjjP8fVWvSi02PVy3FSd/+k7JA
         S4pGtGsak5HOr47b+JIWYsgG81/2T9WtbGBV7mJHpo4U1DjyDHHsXQdvlZaknjIa41Am
         wSew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:organization:in-reply-to
         :content-transfer-encoding;
        bh=5JCf3O060kbSSop2cpb2bg0F0aVQnL4uVtK8Kp7eaR4=;
        b=x2OWa5uvUbTkqHzrO4h69pR02pGaWSeSnh2oDQaBsDpoRuwWqGPra6sNrvNEve5Yee
         JSv64Tn/88QIBeNTLFaDqUPXBaoiIAINYWwp8OtecClBMB7uX/g+bg7lwRXbbNwMRheR
         OAWVKhWKuukgBLnrpYJIeiaTd5ILIYGcw1JPfj2MHnXnPwcbFvZC+MFWOgnkLgZaxaaR
         8v8URxQw3jLmnXrkwVzKa4RIfCwXZX4bQB9xaH36S8Olfr8fq3A2GwMWRR1R+WYKyKXQ
         VpfVxoNbMgSgYLGPdKbeODlc3xpDt6l/+fohWqO+kptG7+0toHvBe2Ib16jRBmauTYHW
         djlg==
X-Gm-Message-State: AOAM532r3eAEF8j9EVlk6k/JcOU1QlJ/MoDuklECr4hfpkQAyyGfFqq4
        OKXsXJbx1jV6pRFknNIGD+g=
X-Google-Smtp-Source: ABdhPJzTrZWO2VNfOhplT+u4kBtvyPgCVdMGaBIGEABbveTXYSqVS6ytt0fRPBV1gli1C3tuNl66zg==
X-Received: by 2002:a17:902:b215:: with SMTP id t21mr1255668plr.73.1644399004379;
        Wed, 09 Feb 2022 01:30:04 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id md9sm5462893pjb.6.2022.02.09.01.30.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 01:30:04 -0800 (PST)
Message-ID: <43e6dad3-dfdf-ba4a-cd95-99eca2538384@gmail.com>
Date:   Wed, 9 Feb 2022 17:29:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH] KVM: x86/cpuid: Stop exposing unknown AMX Tile Palettes
 and accelerator units
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220117065957.65335-1-likexu@tencent.com>
Organization: Tencent
In-Reply-To: <20220117065957.65335-1-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

KVM does not have much filtering in exposing the host cpuid (at least for Intel 
PT and AMX),
and innocent user spaces could be corrupted when unknown new bits are 
accidentally exposed.

Comments on code changes in this direction are welcome.

+ https://lore.kernel.org/kvm/20220112041100.26769-1-likexu@tencent.com/

On 17/1/2022 2:59 pm, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> Guest enablement of Intel AMX requires a good co-work from both host and
> KVM, which means that KVM should take a more safer approach to avoid
> the accidental inclusion of new unknown AMX features, even though it's
> designed to be an extensible architecture.
> 
> Per current spec, Intel CPUID Leaf 1EH sub-leaf 1 and above are reserved,
> other bits in leaves 0x1d and 0x1e marked as "Reserved=0" shall be strictly
> limited by definition for reporeted KVM_GET_SUPPORTED_CPUID.
> 
> Fixes: 690a757d610e ("kvm: x86: Add CPUID support for Intel AMX")
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>   arch/x86/kvm/cpuid.c | 12 ++++++++----
>   1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index c55e57b30e81..3fde6610d314 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -661,7 +661,6 @@ static struct kvm_cpuid_entry2 *do_host_cpuid(struct kvm_cpuid_array *array,
>   	case 0x17:
>   	case 0x18:
>   	case 0x1d:
> -	case 0x1e:
>   	case 0x1f:
>   	case 0x8000001d:
>   		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
> @@ -936,21 +935,26 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>   		break;
>   	/* Intel AMX TILE */
>   	case 0x1d:
> +		entry->ebx = entry->ecx = entry->edx = 0;
>   		if (!kvm_cpu_cap_has(X86_FEATURE_AMX_TILE)) {
> -			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
> +			entry->eax = 0;
>   			break;
>   		}
>   
> +		entry->eax = min(entry->eax, 1u);
>   		for (i = 1, max_idx = entry->eax; i <= max_idx; ++i) {
>   			if (!do_host_cpuid(array, function, i))
>   				goto out;
>   		}
>   		break;
> -	case 0x1e: /* TMUL information */
> +	/* TMUL Information */
> +	case 0x1e:
> +		entry->eax = entry->ecx = entry->edx = 0;
>   		if (!kvm_cpu_cap_has(X86_FEATURE_AMX_TILE)) {
> -			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
> +			entry->ebx = 0;
>   			break;
>   		}
> +		entry->ebx &= 0xffffffu;
>   		break;
>   	case KVM_CPUID_SIGNATURE: {
>   		const u32 *sigptr = (const u32 *)KVM_SIGNATURE;
