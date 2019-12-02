Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 570DC10ED90
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 17:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbfLBQ4G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 11:56:06 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49082 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727438AbfLBQ4F (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Dec 2019 11:56:05 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB2GmF94092109
        for <kvm@vger.kernel.org>; Mon, 2 Dec 2019 11:56:04 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wkm46sdgv-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 02 Dec 2019 11:56:03 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Mon, 2 Dec 2019 16:56:01 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 2 Dec 2019 16:55:58 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xB2GtvtK50135066
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 Dec 2019 16:55:57 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D8D0A4051;
        Mon,  2 Dec 2019 16:55:57 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 236FBA405B;
        Mon,  2 Dec 2019 16:55:57 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.75])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  2 Dec 2019 16:55:57 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 3/9] s390x: irq: make IRQ handler weak
To:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        cohuck@redhat.com
References: <1574945167-29677-1-git-send-email-pmorel@linux.ibm.com>
 <1574945167-29677-4-git-send-email-pmorel@linux.ibm.com>
 <33be2bbd-ea3b-4a93-3ce3-9dee36a531d1@redhat.com>
 <1fdc2864-ce65-1af1-272b-0769d903dd3f@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Mon, 2 Dec 2019 17:55:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <1fdc2864-ce65-1af1-272b-0769d903dd3f@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19120216-0016-0000-0000-000002CFCE31
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19120216-0017-0000-0000-00003331C3AC
Message-Id: <a7968159-f161-93d5-6b24-3c484a331d68@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-02_03:2019-11-29,2019-12-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 clxscore=1015
 impostorscore=0 adultscore=0 suspectscore=0 mlxlogscore=898 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912020144
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019-12-02 11:41, Thomas Huth wrote:
> On 29/11/2019 13.01, David Hildenbrand wrote:
>> On 28.11.19 13:46, Pierre Morel wrote:
>>> Having a weak function allows the tests programm to declare its own
>>> IRQ handler.
>>> This is helpfull for I/O tests to have the I/O IRQ handler having
>>> its special work to do.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> Reviewed-by: Thomas Huth <thuth@redhat.com>
>>> ---
>>>   lib/s390x/interrupt.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
>>> index 3e07867..d70fde3 100644
>>> --- a/lib/s390x/interrupt.c
>>> +++ b/lib/s390x/interrupt.c
>>> @@ -140,7 +140,7 @@ void handle_mcck_int(void)
>>>   		     lc->mcck_old_psw.addr);
>>>   }
>>>   
>>> -void handle_io_int(void)
>>> +__attribute__((weak)) void handle_io_int(void)
>>>   {
>>>   	report_abort("Unexpected io interrupt: at %#lx",
>>>   		     lc->io_old_psw.addr);
>>>
>>
>> The clear alternative would be a way to register a callback function.
>> That way you can modify the callback during the tests. As long as not
>> registered, wrong I/Os can be caught easily here. @Thomas?
> 
> I don't mind too much, but I think I'd also slightly prefer a registered
> callback function here instead.
> 
>   Thomas
> 

As you like but I wonder why you prefer the complicated solution.
The kvm-unit-test is single task, if a test really need something 
complicated it can be done in the test not in the common code.

Anyway I do like you want.

-- 
Pierre Morel
IBM Lab Boeblingen

