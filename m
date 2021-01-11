Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66E7A2F1ED0
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 20:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390686AbhAKTSo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 14:18:44 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64654 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732725AbhAKTSn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Jan 2021 14:18:43 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10BJ3O8c090722;
        Mon, 11 Jan 2021 14:18:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=eB+FS5HuAc1Pp8Py6LG+Dd8gBO0T3kD7jYyu+g+GrWo=;
 b=aHrnl2jyB3dBgo8tAbmaHvCiSsgOLKZKUk6jSzSymyA/WGDMyk6SPkg/q84njbiv6tV8
 iDEAc8X7WYByzLbZbNNlS8x43raa8xccPDAOL6V08lCvV0r9CnaDLZVAYS/GSiyzJLPU
 iWE8S+qsiwdM/6WqlAXeZVJLH3v6TlA5pcprX3nYotFOpQx9rn2O7RY33CJmxhW0tjGy
 cOr9lITpVLo2r75d+bqGN6Z7P1JJw2wXHUoPE4z7e9KmIkqhhOkfEamzvrqp1liO6jd+
 pW6WBaqUVIjtI2iIow+cAOuuH+hIrYm0xBmHp4S9MehMm/IVf81v3jQ8zyaURcw1Sg+P kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 360snjxf2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 14:18:02 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10BJ3NmB090664;
        Mon, 11 Jan 2021 14:18:01 -0500
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 360snjxf1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 14:18:01 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10BJGadU007763;
        Mon, 11 Jan 2021 19:17:59 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 35y4481bah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 19:17:59 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10BJHpMC31916420
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Jan 2021 19:17:51 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1980752050;
        Mon, 11 Jan 2021 19:17:56 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.62.86])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id 62D185204F;
        Mon, 11 Jan 2021 19:17:55 +0000 (GMT)
Date:   Mon, 11 Jan 2021 20:17:52 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v13 05/15] s390/vfio-ap: manage link between queue
 struct and matrix mdev
Message-ID: <20210111201752.21a41db4.pasic@linux.ibm.com>
In-Reply-To: <20201223011606.5265-6-akrowiak@linux.ibm.com>
References: <20201223011606.5265-1-akrowiak@linux.ibm.com>
        <20201223011606.5265-6-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_30:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 adultscore=0
 impostorscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101110105
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 22 Dec 2020 20:15:56 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> Let's create links between each queue device bound to the vfio_ap device
> driver and the matrix mdev to which the queue's APQN is assigned. The idea
> is to facilitate efficient retrieval of the objects representing the queue
> devices and matrix mdevs as well as to verify that a queue assigned to
> a matrix mdev is bound to the driver.
> 
> The links will be created as follows:
> 
>    * When the queue device is probed, if its APQN is assigned to a matrix
>      mdev, the structures representing the queue device and the matrix mdev
>      will be linked.
> 
>    * When an adapter or domain is assigned to a matrix mdev, for each new
>      APQN assigned that references a queue device bound to the vfio_ap
>      device driver, the structures representing the queue device and the
>      matrix mdev will be linked.
> 
> The links will be removed as follows:
> 
>    * When the queue device is removed, if its APQN is assigned to a matrix
>      mdev, the structures representing the queue device and the matrix mdev
>      will be unlinked.
> 
>    * When an adapter or domain is unassigned from a matrix mdev, for each
>      APQN unassigned that references a queue device bound to the vfio_ap
>      device driver, the structures representing the queue device and the
>      matrix mdev will be unlinked.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>

Reviewed-by: Halil Pasic <pasic@linux.ibm.com>

