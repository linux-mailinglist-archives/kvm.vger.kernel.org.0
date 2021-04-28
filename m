Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D98236DE99
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 19:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242465AbhD1Rre (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 13:47:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56099 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242447AbhD1Rrb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Apr 2021 13:47:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619632005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8BOun1ZYibCbIwXIrMmv7Pl4kSj5RYq+jSho1dRkNPA=;
        b=jJ9eozzaD5WeSd0mgY7tQQJE0WdZTh/qd4n8w37YZ+p/Dr4E7A325KGJVlE1a9bBMJrLuP
        dfiM6LjoYGEosWCNZN/iDd5gG75gLoBvUY824loD5Hm4EfSwIroKgsF//iSxpXBLuK+RBF
        B0LvA0lw1146deGlRWvJc6X4jT2YFTw=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-rgfQnNm_OJmKA1PWt-bS3g-1; Wed, 28 Apr 2021 13:46:43 -0400
X-MC-Unique: rgfQnNm_OJmKA1PWt-bS3g-1
Received: by mail-ej1-f70.google.com with SMTP id p25-20020a1709061419b0290378364a6464so12664617ejc.15
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 10:46:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8BOun1ZYibCbIwXIrMmv7Pl4kSj5RYq+jSho1dRkNPA=;
        b=nkbXBsgFOel7RYljnd8f0phOyuydAqC6YlYRE9ilUV4sRDHDkHtleubGcj06xrfm0w
         Yxk3blsFeSDbgWXcuAMvFwPnR9AMQ+965Oiygi+vz/Y/B76d+/mRikpNIvRlAXD7gwZ0
         2iFirb/uHe9BivsxzQJrR69TmJIsfQAY5Qr8OFGwaKXIiqCIk7CbORlVyKnhpV1HcVzh
         ouvNUUCbbe44XaOcJW3ON9pMT2Msdg540NevtK/1GVzGvkmoYFaq1ho2LyEFKN5wQBRS
         Q9ULIf9nXY7FoXmJeeULMh553lwqJi40bIzkY2rQn1s/Pwmp4mwuzILGISFQkFLyfqos
         qG2g==
X-Gm-Message-State: AOAM530yYPHUzazIdBkuKKW6FsmGvoMBFZcGMEOtP3KawXXiPql5+I6N
        jm+tX0zYKhTy6qjJq9T34T1yU5TrA69a8+rllNbKMn0dQhqOLHEv64Z8NVfaG+Ut0L5O8r8Tpnk
        8L6r/tLoVrLv4
X-Received: by 2002:aa7:c7d5:: with SMTP id o21mr13060593eds.166.1619632001801;
        Wed, 28 Apr 2021 10:46:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwjDsV9NGJUW50rDTXrCtAkYz85juYbP1wtFF5LgyE9uXZiwIK4vbpBeyZwXwTfivQpZPGnog==
X-Received: by 2002:aa7:c7d5:: with SMTP id o21mr13060570eds.166.1619632001620;
        Wed, 28 Apr 2021 10:46:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id u24sm361329edt.85.2021.04.28.10.46.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Apr 2021 10:46:41 -0700 (PDT)
To:     Ben Gardon <bgardon@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20210427223635.2711774-1-bgardon@google.com>
 <20210427223635.2711774-6-bgardon@google.com>
 <997f9fe3-847b-8216-c629-1ad5fdd2ffae@redhat.com>
 <CANgfPd8RZXQ-BamwQPS66Q5hLRZaDFhi0WaA=ZvCP4BbofiUhg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 5/6] KVM: x86/mmu: Protect kvm->memslots with a mutex
