Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BED8740B96
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 10:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234668AbjF1IdK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 04:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235338AbjF1Ia7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 04:30:59 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F102D76;
        Wed, 28 Jun 2023 01:22:58 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1b82616c4ecso8744535ad.2;
        Wed, 28 Jun 2023 01:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687940578; x=1690532578;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yh3r9ozI6iCZ3HLG4svWMn5mT2ARhBSKX4nEiZrlmq4=;
        b=b/imsmQDaFn27HHBrhikiwr7xAiNtwoMA70h3v4uflr87pwW8ysF/93zj6T51i22PK
         wxToSlMqXi5Nby3R14gIfsd2qLfpW0YaW7xNtTmICbzhFMK/nVFiEvE/v4t3uabA33y3
         ZFq9JP8nHNGvGiFTxQX20BHvbxTlctItCOItErwyIpD8pzs0Wt/c/BxQxIp6LvePDIDA
         c9m9wdllcSGMjaK050Pz2TCBohFhLF5mHebGIvHGcwJgRJz8LSEZlGvsmVl0wObtMkfG
         10qKVnGCGqg6ngLX7RoVhnNYhCmCY52N4m3VMyRCnf+WvL2BHU9frpAg/n+owoBfV/at
         VfsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687940578; x=1690532578;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yh3r9ozI6iCZ3HLG4svWMn5mT2ARhBSKX4nEiZrlmq4=;
        b=BGkXHyJimDK3NUxb2catyFQOt1RsZO1gjjrT2FAVWoWfzdF7FtuL7lh+Xhe4+tyaXS
         ezYqQ6fIy1Q2ECPhtNYAxPpesJ3Gm5+GjuB5612fAUROIIGAQgwxrXGcxGDuz4v6WCXw
         saUN5lWiwqJ1ChaOdeHorWh33jjIucCi7+tH4+bvB1+72tl3qmHexSqIoQRXsPNNU54l
         /PUTGrMt8nVI/kKkpp+Sk1FiUpynl7QvzjtkbTdvkJDBy78fTgaiY5Xf27SThhH5xkzD
         L9E9MwILvnikcm4RL02EnghoWvu98MoHcwS7xhykRKPg7UXIQ4VH6PXXIpWymikwJ3C5
         tMWA==
X-Gm-Message-State: AC+VfDxHQPWj//1dPc9j6JzNjXp8bTgDYtn+iUY25eQ7OdHgy74aESk2
        bAob1ZwsdUwfKkR32b5LUEo088b8d5GJ7NCWtU4=
X-Google-Smtp-Source: ACHHUZ56jGXuIEKfoHtNcofr3E73Z8afz/z8VDWxvvkxrGv1P/UUs0rOcCOidY9AJeSVk0YK++CuUw==
X-Received: by 2002:a17:903:11c6:b0:1b3:d4ae:7e21 with SMTP id q6-20020a17090311c600b001b3d4ae7e21mr8607753plh.63.1687930673578;
        Tue, 27 Jun 2023 22:37:53 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id u10-20020a17090282ca00b001b8062c1db3sm4310127plz.82.2023.06.27.22.37.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jun 2023 22:37:52 -0700 (PDT)
Message-ID: <613d0cfa-e118-1e7e-b313-6c775a2daa14@gmail.com>
Date:   Wed, 28 Jun 2023 13:37:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [PATCH 2/4] KVM: VMX/pmu: Save host debugctlmsr just before vm
 entry
Content-Language: en-US
To:     "Zhang, Xiong Y" <xiong.y.zhang@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "kan.liang@linux.intel.com" <kan.liang@linux.intel.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>
References: <20230616113353.45202-1-xiong.y.zhang@intel.com>
 <20230616113353.45202-3-xiong.y.zhang@intel.com>
 <ZJX9WHFPdEVjRtC+@google.com>
 <MW4PR11MB5824480492ED55C63769FF11BB21A@MW4PR11MB5824.namprd11.prod.outlook.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <MW4PR11MB5824480492ED55C63769FF11BB21A@MW4PR11MB5824.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/6/2023 12:03 pm, Zhang, Xiong Y wrote:
