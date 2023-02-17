Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F28469A6CC
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 09:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbjBQIWP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 03:22:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBQIWN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 03:22:13 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BAD65EC91;
        Fri, 17 Feb 2023 00:21:54 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31H6DY4S034574;
        Fri, 17 Feb 2023 08:21:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=PhOPvRxSccZ0JizLljIoOYKn+EmB6A64ecGWeyQyOSE=;
 b=f8/C20xUFz/RSsyd394W/4lGKk+FNLCkWEkC00EjNamkYYf9rj8iZVapKTEuqicyZw9d
 5xSvzBof3ig89Cndz/2KumSTufaFB44ek7LSUcaHlY2xzFamYV0Z2olvSll/r1qXF9Js
 /x+NwA0LKbioye2B0WwDiURa22qwaDnv7dF27EVgcCUrgP+D8/e2ozQED/ku9hvxo4kz
 n3/I7LTp8su+oxWgdPxh6A7zPR7chT3kNVyi1C5Dj6PuZfBFd5swtxuXII5bmEweu0cV
 dw8XtGcsJfm4PrnX4J1zL0w/FqFtakXGzDyQ/unkrBJkMU/hZ8xguYG+ez+rTxEKpByZ 6A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nt44daffd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Feb 2023 08:21:53 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31H7oid0005198;
        Fri, 17 Feb 2023 08:21:52 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nt44dafet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Feb 2023 08:21:52 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31GFRmko002747;
        Fri, 17 Feb 2023 08:21:50 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3np2n6dpcs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Feb 2023 08:21:50 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31H8LlHp44761502
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Feb 2023 08:21:47 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE95220043;
        Fri, 17 Feb 2023 08:21:46 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C68B20040;
        Fri, 17 Feb 2023 08:21:46 +0000 (GMT)
Received: from [9.179.29.70] (unknown [9.179.29.70])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 17 Feb 2023 08:21:46 +0000 (GMT)
Message-ID: <4b54bb98-593d-4ef0-8479-6e0446ee902a@linux.ibm.com>
Date:   Fri, 17 Feb 2023 09:21:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH v3 1/1] KVM: s390: vsie: clarifications on setting the
 APCB
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>, david@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, svens@linux.ibm.com
References: <20230214122841.13066-1-pmorel@linux.ibm.com>
 <20230214122841.13066-2-pmorel@linux.ibm.com>
 <d32a4080-3c74-27f0-2ef7-78755da98022@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <d32a4080-3c74-27f0-2ef7-78755da98022@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1pIoEP0DGBrcz1S7HYMID0Pv2VGeQDNA
X-Proofpoint-GUID: KxVel-WhCNhAttbkqfI1E-8mtE0Ad1mI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-17_04,2023-02-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 bulkscore=0 clxscore=1015 adultscore=0 mlxscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302170073
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/16/23 14:41, Janosch Frank wrote:
> On 2/14/23 13:28, Pierre Morel wrote:
>> The APCB is part of the CRYCB.
>> The calculation of the APCB origin can be done by adding
>> the APCB offset to the CRYCB origin.
>>
>> Current code makes confusing transformations, converting
>> the CRYCB origin to a pointer to calculate the APCB origin.
>>
>> Let's make things simpler and keep the CRYCB origin to make
>> these calculations.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> 
> LGTM:
> Acked-by: Janosch Frank <frankja@linux.ibm.com>

Thanks,
Pierre

