Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9EF845422A
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 08:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234056AbhKQH5w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 02:57:52 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63112 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234016AbhKQH5v (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Nov 2021 02:57:51 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AH7jOvN027191;
        Wed, 17 Nov 2021 07:54:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=nvkHJM9iW1Y1hh37kgc4noHhZP2n5kau9SCNVmfKSLA=;
 b=USL4rXZ6bxqE0rSqUINXoQy7PX4S6BEcW6v/nByWhQjIFVdD+5ULVgmc7oGqIdRXbsPa
 dyTDfyeIKT29PmF0FSBtV+oMjpqEzvrbftyCWs5OeJrqWNw0fx3AUzhXweEuddjGR6C1
 YqnzwJzQ2sGJTBczKYk0bdvz1N1pclnKH5GNtiHQI7CX7l6PC1/lI9mJFOS1w3pEgctT
 BIxkC/vmEDm26hlWrh9hfwCczL5QOKi3y7DGPPYXNAuaN0wDuNMby2Kk0vbb1zElKJCd
 cBNW0WuqVfA2OVdyEKT3Tj/OGGzsZbJWlQjiLuCnLwfsGKdaWkKoHSI/pItKQw248m1o mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ccwmmr4wy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Nov 2021 07:54:53 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AH7orHx024036;
        Wed, 17 Nov 2021 07:54:53 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ccwmmr4wh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Nov 2021 07:54:52 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AH7r1fO004838;
        Wed, 17 Nov 2021 07:54:50 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3ca50b752p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Nov 2021 07:54:50 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AH7sl9o3211978
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Nov 2021 07:54:47 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E2CB1AE055;
        Wed, 17 Nov 2021 07:54:46 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7760BAE045;
        Wed, 17 Nov 2021 07:54:46 +0000 (GMT)
Received: from [9.171.32.217] (unknown [9.171.32.217])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 17 Nov 2021 07:54:46 +0000 (GMT)
Message-ID: <9c9bbf66-54c9-3d02-6d9f-1e147945abe8@de.ibm.com>
Date:   Wed, 17 Nov 2021 08:54:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH v3 2/2] KVM: s390: Extend the USER_SIGP capability
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20211110203322.1374925-1-farman@linux.ibm.com>
 <20211110203322.1374925-3-farman@linux.ibm.com>
 <dd8a8b49-da6d-0ab8-dc47-b24f5604767f@redhat.com>
 <ab82e68051674ea771e2cb5371ca2a204effab40.camel@linux.ibm.com>
 <32836eb5-532f-962d-161a-faa2213a0691@linux.ibm.com>
 <b116e738d8f9b185867ab28395012aaddd58af31.camel@linux.ibm.com>
 <85ba9fa3-ca25-b598-aecd-5e0c6a0308f2@redhat.com>
 <19a2543b24015873db736bddb14d0e4d97712086.camel@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <19a2543b24015873db736bddb14d0e4d97712086.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WioIncOhfvadwMr29MvEfUaUqu7qsl5o
