Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60F3117501
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 11:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbfEHJWS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 05:22:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34032 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727197AbfEHJWS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 May 2019 05:22:18 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4898t5m044833
        for <kvm@vger.kernel.org>; Wed, 8 May 2019 05:22:16 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sburk24pm-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 08 May 2019 05:22:15 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Wed, 8 May 2019 10:22:12 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 8 May 2019 10:22:09 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x489M86l52560028
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 May 2019 09:22:08 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E142542047;
        Wed,  8 May 2019 09:22:07 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88A3042042;
        Wed,  8 May 2019 09:22:07 +0000 (GMT)
Received: from [9.145.42.10] (unknown [9.145.42.10])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 May 2019 09:22:07 +0000 (GMT)
Reply-To: pmorel@linux.ibm.com
Subject: Re: [PATCH 7/7] s390/cio: Remove vfio-ccw checks of command codes
To:     Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Farhan Ali <alifm@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20190503134912.39756-1-farman@linux.ibm.com>
 <20190503134912.39756-8-farman@linux.ibm.com>
 <8625f759-0a2d-09af-c8b5-5b312d854ba1@linux.ibm.com>
 <7c897993-d146-bf8e-48ad-11a914a04716@linux.ibm.com>
 <bba6c0a8-2346-cd99-b8ad-f316daac010b@linux.ibm.com>
 <7ac9fb43-8d7a-9e04-8cba-fa4c63dfc413@linux.ibm.com>
 <1f2e4272-8570-f93f-9d67-a43dcb00fc55@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Wed, 8 May 2019 11:22:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1f2e4272-8570-f93f-9d67-a43dcb00fc55@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19050809-0020-0000-0000-0000033A790B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050809-0021-0000-0000-0000218D1919
