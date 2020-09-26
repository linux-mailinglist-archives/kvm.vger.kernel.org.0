Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D8E279CE8
	for <lists+kvm@lfdr.de>; Sun, 27 Sep 2020 01:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728284AbgIZXtO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 26 Sep 2020 19:49:14 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59044 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726242AbgIZXtO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 26 Sep 2020 19:49:14 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08QNWhRM160433;
        Sat, 26 Sep 2020 19:49:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=K9N7FJZfsebxYXnLoDrFZQ+1EMhNg5YHJXucIYGpBnM=;
 b=OaHbJl1iyrSwQfsDw0jgslXAbN3757JrlGjomDzwiXRlNMi9FX4hLTi3WMTmpVl+NGxd
 bcgmEnJoNoA0Y3gvkQZgPpNKxEhh53lXeM3oqhBs8As+YZp7hfxNnN52xf0oYrErRS2V
 d4rXJYw/J5cv4KIvmtyy2CMegiwjQDwCzrIvLFfzHBhqccsv8v5hD2RqADu/01mOFPIQ
 XR7aEkGbqo07Sy+RScVvK0D4B60Kp+10aqdnSe7UWOtbtjH6sXnox9uFO9lmRm3MfDbj
 ehMKbBGIKaJQWbn/NKyr0kxIcrLr7OU4HIgULynwsptlTPMBbOwVCGQlHq9ME9dY6wHu Sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33tdg120dm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 19:49:12 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08QNei7x174949;
        Sat, 26 Sep 2020 19:49:12 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33tdg120da-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 19:49:12 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08QNlH37030891;
        Sat, 26 Sep 2020 23:49:10 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 33sw97rr49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 23:49:09 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08QNn6Gj15401456
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Sep 2020 23:49:06 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A46411C054;
        Sat, 26 Sep 2020 23:49:06 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9DE3411C050;
        Sat, 26 Sep 2020 23:49:05 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.162.14])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 26 Sep 2020 23:49:05 +0000 (GMT)
Date:   Sun, 27 Sep 2020 01:49:02 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v10 09/16] s390/vfio-ap: allow assignment of unavailable
 AP queues to mdev device
Message-ID: <20200927014902.1a1a0d8c.pasic@linux.ibm.com>
In-Reply-To: <20200821195616.13554-10-akrowiak@linux.ibm.com>
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
        <20200821195616.13554-10-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-26_21:2020-09-24,2020-09-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 mlxlogscore=999 priorityscore=1501
 mlxscore=0 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0
 suspectscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009260214
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 Aug 2020 15:56:09 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> The current implementation does not allow assignment of an AP adapter or
> domain to an mdev device if the APQNs resulting from the assignment
> do not reference AP queue devices that are bound to the vfio_ap device
> driver. This patch allows assignment of AP resources to the matrix mdev as
> long as the APQNs resulting from the assignment:
>    1. Are not reserved by the AP BUS for use by the zcrypt device drivers.
>    2. Are not assigned to another matrix mdev.
> 
> The rationale behind this is twofold:
>    1. The AP architecture does not preclude assignment of APQNs to an AP
>       configuration that are not available to the system.
>    2. APQNs that do not reference a queue device bound to the vfio_ap
>       device driver will not be assigned to the guest's CRYCB, so the
>       guest will not get access to queues not bound to the vfio_ap driver.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 212 +++++-------------------------
>  1 file changed, 35 insertions(+), 177 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index eaf4e9eab6cb..24fd47e43b80 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1,4 +1,3 @@
> -// SPDX-License-Identifier: GPL-2.0+

Probably not intentional, or?

