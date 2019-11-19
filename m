Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A869F102C2E
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 19:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbfKSS7B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 13:59:01 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30408 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726939AbfKSS7A (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Nov 2019 13:59:00 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAJIluQi042859;
        Tue, 19 Nov 2019 13:58:59 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wact79j66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Nov 2019 13:58:58 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id xAJImDEB043578;
        Tue, 19 Nov 2019 13:58:57 -0500
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wact79j5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Nov 2019 13:58:57 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xAJIqMiA016039;
        Tue, 19 Nov 2019 18:58:57 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma03wdc.us.ibm.com with ESMTP id 2wa8r6dtxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Nov 2019 18:58:57 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAJIwuF914484252
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 18:58:56 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E7C2B2064;
        Tue, 19 Nov 2019 18:58:56 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60A04B2065;
        Tue, 19 Nov 2019 18:58:56 +0000 (GMT)
Received: from [9.80.210.113] (unknown [9.80.210.113])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 19 Nov 2019 18:58:56 +0000 (GMT)
Subject: Re: [RFC PATCH v1 03/10] vfio-ccw: Use subchannel lpm in the orb
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>
References: <20191115025620.19593-1-farman@linux.ibm.com>
 <20191115025620.19593-4-farman@linux.ibm.com>
 <20191119140046.4b81edd8.cohuck@redhat.com>
 <fa7f22e1-df44-4ad2-871a-23cd4feebc5e@linux.ibm.com>
 <20191119163846.18df1f69.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <a4af0337-3922-708f-a6f4-4a2e4af352e1@linux.ibm.com>
Date:   Tue, 19 Nov 2019 13:58:56 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191119163846.18df1f69.cohuck@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-19_06:2019-11-15,2019-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=712 suspectscore=0
 adultscore=0 mlxscore=0 bulkscore=0 clxscore=1015 spamscore=0
 malwarescore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1911190157
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/19/19 10:38 AM, Cornelia Huck wrote:
> On Tue, 19 Nov 2019 10:16:30 -0500
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> On 11/19/19 8:00 AM, Cornelia Huck wrote:
>>> On Fri, 15 Nov 2019 03:56:13 +0100
>>> Eric Farman <farman@linux.ibm.com> wrote:
>>>   
>>>> From: Farhan Ali <alifm@linux.ibm.com>
>>>>
>>>> The subchannel logical path mask (lpm) would have the most
>>>> up to date information of channel paths that are logically
>>>> available for the subchannel.
>>>>
>>>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
>>>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>>>> ---
>>>>
>>>> Notes:
>>>>     v0->v1: [EF]
>>>>      - None; however I am greatly confused by this one.  Thoughts?  
>>>
>>> I think it's actually wrong.
>>>   
>>>>
>>>>  drivers/s390/cio/vfio_ccw_cp.c | 4 +---
>>>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
>>>> index 3645d1720c4b..d4a86fb9d162 100644
>>>> --- a/drivers/s390/cio/vfio_ccw_cp.c
>>>> +++ b/drivers/s390/cio/vfio_ccw_cp.c
>>>> @@ -779,9 +779,7 @@ union orb *cp_get_orb(struct channel_program *cp, u32 intparm, u8 lpm)
>>>>  	orb->cmd.intparm = intparm;
>>>>  	orb->cmd.fmt = 1;
>>>>  	orb->cmd.key = PAGE_DEFAULT_KEY >> 4;
>>>> -
>>>> -	if (orb->cmd.lpm == 0)
>>>> -		orb->cmd.lpm = lpm;  
>>>
>>> In the end, the old code will use the lpm from the subchannel
>>> structure, if userspace did not supply anything to be used.
>>>   
>>>> +	orb->cmd.lpm = lpm;  
>>>
>>> The new code will always discard any lpm userspace has supplied and
>>> replace it with the lpm from the subchannel structure. This feels
>>> wrong; what if the I/O is supposed to be restricted to a subset of the
>>> paths?  
>>
>> I had the same opinion, but didn't want to flat-out discard it from his
>> series without a second look.  :)
> 
> :)
> 
>>
>>>
>>> If we want to include the current value of the subchannel lpm in the
>>> requests, we probably want to AND the masks instead.  
>>
>> Then we'd be on the hook to return some sort of error if the result is
>> zero.  Is it better to just send it to hw as-is, and let the response
>> come back naturally?  (Which is what we do today.)
> 
> But if a chpid is logically varied off, it is removed from the lpm,
> right? Therefore, the caller really should get a 'no path' indication
> back, shouldn't it?

Agreed, just don't know whether we should be kicking it out here, versus
just doing what we do today and sending the guest LPM to the hardware.

The routine being modified here is cp_get_orb(), which doesn't seem like
the right place for such a check.  It does currently return NULL when
the cp is not initialized, claiming an error in the caller.  Not sure
what happens if we start doing that when a path goes away unexpectedly.

I'll poke around and see what happens if we do that, and if I can drive
some path-directed I/O easily.

> 
>>
>>>   
>>>>  
>>>>  	chain = list_first_entry(&cp->ccwchain_list, struct ccwchain, next);
>>>>  	cpa = chain->ch_ccw;  
>>>   
>>
> 
