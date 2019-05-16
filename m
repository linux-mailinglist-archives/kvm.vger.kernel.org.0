Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D50820B11
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 17:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbfEPPYt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 May 2019 11:24:49 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42236 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726692AbfEPPYt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 May 2019 11:24:49 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4GFDhCr081335
        for <kvm@vger.kernel.org>; Thu, 16 May 2019 11:24:47 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sha8b8s71-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 16 May 2019 11:24:47 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Thu, 16 May 2019 16:24:45 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 16 May 2019 16:24:42 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4GFOfDv44236992
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 May 2019 15:24:41 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F304F42049;
        Thu, 16 May 2019 15:24:40 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A6544203F;
        Thu, 16 May 2019 15:24:40 +0000 (GMT)
Received: from [9.152.222.58] (unknown [9.152.222.58])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 16 May 2019 15:24:40 +0000 (GMT)
Reply-To: pmorel@linux.ibm.com
Subject: Re: [PATCH 08/10] virtio/s390: add indirection to indicators access
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sebastian Ott <sebott@linux.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
References: <20190426183245.37939-1-pasic@linux.ibm.com>
 <20190426183245.37939-9-pasic@linux.ibm.com>
 <716d47ca-016f-e8f4-6d78-7746a7d9f6ba@linux.ibm.com>
 <a4bf1976-8037-63bb-2cf6-c389edbd2e89@linux.ibm.com>
 <20190509202600.4fd6aebe.pasic@linux.ibm.com>
 <c1e03cf0-3773-de00-10ae-d092ffe7ccc5@linux.ibm.com>
 <20190510135421.5363f14a.pasic@linux.ibm.com>
 <89074bc5-78ee-a2e3-0546-791a465f83bd@linux.ibm.com>
 <20190513121502.34d3dc62.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Thu, 16 May 2019 17:24:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190513121502.34d3dc62.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19051615-0020-0000-0000-0000033D631B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051615-0021-0000-0000-000021902B7B
