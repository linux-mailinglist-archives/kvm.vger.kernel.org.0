Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2887044522E
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 12:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbhKDLaF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 07:30:05 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40534 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229705AbhKDLaE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Nov 2021 07:30:04 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A4AlOJ6004589;
        Thu, 4 Nov 2021 11:27:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=fYrXFm65Klb4z912RpG/K9fLuFdTpkSX+Z6cVddfAuo=;
 b=M6VutEAuJMXJaksC+Fwe+t9Deahob9fuEFo7mRtgIajada0TZTrfkFSDDpDOz5G7+y5e
 9uZtWFnG/cb81tk63U0MV2c98iznnC5SBXPwsWKnktloRv3vAGMzOI10f7VFpsqLjaNn
 tV7v95WILojj76jDzXM2IXEdB7msPHIRwfLI4xPjncxk1HVOcxksmSiorEK1/+Bob1kh
 3KdMoeCYaybRjRgSBHIu0Q65r+i/l2OQ1vrQwA0ZK/v5oKnCt0X09Ma0MeHVVLhLxfuv
 ly2B+SWEwFsLxH5OpADuwTvZMOmpOInEQerrn2ddayEhvygiu8Y+pctCT4qxo7IlfZRX FQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c4e2x0pgy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Nov 2021 11:27:24 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1A4BRLhW005056;
        Thu, 4 Nov 2021 11:27:24 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c4e2x0pge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Nov 2021 11:27:23 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A4BD4Av016087;
        Thu, 4 Nov 2021 11:27:21 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3c0wpb6e4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Nov 2021 11:27:21 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A4BRHRK48693710
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 Nov 2021 11:27:17 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5043AE04D;
        Thu,  4 Nov 2021 11:27:17 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BCB29AE053;
        Thu,  4 Nov 2021 11:27:16 +0000 (GMT)
Received: from funtu.home (unknown [9.145.185.82])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  4 Nov 2021 11:27:16 +0000 (GMT)
Subject: Re: [PATCH v17 11/15] s390/ap: driver callback to indicate resource
 in use
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20211021152332.70455-1-akrowiak@linux.ibm.com>
 <20211021152332.70455-12-akrowiak@linux.ibm.com>
