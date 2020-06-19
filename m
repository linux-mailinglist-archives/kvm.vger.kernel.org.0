Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5131201936
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 19:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390325AbgFSRSJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 13:18:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47618 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729842AbgFSRSH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jun 2020 13:18:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592587084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=O3j0VRVgpWvE/5JKvgt+8RjmBNIrWEUkZCGUeQsiriY=;
        b=a7mszB/PFYzVrTiae5N448BkY6Cgf2UjrnMjE2XuGGCjh2hll6MVUul/0yzVY0Mxc2Xziz
        0dapl9bnNRr8Bxy9Tn59C+gUDywhFC7wAoTiZ/3UYn3UukoJOO+eyAZSycbVxGuhcMiKnL
        TFsBMFPKJD9gwbuxJ4SZuClRVQ6OUzw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-eB7C4AzJNIebubprwXh0PQ-1; Fri, 19 Jun 2020 13:18:03 -0400
X-MC-Unique: eB7C4AzJNIebubprwXh0PQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 54D08BFC0;
        Fri, 19 Jun 2020 17:18:01 +0000 (UTC)
Received: from [10.36.112.17] (ovpn-112-17.ams2.redhat.com [10.36.112.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 26D7019D7B;
        Fri, 19 Jun 2020 17:17:58 +0000 (UTC)
Subject: Re: [PATCH v8 2/2] s390/kvm: diagnose 0x318 sync and reset
To:     Collin Walling <walling@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com, thuth@redhat.com
References: <20200618222222.23175-1-walling@linux.ibm.com>
 <20200618222222.23175-3-walling@linux.ibm.com>
 <eb41cdd1-9bdf-eb0c-1296-254ade66397a@redhat.com>
 <e080cf6d-c8cb-a363-1fd1-cbbc4cbda7fe@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <09821617-3f21-f61e-4e6e-6c992a43d787@redhat.com>
Date:   Fri, 19 Jun 2020 19:17:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <e080cf6d-c8cb-a363-1fd1-cbbc4cbda7fe@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19.06.20 17:47, Collin Walling wrote:
> On 6/19/20 10:52 AM, David Hildenbrand wrote:
>> On 19.06.20 00:22, Collin Walling wrote:
>>> DIAGNOSE 0x318 (diag318) sets information regarding the environment
>>> the VM is running in (Linux, z/VM, etc) and is observed via
>>> firmware/service events.
>>>
>>> This is a privileged s390x instruction that must be intercepted by
>>> SIE. Userspace handles the instruction as well as migration. Data
>>> is communicated via VCPU register synchronization.
>>>
>>> The Control Program Name Code (CPNC) is stored in the SIE block. The
>>> CPNC along with the Control Program Version Code (CPVC) are stored
>>> in the kvm_vcpu_arch struct.
>>>
>>> The CPNC is shadowed/unshadowed in VSIE.
>>>
>>
>> [...]
>>
>>>  
>>>  int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
>>> @@ -4194,6 +4198,10 @@ static void sync_regs_fmt2(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>>>  		if (vcpu->arch.pfault_token == KVM_S390_PFAULT_TOKEN_INVALID)
>>>  			kvm_clear_async_pf_completion_queue(vcpu);
>>>  	}
>>> +	if (kvm_run->kvm_dirty_regs & KVM_SYNC_DIAG318) {
>>> +		vcpu->arch.diag318_info.val = kvm_run->s.regs.diag318;
>>> +		vcpu->arch.sie_block->cpnc = vcpu->arch.diag318_info.cpnc;
>>> +	}
>>>  	/*
>>>  	 * If userspace sets the riccb (e.g. after migration) to a valid state,
>>>  	 * we should enable RI here instead of doing the lazy enablement.
>>> @@ -4295,6 +4303,7 @@ static void store_regs_fmt2(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>>>  	kvm_run->s.regs.pp = vcpu->arch.sie_block->pp;
>>>  	kvm_run->s.regs.gbea = vcpu->arch.sie_block->gbea;
>>>  	kvm_run->s.regs.bpbc = (vcpu->arch.sie_block->fpf & FPF_BPBC) == FPF_BPBC;
>>> +	kvm_run->s.regs.diag318 = vcpu->arch.diag318_info.val;
>>>  	if (MACHINE_HAS_GS) {
>>>  		__ctl_set_bit(2, 4);
>>>  		if (vcpu->arch.gs_enabled)
>>> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
>>> index 9e9056cebfcf..ba83d0568bc7 100644
>>> --- a/arch/s390/kvm/vsie.c
>>> +++ b/arch/s390/kvm/vsie.c
>>> @@ -423,6 +423,8 @@ static void unshadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>>>  		break;
>>>  	}
>>>  
>>> +	scb_o->cpnc = scb_s->cpnc;
>>
>> "This is a privileged s390x instruction that must be intercepted", how
>> can the cpnc change, then, while in SIE?
>>
>> Apart from that LGTM.
>>
> 
> I thought shadow/unshadow was a load/store (respectively) when executing
> in SIE for a level 3+ guest (where LPAR is level 1)?
> 
> * Shadow SCB (load shadow VSIE page; originally CPNC is 0)

1. Here, you copy the cpnc from the pinned (original) SCB to the shadow SCB.

> 
> * Execute diag318 (under SIE)

2. Here the SIE runs using the shadow SCB.

> 
> * Unshadow SCB (store in original VSIE page; CPNC is whatever code the
> guest decided to set)

3. Here you copy back the cpnc from the shadow SCB to the pinned
(original) SCB.


If 2. cannot modify the cpnc residing in the shadow SCB, 3. can be
dropped, because the values will always match.


If guest3 tries to modify the cpnc (via diag 318), we exit the SIE
(intercept) in 2., return to our guest 2. guest 2 will perform the
change and adapt the original SCB.

(yep, it's confusing)

Or did I miss anything?

-- 
Thanks,

David / dhildenb

