Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF3A4B95D
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 15:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731963AbfFSNEm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 09:04:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56302 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731812AbfFSNEl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Jun 2019 09:04:41 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5JD0iGL124868;
        Wed, 19 Jun 2019 09:04:33 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t7m3hwae4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jun 2019 09:04:32 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x5JCsT70007498;
        Wed, 19 Jun 2019 13:04:22 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma03dal.us.ibm.com with ESMTP id 2t4ra62vhq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jun 2019 13:04:22 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5JD4JAl42664256
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jun 2019 13:04:19 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 477C128064;
        Wed, 19 Jun 2019 13:04:19 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8EFC328059;
        Wed, 19 Jun 2019 13:04:18 +0000 (GMT)
Received: from [9.85.194.193] (unknown [9.85.194.193])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 19 Jun 2019 13:04:18 +0000 (GMT)
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
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <2366c6b6-fd9e-0c32-0e9d-018cd601a0ad@linux.ibm.com>
Date:   Wed, 19 Jun 2019 09:04:18 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190618182558.7d7e025a.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-19_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906190108
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/18/19 12:25 PM, Cornelia Huck wrote:
> On Thu, 13 Jun 2019 15:39:36 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> 
>> Introduces a new driver callback to prevent a root user from unbinding
>> an AP queue from its device driver if the queue is in use. This prevents
>> a root user from inadvertently taking a queue away from a guest and
>> giving it to the host, or vice versa. The callback will be invoked
>> whenever a change to the AP bus's apmask or aqmask sysfs interfaces may
>> result in one or more AP queues being removed from its driver. If the
>> callback responds in the affirmative for any driver queried, the change
>> to the apmask or aqmask will be rejected with a device in use error.
>>
>> For this patch, only non-default drivers will be queried. Currently,
>> there is only one non-default driver, the vfio_ap device driver. The
>> vfio_ap device driver manages AP queues passed through to one or more
>> guests and we don't want to unexpectedly take AP resources away from
>> guests which are most likely independently administered.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/ap_bus.c | 138 +++++++++++++++++++++++++++++++++++++++++--
>>   drivers/s390/crypto/ap_bus.h |   3 +
>>   2 files changed, 135 insertions(+), 6 deletions(-)
> 
> Hm... I recall objecting to this patch before, fearing that it makes it
> possible for a bad actor to hog resources that can't be removed by
> root, even forcefully. (I have not had time to look at the intervening
> versions, so I might be missing something.)
> 
> Is there a way for root to forcefully override this?

You recall correctly; however, after many internal crypto team
discussions, it was decided that this feature was important
and should be kept.

Allow me to first address your fear that a bad actor can hog
resources that can't be removed by root. With this enhancement,
there is nothing preventing a root user from taking resources
from a matrix mdev, it simply forces him/her to follow the
proper procedure. The resources to be removed must first be
unassigned from the matrix mdev to which they are assigned.
The AP bus's /sys/bus/ap/apmask and /sys/bus/ap/aqmask
sysfs attributes can then be edited to transfer ownership
of the resources to zcrypt.

The rationale for keeping this feature is:

* It is a bad idea to steal an adapter in use from a guest. In the worst
   case, the guest could end up without access to any crypto adapters
   without knowing why. This could lead to performance issues on guests
   that rely heavily on crypto such as guests used for blockchain
   transactions.

* There are plenty of examples in linux of the kernel preventing a root
   user from performing a task. For example, a module can't be removed
   if references are still held for it. Another example would be trying
   to bind a CEX4 adapter to a device driver not registered for CEX4;
   this action will also be rejected.

* The semantics are much cleaner and the logic is far less complicated.

* It forces the use of the proper procedure to change ownership of AP
   queues.


> 

