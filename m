Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9C73421A0
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 17:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhCSQSg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 12:18:36 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50556 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229941AbhCSQS0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Mar 2021 12:18:26 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12JG4OTi142881
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 12:18:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=KTMJoghM57r+I/DwQMFo3m6m0jfmelzJWCG0mVJEkW0=;
 b=jy+Hjz2fHxICAR1SXzksxrwZ0kWW6edsjy2kQeMSWnotSsYXHMI8gfxhAlGFU82Gc9sL
 NG3gp8yglsC3S88ipgQJUQn+GCaaJeue7QbmHTupZLVs1Ox2u1p5Npo350O7Ii8QjP0x
 m/X+0xKd9xrJlrI35bi4ygiqDx6aIQJO1sgMMAds+4723TxFsVgfavKlLx6R6gYiyQGF
 DxqkdMBGgHGy5DJBoIME+ejrUMneiVOUMgL4hEP6vgUB6GRGgld5IihcVpSQRtT59pCW
 jFci2/vVMK/sTsLKuJbzibIPbOfYLHZ0y4pMmsGQRHxarUndmzSD3FRKxHB6dpBQMplW vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37bnren1ny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 12:18:26 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12JG4OAV142914
        for <kvm@vger.kernel.org>; Fri, 19 Mar 2021 12:18:26 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37bnren1me-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Mar 2021 12:18:25 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12JGHak4027585;
        Fri, 19 Mar 2021 16:18:22 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 378n18b4fk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Mar 2021 16:18:22 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12JGIJuo38797570
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 16:18:19 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4741DA4059;
        Fri, 19 Mar 2021 16:18:19 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 04B57A4040;
        Fri, 19 Mar 2021 16:18:18 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.3.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 19 Mar 2021 16:18:17 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v1 4/6] s390x: lib: css: add expectations
 to wait for interrupt
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com
References: <1616073988-10381-1-git-send-email-pmorel@linux.ibm.com>
 <1616073988-10381-5-git-send-email-pmorel@linux.ibm.com>
 <c9a38bd8-f091-d3e4-dea5-0ffd9f1cdf12@linux.ibm.com>
 <02a90318-2af5-d4eb-7329-425585bf51d3@linux.ibm.com>
 <20210319122351.407bdb65.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <b71b0238-e0c7-c3a0-13c5-f47cefe7f68d@linux.ibm.com>
Date:   Fri, 19 Mar 2021 17:18:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210319122351.407bdb65.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-19_06:2021-03-19,2021-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 phishscore=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103190111
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/19/21 12:23 PM, Cornelia Huck wrote:
> On Fri, 19 Mar 2021 10:50:09 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> On 3/19/21 10:09 AM, Janosch Frank wrote:
>>> On 3/18/21 2:26 PM, Pierre Morel wrote:
>>>> When waiting for an interrupt we may need to check the cause of
>>>> the interrupt depending on the test case.
>>>>
>>>> Let's provide the tests the possibility to check if the last valid
>>>> IRQ received is for the expected instruction.
>>>
>>> s/instruction/command/?
>>
>> Right, instruction may not be the optimal wording.
>> I/O architecture description have some strange (for me) wording, the
>> best is certainly to stick on this.
>>
>> Then I will use "the expected function" here.
>>
>>>
>>> We're checking for some value in an IO structure, right?
>>> Instruction makes me expect an actual processor instruction.
>>>
>>> Is there another word that can be used to describe what we're checking
>>> here? If yes please also add it to the "pending" variable. "pending_fc"
>>> or "pending_scsw_fc" for example.
>>
>> Pending is used to specify that the instruction has been accepted but
>> the according function is still pending, i.e. not finished and will stay
>> pending for a normal operation until the device active bit is set.
>>
>> So pending is not the right word, what we check here is the function
>> control, indicating the function the status refers too.
>>
>>>    
>>>>   
>> ...snip...
>>
>>>>     * Only report failures.
>>>>     */
>>>> -int wait_and_check_io_completion(int schid)
>>>> +int wait_and_check_io_completion(int schid, uint32_t pending)
>>
>>
>> Consequently I will change "pending" with "function_ctrl"
>>
>> Thanks for forcing clarification
>> I hope Connie will agree with this :)
> 
> I'm not quite sure yet :)
> 
> I/O wording and operation can be complicated... we basically have:
> 
> - various instructions: ssch, hsch, csch
> - invoking one of those instructions may initiate a function at the
>    subchannel
> - if an instruction lead to a function being initiated (but not
>    necessarily actually being performed!), the matching bit is set in
>    the fctl
> - the fctl bits are accumulative (e.g. if you do a hsch on a subchannel
>    where a start function is still in progress, you'll have both the
>    start and the halt function indicated) and only cleared after
>    collecting final status
> 
> So, setting the function is a direct consequence of executing an I/O
> instruction -- but the interrupt may not be directly related to *all*
> of the functions that are indicated (e.g. in the example above, where
> we may get an interrupt for the hsch, but none directly for the ssch;
> you can also add a csch on top of this; fortunately, we only stack in
> the start->halt->clear direction.)

For the real machine but QEMU serialize every I/O instruction so we 
never get 2 activities indicated at the same time.
That is something I tried to check with the last 2 patches.

> 
> Regarding wording:
> 
> Maybe
> 
> "if the last valid IRQ received is for the function expected
> after executing an instruction or sequence of instructions."
> 
> and
> 
> int wait_and_check_io_completion(int schid, uint32_t expected_fctl)
> 
> ?
> 

Yes better.

Thanks for the comments,

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
