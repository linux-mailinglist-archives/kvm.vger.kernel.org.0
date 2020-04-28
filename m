Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C761BB9D0
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 11:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgD1J1a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 05:27:30 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18366 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726477AbgD1J1a (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 05:27:30 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03S92O6L141129;
        Tue, 28 Apr 2020 05:27:29 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mh9ncv4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Apr 2020 05:27:29 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03S936qK144559;
        Tue, 28 Apr 2020 05:27:29 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mh9ncv3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Apr 2020 05:27:29 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03S9Q70s029207;
        Tue, 28 Apr 2020 09:27:27 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 30mcu5nsd8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Apr 2020 09:27:26 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03S9QGn9393748
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 09:26:16 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7D485204F;
        Tue, 28 Apr 2020 09:27:24 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.156.174])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 5B86C5204E;
        Tue, 28 Apr 2020 09:27:24 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v6 08/10] s390x: define wfi: wait for
 interrupt
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com
References: <1587725152-25569-1-git-send-email-pmorel@linux.ibm.com>
 <1587725152-25569-9-git-send-email-pmorel@linux.ibm.com>
 <4cc33b1c-7fa2-0775-f176-08bb31b7e68e@linux.ibm.com>
 <60b951c7-2fa2-2284-db04-33e422974626@linux.ibm.com>
 <84cf8f4f-4d29-8ff5-0d84-5c9b0b52ff34@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <f13ba67e-7b36-f184-f585-ec198be6f40b@linux.ibm.com>
Date:   Tue, 28 Apr 2020 11:27:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <84cf8f4f-4d29-8ff5-0d84-5c9b0b52ff34@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_03:2020-04-27,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 spamscore=0 malwarescore=0 adultscore=0 suspectscore=0 mlxlogscore=802
 impostorscore=0 lowpriorityscore=0 mlxscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280074
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-04-28 11:20, Janosch Frank wrote:
> On 4/28/20 10:44 AM, Pierre Morel wrote:
>>
>>
>> On 2020-04-27 14:59, Janosch Frank wrote:
>>> On 4/24/20 12:45 PM, Pierre Morel wrote:
>>>> wfi(irq_mask) allows the programm to wait for an interrupt.
>>>
>>> s/programm/program/
>>
>> Thx,
>>
>>>
>>>> The interrupt handler is in charge to remove the WAIT bit
>>>> when it finished handling interrupt.
>>>
>>> ...finished handling the interrupt.
>>
>> OK, thx
>>
>>>
>>
>>>>    }
>>>>    
>>>> +static inline void wfi(uint64_t irq_mask)
>>>
>>> enabled_wait()
>>
>>
>> I do not like enabled_wait(), we do not know what is enabled and we do
>> not know what we are waiting for.
>>
>> What about wait_for_interrupt()
> 
> As long as it's not called wfi...
> 
>>
>>>
>>>> +{
>>>> +	uint64_t psw_mask;
>>>
>>> You can directly initialize this variable.
>>>
>>>> +
>>>> +	psw_mask = extract_psw_mask();
>>>> +	load_psw_mask(psw_mask | irq_mask | PSW_MASK_WAIT);
>>>
>>> Maybe add a comment here:
>>>
>>> /*
>>>    * After being woken and having processed the interrupt, let's restore
>>> the PSW mask.
>>> */
>>>
>>>> +	load_psw_mask(psw_mask);
>>>> +}
>>>> +
>>
>> I can do this, but wasn't it obvious?
> 
> It took me a minute, so it will take even longer for developers that are
> not yet familiar with s390 kernel development.
> 
>>
>>
>> Regards,
>> Pierre
>>
> 
> 

OK, will do
Thx

Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
