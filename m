Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8EA7A66C6
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 16:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbjISOeP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Sep 2023 10:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232761AbjISOeO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Sep 2023 10:34:14 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8698CBC;
        Tue, 19 Sep 2023 07:34:07 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-40476ce8b2fso52429005e9.3;
        Tue, 19 Sep 2023 07:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695134046; x=1695738846; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lqJvPFmgqoOTX72N2Rr3WDY0GncM240kQ4I/QG2dQUs=;
        b=nZ0Bmayv3WYTebpIcHPHFElJxVkCKekEiy7m0Xg0bNwmGiScj8yPRGlr/z74ac3kx8
         GPbMsjD76ikpkyuy98s8WSnxVG6uUFq0if7JEG06mfoyYhkDO46MNYsoQRqNXgvmCIcG
         spbX/jXOiRjHd9sWyZEkji6yGbtL1EL+RQY1k2Jbvpri0F+KxaSg3MDkAl91JTGD+IDB
         EweEC83fqisjyQmSMNwQCBsqLEdBE2jUEHOdXHznwlXhtb5cXhGnGgHXixgXh8hC56/x
         83puByYcKphyxL0TFXYmAZFZev7Y1274h5yRHCrFXvVSBU2Ofz8Yvw2MKjUGVTkoLSBV
         g0lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695134046; x=1695738846;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lqJvPFmgqoOTX72N2Rr3WDY0GncM240kQ4I/QG2dQUs=;
        b=HUq+iCzz0Y1Pmli0/sjkbJlIvrY7ENys4XjPMvdQ4V7xtpsj7wwYN1YiU0Y7lJX4GS
         K7P746nufY63pK7kOQZ6sxJwHPWhVFFtkHR294VjzbHGL444zn61vEDWVq7wn1x4wvyQ
         zBasuWsoTiGcqcdEs1jj839peLWCj2Wt5P4XTLtkBoabBSoSh7ddW+s0SxrhYOOQTAnH
         xK3YLaxLxcnwO+lSIRmIwemhiWyP2ejNxfrbN6lizzQXGJv/gINVjoW9+jwo2xY/Us6c
         ZvunMmkrBRR0nbO2930whr95l5uTkZKIkkjQLFk9CYAIHHShfn4BfkvIkzz41Eu85xBs
         p/yQ==
X-Gm-Message-State: AOJu0Yxva7CjpLhMRTWxEbyTWcuQERGKdvtagrYONvw6jjLRGsjM3sor
        fgQpvgvADVhmAwc55TVmcUM=
X-Google-Smtp-Source: AGHT+IEzyB0JNFcrAyJfLZuHQ9lS+0XHPaqBZTrl/pVLxSTgSeoyVAhmsvj9jMH0LblOBe9kPxiJYg==
X-Received: by 2002:a05:600c:228c:b0:401:c52c:5ed8 with SMTP id 12-20020a05600c228c00b00401c52c5ed8mr10325465wmf.13.1695134045697;
        Tue, 19 Sep 2023 07:34:05 -0700 (PDT)
