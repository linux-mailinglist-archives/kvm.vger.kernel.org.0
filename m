Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546BD423F83
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 15:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238997AbhJFNi7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 09:38:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48579 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238996AbhJFNiq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 09:38:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633527414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zi054OphNR4YOrKnGY04qCEpE/Tk8lGtKOdDVzEQgV0=;
        b=hkvq8NJsRhQfpjVdjxrZRGtJhpW4oeiWTke+Xvrijv0jKYZhwKP32NnOBHHpsH7g7cyvzL
        kjnVqziaTY2fpnfYiQiYiJfRdFanO4g3sVXe5WpnaFhqfE2DsBQ9jXyoIEPiremE0xEZGx
        n5iaW+aXgN9P3FdigiGc+NupE+ndmW0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-x4AS0vHdNXatX1SDoBoMKA-1; Wed, 06 Oct 2021 09:36:53 -0400
X-MC-Unique: x4AS0vHdNXatX1SDoBoMKA-1
Received: by mail-ed1-f72.google.com with SMTP id x5-20020a50f185000000b003db0f796903so2636715edl.18
        for <kvm@vger.kernel.org>; Wed, 06 Oct 2021 06:36:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zi054OphNR4YOrKnGY04qCEpE/Tk8lGtKOdDVzEQgV0=;
        b=2+fBF0yqjH5bOZdal/yXGNRywfK5mhnld5hpveJRIkJjAovD9ghAm1p90VH+rWQv47
         swTXNMe4zHb/rfGAXROilP8xgDIf2lHbsK7XhfiJorLpPjn+HPrrGw0lnU3HKHWH8PCD
         fNUTXM5730jBNDTyqu9LTx99me4Iok+qB8OTyt3fJNatC3pWGsmLZjUgGhuvcUa3OB2o
         MI7Mt48kjKN/nB4H35gLZhE6wUCd86aio/MdCSWzgVWEUWuzvFBTYEyTv3Ri2HkZokTk
         RGHh2OvRbNh4lJUn57VWzhzG6v4kJgTIWcE+5R/55ZrsEjuFmvnCOtsTmaeXJl2/ZYFM
         i9pQ==
X-Gm-Message-State: AOAM533XzzjQkvlZMKwg4t6k0x3/Ij1jdsd41LAEmucf9d6xi8fl8l3l
        i9LpJosKgZF+yUoNQuo95Tpn+K9V/Mn81CxBTQd5JeC0kIaWdeTHQhgvxGcRSkBb4d3w5aYgSJk
        6/dCfWQU8PmWB
X-Received: by 2002:a17:906:2c53:: with SMTP id f19mr3279738ejh.326.1633527412049;
        Wed, 06 Oct 2021 06:36:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGhrNpiCcqnxw2q4z0gic+jPTFiIPs5YIp8IwzhKzz3fJa/t/dqSqNd48d9J3px/QNMuYt7A==
X-Received: by 2002:a17:906:2c53:: with SMTP id f19mr3279721ejh.326.1633527411866;
        Wed, 06 Oct 2021 06:36:51 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id zg6sm1917740ejb.102.2021.10.06.06.36.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 06:36:50 -0700 (PDT)
Message-ID: <5c4a0910-7cb8-da4c-aec5-c88c50f0b2fc@redhat.com>
Date:   Wed, 6 Oct 2021 15:36:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH MANUALSEL 5.14 7/9] kvm: x86: Add AMD PMU MSRs to
 msrs_to_save_all[]
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Fares Mehanna <faresx@amazon.de>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
References: <20211006133021.271905-1-sashal@kernel.org>
 <20211006133021.271905-7-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211006133021.271905-7-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/10/21 15:30, Sasha Levin wrote:
> From: Fares Mehanna <faresx@amazon.de>
> 
> [ Upstream commit e1fc1553cd78292ab3521c94c9dd6e3e70e606a1 ]
> 
> Intel PMU MSRs is in msrs_to_save_all[], so add AMD PMU MSRs to have a
> consistent behavior between Intel and AMD when using KVM_GET_MSRS,
> KVM_SET_MSRS or KVM_GET_MSR_INDEX_LIST.
> 
> We have to add legacy and new MSRs to handle guests running without
> X86_FEATURE_PERFCTR_CORE.
> 
> Signed-off-by: Fares Mehanna <faresx@amazon.de>
> Message-Id: <20210915133951.22389-1-faresx@amazon.de>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/x86.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1e7d629bbf36..28b86f47fea5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1327,6 +1327,13 @@ static const u32 msrs_to_save_all[] = {
>   	MSR_ARCH_PERFMON_EVENTSEL0 + 12, MSR_ARCH_PERFMON_EVENTSEL0 + 13,
>   	MSR_ARCH_PERFMON_EVENTSEL0 + 14, MSR_ARCH_PERFMON_EVENTSEL0 + 15,
>   	MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
> +
> +	MSR_K7_EVNTSEL0, MSR_K7_EVNTSEL1, MSR_K7_EVNTSEL2, MSR_K7_EVNTSEL3,
> +	MSR_K7_PERFCTR0, MSR_K7_PERFCTR1, MSR_K7_PERFCTR2, MSR_K7_PERFCTR3,
> +	MSR_F15H_PERF_CTL0, MSR_F15H_PERF_CTL1, MSR_F15H_PERF_CTL2,
> +	MSR_F15H_PERF_CTL3, MSR_F15H_PERF_CTL4, MSR_F15H_PERF_CTL5,
> +	MSR_F15H_PERF_CTR0, MSR_F15H_PERF_CTR1, MSR_F15H_PERF_CTR2,
> +	MSR_F15H_PERF_CTR3, MSR_F15H_PERF_CTR4, MSR_F15H_PERF_CTR5,
>   };
>   
>   static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

