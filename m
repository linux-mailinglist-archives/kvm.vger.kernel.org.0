Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7F327D041
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 15:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731484AbgI2N7U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 09:59:20 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15168 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731133AbgI2N7O (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 09:59:14 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08TDXFoe012857;
        Tue, 29 Sep 2020 09:59:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=iKiPTW/vJ5vu9BFyY5Tv2uyi4lQzNzC3ABm6E4hmx9M=;
 b=aWNRoN1HdGr58scvDbjIDDjwZ3kCMdBVhhZarHG3IEYhV5JP54rM+n5Ekk7Z70fnERNB
 /zVABq3fvPoQPNEMMsAanlXJViFXgR32516sGt5Mm4jesp8mManPS7Q8HUu5ZCmIAjaN
 yRG+u6R/cvgMsZXpSUqtbUglmfJ6TLKbss/4zjvA9nZWDv0LC5kjxZ7tSFeUwpbx/wXb
 KL+GW2AMBjBaVq0lUDH6puC6ZcE3m63xMAiZ8BAlLDYctwyEYg0jWN67cFdjlZgisWOS
 JbXJRQWVYwE4ucE/TpYqHjwdl+YCcqG/74C7Ya5GQZFJ1qR1/EFfVb289WGyVd3a+dle cQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33v4ybuh92-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 09:59:11 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08TDXUsD014633;
        Tue, 29 Sep 2020 09:59:11 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33v4ybuh8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 09:59:11 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08TDr8mc026310;
        Tue, 29 Sep 2020 13:59:10 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03dal.us.ibm.com with ESMTP id 33sw99bqj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Sep 2020 13:59:10 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08TDx7HZ56230288
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Sep 2020 13:59:07 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1CD913605D;
        Tue, 29 Sep 2020 13:59:06 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 655E6136055;
        Tue, 29 Sep 2020 13:59:05 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.170.177])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 29 Sep 2020 13:59:05 +0000 (GMT)
Subject: Re: [PATCH v10 04/16] s390/zcrypt: driver callback to indicate
 resource in use
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
 <20200821195616.13554-5-akrowiak@linux.ibm.com>
 <20200925112410.4134faae.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <054d609b-1c90-96c0-2e42-777edfa45f4b@linux.ibm.com>
