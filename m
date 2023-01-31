Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07D3368256F
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 08:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbjAaHUn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 02:20:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjAaHUl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 02:20:41 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4EB22B0B7;
        Mon, 30 Jan 2023 23:20:39 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id d3so14151366plr.10;
        Mon, 30 Jan 2023 23:20:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Uf4J6ccw6V6I9dyQLrV+NN/+J2brxB5QVhy1JYmFFs8=;
        b=iJzxqFi7xafyuD1QzyFQ5G715kAHT1Dk9lY5MDbpYnnxYgc0Fg3lvpGzdWMQ8oab6a
         iUkijzSB620JaPry0FfVZwVLb5N9/vJrAgEsGR7Ng6D4nuiRqYOyrAndW0ng+4z+n5CI
         t25UrrTKgRS5Zn+9MGSHdOuLroItoZTkdZaLbUHPp1x/M93yZFFwNTPfFxb5apoEnEqP
         y13VAkmth+4SHXk7Mft8701RT66cIku14OSO3JYujXQG3mr6IQxv7X7cISC5phBURyG2
         8lrLArmF/1HC98Akm6tUMNTr2HxkjwSH3jbequHLs3uMx/+MX+knMMuzi3hhg2UnkfIh
         fxzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Uf4J6ccw6V6I9dyQLrV+NN/+J2brxB5QVhy1JYmFFs8=;
        b=5EPxK2W9llsa2VUUoUOuxBTDnAPJ/ElPGoJ35KZ3eAP4VyXjU4aNbojSJuFI/Iuya7
         vr26Ok/bVPJlWw9e6uvq6AmqbK5/nF4UrmsQyjE6QsQZMbGIUzZzM0WwA9vtpOQoF1nY
         Q9aYY/KwHr7ywTHuDEinTKPr5+mm2fxYVWXuPnnFxD1ZYRoJ4omrSvT5RxMNi6Qr1nsF
         WNPNuGNpkyOAaIch2goRg+5WXMBdstqahH1gIZoavPVhAQBQHOmAx0N8Ze2WxBHA9Xoe
         z/LAJ9UQLNTqU+slKX5NHAmH8axGSvVuu4P78p3i5yt/dOORp0dAInqmAS8+mkmViWpw
         t1zQ==
X-Gm-Message-State: AFqh2kpKLpmBibALeMdQbsmiAfaXWrEJnIxn9/9geWJRC9KNPAggM9Jx
        EaoDvUek0+AF6hPivvawEjseruR5RvEoUwjt
X-Google-Smtp-Source: AMrXdXvyHgU+XKn3Anr3zezEQ5EyGsLztYOW3iRXERHTdXiiKTgOkW+i2LXBw5AfRGPXxuLA3fmTBw==
X-Received: by 2002:a05:6a20:d48f:b0:bb:84a1:68b0 with SMTP id im15-20020a056a20d48f00b000bb84a168b0mr28709634pzb.55.1675149639173;
        Mon, 30 Jan 2023 23:20:39 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id x2-20020aa793a2000000b00592591d1634sm8160489pff.97.2023.01.30.23.20.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 23:20:38 -0800 (PST)
Message-ID: <f106a06e-ae6f-2c79-df87-721817aacc02@gmail.com>
Date:   Tue, 31 Jan 2023 15:20:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH] KVM: x86/pmu: Disallow legacy LBRs if architectural LBRs
 are available
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Weijiang <weijiang.yang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230128001427.2548858-1-seanjc@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20230128001427.2548858-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/1/2023 8:14 am, Sean Christopherson wrote:
> Disallow enabling LBR support if the CPU supports architectural LBRs.
> Traditional LBR support is absent on CPU models that have architectural
> LBRs, and KVM doesn't yet support arch LBRs, i.e. KVM will pass through
> non-existent MSRs if userspace enables LBRs for the guest.

True, we have call_trace due to MSR_ARCH_LBR_FROM_0 (0x1500) for example.

> 
> Cc: stable@vger.kernel.org
> Cc: Yang Weijiang <weijiang.yang@intel.com>
> Cc: Like Xu <like.xu.linux@gmail.com>

Tested-by: Like Xu <likexu@tencent.com>

> Reported-by: Paolo Bonzini <pbonzini@redhat.com>

Fixes: 145dfad998ea ("KVM: VMX: Advertise PMU LBRs if and only if perf supports 
LBRs")

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> 
> Am I missing something that would prevent this scenario?
> 
>   arch/x86/kvm/vmx/vmx.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 8f0f67c75f35..77ee6b4a5ec4 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7761,9 +7761,11 @@ static u64 vmx_get_perf_capabilities(void)
>   	if (boot_cpu_has(X86_FEATURE_PDCM))
>   		rdmsrl(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);
>   
> -	x86_perf_get_lbr(&lbr);
> -	if (lbr.nr)
> -		perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
> +	if (!cpu_feature_enabled(X86_FEATURE_ARCH_LBR)) {

To avoid changing this again in the Arch lbr enabling part, how about:

	x86_perf_get_lbr(&lbr);
	if (lbr.nr && cpu_feature_enabled(X86_FEATURE_ARCH_LBR) ==
	    kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
		perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;

?

> +		x86_perf_get_lbr(&lbr);
> +		if (lbr.nr)
> +			perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
> +	}
>   
>   	if (vmx_pebs_supported()) {
>   		perf_cap |= host_perf_cap & PERF_CAP_PEBS_MASK;
> 
> base-commit: 2de154f541fc5b9f2aed3fe06e218130718ce320