Received: from [192.168.4.177] (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id m13-20020a7bca4d000000b003fe4548188bsm18380179wml.48.2023.09.19.07.34.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Sep 2023 07:34:05 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <451eebfe-1df5-4f02-2ce1-998560feaa98@xen.org>
Date:   Tue, 19 Sep 2023 15:34:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Reply-To: paul@xen.org
Subject: Re: [PATCH v4 09/13] KVM: xen: automatically use the vcpu_info
 embedded in shared_info
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
References: <20230919134149.6091-1-paul@xen.org>
 <20230919134149.6091-10-paul@xen.org>
 <3d7070d51dd0094e426b420bc5e7d09657dd8d38.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <3d7070d51dd0094e426b420bc5e7d09657dd8d38.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/09/2023 15:18, David Woodhouse wrote:
> On Tue, 2023-09-19 at 13:41 +0000, Paul Durrant wrote:
>> --- a/arch/x86/kvm/xen.c
>> +++ b/arch/x86/kvm/xen.c
>> @@ -491,6 +491,21 @@ static void kvm_xen_inject_vcpu_vector(struct kvm_vcpu *v)
>>   
>>   static struct gfn_to_pfn_cache *get_vcpu_info_cache(struct kvm_vcpu *v, unsigned long *offset)
>>   {
>> +       if (!v->arch.xen.vcpu_info_cache.active && v->arch.xen.vcpu_id < MAX_VIRT_CPUS) {
>> +               struct kvm *kvm = v->kvm;
>> +
>> +               if (offset) {
>> +                       if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode)
>> +                               *offset = offsetof(struct shared_info,
>> +                                                  vcpu_info[v->arch.xen.vcpu_id]);
>> +                       else
>> +                               *offset = offsetof(struct compat_shared_info,
>> +                                                  vcpu_info[v->arch.xen.vcpu_id]);
>> +               }
>> +
>> +               return &kvm->arch.xen.shinfo_cache;
>> +       }
>> +
>>          if (offset)
>>                  *offset = 0;
>>   
>> @@ -764,6 +779,92 @@ static int kvm_xen_set_vcpu_id(struct kvm_vcpu *vcpu, unsigned int vcpu_id)
>>          return 0;
>>   }
>>   
>> +static int kvm_xen_set_vcpu_info(struct kvm_vcpu *vcpu, gpa_t gpa)
>> +{
>> +       struct kvm *kvm = vcpu->kvm;
>> +       struct gfn_to_pfn_cache *si_gpc = &kvm->arch.xen.shinfo_cache;
>> +       struct gfn_to_pfn_cache *vi_gpc = &vcpu->arch.xen.vcpu_info_cache;
>> +       unsigned long flags;
>> +       unsigned long offset;
>> +       int ret;
>> +
>> +       if (gpa == KVM_XEN_INVALID_GPA) {
>> +               kvm_gpc_deactivate(vi_gpc);
>> +               return 0;
>> +       }
>> +
>> +       /*
>> +        * In Xen it is not possible for an explicit vcpu_info to be set
>> +        * before the shared_info exists since the former is done in response
>> +        * to a hypercall and the latter is set up as part of domain creation.
>> +        * The first 32 vCPUs have a default vcpu_info embedded in shared_info
>> +        * the content of which is copied across when an explicit vcpu_info is
>> +        * set, which can also clearly not be done if we don't know where the
>> +        * shared_info is. Hence we need to enforce that the shared_info cache
>> +        * is active here.
>> +        */
>> +       if (!si_gpc->active)
>> +               return -EINVAL;
>> +
>> +       /* Setting an explicit vcpu_info is a one-off operation */
>> +       if (vi_gpc->active)
>> +               return -EINVAL;
> 
> Is that the errno that Xen will return to the hypercall if a guest
> tries it? I.e. if the VMM simply returns the errno that it gets from
> the kernel, is that OK?
> 

Yes, I checked. Xen returns -EINVAL.

>> +       ret = kvm_gpc_activate(vi_gpc, gpa, sizeof(struct vcpu_info));
> 
>  From this moment, can't interrupts be delivered to the new vcpu_info,
> even though the memcpy hasn't happened yet?
> 

Hmm, that's a good point. TBH it would be nice to have an 'activate and 
leave locked' primitive to avoid this.

> I think we need to ensure that any kvm_xen_set_evtchn_fast() which
> happens at this point cannot proceed, and falls back to the slow path.
> 
> Can we set a flag before we activate the vcpu_info and clear it after
> the memcpy is done, then make kvm_xen_set_evtchn_fast() return
> EWOULDBLOCK whenever that flag is set?
> 
> The slow path in kvm_xen_set_evtchn() takes kvm->arch.xen.xen_lock and
> I think kvm_xen_vcpu_set_attr() has taken that same lock before you get
> to this code, so it works out nicely?
> 

Yes, I think that is safe... but if we didn't have the window between 
activating the vcpu_info cache and doing the copy we'd also be ok I 
think... Or perhaps we could simply preserve evtchn_pending_sel and copy 
the rest of it?

> 
> 
>> +       if (ret)
>> +               return ret;
>> +
>> +       /* Nothing more to do if the vCPU is not among the first 32 */
>> +       if (vcpu->arch.xen.vcpu_id >= MAX_VIRT_CPUS)
>> +               return 0;
>> +
>> +       /*
>> +        * It's possible that the vcpu_info cache has been invalidated since
>> +        * we activated it so we need to go through the check-refresh dance.
>> +        */
>> +       read_lock_irqsave(&vi_gpc->lock, flags);
>> +       while (!kvm_gpc_check(vi_gpc, sizeof(struct vcpu_info))) {
>> +               read_unlock_irqrestore(&vi_gpc->lock, flags);
>> +
>> +               ret = kvm_gpc_refresh(vi_gpc, sizeof(struct vcpu_info));
>> +               if (ret) {
>> +                       kvm_gpc_deactivate(vi_gpc);
>> +                       return ret;
>> +               }
>> +
>> +               read_lock_irqsave(&vi_gpc->lock, flags);
>> +       }
>> +
>> +       /* Now lock the shared_info cache so we can copy the vcpu_info */
>> +       read_lock(&si_gpc->lock);
> 
> This adds a new lock ordering rule of the vcpu_info lock(s) before the
> shared_info lock. I don't know that it's *wrong* but it seems weird to
> me; I expected the shared_info to come first?
> 
> I avoided taking both at once in kvm_xen_set_evtchn_fast(), although
> maybe if we are going to have a rule that allows both, we could revisit
> that. Suspect it isn't needed.
> 
> Either way it is worth a clear comment somewhere to document the lock
> ordering, and I'd also like to know this has been tested with lockdep,
> which is often cleverer than me.
> 

Ok. I agree that shared_info before vcpu_info does seem more intuitive 
and maybe it would be better given the code in 
kvm_xen_set_evtchn_fast(). I'll seem how messy it gets in re-ordering 
and add a comment as you suggest.

   Paul

>> +       while (!kvm_gpc_check(si_gpc, PAGE_SIZE)) {
>> +               read_unlock(&si_gpc->lock);
>> +
>> +               ret = kvm_gpc_refresh(si_gpc, PAGE_SIZE);
>> +               if (ret) {
>> +                       read_unlock_irqrestore(&vi_gpc->lock, flags);
>> +                       kvm_gpc_deactivate(vi_gpc);
>> +                       return ret;
>> +               }
>> +
>> +               read_lock(&si_gpc->lock);
>> +       }
>> +
>> +       if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode)
>> +               offset = offsetof(struct shared_info,
>> +                                 vcpu_info[vcpu->arch.xen.vcpu_id]);
>> +       else
>> +               offset = offsetof(struct compat_shared_info,
>> +                                 vcpu_info[vcpu->arch.xen.vcpu_id]);
>> +
>> +       memcpy(vi_gpc->khva, si_gpc->khva + offset, sizeof(struct vcpu_info));
>> +
>> +       read_unlock(&si_gpc->lock);
>> +       read_unlock_irqrestore(&vi_gpc->lock, flags);
>> +
>> +       return 0;
>> +}
>> +
>>   int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
>>   {
>>          int idx, r = -ENOENT;
>> @@ -779,14 +880,7 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
>>                  BUILD_BUG_ON(offsetof(struct vcpu_info, time) !=
>>                               offsetof(struct compat_vcpu_info, time));
>>   
>> -               if (data->u.gpa == KVM_XEN_INVALID_GPA) {
>> -                       kvm_gpc_deactivate(&vcpu->arch.xen.vcpu_info_cache);
>> -                       r = 0;
>> -                       break;
>> -               }
>> -
>> -               r = kvm_gpc_activate(&vcpu->arch.xen.vcpu_info_cache,
>> -                                    data->u.gpa, sizeof(struct vcpu_info));
>> +               r = kvm_xen_set_vcpu_info(vcpu, data->u.gpa);
>>                  if (!r)
>>                          kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
>>   
> 

