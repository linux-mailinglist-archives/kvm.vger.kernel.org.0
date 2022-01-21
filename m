Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E4A495FFB
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 14:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380681AbiAUNui (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 08:50:38 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22422 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350479AbiAUNud (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Jan 2022 08:50:33 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20LDgC3n017387;
        Fri, 21 Jan 2022 13:50:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=O+zsEh10iv4ltaOecp/Lq/UMv/BhS8YHn1EmaRaVRZM=;
 b=WexoyTYow3B5IxYf/TboM+5zq3AbKlISYCYXmnRR25jotQF7xic7KgfhWaOpfZfwV0kg
 v1fj/L5ZlKfl+7E1dbA/7qQafQDCUG4hCxhlKeG3SDdAjwIareSaVHpbo5/YT/nPECMh
 81yWbTNGq7MuVdtTdiJGKvtLfHMdMAmfUORDSMWUGUkwJQAlhqZKjYfQSOcQQeTiFsWi
 CSRLo+f/ajkA9nSurTymBQiZ2HYuYpdjFAqMdChHiRBdUoD6UMpC/HZJqbp0hSeM0P6i
 Vsk4O0JpvB+kaRWKn/HfDA5XQDwrEDBnqJXhPIi/WG3i3LDg+hFJ+Nr/hVp7DAn/fc3D Vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dqwxjr5rn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 13:50:32 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20LDgwMP022136;
        Fri, 21 Jan 2022 13:50:32 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dqwxjr5qy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 13:50:32 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20LDmFPJ015729;
        Fri, 21 Jan 2022 13:50:30 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3dqjdpn6as-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 13:50:29 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20LDoQ5225362782
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 13:50:26 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECD5552050;
        Fri, 21 Jan 2022 13:50:25 +0000 (GMT)
Received: from [9.171.30.56] (unknown [9.171.30.56])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 99ACB5205A;
        Fri, 21 Jan 2022 13:50:25 +0000 (GMT)
Message-ID: <1bd19f35-aaa1-1668-60ec-14b999b8e4e2@linux.ibm.com>
Date:   Fri, 21 Jan 2022 14:50:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [RFC PATCH v1 04/10] KVM: s390: selftests: Test TEST PROTECTION
 emulation
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220118095210.1651483-1-scgl@linux.ibm.com>
 <20220118095210.1651483-5-scgl@linux.ibm.com>
 <c5ce5d0b-444b-ba33-a670-3bd3893af475@linux.ibm.com>
 <06422388-8389-6954-00c7-7b582b4cf1bb@linux.ibm.com>
 <20220121132801.12ea572f@p-imbrenda>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <20220121132801.12ea572f@p-imbrenda>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jR3cGsM2MG5NDoDjLwFFguK8WhEyXniz
X-Proofpoint-ORIG-GUID: u3sLOEDWebyD0b2qnhKMRClvDgZSoRrx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_06,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 phishscore=0 spamscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 impostorscore=0 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201210091
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/21/22 13:28, Claudio Imbrenda wrote:
> On Fri, 21 Jan 2022 12:03:20 +0100
> Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
> 
> [...]
> 
>>>> +
>>>> +static int set_storage_key(void *addr, uint8_t key)
>>>> +{
>>>> +    int not_mapped = 0;
>>>> +  
>>>
>>> Maybe add a short comment:
>>> Check if address is mapped via lra and set the storage key if it is.
>>>   
>>>> +    asm volatile (
>>>> +               "lra    %[addr], 0(0,%[addr])\n"
>>>> +        "    jz    0f\n"
>>>> +        "    llill    %[not_mapped],1\n"
>>>> +        "    j    1f\n"
>>>> +        "0:    sske    %[key], %[addr]\n"
>>>> +        "1:"
>>>> +        : [addr] "+&a" (addr), [not_mapped] "+r" (not_mapped)  
>>>
>>> Shouldn't this be a "=r" instead of a "+r" for not_mapped?  
>>
>> I don't think so. We only write to it on one code path and the compiler mustn't conclude
>> that it can remove the = 0 assignment because the value gets overwritten anyway.
>>
>> Initially I tried to implement the function like this:
>>
>> static int set_storage_key(void *addr, uint8_t key)
>> {
>>         asm goto ("lra  %[addr], 0(0,%[addr])\n\t"
>>                   "jnz  %l[not_mapped]\n\t"
>>                   "sske %[key], %[addr]\n"
>>                 : [addr] "+&a" (addr)
>>                 : [key] "r" (key)
>>                 : "cc", "memory"
>>                 : not_mapped
>>         );
>>         return 0;
>> not_mapped:
>>         return -1;
>> }
>>
>> Which I think is nicer, but the compiler just optimized that completely away.
>> I have no clue why it (thinks it) is allowed to do that.
>>
>>>   
>>>> +        : [key] "r" (key)
>>>> +        : "cc"
>>>> +    );
>>>> +    return -not_mapped;
>>>> +}
>>>> +
>>>> +enum permission {
>>>> +    READ_WRITE = 0,
>>>> +    READ = 1,
>>>> +    NONE = 2,
>>>> +    UNAVAILABLE = 3,  
>>>
>>> TRANSLATION_NA ?
>>> I'm not completely happy with these names but I've yet to come up with a better naming scheme here.  
>>
>> Mentioning translation is a good idea. Don't think there is any harm in using
>> TRANSLATION_NOT_AVAILABLE or TRANSLATION_UNAVAILABLE.
> 
> it's too long, it actually makes the code harder to read when used
> 
> maybe consider something like TRANSL_UNAVAIL as well

Fine with me. I'll rename NONE to RW_PROTECTED. NONE is too nondescript.
> 
>>>   
>>>> +};
>>>> +
>>>> +static enum permission test_protection(void *addr, uint8_t key)
>>>> +{
>>>> +    uint64_t mask;
>>>> +
>>>> +    asm volatile (
>>>> +               "tprot    %[addr], 0(%[key])\n"
>>>> +        "    ipm    %[mask]\n"
>>>> +        : [mask] "=r" (mask)
>>>> +        : [addr] "Q" (*(char *)addr),
>>>> +          [key] "a" (key)
>>>> +        : "cc"
>>>> +    );
>>>> +
>>>> +    return (enum permission)mask >> 28;  
>>>
>>> You could replace the shift with the "srl" that we normally do.  
>>
>> I prefer keeping the asm as small as possible, C is just so much easier to understand.
> 
> we use srl everywhere, but I agree that explicitly using C makes it
> less obscure. and in the end the compiler should generate the same
> instructions anyway.
> 
> my only comment about the above code is that you are casting the
> uint64_t to enum permission _and then_ shifting. _technically_ it
> should still work (enums are just ints), but I think it would
> look cleaner if you write
> 
> 	return (enum permission)(mask >> 28);

That is better indeed.

[...]
