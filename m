Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B56049492B
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 09:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359103AbiATILf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 03:11:35 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35274 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358401AbiATILY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Jan 2022 03:11:24 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20K4vUx9008169;
        Thu, 20 Jan 2022 08:11:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=c9PmOdTbAfPIsrLIi5pY5ZdtQiZKC9uuJMMdKGDae8U=;
 b=k+ri4nERJ7hdftGFuFEEMo9RgT2xiGW1HmnR5QQEkWZqKMKf8XiXEbakSNOhRFKF7TVs
 Y5O0vQPJvRL6rfdLnN/l8TjNga4J/OIKGfzZ1Ux0WOUm1bJEOjIA+t4Jjrk7FiAOjw1U
 Nn8RPTKiKAkZzeM7FuVDT9cJfYhqXWRC/x5oj23ZR7sIOuDsvUCMe/wkPtmzX0/RfjO+
 pCwoh7B1tB1BmfxFlD9VNIads/hNhQKCs/PJlWYV9FLVVOt/tBRwDM0a+igMEnKfiM9T
 wmfndyaoAK28amuN4eXRZOYLdSYaj8KME8I+aPNoq4OI97Xe1VwjF515mPIwvGCVKPF2 VA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dq15w34x0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Jan 2022 08:11:23 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20K7nTkf031605;
        Thu, 20 Jan 2022 08:11:22 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dq15w34w8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Jan 2022 08:11:22 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20K87sP4025135;
        Thu, 20 Jan 2022 08:11:20 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3dknhjxu46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Jan 2022 08:11:20 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20K8BH7516581010
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jan 2022 08:11:17 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DCB411C052;
        Thu, 20 Jan 2022 08:11:17 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 97BD811C04A;
        Thu, 20 Jan 2022 08:11:16 +0000 (GMT)
Received: from [9.171.35.3] (unknown [9.171.35.3])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Jan 2022 08:11:16 +0000 (GMT)
Message-ID: <f507580f-ab5b-827f-592e-42d38e639c71@linux.ibm.com>
Date:   Thu, 20 Jan 2022 09:11:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [RFC PATCH v1 02/10] KVM: s390: Honor storage keys when accessing
 guest memory
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20220118095210.1651483-1-scgl@linux.ibm.com>
 <20220118095210.1651483-3-scgl@linux.ibm.com>
 <1bbc2b03-6daa-5e27-956c-4d022bd8e9cb@linux.ibm.com>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <1bbc2b03-6daa-5e27-956c-4d022bd8e9cb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: e_Wcji67YDndT18kQMQZr6wmW3g0cWeW
