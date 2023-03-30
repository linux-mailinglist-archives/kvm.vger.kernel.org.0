Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7351E6CFC68
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 09:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbjC3HMt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 03:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbjC3HMo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 03:12:44 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2855A6A6A
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 00:12:42 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id b20so72729366edd.1
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 00:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680160360;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j8/ouX+YMZS0bbwjsx1bXH6jzX2LC2Te4TwuT8s0n2M=;
        b=YtZNq/EQEp0FzqlN+y0/uDWNOj7WUgMXwTuyx/9a1igPairphmML0iiUtIODlJ4Jkv
         PiLgo+sJ5rZJh6Uqgtl2QaZxji6mI683/k9LB3mDKpYSSAc/LWusEDPJ8s/rQvZAGhI/
         K150jn/Hxrd1qsufoa3q7c92tsfohqAtu0ls93Cs1d9vtDP1wH/UPhj6Qven+XlST1lg
         0XupexKCnMNW1exEnCDMtiIz/DEGsTCashVJjxH/xaEILnJtgNctkXvNrndajJgjWtSE
         AmTd6e+WlCeFUBykqnTHc9X59/2r86THfNqRBe5VlcX1tbvf7k0sXyK/5AvUd+vLkQpr
         AO/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680160360;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j8/ouX+YMZS0bbwjsx1bXH6jzX2LC2Te4TwuT8s0n2M=;
        b=MPM2sgLOWFCGlxASW0GXyd2MIRhVklBTK3HjNucu+wZurqSZHRBTInVdZNQsrQE/RL
         bh+h1qav5bWPN6Tu0sLlzTgVH7JrL9ZYAlCdEboBxyL5tMEv1D+hgS+udBz3O4rZ9QRA
         PnYZcVevq5Hq0LOaTy5t2pWyvyH3Uqy+TgzQq7mTrBlkwJnoPBMf9enB433Od2o0pmJi
         YWSL7anyrePvzrZcVRIJ7vN38Yo4hU/3fOlb8UvUA7dbToKT3IXWlruSetbQcVboThDS
         vgwBh/jU99punCr//ho2cW5FHNZguYq41w5o+v/Y7LYXiR1X8zI21BZMDUoGA58gRQOe
         rFeg==
X-Gm-Message-State: AAQBX9epeC10MdJ2Dpo877R5ncWzjRvmmP4Jr2mVFZRklAxmh3FHRqNX
        8iXPhFJMmvxtgqEm38Ko8rMNmz3mlGbbtGKEX1RNRQ==
X-Google-Smtp-Source: AKy350aOlcBc4/1kCg8vVxzEt8v8oE9E7cIpwB2TprpFHcFsldRGn1pEK+MrPQ45nq+Q30qqfuzNXw==
X-Received: by 2002:a17:906:278a:b0:8b1:fc1a:7d21 with SMTP id j10-20020a170906278a00b008b1fc1a7d21mr25986113ejc.5.1680160360554;
        Thu, 30 Mar 2023 00:12:40 -0700 (PDT)
Received: from [192.168.2.107] ([79.115.63.91])
        by smtp.gmail.com with ESMTPSA id s12-20020a50d48c000000b005023aaf52desm6101228edi.95.2023.03.30.00.12.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Mar 2023 00:12:40 -0700 (PDT)
Message-ID: <ab6f161e-59fd-0ad7-d0ce-2edfc9e6bc18@linaro.org>
Date:   Thu, 30 Mar 2023 08:12:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v3 07/26] KVM: VMX: Move preemption timer <=> hrtimer
 dance to common x86
Content-Language: en-US
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Lee Jones <joneslee@google.com>
References: <20211208015236.1616697-1-seanjc@google.com>
 <20211208015236.1616697-8-seanjc@google.com>
 <1548c1a4-4681-4d98-ee43-44bc97b3bdee@linaro.org>
 <244097d2-3d14-6031-7733-62be75036d88@redhat.com>
 <ff078de7-1af8-19fd-2d8c-7a02792245cd@linaro.org>
In-Reply-To: <ff078de7-1af8-19fd-2d8c-7a02792245cd@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Paolo,

