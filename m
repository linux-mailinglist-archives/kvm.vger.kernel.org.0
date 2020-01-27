Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7EAC14ABA1
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 22:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgA0V2W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jan 2020 16:28:22 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22372 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725955AbgA0V2V (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Jan 2020 16:28:21 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00RLEZQa091041;
        Mon, 27 Jan 2020 16:28:21 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xrhv0wxnf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jan 2020 16:28:21 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 00RLHwu8133892;
        Mon, 27 Jan 2020 16:28:20 -0500
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xrhv0wxmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jan 2020 16:28:20 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 00RLE994012293;
        Mon, 27 Jan 2020 21:28:19 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma02dal.us.ibm.com with ESMTP id 2xrda69auq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jan 2020 21:28:19 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00RLSI9246072310
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jan 2020 21:28:19 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E2C05124052;
        Mon, 27 Jan 2020 21:28:18 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7BD79124055;
        Mon, 27 Jan 2020 21:28:18 +0000 (GMT)
Received: from [9.160.17.65] (unknown [9.160.17.65])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 27 Jan 2020 21:28:18 +0000 (GMT)
From:   Eric Farman <farman@linux.ibm.com>
Subject: Re: [PATCH v1 1/1] vfio-ccw: Don't free channel programs for
 unrelated interrupts
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        "Jason J . Herne" <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200124145455.51181-1-farman@linux.ibm.com>
 <20200124145455.51181-2-farman@linux.ibm.com>
 <20200124163305.3d6f0d47.cohuck@redhat.com>
 <50a0fe00-a7c1-50e4-12f5-412ee7a0e522@linux.ibm.com>
 <20200127135235.1f783f1b.cohuck@redhat.com>
Message-ID: <eb3f3887-50f2-ef4d-0b98-b25936047a49@linux.ibm.com>
Date:   Mon, 27 Jan 2020 16:28:18 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200127135235.1f783f1b.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-27_07:2020-01-24,2020-01-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 malwarescore=0 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2001270168
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/27/20 7:52 AM, Cornelia Huck wrote:
> On Fri, 24 Jan 2020 11:08:12 -0500
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> On 1/24/20 10:33 AM, Cornelia Huck wrote:
>>> On Fri, 24 Jan 2020 15:54:55 +0100
>>> Eric Farman <farman@linux.ibm.com> wrote:
> 
>>>> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
>>>> index e401a3d0aa57..a8ab256a217b 100644
>>>> --- a/drivers/s390/cio/vfio_ccw_drv.c
>>>> +++ b/drivers/s390/cio/vfio_ccw_drv.c
>>>> @@ -90,8 +90,8 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
>>>>  	is_final = !(scsw_actl(&irb->scsw) &
>>>>  		     (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT));
>>>>  	if (scsw_is_solicited(&irb->scsw)) {
>>>> -		cp_update_scsw(&private->cp, &irb->scsw);
>>>> -		if (is_final && private->state == VFIO_CCW_STATE_CP_PENDING)
>>>> +		if (cp_update_scsw(&private->cp, &irb->scsw) &&
>>>> +		    is_final && private->state == VFIO_CCW_STATE_CP_PENDING)  
>>>
>>> ...but I still wonder why is_final is not catching non-ssch related
>>> interrupts, as I thought it would. We might want to adapt that check,
>>> instead. (Or was the scsw_is_solicited() check supposed to catch that?
>>> As said, too tired right now...)  
>>
>> I had looked at the (un)solicited bits at one point, and saw very few
>> unsolicited interrupts.  The ones that did show up didn't appear to
>> affect things in the way that would cause the problems I'm seeing.
> 
> Ok, so that check is hopefully fine.
> 
>>
>> As for is_final...  That POPS table states that for "status pending
>> [alone] after termination of HALT or CLEAR ... cpa is unpredictable",
>> which is what happens here.  In the example above, the cpa is the same
>> as the previous (successful) interrupt, and thus unrelated to the
>> current chain.  Perhaps is_final needs to check that the function
>> control in the interrupt is for a start?
> 
> I think our reasoning last time we discussed this function was that we
> only are in CP_PENDING if we actually did a ssch previously. Now, if we

I spent a little time looking at the conversations on the patch that
added the CP_PENDING check.  Sadly, those patches hit the list when I
left for holiday so I came late to those discussions and there appears
some loose ends that I should've chased down at the time.  Sorry.

But yes, we should only be in CP_PENDING because of the SSCH, but the
only check of the interrupt here is the "is_final" check, and not that
the interrupt was for a start function.

> do a hsch/csch before we got final status for the program started by
> the ssch, we don't move out of the CP_PENDING, but the cpa still might
> not be what we're looking for. 

As long as we get an interrupt that's "is_final" then don't we come out
of CP_PENDING state at the end of this routine, regardless of whether or
not it does the cp_free() call?  I think your original diagnosis [1] was
that even if the cpa is invalid, calling cp_update_scsw() is okay
because garbage-in-garbage-out.  This patch makes that part of the
criteria for doing the cp_free(), so maybe that's too heavy?  After all,
it does mean that we may leave private->cp "initialized", but reset the
state back to IDLE.  (More on that in a minute.)

> So, we should probably check that we
> have only the start function indicated in the fctl.

For the call to cp_update_scsw() or cp_free()?  Or both?

> 
> But if we do that, we still have a chain allocated for something that
> has already been terminated... how do we find the right chain to clean
> up, if needed?

Don't we free all/none of the chains?  Ideally, since we only have one
set of chains per cp (and thus, per SSCH), they should either all be
freed or ignored.

But regardless, this patch is at least not complete, if not incorrect.
I left a test running for the weekend and while I don't see the storage
damage I saw before, there's a lot of unreleased memory because of stuff
like this:

950.541644 06 ...sch_io_todo sch 09c5: state=3 orb.cpa=7f586f48
                                               irb.w0=00001001
                                               irb.cpa=02e35d58
                                               irb.w2=0000000c
                                               ccw=0
                                               *cda=0
950.541837 06 ...sch_io_todo sch 09c5: state=2 orb.cpa=030ec750
                                               irb.w0=00c04007
                                               irb.cpa=7f586f50
                                               irb.w2=0c000000
                                               ccw=3424000c030ea840
                                               *cda=190757ef0

(I was only tracing instances where vfio-ccw did NOT call cp_free() on
the interrupt path; so I don't have a complete history of what happened.)

The orb.cpa address in the first trace looks like something which came
from the guest, rather than something built by vfio-ccw.  The irb.cpa
address in the second trace is 8 bytes after the first orb.cpa address.
And the storage referenced by both the CP and IDAL referenced in trace 2
are still active when I started poking at the state of things.

There's a lot just to unravel just with this instance.  Like why a guest
CPA is in orb, and thus an irb.  Or why cp_prefetch() checks that
!cp->initialized, but cp_init() does no such thing.  I guess I'll put in
a check to see how that helps this particular situation, while I sort
out the other problems here.

> 

[1] https://lore.kernel.org/kvm/20190702115134.790f8891.cohuck@redhat.com/
