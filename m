Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1AB4195778
	for <lists+kvm@lfdr.de>; Fri, 27 Mar 2020 13:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbgC0MsM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Mar 2020 08:48:12 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:54858 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726959AbgC0MsK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Mar 2020 08:48:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585313289;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J3R9pjfcrLfveJt0OaJwOudwQhu7GzXewbxhBYVgwpg=;
        b=YtBBVrJDC50J/yD40DXJrZED8DfubWOTp5A25VAQAUwquqeWKXkuWHn/Yai7dMMkWpG2oM
        c3wlDafb4j31bhmqjZQV41YiS32LXvsHeyD4XKtZACwL/6doospHd3+e/tfQ9WHCrVgNCY
        IWcw7whRTFcCWsbPhv2x5U7Is6oeY0w=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-65-fzXJnt-xM0q8uw4VSvc00w-1; Fri, 27 Mar 2020 08:48:07 -0400
X-MC-Unique: fzXJnt-xM0q8uw4VSvc00w-1
Received: by mail-wm1-f71.google.com with SMTP id f8so4311881wmh.4
        for <kvm@vger.kernel.org>; Fri, 27 Mar 2020 05:48:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=J3R9pjfcrLfveJt0OaJwOudwQhu7GzXewbxhBYVgwpg=;
        b=DffcOg4/CTToYdJgKcfPoWg2Fp5M0KhLIeQXxSNr3vZvN2MLAsdwt7BJLmwfNz3t73
         3guteGjFqss2WHfyodiNqeRWiROytmFgJvszwY6JYEul8fvWIWLc5QcZzBPkY4PLVNqI
         DiqSpF6ycHDIo/iTDrWPvbUTnp7Iv0xAB6o/dFCM96TiI6VJHLUwG9fxURoS1cOL9s1Z
         ldPSUpJRatm7BtJ2FYGEA56N5XIedMtMmmpylK7FWiL9pTkpORWoaZCOCG/yjNxAnSf9
         XALBKc5zGvnCDcPLwEa1vPn6kH0ifxWEvPIMlI+CYYIG1X6R00kRPpo0pM9+ObXd5H9o
         +VcA==
X-Gm-Message-State: ANhLgQ0p7sponzUH4GYV6lsf1SJUhgCRbRTwFvIbQozs1id5i3f0kmRi
        jkvPyHmlDzR9B+NW62EIA1wbPvZ9SYB7gnWIigZSANEZ/7LMNReoG0f2dUYwWBEFZJ084A0rUlK
        4n2BTCwZQRATp
X-Received: by 2002:adf:f5c8:: with SMTP id k8mr13922487wrp.33.1585313286079;
        Fri, 27 Mar 2020 05:48:06 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vt5vgDE/lGJRuJHFUg90TW5N/ADRnKJCzJQ3za8iF5BR3iNikqZ3JIgzc9k8sjECJJks2AE1A==
X-Received: by 2002:adf:f5c8:: with SMTP id k8mr13922457wrp.33.1585313285753;
        Fri, 27 Mar 2020 05:48:05 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id a8sm7715284wmb.39.2020.03.27.05.48.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 05:48:04 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Junaid Shahid <junaids@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 2/3] KVM: x86: cleanup kvm_inject_emulated_page_fault
In-Reply-To: <d2222e81-8618-b3b0-baf3-2bda72d48ede@redhat.com>
References: <20200326093516.24215-1-pbonzini@redhat.com> <20200326093516.24215-3-pbonzini@redhat.com> <877dz75j4i.fsf@vitty.brq.redhat.com> <d2222e81-8618-b3b0-baf3-2bda72d48ede@redhat.com>
Date:   Fri, 27 Mar 2020 13:48:04 +0100
Message-ID: <87a7423qwr.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 26/03/20 14:41, Vitaly Kuznetsov wrote:
>> Paolo Bonzini <pbonzini@redhat.com> writes:
>> 
>>> To reconstruct the kvm_mmu to be used for page fault injection, we
>>> can simply use fault->nested_page_fault.  This matches how
>>> fault->nested_page_fault is assigned in the first place by
>>> FNAME(walk_addr_generic).
>>>
>>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>>> ---
>>>  arch/x86/kvm/mmu/mmu.c         | 6 ------
>>>  arch/x86/kvm/mmu/paging_tmpl.h | 2 +-
>>>  arch/x86/kvm/x86.c             | 7 +++----
>>>  3 files changed, 4 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>>> index e26c9a583e75..6250e31ac617 100644
>>> --- a/arch/x86/kvm/mmu/mmu.c
>>> +++ b/arch/x86/kvm/mmu/mmu.c
>>> @@ -4353,12 +4353,6 @@ static unsigned long get_cr3(struct kvm_vcpu *vcpu)
>>>  	return kvm_read_cr3(vcpu);
>>>  }
>>>  
>>> -static void inject_page_fault(struct kvm_vcpu *vcpu,
>>> -			      struct x86_exception *fault)
>>> -{
>>> -	vcpu->arch.mmu->inject_page_fault(vcpu, fault);
>>> -}
>>> -
>> 
>> This is already gone with Sean's "KVM: x86: Consolidate logic for
>> injecting page faults to L1".
>> 
>> It would probably make sense to have a combined series (or a branch on
>> kvm.git) to simplify testing efforts.
>
> Yes, these three patches replace part of Sean's (the patch you mention
> and the next one, "KVM: x86: Sync SPTEs when injecting page/EPT fault
> into L1").
>
> I pushed the result to a branch named kvm-tlb-cleanup on kvm.git.
>

Thank you,

I've tested it with Hyper-V on both VMX and SVM with and without PV TLB
flush and nothing immediately blew up. I'm also observing a very nice
19000 -> 14000 cycles improvement on tight cpuid loop test (with EVMCS
enabled).

-- 
Vitaly

