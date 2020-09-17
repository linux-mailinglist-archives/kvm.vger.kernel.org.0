Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF18426DEEB
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 16:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727497AbgIQO7h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 10:59:37 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36942 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727747AbgIQO71 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Sep 2020 10:59:27 -0400
X-Greylist: delayed 3802 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 10:59:10 EDT
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08HDdLuZ178952;
        Thu, 17 Sep 2020 09:54:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=i0IqlJxJeCrMDBPn1qGA0l+kWXlDmq4OGa2bXphZnZE=;
 b=D9BckashlyaPq5cE1sS0GBwqc24BvctHSqsn+LeGpHvGbtqMzGt61RkhNBb5vxquK8AC
 7GzpT+FotJX0oNJEj/K2Gyfuk35ktgXYz64dHRWaPAqsQd3CiH8m0izpHDyXqUlXxsvD
 VQn+aIHn5UChrumZ3oQ50plE73yxHWOhmUhRSXimT21V6kn58WQ95yfDyPSbL+BehCHH
 Vt91wFz4OAIJQ4h8t2Hp6Yvr4WnbalIF5J7ZV5peAC0PWOjdqt9dDdPsBQ3hJVk9iiTJ
 YXpr9+SDdN+sJ9zob/0MGXCM98QMoqpDAnHApM0ig6cxm+hmR07Dm8ah2X8GB+z6dK2t 0g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33m6tcm0gc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Sep 2020 09:54:12 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08HDdN4T179013;
        Thu, 17 Sep 2020 09:54:11 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33m6tcm0g0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Sep 2020 09:54:11 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08HDl6jY028303;
        Thu, 17 Sep 2020 13:54:10 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma04dal.us.ibm.com with ESMTP id 33m7u9rmc8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Sep 2020 13:54:10 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08HDs8OC27984162
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 13:54:08 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C664BAE05F;
        Thu, 17 Sep 2020 13:54:08 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 004FCAE05C;
        Thu, 17 Sep 2020 13:54:07 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.128.188])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 17 Sep 2020 13:54:07 +0000 (GMT)
Subject: Re: [PATCH v10 04/16] s390/zcrypt: driver callback to indicate
 resource in use
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        kernel test robot <lkp@intel.com>
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
 <20200821195616.13554-5-akrowiak@linux.ibm.com>
 <20200914172947.533ddf56.cohuck@redhat.com>
 <fe3ba715-8ea7-45df-4144-d1f5dec38a45@linux.ibm.com>
 <20200917141442.6e531799.cohuck@redhat.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <ca8da504-5b81-3c64-ccca-c056921af668@linux.ibm.com>
Date:   Thu, 17 Sep 2020 09:54:07 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200917141442.6e531799.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-17_09:2020-09-16,2020-09-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 suspectscore=2 bulkscore=0 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 impostorscore=0 spamscore=0
 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170104
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/17/20 8:14 AM, Cornelia Huck wrote:
> On Tue, 15 Sep 2020 15:32:35 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> On 9/14/20 11:29 AM, Cornelia Huck wrote:
>>> On Fri, 21 Aug 2020 15:56:04 -0400
>>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>>   
>>>> Introduces a new driver callback to prevent a root user from unbinding
>>>> an AP queue from its device driver if the queue is in use. The intent of
>>>> this callback is to provide a driver with the means to prevent a root user
>>>> from inadvertently taking a queue away from a matrix mdev and giving it to
>>>> the host while it is assigned to the matrix mdev. The callback will
>>>> be invoked whenever a change to the AP bus's sysfs apmask or aqmask
>>>> attributes would result in one or more AP queues being removed from its
>>>> driver. If the callback responds in the affirmative for any driver
>>>> queried, the change to the apmask or aqmask will be rejected with a device
>>>> in use error.
>>>>
>>>> For this patch, only non-default drivers will be queried. Currently,
>>>> there is only one non-default driver, the vfio_ap device driver. The
>>>> vfio_ap device driver facilitates pass-through of an AP queue to a
>>>> guest. The idea here is that a guest may be administered by a different
>>>> sysadmin than the host and we don't want AP resources to unexpectedly
>>>> disappear from a guest's AP configuration (i.e., adapters, domains and
>>>> control domains assigned to the matrix mdev). This will enforce the proper
>>>> procedure for removing AP resources intended for guest usage which is to
>>>> first unassign them from the matrix mdev, then unbind them from the
>>>> vfio_ap device driver.
>>>>
>>>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>>>> Reported-by: kernel test robot <lkp@intel.com>
>>> This looks a bit odd...
>> I've removed all of those. These kernel test robot errors were flagged
>> in the last series. The review comments from the robot suggested
>> the reported-by, but I assume that was for patches intended to
>> fix those errors, so I am removing these as per Christian's comments.
> Yes, I think the Reported-by: mostly makes sense if you include a patch
> to fix something on top.
>
>>>   
>>>> ---
>>>>    drivers/s390/crypto/ap_bus.c | 148 ++++++++++++++++++++++++++++++++---
>>>>    drivers/s390/crypto/ap_bus.h |   4 +
>>>>    2 files changed, 142 insertions(+), 10 deletions(-)
>>>>   
>>> (...)
>>>   
>>>> @@ -1107,12 +1118,70 @@ static ssize_t apmask_show(struct bus_type *bus, char *buf)
>>>>    	return rc;
>>>>    }
>>>>    
>>>> +static int __verify_card_reservations(struct device_driver *drv, void *data)
>>>> +{
>>>> +	int rc = 0;
>>>> +	struct ap_driver *ap_drv = to_ap_drv(drv);
>>>> +	unsigned long *newapm = (unsigned long *)data;
>>>> +
>>>> +	/*
>>>> +	 * No need to verify whether the driver is using the queues if it is the
>>>> +	 * default driver.
>>>> +	 */
>>>> +	if (ap_drv->flags & AP_DRIVER_FLAG_DEFAULT)
>>>> +		return 0;
>>>> +
>>>> +	/* The non-default driver's module must be loaded */
>>>> +	if (!try_module_get(drv->owner))
>>>> +		return 0;
>>>> +
>>>> +	if (ap_drv->in_use)
>>>> +		if (ap_drv->in_use(newapm, ap_perms.aqm))
>>>> +			rc = -EADDRINUSE;
>>> ISTR that Christian suggested -EBUSY in a past revision of this series?
>>> I think that would be more appropriate.
>> I went back and looked and sure enough, he did recommend that.
>> You have a great memory! I didn't respond to that comment, so I
>> must have missed it at the time.
>>
>> I personally prefer EADDRINUSE because I think it is more indicative
>> of the reason an AP resource can not be assigned back to the host
>> drivers is because it is in use by a guest or, at the very least, reserved
>> for use by a guest (i.e., assigned to an mdev). To say it is busy implies
>> that the device is busy performing encryption services which may or
>> may not be true at a given moment. Even if so, that is not the reason
>> for refusing to allow reassignment of the device.
> I have a different understanding of these error codes: EADDRINUSE is
> something used in the networking context when an actual address is
> already used elsewhere. EBUSY is more of a generic error that indicates
> that a certain resource is not free to perform the requested operation;
> it does not necessarily mean that the resource is currently actively
> doing something. Kind of when you get EBUSY when trying to eject
> something another program holds a reference on: that other program
> might not actually be doing anything, but it potentially could.

I'll go ahead and change it to -EBUSY.

>

