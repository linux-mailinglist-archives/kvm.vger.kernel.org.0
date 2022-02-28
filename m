Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13E094C64D6
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 09:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233946AbiB1I1k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 03:27:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiB1I1j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 03:27:39 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD81F5BE48
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 00:27:00 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id q8-20020a17090a178800b001bc299b8de1so10717245pja.1
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 00:27:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=84kTi9FPdY2UlbNHAvY3OJ8kcjhSpXBxCEwtIaRVe9c=;
        b=LlVepMb/nEoRQydPcQ2gD5Oezj0eIMVNRKG+vfyslpJs4tWwuo72/kw1WV3d6ATaPF
         pU+KoAq+69+qa6k4trY18aCSIHFd1gKP/bv1nUzAsuvoxHMhLoplq7aiWJAbsqfNKsaQ
         HzHfSrzfhEybw+uFMwtzGb6KfO2syDnyleyzYDDX3zAgqpK82qDVe6PQp2yLUVZY17gX
         MfvUYcaklPK2yXLKml4lG0n4EshvgiOilLlUo74fAcPxLJ0H0xvoPj39rs2LZPz3ToLr
         nHTYKySdswAes9aVbQ+wU90YsZMVLe2P/7xPYpJZ9Gjm4ae96r5LYZvUE+GUuT0YDLuz
         UpIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=84kTi9FPdY2UlbNHAvY3OJ8kcjhSpXBxCEwtIaRVe9c=;
        b=fQLQiAbfyWGgYWJs9ewT8xwxHSZcosMhgtS9R5pmko5l8Kv9EMRHoER+2JWvvRyj5L
         fFYk88LJNepm7z7byKzuRK6Wz+CE2wKG1YlvUJMyCZZu7EqZT6MRW9M2aWlmqntXGiJM
         MwbEqCA8vMybs6k3eI6agY6f5waYRbdtFQUT31FcDJVLzj2odhqkGx5NTiCCfGaEpfy9
         Me7PD6tdmIlJXpoIt0YYNVdEJHbTRA69IMYEuZ6111SYUb+CKzT8nwV8LGlwAfiQf8UQ
         4XEbT6FAZuoUTTMqeHZtfZH2bXJAMpb1ZX++RLZu7SG1wW+sy9KizQ5EhRIQTjDgVBkc
         vBzg==
X-Gm-Message-State: AOAM5329BsLFryrbxaJA5pooOQY1XR88cfhTa/3bDr6XN0q8VWtljTds
        vkqNhZ/oMjmK+cNeAGCoVAo=
X-Google-Smtp-Source: ABdhPJzrrZCuBCfjbN2aST9UvQ0GWCZ6V4XSAh5nMo+crPX11SXeQ1Ivv9XPmUus3KHIiVm2MMSZng==
X-Received: by 2002:a17:902:b490:b0:151:6ee1:8034 with SMTP id y16-20020a170902b49000b001516ee18034mr1898117plr.28.1646036820258;
        Mon, 28 Feb 2022 00:27:00 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id f17-20020a056a001ad100b004f0ec1cbc4fsm12428374pfv.109.2022.02.28.00.26.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Feb 2022 00:27:00 -0800 (PST)
Message-ID: <53954c03-49ff-c84e-e062-142e103f735c@gmail.com>
Date:   Mon, 28 Feb 2022 16:26:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH] KVM: x86/svm: Clear reserved bits written to PerfEvtSeln
 MSRs
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>, pbonzini@redhat.com
Cc:     Lotus Fenn <lotusf@google.com>, kvm list <kvm@vger.kernel.org>,
        "Bangoria, Ravikumar" <ravi.bangoria@amd.com>
References: <20220226234131.2167175-1-jmattson@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <20220226234131.2167175-1-jmattson@google.com>
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

On 27/2/2022 7:41 am, Jim Mattson wrote:
> AMD EPYC CPUs never raise a #GP for a WRMSR to a PerfEvtSeln MSR. Some
> reserved bits are cleared, and some are not. Specifically, on
> Zen3/Milan, bits 19 and 42 are not cleared.

Curiously, is there any additional documentation on what bits 19 and 42 are for?
And we only need this part of logic specifically for at least (guest cpu model) 
Zen3.

> 
> When emulating such a WRMSR, KVM should not synthesize a #GP, > regardless of which bits are set. However, undocumented bits should

If KVM chooses to emulate different #GP behavior on AMD and Intel for
"reserved bits without qualification"[0], there should be more code for almost
all MSRs to be checked one by one.

[0] "If a field is marked reserved without qualification, software must not
change the state of that field; it must reload that field with the same value
returned from a prior read."

> not be passed through to the hardware MSR. So, rather than checking
> for reserved bits and synthesizing a #GP, just clear the reserved
> bits.

wrmsr -a 0xc0010200 0xfffffcf000280000
rdmsr -a 0xc0010200 | sort | uniq
# 0x40000080000 (expected)

According to the test, there will be memory bits somewhere on the host
recording the bit status of bits 19 and 42.

Shouldn't KVM emulate this bit-memory behavior as well ?

> 
> This may seem pedantic, but since KVM currently does not support the
> "Host/Guest Only" bits (41:40), it is necessary to clear these bits

I would have thought you had code to emulate the "Host/Guest Only"
bits for nested SVM PMU to fix this issue fundamentally.

> rather than synthesizing #GP, because some popular guests (e.g Linux)
> will set the "Host Only" bit even on CPUs that don't support
> EFER.SVME, and they don't expect a #GP.

IMO, this fix is just a reprieve.

The logic of special handling of #GP only for AMD PMU MSR's
"reserved without qualification" bits is asymmetric in the KVM/svm
context and will confuse users even more.

> 
> For example,
> 
> root@Ubuntu1804:~# perf stat -e r26 -a sleep 1
> 
>   Performance counter stats for 'system wide':
> 
>                   0      r26
> 
>         1.001070977 seconds time elapsed
> 
> Feb 23 03:59:58 Ubuntu1804 kernel: [  405.379957] unchecked MSR access error: WRMSR to 0xc0010200 (tried to write 0x0000020000130026) at rIP: 0xffffffff9b276a28 (native_write_msr+0x8/0x30)
> Feb 23 03:59:58 Ubuntu1804 kernel: [  405.379958] Call Trace:
> Feb 23 03:59:58 Ubuntu1804 kernel: [  405.379963]  amd_pmu_disable_event+0x27/0x90
> 
> Fixes: ca724305a2b0 ("KVM: x86/vPMU: Implement AMD vPMU code for KVM")
> Reported-by: Lotus Fenn <lotusf@google.com>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>   arch/x86/kvm/svm/pmu.c | 8 +++-----
>   1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index d4de52409335..886e8ac5cfaa 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -262,12 +262,10 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   	/* MSR_EVNTSELn */
>   	pmc = get_gp_pmc_amd(pmu, msr, PMU_TYPE_EVNTSEL);
>   	if (pmc) {
> -		if (data == pmc->eventsel)
> -			return 0;
> -		if (!(data & pmu->reserved_bits)) {
> +		data &= ~pmu->reserved_bits;
> +		if (data != pmc->eventsel)
>   			reprogram_gp_counter(pmc, data);
> -			return 0;
> -		}
> +		return 0;
>   	}
>   
>   	return 1;
