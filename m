Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66CD75103D
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2019 17:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730736AbfFXPYY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jun 2019 11:24:24 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52354 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729026AbfFXPYX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Jun 2019 11:24:23 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5OFIiS6055294
        for <kvm@vger.kernel.org>; Mon, 24 Jun 2019 11:24:22 -0400
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tb0tyh6au-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 24 Jun 2019 11:24:22 -0400
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <alifm@linux.ibm.com>;
        Mon, 24 Jun 2019 16:24:21 +0100
Received: from b01cxnp22033.gho.pok.ibm.com (9.57.198.23)
        by e16.ny.us.ibm.com (146.89.104.203) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 24 Jun 2019 16:24:18 +0100
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5OFOH2x47055218
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jun 2019 15:24:17 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 15845124058;
        Mon, 24 Jun 2019 15:24:17 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 077BE124055;
        Mon, 24 Jun 2019 15:24:17 +0000 (GMT)
Received: from [9.56.58.42] (unknown [9.56.58.42])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 24 Jun 2019 15:24:16 +0000 (GMT)
Subject: Re: [RFC v1 1/1] vfio-ccw: Don't call cp_free if we are processing a
 channel program
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Eric Farman <farman@linux.ibm.com>, pasic@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1561055076.git.alifm@linux.ibm.com>
 <46dc0cbdcb8a414d70b7807fceb1cca6229408d5.1561055076.git.alifm@linux.ibm.com>
 <638804dc-53c0-ff2f-d123-13c257ad593f@linux.ibm.com>
 <581d756d-7418-cd67-e0e8-f9e4fe10b22d@linux.ibm.com>
 <2d9c04ba-ee50-2f9b-343a-5109274ff52d@linux.ibm.com>
 <56ced048-8c66-a030-af35-8afbbd2abea8@linux.ibm.com>
 <20190624114231.2d81e36f.cohuck@redhat.com>
 <20190624120514.4b528db5.cohuck@redhat.com>
 <20190624134622.2bb3bba2.cohuck@redhat.com>
 <20190624140723.5aa7b0b1.cohuck@redhat.com>
 <3e93215c-c11a-d0bb-8982-be3f2b467e13@linux.ibm.com>
 <20190624170937.4c76de8d.cohuck@redhat.com>
