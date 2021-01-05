Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 024682EAA29
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 12:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729793AbhAELsz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 06:48:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37597 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729791AbhAELsz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Jan 2021 06:48:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609847248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ClUuOmIXrBPfDVSqFPOKOMOGcWLMSgCQAXE3Y+wG7Kk=;
        b=ZWDD9FszUOnwQTKvzWU1znMZIiz+tnk7RF5XbM7effrG2DN3XjDobLYuxF52q7XH2RGvGQ
        62SvimLkgbWHKG59ZxzQ5C6RAR5z80LdjIW36mz9yirum3kor3QlMsbel+cTTMItXzEAHA
        r6htS17d+F1+TCFKPdkcYz9uTUL79VU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-EJkwCziqPrG0DoQtqa5jUw-1; Tue, 05 Jan 2021 06:47:26 -0500
X-MC-Unique: EJkwCziqPrG0DoQtqa5jUw-1
Received: by mail-wr1-f70.google.com with SMTP id d2so14669202wrr.5
        for <kvm@vger.kernel.org>; Tue, 05 Jan 2021 03:47:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ClUuOmIXrBPfDVSqFPOKOMOGcWLMSgCQAXE3Y+wG7Kk=;
        b=d7fviAjnCzqs96mu4aPie09MF3TiulV0geUkpEmmy6yuPf1+kwUCWUhuODmD3ZdSaA
         dzf6hVH+TmvhAvx0hKtaJLyT1kaO8wYhLkCr8RmWilTGNgXpuOKXswRrSZI0yB/l+HR3
         G3ysIERufMbzOCxvkLHPTWEc2A8VxKYtCEn0ayJHtsdq7WKy+SvWpl7IGViiMrMo2i9c
         udoLep7SNJ9tURYDSdRzC+MI8noGcaqfkzqPMzhA8J1PHvTLtMy2t8CT1GzUGJjF9n/b
         B0SxBIJ/ZUrSgMmzMa2SPHqkPDhuSnPFtm7lFn3IRsJAIYkdc1m/yhmrDyMIphsd2V9C
         2fvA==
X-Gm-Message-State: AOAM533KCbN49Y+BItZGbYKN72k/XXCzR5AkR+I2NImf44OttjeW9VaU
        TyHSBzgzX8xxz8VV/FwVwf10jsoIUxaH9q/iaYC3BOmVmkfr8vY+aEtcSG1YvAkjgMg7szjl4bx
        P0UNzQUbrQua7
X-Received: by 2002:adf:f891:: with SMTP id u17mr85387365wrp.253.1609847245441;
        Tue, 05 Jan 2021 03:47:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx9I904n6T6jfhAhM0sgcAhzqezyiAlcELO+BwqoCvvPl9Z7tOkscAOuPKTxJP3uSvTmSjxlw==
X-Received: by 2002:adf:f891:: with SMTP id u17mr85387347wrp.253.1609847245243;
        Tue, 05 Jan 2021 03:47:25 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f77sm3622230wmf.42.2021.01.05.03.47.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jan 2021 03:47:24 -0800 (PST)
Subject: Re: [PATCH 1/2] Enumerate AVX Vector Neural Network instructions
To:     Yang Zhong <yang.zhong@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, bp@alien8.de
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        tony.luck@intel.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kyung.min.park@intel.com, x86@kernel.org
References: <20210105004909.42000-1-yang.zhong@intel.com>
 <20210105004909.42000-2-yang.zhong@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8fa46290-28d8-5f61-1ce4-8e83bf911106@redhat.com>
Date:   Tue, 5 Jan 2021 12:47:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210105004909.42000-2-yang.zhong@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/01/21 01:49, Yang Zhong wrote:
> From: Kyung Min Park <kyung.min.park@intel.com>
> 
> Add AVX version of the Vector Neural Network (VNNI) Instructions.
> 
> A processor supports AVX VNNI instructions if CPUID.0x07.0x1:EAX[4] is
> present. The following instructions are available when this feature is
> present.
>    1. VPDPBUS: Multiply and Add Unsigned and Signed Bytes
>    2. VPDPBUSDS: Multiply and Add Unsigned and Signed Bytes with Saturation
>    3. VPDPWSSD: Multiply and Add Signed Word Integers
>    4. VPDPWSSDS: Multiply and Add Signed Integers with Saturation
> 
> The only in-kernel usage of this is kvm passthrough. The CPU feature
> flag is shown as "avx_vnni" in /proc/cpuinfo.
> 
> This instruction is currently documented in the latest "extensions"
> manual (ISE). It will appear in the "main" manual (SDM) in the future.
> 
> Signed-off-by: Kyung Min Park <kyung.min.park@intel.com>
> Signed-off-by: Yang Zhong <yang.zhong@intel.com>
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> ---
>   arch/x86/include/asm/cpufeatures.h | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index f5ef2d5b9231..d10d9962bd9b 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -293,6 +293,7 @@
>   #define X86_FEATURE_PER_THREAD_MBA	(11*32+ 7) /* "" Per-thread Memory Bandwidth Allocation */
>   
>   /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
> +#define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
>   #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
>   
>   /* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 13 */
> 

Boris, is it possible to have a topic branch for this patch?

