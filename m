Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB75811D421
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 18:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730110AbfLLRfP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 12:35:15 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24544 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730088AbfLLRfP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Dec 2019 12:35:15 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBCHYju9053844
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2019 12:35:14 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2wu4t7edqq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2019 12:35:08 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Thu, 12 Dec 2019 17:33:19 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 12 Dec 2019 17:33:16 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBCHXF3S45285574
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Dec 2019 17:33:15 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E9ECA4054;
        Thu, 12 Dec 2019 17:33:15 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36727A405B;
        Thu, 12 Dec 2019 17:33:15 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.152.222.89])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 Dec 2019 17:33:15 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v4 7/9] s390x: css: msch, enable test
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
References: <1576079170-7244-1-git-send-email-pmorel@linux.ibm.com>
 <1576079170-7244-8-git-send-email-pmorel@linux.ibm.com>
 <20191212130111.0f75fe7f.cohuck@redhat.com>
 <83d45c31-30c3-36e1-1d68-51b88448f4af@linux.ibm.com>
 <20191212151002.1c7ca4eb.cohuck@redhat.com>
 <c92089cf-39f4-3b64-79a8-3264654130b1@linux.ibm.com>
 <20191212153303.6444697e.cohuck@redhat.com>
 <a29048f4-1783-54c6-8bf3-91d573b2d49d@linux.ibm.com>
