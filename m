Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3748240F3DE
	for <lists+kvm@lfdr.de>; Fri, 17 Sep 2021 10:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233367AbhIQIPz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 04:15:55 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8024 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229837AbhIQIPy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Sep 2021 04:15:54 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18H7UT0Q020803;
        Fri, 17 Sep 2021 04:14:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=D72Nmltq5W761HKc8q5yf4qEMem+vL6IcD2L/nSKoec=;
 b=HdF4u9HK+PXauaX4EGimJAqSwUQN9m8xrvWBvmSFKrMkq6+AOgAng4XjGVv03APpIp3c
 5U0Z2hx9ZQ1vbmo6Ah9NcuG/WshCt8+UwzWT+XGX6tfpkve/sf/qfIoMfe0CuvMeZ7q1
 vkp689eyJNKjEg0MGfszoWXjHN//DeJBsx5w9kp9Q8lJS82zfpQvgKqjTXJU09dzi/DI
 JyFU1nmnCMlUZxaKhSJnHId8FvKddOKd6PdxrlnQAapLCSnzJV9u1S+VV39IAEcbthQM
 9rampl8LZyD6ILfD3gHcZS73wuw7vfwfIHhFKANRlvHQmt+pAmy5CuyzLTwJlcvydoy5 HA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b4ppmrvqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 04:14:31 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18H8CnT0020157;
        Fri, 17 Sep 2021 04:14:31 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b4ppmrvqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 04:14:31 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18H8D39x029176;
        Fri, 17 Sep 2021 08:14:29 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3b0kqkhrfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 08:14:29 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18H89l8g56361376
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Sep 2021 08:09:47 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4060A405F;
        Fri, 17 Sep 2021 08:14:25 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 48BCBA4054;
        Fri, 17 Sep 2021 08:14:25 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.70.78])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 17 Sep 2021 08:14:25 +0000 (GMT)
Subject: Re: [PATCH v4 1/1] s390x: KVM: accept STSI for CPU topology
 information
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com
References: <1631799845-24860-1-git-send-email-pmorel@linux.ibm.com>
 <1631799845-24860-2-git-send-email-pmorel@linux.ibm.com>
 <eef5ed95-3f54-b709-894d-cdf75bc3180b@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <d5a752d3-9de0-5f7e-fefa-76b680b1d2a7@linux.ibm.com>
Date:   Fri, 17 Sep 2021 10:14:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <eef5ed95-3f54-b709-894d-cdf75bc3180b@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vfrr3HJkTCHB8QQyscuCERwC2DXcARzi
X-Proofpoint-GUID: W6T2wZ_OjEKcyUUzYd4oNyNnpdDdygo_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-17_03,2021-09-16_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109170047
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/16/21 4:03 PM, David Hildenbrand wrote:
>>   struct kvm_vm_stat {
>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>> index 51d1594bd6cd..f3887e13c5db 100644
>> --- a/arch/s390/kvm/kvm-s390.c
>> +++ b/arch/s390/kvm/kvm-s390.c
>> @@ -608,6 +608,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, 
>> long ext)
>>       case KVM_CAP_S390_PROTECTED:
>>           r = is_prot_virt_host();
>>           break;
>> +    case KVM_CAP_S390_CPU_TOPOLOGY:
>> +        r = test_facility(11);
>> +        break;
>>       default:
>>           r = 0;
>>       }
>> @@ -819,6 +822,19 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, 
>> struct kvm_enable_cap *cap)
>>           icpt_operexc_on_all_vcpus(kvm);
>>           r = 0;
>>           break;
>> +    case KVM_CAP_S390_CPU_TOPOLOGY:
> 
> As given in my example, this should be
> 
> r = -EINVAL;
> mutex_lock(&kvm->lock);
> if (kvm->created_vcpus) {
>      r = -EBUSY;
> } else if (test_facility(11)) {
> ...
> }
> 
> Similar to how we handle KVM_CAP_S390_VECTOR_REGISTERS.
> 
> [...]
> 
>> +
>> +    /* PTF needs both host and guest facilities to enable 
>> interpretation */
>> +    if (test_kvm_facility(vcpu->kvm, 11) && test_facility(11))
>> +        vcpu->arch.sie_block->ecb |= ECB_PTF;
> 
> This should be simplified to
> 
> if (test_kvm_facility(vcpu->kvm, 11))
> 
> then. (vsie code below is correct)
> 
> 

OK, the idea was to let the hypervisor the possibility to do userland 
emulation if it wanted.
But I can modify as you want.

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
