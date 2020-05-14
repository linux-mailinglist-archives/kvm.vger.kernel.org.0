Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3BD1D2BEB
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 11:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726161AbgENJxj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 05:53:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38347 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725925AbgENJxj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 05:53:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589450016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=Us/4qmEKKUhwOIJAkiRV4bYllBWwmCjeXn4/+gU+EfA=;
        b=ekLVOCZ/RhLJqSt7MRjMF33aRT9cL0Tdq0OMs7+zeHobtm7nQOn27RPOoWse1X4PIlAj+I
        Ppp6J3Koqc7Iof+KmAl/OfR+7vAXhBYTxhbTvS6UoG5BU9GSEJ8Uh7isXJAkiSe9pawear
        7UoqVp8201VEjqfr+4rky0pFcLwEA0g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-_GlTj0hONOS_Mmn3UIuoYQ-1; Thu, 14 May 2020 05:53:32 -0400
X-MC-Unique: _GlTj0hONOS_Mmn3UIuoYQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2DA62835B40;
        Thu, 14 May 2020 09:53:31 +0000 (UTC)
Received: from [10.36.114.168] (ovpn-114-168.ams2.redhat.com [10.36.114.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AFD087D951;
        Thu, 14 May 2020 09:53:28 +0000 (UTC)
Subject: Re: [PATCH v6 2/2] s390/kvm: diagnose 318 handling
To:     Janosch Frank <frankja@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Collin Walling <walling@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com, heiko.carstens@de.ibm.com,
        gor@linux.ibm.com
References: <20200513221557.14366-1-walling@linux.ibm.com>
 <20200513221557.14366-3-walling@linux.ibm.com>
 <d4320d09-7b3a-ac13-77be-02397f4ccc83@redhat.com>
 <de4e4416-5158-b60f-e2a8-fb6d3d48d516@linux.ibm.com>
 <88d27a61-b55b-ee68-f7f9-85ce7fcefd64@redhat.com>
 <e7691d9a-a446-17db-320e-a2348e0eb057@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <516405b3-67c4-aa12-1fa5-772e401e4403@redhat.com>
Date:   Thu, 14 May 2020 11:53:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <e7691d9a-a446-17db-320e-a2348e0eb057@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14.05.20 11:49, Janosch Frank wrote:
> On 5/14/20 11:37 AM, David Hildenbrand wrote:
>> On 14.05.20 10:52, Janosch Frank wrote:
>>> On 5/14/20 9:53 AM, Thomas Huth wrote:
>>>> On 14/05/2020 00.15, Collin Walling wrote:
>>>>> DIAGNOSE 0x318 (diag318) is a privileged s390x instruction that must
>>>>> be intercepted by SIE and handled via KVM. Let's introduce some
>>>>> functions to communicate between userspace and KVM via ioctls. These
>>>>> will be used to get/set the diag318 related information, as well as
>>>>> check the system if KVM supports handling this instruction.
>>>>>
>>>>> This information can help with diagnosing the environment the VM is
>>>>> running in (Linux, z/VM, etc) if the OS calls this instruction.
>>>>>
>>>>> By default, this feature is disabled and can only be enabled if a
>>>>> user space program (such as QEMU) explicitly requests it.
>>>>>
>>>>> The Control Program Name Code (CPNC) is stored in the SIE block
>>>>> and a copy is retained in each VCPU. The Control Program Version
>>>>> Code (CPVC) is not designed to be stored in the SIE block, so we
>>>>> retain a copy in each VCPU next to the CPNC.
>>>>>
>>>>> Signed-off-by: Collin Walling <walling@linux.ibm.com>
>>>>> ---
>>>>>  Documentation/virt/kvm/devices/vm.rst | 29 +++++++++
>>>>>  arch/s390/include/asm/kvm_host.h      |  6 +-
>>>>>  arch/s390/include/uapi/asm/kvm.h      |  5 ++
>>>>>  arch/s390/kvm/diag.c                  | 20 ++++++
>>>>>  arch/s390/kvm/kvm-s390.c              | 89 +++++++++++++++++++++++++++
>>>>>  arch/s390/kvm/kvm-s390.h              |  1 +
>>>>>  arch/s390/kvm/vsie.c                  |  2 +
>>>>>  7 files changed, 151 insertions(+), 1 deletion(-)
>>>> [...]
>>>>> diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
>>>>> index 563429dece03..3caed4b880c8 100644
>>>>> --- a/arch/s390/kvm/diag.c
>>>>> +++ b/arch/s390/kvm/diag.c
>>>>> @@ -253,6 +253,24 @@ static int __diag_virtio_hypercall(struct kvm_vcpu *vcpu)
>>>>>  	return ret < 0 ? ret : 0;
>>>>>  }
>>>>>  
>>>>> +static int __diag_set_diag318_info(struct kvm_vcpu *vcpu)
>>>>> +{
>>>>> +	unsigned int reg = (vcpu->arch.sie_block->ipa & 0xf0) >> 4;
>>>>> +	u64 info = vcpu->run->s.regs.gprs[reg];
>>>>> +
>>>>> +	if (!vcpu->kvm->arch.use_diag318)
>>>>> +		return -EOPNOTSUPP;
>>>>> +
>>>>> +	vcpu->stat.diagnose_318++;
>>>>> +	kvm_s390_set_diag318_info(vcpu->kvm, info);
>>>>> +
>>>>> +	VCPU_EVENT(vcpu, 3, "diag 0x318 cpnc: 0x%x cpvc: 0x%llx",
>>>>> +		   vcpu->kvm->arch.diag318_info.cpnc,
>>>>> +		   (u64)vcpu->kvm->arch.diag318_info.cpvc);
>>>>> +
>>>>> +	return 0;
>>>>> +}
>>>>> +
>>>>>  int kvm_s390_handle_diag(struct kvm_vcpu *vcpu)
>>>>>  {
>>>>>  	int code = kvm_s390_get_base_disp_rs(vcpu, NULL) & 0xffff;
>>>>> @@ -272,6 +290,8 @@ int kvm_s390_handle_diag(struct kvm_vcpu *vcpu)
>>>>>  		return __diag_page_ref_service(vcpu);
>>>>>  	case 0x308:
>>>>>  		return __diag_ipl_functions(vcpu);
>>>>> +	case 0x318:
>>>>> +		return __diag_set_diag318_info(vcpu);
>>>>>  	case 0x500:
>>>>>  		return __diag_virtio_hypercall(vcpu);
>>>>
>>>> I wonder whether it would make more sense to simply drop to userspace
>>>> and handle the diag 318 call there? That way the userspace would always
>>>> be up-to-date, and as we've seen in the past (e.g. with the various SIGP
>>>> handling), it's better if the userspace is in control... e.g. userspace
>>>> could also decide to only use KVM_S390_VM_MISC_ENABLE_DIAG318 if the
>>>> guest just executed the diag 318 instruction.
>>>>
>>>> And you need the kvm_s390_vm_get/set_misc functions anyway, so these
>>>> could also be simply used by the diag 318 handler in userspace?
>>>>
>>>>>  	default:
>>>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>>>> index d05bb040fd42..c3eee468815f 100644
>>>>> --- a/arch/s390/kvm/kvm-s390.c
>>>>> +++ b/arch/s390/kvm/kvm-s390.c
>>>>> @@ -159,6 +159,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
>>>>>  	{ "diag_9c_ignored", VCPU_STAT(diagnose_9c_ignored) },
>>>>>  	{ "instruction_diag_258", VCPU_STAT(diagnose_258) },
>>>>>  	{ "instruction_diag_308", VCPU_STAT(diagnose_308) },
>>>>> +	{ "instruction_diag_318", VCPU_STAT(diagnose_318) },
>>>>>  	{ "instruction_diag_500", VCPU_STAT(diagnose_500) },
>>>>>  	{ "instruction_diag_other", VCPU_STAT(diagnose_other) },
>>>>>  	{ NULL }
>>>>> @@ -1243,6 +1244,76 @@ static int kvm_s390_get_tod(struct kvm *kvm, struct kvm_device_attr *attr)
>>>>>  	return ret;
>>>>>  }
>>>>>  
>>>>> +void kvm_s390_set_diag318_info(struct kvm *kvm, u64 info)
>>>>> +{
>>>>> +	struct kvm_vcpu *vcpu;
>>>>> +	int i;
>>>>> +
>>>>> +	kvm->arch.diag318_info.val = info;
>>>>> +
>>>>> +	VM_EVENT(kvm, 3, "SET: CPNC: 0x%x CPVC: 0x%llx",
>>>>> +		 kvm->arch.diag318_info.cpnc, kvm->arch.diag318_info.cpvc);
>>>>> +
>>>>> +	if (sclp.has_diag318) {
>>>>> +		kvm_for_each_vcpu(i, vcpu, kvm) {
>>>>> +			vcpu->arch.sie_block->cpnc = kvm->arch.diag318_info.cpnc;
>>>>> +		}
>>>>> +	}
>>>>> +}
>>>>> +
>>>>> +static int kvm_s390_vm_set_misc(struct kvm *kvm, struct kvm_device_attr *attr)
>>>>> +{
>>>>> +	int ret;
>>>>> +	u64 diag318_info;
>>>>> +
>>>>> +	switch (attr->attr) {
>>>>> +	case KVM_S390_VM_MISC_ENABLE_DIAG318:
>>>>> +		kvm->arch.use_diag318 = 1;
>>>>> +		ret = 0;
>>>>> +		break;
>>>>
>>>> Would it make sense to set kvm->arch.use_diag318 = 1 during the first
>>>> execution of KVM_S390_VM_MISC_DIAG318 instead, so that we could get
>>>> along without the KVM_S390_VM_MISC_ENABLE_DIAG318 ?
>>>
>>> I'm not an expert in feature negotiation, but why isn't this a cpu
>>> feature like sief2 instead of a attribute?
>>>
>>> @David?
>>
>> In the end you want to have it somehow in the CPU model I guess. You
>> cannot glue it to QEMU machines, because availability depends on HW+KVM
>> support.
>>
>> How does the guest detect that it can use diag318? I assume/hope via a a
>> STFLE feature.
>>
> SCLP

Okay, so just another feature flag, which implies it belongs into the
CPU model. How we communicate support from kvm to QEMU can be done via
features, bot also via attributes. Important part is that we can
sense/enable/disable.


-- 
Thanks,

David / dhildenb

