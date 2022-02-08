Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFF744ADB4B
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 15:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378271AbiBHOgR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 09:36:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiBHOgO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 09:36:14 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4585EC03FECE;
        Tue,  8 Feb 2022 06:36:13 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 218CJtMm015569;
        Tue, 8 Feb 2022 14:36:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=AAYDtomxl4rPrxMotPaqAzwZrNgrhLQKSqm91wF27oM=;
 b=byIzlnt/5EuFXf8lyfvAA6+xjfonfjsl9Hq3blTBV8NBq90YfpPfaiZ+tbtU3xHyp2Js
 QTiTwDxIJXSKxl9RZlMAs9p629NUS4sxHqVuIosye8AtXzzeh/A8Tk4jDyrZSVNuyRY0
 l3HMncSN92kCjm87wwA8OHfn31G8d434136bT3+L+jad7A5yyKG2ZqHJLAOMvjBT5PiB
 xh7P8730dnwlbDbOMr00eWNxV6pJ+94WAIg8CUjldwKaXaa3D5ADQiTlFNJgHDMYBlG+
 tRdZ8HhJqAftFrtRhdgkY5FgQqmPhonu7OUyoezqYlMUgfXDwVpbpdk8XBRx6P88quCE UQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e236fje33-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 14:36:11 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 218EG9jS036875;
        Tue, 8 Feb 2022 14:36:10 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e236fje2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 14:36:10 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 218EWaAm015991;
        Tue, 8 Feb 2022 14:36:08 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3e1gv9emuh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 14:36:08 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 218Ea44J38797596
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Feb 2022 14:36:04 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40864A4065;
        Tue,  8 Feb 2022 14:36:04 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98FAFA405F;
        Tue,  8 Feb 2022 14:36:03 +0000 (GMT)
Received: from [9.171.95.210] (unknown [9.171.95.210])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Feb 2022 14:36:03 +0000 (GMT)
Message-ID: <a3eea263-de38-e3d7-f188-93eb5148a73a@linux.ibm.com>
Date:   Tue, 8 Feb 2022 15:36:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 02/11] KVM: s390: Honor storage keys when accessing
 guest memory
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
References: <20220207165930.1608621-1-scgl@linux.ibm.com>
 <20220207165930.1608621-3-scgl@linux.ibm.com>
 <21c30a11-1219-04bb-b0c9-8ac0baf0c506@linux.ibm.com>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <21c30a11-1219-04bb-b0c9-8ac0baf0c506@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vE8Pncz96lqpotYz099ue1F3O1_iYzUz
X-Proofpoint-GUID: Qob6cUfGxOo6rBEK5spfRzPntwPNDMs8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-08_04,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 mlxscore=0 phishscore=0 spamscore=0 malwarescore=0 impostorscore=0
 bulkscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202080090
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/8/22 15:02, Christian Borntraeger wrote:
> Am 07.02.22 um 17:59 schrieb Janis Schoetterl-Glausch:
>> Storage key checking had not been implemented for instructions emulated
>> by KVM. Implement it by enhancing the functions used for guest access,
>> in particular those making use of access_guest which has been renamed
>> to access_guest_with_key.
>> Accesses via access_guest_real should not be key checked.
>>
>> For actual accesses, key checking is done by
>> copy_from/to_user_key (which internally uses MVCOS/MVCP/MVCS).
>> In cases where accessibility is checked without an actual access,
>> this is performed by getting the storage key and checking if the access
>> key matches. In both cases, if applicable, storage and fetch protection
>> override are honored.
>>
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> 
> Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> 
>> ---
>>   arch/s390/include/asm/ctl_reg.h |   2 +
>>   arch/s390/include/asm/page.h    |   2 +
>>   arch/s390/kvm/gaccess.c         | 187 ++++++++++++++++++++++++++++++--
>>   arch/s390/kvm/gaccess.h         |  77 +++++++++++--
>>   arch/s390/kvm/intercept.c       |  12 +-
>>   arch/s390/kvm/kvm-s390.c        |   4 +-
>>   6 files changed, 253 insertions(+), 31 deletions(-)
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
>> index 4460808c3b9a..7fca0cff4c12 100644
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
>> +static bool storage_prot_override_applies(u8 access_control)
>> +{
>> +    /* matches special storage protection override key (9) -> allow */
>> +    return access_control == PAGE_SPO_ACC;
>> +}
>> +

