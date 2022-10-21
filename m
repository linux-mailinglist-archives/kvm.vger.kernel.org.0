Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD49606FA6
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 07:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbiJUFyp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 01:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiJUFyn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 01:54:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6473922519
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 22:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666331669;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tgI5G2J2rSqleABOMMgrdH7BPv6EX6F+tl8aXvUbqNo=;
        b=S5KbPqN+TIDc5XhHQhWGWoPekkctzBonWz2Pd4TZBWF4VTuy9VN7GgYezxKaL5cC0IpKm8
        RUCnIJeo4gHxLoE5XtAA0h6A5DzvWiR6DpyPbgqyBzfIQyX8EPEr9qZ+c8jY0cvxJawwdz
        BPYDmjOQkTTtj/TGBdCm7cLkIAc4iRA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-137-Z95UehEFMgGFnZY-mGL7eg-1; Fri, 21 Oct 2022 01:54:26 -0400
X-MC-Unique: Z95UehEFMgGFnZY-mGL7eg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5239E2A59579;
        Fri, 21 Oct 2022 05:54:25 +0000 (UTC)
Received: from [10.64.54.99] (vpn2-54-99.bne.redhat.com [10.64.54.99])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EB09A40CA41F;
        Fri, 21 Oct 2022 05:54:18 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v6 1/8] KVM: x86: Introduce KVM_REQ_RING_SOFT_FULL
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, peterx@redhat.com, maz@kernel.org,
        will@kernel.org, catalin.marinas@arm.com, bgardon@google.com,
        shuah@kernel.org, andrew.jones@linux.dev, dmatlack@google.com,
        pbonzini@redhat.com, zhenyzha@redhat.com, james.morse@arm.com,
        suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        oliver.upton@linux.dev, shan.gavin@gmail.com
References: <20221011061447.131531-1-gshan@redhat.com>
 <20221011061447.131531-2-gshan@redhat.com> <Y1HO46UCyhc9M6nM@google.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <db2cb7da-d3b1-c87e-4362-94764a7ea480@redhat.com>
Date:   Fri, 21 Oct 2022 13:54:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Y1HO46UCyhc9M6nM@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On 10/21/22 6:42 AM, Sean Christopherson wrote:
> On Tue, Oct 11, 2022, Gavin Shan wrote:
>> This adds KVM_REQ_RING_SOFT_FULL, which is raised when the dirty
> 
> "This" is basically "This patch", which is generally frowned upon.  Just state
> what changes are being made.
> 

Ok.

>> ring of the specific VCPU becomes softly full in kvm_dirty_ring_push().
>> The VCPU is enforced to exit when the request is raised and its
>> dirty ring is softly full on its entrance.
>>
>> The event is checked and handled in the newly introduced helper
>> kvm_dirty_ring_check_request(). With this, kvm_dirty_ring_soft_full()
>> becomes a private function.
> 
> None of this captures why the request is being added.  I'm guessing Marc's
> motivation is to avoid having to check ring on every entry, though there might
> also be a correctness issue too?
> 
> It'd also be helpful to explain that KVM re-queues the request to maintain KVM's
> existing uABI, which enforces the soft_limit even if no entries have been added
> to the ring since the last KVM_EXIT_DIRTY_RING_FULL exit.
> 
> And maybe call out the alternative(s) that was discussed in v2[*]?
> 
> [*] https://lore.kernel.org/all/87illlkqfu.wl-maz@kernel.org
> 

I think Marc want to make the check more generalized with a new event [1].

[1] https://lore.kernel.org/kvmarm/87fshovtu0.wl-maz@kernel.org/

Yes, the commit log will be modified accordingly after your comments are
addressed. I will add something to explain why KVM_REQ_DIRTY_RING_SOFT_FULL
needed to re-queued, to ensure we have spare space in the dirty ring before
the VCPU becomes runnable.

>> Suggested-by: Marc Zyngier <maz@kernel.org>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> Reviewed-by: Peter Xu <peterx@redhat.com>
>> ---
>>   arch/x86/kvm/x86.c             | 15 ++++++---------
>>   include/linux/kvm_dirty_ring.h |  8 ++------
>>   include/linux/kvm_host.h       |  1 +
>>   virt/kvm/dirty_ring.c          | 19 ++++++++++++++++++-
>>   4 files changed, 27 insertions(+), 16 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index b0c47b41c264..0dd0d32073e7 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -10260,16 +10260,13 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>>   
>>   	bool req_immediate_exit = false;
>>   
>> -	/* Forbid vmenter if vcpu dirty ring is soft-full */
>> -	if (unlikely(vcpu->kvm->dirty_ring_size &&
>> -		     kvm_dirty_ring_soft_full(&vcpu->dirty_ring))) {
>> -		vcpu->run->exit_reason = KVM_EXIT_DIRTY_RING_FULL;
>> -		trace_kvm_dirty_ring_exit(vcpu);
>> -		r = 0;
>> -		goto out;
>> -	}
>> -
>>   	if (kvm_request_pending(vcpu)) {
>> +		/* Forbid vmenter if vcpu dirty ring is soft-full */
> 
> Eh, I'd drop the comment, pretty obvious what the code is doing
> 

Ok, It will be dropped in next revision.

>> +		if (kvm_dirty_ring_check_request(vcpu)) {
> 
> I think it makes to move this check below at KVM_REQ_VM_DEAD.  I doubt it will
> ever matter in practice, but conceptually VM_DEAD is a higher priority event.
> 
> I'm pretty sure the check can be moved to the very end of the request checks,
> e.g. to avoid an aborted VM-Enter attempt if one of the other request triggers
> KVM_REQ_RING_SOFT_FULL.
> 
> Heh, this might actually be a bug fix of sorts.  If anything pushes to the ring
> after the check at the start of vcpu_enter_guest(), then without the request, KVM
> would enter the guest while at or above the soft limit, e.g. record_steal_time()
> can dirty a page, and the big pile of stuff that's behind KVM_REQ_EVENT can
> certainly dirty pages.
> 

When dirty ring becomes full, the VCPU can't handle any operations, which will
bring more dirty pages. So lets move the check right after KVM_REQ_VM_DEAD, which
is obviously having higher priority than KVM_REQ_DIRTY_RING_SOFT_FULL.

>> +			r = 0;
>> +			goto out;
>> +		}
>> +
>>   		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu)) {
>>   			r = -EIO;
>>   			goto out;
> 
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -157,6 +157,7 @@ static inline bool is_error_page(struct page *page)
>>   #define KVM_REQ_VM_DEAD           (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>>   #define KVM_REQ_UNBLOCK           2
>>   #define KVM_REQ_UNHALT            3
> 
> UNHALT is gone, the new request can use '3'.
> 

Yep :)

