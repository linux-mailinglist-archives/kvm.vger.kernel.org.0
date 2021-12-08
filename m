Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 559DD46DAA9
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 19:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238513AbhLHSEu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 13:04:50 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31580 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238424AbhLHSEt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 13:04:49 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B8HrVx9016831;
        Wed, 8 Dec 2021 18:01:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=icNS/hUNTZOizlARzmU3ZuuwS3Cil4+EuDX+1J989XA=;
 b=quK1iRPj1wdLDc52theVqpsIOMn6+jROqrkVuyVJj/RAVKmzT1Ne/tkSX5YOa3pqndTy
 II57fJ1yMbitQbhzs2KfzgldQU3j3bKqUM8yVaYAuVCgzNk3KOiYD1nPjMd/IPZ3eAOx
 dhbhBqnA5kY/I4NhsDADEAXikQMCO73gUsB5jzp4ILZKyqOvcta0MVLeulZSouwbK/9t
 n3nHTIMdngUXpqJgQH9dRwq6RXMUHv5KDzq1l8FMOj6u3GkR/fW2e2w/GMEEJK6Mmi0t
 iPJRvSuQDB+hmLW2pcXyIAYlX0Tyq1i5/JLqjpTRkFUsBGXU/utEGhRlFmqbv27nNQ+P Fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cu1gp83g2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 18:01:05 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B8HwfrK002195;
        Wed, 8 Dec 2021 18:01:04 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cu1gp83fe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 18:01:04 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B8HwVXT009300;
        Wed, 8 Dec 2021 18:01:03 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01wdc.us.ibm.com with ESMTP id 3cqyyb7hgq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 18:01:03 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B8I11oD44040630
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Dec 2021 18:01:01 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80C9BB2072;
        Wed,  8 Dec 2021 18:01:01 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0783AB2066;
        Wed,  8 Dec 2021 18:00:55 +0000 (GMT)
Received: from [9.211.152.43] (unknown [9.211.152.43])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  8 Dec 2021 18:00:55 +0000 (GMT)
Message-ID: <d3d4c643-0d97-e16e-b505-a81c2a8f19e3@linux.ibm.com>
Date:   Wed, 8 Dec 2021 13:00:54 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 06/12] target/s390x: add zpci-interp to cpu models
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, pasic@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20211207210425.150923-1-mjrosato@linux.ibm.com>
 <20211207210425.150923-7-mjrosato@linux.ibm.com>
 <77f66828-b947-da7a-fe8c-35b698eca841@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <77f66828-b947-da7a-fe8c-35b698eca841@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RF81MBEXchmr9Zq_YvHs3EONs2KvAWgP
X-Proofpoint-ORIG-GUID: LeZZ6_VsQVpt8bV5kHJ61Rqlhrrj7yKn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-08_07,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 suspectscore=0 impostorscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112080102
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/21 5:16 AM, Christian Borntraeger wrote:
> Am 07.12.21 um 22:04 schrieb Matthew Rosato:
>> The zpci-interp feature is used to specify whether zPCI interpretation is
>> to be used for this guest.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   target/s390x/cpu_features_def.h.inc | 1 +
>>   target/s390x/gen-features.c         | 2 ++
>>   target/s390x/kvm/kvm.c              | 1 +
>>   3 files changed, 4 insertions(+)
>>
>> diff --git a/target/s390x/cpu_features_def.h.inc 
>> b/target/s390x/cpu_features_def.h.inc
>> index e86662bb3b..4ade3182aa 100644
>> --- a/target/s390x/cpu_features_def.h.inc
>> +++ b/target/s390x/cpu_features_def.h.inc
>> @@ -146,6 +146,7 @@ DEF_FEAT(SIE_CEI, "cei", SCLP_CPU, 43, "SIE: 
>> Conditional-external-interception f
>>   DEF_FEAT(DAT_ENH_2, "dateh2", MISC, 0, "DAT-enhancement facility 2")
>>   DEF_FEAT(CMM, "cmm", MISC, 0, "Collaborative-memory-management 
>> facility")
>>   DEF_FEAT(AP, "ap", MISC, 0, "AP instructions installed")
>> +DEF_FEAT(ZPCI_INTERP, "zpci-interp", MISC, 0, "zPCI interpretation")
>>   /* Features exposed via the PLO instruction. */
>>   DEF_FEAT(PLO_CL, "plo-cl", PLO, 0, "PLO Compare and load (32 bit in 
>> general registers)")
>> diff --git a/target/s390x/gen-features.c b/target/s390x/gen-features.c
>> index 7cb1a6ec10..7005d22415 100644
>> --- a/target/s390x/gen-features.c
>> +++ b/target/s390x/gen-features.c
>> @@ -554,6 +554,7 @@ static uint16_t full_GEN14_GA1[] = {
>>       S390_FEAT_HPMA2,
>>       S390_FEAT_SIE_KSS,
>>       S390_FEAT_GROUP_MULTIPLE_EPOCH_PTFF,
>> +    S390_FEAT_ZPCI_INTERP,
>>   };
>>   #define full_GEN14_GA2 EmptyFeat
>> @@ -650,6 +651,7 @@ static uint16_t default_GEN14_GA1[] = {
>>       S390_FEAT_GROUP_MSA_EXT_8,
>>       S390_FEAT_MULTIPLE_EPOCH,
>>       S390_FEAT_GROUP_MULTIPLE_EPOCH_PTFF,
>> +    S390_FEAT_ZPCI_INTERP,
>>   };
> 
> For the default model you need to be careful.
> Is this in any way guest visible? then you definitely need to fence this
> off for older QEMU versions so that when you migrate with older QEMUs
> See the s390_cpudef_featoff_greater calls in  hw/s390x/s390-virtio-ccw.c
> 
> I know its more of a theoretical aspect, since PCI currently forbids 
> migration
> but we should try to have the cpu model consistent I guess.

Ah, good idea.  Thanks for the pointer.

>>   #define default_GEN14_GA2 EmptyFeat
>> diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
>> index 5b1fdb55c4..b13d78f988 100644
>> --- a/target/s390x/kvm/kvm.c
>> +++ b/target/s390x/kvm/kvm.c
>> @@ -2290,6 +2290,7 @@ static int kvm_to_feat[][2] = {
>>       { KVM_S390_VM_CPU_FEAT_PFMFI, S390_FEAT_SIE_PFMFI},
>>       { KVM_S390_VM_CPU_FEAT_SIGPIF, S390_FEAT_SIE_SIGPIF},
>>       { KVM_S390_VM_CPU_FEAT_KSS, S390_FEAT_SIE_KSS},
>> +    { KVM_S390_VM_CPU_FEAT_ZPCI_INTERP, S390_FEAT_ZPCI_INTERP },
>>   };
>>   static int query_cpu_feat(S390FeatBitmap features)
>>

