Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD3A034CE67
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 13:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbhC2LC3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 07:02:29 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55964 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231569AbhC2LCA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Mar 2021 07:02:00 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12TAZ9Pu029306
        for <kvm@vger.kernel.org>; Mon, 29 Mar 2021 07:02:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=QIOYodHaGoE+9qiwCKbDGjIXRTtXY0Mkri/DksBA6zE=;
 b=iLYvLRpVptIXBoxyaaE/UW7gIHjp9b/PbKAJyjEA1y9ehOUiCnEUvo3dnUZtW/f6khKk
 HfJwI7D+BCL/kHUqH5627XjMQgTNAKEeIG5XVFFBkyi2oP0Fk9yAZnYOv8VM6thSWN73
 4WWeJt0qhVX1cEaDeONilngh2B3YlGnkmR0imnxNuNJ9a7vpxST5towsH9DaTSmFgHUg
 QnDpwD46s2b4yVmZrKAt8KoRBKA6jYYbUvAGyuFiO9X9ma7mh3brg5Mvd9J8QWFPtxB4
 04X0OsKkbN7WBRwEmUcdPk8vXNx8yvQ9qd3werqx3VQJIBRG1db/ITrzFGm5tUFabo6b yA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37jpbv7wcg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 29 Mar 2021 07:01:59 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12TAZO2s030604
        for <kvm@vger.kernel.org>; Mon, 29 Mar 2021 07:01:59 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37jpbv7wbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 07:01:59 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12TB1vbN007709;
        Mon, 29 Mar 2021 11:01:57 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 37huyh9r1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 11:01:57 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12TB1ZEg14942624
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Mar 2021 11:01:35 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C51A542041;
        Mon, 29 Mar 2021 11:01:54 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 53A3D42045;
        Mon, 29 Mar 2021 11:01:54 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.39.64])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 29 Mar 2021 11:01:54 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 5/8] s390x: lib: css: add SCSW ctrl
 expectations to check I/O completion
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
 <1616665147-32084-6-git-send-email-pmorel@linux.ibm.com>
 <b1ccfed0-5a1c-323d-2176-39513fbde391@redhat.com>
 <036a0962-e46c-7105-3f2a-d61c26e53226@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <a2a22a6c-728b-cc0f-383d-9f9db8839195@linux.ibm.com>
Date:   Mon, 29 Mar 2021 13:01:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <036a0962-e46c-7105-3f2a-d61c26e53226@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CRgLIrXT6TqZVuNE5hE99DufQvBl0_PR
X-Proofpoint-ORIG-GUID: TbnSWbR_sRloOx_USGJ38AzPLG01chRN
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-29_05:2021-03-26,2021-03-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 suspectscore=0 priorityscore=1501 malwarescore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103290082
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/29/21 10:32 AM, Thomas Huth wrote:
> On 29/03/2021 10.27, Thomas Huth wrote:
>> On 25/03/2021 10.39, Pierre Morel wrote:
>>> When checking for an I/O completion may need to check the cause of
>>> the interrupt depending on the test case.
>>>
>>> Let's provide the tests the possibility to check if the last
>>> valid IRQ received is for the function expected after executing
>>> an instruction or sequence of instructions and if all ctrl flags
>>> of the SCSW are set as expected.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>>>   lib/s390x/css.h     |  4 ++--
>>>   lib/s390x/css_lib.c | 21 ++++++++++++++++-----
>>>   s390x/css.c         |  4 ++--
>>>   3 files changed, 20 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
>>> index 5d1e1f0..1603781 100644
>>> --- a/lib/s390x/css.h
>>> +++ b/lib/s390x/css.h
>>> @@ -316,8 +316,8 @@ void css_irq_io(void);
>>>   int css_residual_count(unsigned int schid);
>>>   void enable_io_isc(uint8_t isc);
>>> -int wait_and_check_io_completion(int schid);
>>> -int check_io_completion(int schid);
>>> +int wait_and_check_io_completion(int schid, uint32_t ctrl);
>>> +int check_io_completion(int schid, uint32_t ctrl);
>>>   /*
>>>    * CHSC definitions
>>> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
>>> index 1e5c409..55e70e6 100644
>>> --- a/lib/s390x/css_lib.c
>>> +++ b/lib/s390x/css_lib.c
>>> @@ -488,21 +488,25 @@ struct ccw1 *ccw_alloc(int code, void *data, 
>>> int count, unsigned char flags)
>>>   /* wait_and_check_io_completion:
>>>    * @schid: the subchannel ID
>>> + * @ctrl : expected SCSW control flags
>>>    */
>>> -int wait_and_check_io_completion(int schid)
>>> +int wait_and_check_io_completion(int schid, uint32_t ctrl)
>>>   {
>>>       wait_for_interrupt(PSW_MASK_IO);
>>> -    return check_io_completion(schid);
>>> +    return check_io_completion(schid, ctrl);
>>>   }
>>>   /* check_io_completion:
>>>    * @schid: the subchannel ID
>>> + * @ctrl : expected SCSW control flags
>>>    *
>>> - * Makes the most common check to validate a successful I/O
>>> - * completion.
>>> + * If the ctrl parameter is not null check the IRB SCSW ctrl
>>> + * against the ctrl parameter.
>>> + * Otherwise, makes the most common check to validate a successful
>>> + * I/O completion.
>>>    * Only report failures.
>>>    */
>>> -int check_io_completion(int schid)
>>> +int check_io_completion(int schid, uint32_t ctrl)
>>>   {
>>>       int ret = 0;
>>> @@ -515,6 +519,13 @@ int check_io_completion(int schid)
>>>           goto end;
>>>       }
>>> +    if (ctrl && (ctrl ^ irb.scsw.ctrl)) {
>>
>> With the xor, you can only check for enabled bits ... do we also want 
>> to check for disabled bits, or is this always out of scope?
> 
> Never mind, I think I just did not have enough coffee yet, the check 
> should be fine. But couldn't you simply use "!=" instead of "^" here?
> 
>   Thomas
> 


OK, yes I can


-- 
Pierre Morel
IBM Lab Boeblingen
