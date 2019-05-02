Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8575411EB6
	for <lists+kvm@lfdr.de>; Thu,  2 May 2019 17:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbfEBPjx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 May 2019 11:39:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32838 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726935AbfEBPjw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 May 2019 11:39:52 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4EEDD30832E1;
        Thu,  2 May 2019 15:39:52 +0000 (UTC)
Received: from [10.36.117.88] (ovpn-117-88.ams2.redhat.com [10.36.117.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 01A005D960;
        Thu,  2 May 2019 15:39:50 +0000 (UTC)
Subject: Re: [PATCH v4 2/2] s390/kvm: diagnose 318 handling
To:     Collin Walling <walling@linux.ibm.com>, cohuck@redhat.com,
        pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <1556751063-21835-1-git-send-email-walling@linux.ibm.com>
 <1556751063-21835-3-git-send-email-walling@linux.ibm.com>
 <783ecdb4-3bc2-4bf3-55cb-9a902467aadd@redhat.com>
 <1988b4c3-e123-47dd-2008-15d8bec0171d@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 SE+xAvmumFBY
Organization: Red Hat GmbH
Message-ID: <02bfe52f-95e7-b4a3-e8d3-a8a8fffc5dec@redhat.com>
Date:   Thu, 2 May 2019 17:39:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1988b4c3-e123-47dd-2008-15d8bec0171d@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Thu, 02 May 2019 15:39:52 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02.05.19 17:25, Collin Walling wrote:
> On 5/2/19 8:59 AM, David Hildenbrand wrote:
>> On 02.05.19 00:51, Collin Walling wrote:
>>> DIAGNOSE 0x318 (diag318) is a privileged s390x instruction that must
>>> be intercepted by SIE and handled via KVM. Let's introduce some
>>> functions to communicate between userspace and KVM via ioctls. These
>>> will be used to get/set the diag318 related information (also known
>>> as the "Control Program Code" or "CPC"), as well as check the system
>>> if KVM supports handling this instruction.
>>>
>>> This information can help with diagnosing the OS the VM is running
>>> in (Linux, z/VM, etc) if the OS calls this instruction.
>>>
>>> The get/set functions are introduced primarily for VM migration and
>>> reset, though no harm could be done to the system if a userspace
>>> program decides to alter this data (this is highly discouraged).
>>>
>>> The Control Program Name Code (CPNC) is stored in the SIE block and
>>> a copy is retained in each VCPU. The Control Program Version Code
>>> (CPVC) retains a copy in each VCPU as well.
>>>
>>> At this time, the CPVC is not reported as its format is yet to be
>>> defined.
>>>
>>> Note that the CPNC is set in the SIE block iff the host hardware
>>> supports it.
>>
>> For vSIE and SIE you only configure the CPNC. Is that sufficient?
>> Shouldn't diag318 allow the guest to set both? (especially regarding vSIE)
>>
> 
> The SIE block only stores the CPNC. The CPVC is not designed to be
> stored in the SIE block, so we store it in guest memory only.

How can the cpvc value be used? Who will access it? Right now, it is
only written to some location in KVM, and only read/written during
migration.

You mention "The Control Program Version Code (CPVC) retains a copy in
each VCPU as well", this is wrong, no?

> 
>> [...]
>>>
>>> diff --git a/Documentation/virtual/kvm/devices/vm.txt b/Documentation/virtual/kvm/devices/vm.txt
>>> index 95ca68d..9a8d934 100644
>>> --- a/Documentation/virtual/kvm/devices/vm.txt
>>> +++ b/Documentation/virtual/kvm/devices/vm.txt
>>> @@ -267,3 +267,17 @@ Parameters: address of a buffer in user space to store the data (u64) to;
>>>   	    if it is enabled
>>>   Returns:    -EFAULT if the given address is not accessible from kernel space
>>>   	    0 in case of success.
>>> +
>>> +6. GROUP: KVM_S390_VM_MISC
>>> +Architectures: s390
>>> +
>>> +6.1. KVM_S390_VM_MISC_CPC (r/w)
>>> +
>>> +Allows userspace to access the "Control Program Code" which consists of a
>>> +1-byte "Control Program Name Code" and a 7-byte "Control Program Version Code".
>>> +This information is initialized during IPL and must be preserved during
>>> +migration.
>>
>> Your implementation does not match this description. User space can only
>> get/set the cpnc effectively for the HW to see it, not the CPVC, no?
>>
> 
> We retrieve the entire CPNC + CPVC. User space (i.e. QEMU) can retrieve
> this 64-bit value and save / load it during live guest migration.
> 
> I figured it would be best to set / get this entire value now, so that
> we don't need to add extra handling for the version code later when its
> format is properly decided.
> 
>> Shouldn't you transparently forward that data to the SCB for vSIE/SIE,
>> because we really don't care what the target format will be?
>>
> 
> Sorry, I'm not fully understanding what you mean by "we really don't
> care what the target format will be?"
> 
> Do you mean to shadow the CPNC without checking if diag318 is supported?
> I imagine that would be harmless.

No, I was rather wondering about the CPVC format. But I think I am
missing how that one will be used at all.

-- 

Thanks,

David / dhildenb
