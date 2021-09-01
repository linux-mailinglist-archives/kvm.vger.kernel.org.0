Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC8EC3FD728
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 11:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243809AbhIAJrI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 05:47:08 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23852 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243803AbhIAJrH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Sep 2021 05:47:07 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1819XbBM153630;
        Wed, 1 Sep 2021 05:46:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=eU+PaGN6XosFMAZE0A8hOYQ9oWQnq+2fPo5QWJUN3ic=;
 b=VMS0hMN1s2GqcU8RFndv+Xg6m6noBGVAptMk/rFC6GlePPdTqwrVPiOciJrIsOY7R9f1
 oGX2X0RN4SkBEUB3RGyuyrZZbf/0LrQSlgho6P+YGdcT/AHlbdEsWSJfXXituQ4SP9jD
 mmvCQENqoPcgQEog5+D0C+rRMU3c4veyMLrUJRIl0e2IT56qoYw19BVvdYRWqgv/wmv1
 Yp+i8WCCQQxJErsPlfMPKkWEx/5MIlAvhg2lQ7Kps6t6s9ABPGySDyGqGwxrrx8OcNdo
 cvV7L0/iR0hEC/ACgesz545H8HMuHpQ0hFcntzrmNiXlVrxqyT4ORjM9KkiOtpnENQAq UQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3at2hmqmtw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Sep 2021 05:46:11 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1819YEPc155494;
        Wed, 1 Sep 2021 05:46:10 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3at2hmqmt4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Sep 2021 05:46:10 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1819baRd017791;
        Wed, 1 Sep 2021 09:46:08 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3aqcdjrdwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Sep 2021 09:46:08 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1819k25055116192
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Sep 2021 09:46:02 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C3388AE057;
        Wed,  1 Sep 2021 09:46:02 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A640AE087;
        Wed,  1 Sep 2021 09:46:02 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.181.78])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  1 Sep 2021 09:46:02 +0000 (GMT)
Subject: Re: [PATCH v3 2/3] s390x: KVM: Implementation of Multiprocessor
 Topology-Change-Report
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com
References: <1627979206-32663-1-git-send-email-pmorel@linux.ibm.com>
 <1627979206-32663-3-git-send-email-pmorel@linux.ibm.com>
 <4d462f11-2990-6799-75e5-add0c39f9563@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <98d3b4fb-f875-d833-2a75-5412cd426ec7@linux.ibm.com>
Date:   Wed, 1 Sep 2021 11:46:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <4d462f11-2990-6799-75e5-add0c39f9563@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lwZB1hTWhSkCXX0YL12WjxFziYs8Hxve
X-Proofpoint-ORIG-GUID: N24AoYAcubgT9d7rMQa1tzE1-qGLg0EB
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-01_03:2021-08-31,2021-09-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 bulkscore=0 mlxlogscore=999 mlxscore=0 impostorscore=0 suspectscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 lowpriorityscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2109010054
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/31/21 4:03 PM, David Hildenbrand wrote:
> On 03.08.21 10:26, Pierre Morel wrote:

...snip...


>> @@ -819,6 +820,23 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, 
>> struct kvm_enable_cap *cap)
>>           icpt_operexc_on_all_vcpus(kvm);
>>           r = 0;
>>           break;
>> +    case KVM_CAP_S390_CPU_TOPOLOGY:
>> +        mutex_lock(&kvm->lock);
>> +        if (kvm->created_vcpus) {
>> +            r = -EBUSY;
>> +        } else {
>> +            set_kvm_facility(kvm->arch.model.fac_mask, 11);
>> +            set_kvm_facility(kvm->arch.model.fac_list, 11);
>> +            r = 0;
>> +        }
>> +        mutex_unlock(&kvm->lock);
>> +        VM_EVENT(kvm, 3, "ENABLE: CPU TOPOLOGY %s",
>> +             r ? "(not available)" : "(success)");
>> +        break;
>> +
>> +        r = -EINVAL;
>> +        break;
>> +
>>       default:
>>           r = -EINVAL;
>>           break;

This above enables the facility 11.

...snip...

>> @@ -3198,6 +3239,11 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu 
>> *vcpu)
>>           vcpu->arch.sie_block->ecb |= ECB_HOSTPROTINT;
>>       if (test_kvm_facility(vcpu->kvm, 9))
>>           vcpu->arch.sie_block->ecb |= ECB_SRSI;
>> +
>> +    /* PTF needs both host and guest facilities to enable 
>> interpretation */
>> +    if (test_kvm_facility(vcpu->kvm, 11) && test_facility(11))
>> +        vcpu->arch.sie_block->ecb |= ECB_PTF;
> 
> 
> Again, doesn't test_kvm_facility(vcpu->kvm, 11) imply that we have host 
> support by checking fac_mask?
> 

-- 
Pierre Morel
IBM Lab Boeblingen