From:   Farhan Ali <alifm@linux.ibm.com>
Date:   Mon, 24 Jun 2019 11:24:16 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190624170937.4c76de8d.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19062415-0072-0000-0000-00000440048F
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011321; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01222649; UDB=6.00643356; IPR=6.01003810;
 MB=3.00027446; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-24 15:24:19
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19062415-0073-0000-0000-00004CB021ED
Message-Id: <7841b312-13ad-a4b3-85d9-1f5a4991f7fd@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-24_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906240123
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 06/24/2019 11:09 AM, Cornelia Huck wrote:
> On Mon, 24 Jun 2019 10:44:17 -0400
> Farhan Ali <alifm@linux.ibm.com> wrote:
> 
>> On 06/24/2019 08:07 AM, Cornelia Huck wrote:
>>> On Mon, 24 Jun 2019 13:46:22 +0200
>>> Cornelia Huck <cohuck@redhat.com> wrote:
>>>    
>>>> On Mon, 24 Jun 2019 12:05:14 +0200
>>>> Cornelia Huck <cohuck@redhat.com> wrote:
>>>>   
>>>>> On Mon, 24 Jun 2019 11:42:31 +0200
>>>>> Cornelia Huck <cohuck@redhat.com> wrote:
>>>>>       
>>>>>> On Fri, 21 Jun 2019 14:34:10 -0400
>>>>>> Farhan Ali <alifm@linux.ibm.com> wrote:
>>>>>>         
>>>>>>> On 06/21/2019 01:40 PM, Eric Farman wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>> On 6/21/19 10:17 AM, Farhan Ali wrote:
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> On 06/20/2019 04:27 PM, Eric Farman wrote:
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> On 6/20/19 3:40 PM, Farhan Ali wrote:
>>>>   
>>>>>>>>>>> diff --git a/drivers/s390/cio/vfio_ccw_drv.c
>>>>>>>>>>> b/drivers/s390/cio/vfio_ccw_drv.c
>>>>>>>>>>> index 66a66ac..61ece3f 100644
>>>>>>>>>>> --- a/drivers/s390/cio/vfio_ccw_drv.c
>>>>>>>>>>> +++ b/drivers/s390/cio/vfio_ccw_drv.c
>>>>>>>>>>> @@ -88,7 +88,7 @@ static void vfio_ccw_sch_io_todo(struct work_struct
>>>>>>>>>>> *work)
>>>>>>>>>>>                   (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT));
>>>>>>>>>>>          if (scsw_is_solicited(&irb->scsw)) {
>>>>>>>>>>>              cp_update_scsw(&private->cp, &irb->scsw);
>>>>>>>>>>
>>>>>>>>>> As I alluded earlier, do we know this irb is for this cp?  If no, what
>>>>>>>>>> does this function end up putting in the scsw?
>>>>>>
>>>>>> Yes, I think this also needs to check whether we have at least a prior
>>>>>> start function around. (We use the orb provided by the guest; maybe we
>>>>>> should check if that intparm is set in the irb?)
>>>>>
>>>>> Hrm; not so easy as we always set the intparm to the address of the
>>>>> subchannel structure...
>>>>>
>>>>> Maybe check if we have have one of the conditions of the large table
>>>>> 16-6 and correlate to the ccw address? Or is it enough to check the
>>>>> function control? (Don't remember when the hardware resets it.)
>>>>
>>>> Nope, we cannot look at the function control, as csch clears any set
>>>> start function bit :( (see "Function Control", pg 16-13)
>>>>
>>>> I think this problem mostly boils down to "csch clears pending status;
>>>> therefore, we may only get one interrupt, even though there had been a
>>>> start function going on". If we only go with what the hardware gives
>>>> us, I don't see a way to distinguish "clear with a prior start" from
>>>> "clear only". Maybe we want to track an "issued" status in the cp?
>>>
>>> Sorry for replying to myself again :), but maybe we should simply call
>>> cp_free() if we got cc 0 from a csch? Any start function has been
>>> terminated at the subchannel during successful execution of csch, and
>>> cp_free does nothing if !cp->initialized, so we should hopefully be
>>> safe there as well. We can then add a check for the start function in
>>> the function control in the check above and should be fine, I think.
>>>
>>>    
>>
>> So you mean not call cp_free in vfio_ccw_sch_io_todo, and instead call
>> cp_free for a cc=0 for csch (and hsch) ?
>>
>> Won't we end up with memory leak for a successful for ssch then?
> 
> No; both:
> 
> - free if cc=0 for csch (as this clears the status; hsch doesn't)
> - free in _todo if the start function is set in the irb and the status
>    is final
> 
>>
>> But even if we don't remove the cp_free from vfio_ccw_sch_io_todo, I am
>> not sure if your suggestion will fix the problem. The problem here is
>> that we can call vfio_ccw_sch_io_todo (for a clear or halt interrupt) at
>> the same time we are handling an ssch request. So depending on the order
>> of the operations we could still end up calling cp_free from both from
>> threads (i refer to the threads I mentioned in response to Eric's
>> earlier email).
> 
> What I don't see is why this is a problem with ->initialized; wasn't
> the problem that we misinterpreted an interrupt for csch as one for a
> not-yet-issued ssch?
> 

It's the order in which we do things, which could cause the problem. 
Since we queue interrupt handling in the workqueue, we could delay 
processing the csch interrupt. During this delay if ssch comes through, 
we might have already set ->initialized to true.

So when we get around to handling the interrupt in io_todo, we would go 
ahead and call cp_free. This would cause the problem of freeing the 
ccwchain list while we might be adding to it.

>>
>> Another thing that concerns me is that vfio-ccw can also issue csch/hsch
>> in the quiesce path, independently of what the guest issues. So in that
>> case we could have a similar scenario to processing an ssch request and
>> issuing halt/clear in parallel. But maybe I am being paranoid :)
> 
> I think the root problem is really trying to clear a cp while another
> thread is trying to set it up. Should we maybe use something like rcu?
> 
> 

Yes, this is the root problem. I am not too familiar with rcu locking, 
but what would be the benefit over a traditional mutex?

Thanks
Farhan

