Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 650FD10D712
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2019 15:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbfK2OeB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Nov 2019 09:34:01 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30943 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726893AbfK2OeB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Nov 2019 09:34:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575038039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=GIuVjQcobpZM2fm7slB9w0cSSv7BUzvgqxu4TntWSQU=;
        b=OqrJpNeypMV++x01IaTtDvqxtKnIL/1PdJ7IvbZA3Nj6kt2H8p+Tb6+s8hI51pY7V7MLzr
        O+s5thgFBs5pXh8YZtLOqmQrKtroKRnaB2X7UqmA0kD3GdkN41wUG783QQcjTnDLccwr1k
        TuZxTYEWL8gkoOZBUE8mxFoZCDcwmI8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-RBfGoIP9Nkq0W2265vgCpQ-1; Fri, 29 Nov 2019 09:33:56 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 61F15107ACC9;
        Fri, 29 Nov 2019 14:33:55 +0000 (UTC)
Received: from [10.36.118.44] (unknown [10.36.118.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D2E5019C58;
        Fri, 29 Nov 2019 14:33:53 +0000 (UTC)
Subject: Re: [PATCH] KVM: s390: Add new reset vcpu API
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, borntraeger@de.ibm.com, mihajlov@linux.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20191129142122.21528-1-frankja@linux.ibm.com>
 <bc1d057f-03a0-b850-dff8-a7156bfe3274@redhat.com>
 <8e1aa1af-d929-e36b-f341-aa7dbe27f6a4@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 SE+xAvmumFBY
Organization: Red Hat GmbH
Message-ID: <227a8fce-7e14-030e-b0a4-17e4521eed98@redhat.com>
Date:   Fri, 29 Nov 2019 15:33:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <8e1aa1af-d929-e36b-f341-aa7dbe27f6a4@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: RBfGoIP9Nkq0W2265vgCpQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29.11.19 15:33, Janosch Frank wrote:
> On 11/29/19 3:31 PM, David Hildenbrand wrote:
>> On 29.11.19 15:21, Janosch Frank wrote:
>>> The architecture states that we need to reset local IRQs for all CPU
>>> resets. Because the old reset interface did not support the normal CPU
>>> reset we never did that.
>>>
>>> Now that we have a new interface, let's properly clear out local IRQs
>>> and let this commit be a reminder.
>>>
>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>> ---
>>>  arch/s390/kvm/kvm-s390.c | 25 ++++++++++++++++++++++++-
>>>  include/uapi/linux/kvm.h |  7 +++++++
>>>  2 files changed, 31 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>> index d9e6bf3d54f0..2f74ff46b176 100644
>>> --- a/arch/s390/kvm/kvm-s390.c
>>> +++ b/arch/s390/kvm/kvm-s390.c
>>> @@ -529,6 +529,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>>  	case KVM_CAP_S390_CMMA_MIGRATION:
>>>  	case KVM_CAP_S390_AIS:
>>>  	case KVM_CAP_S390_AIS_MIGRATION:
>>> +	case KVM_CAP_S390_VCPU_RESETS:
>>>  		r = 1;
>>>  		break;
>>>  	case KVM_CAP_S390_HPAGE_1M:
>>> @@ -3293,6 +3294,25 @@ static int kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu)
>>>  	return 0;
>>>  }
>>>  
>>> +static int kvm_arch_vcpu_ioctl_reset(struct kvm_vcpu *vcpu, unsigned long type)
>>> +{
>>> +	int rc = -EINVAL;
>>> +
>>> +	switch (type) {
>>> +	case KVM_S390_VCPU_RESET_NORMAL:
>>> +		rc = 0;
>>> +		kvm_clear_async_pf_completion_queue(vcpu);
>>> +		kvm_s390_clear_local_irqs(vcpu);
>>> +		break;
>>> +	case KVM_S390_VCPU_RESET_INITIAL:
>>> +		/* fallthrough */
>>> +	case KVM_S390_VCPU_RESET_CLEAR:
>>> +		rc = kvm_arch_vcpu_ioctl_initial_reset(vcpu);
>>
>> As we now have two interfaces to achieve the same thing (initial reset),
>> I do wonder if we should simply introduce
>>
>> KVM_S390_NORMAL_RESET
>> KVM_S390_CLEAR_RESET
>>
>> instead ...
>>
>> Then you can do KVM_S390_NORMAL_RESET for the bugfix and
>> KVM_S390_CLEAR_RESET later for PV.
>>
>> Does anything speak against that?
> 
> Apart from loosing one more ioctl number probably not

Do we care? (I think not, but maybe I am missing something :) )

-- 
Thanks,

David / dhildenb

