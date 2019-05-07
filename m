Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCD1A15F6C
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 10:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbfEGIdC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 04:33:02 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48916 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726313AbfEGIdC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 May 2019 04:33:02 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x478RkPf075064
        for <kvm@vger.kernel.org>; Tue, 7 May 2019 04:33:00 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sb4t4n3t2-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 07 May 2019 04:32:59 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Tue, 7 May 2019 09:32:58 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 7 May 2019 09:32:55 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x478Wr1953674192
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 May 2019 08:32:53 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF6B7A4068;
        Tue,  7 May 2019 08:32:53 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6DB32A4065;
        Tue,  7 May 2019 08:32:53 +0000 (GMT)
Received: from [9.152.222.136] (unknown [9.152.222.136])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  7 May 2019 08:32:53 +0000 (GMT)
Reply-To: pmorel@linux.ibm.com
Subject: Re: [PATCH 2/7] s390/cio: Set vfio-ccw FSM state before ioeventfd
To:     Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20190503134912.39756-1-farman@linux.ibm.com>
 <20190503134912.39756-3-farman@linux.ibm.com>
 <20190506165158.5da82576.cohuck@redhat.com>
 <39a1efa5-5298-97b9-21fa-e9ed70a2b892@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Tue, 7 May 2019 10:32:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <39a1efa5-5298-97b9-21fa-e9ed70a2b892@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19050708-0012-0000-0000-000003191766
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050708-0013-0000-0000-00002151936F
Message-Id: <c9b55b66-59b4-639c-aad6-764346d6f4de@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-07_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905070056
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/05/2019 18:36, Eric Farman wrote:
> 
> 
> On 5/6/19 10:51 AM, Cornelia Huck wrote:
>> On Fri,  3 May 2019 15:49:07 +0200
>> Eric Farman <farman@linux.ibm.com> wrote:
>>
>>> Otherwise, the guest can believe it's okay to start another I/O
>>> and bump into the non-idle state.  This results in a cc=3
>>> (or cc=2 with the pending async CSCH/HSCH code [1]) to the guest,
>>
>> I think you can now refer to cc=2, as the csch/hsch is on its way in :)
> 
> Woohoo!  :)
> 
>>
>>> which is unfortunate since everything is otherwise working normally.
>>>
>>> [1] https://patchwork.kernel.org/comment/22588563/
>>>
>>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>>>
>>> ---
>>>
>>> I think this might've been part of Pierre's FSM cleanup?
>>
>> Not sure if I saw this before, but there have been quite a number of
>> patches going around...
> 
> I guess I should have said his original cleanup from last year.  I 
> didn't find it, but it also seems familiar to me.

May be, I am not sure, but does not mater.
It looks good to me to change the state before to send the IRQ signal to 
the guest, just in case we get asynchronism sometime.

> 
>>
>>> ---
>>>   drivers/s390/cio/vfio_ccw_drv.c | 6 +++---
>>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/s390/cio/vfio_ccw_drv.c 
>>> b/drivers/s390/cio/vfio_ccw_drv.c
>>> index 0b3b9de45c60..ddd21b6149fd 100644
>>> --- a/drivers/s390/cio/vfio_ccw_drv.c
>>> +++ b/drivers/s390/cio/vfio_ccw_drv.c
>>> @@ -86,11 +86,11 @@ static void vfio_ccw_sch_io_todo(struct 
>>> work_struct *work)
>>>       }
>>>       memcpy(private->io_region->irb_area, irb, sizeof(*irb));
>>> -    if (private->io_trigger)
>>> -        eventfd_signal(private->io_trigger, 1);
>>> -
>>>       if (private->mdev && is_final)
>>>           private->state = VFIO_CCW_STATE_IDLE;
>>> +
>>> +    if (private->io_trigger)
>>> +        eventfd_signal(private->io_trigger, 1);
>>>   }
>>>   /*
>>

Reviewed-by: Pierre Morel<pmorel@linux.ibm.com>



-- 
Pierre Morel
Linux/KVM/QEMU in Böblingen - Germany

