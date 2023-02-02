Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5BA687656
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 08:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbjBBH02 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 02:26:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjBBH01 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 02:26:27 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E6C66FBE;
        Wed,  1 Feb 2023 23:26:26 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id 7so674546pgh.7;
        Wed, 01 Feb 2023 23:26:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ld+oANwBtzsv6bJz5Tu+JDSsYqqL3LUCBuAOz5v+nbA=;
        b=YtbjYfhiyinlEdWQ14gqm44CRGJNvufLBOtdvBZl9ot+j9cYgqQdDEjZ2rrviOKFk2
         WHNzSo0qPyW9/MZYOge73y54NKCwbv2hKMs0XkmyFPDGgkCnlMk9VoBb7PTLOz3F8Q5T
         Fh0LcWzIQvk3bEVnpg0XMN1CgnijuAMWC4bHsKj9zP5pf2W9UA0mZSuUgH8VO8owan8F
         d6HGZeJmsRgzdolMR1L6BsSYOjNIBNVUjOo20Sf2AI3acDKUmeTWDsX7l2sq2PXNrDZm
         S3/Kr0nbL+45vl1gdHLvRRwDGhh9wHTM/XbKQ9wenKYH/kqxohqPznDtcnoo3XDfevFJ
         7mew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ld+oANwBtzsv6bJz5Tu+JDSsYqqL3LUCBuAOz5v+nbA=;
        b=0nDj3tbRMBnasBKntH5jz1txQfbSF8mjCH6Ld5luhV66CpgS+jpZ3y15v0eQfHT1cw
         Yfd4DuboS8JYQbJxM3V6QZ6JzgAEoBlt94+4R0dnn1Zf73CY8kr3HFNCnjQ7tFz1S9J7
         TgMBSlHv9+6yJz0i3KuWy8dsay2Rd63p22KaBxScFgwCjsA/LBCjlW4x30wIZXcjZT4e
         w1PG3PHYbKiSFDxiA64dpDuq8nac607GKg+HK/DW6pL9x4Bejvuk9syF8jDuKQyxN7Il
         dKB+GZLshpApgf2exEQblmYR6+RR4Fl7oPRST9tu8YhH7V1hgMZvD/HouJ8yKeTODsZO
         jsww==
X-Gm-Message-State: AO0yUKUID0HjEH74mpI0g1uwQXlj65z/X9V0J99HbTYFEfLoyUkIrbtz
        ELcjrtbafKPe2C82VijHanPhzR2Ht/7E9/dE9u0=
X-Google-Smtp-Source: AK7set/pphT6Xfy1D+SzvXtqRuqMRWCpo6dRBaHk93CigYZ4LKRxAwNgNy39EJ7oGhHD3uNDBInLQA==
X-Received: by 2002:a05:6a00:21d1:b0:58b:ca43:9c05 with SMTP id t17-20020a056a0021d100b0058bca439c05mr5965754pfj.16.1675322785746;
        Wed, 01 Feb 2023 23:26:25 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id s8-20020a056a00178800b0058e12372079sm6427061pfg.29.2023.02.01.23.26.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Feb 2023 23:26:24 -0800 (PST)
Message-ID: <afe1fdd8-9f3e-c988-cd38-476a6da26d46@gmail.com>
Date:   Thu, 2 Feb 2023 15:26:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v2] KVM: x86/pmu: Disable all vPMU features support on
 Intel hybrid CPUs
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jianfeng Gao <jianfeng.gao@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <20230131085031.88939-1-likexu@tencent.com>
 <Y9k7eyfmXjqW9lYF@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <Y9k7eyfmXjqW9lYF@google.com>
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

On 1/2/2023 12:02 am, Sean Christopherson wrote:
> On Tue, Jan 31, 2023, Like Xu wrote:
>> From: Like Xu <likexu@tencent.com>
>>
>> Disable KVM support for virtualizing PMUs on hosts with hybrid PMUs until
>> KVM gains a sane way to enumeration the hybrid vPMU to userspace and/or
>> gains a mechanism to let userspace opt-in to the dangers of exposing a
>> hybrid vPMU to KVM guests.
>>
>> Virtualizing a hybrid PMU, or at least part of a hybrid PMU, is possible,
>> but it requires userspace to pin vCPUs to pCPUs to prevent migrating a
>> vCPU between a big core and a little core, requires the VMM to accurately
>> enumerate the topology to the guest (if exposing a hybrid CPU to the
>> guest), and also requires the VMM to accurately enumerate the vPMU
>> capabilities to the guest.
>>
>> The last point is especially problematic, as KVM doesn't control which
>> pCPU it runs on when enumerating KVM's vPMU capabilities to userspace.
>> For now, simply disable vPMU support on hybrid CPUs to avoid inducing
>> seemingly random #GPs in guests.
>>
>> Reported-by: Jianfeng Gao <jianfeng.gao@intel.com>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>> v1: https://lore.kernel.org/all/20230120004051.2043777-1-seanjc@google.com/
>>   arch/x86/kvm/pmu.h | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
>> index 79988dafb15b..6a3995657e1e 100644
>> --- a/arch/x86/kvm/pmu.h
>> +++ b/arch/x86/kvm/pmu.h
>> @@ -166,9 +166,11 @@ static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
>>   
>>   	 /*
>>   	  * For Intel, only support guest architectural pmu
>> -	  * on a host with architectural pmu.
>> +	  * on a non-hybrid host with architectural pmu.
>>   	  */
>> -	if ((is_intel && !kvm_pmu_cap.version) || !kvm_pmu_cap.num_counters_gp)
>> +	if (!kvm_pmu_cap.num_counters_gp ||
>> +	    (is_intel && (!kvm_pmu_cap.version ||
>> +			  boot_cpu_has(X86_FEATURE_HYBRID_CPU))))
> 
> Why do this here instead of in perf_get_x86_pmu_capability()[*]?  The issue isn't
> restricted to Intel CPUs, it just so happens that Intel is the only x86 vendor
> that has shipped hybrid CPUs/PMUs.  Similarly, it's entirely possible to create a
> hybrid CPU with a fully homogeneous PMU.  IMO KVM should rely on the PMU's is_hybrid()
> and not the generic X86_FEATURE_HYBRID_CPU flag.
> 
> [*] https://lore.kernel.org/all/20230120004051.2043777-1-seanjc@google.com

As of today, other x86 vendors do not have hybrid core products in their
road maps. Before implementing the virtual hybrid vCPU model, there is
no practical value in talking about homogeneous PMU on hybrid vCPU
at the present stage.

The perf interface only provides host PMU capabilities and the logic for
choosing to disable (or enable) vPMU based on perf input should be left
in the KVM part so that subsequent development work can add most code
to the just KVM, which is very helpful for downstream users to upgrade
loadable KVM module rather than the entire core kernel.

My experience interacting with the perf subsystem has taught me that
perf change required from KVM should be made as small as possible.
I assume that Peterz's timely "Acked-by" also implies his preference.

Thanks,
Like Xu
