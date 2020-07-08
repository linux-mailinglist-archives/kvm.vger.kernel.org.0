Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B538E2189C8
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 16:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729482AbgGHOEH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 10:04:07 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40238 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728148AbgGHOEG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Jul 2020 10:04:06 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 068E2roK100024;
        Wed, 8 Jul 2020 10:04:05 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 325e12b84c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jul 2020 10:04:05 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 068E32bY100648;
        Wed, 8 Jul 2020 10:04:04 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 325e12b83d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jul 2020 10:04:04 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 068E0PM4014000;
        Wed, 8 Jul 2020 14:04:03 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma05wdc.us.ibm.com with ESMTP id 324yf9x76u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jul 2020 14:04:03 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 068E41Aw31785338
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Jul 2020 14:04:02 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA2B5B206E;
        Wed,  8 Jul 2020 14:04:01 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 57640B2068;
        Wed,  8 Jul 2020 14:04:01 +0000 (GMT)
Received: from cpe-172-100-175-116.stny.res.rr.com (unknown [9.85.160.4])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  8 Jul 2020 14:04:01 +0000 (GMT)
Subject: Re: [PATCH v8 04/16] s390/zcrypt: driver callback to indicate
 resource in use
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
References: <20200605214004.14270-1-akrowiak@linux.ibm.com>
 <20200605214004.14270-5-akrowiak@linux.ibm.com>
 <d7954c15-b14f-d6e5-0193-aadca61883a8@de.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <f0ab3b69-8eb9-90c0-6daf-fa4b22bcb9dd@linux.ibm.com>
Date:   Wed, 8 Jul 2020 10:04:01 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <d7954c15-b14f-d6e5-0193-aadca61883a8@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-08_11:2020-07-08,2020-07-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 clxscore=1015 malwarescore=0 spamscore=0 impostorscore=0
 suspectscore=3 phishscore=0 lowpriorityscore=0 priorityscore=1501
 cotscore=-2147483648 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2007080102
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/8/20 8:27 AM, Christian Borntraeger wrote:
> On 05.06.20 23:39, Tony Krowiak wrote:
>> Introduces a new driver callback to prevent a root user from unbinding
>> an AP queue from its device driver if the queue is in use. The intent of
>> this callback is to provide a driver with the means to prevent a root user
>> from inadvertently taking a queue away from a matrix mdev and giving it to
>> the host while it is assigned to the matrix mdev. The callback will
>> be invoked whenever a change to the AP bus's sysfs apmask or aqmask
>> attributes would result in one or more AP queues being removed from its
>> driver. If the callback responds in the affirmative for any driver
>> queried, the change to the apmask or aqmask will be rejected with a device
>> in use error.
> The alternative would be to tear down the connection in the matrix mdev in this
> callback (so that the guest will see a hot unplug), but actually making this
> a more conscious decision (requiring 2 steps from the host admin) is certainly
> also fine.

That alternative was considered. Keep in mind that unassigning
an adapter (apmask) or domain (aqmask) may result in multiple APQNs
being removed from one or more matrix mdevs, which could affect
multiple guests. The choice was made to enforce the proper procedure
for taking AP resources away from a guest to prevent accidental or
indiscriminate maladministration.

>
>
>> For this patch, only non-default drivers will be queried. Currently,
>> there is only one non-default driver, the vfio_ap device driver. The
>> vfio_ap device driver facilitates pass-through of an AP queue to a
>> guest. The idea here is that a guest may be administered by a different
>> sysadmin than the host and we don't want AP resources to unexpectedly
>> disappear from a guest's AP configuration (i.e., adapters, domains and
>> control domains assigned to the matrix mdev). This will enforce the proper
>> procedure for removing AP resources intended for guest usage which is to
>> first unassign them from the matrix mdev, then unbind them from the
>> vfio_ap device driver.
> What I said above, we can force a hot unplug to the guest, but we require
> to do 2 steps. I think this is fine.
>
>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/ap_bus.c | 148 ++++++++++++++++++++++++++++++++---
>>   drivers/s390/crypto/ap_bus.h |   4 +
>>   2 files changed, 142 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
>> index e71ca4a719a5..40cb5861dad3 100644
>> --- a/drivers/s390/crypto/ap_bus.c
>> +++ b/drivers/s390/crypto/ap_bus.c
>> @@ -35,6 +35,7 @@
>>   #include <linux/mod_devicetable.h>
>>   #include <linux/debugfs.h>
>>   #include <linux/ctype.h>
>> +#include <linux/module.h>
>>   
>>   #include "ap_bus.h"
>>   #include "ap_debug.h"
>> @@ -876,6 +877,23 @@ static int modify_bitmap(const char *str, unsigned long *bitmap, int bits)
>>   	return 0;
>>   }
>>   
>> +static int ap_parse_bitmap_str(const char *str, unsigned long *bitmap, int bits,
>> +			       unsigned long *newmap)
>> +{
>> +	unsigned long size;
>> +	int rc;
>> +
>> +	size = BITS_TO_LONGS(bits)*sizeof(unsigned long);                                  ^ ^ spaces around the *
>> +	if (*str == '+' || *str == '-') {
>> +		memcpy(newmap, bitmap, size);
>> +		rc = modify_bitmap(str, newmap, bits);
>> +	} else {
>> +		memset(newmap, 0, size);
>> +		rc = hex2bitmap(str, newmap, bits);
>> +	}
>> +	return rc;
>> +}
>> +
>>   int ap_parse_mask_str(const char *str,
>>   		      unsigned long *bitmap, int bits,
>>   		      struct mutex *lock)
>> @@ -895,14 +913,7 @@ int ap_parse_mask_str(const char *str,
>>   		kfree(newmap);
>>   		return -ERESTARTSYS;
>>   	}
>> -
>> -	if (*str == '+' || *str == '-') {
>> -		memcpy(newmap, bitmap, size);
> Do we still need the size variable in here?
>
>> -		rc = modify_bitmap(str, newmap, bits);
>> -	} else {
>> -		memset(newmap, 0, size);
>> -		rc = hex2bitmap(str, newmap, bits);
>> -	}
>> +	rc = ap_parse_bitmap_str(str, bitmap, bits, newmap);
>>   	if (rc == 0)
>>   		memcpy(bitmap, newmap, size);
>>   	mutex_unlock(lock);
>> @@ -1092,12 +1103,70 @@ static ssize_t apmask_show(struct bus_type *bus, char *buf)
>>   	return rc;
>>   }
>>   
>> +int __verify_card_reservations(struct device_driver *drv, void *data)
>> +{
>> +	int rc = 0;
>> +	struct ap_driver *ap_drv = to_ap_drv(drv);
>> +	unsigned long *newapm = (unsigned long *)data;
>> +
>> +	/*
>> +	 * No need to verify whether the driver is using the queues if it is the
>> +	 * default driver.
>> +	 */
>> +	if (ap_drv->flags & AP_DRIVER_FLAG_DEFAULT)
>> +		return 0;
>> +
>> +	/* The non-default driver's module must be loaded */> +	if (!try_module_get(drv->owner))
>> +		return 0;
>> +
>> +	if (ap_drv->in_use)
>> +		if (ap_drv->in_use(newapm, ap_perms.aqm))
>> +			rc = -EADDRINUSE;
> I think -EBUSY is more appropriate.  (also in the other places)
>