X-Proofpoint-GUID: ewtdicPFJyDTz0o7uQe5kS9JjxcYxuph
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-17_02,2021-11-16_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 clxscore=1015 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 suspectscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111170034
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 11.11.21 um 20:05 schrieb Eric Farman:
> On Thu, 2021-11-11 at 19:29 +0100, David Hildenbrand wrote:
>> On 11.11.21 18:48, Eric Farman wrote:
>>> On Thu, 2021-11-11 at 17:13 +0100, Janosch Frank wrote:
>>>> On 11/11/21 16:03, Eric Farman wrote:
>>>>> On Thu, 2021-11-11 at 10:15 +0100, David Hildenbrand wrote:
>>>>>> On 10.11.21 21:33, Eric Farman wrote:
>>>>>>> With commit 2444b352c3ac ("KVM: s390: forward most SIGP
>>>>>>> orders
>>>>>>> to
>>>>>>> user
>>>>>>> space") we have a capability that allows the "fast" SIGP
>>>>>>> orders
>>>>>>> (as
>>>>>>> defined by the Programming Notes for the SIGNAL PROCESSOR
>>>>>>> instruction in
>>>>>>> the Principles of Operation) to be handled in-kernel, while
>>>>>>> all
>>>>>>> others are
>>>>>>> sent to userspace for processing.
>>>>>>>
>>>>>>> This works fine but it creates a situation when, for
>>>>>>> example, a
>>>>>>> SIGP SENSE
>>>>>>> might return CC1 (STATUS STORED, and status bits indicating
>>>>>>> the
>>>>>>> vcpu is
>>>>>>> stopped), when in actuality userspace is still processing a
>>>>>>> SIGP
>>>>>>> STOP AND
>>>>>>> STORE STATUS order, and the vcpu is not yet actually
>>>>>>> stopped.
>>>>>>> Thus,
>>>>>>> the
>>>>>>> SIGP SENSE should actually be returning CC2 (busy) instead
>>>>>>> of
>>>>>>> CC1.
>>>>>>>
>>>>>>> To fix this, add another CPU capability, dependent on the
>>>>>>> USER_SIGP
>>>>>>> one,
>>>>>>> and two associated IOCTLs. One IOCTL will be used by
>>>>>>> userspace
>>>>>>> to
>>>>>>> mark a
>>>>>>> vcpu "busy" processing a SIGP order, and cause concurrent
>>>>>>> orders
>>>>>>> handled
>>>>>>> in-kernel to be returned with CC2 (busy). Another IOCTL
>>>>>>> will be
>>>>>>> used by
>>>>>>> userspace to mark the SIGP "finished", and the vcpu free to
>>>>>>> process
>>>>>>> additional orders.
>>>>>>>
>>>>>>
>>>>>> This looks much cleaner to me, thanks!
>>>>>>
>>>>>> [...]
>>>>>>
>>>>>>> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-
>>>>>>> s390.h
>>>>>>> index c07a050d757d..54371cede485 100644
>>>>>>> --- a/arch/s390/kvm/kvm-s390.h
>>>>>>> +++ b/arch/s390/kvm/kvm-s390.h
>>>>>>> @@ -82,6 +82,22 @@ static inline int is_vcpu_idle(struct
>>>>>>> kvm_vcpu
>>>>>>> *vcpu)
>>>>>>>    	return test_bit(vcpu->vcpu_idx, vcpu->kvm-
>>>>>>>> arch.idle_mask);
>>>>>>>    }
>>>>>>>    
>>>>>>> +static inline bool kvm_s390_vcpu_is_sigp_busy(struct
>>>>>>> kvm_vcpu
>>>>>>> *vcpu)
>>>>>>> +{
>>>>>>> +	return (atomic_read(&vcpu->arch.sigp_busy) == 1);
>>>>>>
>>>>>> You can drop ()
>>>>>>
>>>>>>> +}
>>>>>>> +
>>>>>>> +static inline bool kvm_s390_vcpu_set_sigp_busy(struct
>>>>>>> kvm_vcpu
>>>>>>> *vcpu)
>>>>>>> +{
>>>>>>> +	/* Return zero for success, or -EBUSY if another vcpu
>>>>>>> won */
>>>>>>> +	return (atomic_cmpxchg(&vcpu->arch.sigp_busy, 0, 1) ==
>>>>>>> 0) ? 0 :
>>>>>>> -EBUSY;
>>>>>>
>>>>>> You can drop () as well.
>>>>>>
>>>>>> We might not need the -EBUSY semantics after all. User space
>>>>>> can
>>>>>> just
>>>>>> track if it was set, because it's in charge of setting it.
>>>>>
>>>>> Hrm, I added this to distinguish a newer kernel with an older
>>>>> QEMU,
>>>>> but
>>>>> of course an older QEMU won't know the difference either. I'll
>>>>> doublecheck that this is works fine in the different
>>>>> permutations.
>>>>>
>>>>>>> +}
>>>>>>> +
>>>>>>> +static inline void kvm_s390_vcpu_clear_sigp_busy(struct
>>>>>>> kvm_vcpu
>>>>>>> *vcpu)
>>>>>>> +{
>>>>>>> +	atomic_set(&vcpu->arch.sigp_busy, 0);
>>>>>>> +}
>>>>>>> +
>>>>>>>    static inline int kvm_is_ucontrol(struct kvm *kvm)
>>>>>>>    {
>>>>>>>    #ifdef CONFIG_KVM_S390_UCONTROL
>>>>>>> diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
>>>>>>> index 5ad3fb4619f1..a37496ea6dfa 100644
>>>>>>> --- a/arch/s390/kvm/sigp.c
>>>>>>> +++ b/arch/s390/kvm/sigp.c
>>>>>>> @@ -276,6 +276,10 @@ static int handle_sigp_dst(struct
>>>>>>> kvm_vcpu
>>>>>>> *vcpu, u8 order_code,
>>>>>>>    	if (!dst_vcpu)
>>>>>>>    		return SIGP_CC_NOT_OPERATIONAL;
>>>>>>>    
>>>>>>> +	if (kvm_s390_vcpu_is_sigp_busy(dst_vcpu)) {
>>>>>>> +		return SIGP_CC_BUSY;
>>>>>>> +	}
>>>>>>
>>>>>> You can drop {}
>>>>>
>>>>> Arg, I had some debug in there which needed the braces, and of
>>>>> course
>>>>> it's unnecessary now. Thanks.
>>>>>
>>>>>>> +
>>>>>>>    	switch (order_code) {
>>>>>>>    	case SIGP_SENSE:
>>>>>>>    		vcpu->stat.instruction_sigp_sense++;
>>>>>>> @@ -411,6 +415,12 @@ int kvm_s390_handle_sigp(struct
>>>>>>> kvm_vcpu
>>>>>>> *vcpu)
>>>>>>>    	if (handle_sigp_order_in_user_space(vcpu, order_code,
>>>>>>> cpu_addr))
>>>>>>>    		return -EOPNOTSUPP;
>>>>>>>    
>>>>>>> +	/* Check the current vcpu, if it was a target from
>>>>>>> another vcpu
>>>>>>> */
>>>>>>> +	if (kvm_s390_vcpu_is_sigp_busy(vcpu)) {
>>>>>>> +		kvm_s390_set_psw_cc(vcpu, SIGP_CC_BUSY);
>>>>>>> +		return 0;
>>>>>>> +	}
>>>>>>
>>>>>> I don't think we need this. I think the above (checking the
>>>>>> target of
>>>>>> a
>>>>>> SIGP order) is sufficient. Or which situation do you have in
>>>>>> mind?
>>>>>>
>>>>>
>>>>> Hrm... I think you're right. I was thinking of this:
>>>>>
>>>>> VCPU 1 - SIGP STOP CPU 2
>>>>> VCPU 2 - SIGP SENSE CPU 1
>>>>>
>>>>> But of course either CPU2 is going to be marked "busy" first,
>>>>> and
>>>>> the
>>>>> sense doesn't get processed until it's reset, or the sense
>>>>> arrives
>>>>> first, and the busy/notbusy doesn't matter. Let me doublecheck
>>>>> my
>>>>> tests
>>>>> for the non-RFC version.
>>>>>
>>>>>> I do wonder if we want to make this a kvm_arch_vcpu_ioctl()
>>>>>> instead,
>>>>>
>>>>> In one of my original attempts between v1 and v2, I had put
>>>>> this
>>>>> there.
>>>>> This reliably deadlocks my guest, because the caller
>>>>> (kvm_vcpu_ioctl())
>>>>> tries to acquire vcpu->mutex, and racing SIGPs (via KVM_RUN)
>>>>> might
>>>>> already be holding it. Thus, it's an async ioctl. I could fold
>>>>> it
>>>>> into
>>>>> the existing interrupt ioctl, but as those are architected
>>>>> structs
>>>>> it
>>>>> seems more natural do it this way. Or I have mis-understood
>>>>> something
>>>>> along the way?
>>>>>
>>>>>> essentially just providing a KVM_S390_SET_SIGP_BUSY *and*
>>>>>> providing
>>>>>> the
>>>>>> order. "order == 0" sets it to !busy.
>>>>>
>>>>> I'd tried this too, since it provided some nice debug-ability.
>>>>> Unfortunately, I have a testcase (which I'll eventually get
>>>>> folded
>>>>> into
>>>>> kvm-unit-tests :)) that picks a random order between 0-255,
>>>>> knowing
>>>>> that there's only a couple handfuls of valid orders, to check
>>>>> the
>>>>> response. Zero is valid architecturally (POPS figure 4-29),
>>>>> even if
>>>>> it's unassigned. The likelihood of it becoming assigned is
>>>>> probably
>>>>> quite low, but I'm not sure that I like special-casing an order
>>>>> of
>>>>> zero
>>>>> in this way.
>>>>>
>>>>
>>>> Looking at the API I'd like to avoid having two IOCTLs
>>>
>>> Since the order is a single byte, we could have the payload of an
>>> ioctl
>>> say "0-255 is an order that we're busy processing, anything higher
>>> than
>>> that resets the busy" or something. That would remove the need for
>>> a
>>> second IOCTL.
>>
>> Maybe just pass an int and treat a negative (or just -1) value as
>> clearing the order.
>>
> 
> Right, that's exactly what I had at one point. I thought it was too
> cumbersome, but maybe not. Will dust it off, pending my question to
> Janosch about 0-vs-1 IOCTLs.

As a totally different idea. Would a sync_reg value called SIGP_BUSY
work as well?

