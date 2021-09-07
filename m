Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77D3E4026E6
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 12:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245128AbhIGKMm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 06:12:42 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6968 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244744AbhIGKMi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Sep 2021 06:12:38 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 187A3u5w177383;
        Tue, 7 Sep 2021 06:11:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=pNaCS8fCAXlLe10iIVcVs4n0KsDs36NpibASR4Zw3Lc=;
 b=PDfsVxSLR5a/KbyQzIw2NwxBtk9cyqiKMKZ6/XNYrmkRaINiDY1FiNGmpr1w++EZV1k2
 7Q7xMkBlc0DXxaegK0Ry/pGN5IPY+wdp+IYi7qz+lEhIFeiXADk+bXP31X2maeMIWd0O
 89c3KLm0P5USOL5vtx5cZiYWIHaYYzMCW6/BCSyjvYiwQpZ5CohYUyJNtSH3mNqf0udN
 6VEnc149phsNufDKh8//akojYAuTDcGsLBTx83T0L+T2dQqA6oqugiDAY0c6s9ZeylV1
 CR1hzMGatkXWYhxuDYU6OQ0u21beD9OmUNwIPzN4qCojQ+hNfJU671mBp2TlgPIj1Uen wQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ax2v2d5me-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Sep 2021 06:11:32 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 187A4CVD178267;
        Tue, 7 Sep 2021 06:11:32 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ax2v2d5kr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Sep 2021 06:11:31 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1879w8Cs003266;
        Tue, 7 Sep 2021 10:11:29 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 3av02jcgxa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Sep 2021 10:11:29 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 187ABQP57209290
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Sep 2021 10:11:26 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A24F1AE063;
        Tue,  7 Sep 2021 10:11:25 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D4B5AE065;
        Tue,  7 Sep 2021 10:11:25 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.9.165])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  7 Sep 2021 10:11:25 +0000 (GMT)
Subject: Re: [PATCH v3 1/3] s390x: KVM: accept STSI for CPU topology
 information
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com
References: <1627979206-32663-1-git-send-email-pmorel@linux.ibm.com>
 <1627979206-32663-2-git-send-email-pmorel@linux.ibm.com>
 <b5ee1953-b19d-50ec-b2e2-47a05babcee4@redhat.com>
 <f8d8bf00-3965-d4a1-c464-59ffcf20bfa3@linux.ibm.com>
 <bb1f5629-a6c6-b299-7765-a4326c8fa2d5@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <92fcb116-8bc7-7524-c522-0be5b210029b@linux.ibm.com>
