Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9FC7508993
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 15:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379064AbiDTNrp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 09:47:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378996AbiDTNrn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 09:47:43 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C86264F;
        Wed, 20 Apr 2022 06:44:56 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23KC1u4A023050;
        Wed, 20 Apr 2022 13:44:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=oIK6G4Mx6x35Ng/xmn0PjFMZavnjIBv1e01z5drXSac=;
 b=EQjvvpI0wXjmVWhLcX3pnbYApDEHAovHTJHNHodmt8KJqFKxJWN/jAJjf4+5ZPiiXc+h
 MrXaj8Q2/nYzK/gCHjTDFAU9vR3DsgsueXz0usg1OVaNtNUsrTwJtKGoGiAWH6MxXAhh
 gxi50Bn+jQ/njss1nZAiyBpxbIZwLrl6+GBl7gjzCI1eMIEwatTlYgxD7KMLE8wM5Ixy
 2PRhQH4M1nExX2tdqsoUGHeYeDE9q6RapBrAhkgKLUtuQyadu98dN3sXDIFeAQxCnyzT
 KgdU1DLaRdBd8BpyLgshuET0iLpKWpu3lZKkW0lb9C41n2rBUCreW7cwNEY4m3piJjKW Aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fg79fmubv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 13:44:55 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23KDDcQF018805;
        Wed, 20 Apr 2022 13:44:55 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fg79fmub1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 13:44:55 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23KDXUbL011634;
        Wed, 20 Apr 2022 13:44:53 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3ffne96dag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Apr 2022 13:44:52 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23KDiguL51118584
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Apr 2022 13:44:49 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 61CDFA405E;
        Wed, 20 Apr 2022 13:44:42 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 154C1A4055;
        Wed, 20 Apr 2022 13:44:42 +0000 (GMT)
Received: from [9.171.21.171] (unknown [9.171.21.171])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 20 Apr 2022 13:44:42 +0000 (GMT)
Message-ID: <c0e1237f-4794-063e-aab3-b589a47d5844@linux.ibm.com>
Date:   Wed, 20 Apr 2022 15:44:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [kvm-unit-tests PATCH v2] s390x: Test effect of storage keys on
 some instructions
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220301095059.3026178-1-scgl@linux.ibm.com>
 <f050da01-4d50-5da5-7f08-6da30f5dbbbe@redhat.com>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <f050da01-4d50-5da5-7f08-6da30f5dbbbe@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Ho80OZC-2ud1XPETi6TMBBBjniDwOYLJ
X-Proofpoint-ORIG-GUID: znJZzOEsJBeOkC09-q_mVhRtghPGv6cX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_03,2022-04-20_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 bulkscore=0 phishscore=0 clxscore=1015 malwarescore=0 spamscore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204200081
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/12/22 11:32, Thomas Huth wrote:
> On 01/03/2022 10.50, Janis Schoetterl-Glausch wrote:
>> Some instructions are emulated by KVM. Test that KVM correctly emulates
>> storage key checking for two of those instructions (STORE CPU ADDRESS,
>> SET PREFIX).
>> Test success and error conditions, including coverage of storage and
>> fetch protection override.
>> Also add test for TEST PROTECTION, even if that instruction will not be
>> emulated by KVM under normal conditions.
>>
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>> ---
> [...]
>>   lib/s390x/asm/arch_def.h |  20 ++---
>>   s390x/skey.c             | 171 +++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 182 insertions(+), 9 deletions(-)
>>
>> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
>> index 40626d72..e443a9cd 100644
>> --- a/lib/s390x/asm/arch_def.h
>> +++ b/lib/s390x/asm/arch_def.h
>> @@ -55,15 +55,17 @@ struct psw {
>>   #define PSW_MASK_BA            0x0000000080000000UL
>>   #define PSW_MASK_64            (PSW_MASK_BA | PSW_MASK_EA)
>>   -#define CTL0_LOW_ADDR_PROT        (63 - 35)
>> -#define CTL0_EDAT            (63 - 40)
>> -#define CTL0_IEP            (63 - 43)
>> -#define CTL0_AFP            (63 - 45)
>> -#define CTL0_VECTOR            (63 - 46)
>> -#define CTL0_EMERGENCY_SIGNAL        (63 - 49)
>> -#define CTL0_EXTERNAL_CALL        (63 - 50)
>> -#define CTL0_CLOCK_COMPARATOR        (63 - 52)
>> -#define CTL0_SERVICE_SIGNAL        (63 - 54)
>> +#define CTL0_LOW_ADDR_PROT            (63 - 35)
>> +#define CTL0_EDAT                (63 - 40)
>> +#define CTL0_FETCH_PROTECTION_OVERRIDE        (63 - 38)
>> +#define CTL0_STORAGE_PROTECTION_OVERRIDE    (63 - 39)
> 
> Just a matter of taste, but IMHO the names are getting a little bit long here ... maybe use "PROT" instead of "PROTECTION" to shorten them a little bit?

It's called CR0_STORAGE_PROTECTION_OVERRIDE in the kernel and I
want it to keep it similar to that.

[...]

>> +static void test_store_cpu_address(void)
>> +{
>> +    uint16_t *out = (uint16_t *)pagebuf;
>> +    uint16_t cpu_addr;
>> +
>> +    asm ("stap %0" : "=Q" (cpu_addr));
>> +
>> +    report_prefix_push("STORE CPU ADDRESS, zero key");
> 
> You could also use one report_prefix_push("STORE CPU ADDRESS") prefix for the whole function, so you don't have to repeat that string everywhere again.
> 
>> +    set_storage_key(pagebuf, 0x20, 0);
>> +    *out = 0xbeef;
>> +    asm ("stap %0" : "=Q" (*out));
> 
> I think it might be better to use +Q here ... otherwise the compiler might optimize the "*out = 0xbeef" away, since it sees that the variable is only written twice, but never used in between.

Good catch, I'll use WRITE_ONCE tho, since no exceptions should occur
in the asm and it might be a bit misleading.

[...]
>> +    set_storage_key(pagebuf, 0x00, 0);
> 
> The other tests don't clear the storage key at the end, so why here now?

It's not necessary, but Claudio suggested it for the last version and
I like that it indicates that there is not supposed to be a shared state between the tests.

[...]

>> +    report_prefix_push("SET PREFIX, mismatching key, fetch protection override does not apply");
>> +    out = (uint32_t *)(pagebuf + 2048);
>> +    set_storage_key(pagebuf, 0x28, 0);
>> +    expect_pgm_int();
>> +    install_page(root, virt_to_pte_phys(root, pagebuf), 0);
>> +    WRITE_ONCE(*out, 0xdeadbeef);
> 
> Would it make sense to swap the above two lines, i.e. first the WRITE_ONCE, then the install_page? ... access to *out between the two intall_page() calls requires me to think twice whether that's ok or not ;-)

Yes, that is possible. Alternatively we could do

*(uint32_t *)2048 = 0xdeadbeef;

Which might make it clearer to the reader what's happening.
I'm not sure if it is a good idea of if the compiler would take it as an invitation to do funky things.

[...]

I'll implement your other suggestions, too.
Thanks for the input!
> 
>  Thomas
> 

