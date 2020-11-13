Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5170F2B26CA
	for <lists+kvm@lfdr.de>; Fri, 13 Nov 2020 22:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgKMVay (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 16:30:54 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47824 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725885AbgKMVao (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Nov 2020 16:30:44 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0ADL2sT3019504;
        Fri, 13 Nov 2020 16:30:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=snyK0uCXlSYEhWgBVbNlWfSW7v+aaXHbYQSKhsCnA4c=;
 b=lZAO/PkkvKjSc1xwUPDxbUv8rDtbC83IE6ahB6xynyIG2T+Wid4Hp7z0mRxfs15pT/Fu
 LwJklwc9vgqNcSmtnCmCRI00e2vPGpEuijfVQuBbaRgW0oQbUSyCavE3DFfWBLlNhHc0
 VXZ+x9bxwkzBoZGqhwBFozEHXjN0xGhwd+qRuFG2locgl9l2nPLyovLRBx5TuyJydhgW
 cMng4ZfyHy+T4RzX5dTXSX7ZfGTI59oAex/45Fiq3XAhbCCCntKmZh3eiB44AdCg41gI
 bPlJEOheTL/vxjSHF/7Mq7siwyzXt6gaHmD9Lkc6ZUTQH707OxOfPoQXcoVfz1Iysahd 4Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34t0hu2ksk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Nov 2020 16:30:38 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0ADLR1bf101936;
        Fri, 13 Nov 2020 16:30:38 -0500
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34t0hu2ksa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Nov 2020 16:30:38 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0ADLLr6E006401;
        Fri, 13 Nov 2020 21:30:37 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma02dal.us.ibm.com with ESMTP id 34nk7akf9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Nov 2020 21:30:37 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0ADLUY0R11993718
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Nov 2020 21:30:34 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EDAA06A04D;
        Fri, 13 Nov 2020 21:30:33 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86DE46A051;
        Fri, 13 Nov 2020 21:30:32 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.152.80])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 13 Nov 2020 21:30:32 +0000 (GMT)
Subject: Re: [PATCH v11 04/14] s390/zcrypt: driver callback to indicate
 resource in use
To:     Harald Freudenberger <freude@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, hca@linux.ibm.com, gor@linux.ibm.com
References: <20201022171209.19494-1-akrowiak@linux.ibm.com>
 <20201022171209.19494-5-akrowiak@linux.ibm.com>
 <42f3f4f9-6263-cb1e-d882-30b62236a594@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <dcdb9c78-daf8-1f25-f59a-903f0db96ada@linux.ibm.com>
Date:   Fri, 13 Nov 2020 16:30:31 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <42f3f4f9-6263-cb1e-d882-30b62236a594@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-13_19:2020-11-13,2020-11-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 phishscore=0 clxscore=1015
 impostorscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011130131
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/27/20 12:55 PM, Harald Freudenberger wrote:
> On 22.10.20 19:11, Tony Krowiak wrote:
>> Introduces a new driver callback to prevent a root user from unbinding
>> an AP queue from its device driver if the queue is in use. The callback
>> will be invoked whenever a change to the AP bus's sysfs apmask or aqmask
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
>> disappear from a guest's AP configuration (i.e., adapters and domains
>> assigned to the matrix mdev). This will enforce the proper procedure for
>> removing AP resources intended for guest usage which is to
>> first unassign them from the matrix mdev, then unbind them from the
>> vfio_ap device driver.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/ap_bus.c | 148 ++++++++++++++++++++++++++++++++---
>>   drivers/s390/crypto/ap_bus.h |   4 +
>>   2 files changed, 142 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
>> index 485cbfcbf06e..998e61cd86d9 100644
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
>> @@ -893,6 +894,23 @@ static int modify_bitmap(const char *str, unsigned long *bitmap, int bits)
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
>> @@ -912,14 +930,7 @@ int ap_parse_mask_str(const char *str,
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
>> @@ -1111,12 +1122,70 @@ static ssize_t apmask_show(struct bus_type *bus, char *buf)
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
> Can you please update this comment? It should be something like
> /* increase the driver's module refcounter to be sure it is not
>     going away when we invoke the callback function. */

Will do.

>
>> +	if (!try_module_get(drv->owner))
>> +		return 0;
>> +
>> +	if (ap_drv->in_use)
>> +		if (ap_drv->in_use(newapm, ap_perms.aqm))
>> +			rc = -EBUSY;
>> +
> And here: /* release driver's module */ or simmilar

Okay

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
>> +
>> +	memcpy(ap_perms.apm, newapm, APMASKSIZE);
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
>> @@ -1142,12 +1211,71 @@ static ssize_t aqmask_show(struct bus_type *bus, char *buf)
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
> Same here.

Okay

>> +	if (!try_module_get(drv->owner))
>> +		return 0;
>> +
>> +	if (ap_drv->in_use)
>> +		if (ap_drv->in_use(ap_perms.apm, newaqm))
>> +			rc = -EBUSY;
>> +
> and here

Okay

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
>> index 5029b80132aa..6ce154d924d3 100644
>> --- a/drivers/s390/crypto/ap_bus.h
>> +++ b/drivers/s390/crypto/ap_bus.h
>> @@ -145,6 +145,7 @@ struct ap_driver {
>>   
>>   	int (*probe)(struct ap_device *);
>>   	void (*remove)(struct ap_device *);
>> +	bool (*in_use)(unsigned long *apm, unsigned long *aqm);
>>   };
>>   
>>   #define to_ap_drv(x) container_of((x), struct ap_driver, driver)
>> @@ -293,6 +294,9 @@ void ap_queue_init_state(struct ap_queue *aq);
>>   struct ap_card *ap_card_create(int id, int queue_depth, int raw_device_type,
>>   			       int comp_device_type, unsigned int functions);
>>   
>> +#define APMASKSIZE (BITS_TO_LONGS(AP_DEVICES) * sizeof(unsigned long))
>> +#define AQMASKSIZE (BITS_TO_LONGS(AP_DOMAINS) * sizeof(unsigned long))
>> +
>>   struct ap_perms {
>>   	unsigned long ioctlm[BITS_TO_LONGS(AP_IOCTLS)];
>>   	unsigned long apm[BITS_TO_LONGS(AP_DEVICES)];
> I still don't like this code. That's because of what it is doing - not because of the code quality.
> And Halil, you are right. It is adding more pressure to the mutex used for locking the apmask
> and aqmask stuff (and the zcrypt multiple device drivers support code also).
> I am very concerned about the in_use callback which is called with the ap_perms_mutex
> held AND during bus_for_each_drv (so holding the overall AP BUS mutex) and then diving
> into the vfio_ap ... with yet another mutex to protect the vfio structs.
> Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>

Thank you for your review. Maybe you ought to bring these concerns up with
our crypto architect. Halil came up with a solution for the potential 
deadlock
situation. We will be using the mutex_trylock() function in our sysfs 
assignment
interfaces which make the call to the AP bus to check permissions (which 
also
locks ap_perms). If the mutex_trylock() fails, we return from the assignment
function with -EBUSY. This should resolve that potential deadlock issue.


