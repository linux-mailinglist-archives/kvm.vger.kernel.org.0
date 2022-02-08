Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A59E4AD9AF
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 14:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346880AbiBHNWj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 08:22:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350566AbiBHNTz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 08:19:55 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A8EAC03BFD6;
        Tue,  8 Feb 2022 05:17:00 -0800 (PST)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 218DEkMQ006682;
        Tue, 8 Feb 2022 13:16:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=jrZ9s+TyrhC96oXFmcVYKc1DPqHg5m9pACkgR19DWw0=;
 b=JekJWgUWFszHvkn9yUtMD6FIL0MvFzM7BhwulNz3rZRcTb0yhdQELzIOWss9eAocZM53
 GSVxb0lfuruRV3YDonKuFqMhvdDCHEfqjq/7C8t8IR+wWKNIUlJLkfZsvnTUCNGpfpcD
 7EpG9DUc7mCrmLYfUm6s3hb5ZiZbFoCapLpum5R9I9wgF3RxTbuW/x40onmR3LwrceCq
 epimeWsxjizP5mJXgnYlNgN30AbN6uTDC3vsM0m0LYw+Y474hyOCn+bI7QKMIzYDb8sO
 loFF68Tnjkc4J+x1AbTczzp7J0PbxnMJLctLUIa4dMhN0rBI0sTwVl0Cw4jy/JBNNZiV Ww== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e23apr0bc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 13:16:54 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 218CjktU028625;
        Tue, 8 Feb 2022 13:16:54 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e23apr0a5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 13:16:54 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 218DFpur012178;
        Tue, 8 Feb 2022 13:16:51 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3e1gv95x3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 13:16:51 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 218D6gmi49611194
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Feb 2022 13:06:42 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 494A8A405D;
        Tue,  8 Feb 2022 13:16:47 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9CBD1A4069;
        Tue,  8 Feb 2022 13:16:46 +0000 (GMT)
Received: from [9.171.40.184] (unknown [9.171.40.184])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Feb 2022 13:16:46 +0000 (GMT)
Message-ID: <166a5360-8862-b0ef-3ac9-6c73f1f26bbb@linux.ibm.com>
Date:   Tue, 8 Feb 2022 14:16:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 01/11] s390/uaccess: Add copy_from/to_user_key
 functions
Content-Language: en-US
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
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
 <20220207165930.1608621-2-scgl@linux.ibm.com>
 <8c02d3c5-03a2-19a3-ff64-6646d09ae9ff@linux.ibm.com>
