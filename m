Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACB77AF9ED
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 07:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjI0FTO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 01:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjI0FSU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 01:18:20 -0400
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB9826A5;
        Tue, 26 Sep 2023 22:04:25 -0700 (PDT)
Received: from [192.168.7.187] ([76.103.185.250])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 38R543cI2550161
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Tue, 26 Sep 2023 22:04:03 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 38R543cI2550161
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2023091101; t=1695791044;
        bh=/CKCX+/bMK4QwZQehQM2V6fpo3oGAysyOu0z82z/O+E=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=NePHnPjB9AyAEh9FKNsDyyRLDRHeI8EIn3oAi+DRNzzuc7fSSNV+MVwe1MjWCspeH
         Nf1HpCAAUzN1OZBBSkl7qZuYn+dCGHcxYSDz2ESDH643GK21cBjutTQUHxDE/WOu9Q
         KT1Ta8z6cuLnSz28YFF7JS4wC54ZGOJBTetW6AC0BWqxtqTGKqFlKIHsTNlXYSrWKA
         FNrfvhK4J+aks47A3DG0jii0oReyFDXQU6NXiNIBhms0zgegokng8+EMNfT/5rf5vr
         Mcov+fMatqi6BWFRimfHnzc2cd46OUYiV+0+/ICBtMHZYpuH4Uu2J8daM4Zs5wYqCi
         g4cp/fCC+JkuA==
Message-ID: <2c79115e-e16d-49cc-8f5b-2363d7910269@zytor.com>
Date:   Tue, 26 Sep 2023 22:04:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: Move kvm_check_request(KVM_REQ_NMI) after
 kvm_check_request(KVM_REQ_NMI)
Content-Language: en-US
To:     Mingwei Zhang <mizhang@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Like Xu <likexu@tencent.com>, Kan Liang <kan.liang@intel.com>,
        Dapeng1 Mi <dapeng1.mi@intel.com>
References: <20230927040939.342643-1-mizhang@google.com>
 <CAL715WJM2hMyMvNYZAcd4cSpDQ6XPFsNhtR2dsi7W=ySfy=CFw@mail.gmail.com>
From:   Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <CAL715WJM2hMyMvNYZAcd4cSpDQ6XPFsNhtR2dsi7W=ySfy=CFw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/26/2023 9:15 PM, Mingwei Zhang wrote:
> ah, typo in the subject: The 2nd KVM_REQ_NMI should be KVM_REQ_PMI.
> Sorry about that.
> 
> On Tue, Sep 26, 2023 at 9:09 PM Mingwei Zhang <mizhang@google.com> wrote:
>>
>> Move kvm_check_request(KVM_REQ_NMI) after kvm_check_request(KVM_REQ_NMI).

Please remove it, no need to repeat the subject.

>> When vPMU is active use, processing each KVM_REQ_PMI will generate a
>> KVM_REQ_NMI. Existing control flow after KVM_REQ_PMI finished will fail the
>> guest enter, jump to kvm_x86_cancel_injection(), and re-enter
>> vcpu_enter_guest(), this wasted lot of cycles and increase the overhead for
>> vPMU as well as the virtualization.

Optimization is after correctness, so please explain if this is correct
first!

>>
>> So move the code snippet of kvm_check_request(KVM_REQ_NMI) to make KVM
>> runloop more efficient with vPMU.
>>
>> To evaluate the effectiveness of this change, we launch a 8-vcpu QEMU VM on
>> an Intel SPR CPU. In the VM, we run perf with all 48 events Intel vtune
>> uses. In addition, we use SPEC2017 benchmark programs as the workload with
>> the setup of using single core, single thread.
>>
>> At the host level, we probe the invocations to vmx_cancel_injection() with
>> the following command:
>>
>>      $ perf probe -a vmx_cancel_injection
>>      $ perf stat -a -e probe:vmx_cancel_injection -I 10000 # per 10 seconds
>>
>> The following is the result that we collected at beginning of the spec2017
>> benchmark run (so mostly for 500.perlbench_r in spec2017). Kindly forgive
>> the incompleteness.
>>
>> On kernel without the change:
>>      10.010018010              14254      probe:vmx_cancel_injection
>>      20.037646388              15207      probe:vmx_cancel_injection
>>      30.078739816              15261      probe:vmx_cancel_injection
>>      40.114033258              15085      probe:vmx_cancel_injection
>>      50.149297460              15112      probe:vmx_cancel_injection
>>      60.185103088              15104      probe:vmx_cancel_injection
>>
>> On kernel with the change:
>>      10.003595390                 40      probe:vmx_cancel_injection
>>      20.017855682                 31      probe:vmx_cancel_injection
>>      30.028355883                 34      probe:vmx_cancel_injection
>>      40.038686298                 31      probe:vmx_cancel_injection
>>      50.048795162                 20      probe:vmx_cancel_injection
>>      60.069057747                 19      probe:vmx_cancel_injection
>>
>>  From the above, it is clear that we save 1500 invocations per vcpu per
>> second to vmx_cancel_injection() for workloads like perlbench.
>>
>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>> ---
>>   arch/x86/kvm/x86.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 42a4e8f5e89a..302b6f8ddfb1 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -10580,12 +10580,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>>                  if (kvm_check_request(KVM_REQ_SMI, vcpu))
>>                          process_smi(vcpu);
>>   #endif
>> -               if (kvm_check_request(KVM_REQ_NMI, vcpu))
>> -                       process_nmi(vcpu);
>>                  if (kvm_check_request(KVM_REQ_PMU, vcpu))
>>                          kvm_pmu_handle_event(vcpu);
>>                  if (kvm_check_request(KVM_REQ_PMI, vcpu))
>>                          kvm_pmu_deliver_pmi(vcpu);
>> +               if (kvm_check_request(KVM_REQ_NMI, vcpu))
>> +                       process_nmi(vcpu);
>>                  if (kvm_check_request(KVM_REQ_IOAPIC_EOI_EXIT, vcpu)) {
>>                          BUG_ON(vcpu->arch.pending_ioapic_eoi > 255);
>>                          if (test_bit(vcpu->arch.pending_ioapic_eoi,
>>
>> base-commit: 73554b29bd70546c1a9efc9c160641ef1b849358
>> --
>> 2.42.0.515.g380fc7ccd1-goog
>>
> 

-- 
Thanks!
     Xin

