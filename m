Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98BDF63880E
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 12:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbiKYLAG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 06:00:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiKYLAF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 06:00:05 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5557E46653;
        Fri, 25 Nov 2022 03:00:04 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id 9so3829316pfx.11;
        Fri, 25 Nov 2022 03:00:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ajZYs/klHZaufNSQQiKDb2NboGQQHvlmx4QqmQd/jgY=;
        b=QRzOSJco9J4vzPLtjp9JEYUGeDnUcpeOW0LK3h1z7KkMiOAWTGzb5sZx+5H7seSgcE
         PdlvUHJcItcxSC4a4InFbO6ADdUceIG1i60A/wAiul7kxf2/RwOiJ690fKtL822WK2Nu
         APYdwlHuK5Fr4FvIFLGCxxrsfU+nfGliSDZUrNvVS86CjOCPmdnhEh2YBH5SEZytKva8
         rtu8IgSju2Oa2L0bCtYS85NGEQLwqiAK9CZpHwxHIF1OlXNNVogHczLCecwItJ45rKa3
         pRUN9ckGSCWI0SfvRpmFRIGMCAsGFMKZyd/Xoch1Na9vKrsykefMtgMilSv7hwoZAtgJ
         My3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ajZYs/klHZaufNSQQiKDb2NboGQQHvlmx4QqmQd/jgY=;
        b=qGUm5bvv9BoU/+Bvs9iV+kg0U5/dgwc1odRtaSxO4vGDJbhPtLr9umQ3Ty5KTSIGfX
         QX1R7TzFYKoP8tyg5nJIqwwQdo9FYl0RSc8kuOjgd8lHZR67uHu71LwDYLDNczqmn+L9
         VY1AKr/RysjzN2qXwoPztVkRqccXsm2nJS0YQqupN8rL3LwdOO2LI3+NLms+KjvLxUbB
         iXpF3n1Lq453qJ/CcAbm5VWKdLQIgdR41ZQhvnoQcV8C9FeAF2rYxgth46n58f7cUDd1
         vHLGB7KMVanYWMK3PjjcNHNu+kZZbz5nL/+fGIJdj6kCMv3uuQFHZ/x+VfvA/HQE8MeX
         eH8w==
X-Gm-Message-State: ANoB5pl4nwofQ8tZIihZVI4YxqoVlXywUTNHvMbByRKw1PPk+J4xbmyP
        +V9dj2yrT5lpJG03rmcsQ3/pqL0uPLxfDg==
X-Google-Smtp-Source: AA0mqf65er91QWQrviT+XJo9yluj0AZX3H0kHtfGJ9bSSFbKYXnQsMYGrQGaocOqP6z6pENOiTEGUg==
X-Received: by 2002:aa7:85c8:0:b0:574:5789:b8a4 with SMTP id z8-20020aa785c8000000b005745789b8a4mr11823894pfn.47.1669374003700;
        Fri, 25 Nov 2022 03:00:03 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id d18-20020a170903231200b001780e4e6b65sm3122894plh.114.2022.11.25.03.00.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Nov 2022 03:00:02 -0800 (PST)
Message-ID: <a07db01a-5aa4-3a77-187e-e69171fb9fe1@gmail.com>
Date:   Fri, 25 Nov 2022 18:59:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [PATCH v3 1/3] KVM: x86/pmu: Disable guest PEBS on hybird cpu due
 to heterogeneity
To:     Kunkun Jiang <jiangkunkun@huawei.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20221109082802.27543-1-likexu@tencent.com>
 <20221109082802.27543-2-likexu@tencent.com>
 <16bb2874-c8c8-fb4e-c793-28605f36712b@huawei.com>
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <16bb2874-c8c8-fb4e-c793-28605f36712b@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/11/2022 6:18 pm, Kunkun Jiang wrote:
> Hi Like,
> 
> There is a question I would like to ask. As far as I know, Alder Lake uses
> a hybrid architecture and the kernel presents two types of PMUs.Can the
> events created on the VCPU still count normally if the VCPU thread gets
> migrate across different CPUs?

The best answer is the test results as no one sponsored me a hybrid x86 box.

According to my understanding, when a performance event (e.g. instructions)
is supported on both types of pmu (even with different event codes), perf_event
will remain enabled after the cpu migration (just changing the per-cpu context
based on migrated pmu, and allocating another available hardware counter).

Otherwise, the kernel will or should create and enable the perf_event based on
current pmu type and disable the event of the previous cpu type. For the guest,
KVM will or should recognize the migrated pmu type and enable the currently
available perf_event for guest vPMC.

But on hybrid x86, pmu capabilities are heterogeneous (even though the ISA is
the same), and incompatible migrations can result in previous pmu capabilities
(such as PEBS in this case) not being implemented on the new pmu, which breaks
the expectation of the guest pmu driver.

Making the guest aware of the differences in pmu types requires more fundamental
KVM changes (for example, presenting multiple types of cpu model for the guest),
and perhaps the simple and safe approach is to provide the guest with only the
capabilities that are available to both pmu types.

If things don't happen the way you expect them to, work it out w/ or w/o my help.

> 
> As far as I know, ARM64 big.LITTLE is not working properly, according to
> this set of patches.
> [PATCH v4 0/6] KVM: arm64: Improve PMU support on heterogeneous systems
> https://lore.kernel.org/all/20220127161759.53553-1-alexandru.elisei@arm.com/

The arm64 will have more cpu types (especially in terms of power management),
but the difference in pmu capabilities will also depend on the design of IP vendors.

> 
> Thanks，
> Kunkun Jiang
> 
> On 2022/11/9 16:28, Like Xu wrote:
>> From: Like Xu <likexu@tencent.com>
>>
>> >From vPMU enabling perspective, KVM does not have proper support for
>> hybird x86 core. The reported perf_capabilities value (e.g. the format
>> of pebs record) depends on the type of cpu the kvm-intel module is init.
>> When a vcpu of one pebs format migrates to a vcpu of another pebs format,
>> the incorrect parsing of pebs records by guest can make profiling data
>> analysis extremely problematic.
>>
>> The safe way to fix this is to disable this part of the support until the
>> guest recognizes that it is running on the hybird cpu, which is appropriate
>> at the moment given that x86 hybrid architectures are not heavily touted
>> in the data center market.
>>
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>>   arch/x86/kvm/vmx/capabilities.h | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
>> index cd2ac9536c99..ea0498684048 100644
>> --- a/arch/x86/kvm/vmx/capabilities.h
>> +++ b/arch/x86/kvm/vmx/capabilities.h
>> @@ -392,7 +392,9 @@ static inline bool vmx_pt_mode_is_host_guest(void)
>>   static inline bool vmx_pebs_supported(void)
>>   {
>> -    return boot_cpu_has(X86_FEATURE_PEBS) && kvm_pmu_cap.pebs_ept;
>> +    return boot_cpu_has(X86_FEATURE_PEBS) &&
>> +           !boot_cpu_has(X86_FEATURE_HYBRID_CPU) &&
>> +           kvm_pmu_cap.pebs_ept;
>>   }
>>   static inline bool cpu_has_notify_vmexit(void)