In-Reply-To: <8c02d3c5-03a2-19a3-ff64-6646d09ae9ff@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CwtBvTizDgJx65sMeF-6gf87qr_2OUyq
X-Proofpoint-ORIG-GUID: SFLfdMMnGR2fDSsYLDzaYuealMia3L5S
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-08_04,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 clxscore=1015
 mlxlogscore=999 adultscore=0 bulkscore=0 suspectscore=0 impostorscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202080082
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 08.02.22 um 13:31 schrieb Christian Borntraeger:
> Am 07.02.22 um 17:59 schrieb Janis Schoetterl-Glausch:
>> Add copy_from/to_user_key functions, which perform storage key checking.
>> These functions can be used by KVM for emulating instructions that need
>> to be key checked.
>> These functions differ from their non _key counterparts in
>> include/linux/uaccess.h only in the additional key argument and must be
>> kept in sync with those.
>>
>> Since the existing uaccess implementation on s390 makes use of move
>> instructions that support having an additional access key supplied,
>> we can implement raw_copy_from/to_user_key by enhancing the
>> existing implementation.
>>
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> 
> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
please use
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
instead...
> 
>> ---
>>   arch/s390/include/asm/uaccess.h | 22 +++++++++
>>   arch/s390/lib/uaccess.c         | 81 +++++++++++++++++++++++++--------
>>   2 files changed, 85 insertions(+), 18 deletions(-)
>>
>> diff --git a/arch/s390/include/asm/uaccess.h b/arch/s390/include/asm/uaccess.h
>> index d74e26b48604..ba1bcb91af95 100644
>> --- a/arch/s390/include/asm/uaccess.h
>> +++ b/arch/s390/include/asm/uaccess.h
>> @@ -44,6 +44,28 @@ raw_copy_to_user(void __user *to, const void *from, unsigned long n);
>>   #define INLINE_COPY_TO_USER
>>   #endif
>> +unsigned long __must_check
>> +_copy_from_user_key(void *to, const void __user *from, unsigned long n, unsigned long key);
>> +
>> +static __always_inline unsigned long __must_check
>> +copy_from_user_key(void *to, const void __user *from, unsigned long n, unsigned long key)
>> +{
>> +    if (likely(check_copy_size(to, n, false)))
>> +        n = _copy_from_user_key(to, from, n, key);
>> +    return n;
>> +}
>> +
>> +unsigned long __must_check
>> +_copy_to_user_key(void __user *to, const void *from, unsigned long n, unsigned long key);
>> +
>> +static __always_inline unsigned long __must_check
>> +copy_to_user_key(void __user *to, const void *from, unsigned long n, unsigned long key)
>> +{
>> +    if (likely(check_copy_size(from, n, true)))
>> +        n = _copy_to_user_key(to, from, n, key);
>> +    return n;
>> +}
>> +
>>   int __put_user_bad(void) __attribute__((noreturn));
>>   int __get_user_bad(void) __attribute__((noreturn));
>> diff --git a/arch/s390/lib/uaccess.c b/arch/s390/lib/uaccess.c
>> index 8a5d21461889..b709239feb5d 100644
>> --- a/arch/s390/lib/uaccess.c
>> +++ b/arch/s390/lib/uaccess.c
>> @@ -59,11 +59,13 @@ static inline int copy_with_mvcos(void)
>>   #endif
>>   static inline unsigned long copy_from_user_mvcos(void *x, const void __user *ptr,
>> -                         unsigned long size)
>> +                         unsigned long size, unsigned long key)
>>   {
>>       unsigned long tmp1, tmp2;
>>       union oac spec = {
>> +        .oac2.key = key,
>>           .oac2.as = PSW_BITS_AS_SECONDARY,
>> +        .oac2.k = 1,
>>           .oac2.a = 1,
>>       };
>> @@ -94,19 +96,19 @@ static inline unsigned long copy_from_user_mvcos(void *x, const void __user *ptr
>>   }
>>   static inline unsigned long copy_from_user_mvcp(void *x, const void __user *ptr,
>> -                        unsigned long size)
>> +                        unsigned long size, unsigned long key)
>>   {
>>       unsigned long tmp1, tmp2;
>>       tmp1 = -256UL;
>>       asm volatile(
>>           "   sacf  0\n"
>> -        "0: mvcp  0(%0,%2),0(%1),%3\n"
>> +        "0: mvcp  0(%0,%2),0(%1),%[key]\n"
>>           "7: jz    5f\n"
>>           "1: algr  %0,%3\n"
>>           "   la    %1,256(%1)\n"
>>           "   la    %2,256(%2)\n"
>> -        "2: mvcp  0(%0,%2),0(%1),%3\n"
>> +        "2: mvcp  0(%0,%2),0(%1),%[key]\n"
>>           "8: jnz   1b\n"
>>           "   j     5f\n"
>>           "3: la    %4,255(%1)\n"    /* %4 = ptr + 255 */
>> @@ -115,7 +117,7 @@ static inline unsigned long copy_from_user_mvcp(void *x, const void __user *ptr,
>>           "   slgr  %4,%1\n"
>>           "   clgr  %0,%4\n"    /* copy crosses next page boundary? */
>>           "   jnh   6f\n"
>> -        "4: mvcp  0(%4,%2),0(%1),%3\n"
>> +        "4: mvcp  0(%4,%2),0(%1),%[key]\n"
>>           "9: slgr  %0,%4\n"
>>           "   j     6f\n"
>>           "5: slgr  %0,%0\n"
>> @@ -123,24 +125,49 @@ static inline unsigned long copy_from_user_mvcp(void *x, const void __user *ptr,
>>           EX_TABLE(0b,3b) EX_TABLE(2b,3b) EX_TABLE(4b,6b)
>>           EX_TABLE(7b,3b) EX_TABLE(8b,3b) EX_TABLE(9b,6b)
>>           : "+a" (size), "+a" (ptr), "+a" (x), "+a" (tmp1), "=a" (tmp2)
>> -        : : "cc", "memory");
>> +        : [key] "d" (key << 4)
>> +        : "cc", "memory");
>>       return size;
>>   }
>> -unsigned long raw_copy_from_user(void *to, const void __user *from, unsigned long n)
>> +static unsigned long raw_copy_from_user_key(void *to, const void __user *from,
>> +                        unsigned long n, unsigned long key)
>>   {
>>       if (copy_with_mvcos())
>> -        return copy_from_user_mvcos(to, from, n);
>> -    return copy_from_user_mvcp(to, from, n);
>> +        return copy_from_user_mvcos(to, from, n, key);
>> +    return copy_from_user_mvcp(to, from, n, key);
>> +}
>> +
>> +unsigned long raw_copy_from_user(void *to, const void __user *from, unsigned long n)
>> +{
>> +    return raw_copy_from_user_key(to, from, n, 0);
>>   }
>>   EXPORT_SYMBOL(raw_copy_from_user);
>> +unsigned long _copy_from_user_key(void *to, const void __user *from,
>> +                  unsigned long n, unsigned long key)
>> +{
>> +    unsigned long res = n;
>> +
>> +    might_fault();
>> +    if (!should_fail_usercopy()) {
>> +        instrument_copy_from_user(to, from, n);
>> +        res = raw_copy_from_user_key(to, from, n, key);
>> +    }
>> +    if (unlikely(res))
>> +        memset(to + (n - res), 0, res);
>> +    return res;
>> +}
>> +EXPORT_SYMBOL(_copy_from_user_key);
>> +
>>   static inline unsigned long copy_to_user_mvcos(void __user *ptr, const void *x,
>> -                           unsigned long size)
>> +                           unsigned long size, unsigned long key)
>>   {
>>       unsigned long tmp1, tmp2;
>>       union oac spec = {
>> +        .oac1.key = key,
>>           .oac1.as = PSW_BITS_AS_SECONDARY,
>> +        .oac1.k = 1,
>>           .oac1.a = 1,
>>       };
>> @@ -171,19 +198,19 @@ static inline unsigned long copy_to_user_mvcos(void __user *ptr, const void *x,
>>   }
>>   static inline unsigned long copy_to_user_mvcs(void __user *ptr, const void *x,
>> -                          unsigned long size)
>> +                          unsigned long size, unsigned long key)
>>   {
>>       unsigned long tmp1, tmp2;
>>       tmp1 = -256UL;
>>       asm volatile(
>>           "   sacf  0\n"
>> -        "0: mvcs  0(%0,%1),0(%2),%3\n"
>> +        "0: mvcs  0(%0,%1),0(%2),%[key]\n"
>>           "7: jz    5f\n"
>>           "1: algr  %0,%3\n"
>>           "   la    %1,256(%1)\n"
>>           "   la    %2,256(%2)\n"
>> -        "2: mvcs  0(%0,%1),0(%2),%3\n"
>> +        "2: mvcs  0(%0,%1),0(%2),%[key]\n"
>>           "8: jnz   1b\n"
>>           "   j     5f\n"
>>           "3: la    %4,255(%1)\n" /* %4 = ptr + 255 */
>> @@ -192,7 +219,7 @@ static inline unsigned long copy_to_user_mvcs(void __user *ptr, const void *x,
>>           "   slgr  %4,%1\n"
>>           "   clgr  %0,%4\n"    /* copy crosses next page boundary? */
>>           "   jnh   6f\n"
>> -        "4: mvcs  0(%4,%1),0(%2),%3\n"
>> +        "4: mvcs  0(%4,%1),0(%2),%[key]\n"
>>           "9: slgr  %0,%4\n"
>>           "   j     6f\n"
>>           "5: slgr  %0,%0\n"
>> @@ -200,18 +227,36 @@ static inline unsigned long copy_to_user_mvcs(void __user *ptr, const void *x,
>>           EX_TABLE(0b,3b) EX_TABLE(2b,3b) EX_TABLE(4b,6b)
>>           EX_TABLE(7b,3b) EX_TABLE(8b,3b) EX_TABLE(9b,6b)
>>           : "+a" (size), "+a" (ptr), "+a" (x), "+a" (tmp1), "=a" (tmp2)
>> -        : : "cc", "memory");
>> +        : [key] "d" (key << 4)
>> +        : "cc", "memory");
>>       return size;
>>   }
>> -unsigned long raw_copy_to_user(void __user *to, const void *from, unsigned long n)
>> +static unsigned long raw_copy_to_user_key(void __user *to, const void *from,
>> +                      unsigned long n, unsigned long key)
>>   {
>>       if (copy_with_mvcos())
>> -        return copy_to_user_mvcos(to, from, n);
>> -    return copy_to_user_mvcs(to, from, n);
>> +        return copy_to_user_mvcos(to, from, n, key);
>> +    return copy_to_user_mvcs(to, from, n, key);
>> +}
>> +
>> +unsigned long raw_copy_to_user(void __user *to, const void *from, unsigned long n)
>> +{
>> +    return raw_copy_to_user_key(to, from, n, 0);
>>   }
>>   EXPORT_SYMBOL(raw_copy_to_user);
>> +unsigned long _copy_to_user_key(void __user *to, const void *from,
>> +                unsigned long n, unsigned long key)
>> +{
>> +    might_fault();
>> +    if (should_fail_usercopy())
>> +        return n;
>> +    instrument_copy_to_user(to, from, n);
>> +    return raw_copy_to_user_key(to, from, n, key);
>> +}
>> +EXPORT_SYMBOL(_copy_to_user_key);
>> +
>>   static inline unsigned long clear_user_mvcos(void __user *to, unsigned long size)
>>   {
>>       unsigned long tmp1, tmp2;