X-Proofpoint-ORIG-GUID: rFwAkMTyvB4P5eGz1E0BbKIlXaA_e9qh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-20_03,2022-01-19_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 adultscore=0 suspectscore=0 phishscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201200042
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/19/22 20:27, Christian Borntraeger wrote:
> Am 18.01.22 um 10:52 schrieb Janis Schoetterl-Glausch:
>> Storage key checking had not been implemented for instructions emulated
>> by KVM. Implement it by enhancing the functions used for guest access,
>> in particular those making use of access_guest which has been renamed
>> to access_guest_with_key.
>> Accesses via access_guest_real should not be key checked.
>>
>> For actual accesses, key checking is done by __copy_from/to_user_with_key
>> (which internally uses MVCOS/MVCP/MVCS).
>> In cases where accessibility is checked without an actual access,
>> this is performed by getting the storage key and checking
>> if the access key matches.
>> In both cases, if applicable, storage and fetch protection override
>> are honored.
>>
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/ctl_reg.h |   2 +
>>   arch/s390/include/asm/page.h    |   2 +
>>   arch/s390/kvm/gaccess.c         | 174 +++++++++++++++++++++++++++++---
>>   arch/s390/kvm/gaccess.h         |  78 ++++++++++++--
>>   arch/s390/kvm/intercept.c       |  12 +--
>>   arch/s390/kvm/kvm-s390.c        |   4 +-
>>   6 files changed, 241 insertions(+), 31 deletions(-)
>>
>> diff --git a/arch/s390/include/asm/ctl_reg.h b/arch/s390/include/asm/ctl_reg.h
>> index 04dc65f8901d..c800199a376b 100644
>> --- a/arch/s390/include/asm/ctl_reg.h
>> +++ b/arch/s390/include/asm/ctl_reg.h
>> @@ -12,6 +12,8 @@
>>     #define CR0_CLOCK_COMPARATOR_SIGN    BIT(63 - 10)
>>   #define CR0_LOW_ADDRESS_PROTECTION    BIT(63 - 35)
>> +#define CR0_FETCH_PROTECTION_OVERRIDE    BIT(63 - 38)
>> +#define CR0_STORAGE_PROTECTION_OVERRIDE    BIT(63 - 39)
>>   #define CR0_EMERGENCY_SIGNAL_SUBMASK    BIT(63 - 49)
>>   #define CR0_EXTERNAL_CALL_SUBMASK    BIT(63 - 50)
>>   #define CR0_CLOCK_COMPARATOR_SUBMASK    BIT(63 - 52)
>> diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.h
>> index d98d17a36c7b..cfc4d6fb2385 100644
>> --- a/arch/s390/include/asm/page.h
>> +++ b/arch/s390/include/asm/page.h
>> @@ -20,6 +20,8 @@
>>   #define PAGE_SIZE    _PAGE_SIZE
>>   #define PAGE_MASK    _PAGE_MASK
>>   #define PAGE_DEFAULT_ACC    0
>> +/* storage-protection override */
>> +#define PAGE_SPO_ACC        9
>>   #define PAGE_DEFAULT_KEY    (PAGE_DEFAULT_ACC << 4)
>>     #define HPAGE_SHIFT    20
>> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
>> index 4460808c3b9a..92ab96d55504 100644
>> --- a/arch/s390/kvm/gaccess.c
>> +++ b/arch/s390/kvm/gaccess.c
>> @@ -10,6 +10,7 @@
>>   #include <linux/mm_types.h>
>>   #include <linux/err.h>
>>   #include <linux/pgtable.h>
>> +#include <linux/bitfield.h>
>>     #include <asm/gmap.h>
>>   #include "kvm-s390.h"
>> @@ -794,6 +795,79 @@ static int low_address_protection_enabled(struct kvm_vcpu *vcpu,
>>       return 1;
>>   }
>>   +static bool fetch_prot_override_applicable(struct kvm_vcpu *vcpu, enum gacc_mode mode,
>> +                       union asce asce)
>> +{
>> +    psw_t *psw = &vcpu->arch.sie_block->gpsw;
>> +    unsigned long override;
>> +
>> +    if (mode == GACC_FETCH || mode == GACC_IFETCH) {
>> +        /* check if fetch protection override enabled */
>> +        override = vcpu->arch.sie_block->gcr[0];
>> +        override &= CR0_FETCH_PROTECTION_OVERRIDE;
>> +        /* not applicable if subject to DAT && private space */
>> +        override = override && !(psw_bits(*psw).dat && asce.p);
>> +        return override;
>> +    }
>> +    return false;
>> +}
>> +
>> +static bool fetch_prot_override_applies(unsigned long ga, unsigned int len)
>> +{
>> +    return ga < 2048 && ga + len <= 2048;
>> +}
>> +
>> +static bool storage_prot_override_applicable(struct kvm_vcpu *vcpu)
>> +{
>> +    /* check if storage protection override enabled */
>> +    return vcpu->arch.sie_block->gcr[0] & CR0_STORAGE_PROTECTION_OVERRIDE;
>> +}
>> +
>> +static bool storage_prot_override_applies(char access_control)
>> +{
>> +    /* matches special storage protection override key (9) -> allow */
>> +    return access_control == PAGE_SPO_ACC;
>> +}
>> +
>> +static int vcpu_check_access_key(struct kvm_vcpu *vcpu, char access_key,
>> +                 enum gacc_mode mode, union asce asce, gpa_t gpa,
>> +                 unsigned long ga, unsigned int len)
>> +{
>> +    unsigned char storage_key, access_control;
>> +    unsigned long hva;
>> +    int r;
>> +
>> +    /* access key 0 matches any storage key -> allow */
>> +    if (access_key == 0)
>> +        return 0;
>> +    /*
>> +     * caller needs to ensure that gfn is accessible, so we can
>> +     * assume that this cannot fail
>> +     */
>> +    hva = gfn_to_hva(vcpu->kvm, gpa_to_gfn(gpa));
>> +    mmap_read_lock(current->mm);
>> +    r = get_guest_storage_key(current->mm, hva, &storage_key);
>> +    mmap_read_unlock(current->mm);
>> +    if (r)
>> +        return r;
>> +    access_control = FIELD_GET(_PAGE_ACC_BITS, storage_key);
>> +    /* access key matches storage key -> allow */
>> +    if (access_control == access_key)
>> +        return 0;
>> +    if (mode == GACC_FETCH || mode == GACC_IFETCH) {
>> +        /* mismatching keys, no fetch protection -> allowed */
>> +        if (!(storage_key & _PAGE_FP_BIT))
>> +            return 0;
>> +        if (fetch_prot_override_applicable(vcpu, mode, asce))
>> +            if (fetch_prot_override_applies(ga, len))
>> +                return 0;
>> +    }
>> +    if (storage_prot_override_applicable(vcpu))
>> +        if (storage_prot_override_applies(access_control))
>> +            return 0;
>> +    return PGM_PROTECTION;
>> +}
> 
> This function is just a pre-check (and early-exit) and we do an additional final check
> in the MVCOS routing later on, correct? It might actually be faster to get rid of this

No, this exists for those cases that do not do an actual access, that is MEMOPs with
the check only flag, as well as the TEST PROTECTION emulation. access_guest_with_key
passes key 0 so we take the early return. It's easy to miss so Janosch suggested a comment there.

> pre-test and simply rely on MVCOS. MVCOS is usually just some cycles while ISKE to read
> the key is really slow path and take hundreds of cycles. This would even simplify the
> patch (assuming that we do proper key checking all the time).

