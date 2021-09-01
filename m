Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E553FD710
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 11:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243543AbhIAJoK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 05:44:10 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14332 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243522AbhIAJoJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Sep 2021 05:44:09 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1819YBxe135343;
        Wed, 1 Sep 2021 05:43:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Q3IQOAntduAE1izOUzufatGk9AX0B/EI1q9Q9dnuYZs=;
 b=n1I+uToRuOHWkKCzicPjsFmUM2xSQVy4Jxndn5RdedXICS9+6Cc0QXgdDXFyg/e9Q33p
 7sFeqJnay1Oc0Eq2X/NPvriOrI3AFR2VCCbHMOwQsop0De0YvMIR9fmnSt2vbt9dkwyt
 2FfmRa4tWo01bhy57DLhMyXDAs/426WAI3EKDTf5003j7xUqnS+ZwCzDDmNDfiWroOpt
 xH7Pwf7SJN/HcUVb8kuRugDqkYrB3T5a54aTAAmQ/4ZL4yn/iZcwBzT/+G65VtHSa/vP
 eQe8OPDEq/g2JK3wlXK9buet8tYXymvSe8yarfjdG36EFrsjZdXVUwwfGrz+h1p0nNA6 rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3at6g2s7uy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Sep 2021 05:43:12 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1819ZSu0143087;
        Wed, 1 Sep 2021 05:43:12 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3at6g2s7ub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Sep 2021 05:43:12 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1819bgn5024935;
        Wed, 1 Sep 2021 09:43:10 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3aqcs9ptpq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Sep 2021 09:43:09 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1819h1kc18547098
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Sep 2021 09:43:01 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B74EAE079;
        Wed,  1 Sep 2021 09:43:01 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E389CAE08F;
        Wed,  1 Sep 2021 09:43:00 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.181.78])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  1 Sep 2021 09:43:00 +0000 (GMT)
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
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <f8d8bf00-3965-d4a1-c464-59ffcf20bfa3@linux.ibm.com>
Date:   Wed, 1 Sep 2021 11:43:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <b5ee1953-b19d-50ec-b2e2-47a05babcee4@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fswuS0m00twXKBiHPvovRo4h9hOk-M50
X-Proofpoint-ORIG-GUID: -DYeszWcPdXR0QSo36MNC8OmjiSl-v02
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-01_03:2021-08-31,2021-09-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 mlxscore=0 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 malwarescore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2109010054
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/31/21 3:59 PM, David Hildenbrand wrote:
> On 03.08.21 10:26, Pierre Morel wrote:
>> STSI(15.1.x) gives information on the CPU configuration topology.
>> Let's accept the interception of STSI with the function code 15 and
>> let the userland part of the hypervisor handle it when userland
>> support the CPU Topology facility.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   arch/s390/kvm/priv.c | 7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
>> index 9928f785c677..8581b6881212 100644
>> --- a/arch/s390/kvm/priv.c
>> +++ b/arch/s390/kvm/priv.c
>> @@ -856,7 +856,8 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>>       if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
>>           return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
>> -    if (fc > 3) {
>> +    if ((fc > 3 && fc != 15) ||
>> +        (fc == 15 && !test_kvm_facility(vcpu->kvm, 11))) {
>>           kvm_s390_set_psw_cc(vcpu, 3);
>>           return 0;
>>       }
>> @@ -893,6 +894,10 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
>>               goto out_no_data;
>>           handle_stsi_3_2_2(vcpu, (void *) mem);
>>           break;
>> +    case 15:
>> +        trace_kvm_s390_handle_stsi(vcpu, fc, sel1, sel2, operand2);
>> +        insert_stsi_usr_data(vcpu, operand2, ar, fc, sel1, sel2);
>> +        return -EREMOTE;
>>       }
>>       if (kvm_s390_pv_cpu_is_protected(vcpu)) {
>>           memcpy((void *)sida_origin(vcpu->arch.sie_block), (void *)mem,
>>
> 
> Sorry, I'm a bit rusty on s390x kvm facility handling.
> 
> 
> For test_kvm_facility() to succeed, the facility has to be in both:
> 
> a) fac_mask: actually available on the HW and supported by KVM 
> (kvm_s390_fac_base via FACILITIES_KVM, kvm_s390_fac_ext via 
> FACILITIES_KVM_CPUMODEL)
> 
> b) fac_list: enabled for a VM
> 
> AFAIU, facility 11 is neither in FACILITIES_KVM nor 
> FACILITIES_KVM_CPUMODEL, and I remember it's a hypervisor-managed bit.
> 
> So unless we unlock facility 11 in FACILITIES_KVM_CPUMODEL, will 
> test_kvm_facility(vcpu->kvm, 11) ever successfully trigger here?
> 
> 
> I'm pretty sure I am messing something up :)
> 

I think it is the same remark that Christian did as wanted me to use the 
arch/s390/tools/gen_facilities.c to activate the facility.

The point is that CONFIGURATION_TOPOLOGY, STFL, 11, is already defined 
inside QEMU since full_GEN10_GA1, so the test_kvm_facility() will 
succeed with the next patch setting the facility 11 in the mask when 
getting the KVM_CAP_S390_CPU_TOPOLOGY from userland.

But if we activate it in KVM via any of the FACILITIES_KVM_xxx in the 
gen_facilities.c we will activate it for the guest what ever userland 
hypervizor we have, including old QEMU which will generate an exception.


In this circumstances we have the choice between:

- use FACILITY_KVM and handle everything in kernel
- use FACILITY_KVM and use an extra CAPABILITY to handle part in kernel 
to avoid guest crash and part in userland
- use only the extra CAPABILITY and handle almost everything in userland

I want to avoid kernel code when not really necessary so I eliminated 
the first option.

The last two are not very different but I found a better integration 
using the last one, allowing to use standard test_[kvm_]facility()

Thanks for reviewing.

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
