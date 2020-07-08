Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8826B218740
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 14:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729041AbgGHM11 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 08:27:27 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31682 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728965AbgGHM11 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Jul 2020 08:27:27 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 068C1niJ130373;
        Wed, 8 Jul 2020 08:27:25 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3251mvcdt9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jul 2020 08:27:25 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 068C1o46130411;
        Wed, 8 Jul 2020 08:27:24 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3251mvcdrh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jul 2020 08:27:24 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 068CQN7a013903;
        Wed, 8 Jul 2020 12:27:22 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 322hd84nk4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jul 2020 12:27:22 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 068CRJQn59900034
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Jul 2020 12:27:19 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4EAD6AE053;
        Wed,  8 Jul 2020 12:27:19 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B29DAE051;
        Wed,  8 Jul 2020 12:27:18 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.16.21])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Jul 2020 12:27:18 +0000 (GMT)
Subject: Re: [PATCH v8 04/16] s390/zcrypt: driver callback to indicate
 resource in use
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
References: <20200605214004.14270-1-akrowiak@linux.ibm.com>
 <20200605214004.14270-5-akrowiak@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 nS4h0HDFPrrp1C2EMVYIQrMokWvlFZbCpsdYbBI=
Message-ID: <d7954c15-b14f-d6e5-0193-aadca61883a8@de.ibm.com>
Date:   Wed, 8 Jul 2020 14:27:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200605214004.14270-5-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-08_08:2020-07-08,2020-07-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 adultscore=0 suspectscore=0 cotscore=-2147483648
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501
 phishscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2007080084
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05.06.20 23:39, Tony Krowiak wrote:
> Introduces a new driver callback to prevent a root user from unbinding
> an AP queue from its device driver if the queue is in use. The intent of
> this callback is to provide a driver with the means to prevent a root user
> from inadvertently taking a queue away from a matrix mdev and giving it to
> the host while it is assigned to the matrix mdev. The callback will
> be invoked whenever a change to the AP bus's sysfs apmask or aqmask
> attributes would result in one or more AP queues being removed from its
> driver. If the callback responds in the affirmative for any driver
> queried, the change to the apmask or aqmask will be rejected with a device
> in use error.

The alternative would be to tear down the connection in the matrix mdev in this
callback (so that the guest will see a hot unplug), but actually making this
a more conscious decision (requiring 2 steps from the host admin) is certainly
also fine.


> 
> For this patch, only non-default drivers will be queried. Currently,
> there is only one non-default driver, the vfio_ap device driver. The
> vfio_ap device driver facilitates pass-through of an AP queue to a
> guest. The idea here is that a guest may be administered by a different
> sysadmin than the host and we don't want AP resources to unexpectedly
> disappear from a guest's AP configuration (i.e., adapters, domains and
> control domains assigned to the matrix mdev). This will enforce the proper
> procedure for removing AP resources intended for guest usage which is to
> first unassign them from the matrix mdev, then unbind them from the
> vfio_ap device driver.

What I said above, we can force a hot unplug to the guest, but we require
to do 2 steps. I think this is fine.


> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/ap_bus.c | 148 ++++++++++++++++++++++++++++++++---
>  drivers/s390/crypto/ap_bus.h |   4 +
>  2 files changed, 142 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
> index e71ca4a719a5..40cb5861dad3 100644
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
> @@ -876,6 +877,23 @@ static int modify_bitmap(const char *str, unsigned long *bitmap, int bits)
>  	return 0;
>  }
>  
> +static int ap_parse_bitmap_str(const char *str, unsigned long *bitmap, int bits,
> +			       unsigned long *newmap)
> +{
> +	unsigned long size;
> +	int rc;
> +
> +	size = BITS_TO_LONGS(bits)*sizeof(unsigned long);                                  ^ ^ spaces around the *
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
> @@ -895,14 +913,7 @@ int ap_parse_mask_str(const char *str,
>  		kfree(newmap);
>  		return -ERESTARTSYS;
>  	}
> -
> -	if (*str == '+' || *str == '-') {
> -		memcpy(newmap, bitmap, size);

Do we still need the size variable in here?

> -		rc = modify_bitmap(str, newmap, bits);
> -	} else {
> -		memset(newmap, 0, size);
> -		rc = hex2bitmap(str, newmap, bits);
> -	}
> +	rc = ap_parse_bitmap_str(str, bitmap, bits, newmap);
>  	if (rc == 0)
>  		memcpy(bitmap, newmap, size);
>  	mutex_unlock(lock);
> @@ -1092,12 +1103,70 @@ static ssize_t apmask_show(struct bus_type *bus, char *buf)
>  	return rc;
>  }
>  
> +int __verify_card_reservations(struct device_driver *drv, void *data)
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
> +	/* The non-default driver's module must be loaded */> +	if (!try_module_get(drv->owner))
> +		return 0;
> +
> +	if (ap_drv->in_use)
> +		if (ap_drv->in_use(newapm, ap_perms.aqm))
> +			rc = -EADDRINUSE;

I think -EBUSY is more appropriate.  (also in the other places)

