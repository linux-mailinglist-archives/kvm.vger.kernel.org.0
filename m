Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEBEA7AAE69
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 11:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbjIVJld (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 05:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjIVJl3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 05:41:29 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AFF794;
        Fri, 22 Sep 2023 02:41:23 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-32008e339adso1837637f8f.2;
        Fri, 22 Sep 2023 02:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695375681; x=1695980481; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WiLmRa8gWPpCuxu6i5MOMtXJ7QzKKG7kw7FfmIemUBk=;
        b=BhK3d0/kH7SbVHibZXZ0pyt1Dr3mF4hq83C5eu0KYBKDH396coxrFHAi+vL+RYVORL
         XsT2c8GLWEoAl6N0/EhFG8e/tlOneDoLHMIjzFFERbvbN4QD8URJ/SxSVNOC+J+wmnCq
         tLCAFRWKC+bYyGMDqlbhUKKX8DTA4H6A3ZHYAYdsDa7qv/va6S5O6+tNRfGa/FqC1XAW
         CiGO7tF7Qevu3VzamOuB43n/FKQZMcbWIlhMAdUtDh/L2lRDESutOnWB9t6eQdrciEX2
         yHZ2EDblWIil1TCesEkm4uxu+dGqDdjyiP4EG9wpsYznUp2I8H9oorDiAoZ1DKXi3tUS
         l4UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695375681; x=1695980481;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WiLmRa8gWPpCuxu6i5MOMtXJ7QzKKG7kw7FfmIemUBk=;
        b=JggYU3vThruBC+MHYPH9R8DnPZRXDpB9ZMaajSV6gltTB5LGs8h/wWWafdhEf8/WZJ
         DELWyBKgTA15XSflE1zfAMj3cB8xt1ZzfqK1aDn6tI6K/LVhupm8GVZbyuO82jbxvRch
         ZmNgY1fYJ6jMV/s/Dw8LxFzHIIdVnAmdAHv3wbUXXGqJKl5iEFq7mG2F5D7DvzXLf3Wk
         VtRK5/oQE+JgQFAd/kkJzrRprZvRS0jyN38wqYaTYMxRBmkbMaFasmcMUL2FSBsUTEo3
         rBmm6sd5vi47lIPU6YfAR+c8bOJVe1KTa5/CiwIi5bQNYe7V+F3IubOSATOdiIlTlD5/
         sveg==
X-Gm-Message-State: AOJu0YwY4lkqE51SAPSGuQL5eWO7mBNsb0Wpdnv3o/d5VUYn58XUA4MJ
        Qha50COacAsI036IJjTVCrMTG/va9OMFyQ==
X-Google-Smtp-Source: AGHT+IGnfQx1H/Bf7ydzCPTlbi1xtIeGip89SDuB3toPhtRs2IfAV/ozkMaf1KXfZc2d3AwkQxES3w==
X-Received: by 2002:a5d:5005:0:b0:31a:d9bc:47a2 with SMTP id e5-20020a5d5005000000b0031ad9bc47a2mr7346538wrt.53.1695375681234;
        Fri, 22 Sep 2023 02:41:21 -0700 (PDT)
Received: from [192.168.4.149] (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id o13-20020adfeacd000000b00317f3fd21b7sm4002202wrn.80.2023.09.22.02.41.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Sep 2023 02:41:20 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <eae9bc31-f91a-4abf-a491-043d6063ff5d@xen.org>
Date:   Fri, 22 Sep 2023 10:41:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH] KVM: x86: Use fast path for Xen timer delivery
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm <kvm@vger.kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        "Griffoul, Fred" <fgriffo@amazon.com>
References: <445abd6377cf1621a2d306226cab427820583967.camel@infradead.org>
 <dff1ad07-8649-4916-bbc1-ab5cc403bb89@xen.org>
 <e16f0d326d4c6976a9cd194faa66e5eaf8b0c47d.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <e16f0d326d4c6976a9cd194faa66e5eaf8b0c47d.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/09/2023 10:29, David Woodhouse wrote:
> On Fri, 2023-09-22 at 10:22 +0100, Paul Durrant wrote:
>> On 22/09/2023 10:20, David Woodhouse wrote:
>>> From: David Woodhouse <dwmw@amazon.co.uk>
>>>
>>> Most of the time there's no need to kick the vCPU and deliver the timer
>>> event through kvm_xen_inject_timer_irqs(). Use kvm_xen_set_evtchn_fast()
>>> directly from the timer callback, and only fall back to the slow path
>>> when it's necessary to do so.
>>>
>>> This gives a significant improvement in timer latency testing (using
>>> nanosleep() for various periods and then measuring the actual time
>>> elapsed).
>>>
>>> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
>>> ---
>>>    arch/x86/kvm/xen.c | 17 ++++++++++++++---
>>>    1 file changed, 14 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
>>> index 40edf4d1974c..66c4cf93a55c 100644
>>> --- a/arch/x86/kvm/xen.c
>>> +++ b/arch/x86/kvm/xen.c
>>> @@ -134,12 +134,23 @@ static enum hrtimer_restart xen_timer_callback(struct hrtimer *timer)
>>>    {
>>>          struct kvm_vcpu *vcpu = container_of(timer, struct kvm_vcpu,
>>>                                               arch.xen.timer);
>>> +       struct kvm_xen_evtchn e;
>>> +       int rc;
>>> +
>>>          if (atomic_read(&vcpu->arch.xen.timer_pending))
>>>                  return HRTIMER_NORESTART;
>>>    
>>> -       atomic_inc(&vcpu->arch.xen.timer_pending);
>>> -       kvm_make_request(KVM_REQ_UNBLOCK, vcpu);
>>> -       kvm_vcpu_kick(vcpu);
>>> +       e.vcpu_id = vcpu->vcpu_id;
>>> +       e.vcpu_idx = vcpu->vcpu_idx;
>>> +       e.port = vcpu->arch.xen.timer_virq;
>>
>> Don't you need to check the port for validity? The VMM may not have set
>> it (and hence be delivering timer VIRQ events itself).
> 
> Nah, the kvm_xen_timer_enabled() check which gates all the kernel
> interception of timer hypercalls is already testing precisely that.
> 
> If the TIMER_VIRQ isn't set, none of this code runs. And when userspace
> tears down TIMER_VIRQ, the hrtimer is cancelled. So none of this code
> (then) runs.

Ok. Good :-)

Reviewed-by: Paul Durrant <paul@xen.org>
