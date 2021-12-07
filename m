Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 042AB46B2B8
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 07:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236547AbhLGGLh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 01:11:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbhLGGLg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 01:11:36 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90515C061746;
        Mon,  6 Dec 2021 22:08:06 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id j6-20020a17090a588600b001a78a5ce46aso1152969pji.0;
        Mon, 06 Dec 2021 22:08:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:organization:subject:in-reply-to
         :content-transfer-encoding;
        bh=HlQr+EswJMIm5Z5Ks83Qr6+ZdOEMpkP5u4xGvE5LBFk=;
        b=FARRkLlbpPDiuw1ypugqeCOTdgjwg7d8aBS13AGQXQKGc3gshr9+qizunQdH4q2Y7K
         s7kdwkI2WscGLUVNExgiXCnjV1QL61xDArfXmjMqJpt8hpnD9j7Nn7jc2PBl6mneXW3U
         hzUmTa9kT4voa4mLUmb+ceJXo1IGJFD1KVJZ1Ugdlz2UOmFJGqSVKXoMI0bXi0fkNlrV
         NWWB+cZ2keqNf4s+bU0fw8gyNEQyKz3ZNynDCu+8M/xMGmPf6txP4sza+jarxqiUsCJa
         KMDYUpHHzjHPXcjQpL2ZO70yiLJGa6gam1A4+mQrGTxUhYkPqsGyF4riV4YJp9rCA1DQ
         eO3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=HlQr+EswJMIm5Z5Ks83Qr6+ZdOEMpkP5u4xGvE5LBFk=;
        b=kCQ56XfPuUzNy+xb9NDXc8+uyY7GMWaVl6Mn6oaeSUBtmAo1hPs24wV6mMDWn8IJOT
         gKHbcz7fCSFV2/qaD0CREZWVy5CbnsiYI9Cbnxs1dMp7AZSe3TzOx6hdw7xrNNmyapO0
         Z0Lv0Lw86LT7TXgzO1mvkho+IURlym+YQbxDTVsQ8O4TQt2d4ydCIFez7FOx1smerU5A
         1i2Nh6ttZreAYkH0jFuVWZV9pyaIWEBBvnx/T8Zvq5W6zYOhqS/jw+zUGvv5w95zwnqC
         NIZBnuloiDgt64Vs/0cS51ME8ir8tVlQRnH+yTMtrzU7gCQG6wU4NlK0u9Si+mH+yIn+
         gPMQ==
X-Gm-Message-State: AOAM532mQxb+gwXZp+bg5QmAsuGtfHtK8gS0k4BDgmjK2aXugD1yzB/p
        F1QLDPSZpjJiXv1XuNIzn6A=
X-Google-Smtp-Source: ABdhPJwX56sTmwIklLxIOg8iqJ+hekP4gC4rU2rFrWAFTsMjFoIv7TAVeMucXYFtgMr5GEXS6xzSQg==
X-Received: by 2002:a17:90b:4f86:: with SMTP id qe6mr4148449pjb.224.1638857286128;
        Mon, 06 Dec 2021 22:08:06 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id b15sm14434076pfl.118.2021.12.06.22.08.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Dec 2021 22:08:05 -0800 (PST)
Message-ID: <7ca8ffcb-eb45-a47c-f91b-6dbd35ea8893@gmail.com>
Date:   Tue, 7 Dec 2021 14:07:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
References: <20211130074221.93635-1-likexu@tencent.com>
 <20211130074221.93635-2-likexu@tencent.com>
 <CALMp9eTq8H_bJOVKwi_7j3Kum9RvW6o-G3zCLUFco1A1cvNrkQ@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [PATCH v2 1/6] KVM: x86/pmu: Setup pmc->eventsel for fixed PMCs
In-Reply-To: <CALMp9eTq8H_bJOVKwi_7j3Kum9RvW6o-G3zCLUFco1A1cvNrkQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/12/2021 3:50 am, Jim Mattson wrote:
> On Mon, Nov 29, 2021 at 11:42 PM Like Xu <like.xu.linux@gmail.com> wrote:
> 
>> From: Like Xu <likexu@tencent.com>
>>
>> The current pmc->eventsel for fixed counter is underutilised. The
>> pmc->eventsel can be setup for all known available fixed counters
>> since we have mapping between fixed pmc index and
>> the intel_arch_events array.
>>
>> Either gp or fixed counter, it will simplify the later checks for
>> consistency between eventsel and perf_hw_id.
>>
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>>   arch/x86/kvm/vmx/pmu_intel.c | 16 ++++++++++++++++
>>   1 file changed, 16 insertions(+)
>>
>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>> index 1b7456b2177b..b7ab5fd03681 100644
>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>> @@ -459,6 +459,21 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu,
>> struct msr_data *msr_info)
>>          return 1;
>>   }
>>
>> +static void setup_fixed_pmc_eventsel(struct kvm_pmu *pmu)
>> +{
>> +       size_t size = ARRAY_SIZE(fixed_pmc_events);
>> +       struct kvm_pmc *pmc;
>> +       u32 event;
>> +       int i;
>> +
>> +       for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
>> +               pmc = &pmu->fixed_counters[i];
>> +               event = fixed_pmc_events[array_index_nospec(i, size)];
>>
> 
> How do we know that i < size? For example, Ice Lake supports 4
> fixed counters, but fixed_pmc_events only has three entries.

With the help of macro MAX_FIXED_COUNTERS,
the fourth or more fixed counter is currently not supported in KVM.

If the user space sets a super set of CPUID supported by KVM,
any pmu emulation failure is to be expected, right ?

Waiting for more comments from you on this patch set.

> 
> 
>> +               pmc->eventsel = (intel_arch_events[event].unit_mask << 8) |
>> +                       intel_arch_events[event].eventsel;
>> +       }
>> +}
>> +
>>
>>
>>
> 