>> On Fri, Jun 16, 2023, Xiong Zhang wrote:
>>> Perf defines four types of perf event: per cpu pinned event, per
>>> process pinned event, per cpu event, per process event, their
>>> prioirity are from high to low. vLBR event is per process pinned
>>> event. So durng vm exit handler, if vLBR event preempts perf low
>>> priority LBR event, perf will disable LBR and let guest control LBR,
>>> or if vLBR event is preempted by perf high priority LBR event, perf
>>> will enable LBR. In a word LBR status may be changed during vm exit handler.
>>>
>>> MSR_IA32_DEBUGCTLMSR[0] controls LBR enabling, kvm saves its value
>>> into
>>> vmx->host_debugctlmsr in vcpu_load(), and kvm restores its value from
>>> vmx->host_debugctlmsr after vm exit immediately. Since
>>> MSR_IA32_DEBUGCTLMSR[0] could be changed during vm exit handler, the
>>> saved value vmx->host_debugctlmsr could be wrong. So this commit saves
>>> MSR_IA32_DEBUGCTLMSR into vmx->host_debugctlmsr just before vm entry
>>> to reflect the real hardware value.
>>>
>>> Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
>>> ---
>>>   arch/x86/kvm/vmx/vmx.c | 5 +----
>>>   1 file changed, 1 insertion(+), 4 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c index
>>> 44fb619803b8..5ca61a26d0d7 100644
>>> --- a/arch/x86/kvm/vmx/vmx.c
>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>> @@ -1459,13 +1459,9 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu,
>> int cpu,
>>>    */
>>>   static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)  {
>>> -	struct vcpu_vmx *vmx = to_vmx(vcpu);
>>> -
>>>   	vmx_vcpu_load_vmcs(vcpu, cpu, NULL);
>>>
>>>   	vmx_vcpu_pi_load(vcpu, cpu);
>>> -
>>> -	vmx->host_debugctlmsr = get_debugctlmsr();
>>>   }
>>>
>>>   static void vmx_vcpu_put(struct kvm_vcpu *vcpu) @@ -7273,6 +7269,7 @@
>>> static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>>>   	atomic_switch_perf_msrs(vmx);
>>>   	if (intel_pmu_lbr_is_enabled(vcpu))
>>>   		vmx_passthrough_lbr_msrs(vcpu);
>>> +	vmx->host_debugctlmsr = get_debugctlmsr();
>>
>> Reading DEBUG_CTL on every VM-Entry is either unnecessary or insufficient.  If
>> the DEBUG_CTL value is being changed synchronously, then just fix whatever
>> KVM path leads to a change in the host avlue.  If DEBUG_CTL is being changed
>> asynchronously, then I'm guessing the change is coming from NMI context,
>> which means that KVM is buggy no matter how close we put this to VM-Enter.
> When a perf event reschedule is needed on a physical cpu, perf scheduler send an IPI to the target cpu, LBR will be enabled or disabled in the IPI handler according to active event attribute.
> If vLBR event is active, LBR is disabled in IPI handler.
> If Host LBR event is active, LBR is enabled in the IPI handler, this could happen when host LBR event preempt vLBR event during vm exit handler.
> DEBUG_CTL[0]'s changing is asynchronous in the perf IPI handler,  host irq is disabled near VM-Enter, so IPI couldn't happen, then host DEBUG_CTL[0] couldn't change before kvm enable host irq.
> Perf event counter overflow (PMI) is a NMI, but this NMI handler doesn't change LBR status, the kvm saved host_debugctlmsr is correct still after PMI handler.
> 
> thanks

This is not true. One example is Freezing LBRs on PMI (bit 11) in the host NMI ctx.

For "Legacy Freeze_LBR_on_PMI" feature on a host, "the LBR is frozen on the
overflowed condition of the buffer area, the processor clears the LBR bit
(bit 0) in IA32_DEBUGCTL."

Not to mention that the commit message makes no mention of the effect of
this change on other features on DEBUG_CTL.

I couldn't agree with Sean more here. I think the first is to make sure that 
debugctl's
functionality is not broken in both root mode and non-root mode, followed closely
by what policy should be set and notified to any user if host/kvm are not in a
position to support either side.