Date:   Tue, 29 Sep 2020 09:59:04 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200925112410.4134faae.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_04:2020-09-29,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 impostorscore=0 adultscore=0 spamscore=0
 bulkscore=0 priorityscore=1501 mlxlogscore=999 mlxscore=0 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009290119
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/25/20 5:24 AM, Halil Pasic wrote:
> On Fri, 21 Aug 2020 15:56:04 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
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
>>
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
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> Reported-by: kernel test robot <lkp@intel.com>
>> ---
>>   drivers/s390/crypto/ap_bus.c | 148 ++++++++++++++++++++++++++++++++---
>>   drivers/s390/crypto/ap_bus.h |   4 +
>>   2 files changed, 142 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
>> index 24a1940b829e..db27bd931308 100644
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
>> @@ -889,6 +890,23 @@ static int modify_bitmap(const char *str, unsigned long *bitmap, int bits)
>>   	return 0;
>>   }
>>   
>> +static int ap_parse_bitmap_str(const char *str, unsigned long *bitmap, int bits,
>> +			       unsigned long *newmap)
>> +{
>> +	unsigned long size;
>> +	int rc;
>> +
>> +	size = BITS_TO_LONGS(bits)*sizeof(unsigned long);
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
>> @@ -908,14 +926,7 @@ int ap_parse_mask_str(const char *str,
>>   		kfree(newmap);
>>   		return -ERESTARTSYS;
>>   	}
>> -
>> -	if (*str == '+' || *str == '-') {
>> -		memcpy(newmap, bitmap, size);
>> -		rc = modify_bitmap(str, newmap, bits);
>> -	} else {
>> -		memset(newmap, 0, size);
>> -		rc = hex2bitmap(str, newmap, bits);
>> -	}
>> +	rc = ap_parse_bitmap_str(str, bitmap, bits, newmap);
>>   	if (rc == 0)
>>   		memcpy(bitmap, newmap, size);
>>   	mutex_unlock(lock);
>> @@ -1107,12 +1118,70 @@ static ssize_t apmask_show(struct bus_type *bus, char *buf)
>>   	return rc;
>>   }
>>   
>> +static int __verify_card_reservations(struct device_driver *drv, void *data)
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
>> +	/* The non-default driver's module must be loaded */
>> +	if (!try_module_get(drv->owner))
>> +		return 0;
>> +
>> +	if (ap_drv->in_use)
>> +		if (ap_drv->in_use(newapm, ap_perms.aqm))
>> +			rc = -EADDRINUSE;
>> +
>> +	module_put(drv->owner);
>> +
>> +	return rc;
>> +}
>> +
>> +static int apmask_commit(unsigned long *newapm)
>> +{
>> +	int rc;
>> +	unsigned long reserved[BITS_TO_LONGS(AP_DEVICES)];
>> +
>> +	/*
>> +	 * Check if any bits in the apmask have been set which will
>> +	 * result in queues being removed from non-default drivers
>> +	 */
>> +	if (bitmap_andnot(reserved, newapm, ap_perms.apm, AP_DEVICES)) {
>> +		rc = bus_for_each_drv(&ap_bus_type, NULL, reserved,
>> +				      __verify_card_reservations);
>> +		if (rc)
>> +			return rc;
>> +	}
> I understand the above asks all the non-default drivers if some of the
> queues are 'used'. But AFAIU this reflects the truth ap_drv->in_use()
> is only telling us something about a given moment...
>
>> +
>> +	memcpy(ap_perms.apm, newapm, APMASKSIZE);
> ... So I fail to understand what will prevent us from performing a
> successful commit if some of the resources become 'used' between
> the call to the in_use() callback and the memcpy.

So, the scenario you describe would go something like this:
1. User changes apmask or aqmask attempting to take
     queue xx.yyyy away from the vfio_ap driver.
2. The in_use callback does not detect the affected
     queues to be in use (i.e., it is not assigned to an mdev).
3. Another user assigns queue xx.yyyy to an mdev
4. The memcpy is performed and ownership of xx.yyyy is
     transferred to the host.
5. Afterward, the queues are reprobed which results in the
     remove callback on the vfio_ap driver for xx.yyyy and the
     probe callback on the cex4queue driver for xx.yyyy.

You are correct, there is nothing preventing a resource from becoming
'used' between the in_use callback and the memcpy. While the
above scenario could be considered a circumvention of the
intent of this design, the result would be no different than if
the in_use callback was not implemented at all. When the
remove callback is invoked for xx.yyyy on the vfio_ap driver
due to the reprobe, the queue will be released.

The chances of this scenario occurring are probably quite tiny
given the timing of two root users almost simultaneously
taking the required actions in the time it takes the verification
loop to complete and the mask to be copied. I suppose this
could happen if there are a great number of mdevs or a very large
number of queues bound to the vfio_ap driver, but this scenario
seems very unlikely.

>
> Of course I might be wrong.
>
> BTW I was never a fan of this mechanism, so I don't mind if it
> does not work perfectly, and this should catch most of the cases. Just
> want to make sure we don't introduce more confusion than necessary.
>
>> +
>> +	return 0;
>> +}
>> +
>>   static ssize_t apmask_store(struct bus_type *bus, const char *buf,
>>   			    size_t count)
>>   {
>>   	int rc;
>> +	DECLARE_BITMAP(newapm, AP_DEVICES);
>> +
>> +	if (mutex_lock_interruptible(&ap_perms_mutex))
>> +		return -ERESTARTSYS;
>> +
>> +	rc = ap_parse_bitmap_str(buf, ap_perms.apm, AP_DEVICES, newapm);
>> +	if (rc)
>> +		goto done;
>>   
>> -	rc = ap_parse_mask_str(buf, ap_perms.apm, AP_DEVICES, &ap_perms_mutex);
>> +	rc = apmask_commit(newapm);
>> +
>> +done:
>> +	mutex_unlock(&ap_perms_mutex);
>>   	if (rc)
>>   		return rc;
>>   
>> @@ -1138,12 +1207,71 @@ static ssize_t aqmask_show(struct bus_type *bus, char *buf)
>>   	return rc;
>>   }
>>   
>> +static int __verify_queue_reservations(struct device_driver *drv, void *data)
>> +{
>> +	int rc = 0;
>> +	struct ap_driver *ap_drv = to_ap_drv(drv);
>> +	unsigned long *newaqm = (unsigned long *)data;
>> +
>> +	/*
>> +	 * If the reserved bits do not identify queues reserved for use by the
>> +	 * non-default driver, there is no need to verify the driver is using
>> +	 * the queues.
>> +	 */
>> +	if (ap_drv->flags & AP_DRIVER_FLAG_DEFAULT)
>> +		return 0;
>> +
>> +	/* The non-default driver's module must be loaded */
>> +	if (!try_module_get(drv->owner))
>> +		return 0;
>> +
>> +	if (ap_drv->in_use)
>> +		if (ap_drv->in_use(ap_perms.apm, newaqm))
>> +			rc = -EADDRINUSE;
>> +
>> +	module_put(drv->owner);
>> +
>> +	return rc;
>> +}
>> +
>> +static int aqmask_commit(unsigned long *newaqm)
>> +{
>> +	int rc;
>> +	unsigned long reserved[BITS_TO_LONGS(AP_DOMAINS)];
>> +
>> +	/*
>> +	 * Check if any bits in the aqmask have been set which will
>> +	 * result in queues being removed from non-default drivers
>> +	 */
>> +	if (bitmap_andnot(reserved, newaqm, ap_perms.aqm, AP_DOMAINS)) {
>> +		rc = bus_for_each_drv(&ap_bus_type, NULL, reserved,
>> +				      __verify_queue_reservations);
>> +		if (rc)
>> +			return rc;
>> +	}
>> +
>> +	memcpy(ap_perms.aqm, newaqm, AQMASKSIZE);
>> +
> Same here.
>
> Regards,
> Halil
>
>> +	return 0;
>> +}
>> +
>>   static ssize_t aqmask_store(struct bus_type *bus, const char *buf,
>>   			    size_t count)
>>   {
>>   	int rc;
>> +	DECLARE_BITMAP(newaqm, AP_DOMAINS);
>>   
>> -	rc = ap_parse_mask_str(buf, ap_perms.aqm, AP_DOMAINS, &ap_perms_mutex);
>> +	if (mutex_lock_interruptible(&ap_perms_mutex))
>> +		return -ERESTARTSYS;
>> +
>> +	rc = ap_parse_bitmap_str(buf, ap_perms.aqm, AP_DOMAINS, newaqm);
>> +	if (rc)
>> +		goto done;
>> +
>> +	rc = aqmask_commit(newaqm);
>> +
>> +done:
>> +	mutex_unlock(&ap_perms_mutex);
>>   	if (rc)
>>   		return rc;
>>   
>> diff --git a/drivers/s390/crypto/ap_bus.h b/drivers/s390/crypto/ap_bus.h
>> index 1ea046324e8f..48c57b3d53a0 100644
>> --- a/drivers/s390/crypto/ap_bus.h
>> +++ b/drivers/s390/crypto/ap_bus.h
>> @@ -136,6 +136,7 @@ struct ap_driver {
>>   
>>   	int (*probe)(struct ap_device *);
>>   	void (*remove)(struct ap_device *);
>> +	bool (*in_use)(unsigned long *apm, unsigned long *aqm);
>>   };
>>   
>>   #define to_ap_drv(x) container_of((x), struct ap_driver, driver)
>> @@ -255,6 +256,9 @@ void ap_queue_init_state(struct ap_queue *aq);
>>   struct ap_card *ap_card_create(int id, int queue_depth, int raw_device_type,
>>   			       int comp_device_type, unsigned int functions);
>>   
>> +#define APMASKSIZE (BITS_TO_LONGS(AP_DEVICES) * sizeof(unsigned long))
>> +#define AQMASKSIZE (BITS_TO_LONGS(AP_DOMAINS) * sizeof(unsigned long))
>> +
>>   struct ap_perms {
>>   	unsigned long ioctlm[BITS_TO_LONGS(AP_IOCTLS)];
>>   	unsigned long apm[BITS_TO_LONGS(AP_DEVICES)];

