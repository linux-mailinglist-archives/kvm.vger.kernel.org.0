Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7446B7A6851
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 17:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233199AbjISPsB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Sep 2023 11:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233184AbjISPsA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Sep 2023 11:48:00 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10B39C;
        Tue, 19 Sep 2023 08:47:54 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id ffacd0b85a97d-3200bc30666so2558289f8f.2;
        Tue, 19 Sep 2023 08:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695138473; x=1695743273; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ANj/G1QqgtW6bo0+EDli+wp6aYMdZfH9ByTF2IjfuOs=;
        b=R/DOZI19Eod6bHXvnPKXYhLzyEF94lX71Rp4DtSEdwCGr/AUUaDLjcvhXiQhFGQwUi
         iKIpPc9rEzjpgJ0bc47X7qSKiyTzaHbTCGrvlqztVUsAddwcwmAJo/ZL8RZKWak9uL9l
         v1wC8ipb4axHrnAQNukJC6naMxmquFZSPhqU6qTM/vN0jV97vt7whvmGy2zzvlfr3TrI
         IEzRlxVUAV+jL+Q7Mr/o9/vqQ9r7brAF8U/XnSfXAmK0LUylZjzXgg+9aMJjqhEEWrGU
         YLJKQj/1EVXJTWJgjlNywYhlW786zwfycda3oSXOvDRXdclGbctmeg5GHZJxuZWWO+H+
         Cskw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695138473; x=1695743273;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ANj/G1QqgtW6bo0+EDli+wp6aYMdZfH9ByTF2IjfuOs=;
        b=XekyBD7pz+wjsCsemA76nHDi/EVOU/DMw923QvgU1O9X3xnAD9nDXsiNVQ63nnB0+O
         ubjXfT5Y4ZoJueBwekzKrYi7w35usebnt8v71COA8c7kqTAyYvFw3vAlg4QKS2NyQ5xu
         g/oQS72Wpe9Ch3poATaBdVgO6Z79BDu3TlLwcJ2MfMlLK7eQnVseHCBScrtXv73vlHzk
         U/QpvULilXa24Tszop3F8HAZVIOfg3wxzh0ZxKLQIgE77618RqACBHC7RTiIsYiDWt8i
         RjPxyifiwF4XKghDMCTWf7pAYQ/3KaCUIct0uq0LVqEKyuhOR/ShY0ChFCfFH0N5VHjm
         ouVQ==
X-Gm-Message-State: AOJu0YxK+i+6xc2loAqxOmLLJ183d6mvF+Hac0rzGXEgXo20f/dbxmz3
        7RSq4lqyTGLchryNwjR3FQ8=
X-Google-Smtp-Source: AGHT+IHcntaufHjjMwfAihNVW2MO3QORi/UOuYmQjOol84n1VtL8VzzsiTAo0jqjf4LDnrEQ0FOffw==
X-Received: by 2002:a5d:4843:0:b0:31f:9398:3654 with SMTP id n3-20020a5d4843000000b0031f93983654mr23449wrs.40.1695138473025;
        Tue, 19 Sep 2023 08:47:53 -0700 (PDT)