From:   Harald Freudenberger <freude@linux.ibm.com>
Message-ID: <15a87038-a88c-b29e-f7d7-760ca27c87cf@linux.ibm.com>
Date:   Thu, 4 Nov 2021 12:27:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211021152332.70455-12-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: I7kePiBWxLWjtZ-2rJ0_zfjY3we0LjZi
X-Proofpoint-ORIG-GUID: fFhU-mOVSMVqNVErIZ8T1mOeZ9s1xZ8Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-04_03,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 priorityscore=1501 clxscore=1011 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111040046
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21.10.21 17:23, Tony Krowiak wrote:
> Introduces a new driver callback to prevent a root user from re-assigning
> the APQN of a queue that is in use by a non-default host device driver to
> a default host device driver and vice versa. The callback will be invoked
> whenever a change to the AP bus's sysfs apmask or aqmask attributes would
> result in one or more APQNs being re-assigned. If the callback responds
> in the affirmative for any driver queried, the change to the apmask or
> aqmask will be rejected with a device busy error.
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
> Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
> Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
> ---
>  drivers/s390/crypto/ap_bus.c | 160 ++++++++++++++++++++++++++++++++---
>  drivers/s390/crypto/ap_bus.h |   4 +
>  2 files changed, 154 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
> index d9b804943d19..15886610f61a 100644
> --- a/drivers/s390/crypto/ap_bus.c
> +++ b/drivers/s390/crypto/ap_bus.c
> @@ -36,6 +36,7 @@
>  #include <linux/mod_devicetable.h>
>  #include <linux/debugfs.h>
>  #include <linux/ctype.h>
> +#include <linux/module.h>
>  
>  #include "ap_bus.h"
>  #include "ap_debug.h"
> @@ -1060,6 +1061,23 @@ static int modify_bitmap(const char *str, unsigned long *bitmap, int bits)
>  	return 0;
>  }
>  
> +static int ap_parse_bitmap_str(const char *str, unsigned long *bitmap, int bits,
> +			       unsigned long *newmap)
> +{
> +	unsigned long size;
> +	int rc;
> +
> +	size = BITS_TO_LONGS(bits) * sizeof(unsigned long);
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
> @@ -1079,14 +1097,7 @@ int ap_parse_mask_str(const char *str,
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
> @@ -1278,12 +1289,76 @@ static ssize_t apmask_show(struct bus_type *bus, char *buf)
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
> +	/*
> +	 * increase the driver's module refcounter to be sure it is not
> +	 * going away when we invoke the callback function.
> +	 */
> +	if (!try_module_get(drv->owner))
> +		return 0;
> +
> +	if (ap_drv->in_use) {
> +		rc = ap_drv->in_use(newapm, ap_perms.aqm);
> +		if (rc)
> +			rc = -EBUSY;
> +	}
> +
> +	/* release the driver's module */
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
>  
> -	rc = ap_parse_mask_str(buf, ap_perms.apm, AP_DEVICES, &ap_perms_mutex);
> +	if (mutex_lock_interruptible(&ap_perms_mutex))
> +		return -ERESTARTSYS;
> +
> +	rc = ap_parse_bitmap_str(buf, ap_perms.apm, AP_DEVICES, newapm);
> +	if (rc)
> +		goto done;
> +
> +	rc = apmask_commit(newapm);
> +
> +done:
> +	mutex_unlock(&ap_perms_mutex);
>  	if (rc)
>  		return rc;
>  
> @@ -1309,12 +1384,77 @@ static ssize_t aqmask_show(struct bus_type *bus, char *buf)
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
> +	/*
> +	 * increase the driver's module refcounter to be sure it is not
> +	 * going away when we invoke the callback function.
> +	 */
> +	if (!try_module_get(drv->owner))
> +		return 0;
> +
> +	if (ap_drv->in_use) {
> +		rc = ap_drv->in_use(ap_perms.apm, newaqm);
> +		if (rc)
> +			return -EBUSY;
> +	}
> +
> +	/* release the driver's module */
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
> +
> +	if (mutex_lock_interruptible(&ap_perms_mutex))
> +		return -ERESTARTSYS;
> +
> +	rc = ap_parse_bitmap_str(buf, ap_perms.aqm, AP_DOMAINS, newaqm);
> +	if (rc)
> +		goto done;
> +
> +	rc = aqmask_commit(newaqm);
>  
> -	rc = ap_parse_mask_str(buf, ap_perms.aqm, AP_DOMAINS, &ap_perms_mutex);
> +done:
> +	mutex_unlock(&ap_perms_mutex);
>  	if (rc)
>  		return rc;
>  
> diff --git a/drivers/s390/crypto/ap_bus.h b/drivers/s390/crypto/ap_bus.h
> index 95b577754b35..67c1bef60ad5 100644
> --- a/drivers/s390/crypto/ap_bus.h
> +++ b/drivers/s390/crypto/ap_bus.h
> @@ -142,6 +142,7 @@ struct ap_driver {
>  
>  	int (*probe)(struct ap_device *);
>  	void (*remove)(struct ap_device *);
> +	int (*in_use)(unsigned long *apm, unsigned long *aqm);
>  };
>  
>  #define to_ap_drv(x) container_of((x), struct ap_driver, driver)
> @@ -289,6 +290,9 @@ void ap_queue_init_state(struct ap_queue *aq);
>  struct ap_card *ap_card_create(int id, int queue_depth, int raw_type,
>  			       int comp_type, unsigned int functions, int ml);
>  
> +#define APMASKSIZE (BITS_TO_LONGS(AP_DEVICES) * sizeof(unsigned long))
> +#define AQMASKSIZE (BITS_TO_LONGS(AP_DOMAINS) * sizeof(unsigned long))
> +
>  struct ap_perms {
>  	unsigned long ioctlm[BITS_TO_LONGS(AP_IOCTLS)];
>  	unsigned long apm[BITS_TO_LONGS(AP_DEVICES)];
reviewed again. I still don't like this as it introduces an unbalanced weighting for the
vfio dd but ... We could consider removing the

if (ap_drv->flags & AP_DRIVER_FLAG_DEFAULT)
		return 0;

in function __verify_queue_reservations. It would still work as the 'default device
drivers' do not implement the in_use() callback and thus do not disagree about
the upcoming change.

