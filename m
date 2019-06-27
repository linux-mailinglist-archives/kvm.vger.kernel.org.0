Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD465830B
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 15:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfF0NAX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jun 2019 09:00:23 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64718 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726375AbfF0NAX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Jun 2019 09:00:23 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5RCx0N2076326;
        Thu, 27 Jun 2019 09:00:03 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tcx3crqyj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jun 2019 09:00:03 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x5RCxOBL003367;
        Thu, 27 Jun 2019 13:00:01 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma04dal.us.ibm.com with ESMTP id 2t9by76dx1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jun 2019 13:00:01 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5RCxxMt53215686
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 12:59:59 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B59AAE060;
        Thu, 27 Jun 2019 12:59:59 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD20EAE066;
        Thu, 27 Jun 2019 12:59:58 +0000 (GMT)
Received: from [9.60.85.213] (unknown [9.60.85.213])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 27 Jun 2019 12:59:58 +0000 (GMT)
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
 <44f13e89-2fb4-bf8c-7849-641aae8d08cc@linux.ibm.com>
 <20190627092518.1f8d7d48.cohuck@redhat.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <315c8220-3dfa-1b19-266a-b9d9069bbe73@linux.ibm.com>
Date:   Thu, 27 Jun 2019 08:59:59 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190627092518.1f8d7d48.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-27_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906270152
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/27/19 3:25 AM, Cornelia Huck wrote:
> On Wed, 26 Jun 2019 17:13:50 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> 
>> On 6/19/19 9:04 AM, Tony Krowiak wrote:
>>> On 6/18/19 12:25 PM, Cornelia Huck wrote:
>>>> On Thu, 13 Jun 2019 15:39:36 -0400
>>>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>>>   
>>>>> Introduces a new driver callback to prevent a root user from unbinding
>>>>> an AP queue from its device driver if the queue is in use. This prevents
>>>>> a root user from inadvertently taking a queue away from a guest and
>>>>> giving it to the host, or vice versa. The callback will be invoked
>>>>> whenever a change to the AP bus's apmask or aqmask sysfs interfaces may
>>>>> result in one or more AP queues being removed from its driver. If the
>>>>> callback responds in the affirmative for any driver queried, the change
>>>>> to the apmask or aqmask will be rejected with a device in use error.
>>>>>
>>>>> For this patch, only non-default drivers will be queried. Currently,
>>>>> there is only one non-default driver, the vfio_ap device driver. The
>>>>> vfio_ap device driver manages AP queues passed through to one or more
>>>>> guests and we don't want to unexpectedly take AP resources away from
>>>>> guests which are most likely independently administered.
>>>>>
>>>>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>>>>> ---
>>>>>    drivers/s390/crypto/ap_bus.c | 138
>>>>> +++++++++++++++++++++++++++++++++++++++++--
>>>>>    drivers/s390/crypto/ap_bus.h |   3 +
>>>>>    2 files changed, 135 insertions(+), 6 deletions(-)
>>>>
>>>> Hm... I recall objecting to this patch before, fearing that it makes it
>>>> possible for a bad actor to hog resources that can't be removed by
>>>> root, even forcefully. (I have not had time to look at the intervening
>>>> versions, so I might be missing something.)
>>>>
>>>> Is there a way for root to forcefully override this?
>>>
>>> You recall correctly; however, after many internal crypto team
>>> discussions, it was decided that this feature was important
>>> and should be kept.
>>>
>>> Allow me to first address your fear that a bad actor can hog
>>> resources that can't be removed by root. With this enhancement,
>>> there is nothing preventing a root user from taking resources
>>> from a matrix mdev, it simply forces him/her to follow the
>>> proper procedure. The resources to be removed must first be
>>> unassigned from the matrix mdev to which they are assigned.
>>> The AP bus's /sys/bus/ap/apmask and /sys/bus/ap/aqmask
>>> sysfs attributes can then be edited to transfer ownership
>>> of the resources to zcrypt.
>>>
>>> The rationale for keeping this feature is:
>>>
>>> * It is a bad idea to steal an adapter in use from a guest. In the worst
>>>     case, the guest could end up without access to any crypto adapters
>>>     without knowing why. This could lead to performance issues on guests
>>>     that rely heavily on crypto such as guests used for blockchain
>>>     transactions.
>>>
>>> * There are plenty of examples in linux of the kernel preventing a root
>>>     user from performing a task. For example, a module can't be removed
>>>     if references are still held for it. Another example would be trying
>>>     to bind a CEX4 adapter to a device driver not registered for CEX4;
>>>     this action will also be rejected.
>>>
>>> * The semantics are much cleaner and the logic is far less complicated.
>>>
>>> * It forces the use of the proper procedure to change ownership of AP
>>>     queues.
>>>   
>>
>> Any feedback on this?
> 
> Had not yet time to look at this, sorry.

No problem, just wanted to make sure it didn't get lost in the shuffle.

> 
> 
>>
>> Tony K
>>
>>>    
>>>>   
>>>    
>>
> 