Message-Id: <2736e862-69e5-7923-b429-aee0dcdd2c5a@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-16_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905160097
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/05/2019 12:15, Cornelia Huck wrote:
> On Fri, 10 May 2019 17:36:05 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> On 10/05/2019 13:54, Halil Pasic wrote:
>>> On Fri, 10 May 2019 09:43:08 +0200
>>> Pierre Morel <pmorel@linux.ibm.com> wrote:
>>>    
>>>> On 09/05/2019 20:26, Halil Pasic wrote:
>>>>> On Thu, 9 May 2019 14:01:01 +0200
>>>>> Pierre Morel <pmorel@linux.ibm.com> wrote:
>>>>>   
>>>>>> On 08/05/2019 16:31, Pierre Morel wrote:
>>>>>>> On 26/04/2019 20:32, Halil Pasic wrote:
>>>>>>>> This will come in handy soon when we pull out the indicators from
>>>>>>>> virtio_ccw_device to a memory area that is shared with the hypervisor
>>>>>>>> (in particular for protected virtualization guests).
>>>>>>>>
>>>>>>>> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
>>>>>>>> ---
>>>>>>>>      drivers/s390/virtio/virtio_ccw.c | 40
>>>>>>>> +++++++++++++++++++++++++---------------
>>>>>>>>      1 file changed, 25 insertions(+), 15 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/drivers/s390/virtio/virtio_ccw.c
>>>>>>>> b/drivers/s390/virtio/virtio_ccw.c
>>>>>>>> index bb7a92316fc8..1f3e7d56924f 100644
>>>>>>>> --- a/drivers/s390/virtio/virtio_ccw.c
>>>>>>>> +++ b/drivers/s390/virtio/virtio_ccw.c
>>>>>>>> @@ -68,6 +68,16 @@ struct virtio_ccw_device {
>>>>>>>>          void *airq_info;
>>>>>>>>      };
>>>>>>>> +static inline unsigned long *indicators(struct virtio_ccw_device *vcdev)
>>>>>>>> +{
>>>>>>>> +    return &vcdev->indicators;
>>>>>>>> +}
>>>>>>>> +
>>>>>>>> +static inline unsigned long *indicators2(struct virtio_ccw_device
>>>>>>>> *vcdev)
>>>>>>>> +{
>>>>>>>> +    return &vcdev->indicators2;
>>>>>>>> +}
>>>>>>>> +
>>>>>>>>      struct vq_info_block_legacy {
>>>>>>>>          __u64 queue;
>>>>>>>>          __u32 align;
>>>>>>>> @@ -337,17 +347,17 @@ static void virtio_ccw_drop_indicator(struct
>>>>>>>> virtio_ccw_device *vcdev,
>>>>>>>>              ccw->cda = (__u32)(unsigned long) thinint_area;
>>>>>>>>          } else {
>>>>>>>>              /* payload is the address of the indicators */
>>>>>>>> -        indicatorp = kmalloc(sizeof(&vcdev->indicators),
>>>>>>>> +        indicatorp = kmalloc(sizeof(indicators(vcdev)),
>>>>>>>>                           GFP_DMA | GFP_KERNEL);
>>>>>>>>              if (!indicatorp)
>>>>>>>>                  return;
>>>>>>>>              *indicatorp = 0;
>>>>>>>>              ccw->cmd_code = CCW_CMD_SET_IND;
>>>>>>>> -        ccw->count = sizeof(&vcdev->indicators);
>>>>>>>> +        ccw->count = sizeof(indicators(vcdev));
>>>>>>>
>>>>>>> This looks strange to me. Was already weird before.
>>>>>>> Lucky we are indicators are long...
>>>>>>> may be just sizeof(long)
>>>>>>   
>>>>>
>>>>> I'm not sure I understand where are you coming from...
>>>>>
>>>>> With CCW_CMD_SET_IND we tell the hypervisor the guest physical address
>>>>> at which the so called classic indicators. There is a comment that
>>>>> makes this obvious. The argument of the sizeof was and remained a
>>>>> pointer type. AFAIU this is what bothers you.
>>>>>>
>>>>>> AFAIK the size of the indicators (AIV/AIS) is not restricted by the
>>>>>> architecture.
>>>>>
>>>>> The size of vcdev->indicators is restricted or defined by the virtio
>>>>> specification. Please have a look at '4.3.2.6.1 Setting Up Classic Queue
>>>>> Indicators' here:
>>>>> https://docs.oasis-open.org/virtio/virtio/v1.1/cs01/virtio-v1.1-cs01.html#x1-1630002
>>>>>
>>>>> Since with Linux on s390 only 64 bit is supported, both the sizes are in
>>>>> line with the specification. Using u64 would semantically match the spec
>>>>> better, modulo pre virtio 1.0 which ain't specified. I did not want to
>>>>> do changes that are not necessary for what I'm trying to accomplish. If
>>>>> we want we can change these to u64 with a patch on top.
>>>>
>>>> I mean you are changing these line already, so why not doing it right
>>>> while at it?
>>>>   
>>>
>>> This patch is about adding the indirection so we can move the member
>>> painlessly. Mixing in different stuff would be a bad practice.
>>>
>>> BTW I just explained that it ain't wrong, so I really do not understand
>>> what do you mean by  'why not doing it right'. Can you please explain?
>>>    
>>
>> I did not wanted to discuss a long time on this and gave my R-B, so
>> meaning that I am OK with this patch.
>>
>> But if you ask, yes I can, it seems quite obvious.
>> When you build a CCW you give the pointer to CCW->cda and you give the
>> size of the transfer in CCW->count.
>>
>> Here the count is initialized with the sizeof of the pointer used to
>> initialize CCW->cda with.
> 
> But the cda points to the pointer address, so the size of the pointer
> is actually the correct value here, isn't it?

Oh. Yes, it is correct.
What I do not like are the mixing of (unsigned long), (unsigned long *) 
and &
if we had
cda = _u32 (unsigned long) indicatorp
count = sizeof(*indicatorp)

I would have been completely happy.

It was just a non important thing and I wouldn't have given a R-B if the 
functionality was not correct.


> 
>> Lukily we work on a 64 bits machine with 64 bits pointers and the size
>> of the pointed object is 64 bits wide so... the resulting count is right.
>> But it is not the correct way to do it.
> 
> I think it is, but this interface really is confusing.

Yes, it is what I thought we could do better.

> 
>> That is all. Not a big concern, you do not need to change it, as you
>> said it can be done in another patch.
>>
>>> Did you agree with the rest of my comment? I mean there was more to it.
>>>    
>>
>> I understood from your comments that the indicators in Linux are 64bits
>> wide so all OK.
>>
>> Regards
>> Pierre
>>
>>
>>
>>
>>
>>
> 


-- 
Pierre Morel
Linux/KVM/QEMU in Böblingen - Germany