Date:   Tue, 7 Sep 2021 12:11:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <bb1f5629-a6c6-b299-7765-a4326c8fa2d5@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: isJoqA6GwM9P_9t0TAvb_UPf9i3hU48F
X-Proofpoint-ORIG-GUID: KSNg3m-6XNnRbvu-OzwSH60lw9os9XS2
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-07_03:2021-09-03,2021-09-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 spamscore=0
 lowpriorityscore=0 suspectscore=0 mlxscore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2108310000 definitions=main-2109070067
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/6/21 8:14 PM, David Hildenbrand wrote:
> On 01.09.21 11:43, Pierre Morel wrote:
>>
>>
>> On 8/31/21 3:59 PM, David Hildenbrand wrote:
>>> On 03.08.21 10:26, Pierre Morel wrote:
>>>> STSI(15.1.x) gives information on the CPU configuration topology.
>>>> Let's accept the interception of STSI with the function code 15 and
>>>> let the userland part of the hypervisor handle it when userland
>>>> support the CPU Topology facility.
>>>>
>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>> ---
>>>>    arch/s390/kvm/priv.c | 7 ++++++-
>>>>    1 file changed, 6 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
>>>> index 9928f785c677..8581b6881212 100644
>>>> --- a/arch/s390/kvm/priv.c
>>>> +++ b/arch/s390/kvm/priv.c
>>>> @@ -856,7 +856,8 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>>>>        if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
>>>>            return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
>>>> -    if (fc > 3) {
>>>> +    if ((fc > 3 && fc != 15) ||
>>>> +        (fc == 15 && !test_kvm_facility(vcpu->kvm, 11))) {
>>>>            kvm_s390_set_psw_cc(vcpu, 3);
>>>>            return 0;
>>>>        }
>>>> @@ -893,6 +894,10 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>>>>                goto out_no_data;
>>>>            handle_stsi_3_2_2(vcpu, (void *) mem);
>>>>            break;
>>>> +    case 15:
>>>> +        trace_kvm_s390_handle_stsi(vcpu, fc, sel1, sel2, operand2);
>>>> +        insert_stsi_usr_data(vcpu, operand2, ar, fc, sel1, sel2);
>>>> +        return -EREMOTE;
>>>>        }
>>>>        if (kvm_s390_pv_cpu_is_protected(vcpu)) {
>>>>            memcpy((void *)sida_origin(vcpu->arch.sie_block), (void 
>>>> *)mem,
>>>>
>>>
>>> Sorry, I'm a bit rusty on s390x kvm facility handling.
>>>
>>>
>>> For test_kvm_facility() to succeed, the facility has to be in both:
>>>
>>> a) fac_mask: actually available on the HW and supported by KVM
>>> (kvm_s390_fac_base via FACILITIES_KVM, kvm_s390_fac_ext via
>>> FACILITIES_KVM_CPUMODEL)
>>>
>>> b) fac_list: enabled for a VM
>>>
>>> AFAIU, facility 11 is neither in FACILITIES_KVM nor
>>> FACILITIES_KVM_CPUMODEL, and I remember it's a hypervisor-managed bit.
>>>
>>> So unless we unlock facility 11 in FACILITIES_KVM_CPUMODEL, will
>>> test_kvm_facility(vcpu->kvm, 11) ever successfully trigger here?
>>>
>>>
>>> I'm pretty sure I am messing something up :)
>>>
>>
>> I think it is the same remark that Christian did as wanted me to use the
>> arch/s390/tools/gen_facilities.c to activate the facility.
>>
>> The point is that CONFIGURATION_TOPOLOGY, STFL, 11, is already defined
>> inside QEMU since full_GEN10_GA1, so the test_kvm_facility() will
>> succeed with the next patch setting the facility 11 in the mask when
>> getting the KVM_CAP_S390_CPU_TOPOLOGY from userland.
> 
> Ok, I see ...
> 
> QEMU knows the facility and as soon as we present it to QEMU, QEMU will 
> want to automatically enable it in the "host" model.
> 
> However, we'd like QEMU to join in and handle some part of it.
> 
> So indeed, handling it like KVM_CAP_S390_VECTOR_REGISTERS or 
> KVM_CAP_S390_RI looks like a reasonable approach.
> 
>>
>> But if we activate it in KVM via any of the FACILITIES_KVM_xxx in the
>> gen_facilities.c we will activate it for the guest what ever userland
>> hypervizor we have, including old QEMU which will generate an exception.
>>
>>
>> In this circumstances we have the choice between:
>>
>> - use FACILITY_KVM and handle everything in kernel
>> - use FACILITY_KVM and use an extra CAPABILITY to handle part in kernel
>> to avoid guest crash and part in userland
> 
> This sounds quite nice to me. Implement minimal kernel support and 
> indicate the facility via stfl to user space.
> 
> In addition, add a new capability that intercepts to user space instead.
> 
> 
> ... but I can understand that it might not be worth it.

yes, since we need a CAPABILITY anyway I find it makes things more 
complicated.
> 
> 
> This patch as it stands doesn't make any sense on its own. Either 
> document how it's supposed to work and why it is currently dead code, or 
> simply squash into the next patch (preferred IMHO).
> 

Yes, you are right, I will squash it with the next patch.

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
