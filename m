Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17CA833110C
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 15:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbhCHOjT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 09:39:19 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7520 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230511AbhCHOjH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 09:39:07 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 128EXklf059923
        for <kvm@vger.kernel.org>; Mon, 8 Mar 2021 09:39:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Cbxqeq9YSqbvaWoQRl0/dcgY8+6UgZ8lEZPOhy2dDzI=;
 b=i6kImtXds2vylhD4pzJpeTbA1rcA1N0qxwJ30sqxQSiJq9E8IsISN9Rz+Y0DfOJCQhnZ
 /x1NE5DV65sVWcCiNfO/engQhIBpTWTfsPPHCUHFUc1nZks0haI8p/NusXYITIku4v2t
 WMceAjhIkPoajA7TVfk+2EV4KXNwEshjUtJEOzQdx7potFf6VJS1bhz779dsaXhQk9gi
 BdvkAXsPTAwLZ5EgwKE132WiP7hUBDnm3kHuFtoHS9yc9ZvuM7+EU2IKv4COzm+Srqe+
 kitBpGts7oVUqgZ/xi6+imdijB9I0qkNKfUBCSsd3qk4Mq9g0DZgk2qijcwIco5d7A2v ng== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375nqbgbaf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 08 Mar 2021 09:39:07 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 128EXarn009490
        for <kvm@vger.kernel.org>; Mon, 8 Mar 2021 14:39:05 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 37410h9xdk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 08 Mar 2021 14:39:05 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 128Ed3Ro41353596
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <kvm@vger.kernel.org>; Mon, 8 Mar 2021 14:39:03 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E64B64C052;
        Mon,  8 Mar 2021 14:39:02 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90B5C4C05A;
        Mon,  8 Mar 2021 14:39:02 +0000 (GMT)
Received: from [9.145.7.187] (unknown [9.145.7.187])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Mar 2021 14:39:02 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v4 1/6] s390x: css: Store CSS
 Characteristics
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1614599225-17734-1-git-send-email-pmorel@linux.ibm.com>
 <1614599225-17734-2-git-send-email-pmorel@linux.ibm.com>
 <2c94918a-11af-1ac0-9e8b-11439f078727@linux.ibm.com>
 <3730f9e7-be8a-4407-6a03-6bd6623447d8@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <f03a368d-1abd-0bb4-cdaa-8634277830f0@linux.ibm.com>
Date:   Mon, 8 Mar 2021 15:39:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <3730f9e7-be8a-4407-6a03-6bd6623447d8@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-08_08:2021-03-08,2021-03-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0 phishscore=0
 malwarescore=0 mlxscore=0 priorityscore=1501 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103080080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/8/21 3:01 PM, Pierre Morel wrote:
> 
> 
> On 3/1/21 3:45 PM, Janosch Frank wrote:
>> On 3/1/21 12:47 PM, Pierre Morel wrote:
>>> CSS characteristics exposes the features of the Channel SubSystem.
>>> Let's use Store Channel Subsystem Characteristics to retrieve
>>> the features of the CSS.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>>
>> Acked-by: Janosch Frank <frankja@linux.ibm.com>
>>
>> Small nits below
>>
>>> ---
>>>   lib/s390x/css.h     | 67 ++++++++++++++++++++++++++++++++
>>>   lib/s390x/css_lib.c | 93 ++++++++++++++++++++++++++++++++++++++++++++-
>>>   s390x/css.c         |  8 ++++
>>>   3 files changed, 167 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
>>> index 3e57445..4210472 100644
>>> --- a/lib/s390x/css.h
>>> +++ b/lib/s390x/css.h
>>> @@ -288,4 +288,71 @@ int css_residual_count(unsigned int schid);
>>>   void enable_io_isc(uint8_t isc);
>>>   int wait_and_check_io_completion(int schid);
>>>   
>>> +/*
>>> + * CHSC definitions
>>> + */
>>> +struct chsc_header {
>>> +	uint16_t len;
>>> +	uint16_t code;
>>> +};
>>> +
>>> +/* Store Channel Subsystem Characteristics */
>>> +struct chsc_scsc {
>>> +	struct chsc_header req;
>>> +	uint16_t req_fmt;
>>> +	uint8_t cssid;
>>> +	uint8_t res_03;
>>> +	uint32_t res_04[2];
>>
>> I find the naming a bit weird and it could be one uint8_t field.
> 
> OK
> 
>>
>>> +	struct chsc_header res;
>>> +	uint32_t res_fmt;
>>> +	uint64_t general_char[255];
>>> +	uint64_t chsc_char[254];
>>> +};
> 
> ... snip
> 
>>> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
>>> index 3c24480..f46e871 100644
>>> --- a/lib/s390x/css_lib.c
>>> +++ b/lib/s390x/css_lib.c
>>> @@ -15,11 +15,102 @@
>>>   #include <asm/arch_def.h>
>>>   #include <asm/time.h>
>>>   #include <asm/arch_def.h>
>>> -
>>> +#include <alloc_page.h>
>>
>> Did you intend to remove the newline here?
> 
> Yes I do not see why we should have a new line here.

Some people like to separate asm includes from other includes.

> But I can keep it if you want.

I just wanted to know if you removed it by mistake, if you want it that
way it's ok for me.

> 
>>
> ... snip...
> 
>>>   #include <asm/arch_def.h>
>>> +#include <alloc_page.h>
>>>   
>>>   #include <malloc_io.h>
>>>   #include <css.h>
>>> @@ -140,10 +141,17 @@ error_senseid:
>>>   	unregister_io_int_func(css_irq_io);
>>>   }
>>>   
>>> +static void css_init(void)
>>> +{
>>> +	report(!!get_chsc_scsc(), "Store Channel Characteristics");
>>
>> get_chsc_scsc() returns a bool, so you shouldn't need the !! here, no?
> 
> Yes, forgotten when changed get_chsc_scsc(), remove the !!
> 
> 
> Thanks,
> Pierre
> 