Message-Id: <5c2b74a9-e1d9-cd63-1284-6544fa4376d9@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-08_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905080059
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/05/2019 18:43, Eric Farman wrote:
> 
> 
> On 5/7/19 4:52 AM, Pierre Morel wrote:
>> On 06/05/2019 22:47, Eric Farman wrote:
>>>
>>>
>>> On 5/6/19 11:39 AM, Eric Farman wrote:
>>>>
>>>>
>>>> On 5/6/19 8:56 AM, Pierre Morel wrote:
>>>>> On 03/05/2019 15:49, Eric Farman wrote:
>>>>>> If the CCW being processed is a No-Operation, then by definition no
>>>>>> data is being transferred.  Let's fold those checks into the normal
>>>>>> CCW processors, rather than skipping out early.
>>>>>>
>>>>>> Likewise, if the CCW being processed is a "test" (an invented
>>>>>> definition to simply mean it ends in a zero), let's permit that to go
>>>>>> through to the hardware.  There's nothing inherently unique about
>>>>>> those command codes versus one that ends in an eight [1], or any 
>>>>>> other
>>>>>> otherwise valid command codes that are undefined for the device type
>>>>>> in question.
>>>>>>
>>>>>> [1] POPS states that a x08 is a TIC CCW, and that having any 
>>>>>> high-order
>>>>>> bits enabled is invalid for format-1 CCWs.  For format-0 CCWs, the
>>>>>> high-order bits are ignored.
>>>>>>
>>>>>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>>>>>> ---
>>>>>>   drivers/s390/cio/vfio_ccw_cp.c | 11 +++++------
>>>>>>   1 file changed, 5 insertions(+), 6 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/s390/cio/vfio_ccw_cp.c 
>>>>>> b/drivers/s390/cio/vfio_ccw_cp.c
>>>>>> index 36d76b821209..c0a52025bf06 100644
>>>>>> --- a/drivers/s390/cio/vfio_ccw_cp.c
>>>>>> +++ b/drivers/s390/cio/vfio_ccw_cp.c
>>>>>> @@ -289,8 +289,6 @@ static long copy_ccw_from_iova(struct 
>>>>>> channel_program *cp,
>>>>>>   #define ccw_is_read_backward(_ccw) (((_ccw)->cmd_code & 0x0F) == 
>>>>>> 0x0C)
>>>>>>   #define ccw_is_sense(_ccw) (((_ccw)->cmd_code & 0x0F) == 
>>>>>> CCW_CMD_BASIC_SENSE)
>>>>>> -#define ccw_is_test(_ccw) (((_ccw)->cmd_code & 0x0F) == 0)
>>>>>> -
>>>>>>   #define ccw_is_noop(_ccw) ((_ccw)->cmd_code == CCW_CMD_NOOP)
>>>>>>   #define ccw_is_tic(_ccw) ((_ccw)->cmd_code == CCW_CMD_TIC)
>>>>>> @@ -314,6 +312,10 @@ static inline int 
>>>>>> ccw_does_data_transfer(struct ccw1 *ccw)
>>>>>>       if (ccw->count == 0)
>>>>>>           return 0;
>>>>>> +    /* If the command is a NOP, then no data will be transferred */
>>>>>> +    if (ccw_is_noop(ccw))
>>>>>> +        return 0;
>>>>>> +
>>>>>>       /* If the skip flag is off, then data will be transferred */
>>>>>>       if (!ccw_is_skip(ccw))
>>>>>>           return 1;
>>>>>> @@ -398,7 +400,7 @@ static void ccwchain_cda_free(struct ccwchain 
>>>>>> *chain, int idx)
>>>>>>   {
>>>>>>       struct ccw1 *ccw = chain->ch_ccw + idx;
>>>>>> -    if (ccw_is_test(ccw) || ccw_is_noop(ccw) || ccw_is_tic(ccw))
>>>>>> +    if (ccw_is_tic(ccw))
>>>>>
>>>>>
>>>>> AFAIR, we introduced this code to protect against noop and test 
>>>>> with a non zero CDA.
>>>>> This could go away only if there is somewhere the guaranty that 
>>>>> noop have always a null CDA (same for test).
>>>>
>>>> What was generating either the null or "test" command codes?  I can 
>>>> provide plenty of examples for both these command codes and how they 
>>>> look coming out of vfio-ccw now.
>>>
>>> I've sent both x00 and x03 (NOP) CCWs with zero and non-zero CDAs to 
>>> hardware without this patch.  I don't see anything particuarly 
>>> surpising, so I'm not sure what the original code was attempting to 
>>> protect.
>>>
>>> Maybe, since you question this in ccwchain_cda_free(), you're 
>>> referring to commit 408358b50dea ("s390: vfio-ccw: Do not attempt to 
>>> free no-op, test and tic cda."), which fixed up our attempt to clean 
>>> things up that weren't allocated on the transmit side?  With this 
>>> series, that is reverted, but the cda is indeed set to something that 
>>> needs to be free'd (see below).  So maybe I should at least mention 
>>> that commit here.
>>>
>>> Regardless, while the I/Os work/fail as I expect, the cda addresses 
>>> themselves are wrong in much the same way I describe in patch 4.  
>>> Yes, without this patch we don't convert them to an IDAL so certain 
>>> program checks aren't applicable.  But the addresses that we end up 
>>> sending to the hardware are nonsensical, though potentially valid, 
>>> locations.
>>>
>>
>> I am not comfortable with this.
>> with NOOP no data transfer take place and the role of VFIO is to take 
>> care about data transfer.
>> So in my logic better do nothing and send the original CCW to the 
>> hardware.
>>
>>>>
>>>> The noop check is moved up into the "does data transfer" routine, to 
>>>> determine whether the pages should be pinned or not.  Regardless of 
>>>> whether or not the input CDA is null, we'll end up with a CCW 
>>>> pointing to a valid IDAL of invalid addresses.
>>>>
>>>> The "test" command codes always struck me as funky, because x18 and 
>>>> xF8 and everything in between that ends in x8 is architecturally 
>>>> invalid too, but we don't check for them like we do for things that 
>>>> end in x0. And there's a TON of other opcodes that are invalid for 
>>>> today's ECKD devices, or perhaps were valid for older DASD but have 
>>>> since been deprecated, or are only valid for non-DASD device types. 
>>>> We have no logic to permit them, either.  If those CCWs had a 
>>>> non-zero CDA, we either pin it successfully and let the targeted 
>>>> device sort it out or an error occurs and we fail at that point. 
>>>> (QEMU will see a "wirte" region error of -EINVAL because of 
>>>> vfio_pin_pages())
>>
>> The test command is AFAIU even more sensible that the NOOP command and 
>> in my opinion should never be modified since it is highly device 
>> dependent and do not induce data transfer anyway.
>>
>> We even do not know how the CDA field may be used by the device.
> 
> Exactly, which is why I think sending an unpinned, non-translated, guest 
> address to the hardware (which is what happens today) is a Bad Idea.  If 
> the associated command code WERE going to cause the channel to modify 
> any memory, the provided address from the guest would (best case) cause 
> a program check if the address were not available, or some data 
> corruption if it were.
> 
>> May be I am a little dramatic with this.
>> Just to say that I would feel more comfortable if the test command 
>> reach the device unchanged.
>>
> 
> As I say above, I disagree.  I'd rather that the command (test or 
> otherwise) hit the channel (and the device if applicable) with a valid 
> host address in ccw.cda, so that if any data transfer occurs we're not 
> exposed.
> 
> If there's an application that wants to send a test CCW with an invalid 
> CDA (and thus would fail the pin, as I have seen with NOP), then I guess 
> I can add ccw_is_test() to ccw_does_data_transfer(), but since I still 
> don't see the use case for test CCWs I'm not as thrilled about it.
> 
> Do you recall what caused them to be added originally?



AFAIK they have bin added because they are standard CCW commands.


For the NOOP its clearly stated that it does not start a data transfer.
If we pin the CDA, it could then eventually be the cause of errors if 
the address indicated by the CDA is not accessible.

The NOOP is a particular CONTROL operation for which no data is transfered.
Other CONTROL operation may start a data transfer.

The TEST command is used to retrieve the status of the I/O-device 
__path__ and do not go up to the device.
I did not find clearly that it does not start a data transfer but I 
really do not think it does.
May be we should ask people from hardware.
I only found that test I/O (a specific test command) do not initiate an 
operation.

Regards,
Pierre

-- 
Pierre Morel
Linux/KVM/QEMU in Böblingen - Germany