On 3/29/23 16:22, Tudor Ambarus wrote:
> 
> 
> On 3/29/23 14:47, Paolo Bonzini wrote:
> 
> Hi, Paolo!
> 
>> On 3/29/23 14:34, Tudor Ambarus wrote:
>>> This patch fixes the bug reported at:
>>> LINK:
>>> https://syzkaller.appspot.com/bug?id=489beb3d76ef14cc6cd18125782dc6f86051a605
>>>
>>> One may find the strace at:
>>> LINK:https://syzkaller.appspot.com/text?tag=CrashLog&x=1798b54ec80000
>>> and the c reproducer at:
>>> LINK:https://syzkaller.appspot.com/text?tag=ReproC&x=10365781c80000
>>>
>>> Since I've no experience with kvm, it would be helpful if one of you can
>>> provide some guidance. Do you think it is worth to backport this patch
>>> to stable (together with its prerequisite patches), or shall I try to
>>> get familiar with the code and try to provide a less invasive fix?
>>
>> I think it is enough to fix the conflicts in vmx_pre_block and
>> vmx_post_block, there are no prerequisites:
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 0718658268fe..895069038856 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -7577,17 +7577,11 @@ static int vmx_pre_block(struct kvm_vcpu *vcpu)
>>      if (pi_pre_block(vcpu))
>>          return 1;
>>  
>> -    if (kvm_lapic_hv_timer_in_use(vcpu))
>> -        kvm_lapic_switch_to_sw_timer(vcpu);
>> -
>>      return 0;
>>  }
>>  
>>  static void vmx_post_block(struct kvm_vcpu *vcpu)
>>  {
>> -    if (kvm_x86_ops.set_hv_timer)
>> -        kvm_lapic_switch_to_hv_timer(vcpu);
>> -
>>      pi_post_block(vcpu);
>>  }
>>  
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index fcfa3fedf84f..4eca3ec38afd 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -10022,12 +10022,28 @@ static int vcpu_enter_guest(struct kvm_vcpu
>> *vcpu)
>>  
>>  static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
>>  {
>> +    bool hv_timer;
>> +
>>      if (!kvm_arch_vcpu_runnable(vcpu) &&
>>          (!kvm_x86_ops.pre_block || static_call(kvm_x86_pre_block)(vcpu)
>> == 0)) {
>> +        /*
>> +         * Switch to the software timer before halt-polling/blocking as
>> +         * the guest's timer may be a break event for the vCPU, and the
>> +         * hypervisor timer runs only when the CPU is in guest mode.
>> +         * Switch before halt-polling so that KVM recognizes an expired
>> +         * timer before blocking.
>> +         */
>> +        hv_timer = kvm_lapic_hv_timer_in_use(vcpu);
>> +        if (hv_timer)
>> +            kvm_lapic_switch_to_sw_timer(vcpu);
>> +
>>          srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
>>          kvm_vcpu_block(vcpu);
>>          vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
>>  
>> +        if (hv_timer)
>> +            kvm_lapic_switch_to_hv_timer(vcpu);
>> +
>>          if (kvm_x86_ops.post_block)
>>              static_call(kvm_x86_post_block)(vcpu);
>>  
>> @@ -10266,6 +10282,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>>              r = -EINTR;
>>              goto out;
>>          }
>> +        /*
>> +         * It should be impossible for the hypervisor timer to be in
>> +         * use before KVM has ever run the vCPU.
>> +         */
>> +        WARN_ON_ONCE(kvm_lapic_hv_timer_in_use(vcpu));
>>          kvm_vcpu_block(vcpu);
>>          if (kvm_apic_accept_events(vcpu) < 0) {
>>              r = 0;
>>
>> The fix is due to the second "if" changing from
>> kvm_x86_ops.set_hv_timer to hv_timer.
>>
> 
> Thanks for the prompt answer! I fixed the conflicts as per your
> suggestion and tested the patch with the reproducer on top of
> stable/linux-5.15.y and I confirm the reproducer is silenced. Sent the
> patch proposal (with you in To:) at:
> https://lore.kernel.org/all/20230329151747.2938509-1-tudor.ambarus@linaro.org/T/#u
> Feel free to ACK/NACK it.
> 

Wanted to let you know that I've tried the reproducer on
stable/linux-5.{10, 4}.y and the bug is not hit. The only long term
maintained kernel that seems affected is 5.15, so I backported the patch
just for it. If you think it would be good to backport the patch further
or you want me to do some other tests, I'll be glad to do so.

Thanks for the guidance!
ta