Received: from [192.168.4.177] (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id c1-20020a5d4141000000b0031f300a4c26sm15796972wrq.93.2023.09.19.08.47.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Sep 2023 08:47:52 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <7de61c43-e88d-9c22-7e5f-2229d8c49523@xen.org>
Date:   Tue, 19 Sep 2023 16:47:51 +0100
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
 <451eebfe-1df5-4f02-2ce1-998560feaa98@xen.org>
 <6b20173bae6bbf2de03c64c158198b351900f4ea.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <6b20173bae6bbf2de03c64c158198b351900f4ea.camel@infradead.org>
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

On 19/09/2023 16:38, David Woodhouse wrote:
> On Tue, 2023-09-19 at 15:34 +0100, Paul Durrant wrote:
>>>> +       ret = kvm_gpc_activate(vi_gpc, gpa, sizeof(struct vcpu_info));
>>>
>>>   From this moment, can't interrupts be delivered to the new vcpu_info,
>>> even though the memcpy hasn't happened yet?
>>>
>>
>> Hmm, that's a good point. TBH it would be nice to have an 'activate and
>> leave locked' primitive to avoid this.
> 
> I suppose so from the caller's point of view in this case, but I'm
> somewhat disinclined to add that complexity to the pfncache code.
> 
> We take the refresh_lock *mutex* in __kvm_gpc_refresh() so it's not as
> simple as declaring that said function is called with the gpc rwlock
> already held.
> 
> We also do the final gpc_unmap_khva() of the old mapping after dropping
> the lock; *could* we call that with a write lock held? A write lock
> which is going to be taken the MM notifier callbacks? Well, maybe not
> in the case of the first *activate* which isn't really a 'refresh' per
> se but the whole thing is making my skin itch. I don't like it.
> 
>>> I think we need to ensure that any kvm_xen_set_evtchn_fast() which
>>> happens at this point cannot proceed, and falls back to the slow path.
>>>
>>> Can we set a flag before we activate the vcpu_info and clear it after
>>> the memcpy is done, then make kvm_xen_set_evtchn_fast() return
>>> EWOULDBLOCK whenever that flag is set?
>>>
>>> The slow path in kvm_xen_set_evtchn() takes kvm->arch.xen.xen_lock and
>>> I think kvm_xen_vcpu_set_attr() has taken that same lock before you get
>>> to this code, so it works out nicely?
>>>
>>
>> Yes, I think that is safe... but if we didn't have the window between
>> activating the vcpu_info cache and doing the copy we'd also be ok I
>> think... Or perhaps we could simply preserve evtchn_pending_sel and copy
>> the rest of it?
> 
>>
> I suppose you could just write the evtchn_pending_sel word in the new
> vcpu_info GPA to zero before setting up the pfncache for it.
> 
> When when you do the memcpy, you don't *just* memcpy the
> evtchn_pending_sel word; you use the bitwise OR of the old and new, so
> you catch any bits which got set in the new word in the interim?
> 
> But then again, who moves the vcpu_info while there are actually
> interrupts in-flight to the vCPU in question? Maybe we just declare
> that we don't care, and that interrupts may be lost in that case? Even
> if *Xen* wouldn't have lost them (and I don't even know that part is
> true).
> 
>>> This adds a new lock ordering rule of the vcpu_info lock(s) before the
>>> shared_info lock. I don't know that it's *wrong* but it seems weird to
>>> me; I expected the shared_info to come first?
>>>
>>> I avoided taking both at once in kvm_xen_set_evtchn_fast(), although
>>> maybe if we are going to have a rule that allows both, we could revisit
>>> that. Suspect it isn't needed.
>>>
>>> Either way it is worth a clear comment somewhere to document the lock
>>> ordering, and I'd also like to know this has been tested with lockdep,
>>> which is often cleverer than me.
>>>
>>
>> Ok. I agree that shared_info before vcpu_info does seem more intuitive
>> and maybe it would be better given the code in
>> kvm_xen_set_evtchn_fast(). I'll seem how messy it gets in re-ordering
>> and add a comment as you suggest.
>>
> 
> I think they look interchangeable in this case. If we *do* take them
> both in kvm_xen_set_evtchn_fast() then maybe we can simplify the slow
> path where it set the bits in shared_info but then the vcpu_info gpc
> was invalid. That currently uses a kvm->arch.xen.evtchn_pending_sel
> shadow of the bits, and just kicks the vCPU to deliver them for
> itself... but maybe that whole thing could be dropped, and
> kvm_xen_set_evtchn_fast() can just return EWOULDBLOCK if it fails to
> lock *both* shared_info and vcpu_info at the same time?
> 

Yes, I think that sounds like a neater approach.

> I didn't do that before, because I didn't want to introduce lock
> ordering rules. But I'm happier to do so now. And I think we can ditch
> a lot of hairy asm in kvm_xen_inject_pending_events() ?
> 

Messing with the asm sounds like something for a follow-up though.

   Paul

