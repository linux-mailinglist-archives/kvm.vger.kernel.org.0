Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C90D213A09
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 14:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbgGCMZy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 08:25:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30202 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726022AbgGCMZy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Jul 2020 08:25:54 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 063C2Ca2091517;
        Fri, 3 Jul 2020 08:25:53 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 322144nxpb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 08:25:53 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 063CFlpj136601;
        Fri, 3 Jul 2020 08:25:53 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 322144nxnc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 08:25:53 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 063C6Cft000792;
        Fri, 3 Jul 2020 12:25:50 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 31wwr7uf35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 12:25:50 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 063CORsf63504796
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Jul 2020 12:24:27 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1303842045;
        Fri,  3 Jul 2020 12:25:48 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 973DD42041;
        Fri,  3 Jul 2020 12:25:47 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.158.26])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  3 Jul 2020 12:25:47 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v10 9/9] s390x: css: ssch/tsch with sense
 and interrupt
To:     Janosch Frank <frankja@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, cohuck@redhat.com,
        drjones@redhat.com
References: <1593707480-23921-1-git-send-email-pmorel@linux.ibm.com>
 <1593707480-23921-10-git-send-email-pmorel@linux.ibm.com>
 <d8b2ed8c-3948-1cba-47af-ef2a8cdf27ed@redhat.com>
 <0aaab65b-7856-9be9-c6dc-4da8e8d529d4@linux.ibm.com>
 <75982e29-5df8-abf3-57aa-ff717a4868d6@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <b475ca1d-4c34-a58f-d632-1d167cf39dfb@linux.ibm.com>
Date:   Fri, 3 Jul 2020 14:25:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <75982e29-5df8-abf3-57aa-ff717a4868d6@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-03_06:2020-07-02,2020-07-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 mlxscore=0 spamscore=0 impostorscore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 cotscore=-2147483648
 suspectscore=0 adultscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007030082
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-07-03 14:01, Janosch Frank wrote:
> On 7/3/20 11:05 AM, Pierre Morel wrote:
>>
>>
>> On 2020-07-03 10:41, Thomas Huth wrote:
>>> On 02/07/2020 18.31, Pierre Morel wrote:
>>>> After a channel is enabled we start a SENSE_ID command using
>>>> the SSCH instruction to recognize the control unit and device.
>>>>
>>>> This tests the success of SSCH, the I/O interruption and the TSCH
>>>> instructions.
>>>>
>>>> The SENSE_ID command response is tested to report 0xff inside
>>>> its reserved field and to report the same control unit type
>>>> as the cu_type kernel argument.
>>>>
>>>> Without the cu_type kernel argument, the test expects a device
>>>> with a default control unit type of 0x3832, a.k.a virtio-net-ccw.
>>>>
>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>> ---
>>> [...]
>>>> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
>>>> index 0ddceb1..9c22644 100644
>>>> --- a/lib/s390x/css.h
>>>> +++ b/lib/s390x/css.h
>>>> @@ -11,6 +11,8 @@
>>>>    #ifndef CSS_H
>>>>    #define CSS_H
>>>>    
>>>> +#define lowcore_ptr ((struct lowcore *)0x0)
>>>
>>> I'd prefer if you could either put this into the css_lib.c file or in
>>> lib/s390x/asm/arch_def.h.
>>
>> I have a patch ready for this :)
>> But I did not want to add too much new things in this series that could
>> start a new discussion.
>>
>> I have 2 versions of the patch:
>> - The simple one with just the declaration in arch_def.h
>> - The complete one with update of all tests (but smp) using a pointer to
>> lowcore.
>>
> 
> I've seen that patch on your branch and like most maintainers I'm not
> incredibly happy with patches touching a single line in a lot of files.
> 
> Maybe we can achieve a compromise and only clean up our library. The
> tests can be changed when they need to be touched for other changes.
> 
> Anyway for now I think css_lib.c might be the right place. We can talk
> about a lowcore cleanup next week if you want.

css_lib.c is not a good solution because the pointer is also needed in 
css.c.
So the question is css.h or arch_def.h

I have set it in css.h because Ithink it is better to keep it local 
until the others tests need/want to use the same way of accessing lowcore.


-- 
Pierre Morel
IBM Lab Boeblingen
