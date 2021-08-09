Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF123E461E
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 15:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235214AbhHINHc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 09:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234821AbhHINHb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 09:07:31 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8DCC0613D3;
        Mon,  9 Aug 2021 06:07:10 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id l11so4618197plk.6;
        Mon, 09 Aug 2021 06:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=INt6AMamKTURCHBhwQYi/H+ih28+y9YbRQVY0oda3OQ=;
        b=RF+TiZwOlLjqHEQ/UxdiSntRf5kvSPsYhdWZqHM0222Rv4B1IsiCFAIZMPboFd55p+
         SlSmUajD81mq/R1Bg1x6MhStb3pHCuhQrpQqW6cPlaFcq+jLfSCVB+BsvP2qXpcp+Pwa
         6mWLO3grVhk5UQvuaKEgNY7MTS89++EtHKaPwrI0Vy9Is82axNX7sxlb0FdG9q9E6thB
         uHHoPQUntfJ2D8Y0IMXoZVduxXc0uG5zmpAKQYYnH6s2pbkcaDwnmn/hv8KaiCGE+Ru+
         hAQrx/aIoMKSztedQXf1ygujFpZIOV3axKn6VdH6rM8KgqEbVcvT/hdJdcwzpGv8Qu3v
         7ahw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=INt6AMamKTURCHBhwQYi/H+ih28+y9YbRQVY0oda3OQ=;
        b=HQ5bi9aUYuX3m1hajQhzrYm/k3JP+hRzJxAmVvmAweocl47yZQ80qciAQOdE3GvCyn
         2J6YpF56lHZkZCwW7DUJpUYJuSFvtYZVN7mAWwsHbUzxgqd/RxrxRA5VT4klZwFYXFJ7
         mknHYNjlVe58XI5hbh0DaVpcqTbvYwVsQnp3azj7msSvzqHKaZfgDASF1gCHKgqExVgl
         wjMd2c2ocNEddZNvtPZ1td23lgTLl7w4XqA+xpjQRI23nJvbFhKoGge5HVdcVFFq/QXC
         3So6PdV9LR95ofHf2Jwd0wTIn/zaZyr/nBoNi1qrLai6STlTR798SubDlhsF9wVyRnmQ
         k28Q==
X-Gm-Message-State: AOAM530a/zECYauL5ade9XJ5CgfFrITsOxLuUDIbFTqLnyxZiEctAS33
        IVg+g2ZWTZluBthHT5RoJjklusNTsj7IFg==
X-Google-Smtp-Source: ABdhPJwOgGjGoHMNx/ZpkPu+WJL8ZCtgR0RxuWbJfre36P6GZYLUbloyN4qP9bWbhQrfny1QAZpP7Q==
X-Received: by 2002:a65:4682:: with SMTP id h2mr1116172pgr.409.1628514430397;
        Mon, 09 Aug 2021 06:07:10 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id b8sm18546770pjo.51.2021.08.09.06.07.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 06:07:09 -0700 (PDT)
Subject: Re: [PATCH v7 03/15] KVM: x86: Add Arch LBR MSRs to msrs_to_save_all
 list
To:     Yang Weijiang <weijiang.yang@intel.com>,
        Jim Mattson <jmattson@google.com>
References: <1628235745-26566-1-git-send-email-weijiang.yang@intel.com>
 <1628235745-26566-4-git-send-email-weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Message-ID: <f3b5364c-3e3c-eca0-f973-1658bd619e87@gmail.com>
Date:   Mon, 9 Aug 2021 21:07:01 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1628235745-26566-4-git-send-email-weijiang.yang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/8/2021 3:42 pm, Yang Weijiang wrote:
> Arch LBR MSR_ARCH_LBR_DEPTH and MSR_ARCH_LBR_CTL are {saved|restored}
> by userspace application if they're available.
> 
> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> ---
>   arch/x86/kvm/x86.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4116567f3d44..4ae173ab2208 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1327,6 +1327,7 @@ static const u32 msrs_to_save_all[] = {
>   	MSR_ARCH_PERFMON_EVENTSEL0 + 12, MSR_ARCH_PERFMON_EVENTSEL0 + 13,
>   	MSR_ARCH_PERFMON_EVENTSEL0 + 14, MSR_ARCH_PERFMON_EVENTSEL0 + 15,
>   	MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
> +	MSR_ARCH_LBR_CTL, MSR_ARCH_LBR_DEPTH,

Hi Jim,

Do you have a particular reason for not putting the set of
MSR_ARCH_LBR_{FROM, TO, INFO} into msrs_to_save_all[]
for {saved|restored} by user space ?

>   };
>   
>   static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
> @@ -6229,6 +6230,11 @@ static void kvm_init_msr_list(void)
>   			    min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
>   				continue;
>   			break;
> +		case MSR_ARCH_LBR_DEPTH:
> +		case MSR_ARCH_LBR_CTL:
> +			if (!kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
> +				continue;
> +			break;
>   		default:
>   			break;
>   		}
> 
