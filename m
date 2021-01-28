Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13D01307D01
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 18:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbhA1Ruq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 12:50:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56639 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232140AbhA1RsJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 12:48:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611856003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LC0E1GpRXLDOlCRnDuGLRoZ/gZ1WsR+3WhMw6k9lWck=;
        b=BdYvzoUTOSn0qhDohoY0x8/Tt6CVZBKBIE1D7IyVo32WEiTorKWUAV8PpgdO9fs7DbsKeP
        50KswuQV34/JU4I+lKFFYdIDN20NQ0NBlxO8dzect2P7RYUonnAyhUvS56oeyMcymoa/F5
        ZqxY/kRaV7NXmOG1zQOUuEh/EygFdM0=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-6wbyEaa_Pdmc2fOAYGZTrA-1; Thu, 28 Jan 2021 12:46:41 -0500
X-MC-Unique: 6wbyEaa_Pdmc2fOAYGZTrA-1
Received: by mail-ej1-f71.google.com with SMTP id jg11so2546590ejc.23
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 09:46:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LC0E1GpRXLDOlCRnDuGLRoZ/gZ1WsR+3WhMw6k9lWck=;
        b=GNxCz478+WyIM32KMFhTJ4uWqwGb/zE/tdgXxYUin+vAYkpTMBeH33CRoIDgxmfkHU
         AbSMN1xUCUpJWbnfY0PLTCUHrfHbpkdqylfcFa02e9bjESxRIG5AAoC4TOqn5hBseQjq
         ObjzY/TFwA9Zv5sDGTLeTm6Hemi0V301174wKZbh0ELe7z2CSOlswg5/Ya8jy6K7/6Pe
         Hu2eaMthbol5Z+ddS+PADdJTxRlqOnqTeJILSjVkH2cOVGgpvtNdQgbjy2m+CYx2RoNk
         ev1+TRHKEq67if6+gUbrbVou3ef0Km8C9bgVAMAOuXpjAiycg2c084yj3MBuqc59r0ds
         YSXg==
X-Gm-Message-State: AOAM531kVKuRONC3E+x1gw0IyC99Qwt0vp4ZXdXBWSX96IVXspgaifyT
        WYA8vUYy9K5Rwqbh70JWR/H8X7jo/Gu+PqOh3VU5NRE1VeE30B4xkK5WUdNUeR3ak+ZsUipMblS
        422pN7t+4cQiB
X-Received: by 2002:a17:906:828a:: with SMTP id h10mr561812ejx.274.1611856000012;
        Thu, 28 Jan 2021 09:46:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx24S50DQWrrL/lhjofPmbZeVFy27BpQwBeKPaYtvSBcFcfEwdtL6gv9LpQbFpeocwr5Fnq5g==
X-Received: by 2002:a17:906:828a:: with SMTP id h10mr561795ejx.274.1611855999798;
        Thu, 28 Jan 2021 09:46:39 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z13sm3322394edc.73.2021.01.28.09.46.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 09:46:38 -0800 (PST)
Subject: Re: [PATCH v14 09/13] KVM: x86: Report CET MSRs as to-be-saved if CET
 is supported
To:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com
References: <20201106011637.14289-1-weijiang.yang@intel.com>
 <20201106011637.14289-10-weijiang.yang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <732d1da2-70d7-1f8a-b41d-136e068516d7@redhat.com>
Date:   Thu, 28 Jan 2021 18:46:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201106011637.14289-10-weijiang.yang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/11/20 02:16, Yang Weijiang wrote:
> Report all CET MSRs, including the synthetic GUEST_SSP MSR, as
> to-be-saved, e.g. for migration, if CET is supported by KVM.
> 
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>   arch/x86/kvm/x86.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 751b62e871e5..d573cadf5baf 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1248,6 +1248,8 @@ static const u32 msrs_to_save_all[] = {
>   	MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
>   
>   	MSR_IA32_XSS,
> +	MSR_IA32_U_CET, MSR_IA32_S_CET, MSR_IA32_INT_SSP_TAB, MSR_KVM_GUEST_SSP,
> +	MSR_IA32_PL0_SSP, MSR_IA32_PL1_SSP, MSR_IA32_PL2_SSP, MSR_IA32_PL3_SSP,
>   };
>   
>   static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
> @@ -5761,6 +5763,13 @@ static void kvm_init_msr_list(void)
>   			if (!supported_xss)
>   				continue;
>   			break;
> +		case MSR_IA32_U_CET:
> +		case MSR_IA32_S_CET:
> +		case MSR_IA32_INT_SSP_TAB:
> +		case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> +			if (!kvm_cet_supported())
> +				continue;
> +			break;
>   		default:
>   			break;
>   		}
> 

Missing "case MSR_KVM_GUEST_SSP".

Paolo

