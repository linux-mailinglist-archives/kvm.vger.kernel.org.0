Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7081B6C53
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 05:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgDXD6C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 23:58:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62848 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725982AbgDXD6C (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Apr 2020 23:58:02 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03O3VNrm048077
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 23:58:01 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30jtk3c6rc-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 23 Apr 2020 23:58:00 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Fri, 24 Apr 2020 04:57:33 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 24 Apr 2020 04:57:30 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03O3vrpO59965686
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 03:57:53 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 928B5AE055;
        Fri, 24 Apr 2020 03:57:53 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D7073AE04D;
        Fri, 24 Apr 2020 03:57:52 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.87.192])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 24 Apr 2020 03:57:52 +0000 (GMT)
Date:   Fri, 24 Apr 2020 05:57:32 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com, pmorel@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com, fiuczy@linux.ibm.com
Subject: Re: [PATCH v7 01/15] s390/vfio-ap: store queue struct in hash table
 for quick access
In-Reply-To: <20200407192015.19887-2-akrowiak@linux.ibm.com>
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
        <20200407192015.19887-2-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20042403-0012-0000-0000-000003AA35BC
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20042403-0013-0000-0000-000021E78C50
Message-Id: <20200424055732.7663896d.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-23_19:2020-04-23,2020-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 impostorscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004240020
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  7 Apr 2020 15:20:01 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> Rather than looping over potentially 65535 objects, let's store the
> structures for caching information about queue devices bound to the
> vfio_ap device driver in a hash table keyed by APQN.

@Harald:
Would it make sense to make the efficient lookup of an apqueue base
on its APQN core AP functionality instead of each driver figuring it out
on it's own?

If I'm not wrong the zcrypt device/driver(s) must the problem of
looking up a queue based on its APQN as well.

For instance struct ep11_cprb has a target_id filed
(arch/s390/include/uapi/asm/zcrypt.h).

Regards,
Halil

> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_drv.c     | 28 +++------
>  drivers/s390/crypto/vfio_ap_ops.c     | 90 ++++++++++++++-------------
>  drivers/s390/crypto/vfio_ap_private.h | 10 ++-
>  3 files changed, 60 insertions(+), 68 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
> index be2520cc010b..e9c226c0730e 100644
> --- a/drivers/s390/crypto/vfio_ap_drv.c
> +++ b/drivers/s390/crypto/vfio_ap_drv.c
> @@ -51,15 +51,9 @@ MODULE_DEVICE_TABLE(vfio_ap, ap_queue_ids);
>   */
>  static int vfio_ap_queue_dev_probe(struct ap_device *apdev)
>  {
> -	struct vfio_ap_queue *q;
> -
> -	q = kzalloc(sizeof(*q), GFP_KERNEL);
> -	if (!q)
> -		return -ENOMEM;
> -	dev_set_drvdata(&apdev->device, q);
> -	q->apqn = to_ap_queue(&apdev->device)->qid;
> -	q->saved_isc = VFIO_AP_ISC_INVALID;
> -	return 0;
> +	struct ap_queue *queue = to_ap_queue(&apdev->device);
> +
> +	return vfio_ap_mdev_probe_queue(queue);
>  }
>  
>  /**
> @@ -70,18 +64,9 @@ static int vfio_ap_queue_dev_probe(struct ap_device *apdev)
>   */
>  static void vfio_ap_queue_dev_remove(struct ap_device *apdev)
>  {
> -	struct vfio_ap_queue *q;
> -	int apid, apqi;
> -
> -	mutex_lock(&matrix_dev->lock);
> -	q = dev_get_drvdata(&apdev->device);
> -	dev_set_drvdata(&apdev->device, NULL);
> -	apid = AP_QID_CARD(q->apqn);
> -	apqi = AP_QID_QUEUE(q->apqn);
> -	vfio_ap_mdev_reset_queue(apid, apqi, 1);
> -	vfio_ap_irq_disable(q);
> -	kfree(q);
> -	mutex_unlock(&matrix_dev->lock);
> +	struct ap_queue *queue = to_ap_queue(&apdev->device);
> +
> +	vfio_ap_mdev_remove_queue(queue);
>  }
>  
>  static void vfio_ap_matrix_dev_release(struct device *dev)
> @@ -135,6 +120,7 @@ static int vfio_ap_matrix_dev_create(void)
>  
>  	mutex_init(&matrix_dev->lock);
>  	INIT_LIST_HEAD(&matrix_dev->mdev_list);
> +	hash_init(matrix_dev->qtable);
>  
>  	dev_set_name(&matrix_dev->device, "%s", VFIO_AP_DEV_NAME);
>  	matrix_dev->device.parent = root_device;
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 5c0f53c6dde7..134860934fe7 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -26,45 +26,16 @@
>  
>  static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
>  
> -static int match_apqn(struct device *dev, const void *data)
> -{
> -	struct vfio_ap_queue *q = dev_get_drvdata(dev);
> -
> -	return (q->apqn == *(int *)(data)) ? 1 : 0;
> -}
> -
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
> +struct vfio_ap_queue *vfio_ap_get_queue(unsigned long apqn)
>  {
>  	struct vfio_ap_queue *q;
> -	struct device *dev;
> -
> -	if (!test_bit_inv(AP_QID_CARD(apqn), matrix_mdev->matrix.apm))
> -		return NULL;
> -	if (!test_bit_inv(AP_QID_QUEUE(apqn), matrix_mdev->matrix.aqm))
> -		return NULL;
> -
> -	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
> -				 &apqn, match_apqn);
> -	if (!dev)
> -		return NULL;
> -	q = dev_get_drvdata(dev);
> -	q->matrix_mdev = matrix_mdev;
> -	put_device(dev);
>  
> -	return q;
> +	hash_for_each_possible(matrix_dev->qtable, q, qnode, apqn) {
> +		if (q && (apqn == q->apqn))
> +			return q;
> +	}
> +
> +	return NULL;
>  }
>  
>  /**
> @@ -293,10 +264,11 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
>  	matrix_mdev = container_of(vcpu->kvm->arch.crypto.pqap_hook,
>  				   struct ap_matrix_mdev, pqap_hook);
>  
> -	q = vfio_ap_get_queue(matrix_mdev, apqn);
> +	q = vfio_ap_get_queue(apqn);
>  	if (!q)
>  		goto out_unlock;
>  
> +	q->matrix_mdev = matrix_mdev;
>  	status = vcpu->run->s.regs.gprs[1];
>  
>  	/* If IR bit(16) is set we enable the interrupt */
> @@ -1116,16 +1088,11 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>  
>  static void vfio_ap_irq_disable_apqn(int apqn)
>  {
> -	struct device *dev;
>  	struct vfio_ap_queue *q;
>  
> -	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
> -				 &apqn, match_apqn);
> -	if (dev) {
> -		q = dev_get_drvdata(dev);
> +	q = vfio_ap_get_queue(apqn);
> +	if (q)
>  		vfio_ap_irq_disable(q);
> -		put_device(dev);
> -	}
>  }
>  
>  int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
> @@ -1302,3 +1269,38 @@ void vfio_ap_mdev_unregister(void)
>  {
>  	mdev_unregister_device(&matrix_dev->device);
>  }
> +
> +int vfio_ap_mdev_probe_queue(struct ap_queue *queue)
> +{
> +	struct vfio_ap_queue *q;
> +
> +	q = kzalloc(sizeof(*q), GFP_KERNEL);
> +	if (!q)
> +		return -ENOMEM;
> +
> +	mutex_lock(&matrix_dev->lock);
> +	dev_set_drvdata(&queue->ap_dev.device, q);
> +	q->apqn = queue->qid;
> +	q->saved_isc = VFIO_AP_ISC_INVALID;
> +	hash_add(matrix_dev->qtable, &q->qnode, q->apqn);
> +	mutex_unlock(&matrix_dev->lock);
> +
> +	return 0;
> +}
> +
> +void vfio_ap_mdev_remove_queue(struct ap_queue *queue)
> +{
> +	struct vfio_ap_queue *q;
> +	int apid, apqi;
> +
> +	mutex_lock(&matrix_dev->lock);
> +	q = dev_get_drvdata(&queue->ap_dev.device);
> +	dev_set_drvdata(&queue->ap_dev.device, NULL);
> +	apid = AP_QID_CARD(q->apqn);
> +	apqi = AP_QID_QUEUE(q->apqn);
> +	vfio_ap_mdev_reset_queue(apid, apqi, 1);
> +	vfio_ap_irq_disable(q);
> +	hash_del(&q->qnode);
> +	kfree(q);
> +	mutex_unlock(&matrix_dev->lock);
> +}
> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
> index f46dde56b464..e1f8c82cc55d 100644
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
> @@ -43,6 +44,7 @@ struct ap_matrix_dev {
>  	struct list_head mdev_list;
>  	struct mutex lock;
>  	struct ap_driver  *vfio_ap_drv;
> +	DECLARE_HASHTABLE(qtable, 8);
>  };
>  
>  extern struct ap_matrix_dev *matrix_dev;
> @@ -90,8 +92,6 @@ struct ap_matrix_mdev {
>  
>  extern int vfio_ap_mdev_register(void);
>  extern void vfio_ap_mdev_unregister(void);
> -int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
> -			     unsigned int retry);
>  
>  struct vfio_ap_queue {
>  	struct ap_matrix_mdev *matrix_mdev;
> @@ -99,6 +99,10 @@ struct vfio_ap_queue {
>  	int	apqn;
>  #define VFIO_AP_ISC_INVALID 0xff
>  	unsigned char saved_isc;
> +	struct hlist_node qnode;
>  };
> -struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q);
> +
> +int vfio_ap_mdev_probe_queue(struct ap_queue *queue);
> +void vfio_ap_mdev_remove_queue(struct ap_queue *queue);
> +
>  #endif /* _VFIO_AP_PRIVATE_H_ */

