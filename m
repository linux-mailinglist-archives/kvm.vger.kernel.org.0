Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4A646E483
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 09:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235154AbhLIIsi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 03:48:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235135AbhLIIsh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 03:48:37 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6D9C061746;
        Thu,  9 Dec 2021 00:45:04 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id f125so4533625pgc.0;
        Thu, 09 Dec 2021 00:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:organization:subject:in-reply-to
         :content-transfer-encoding;
        bh=tK1hZ3CV+6USV8fTZ69OnQjQ1kpiKKSPbC+alCWSbhE=;
        b=ZXhgGsxay71B8CKUCUxzedWhTbOEJQsW/AFkHmYQAXbl1khZBXC6Sz8n5BWkWSd7Db
         BAefUj4RVYk++F8EBR3xs9qVLqTrtieQ/tFdfUX0AwYb8U+eoKwNlYqWctpXxd20Tii/
         1J68ojkmEoc0BHW/RbL1Fg13EUJdzhpcM43CTvemEIU3PYfqQCZFx7/u6M9Yj0RtI1vz
         ttOnELXkmnAC+jP4hIFJknXtdsu4yCgpYid5+J2+/13yRQXGINydwxAZiGj/0RZVhpcH
         pP4Pqn5wZPjaxnpX0MfUzeGaEefgLm97lmPTS8xTLi92/p1Xwv+1F2rVNj4pUI7ZalBG
         FeTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=tK1hZ3CV+6USV8fTZ69OnQjQ1kpiKKSPbC+alCWSbhE=;
        b=5UD0Mcj3rP34cB2dOr29awZ3pWX+4UHUIiU9Pm9JjknjOcwObFVnZR+7MwHayO0Iqw
         P2a9YAGLfKLKtVNBaI4YaGH8siADL2bQJITrQQid+XEDgk3f5EoD65MPzHhTois9fXer
         JGsySnRcBiU9OP7eLYSIm0CccTz86BGnf8Nx03q6SstW+rO4t8ryWxePX487i8Xx3zPn
         Q/G51vGeG2uvUZYAgJiZJop0NcG89ZyKsnQ5gtKU5Mt2pzQZ0xqls3pBFTVmw6Qt/SJf
         Bbe1c84DsSwzGAib5rTzv6rWmau+nOHXk22DLBNwromgXSGKe5cFWq+HuQe5gW7pCzRP
         aogQ==
X-Gm-Message-State: AOAM532ggIL056DxD7VPpewFLswrwQAKIfsVRM4IanhXbna/BngpRl1t
        9JofUtDIYvb12Dv+eOANRhXe1FBs0lM=
X-Google-Smtp-Source: ABdhPJzKAZBqgP3CexyHBX4s7h0WFpJ+F8MHwwVMrTzHMhJZXGKc9WOGbleIwYK06EBL8zi12xKQvg==
X-Received: by 2002:a63:6b83:: with SMTP id g125mr32404566pgc.578.1639039504383;
        Thu, 09 Dec 2021 00:45:04 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id e35sm4766166pgm.92.2021.12.09.00.45.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 00:45:04 -0800 (PST)
Message-ID: <ad06fc9f-4617-3262-414d-e061d3d68b9d@gmail.com>
Date:   Thu, 9 Dec 2021 16:44:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <20211130074221.93635-1-likexu@tencent.com>
 <20211130074221.93635-6-likexu@tencent.com>
 <CALMp9eQxW_0JBe_6doNTGLXHsXM_Y0YSfnrM1yqTumUQqg7A2A@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [PATCH v2 5/6] KVM: x86: Update vPMCs when retiring instructions
In-Reply-To: <CALMp9eQxW_0JBe_6doNTGLXHsXM_Y0YSfnrM1yqTumUQqg7A2A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/12/2021 12:33 pm, Jim Mattson wrote:
> On Mon, Nov 29, 2021 at 11:42 PM Like Xu <like.xu.linux@gmail.com> wrote:
>>
>> From: Like Xu <likexu@tencent.com>
>>
>> When KVM retires a guest instruction through emulation, increment any
>> vPMCs that are configured to monitor "instructions retired," and
>> update the sample period of those counters so that they will overflow
>> at the right time.
>>
>> Signed-off-by: Eric Hankland <ehankland@google.com>
>> [jmattson:
>>    - Split the code to increment "branch instructions retired" into a
>>      separate commit.
>>    - Added 'static' to kvm_pmu_incr_counter() definition.
>>    - Modified kvm_pmu_incr_counter() to check pmc->perf_event->state ==
>>      PERF_EVENT_STATE_ACTIVE.
>> ]
>> Fixes: f5132b01386b ("KVM: Expose a version 2 architectural PMU to a guests")
>> Signed-off-by: Jim Mattson <jmattson@google.com>
>> [likexu:
>>    - Drop checks for pmc->perf_event or event state or event type
>>    - Increase a counter once its umask bits and the first 8 select bits are matched
>>    - Rewrite kvm_pmu_incr_counter() with a less invasive approach to the host perf;
>>    - Rename kvm_pmu_record_event to kvm_pmu_trigger_event;
>>    - Add counter enable and CPL check for kvm_pmu_trigger_event();
>> ]
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
> 
>> +void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id)
>> +{
>> +       struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>> +       struct kvm_pmc *pmc;
>> +       int i;
>> +
>> +       for_each_set_bit(i, pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX) {
>> +               pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, i);
>> +
>> +               if (!pmc || !pmc_is_enabled(pmc) || !pmc_speculative_in_use(pmc))
>> +                       continue;
>> +
>> +               /* Ignore checks for edge detect, pin control, invert and CMASK bits */
> 
> I don't understand how we can ignore these checks. Doesn't that
> violate the architectural specification?

OK, let's take a conservative approach in the V3.

> 
>> +               if (eventsel_match_perf_hw_id(pmc, perf_hw_id) && cpl_is_matched(pmc))
>> +                       kvm_pmu_incr_counter(pmc);
>> +       }
>> +}
>> +EXPORT_SYMBOL_GPL(kvm_pmu_trigger_event);
>> +
> 