> ---
>  drivers/s390/crypto/vfio_ap_ops.c     | 140 +++++++++++++++++++++-----
>  drivers/s390/crypto/vfio_ap_private.h |   3 +
>  2 files changed, 117 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 835c963ae16d..cdcc6378b4a5 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -27,33 +27,17 @@
>  static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
>  static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
>  
> -/**
> - * vfio_ap_get_queue: Retrieve a queue with a specific APQN from a list
> - * @matrix_mdev: the associated mediated matrix
> - * @apqn: The queue APQN
> - *
> - * Retrieve a queue with a specific APQN from the list of the
> - * devices of the vfio_ap_drv.
> - * Verify that the APID and the APQI are set in the matrix.
> - *
> - * Returns the pointer to the associated vfio_ap_queue
> - */
> -static struct vfio_ap_queue *vfio_ap_get_queue(
> -					struct ap_matrix_mdev *matrix_mdev,
> -					int apqn)
> +static struct vfio_ap_queue *
> +vfio_ap_mdev_get_queue(struct ap_matrix_mdev *matrix_mdev, unsigned long apqn)
>  {
> -	struct vfio_ap_queue *q = NULL;
> -
> -	if (!test_bit_inv(AP_QID_CARD(apqn), matrix_mdev->matrix.apm))
> -		return NULL;
> -	if (!test_bit_inv(AP_QID_QUEUE(apqn), matrix_mdev->matrix.aqm))
> -		return NULL;
> +	struct vfio_ap_queue *q;
>  
> -	q = vfio_ap_find_queue(apqn);
> -	if (q)
> -		q->matrix_mdev = matrix_mdev;
> +	hash_for_each_possible(matrix_mdev->qtable, q, mdev_qnode, apqn) {
> +		if (q && (q->apqn == apqn))
> +			return q;
> +	}
>  
> -	return q;
> +	return NULL;
>  }
>  
>  /**
> @@ -166,7 +150,6 @@ static struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q)
>  		  status.response_code);
>  end_free:
>  	vfio_ap_free_aqic_resources(q);
> -	q->matrix_mdev = NULL;
>  	return status;
>  }
>  
> @@ -282,7 +265,7 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
>  	matrix_mdev = container_of(vcpu->kvm->arch.crypto.pqap_hook,
>  				   struct ap_matrix_mdev, pqap_hook);
>  
> -	q = vfio_ap_get_queue(matrix_mdev, apqn);
> +	q = vfio_ap_mdev_get_queue(matrix_mdev, apqn);
>  	if (!q)
>  		goto out_unlock;
>  
> @@ -325,6 +308,7 @@ static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
>  
>  	matrix_mdev->mdev = mdev;
>  	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->matrix);
> +	hash_init(matrix_mdev->qtable);
>  	mdev_set_drvdata(mdev, matrix_mdev);
>  	matrix_mdev->pqap_hook.hook = handle_pqap;
>  	matrix_mdev->pqap_hook.owner = THIS_MODULE;
> @@ -553,6 +537,50 @@ static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev)
>  	return 0;
>  }
>  
> +static void vfio_ap_mdev_link_queue(struct ap_matrix_mdev *matrix_mdev,
> +				    struct vfio_ap_queue *q)
> +{
> +	if (q) {
> +		q->matrix_mdev = matrix_mdev;
> +		hash_add(matrix_mdev->qtable,
> +			 &q->mdev_qnode, q->apqn);
> +	}
> +}
> +
> +static void vfio_ap_mdev_link_apqn(struct ap_matrix_mdev *matrix_mdev, int apqn)
> +{
> +	struct vfio_ap_queue *q;
> +
> +	q = vfio_ap_find_queue(apqn);
> +	vfio_ap_mdev_link_queue(matrix_mdev, q);
> +}
> +
> +static void vfio_ap_mdev_unlink_queue(struct vfio_ap_queue *q)
> +{
> +	if (q) {
> +		q->matrix_mdev = NULL;
> +		hash_del(&q->mdev_qnode);
> +	}
> +}
> +
> +static void vfio_ap_mdev_unlink_apqn(int apqn)
> +{
> +	struct vfio_ap_queue *q;
> +
> +	q = vfio_ap_find_queue(apqn);
> +	vfio_ap_mdev_unlink_queue(q);
> +}
> +
> +static void vfio_ap_mdev_link_adapter(struct ap_matrix_mdev *matrix_mdev,
> +				      unsigned long apid)
> +{
> +	unsigned long apqi;
> +
> +	for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm, AP_DOMAINS)
> +		vfio_ap_mdev_link_apqn(matrix_mdev,
> +				       AP_MKQID(apid, apqi));
> +}
> +
>  /**
>   * assign_adapter_store
>   *
> @@ -622,6 +650,7 @@ static ssize_t assign_adapter_store(struct device *dev,
>  	if (ret)
>  		goto share_err;
>  
> +	vfio_ap_mdev_link_adapter(matrix_mdev, apid);
>  	ret = count;
>  	goto done;
>  
> @@ -634,6 +663,15 @@ static ssize_t assign_adapter_store(struct device *dev,
>  }
>  static DEVICE_ATTR_WO(assign_adapter);
>  
> +static void vfio_ap_mdev_unlink_adapter(struct ap_matrix_mdev *matrix_mdev,
> +					unsigned long apid)
> +{
> +	unsigned long apqi;
> +
> +	for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm, AP_DOMAINS)
> +		vfio_ap_mdev_unlink_apqn(AP_MKQID(apid, apqi));
> +}
> +
>  /**
>   * unassign_adapter_store
>   *
> @@ -673,6 +711,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
>  
>  	mutex_lock(&matrix_dev->lock);
>  	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
> +	vfio_ap_mdev_unlink_adapter(matrix_mdev, apid);
>  	mutex_unlock(&matrix_dev->lock);
>  
>  	return count;
> @@ -699,6 +738,15 @@ vfio_ap_mdev_verify_queues_reserved_for_apqi(struct ap_matrix_mdev *matrix_mdev,
>  	return 0;
>  }
>  
> +static void vfio_ap_mdev_link_domain(struct ap_matrix_mdev *matrix_mdev,
> +				     unsigned long apqi)
> +{
> +	unsigned long apid;
> +
> +	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, AP_DEVICES)
> +		vfio_ap_mdev_link_apqn(matrix_mdev, AP_MKQID(apid, apqi));
> +}
> +
>  /**
>   * assign_domain_store
>   *
> @@ -763,6 +811,7 @@ static ssize_t assign_domain_store(struct device *dev,
>  	if (ret)
>  		goto share_err;
>  
> +	vfio_ap_mdev_link_domain(matrix_mdev, apqi);
>  	ret = count;
>  	goto done;
>  
> @@ -775,6 +824,14 @@ static ssize_t assign_domain_store(struct device *dev,
>  }
>  static DEVICE_ATTR_WO(assign_domain);
>  
> +static void vfio_ap_mdev_unlink_domain(struct ap_matrix_mdev *matrix_mdev,
> +				       unsigned long apqi)
> +{
> +	unsigned long apid;
> +
> +	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, AP_DEVICES)
> +		vfio_ap_mdev_unlink_apqn(AP_MKQID(apid, apqi));
> +}
>  
>  /**
>   * unassign_domain_store
> @@ -815,6 +872,7 @@ static ssize_t unassign_domain_store(struct device *dev,
>  
>  	mutex_lock(&matrix_dev->lock);
>  	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
> +	vfio_ap_mdev_unlink_domain(matrix_mdev, apqi);
>  	mutex_unlock(&matrix_dev->lock);
>  
>  	return count;
> @@ -1317,6 +1375,28 @@ void vfio_ap_mdev_unregister(void)
>  	mdev_unregister_device(&matrix_dev->device);
>  }
>  
> +/*
> + * vfio_ap_queue_link_mdev
> + *
> + * @q: The queue to link with the matrix mdev.
> + *
> + * Links @q with the matrix mdev to which the queue's APQN is assigned.
> + */
> +static void vfio_ap_queue_link_mdev(struct vfio_ap_queue *q)
> +{
> +	unsigned long apid = AP_QID_CARD(q->apqn);
> +	unsigned long apqi = AP_QID_QUEUE(q->apqn);
> +	struct ap_matrix_mdev *matrix_mdev;
> +
> +	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
> +		if (test_bit_inv(apid, matrix_mdev->matrix.apm) &&
> +		    test_bit_inv(apqi, matrix_mdev->matrix.aqm)) {
> +			vfio_ap_mdev_link_queue(matrix_mdev, q);
> +			break;
> +		}
> +	}
> +}
> +
>  int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
>  {
>  	struct vfio_ap_queue *q;
> @@ -1324,9 +1404,13 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
>  	q = kzalloc(sizeof(*q), GFP_KERNEL);
>  	if (!q)
>  		return -ENOMEM;
> +	mutex_lock(&matrix_dev->lock);
>  	dev_set_drvdata(&apdev->device, q);
>  	q->apqn = to_ap_queue(&apdev->device)->qid;
>  	q->saved_isc = VFIO_AP_ISC_INVALID;
> +	vfio_ap_queue_link_mdev(q);
> +	mutex_unlock(&matrix_dev->lock);
> +

Does the critical section have to include more than just
vfio_ap_queue_link_mdev()? Did we need the critical section
before this patch?

>  	return 0;
>  }
>  
> @@ -1341,6 +1425,10 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
>  	apid = AP_QID_CARD(q->apqn);
>  	apqi = AP_QID_QUEUE(q->apqn);
>  	vfio_ap_mdev_reset_queue(apid, apqi, 1);
> +
> +	if (q->matrix_mdev)
> +		vfio_ap_mdev_unlink_queue(q);
> +
>  	kfree(q);
>  	mutex_unlock(&matrix_dev->lock);
>  }
> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
> index d9003de4fbad..4e5cc72fc0db 100644
> --- a/drivers/s390/crypto/vfio_ap_private.h
> +++ b/drivers/s390/crypto/vfio_ap_private.h
> @@ -18,6 +18,7 @@
>  #include <linux/delay.h>
>  #include <linux/mutex.h>
>  #include <linux/kvm_host.h>
> +#include <linux/hashtable.h>
>  
>  #include "ap_bus.h"
>  
> @@ -86,6 +87,7 @@ struct ap_matrix_mdev {
>  	struct kvm *kvm;
>  	struct kvm_s390_module_hook pqap_hook;
>  	struct mdev_device *mdev;
> +	DECLARE_HASHTABLE(qtable, 8);
>  };
>  
>  extern int vfio_ap_mdev_register(void);
> @@ -97,6 +99,7 @@ struct vfio_ap_queue {
>  	int	apqn;
>  #define VFIO_AP_ISC_INVALID 0xff
>  	unsigned char saved_isc;
> +	struct hlist_node mdev_qnode;
>  };
>  
>  int vfio_ap_mdev_probe_queue(struct ap_device *queue);

