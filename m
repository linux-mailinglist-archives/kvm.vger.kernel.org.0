Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAE6FFCAA3
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 17:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbfKNQRo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 11:17:44 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50882 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726251AbfKNQRo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Nov 2019 11:17:44 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAEG4dcX072336
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 11:17:42 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2w97mp60q8-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 11:15:33 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Thu, 14 Nov 2019 16:15:17 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 14 Nov 2019 16:15:15 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAEGFEEd42664272
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 16:15:14 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 84C5152052;
        Thu, 14 Nov 2019 16:15:14 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.27])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 4F23C52051;
        Thu, 14 Nov 2019 16:15:14 +0000 (GMT)
Subject: Re: [PATCH v1 1/4] s390x: saving regs for interrupts
To:     David Hildenbrand <dhildenb@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, thuth@redhat.com
References: <6c84ade5-8a42-9c73-abff-47e019fc11bd@linux.ibm.com>
 <7C13E9AB-F26B-439B-A170-F187BC1E1136@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Thu, 14 Nov 2019 17:15:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <7C13E9AB-F26B-439B-A170-F187BC1E1136@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19111416-4275-0000-0000-0000037DBE05
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111416-4276-0000-0000-0000389124FB
Message-Id: <e908c728-59ad-0a30-5721-e96500fd0f67@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-14_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=673 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911140147
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019-11-14 16:25, David Hildenbrand wrote:
>
>> Am 14.11.2019 um 16:21 schrieb Pierre Morel <pmorel@linux.ibm.com>:
>>
>> ﻿
>>> On 2019-11-14 13:11, David Hildenbrand wrote:
>>>> On 14.11.19 12:57, Pierre Morel wrote:
>>>>
>>>> On 2019-11-14 11:28, David Hildenbrand wrote:
>>>>>> Am 14.11.2019 um 11:11 schrieb Pierre Morel <pmorel@linux.ibm.com>:
>>>>>>
>>>>>> ﻿
>>>>>>> On 2019-11-13 17:12, Janosch Frank wrote:
>>>>>>>> On 11/13/19 1:23 PM, Pierre Morel wrote:
>>>>>>>> If we use multiple source of interrupts, for exemple, using SCLP console
>>>>>>>> to print information while using I/O interrupts or during exceptions, we
>>>>>>>> need to have a re-entrant register saving interruption handling.
>>>>>>>>
>>>>>>>> Instead of saving at a static place, let's save the base registers on
>>>>>>>> the stack.
>>>>>>>>
>>>>>>>> Note that we keep the static register saving that we need for the RESET
>>>>>>>> tests.
>>>>>>>>
>>>>>>>> We also care to give the handlers a pointer to the save registers in
>>>>>>>> case the handler needs it (fixup_pgm_int needs the old psw address).
>>>>>>> So you're still ignoring the FPRs...
>>>>>>> I disassembled a test and looked at all stds and it looks like printf
>>>>>>> and related functions use them. Wouldn't we overwrite test FPRs if
>>>>>>> printing in a handler?
>>>>>> If printf uses the FPRs in my opinion we should modify the compilation options for the library.
>>>>>>
>>>>>> What is the reason for printf and related functions to use floating point?
>>>>>>
>>>>> Register spilling. This can and will be done.
>>>>
>>>> Hum, can you please clarify?
>>>>
>>>> AFAIK register spilling is for a compiler, to use memory if it has not
>>>> enough registers.
>>> Not strictly memory. If the compiler needs more GPRS, it can save/restore GPRS to FPRS.
>>>
>>> Any function the compiler generates is free to use the FPRS..
>>>
>>>> So your answer is for the my first sentence, meaning yes register
>>>> spilling will be done
>>>> or
>>>> do you mean register spilling is the reason why the compiler use FPRs
>>>> and it must be done so?
>>> Confused by both options :D The compiler might generate code that uses the FPRS although no floating point instructions are in use. That's why we have to enable the AFP control and properly take care of FPRS being used.
>>>
>>>
>> The compiler has the -msoft-float switch to avoid using the floating point instructions and registers, so it is our decision.
> No, not registers AFAIK.


sorry, exact, it must be used in conjunction with -ffloat-store


>
>> Saving the FP registers on exceptions is not very efficient, we loose time on each interrupt, not sure that we win it back by using FPregs to as Regs backup.
> Who on earth cares about performance here?

I only care about simplicity and compiler optimizations are not my friends.


>> Usually a system at low level uses some enter_fpu, leave_fpu routine to enter critical sections using FPU instead of losing time on each interruptions.
>>
>> We can think about this, in between I do as you recomand and save the FPregs too.
>>
>> Best regards,
>>
>> Pierre
>>
>>
>> -- 
>> Pierre Morel
>> IBM Lab Boeblingen
>>
-- 
Pierre Morel
IBM Lab Boeblingen

