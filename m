Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE606597D
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 16:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbfGKO5Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 10:57:16 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62266 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728414AbfGKO5P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Jul 2019 10:57:15 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6BEtIuY084537
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2019 10:57:14 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tp6sj1qxe-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2019 10:57:13 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Thu, 11 Jul 2019 15:57:11 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 11 Jul 2019 15:57:10 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6BEv87p61669412
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 14:57:08 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9CAE7A4040;
        Thu, 11 Jul 2019 14:57:08 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79F49A4053;
        Thu, 11 Jul 2019 14:57:08 +0000 (GMT)
Received: from oc2783563651 (unknown [9.152.98.129])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 11 Jul 2019 14:57:08 +0000 (GMT)
Date:   Thu, 11 Jul 2019 16:57:03 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Farhan Ali <alifm@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, farman@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC v2 4/5] vfio-ccw: Don't call cp_free if we are processing
 a channel program
In-Reply-To: <87f7a37f-cc34-36fb-3a33-309e33bbbdde@linux.ibm.com>
References: <cover.1562616169.git.alifm@linux.ibm.com>
        <1405df8415d3bff446c22753d0e9b91ff246eb0f.1562616169.git.alifm@linux.ibm.com>
        <20190709121613.6a3554fa.cohuck@redhat.com>
        <45ad7230-3674-2601-af5b-d9beef9312be@linux.ibm.com>
        <20190709162142.789dd605.pasic@linux.ibm.com>
        <87f7a37f-cc34-36fb-3a33-309e33bbbdde@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19071114-0008-0000-0000-000002FC7664
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071114-0009-0000-0000-00002269DF19
Message-Id: <20190711165703.3a1a8462.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-11_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907110169
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 9 Jul 2019 17:27:47 -0400
Farhan Ali <alifm@linux.ibm.com> wrote:

> 
> 
> On 07/09/2019 10:21 AM, Halil Pasic wrote:
> > On Tue, 9 Jul 2019 09:46:51 -0400
> > Farhan Ali <alifm@linux.ibm.com> wrote:
> > 
> >>
> >>
> >> On 07/09/2019 06:16 AM, Cornelia Huck wrote:
> >>> On Mon,  8 Jul 2019 16:10:37 -0400
> >>> Farhan Ali <alifm@linux.ibm.com> wrote:
> >>>
> >>>> There is a small window where it's possible that we could be working
> >>>> on an interrupt (queued in the workqueue) and setting up a channel
> >>>> program (i.e allocating memory, pinning pages, translating address).
> >>>> This can lead to allocating and freeing the channel program at the
> >>>> same time and can cause memory corruption.
> >>>>
> >>>> Let's not call cp_free if we are currently processing a channel program.
> >>>> The only way we know for sure that we don't have a thread setting
> >>>> up a channel program is when the state is set to VFIO_CCW_STATE_CP_PENDING.
> >>>
> >>> Can we pinpoint a commit that introduced this bug, or has it been there
> >>> since the beginning?
> >>>
> >>
> >> I think the problem was always there.
> >>
> > 
> > I think it became relevant with the async stuff. Because after the async
> > stuff was added we start getting solicited interrupts that are not about
> > channel program is done. At least this is how I remember the discussion.
> > 

You seem to have ignored this comment. BTW wasn't the cp->is_initialized
make 'Make it safe to call the cp accessors in any case, so we can call
them unconditionally.'?

@Connie: Your opinion as the author of that patch and of the cited
sentence?

> >>>>
> >>>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> >>>> ---
> >>>>    drivers/s390/cio/vfio_ccw_drv.c | 2 +-
> >>>>    1 file changed, 1 insertion(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
> >>>> index 4e3a903..0357165 100644
> >>>> --- a/drivers/s390/cio/vfio_ccw_drv.c
> >>>> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> >>>> @@ -92,7 +92,7 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
> >>>>    		     (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT));
> >>>>    	if (scsw_is_solicited(&irb->scsw)) {
> >>>>    		cp_update_scsw(&private->cp, &irb->scsw);
> >>>> -		if (is_final)
> >>>> +		if (is_final && private->state == VFIO_CCW_STATE_CP_PENDING)
> > 
> > Ain't private->state potentially used by multiple threads of execution?
> 
> yes
> 
> One of the paths I can think of is a machine check from the host which 
> will ultimately call vfio_ccw_sch_event callback which could set state 
> to NOT_OPER or IDLE.
> 
> > Do we need to use atomic operations or external synchronization to avoid
> > this being another gamble? Or am I missing something?
> 
> I think we probably should think about atomic operations for 
> synchronizing the state (and it could be a separate add on patch?).
> 
> But for preventing 2 threads from stomping on the cp the check should be 
> enough, unless I am missing something?
> 

Usually programming languages don't like incorrectly synchronized
programs. One tends to end up in undefined behavior land -- form language
perspective. That doesn't actually mean you are bound to see strange
stuff. With implementation spec + ABI spec + platform/architecture
spec one may end up with things being well defined. But it that is a much
deeper rabbit hole.

The nice thing about condition state == VFIO_CCW_STATE_CP_PENDING is
that it can tolerate stale state values. The bad case at hand
(you free but you should not) would be we see a stale
VFIO_CCW_STATE_CP_PENDING but we are actually
VFIO_CCW_STATE_CP_PROCESSING. That is pretty difficult to imagine
because one can enter VFIO_CCW_STATE_CP_PROCESSING only form
VFIO_CCW_STATE_CP_PENDING afair. On s390x torn reads/writes (i.e.
observing something that ain't either the old nor the new value) on an
int shouldn't be a concern.

The other bad case (where you don't free albeit you should) looks a
bit trickier.

I'm not a fan of keeping races around without good reasons. And I don't
see good reasons here. I'm no fan of needlessly complicated solutions
either.

But seems, at least with my beliefs about races, I'm the oddball
here. 

Regards,
Halil

> > 
> >>>>    			cp_free(&private->cp);
> >>>>    	}
> >>>>    	mutex_lock(&private->io_mutex);
> >>>
> >>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> >>>
> >>>
> >> Thanks for reviewing.
> >>
> >> Thanks
> >> Farhan
> > 
> > 