[...]

>> +int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
>> +              void *data, unsigned long len, enum gacc_mode mode,
>> +              u8 access_key)
>>   {
>>       psw_t *psw = &vcpu->arch.sie_block->gpsw;
>>       unsigned long nr_pages, idx;
>>       unsigned long gpa_array[2];
>>       unsigned int fragment_len;
>>       unsigned long *gpas;
>> +    enum prot_type prot;
>>       int need_ipte_lock;
>>       union asce asce;
>> +    bool try_storage_prot_override;
>> +    bool try_fetch_prot_override;
> 
> These are used only once, so we could get rid of those. On the other hands this
> variant might be slightly more readable, so I am fine either way.

I don't know if the compiler would manage to cache the calls across loop iterations,
but then the functions just perform some checks so it shouldn't matter much.
I'm inclined to keep it since it moves a bit of code out of the loop body, as you say,
it might help a bit with readability, even if not much.
> 
> 
>>       int rc;
>>         if (!len)
>> @@ -904,16 +1022,47 @@ int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
>>           gpas = vmalloc(array_size(nr_pages, sizeof(unsigned long)));
>>       if (!gpas)
>>           return -ENOMEM;
>> +    try_fetch_prot_override = fetch_prot_override_applicable(vcpu, mode, asce);
>> +    try_storage_prot_override = storage_prot_override_applicable(vcpu);
>>       need_ipte_lock = psw_bits(*psw).dat && !asce.r;
>>       if (need_ipte_lock)
>>           ipte_lock(vcpu);
>> -    rc = guest_range_to_gpas(vcpu, ga, ar, gpas, len, asce, mode);
>> -    for (idx = 0; idx < nr_pages && !rc; idx++) {
>> +    /*
>> +     * Since we do the access further down ultimately via a move instruction
>> +     * that does key checking and returns an error in case of a protection
>> +     * violation, we don't need to do the check during address translation.
>> +     * Skip it by passing access key 0, which matches any storage key,
>> +     * obviating the need for any further checks. As a result the check is
>> +     * handled entirely in hardware on access, we only need to take care to
>> +     * forego key protection checking if fetch protection override applies or
>> +     * retry with the special key 9 in case of storage protection override.
>> +     */
>> +    rc = guest_range_to_gpas(vcpu, ga, ar, gpas, len, asce, mode, 0);
>> +    if (rc)
>> +        goto out_unlock;
>> +    for (idx = 0; idx < nr_pages; idx++) {
>>           fragment_len = min(PAGE_SIZE - offset_in_page(gpas[idx]), len);
>> -        rc = access_guest_page(vcpu->kvm, mode, gpas[idx], data, fragment_len);
>> +        if (try_fetch_prot_override && fetch_prot_override_applies(ga, fragment_len)) {
>> +            rc = access_guest_page(vcpu->kvm, mode, gpas[idx],
>> +                           data, fragment_len);
>> +        } else {
>> +            rc = access_guest_page_with_key(vcpu->kvm, mode, gpas[idx],
>> +                            data, fragment_len, access_key);
>> +        }
>> +        if (rc == PGM_PROTECTION && try_storage_prot_override)
>> +            rc = access_guest_page_with_key(vcpu->kvm, mode, gpas[idx],
>> +                            data, fragment_len, PAGE_SPO_ACC);
>> +        if (rc == PGM_PROTECTION)
>> +            prot = PROT_TYPE_KEYC;
>> +        if (rc)
>> +            break;
>>           len -= fragment_len;
>>           data += fragment_len;
>> +        ga = kvm_s390_logical_to_effective(vcpu, ga + fragment_len);
>>       }
>> +    if (rc > 0)
>> +        rc = trans_exc(vcpu, rc, ga, ar, mode, prot);
>> +out_unlock:
>>       if (need_ipte_lock)
>>           ipte_unlock(vcpu);
>>       if (nr_pages > ARRAY_SIZE(gpa_array))

[...]