>  /*
>   * Adjunct processor matrix VFIO device driver callbacks.
>   *
> @@ -420,122 +419,6 @@ static struct attribute_group *vfio_ap_mdev_type_groups[] = {
>  	NULL,
>  };
>  
> -struct vfio_ap_queue_reserved {
> -	unsigned long *apid;
> -	unsigned long *apqi;
> -	bool reserved;
> -};
> -
> -/**
> - * vfio_ap_has_queue
> - *
> - * @dev: an AP queue device
> - * @data: a struct vfio_ap_queue_reserved reference
> - *
> - * Flags whether the AP queue device (@dev) has a queue ID containing the APQN,
> - * apid or apqi specified in @data:
> - *
> - * - If @data contains both an apid and apqi value, then @data will be flagged
> - *   as reserved if the APID and APQI fields for the AP queue device matches
> - *
> - * - If @data contains only an apid value, @data will be flagged as
> - *   reserved if the APID field in the AP queue device matches
> - *
> - * - If @data contains only an apqi value, @data will be flagged as
> - *   reserved if the APQI field in the AP queue device matches
> - *
> - * Returns 0 to indicate the input to function succeeded. Returns -EINVAL if
> - * @data does not contain either an apid or apqi.
> - */
> -static int vfio_ap_has_queue(struct device *dev, void *data)
> -{
> -	struct vfio_ap_queue_reserved *qres = data;
> -	struct ap_queue *ap_queue = to_ap_queue(dev);
> -	ap_qid_t qid;
> -	unsigned long id;
> -
> -	if (qres->apid && qres->apqi) {
> -		qid = AP_MKQID(*qres->apid, *qres->apqi);
> -		if (qid == ap_queue->qid)
> -			qres->reserved = true;
> -	} else if (qres->apid && !qres->apqi) {
> -		id = AP_QID_CARD(ap_queue->qid);
> -		if (id == *qres->apid)
> -			qres->reserved = true;
> -	} else if (!qres->apid && qres->apqi) {
> -		id = AP_QID_QUEUE(ap_queue->qid);
> -		if (id == *qres->apqi)
> -			qres->reserved = true;
> -	} else {
> -		return -EINVAL;
> -	}
> -
> -	return 0;
> -}
> -
> -/**
> - * vfio_ap_verify_queue_reserved
> - *
> - * @matrix_dev: a mediated matrix device
> - * @apid: an AP adapter ID
> - * @apqi: an AP queue index
> - *
> - * Verifies that the AP queue with @apid/@apqi is reserved by the VFIO AP device
> - * driver according to the following rules:
> - *
> - * - If both @apid and @apqi are not NULL, then there must be an AP queue
> - *   device bound to the vfio_ap driver with the APQN identified by @apid and
> - *   @apqi
> - *
> - * - If only @apid is not NULL, then there must be an AP queue device bound
> - *   to the vfio_ap driver with an APQN containing @apid
> - *
> - * - If only @apqi is not NULL, then there must be an AP queue device bound
> - *   to the vfio_ap driver with an APQN containing @apqi
> - *
> - * Returns 0 if the AP queue is reserved; otherwise, returns -EADDRNOTAVAIL.
> - */
> -static int vfio_ap_verify_queue_reserved(unsigned long *apid,
> -					 unsigned long *apqi)
> -{
> -	int ret;
> -	struct vfio_ap_queue_reserved qres;
> -
> -	qres.apid = apid;
> -	qres.apqi = apqi;
> -	qres.reserved = false;
> -
> -	ret = driver_for_each_device(&matrix_dev->vfio_ap_drv->driver, NULL,
> -				     &qres, vfio_ap_has_queue);
> -	if (ret)
> -		return ret;
> -
> -	if (qres.reserved)
> -		return 0;
> -
> -	return -EADDRNOTAVAIL;
> -}
> -
> -static int
> -vfio_ap_mdev_verify_queues_reserved_for_apid(struct ap_matrix_mdev *matrix_mdev,
> -					     unsigned long apid)
> -{
> -	int ret;
> -	unsigned long apqi;
> -	unsigned long nbits = matrix_mdev->matrix.aqm_max + 1;
> -
> -	if (find_first_bit_inv(matrix_mdev->matrix.aqm, nbits) >= nbits)
> -		return vfio_ap_verify_queue_reserved(&apid, NULL);
> -
> -	for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm, nbits) {
> -		ret = vfio_ap_verify_queue_reserved(&apid, &apqi);
> -		if (ret)
> -			return ret;
> -	}
> -
> -	return 0;
> -}
> -
>  #define MDEV_SHARING_ERR "Userspace may not re-assign queue %02lx.%04lx " \
>  			 "already assigned to %s"
>  
> @@ -572,6 +455,11 @@ static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev,
>  	DECLARE_BITMAP(aqm, AP_DOMAINS);
>  
>  	list_for_each_entry(lstdev, &matrix_dev->mdev_list, node) {
> +		/*
> +		 * If either of the input masks belongs to the mdev to which an
> +		 * AP resource is being assigned, then we don't need to verify
> +		 * that mdev's masks.
> +		 */
>  		if (matrix_mdev == lstdev)
>  			continue;
>  

Seems unrelated.

> @@ -597,6 +485,20 @@ static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev,
>  	return 0;
>  }
>  
> +static int vfio_ap_mdev_validate_masks(struct ap_matrix_mdev *matrix_mdev,
> +				       unsigned long *mdev_apm,
> +				       unsigned long *mdev_aqm)
> +{
> +	DECLARE_BITMAP(apm, AP_DEVICES);
> +	DECLARE_BITMAP(aqm, AP_DOMAINS);
> +
> +	if (bitmap_and(apm, mdev_apm, ap_perms.apm, AP_DEVICES) &&
> +	    bitmap_and(aqm, mdev_aqm, ap_perms.aqm, AP_DOMAINS))

Isn't ap_perms supposed to be protected by ap_perms_mutex? In theory
you could end up with a torn write (catch the a[pq]mask_commit() with
its pants down, in a sense that only a part of the memcpy was done (and
became observable on the other CPU doing this validate).

> +		return -EADDRNOTAVAIL;
> +
> +	return vfio_ap_mdev_verify_no_sharing(matrix_mdev, mdev_apm, mdev_aqm);
> +}
> +
>  /**
>   * vfio_ap_mdev_filter_matrix
>   *
> @@ -882,33 +784,21 @@ static ssize_t assign_adapter_store(struct device *dev,
>  	if (apid > matrix_mdev->matrix.apm_max)
>  		return -ENODEV;
>  
> -	/*
> -	 * Set the bit in the AP mask (APM) corresponding to the AP adapter
> -	 * number (APID). The bits in the mask, from most significant to least
> -	 * significant bit, correspond to APIDs 0-255.
> -	 */
> -	mutex_lock(&matrix_dev->lock);
> -
> -	ret = vfio_ap_mdev_verify_queues_reserved_for_apid(matrix_mdev, apid);
> -	if (ret)
> -		goto done;
> -
>  	memset(apm, 0, sizeof(apm));
>  	set_bit_inv(apid, apm);
>  
> -	ret = vfio_ap_mdev_verify_no_sharing(matrix_mdev, apm,
> -					     matrix_mdev->matrix.aqm);
> -	if (ret)
> -		goto done;
> -
> +	mutex_lock(&matrix_dev->lock);
> +	ret = vfio_ap_mdev_validate_masks(matrix_mdev, apm,
> +					  matrix_mdev->matrix.aqm);
> +	if (ret) {
> +		mutex_unlock(&matrix_dev->lock);
> +		return ret;
> +	}

At this point the ap_perms may have already changed, or?

>  	set_bit_inv(apid, matrix_mdev->matrix.apm);
>  	vfio_ap_mdev_link_queues(matrix_mdev, LINK_APID, apid);
> -	ret = count;
> -
> -done:
>  	mutex_unlock(&matrix_dev->lock);
>  
> -	return ret;
> +	return count;
>  }
>  static DEVICE_ATTR_WO(assign_adapter);
>  
> @@ -958,26 +848,6 @@ static ssize_t unassign_adapter_store(struct device *dev,
>  }
>  static DEVICE_ATTR_WO(unassign_adapter);
>  
> -static int
> -vfio_ap_mdev_verify_queues_reserved_for_apqi(struct ap_matrix_mdev *matrix_mdev,
> -					     unsigned long apqi)
> -{
> -	int ret;
> -	unsigned long apid;
> -	unsigned long nbits = matrix_mdev->matrix.apm_max + 1;
> -
> -	if (find_first_bit_inv(matrix_mdev->matrix.apm, nbits) >= nbits)
> -		return vfio_ap_verify_queue_reserved(NULL, &apqi);
> -
> -	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, nbits) {
> -		ret = vfio_ap_verify_queue_reserved(&apid, &apqi);
> -		if (ret)
> -			return ret;
> -	}
> -
> -	return 0;
> -}
> -
>  /**
>   * assign_domain_store
>   *
> @@ -1031,28 +901,21 @@ static ssize_t assign_domain_store(struct device *dev,
>  	if (apqi > max_apqi)
>  		return -ENODEV;
>  
> -	mutex_lock(&matrix_dev->lock);
> -
> -	ret = vfio_ap_mdev_verify_queues_reserved_for_apqi(matrix_mdev, apqi);
> -	if (ret)
> -		goto done;
> -
>  	memset(aqm, 0, sizeof(aqm));
>  	set_bit_inv(apqi, aqm);
>  
> -	ret = vfio_ap_mdev_verify_no_sharing(matrix_mdev,
> -					     matrix_mdev->matrix.apm, aqm);
> -	if (ret)
> -		goto done;
> -
> +	mutex_lock(&matrix_dev->lock);
> +	ret = vfio_ap_mdev_validate_masks(matrix_mdev, matrix_mdev->matrix.apm,
> +					  aqm);
> +	if (ret) {
> +		mutex_unlock(&matrix_dev->lock);
> +		return ret;
> +	}
>  	set_bit_inv(apqi, matrix_mdev->matrix.aqm);
>  	vfio_ap_mdev_link_queues(matrix_mdev, LINK_APQI, apqi);
> -	ret = count;
> -
> -done:
>  	mutex_unlock(&matrix_dev->lock);
>  
> -	return ret;
> +	return count;
>  }
>  static DEVICE_ATTR_WO(assign_domain);
>  
> @@ -1139,11 +1002,6 @@ static ssize_t assign_control_domain_store(struct device *dev,
>  	if (id > matrix_mdev->matrix.adm_max)
>  		return -ENODEV;
>  
> -	/* Set the bit in the ADM (bitmask) corresponding to the AP control
> -	 * domain number (id). The bits in the mask, from most significant to
> -	 * least significant, correspond to IDs 0 up to the one less than the
> -	 * number of control domains that can be assigned.
> -	 */
>  	mutex_lock(&matrix_dev->lock);
>  	set_bit_inv(id, matrix_mdev->matrix.adm);
>  	mutex_unlock(&matrix_dev->lock);

