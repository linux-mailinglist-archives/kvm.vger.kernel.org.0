Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8659A29BEB2
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 17:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1814498AbgJ0Q4g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 12:56:36 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57036 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1813844AbgJ0Qz2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Oct 2020 12:55:28 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09RGWsEY157992;
        Tue, 27 Oct 2020 12:55:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=uD/CK7aYQgFaw4WqbJSs4YbvZ4TxFFPTUTUT3SgWHVY=;
 b=nG8PSTwioWoRs6PRs/PS3Gn4BQcLxs8tyV8VEpyyXPxRz9+Jn+fqA3YbEBYOh/OXQ5P0
 VABaF8P07I3OQceejgifSHGAM425WeC7sxJldTLzTHOyuEo6yQNHfRz+gtIE4bpBu6zn
 iB0JsDPcxsMXSfD1XJt9J6zykoYzlSKL5PWDVK4KfIWgkQWLNfRMXb55qfuxbo72s32u
 SAxu7qo5RAhbG+SdTNCYXREr5WpbZoaJx8JYRqphqYe3vkw0dT/lpH+1JJ9P1nJJCi5s
 oJSvE+dWcbjPZeNbnmq/3AVVvA5lI/hQwgdJFSUOIutcfZtyDe/xXF33vWUW7YbH+s7n bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34ejb6m0ey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Oct 2020 12:55:24 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09RGXKTS160959;
        Tue, 27 Oct 2020 12:55:24 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34ejb6m0e0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Oct 2020 12:55:24 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09RGr1rM014482;
        Tue, 27 Oct 2020 16:55:22 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 34cbhh3k5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Oct 2020 16:55:22 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09RGtJvC28377420
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 16:55:19 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9EDF842047;
        Tue, 27 Oct 2020 16:55:19 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A47C442042;
        Tue, 27 Oct 2020 16:55:18 +0000 (GMT)
Received: from funtu.home (unknown [9.171.1.97])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 27 Oct 2020 16:55:18 +0000 (GMT)
Subject: Re: [PATCH v11 04/14] s390/zcrypt: driver callback to indicate
 resource in use
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, hca@linux.ibm.com, gor@linux.ibm.com
References: <20201022171209.19494-1-akrowiak@linux.ibm.com>
 <20201022171209.19494-5-akrowiak@linux.ibm.com>