Date:   Thu, 12 Dec 2019 18:33:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <a29048f4-1783-54c6-8bf3-91d573b2d49d@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19121217-4275-0000-0000-0000038E56E3
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19121217-4276-0000-0000-000038A211D3
Message-Id: <d34fdb07-c2ff-3a1e-eb31-cf9d160ebac9@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-12_05:2019-12-12,2019-12-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 impostorscore=0 spamscore=0 clxscore=1015 suspectscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912120137
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019-12-12 17:05, Pierre Morel wrote:
> 
> 
> On 2019-12-12 15:33, Cornelia Huck wrote:
>> On Thu, 12 Dec 2019 15:21:21 +0100
>> Pierre Morel <pmorel@linux.ibm.com> wrote:
>>
>>> On 2019-12-12 15:10, Cornelia Huck wrote:
>>>> On Thu, 12 Dec 2019 15:01:07 +0100
>>>> Pierre Morel <pmorel@linux.ibm.com> wrote:
>>>>> On 2019-12-12 13:01, Cornelia Huck wrote:
>>>>>> On Wed, 11 Dec 2019 16:46:08 +0100
>>>>>> Pierre Morel <pmorel@linux.ibm.com> wrote:
>>>>>>> A second step when testing the channel subsystem is to prepare a 
>>>>>>> channel
>>>>>>> for use.
>>>>>>> This includes:
>>>>>>> - Get the current SubCHannel Information Block (SCHIB) using STSCH
>>>>>>> - Update it in memory to set the ENABLE bit
>>>>>>> - Tell the CSS that the SCHIB has been modified using MSCH
>>>>>>> - Get the SCHIB from the CSS again to verify that the subchannel is
>>>>>>>      enabled.
>>>>>>>
>>>>>>> This tests the success of the MSCH instruction by enabling a 
>>>>>>> channel.
>>>>>>>
>>>>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>>>>> ---
>>>>>>>     s390x/css.c | 65 
>>>>>>> +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>>>>     1 file changed, 65 insertions(+)
>>>>>>> +    /* Read the SCHIB for this subchannel */
>>>>>>> +    cc = stsch(test_device_sid, &schib);
>>>>>>> +    if (cc) {
>>>>>>> +        report(0, "stsch cc=%d", cc);
>>>>>>> +        return;
>>>>>>> +    }
>>>>>>> +
>>>>>>> +    /* Update the SCHIB to enable the channel */
>>>>>>> +    pmcw->flags |= PMCW_ENABLE;
>>>>>>> +
>>>>>>> +    /* Tell the CSS we want to modify the subchannel */
>>>>>>> +    cc = msch(test_device_sid, &schib);
>>>>>>> +    if (cc) {
>>>>>>> +        /*
>>>>>>> +         * If the subchannel is status pending or
>>>>>>> +         * if a function is in progress,
>>>>>>> +         * we consider both cases as errors.
>>>>>>> +         */
>>>>>>> +        report(0, "msch cc=%d", cc);
>>>>>>> +        return;
>>>>>>> +    }
>>>>>>> +
>>>>>>> +    /*
>>>>>>> +     * Read the SCHIB again to verify the enablement
>>>>>>> +     * insert a little delay and try 5 times.
>>>>>>> +     */
>>>>>>> +    do {
>>>>>>> +        cc = stsch(test_device_sid, &schib);
>>>>>>> +        if (cc) {
>>>>>>> +            report(0, "stsch cc=%d", cc);
>>>>>>> +            return;
>>>>>>> +        }
>>>>>>> +        delay(10);
>>>>>>
>>>>>> That's just a short delay to avoid a busy loop, right? msch should be
>>>>>> immediate,
>>>>>
>>>>> Thought you told to me that it may not be immediate in zVM did I
>>>>> misunderstand?
>>>>
>>>> Maybe I have been confusing... what I'm referring to is this
>>>> programming note for msch:
>>>>
>>>> "It is recommended that the program inspect the
>>>> contents of the subchannel by subsequently
>>>> issuing STORE SUBCHANNEL when MODIFY
>>>> SUBCHANNEL sets condition code 0. Use of
>>>> STORE SUBCHANNEL is a method for deter-
>>>> mining if the designated subchannel was
>>>> changed or not. Failure to inspect the subchan-
>>>> nel following the setting of condition code 0 by
>>>> MODIFY SUBCHANNEL may result in conditions
>>>> that the program does not expect to occur."
>>>>
>>>> That's exactly what we had to do under z/VM back then: do the msch,
>>>> check via stsch, redo the msch if needed, check again via stsch. It
>>>> usually worked with the second msch the latest.
>>>
>>> OK, I understand, then it is a bug in zVM that this test could 
>>> enlighten.
>>
>> Probably more a quirk than a bug... the explanation there is not
>> explicit about that :)
>>
>>>
>>> I think we should keep it so, it allows to recognize 3 cases (after I
>>> change to test ENABLE in the loop as I said I will):
>>> - immediate ENABLE
>>
>> This is the good case.
>>
>>> - asynchrone ENABLE
>>
>> This one I would consider an architecture violation.
>>
>>> - failure to ENABLE
>>
>> This is the quirk above.
>>
>> But I'm not quite sure how you would be able to distinguish the last
>> two cases?
> 
> This is where the delay can help.
> But yes, not sure that we can differentiate this without to know how 
> long we should delay.
> 
> 
>>
>>>>>> and you probably should not delay on success?
>>>>>
>>>>> yes, it is not optimized, I can test PMCW_ENABLE in the loop this 
>>>>> way we
>>>>> can see if, in the zVM case we need to do retries or not.
>>>>>
>>>>>>> +    } while (!(pmcw->flags & PMCW_ENABLE) && count++ < 5);
>>>>>>
>>>>>> How is this supposed to work? Doesn't the stsch overwrite the control
>>>>>> block again, so you need to re-set the enable bit before you retry?
>>>>>
>>>>> I do not think so, there is no msch() in the loop.
>>>>> Do I miss something?
>>>>
>>>> Well, _I_ missed that the msch() was missing :) You need it (see 
>>>> above);
>>>> just waiting and re-doing the stsch is useless, as msch is a
>>>> synchronous instruction which has finished its processing after the cc
>>>> has been set.
>>>
>>> Since kvm-unit-test is a test system, not an OS so I think that here we
>>> have one more point to leverage the enable function:
>>> - We need to test the enable (what I did (partially))
>>
>> Maybe also log if you needed to retry? Not as an error, but as
>> additional information?
> 
> Yes.
> 
> Regards,
> Pierre
> 

After all, I make it simple by testing if the MSCH works as expected, no 
retry, no delay.
This is just a test.

I will add a new patch to add a library function to enable the channel, 
with retry to serve when we really need to enable the channel, not to test.

Regards,
Pierre



-- 
Pierre Morel
IBM Lab Boeblingen