Message-ID: <d936b13b-bb00-fc93-de3b-adc59fa32a7b@redhat.com>
Date:   Wed, 28 Apr 2021 19:46:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CANgfPd8RZXQ-BamwQPS66Q5hLRZaDFhi0WaA=ZvCP4BbofiUhg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/04/21 18:40, Ben Gardon wrote:
> On Tue, Apr 27, 2021 at 11:25 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 28/04/21 00:36, Ben Gardon wrote:
>>> +void kvm_arch_assign_memslots(struct kvm *kvm, int as_id,
>>> +                          struct kvm_memslots *slots)
>>> +{
>>> +     mutex_lock(&kvm->arch.memslot_assignment_lock);
>>> +     rcu_assign_pointer(kvm->memslots[as_id], slots);
>>> +     mutex_unlock(&kvm->arch.memslot_assignment_lock);
>>> +}
>>
>> Does the assignment also needs the lock, or only the rmap allocation?  I
>> would prefer the hook to be something like kvm_arch_setup_new_memslots.
> 
> The assignment does need to be under the lock to prevent the following race:
> 1. Thread 1 (installing a new memslot): Acquires memslot assignment
> lock (or perhaps in this case rmap_allocation_lock would be more apt.)
> 2. Thread 1: Check alloc_memslot_rmaps (it is false)
> 3. Thread 1: doesn't allocate memslot rmaps for new slot
> 4. Thread 1: Releases memslot assignment lock
> 5. Thread 2 (allocating a shadow root): Acquires memslot assignment lock
> 6. Thread 2: Sets alloc_memslot_rmaps = true
> 7. Thread 2: Allocates rmaps for all existing slots
> 8. Thread 2: Releases memslot assignment lock
> 9. Thread 2: Sets shadow_mmu_active = true
> 10. Thread 1: Installs the new memslots
> 11. Thread 3: Null pointer dereference when trying to access rmaps on
> the new slot.

... because thread 3 would be under mmu_lock and therefore cannot 
allocate the rmap itself (you have to do it in mmu_alloc_shadow_roots, 
as in patch 6).

Related to this, your solution does not have to protect kvm_dup_memslots 
with the new lock, because the first update of the memslots will not go 
through kvm_arch_prepare_memory_region but it _will_ go through 
install_new_memslots and therefore through the new hook.  But overall I 
think I'd prefer to have a kvm->slots_arch_lock mutex in generic code, 
and place the call to kvm_dup_memslots and 
kvm_arch_prepare_memory_region inside that mutex.

That makes the new lock decently intuitive, and easily documented as 
"Architecture code can use slots_arch_lock if the contents of struct 
kvm_arch_memory_slot needs to be written outside 
kvm_arch_prepare_memory_region.  Unlike slots_lock, slots_arch_lock can 
be taken inside a ``kvm->srcu`` read-side critical section".

I admit I haven't thought about it very thoroughly, but if something 
like this is enough, it is relatively pretty:

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9b8e30dd5b9b..6e5106365597 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1333,6 +1333,7 @@ static struct kvm_memslots 
*install_new_memslots(struct kvm *kvm,

  	rcu_assign_pointer(kvm->memslots[as_id], slots);

+	mutex_unlock(&kvm->slots_arch_lock);
  	synchronize_srcu_expedited(&kvm->srcu);

  	/*
@@ -1399,6 +1398,7 @@ static int kvm_set_memslot(struct kvm *kvm,
  	struct kvm_memslots *slots;
  	int r;

+	mutex_lock(&kvm->slots_arch_lock);
  	slots = kvm_dup_memslots(__kvm_memslots(kvm, as_id), change);
  	if (!slots)
  		return -ENOMEM;
@@ -1427,6 +1427,7 @@ static int kvm_set_memslot(struct kvm *kvm,
  		 *	- kvm_is_visible_gfn (mmu_check_root)
  		 */
  		kvm_arch_flush_shadow_memslot(kvm, slot);
+		mutex_lock(&kvm->slots_arch_lock);
  	}

  	r = kvm_arch_prepare_memory_region(kvm, new, mem, change);

It does make the critical section a bit larger, so that the 
initialization of the shadow page (which is in KVM_RUN context) contends 
with slightly more code than necessary.  However it's all but a 
performance critical situation, as it will only happen just once per VM.

WDYT?

Paolo

> Putting the assignment under the lock prevents 5-8 from happening
> between 2 and 10.
> 
> I'm open to other ideas as far as how to prevent this race though. I
> admit this solution is not the most elegant looking.