> 
>> ---
>>   arch/s390/kvm/vsie.c | 50 +++++++++++++++++++++++++-------------------
>>   1 file changed, 29 insertions(+), 21 deletions(-)
>>
>> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
>> index b6a0219e470a..8d6b765abf29 100644
>> --- a/arch/s390/kvm/vsie.c
>> +++ b/arch/s390/kvm/vsie.c
>> @@ -138,11 +138,15 @@ static int prepare_cpuflags(struct kvm_vcpu 
>> *vcpu, struct vsie_page *vsie_page)
>>   }
>>   /* Copy to APCB FORMAT1 from APCB FORMAT0 */
>>   static int setup_apcb10(struct kvm_vcpu *vcpu, struct kvm_s390_apcb1 
>> *apcb_s,
>> -            unsigned long apcb_o, struct kvm_s390_apcb1 *apcb_h)
>> +            unsigned long crycb_gpa, struct kvm_s390_apcb1 *apcb_h)
>>   {
>>       struct kvm_s390_apcb0 tmp;
>> +    unsigned long apcb_gpa;
>> -    if (read_guest_real(vcpu, apcb_o, &tmp, sizeof(struct 
>> kvm_s390_apcb0)))
>> +    apcb_gpa = crycb_gpa + offsetof(struct kvm_s390_crypto_cb, apcb0);
>> +
>> +    if (read_guest_real(vcpu, apcb_gpa, &tmp,
>> +                sizeof(struct kvm_s390_apcb0)))
>>           return -EFAULT;
>>       apcb_s->apm[0] = apcb_h->apm[0] & tmp.apm[0];
>> @@ -157,15 +161,19 @@ static int setup_apcb10(struct kvm_vcpu *vcpu, 
>> struct kvm_s390_apcb1 *apcb_s,
>>    * setup_apcb00 - Copy to APCB FORMAT0 from APCB FORMAT0
>>    * @vcpu: pointer to the virtual CPU
>>    * @apcb_s: pointer to start of apcb in the shadow crycb
>> - * @apcb_o: pointer to start of original apcb in the guest2
>> + * @crycb_gpa: guest physical address to start of original guest crycb
>>    * @apcb_h: pointer to start of apcb in the guest1
>>    *
>>    * Returns 0 and -EFAULT on error reading guest apcb
>>    */
>>   static int setup_apcb00(struct kvm_vcpu *vcpu, unsigned long *apcb_s,
>> -            unsigned long apcb_o, unsigned long *apcb_h)
>> +            unsigned long crycb_gpa, unsigned long *apcb_h)
>>   {
>> -    if (read_guest_real(vcpu, apcb_o, apcb_s,
>> +    unsigned long apcb_gpa;
>> +
>> +    apcb_gpa = crycb_gpa + offsetof(struct kvm_s390_crypto_cb, apcb0);
>> +
>> +    if (read_guest_real(vcpu, apcb_gpa, apcb_s,
>>                   sizeof(struct kvm_s390_apcb0)))
>>           return -EFAULT;
>> @@ -178,16 +186,20 @@ static int setup_apcb00(struct kvm_vcpu *vcpu, 
>> unsigned long *apcb_s,
>>    * setup_apcb11 - Copy the FORMAT1 APCB from the guest to the shadow 
>> CRYCB
>>    * @vcpu: pointer to the virtual CPU
>>    * @apcb_s: pointer to start of apcb in the shadow crycb
>> - * @apcb_o: pointer to start of original guest apcb
>> + * @crycb_gpa: guest physical address to start of original guest crycb
>>    * @apcb_h: pointer to start of apcb in the host
>>    *
>>    * Returns 0 and -EFAULT on error reading guest apcb
>>    */
>>   static int setup_apcb11(struct kvm_vcpu *vcpu, unsigned long *apcb_s,
>> -            unsigned long apcb_o,
>> +            unsigned long crycb_gpa,
>>               unsigned long *apcb_h)
>>   {
>> -    if (read_guest_real(vcpu, apcb_o, apcb_s,
>> +    unsigned long apcb_gpa;
>> +
>> +    apcb_gpa = crycb_gpa + offsetof(struct kvm_s390_crypto_cb, apcb1);
>> +
>> +    if (read_guest_real(vcpu, apcb_gpa, apcb_s,
>>                   sizeof(struct kvm_s390_apcb1)))
>>           return -EFAULT;
>> @@ -200,7 +212,7 @@ static int setup_apcb11(struct kvm_vcpu *vcpu, 
>> unsigned long *apcb_s,
>>    * setup_apcb - Create a shadow copy of the apcb.
>>    * @vcpu: pointer to the virtual CPU
>>    * @crycb_s: pointer to shadow crycb
>> - * @crycb_o: pointer to original guest crycb
>> + * @crycb_gpa: guest physical address of original guest crycb
>>    * @crycb_h: pointer to the host crycb
>>    * @fmt_o: format of the original guest crycb.
>>    * @fmt_h: format of the host crycb.
>> @@ -211,50 +223,46 @@ static int setup_apcb11(struct kvm_vcpu *vcpu, 
>> unsigned long *apcb_s,
>>    * Return 0 or an error number if the guest and host crycb are 
>> incompatible.
>>    */
>>   static int setup_apcb(struct kvm_vcpu *vcpu, struct 
>> kvm_s390_crypto_cb *crycb_s,
>> -           const u32 crycb_o,
>> +           const u32 crycb_gpa,
>>              struct kvm_s390_crypto_cb *crycb_h,
>>              int fmt_o, int fmt_h)
>>   {
>> -    struct kvm_s390_crypto_cb *crycb;
>> -
>> -    crycb = (struct kvm_s390_crypto_cb *) (unsigned long)crycb_o;
>> -
>>       switch (fmt_o) {
>>       case CRYCB_FORMAT2:
>> -        if ((crycb_o & PAGE_MASK) != ((crycb_o + 256) & PAGE_MASK))
>> +        if ((crycb_gpa & PAGE_MASK) != ((crycb_gpa + 256) & PAGE_MASK))
>>               return -EACCES;
>>           if (fmt_h != CRYCB_FORMAT2)
>>               return -EINVAL;
>>           return setup_apcb11(vcpu, (unsigned long *)&crycb_s->apcb1,
>> -                    (unsigned long) &crycb->apcb1,
>> +                    crycb_gpa,
>>                       (unsigned long *)&crycb_h->apcb1);
>>       case CRYCB_FORMAT1:
>>           switch (fmt_h) {
>>           case CRYCB_FORMAT2:
>>               return setup_apcb10(vcpu, &crycb_s->apcb1,
>> -                        (unsigned long) &crycb->apcb0,
>> +                        crycb_gpa,
>>                           &crycb_h->apcb1);
>>           case CRYCB_FORMAT1:
>>               return setup_apcb00(vcpu,
>>                           (unsigned long *) &crycb_s->apcb0,
>> -                        (unsigned long) &crycb->apcb0,
>> +                        crycb_gpa,
>>                           (unsigned long *) &crycb_h->apcb0);
>>           }
>>           break;
>>       case CRYCB_FORMAT0:
>> -        if ((crycb_o & PAGE_MASK) != ((crycb_o + 32) & PAGE_MASK))
>> +        if ((crycb_gpa & PAGE_MASK) != ((crycb_gpa + 32) & PAGE_MASK))
>>               return -EACCES;
>>           switch (fmt_h) {
>>           case CRYCB_FORMAT2:
>>               return setup_apcb10(vcpu, &crycb_s->apcb1,
>> -                        (unsigned long) &crycb->apcb0,
>> +                        crycb_gpa,
>>                           &crycb_h->apcb1);
>>           case CRYCB_FORMAT1:
>>           case CRYCB_FORMAT0:
>>               return setup_apcb00(vcpu,
>>                           (unsigned long *) &crycb_s->apcb0,
>> -                        (unsigned long) &crycb->apcb0,
>> +                        crycb_gpa,
>>                           (unsigned long *) &crycb_h->apcb0);
>>           }
>>       }
> 

-- 
Pierre Morel
IBM Lab Boeblingen