>> +#define KVM_REQ_RING_SOFT_FULL    4
> 
> Any objection to calling this KVM_REQ_DIRTY_RING_SOFT_FULL?  None of the users
> are in danger of having too long lines, and at first glance it's not clear that
> this is specifically for the dirty ring.
> 
> It'd also give us an excuse to replace spaces with tabs in the above alignment :-)
> 
> #define KVM_REQ_TLB_FLUSH		(0 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> #define KVM_REQ_VM_DEAD			(1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> #define KVM_REQ_UNBLOCK			2
> #define KVM_REQ_DIRTY_RING_SOFT_FULL	3
> #define KVM_REQUEST_ARCH_BASE		8
> 

KVM_REQ_DIRTY_RING_SOFT_FULL is better. I will rename the event and
replace spaces with tabs in next revision.

>> @@ -149,6 +149,7 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
>>   
>>   void kvm_dirty_ring_push(struct kvm_dirty_ring *ring, u32 slot, u64 offset)
>>   {
>> +	struct kvm_vcpu *vcpu = container_of(ring, struct kvm_vcpu, dirty_ring);
>>   	struct kvm_dirty_gfn *entry;
>>   
>>   	/* It should never get full */
>> @@ -166,6 +167,22 @@ void kvm_dirty_ring_push(struct kvm_dirty_ring *ring, u32 slot, u64 offset)
>>   	kvm_dirty_gfn_set_dirtied(entry);
>>   	ring->dirty_index++;
>>   	trace_kvm_dirty_ring_push(ring, slot, offset);
>> +
>> +	if (kvm_dirty_ring_soft_full(ring))
>> +		kvm_make_request(KVM_REQ_RING_SOFT_FULL, vcpu);
> 
> Would it make sense to clear the request in kvm_dirty_ring_reset()?  I don't care
> about the overhead of having to re-check the request, the goal would be to help
> document what causes the request to go away.
> 
> E.g. modify kvm_dirty_ring_reset() to take @vcpu and then do:
> 
> 	if (!kvm_dirty_ring_soft_full(ring))
> 		kvm_clear_request(KVM_REQ_RING_SOFT_FULL, vcpu);
> 

It's reasonable to clear KVM_REQ_DIRTY_RING_SOFT_FULL when the ring is reseted.
@vcpu can be achieved by container_of(..., ring).


>> +}
>> +
>> +bool kvm_dirty_ring_check_request(struct kvm_vcpu *vcpu)
>> +{
>> +	if (kvm_check_request(KVM_REQ_RING_SOFT_FULL, vcpu) &&
>> +		kvm_dirty_ring_soft_full(&vcpu->dirty_ring)) {
> 
> Align please,
> 

  Will be fixed in next revision.

> 	if (kvm_check_request(KVM_REQ_RING_SOFT_FULL, vcpu) &&
> 	    kvm_dirty_ring_soft_full(&vcpu->dirty_ring)) {
> 
>> +		kvm_make_request(KVM_REQ_RING_SOFT_FULL, vcpu);
> 
> A comment would be helpful to explain (a) why KVM needs to re-check on the next
> KVM_RUN and (b) why this won't indefinitely prevent KVM from entering the guest.
> For pretty every other request I can think of, re-queueing a request like this
> will effectively hang the vCPU, i.e. this looks wrong at first glance.
> 

It can indefinitely prevent the VCPU from running if the dirty pages aren't
harvested and the dirty ring is reseted by userspace. I will add something
like below to explain why we need to re-queue the event.

        /*
         * The VCPU isn't runnable when the dirty ring becomes full. The
         * KVM_REQ_DIRTY_RING_SOFT_FULL event is always set to prevent
         * the VCPU from running until the dirty pages are harvested and
         * the dirty ring is reseted by userspace.
         */


>> +		vcpu->run->exit_reason = KVM_EXIT_DIRTY_RING_FULL;
>> +		trace_kvm_dirty_ring_exit(vcpu);
>> +		return true;
>> +	}
>> +
>> +	return false;
>>   }
>>   
>>   struct page *kvm_dirty_ring_get_page(struct kvm_dirty_ring *ring, u32 offset)
>> -- 
>> 2.23.0
>>
> 