From:   Harald Freudenberger <freude@linux.ibm.com>
Message-ID: <42f3f4f9-6263-cb1e-d882-30b62236a594@linux.ibm.com>
Date:   Tue, 27 Oct 2020 17:55:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201022171209.19494-5-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-27_10:2020-10-26,2020-10-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 bulkscore=0
 mlxscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0 impostorscore=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270098
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22.10.20 19:11, Tony Krowiak wrote:
> Introduces a new driver callback to prevent a root user from unbinding
> an AP queue from its device driver if the queue is in use. The callback
> will be invoked whenever a change to the AP bus's sysfs apmask or aqmask
> attributes would result in one or more AP queues being removed from its
> driver. If the callback responds in the affirmative for any driver
> queried, the change to the apmask or aqmask will be rejected with a device
> in use error.
>
> For this patch, only non-default drivers will be queried. Currently,
> there is only one non-default driver, the vfio_ap device driver. The
> vfio_ap device driver facilitates pass-through of an AP queue to a
> guest. The idea here is that a guest may be administered by a different
> sysadmin than the host and we don't want AP resources to unexpectedly
> disappear from a guest's AP configuration (i.e., adapters and domains
> assigned to the matrix mdev). This will enforce the proper procedure for
> removing AP resources intended for guest usage which is to
> first unassign them from the matrix mdev, then unbind them from the
> vfio_ap device driver.
>
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/ap_bus.c | 148 ++++++++++++++++++++++++++++++++---
>  drivers/s390/crypto/ap_bus.h |   4 +
>  2 files changed, 142 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
> index 485cbfcbf06e..998e61cd86d9 100644
> --- a/drivers/s390/crypto/ap_bus.c
> +++ b/drivers/s390/crypto/ap_bus.c
> @@ -35,6 +35,7 @@
>  #include <linux/mod_devicetable.h>
>  #include <linux/debugfs.h>
>  #include <linux/ctype.h>
> +#include <linux/module.h>
>  
>  #include "ap_bus.h"
>  #include "ap_debug.h"
> @@ -893,6 +894,23 @@ static int modify_bitmap(const char *str, unsigned long *bitmap, int bits)
>  	return 0;
>  }
>  
> +static int ap_parse_bitmap_str(const char *str, unsigned long *bitmap, int bits,
> +			       unsigned long *newmap)
> +{
> +	unsigned long size;
> +	int rc;
> +
> +	size = BITS_TO_LONGS(bits)*sizeof(unsigned long);
> +	if (*str == '+' || *str == '-') {
> +		memcpy(newmap, bitmap, size);
> +		rc = modify_bitmap(str, newmap, bits);
> +	} else {
> +		memset(newmap, 0, size);
> +		rc = hex2bitmap(str, newmap, bits);
> +	}
> +	return rc;
> +}
> +
>  int ap_parse_mask_str(const char *str,
>  		      unsigned long *bitmap, int bits,
>  		      struct mutex *lock)
> @@ -912,14 +930,7 @@ int ap_parse_mask_str(const char *str,
>  		kfree(newmap);
>  		return -ERESTARTSYS;
>  	}
> -
> -	if (*str == '+' || *str == '-') {
> -		memcpy(newmap, bitmap, size);
> -		rc = modify_bitmap(str, newmap, bits);
> -	} else {
> -		memset(newmap, 0, size);
> -		rc = hex2bitmap(str, newmap, bits);
> -	}
> +	rc = ap_parse_bitmap_str(str, bitmap, bits, newmap);
>  	if (rc == 0)
>  		memcpy(bitmap, newmap, size);
>  	mutex_unlock(lock);
> @@ -1111,12 +1122,70 @@ static ssize_t apmask_show(struct bus_type *bus, char *buf)
>  	return rc;
>  }
>  
> +static int __verify_card_reservations(struct device_driver *drv, void *data)
> +{
> +	int rc = 0;
> +	struct ap_driver *ap_drv = to_ap_drv(drv);
> +	unsigned long *newapm = (unsigned long *)data;
> +
> +	/*
> +	 * No need to verify whether the driver is using the queues if it is the
> +	 * default driver.
> +	 */
> +	if (ap_drv->flags & AP_DRIVER_FLAG_DEFAULT)
> +		return 0;
> +
> +	/* The non-default driver's module must be loaded */
Can you please update this comment? It should be something like
/* increase the driver's module refcounter to be sure it is not
   going away when we invoke the callback function. */

> +	if (!try_module_get(drv->owner))
> +		return 0;
> +
> +	if (ap_drv->in_use)
> +		if (ap_drv->in_use(newapm, ap_perms.aqm))
> +			rc = -EBUSY;
> +
And here: /* release driver's module */ or simmilar
> +	module_put(drv->owner);
> +
> +	return rc;
> +}
> +
> +static int apmask_commit(unsigned long *newapm)
> +{
> +	int rc;
> +	unsigned long reserved[BITS_TO_LONGS(AP_DEVICES)];
> +
> +	/*
> +	 * Check if any bits in the apmask have been set which will
> +	 * result in queues being removed from non-default drivers
> +	 */
> +	if (bitmap_andnot(reserved, newapm, ap_perms.apm, AP_DEVICES)) {
> +		rc = bus_for_each_drv(&ap_bus_type, NULL, reserved,
> +				      __verify_card_reservations);
> +		if (rc)
> +			return rc;
> +	}
> +
> +	memcpy(ap_perms.apm, newapm, APMASKSIZE);
> +
> +	return 0;
> +}
> +
>  static ssize_t apmask_store(struct bus_type *bus, const char *buf,
>  			    size_t count)
>  {
>  	int rc;
> +	DECLARE_BITMAP(newapm, AP_DEVICES);
> +
> +	if (mutex_lock_interruptible(&ap_perms_mutex))
> +		return -ERESTARTSYS;
> +
> +	rc = ap_parse_bitmap_str(buf, ap_perms.apm, AP_DEVICES, newapm);
> +	if (rc)
> +		goto done;
>  
> -	rc = ap_parse_mask_str(buf, ap_perms.apm, AP_DEVICES, &ap_perms_mutex);
> +	rc = apmask_commit(newapm);
> +
> +done:
> +	mutex_unlock(&ap_perms_mutex);
>  	if (rc)
>  		return rc;
>  
> @@ -1142,12 +1211,71 @@ static ssize_t aqmask_show(struct bus_type *bus, char *buf)
>  	return rc;
>  }
>  
> +static int __verify_queue_reservations(struct device_driver *drv, void *data)
> +{
> +	int rc = 0;
> +	struct ap_driver *ap_drv = to_ap_drv(drv);
> +	unsigned long *newaqm = (unsigned long *)data;
> +
> +	/*
> +	 * If the reserved bits do not identify queues reserved for use by the
> +	 * non-default driver, there is no need to verify the driver is using
> +	 * the queues.
> +	 */
> +	if (ap_drv->flags & AP_DRIVER_FLAG_DEFAULT)
> +		return 0;
> +
> +	/* The non-default driver's module must be loaded */
Same here.
> +	if (!try_module_get(drv->owner))
> +		return 0;
> +
> +	if (ap_drv->in_use)
> +		if (ap_drv->in_use(ap_perms.apm, newaqm))
> +			rc = -EBUSY;
> +
and here
> +	module_put(drv->owner);
> +
> +	return rc;
> +}
> +
> +static int aqmask_commit(unsigned long *newaqm)
> +{
> +	int rc;
> +	unsigned long reserved[BITS_TO_LONGS(AP_DOMAINS)];
> +
> +	/*
> +	 * Check if any bits in the aqmask have been set which will
> +	 * result in queues being removed from non-default drivers
> +	 */
> +	if (bitmap_andnot(reserved, newaqm, ap_perms.aqm, AP_DOMAINS)) {
> +		rc = bus_for_each_drv(&ap_bus_type, NULL, reserved,
> +				      __verify_queue_reservations);
> +		if (rc)
> +			return rc;
> +	}
> +
> +	memcpy(ap_perms.aqm, newaqm, AQMASKSIZE);
> +
> +	return 0;
> +}
> +
>  static ssize_t aqmask_store(struct bus_type *bus, const char *buf,
>  			    size_t count)
>  {
>  	int rc;
> +	DECLARE_BITMAP(newaqm, AP_DOMAINS);
>  
> -	rc = ap_parse_mask_str(buf, ap_perms.aqm, AP_DOMAINS, &ap_perms_mutex);
> +	if (mutex_lock_interruptible(&ap_perms_mutex))
> +		return -ERESTARTSYS;
> +
> +	rc = ap_parse_bitmap_str(buf, ap_perms.aqm, AP_DOMAINS, newaqm);
> +	if (rc)
> +		goto done;
> +
> +	rc = aqmask_commit(newaqm);
> +
> +done:
> +	mutex_unlock(&ap_perms_mutex);
>  	if (rc)
>  		return rc;
>  
> diff --git a/drivers/s390/crypto/ap_bus.h b/drivers/s390/crypto/ap_bus.h
> index 5029b80132aa..6ce154d924d3 100644
> --- a/drivers/s390/crypto/ap_bus.h
> +++ b/drivers/s390/crypto/ap_bus.h
> @@ -145,6 +145,7 @@ struct ap_driver {
>  
>  	int (*probe)(struct ap_device *);
>  	void (*remove)(struct ap_device *);
> +	bool (*in_use)(unsigned long *apm, unsigned long *aqm);
>  };
>  
>  #define to_ap_drv(x) container_of((x), struct ap_driver, driver)
> @@ -293,6 +294,9 @@ void ap_queue_init_state(struct ap_queue *aq);
>  struct ap_card *ap_card_create(int id, int queue_depth, int raw_device_type,
>  			       int comp_device_type, unsigned int functions);
>  
> +#define APMASKSIZE (BITS_TO_LONGS(AP_DEVICES) * sizeof(unsigned long))
> +#define AQMASKSIZE (BITS_TO_LONGS(AP_DOMAINS) * sizeof(unsigned long))
> +
>  struct ap_perms {
>  	unsigned long ioctlm[BITS_TO_LONGS(AP_IOCTLS)];
>  	unsigned long apm[BITS_TO_LONGS(AP_DEVICES)];
I still don't like this code. That's because of what it is doing - not because of the code quality.
And Halil, you are right. It is adding more pressure to the mutex used for locking the apmask
and aqmask stuff (and the zcrypt multiple device drivers support code also).
I am very concerned about the in_use callback which is called with the ap_perms_mutex
held AND during bus_for_each_drv (so holding the overall AP BUS mutex) and then diving
into the vfio_ap ... with yet another mutex to protect the vfio structs.
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
