Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 641B562073
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2019 16:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731769AbfGHO23 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jul 2019 10:28:29 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44678 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729760AbfGHO22 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Jul 2019 10:28:28 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x68ESR86120282
        for <kvm@vger.kernel.org>; Mon, 8 Jul 2019 10:28:27 -0400
Received: from e14.ny.us.ibm.com (e14.ny.us.ibm.com [129.33.205.204])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tm7cw0m44-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 08 Jul 2019 10:28:23 -0400
Received: from localhost
        by e14.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <akrowiak@linux.ibm.com>;
        Mon, 8 Jul 2019 15:27:18 +0100
Received: from b01cxnp22036.gho.pok.ibm.com (9.57.198.26)
        by e14.ny.us.ibm.com (146.89.104.201) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 8 Jul 2019 15:27:15 +0100
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x68ERCd214942816
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Jul 2019 14:27:12 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 397F6AE05F;
        Mon,  8 Jul 2019 14:27:12 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E2213AE05C;
        Mon,  8 Jul 2019 14:27:11 +0000 (GMT)
Received: from [9.60.75.173] (unknown [9.60.75.173])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  8 Jul 2019 14:27:11 +0000 (GMT)
Subject: Re: [PATCH v4 3/7] s390: zcrypt: driver callback to indicate resource
 in use
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, mjrosato@linux.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com
References: <1560454780-20359-1-git-send-email-akrowiak@linux.ibm.com>
 <1560454780-20359-4-git-send-email-akrowiak@linux.ibm.com>
 <20190618182558.7d7e025a.cohuck@redhat.com>
 <2366c6b6-fd9e-0c32-0e9d-018cd601a0ad@linux.ibm.com>
 <20190701212643.0dd7d4ab.cohuck@redhat.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Date:   Mon, 8 Jul 2019 10:27:11 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190701212643.0dd7d4ab.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19070814-0052-0000-0000-000003DBC520
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011395; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01229239; UDB=6.00647369; IPR=6.01010497;
 MB=3.00027634; MTD=3.00000008; XFM=3.00000015; UTC=2019-07-08 14:27:17
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19070814-0053-0000-0000-0000619C95B9
Message-Id: <c771961d-f840-fe8a-09b7-a11b39a74d4c@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-08_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907080180
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/1/19 3:26 PM, Cornelia Huck wrote:
> On Wed, 19 Jun 2019 09:04:18 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> 
>> On 6/18/19 12:25 PM, Cornelia Huck wrote:
>>> On Thu, 13 Jun 2019 15:39:36 -0400
>>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>>    
>>>> Introduces a new driver callback to prevent a root user from unbinding
>>>> an AP queue from its device driver if the queue is in use. This prevents
>>>> a root user from inadvertently taking a queue away from a guest and
>>>> giving it to the host, or vice versa. The callback will be invoked
>>>> whenever a change to the AP bus's apmask or aqmask sysfs interfaces may
>>>> result in one or more AP queues being removed from its driver. If the
>>>> callback responds in the affirmative for any driver queried, the change
>>>> to the apmask or aqmask will be rejected with a device in use error.
>>>>
>>>> For this patch, only non-default drivers will be queried. Currently,
>>>> there is only one non-default driver, the vfio_ap device driver. The
>>>> vfio_ap device driver manages AP queues passed through to one or more
>>>> guests and we don't want to unexpectedly take AP resources away from
>>>> guests which are most likely independently administered.
>>>>
>>>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>>>> ---
>>>>    drivers/s390/crypto/ap_bus.c | 138 +++++++++++++++++++++++++++++++++++++++++--
>>>>    drivers/s390/crypto/ap_bus.h |   3 +
>>>>    2 files changed, 135 insertions(+), 6 deletions(-)
>>>
>>> Hm... I recall objecting to this patch before, fearing that it makes it
>>> possible for a bad actor to hog resources that can't be removed by
>>> root, even forcefully. (I have not had time to look at the intervening
>>> versions, so I might be missing something.)
>>>
>>> Is there a way for root to forcefully override this?
>>
>> You recall correctly; however, after many internal crypto team
>> discussions, it was decided that this feature was important
>> and should be kept.
> 
> That's the problem with internal discussions: they're internal :( Would
> have been nice to have some summary of this in the changelog.

I tried to summarize everything here.

> 
>>
>> Allow me to first address your fear that a bad actor can hog
>> resources that can't be removed by root. With this enhancement,
>> there is nothing preventing a root user from taking resources
>> from a matrix mdev, it simply forces him/her to follow the
>> proper procedure. The resources to be removed must first be
>> unassigned from the matrix mdev to which they are assigned.
>> The AP bus's /sys/bus/ap/apmask and /sys/bus/ap/aqmask
>> sysfs attributes can then be edited to transfer ownership
>> of the resources to zcrypt.
> 
> What is the suggested procedure when root wants to unbind a queue
> device? Find the mdev using the queue (is that easy enough?), unassign
> it, then unbind? Failing to unbind is a bit unexpected; can we point
> the admin to the correct mdev from which the queue has to be removed
> first?

The proper procedure is to first unassign the adapter, domain, or both
from the mdev to which the APQN is assigned. The difficulty in finding
the queue depends upon how many mdevs have been created. I would expect
that an admin would keep records of who owns what, but in the case he or
she doesn't, it would be a matter of printing out the matrix attribute
of each mdev until you find the mdev to which the APQN is assigned.
The only means I know of for informing the admin to which mdev a given
APQN is assigned is to log the error when it occurs. I think Matt is
also looking to provide query functions in the management tool on which
he is currently working.

> 
>>
>> The rationale for keeping this feature is:
>>
>> * It is a bad idea to steal an adapter in use from a guest. In the worst
>>     case, the guest could end up without access to any crypto adapters
>>     without knowing why. This could lead to performance issues on guests
>>     that rely heavily on crypto such as guests used for blockchain
>>     transactions.
> 
> Yanking adapters out from a running guest is not a good idea, yes; but
> I see it more as a problem of the management layer. Performance issues
> etc. are not something we want, obviously; but is removing access to
> the adapter deadly, or can the guest keep limping along? (Does the
> guest have any chance to find out that the adapter is gone? What
> happens on an LPAR if an adapter is gone, maybe due to a hardware
> failure?)

I don't think anybody is going to die if an adapter is yanked out;), but
if the guest has only one adapter, then other avenues for crypto
services would have to be used.

> 
>>
>> * There are plenty of examples in linux of the kernel preventing a root
>>     user from performing a task. For example, a module can't be removed
>>     if references are still held for it.
> 
> In this case, removing the module would actively break/crash anything
> relying on it; I'm not sure how analogous the situation is here (i.e.
> can we limp on without the device?)

I believe crypto libraries like libica revert to using other means -
such as crypto software or CPACF functions? - if no adapters are
available, so I don't think the guest is dead in the water as far as
crypto goes, but I'm certainly no expert in what happens above the AP
layer.

> 
>> Another example would be trying
>>     to bind a CEX4 adapter to a device driver not registered for CEX4;
>>     this action will also be rejected.
> 
> I don't think this one is analogous at all: The device driver can't
> drive the device, so why should it be able to bind to it?

Yes, probably a bad example

> 
>>
>> * The semantics are much cleaner and the logic is far less complicated.
> 
> This is actually the most convincing of the arguments, I think :) If we
> need some really byzantine logic to allow unbinding, it's probably not
> worth it.
> 
>>
>> * It forces the use of the proper procedure to change ownership of AP
>>     queues.
> 
> This needs to be properly documented, and the admin needs to have a
> chance to find out why unbinding didn't work and what needs to be done
> (see my comments above).

I will create a section in the vfio-ap.txt document that comes with this
patch set describing the proper procedure for unbinding queues. Of
course, we'll make sure the official IBM doc also more thoroughly
describes this.

> 

