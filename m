Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDD3A2F5757
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 04:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729183AbhAMVq3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 16:46:29 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38836 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729132AbhAMVmn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 16:42:43 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10DLWFkp033988;
        Wed, 13 Jan 2021 16:41:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Q+Gq6TB1awRgjZnvD/ml20jhcW5N4flrtXfO4fqf5X4=;
 b=S+9hJCMPZXigeEby2ZtYxzYtpDWw5d4co/DDtX/DQequ5To5vHwRK4N3t8peVmTR51K/
 egykKaTslRpNx5RYVTv7XbBX68jwi8cLPeWCs03rNI3OAr7Ho2vEk8MARVCl+yBiEiDn
 1aJJWVr95yg7IFhN/K9zNf68gl9M0UEbf0IGQ3+JzcHEW0Ar9XgaEifxa1s8ZJoPgqm9
 9zYW6EioelH9K9FFmS/N9HxHtOTY50Tb0GnVrioSv6mApWi9vqgLO433F4YhB2XnUXTb
 UVQ1QVSHoT5kck5FtuNxPQ1nQb5Mk9ht4RJeQBws8kpbr30N8aGKEXRZDa/aU/TLW8cj CA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3628ta0awk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 16:41:34 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10DLWPtB034468;
        Wed, 13 Jan 2021 16:41:34 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3628ta0aw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 16:41:34 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10DLW4Lo023896;
        Wed, 13 Jan 2021 21:41:33 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma03dal.us.ibm.com with ESMTP id 35y449gjn6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 21:41:33 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10DLfUUW19071440
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 21:41:30 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A652C6055;
        Wed, 13 Jan 2021 21:41:30 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 89144C6059;
        Wed, 13 Jan 2021 21:41:28 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.193.150])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jan 2021 21:41:28 +0000 (GMT)
Subject: Re: [PATCH v13 05/15] s390/vfio-ap: manage link between queue struct
 and matrix mdev
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
References: <20201223011606.5265-1-akrowiak@linux.ibm.com>
 <20201223011606.5265-6-akrowiak@linux.ibm.com>
 <20210111201752.21a41db4.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <8c701a5c-39f8-0c22-c936-aebbc3c8f60e@linux.ibm.com>
Date:   Wed, 13 Jan 2021 16:41:27 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210111201752.21a41db4.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_11:2021-01-13,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 impostorscore=0 bulkscore=0 phishscore=0 adultscore=0 clxscore=1015
 malwarescore=0 suspectscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130128
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/11/21 2:17 PM, Halil Pasic wrote:
> On Tue, 22 Dec 2020 20:15:56 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> Let's create links between each queue device bound to the vfio_ap device
>> driver and the matrix mdev to which the queue's APQN is assigned. The idea
>> is to facilitate efficient retrieval of the objects representing the queue
>> devices and matrix mdevs as well as to verify that a queue assigned to
>> a matrix mdev is bound to the driver.
>>
>> The links will be created as follows:
>>
>>     * When the queue device is probed, if its APQN is assigned to a matrix
>>       mdev, the structures representing the queue device and the matrix mdev
>>       will be linked.
>>
>>     * When an adapter or domain is assigned to a matrix mdev, for each new
>>       APQN assigned that references a queue device bound to the vfio_ap
>>       device driver, the structures representing the queue device and the
>>       matrix mdev will be linked.
>>
>> The links will be removed as follows:
>>
>>     * When the queue device is removed, if its APQN is assigned to a matrix
>>       mdev, the structures representing the queue device and the matrix mdev
>>       will be unlinked.
>>
>>     * When an adapter or domain is unassigned from a matrix mdev, for each
>>       APQN unassigned that references a queue device bound to the vfio_ap
>>       device driver, the structures representing the queue device and the
>>       matrix mdev will be unlinked.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c     | 140 +++++++++++++++++++++-----
>>   drivers/s390/crypto/vfio_ap_private.h |   3 +
>>   2 files changed, 117 insertions(+), 26 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>> index 835c963ae16d..cdcc6378b4a5 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -27,33 +27,17 @@
>>   static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
>>   static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
>>   
>> -/**
>> - * vfio_ap_get_queue: Retrieve a queue with a specific APQN from a list
>> - * @matrix_mdev: the associated mediated matrix
>> - * @apqn: The queue APQN
>> - *
>> - * Retrieve a queue with a specific APQN from the list of the
>> - * devices of the vfio_ap_drv.
>> - * Verify that the APID and the APQI are set in the matrix.
>> - *
>> - * Returns the pointer to the associated vfio_ap_queue
>> - */
>> -static struct vfio_ap_queue *vfio_ap_get_queue(
>> -					struct ap_matrix_mdev *matrix_mdev,
>> -					int apqn)
>> +static struct vfio_ap_queue *
>> +vfio_ap_mdev_get_queue(struct ap_matrix_mdev *matrix_mdev, unsigned long apqn)
>>   {
>> -	struct vfio_ap_queue *q = NULL;
>> -
>> -	if (!test_bit_inv(AP_QID_CARD(apqn), matrix_mdev->matrix.apm))
>> -		return NULL;
>> -	if (!test_bit_inv(AP_QID_QUEUE(apqn), matrix_mdev->matrix.aqm))
>> -		return NULL;
>> +	struct vfio_ap_queue *q;
>>   
>> -	q = vfio_ap_find_queue(apqn);
>> -	if (q)
>> -		q->matrix_mdev = matrix_mdev;
>> +	hash_for_each_possible(matrix_mdev->qtable, q, mdev_qnode, apqn) {
>> +		if (q && (q->apqn == apqn))
>> +			return q;
>> +	}
>>   
>> -	return q;
>> +	return NULL;
>>   }
>>   
>>   /**
>> @@ -166,7 +150,6 @@ static struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q)
>>   		  status.response_code);
>>   end_free:
>>   	vfio_ap_free_aqic_resources(q);
>> -	q->matrix_mdev = NULL;
>>   	return status;
>>   }
>>   
>> @@ -282,7 +265,7 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
>>   	matrix_mdev = container_of(vcpu->kvm->arch.crypto.pqap_hook,
>>   				   struct ap_matrix_mdev, pqap_hook);
>>   
>> -	q = vfio_ap_get_queue(matrix_mdev, apqn);
>> +	q = vfio_ap_mdev_get_queue(matrix_mdev, apqn);
>>   	if (!q)
>>   		goto out_unlock;
>>   
>> @@ -325,6 +308,7 @@ static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
>>   
>>   	matrix_mdev->mdev = mdev;
>>   	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->matrix);
>> +	hash_init(matrix_mdev->qtable);
>>   	mdev_set_drvdata(mdev, matrix_mdev);
>>   	matrix_mdev->pqap_hook.hook = handle_pqap;
>>   	matrix_mdev->pqap_hook.owner = THIS_MODULE;
>> @@ -553,6 +537,50 @@ static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev)
>>   	return 0;
>>   }
>>   
>> +static void vfio_ap_mdev_link_queue(struct ap_matrix_mdev *matrix_mdev,
>> +				    struct vfio_ap_queue *q)
>> +{
>> +	if (q) {
>> +		q->matrix_mdev = matrix_mdev;
>> +		hash_add(matrix_mdev->qtable,
>> +			 &q->mdev_qnode, q->apqn);
>> +	}
>> +}
>> +
>> +static void vfio_ap_mdev_link_apqn(struct ap_matrix_mdev *matrix_mdev, int apqn)
>> +{
>> +	struct vfio_ap_queue *q;
>> +
>> +	q = vfio_ap_find_queue(apqn);
>> +	vfio_ap_mdev_link_queue(matrix_mdev, q);
>> +}
>> +
>> +static void vfio_ap_mdev_unlink_queue(struct vfio_ap_queue *q)
>> +{
>> +	if (q) {
>> +		q->matrix_mdev = NULL;
>> +		hash_del(&q->mdev_qnode);
>> +	}
>> +}
>> +
>> +static void vfio_ap_mdev_unlink_apqn(int apqn)
>> +{
>> +	struct vfio_ap_queue *q;
>> +
>> +	q = vfio_ap_find_queue(apqn);
>> +	vfio_ap_mdev_unlink_queue(q);
>> +}
>> +
>> +static void vfio_ap_mdev_link_adapter(struct ap_matrix_mdev *matrix_mdev,
>> +				      unsigned long apid)
>> +{
>> +	unsigned long apqi;
>> +
>> +	for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm, AP_DOMAINS)
>> +		vfio_ap_mdev_link_apqn(matrix_mdev,
>> +				       AP_MKQID(apid, apqi));
>> +}
>> +
>>   /**
>>    * assign_adapter_store
>>    *
>> @@ -622,6 +650,7 @@ static ssize_t assign_adapter_store(struct device *dev,
>>   	if (ret)
>>   		goto share_err;
>>   
>> +	vfio_ap_mdev_link_adapter(matrix_mdev, apid);
>>   	ret = count;
>>   	goto done;
>>   
>> @@ -634,6 +663,15 @@ static ssize_t assign_adapter_store(struct device *dev,
>>   }
>>   static DEVICE_ATTR_WO(assign_adapter);
>>   
>> +static void vfio_ap_mdev_unlink_adapter(struct ap_matrix_mdev *matrix_mdev,
>> +					unsigned long apid)
>> +{
>> +	unsigned long apqi;
>> +
>> +	for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm, AP_DOMAINS)
>> +		vfio_ap_mdev_unlink_apqn(AP_MKQID(apid, apqi));
>> +}
>> +
>>   /**
>>    * unassign_adapter_store
>>    *
>> @@ -673,6 +711,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
>>   
>>   	mutex_lock(&matrix_dev->lock);
>>   	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
>> +	vfio_ap_mdev_unlink_adapter(matrix_mdev, apid);
>>   	mutex_unlock(&matrix_dev->lock);
>>   
>>   	return count;
>> @@ -699,6 +738,15 @@ vfio_ap_mdev_verify_queues_reserved_for_apqi(struct ap_matrix_mdev *matrix_mdev,
>>   	return 0;
>>   }
>>   
>> +static void vfio_ap_mdev_link_domain(struct ap_matrix_mdev *matrix_mdev,
>> +				     unsigned long apqi)
>> +{
>> +	unsigned long apid;
>> +
>> +	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, AP_DEVICES)
>> +		vfio_ap_mdev_link_apqn(matrix_mdev, AP_MKQID(apid, apqi));
>> +}
>> +
>>   /**
>>    * assign_domain_store
>>    *
>> @@ -763,6 +811,7 @@ static ssize_t assign_domain_store(struct device *dev,
>>   	if (ret)
>>   		goto share_err;
>>   
>> +	vfio_ap_mdev_link_domain(matrix_mdev, apqi);
>>   	ret = count;
>>   	goto done;
>>   
>> @@ -775,6 +824,14 @@ static ssize_t assign_domain_store(struct device *dev,
>>   }
>>   static DEVICE_ATTR_WO(assign_domain);
>>   
>> +static void vfio_ap_mdev_unlink_domain(struct ap_matrix_mdev *matrix_mdev,
>> +				       unsigned long apqi)
>> +{
>> +	unsigned long apid;
>> +
>> +	for_each_set_bit_inv(apid, matrix_mdev->matrix.apm, AP_DEVICES)
>> +		vfio_ap_mdev_unlink_apqn(AP_MKQID(apid, apqi));
>> +}
>>   
>>   /**
>>    * unassign_domain_store
>> @@ -815,6 +872,7 @@ static ssize_t unassign_domain_store(struct device *dev,
>>   
>>   	mutex_lock(&matrix_dev->lock);
>>   	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
>> +	vfio_ap_mdev_unlink_domain(matrix_mdev, apqi);
>>   	mutex_unlock(&matrix_dev->lock);
>>   
>>   	return count;
>> @@ -1317,6 +1375,28 @@ void vfio_ap_mdev_unregister(void)
>>   	mdev_unregister_device(&matrix_dev->device);
>>   }
>>   
>> +/*
>> + * vfio_ap_queue_link_mdev
>> + *
>> + * @q: The queue to link with the matrix mdev.
>> + *
>> + * Links @q with the matrix mdev to which the queue's APQN is assigned.
>> + */
>> +static void vfio_ap_queue_link_mdev(struct vfio_ap_queue *q)
>> +{
>> +	unsigned long apid = AP_QID_CARD(q->apqn);
>> +	unsigned long apqi = AP_QID_QUEUE(q->apqn);
>> +	struct ap_matrix_mdev *matrix_mdev;
>> +
>> +	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
>> +		if (test_bit_inv(apid, matrix_mdev->matrix.apm) &&
>> +		    test_bit_inv(apqi, matrix_mdev->matrix.aqm)) {
>> +			vfio_ap_mdev_link_queue(matrix_mdev, q);
>> +			break;
>> +		}
>> +	}
>> +}
>> +
>>   int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
>>   {
>>   	struct vfio_ap_queue *q;
>> @@ -1324,9 +1404,13 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
>>   	q = kzalloc(sizeof(*q), GFP_KERNEL);
>>   	if (!q)
>>   		return -ENOMEM;
>> +	mutex_lock(&matrix_dev->lock);
>>   	dev_set_drvdata(&apdev->device, q);
>>   	q->apqn = to_ap_queue(&apdev->device)->qid;
>>   	q->saved_isc = VFIO_AP_ISC_INVALID;
>> +	vfio_ap_queue_link_mdev(q);
>> +	mutex_unlock(&matrix_dev->lock);
>> +
> Does the critical section have to include more than just
> vfio_ap_queue_link_mdev()? Did we need the critical section
> before this patch?

We did not need the critical section before this patch because
the only function that retrieved the vfio_ap_queue via the queue
device's drvdata was the remove callback. I included the initialization
of the vfio_ap_queue object under lock because the
vfio_ap_find_queue() function retrieves the vfio_ap_queue object from
the queue device's drvdata so it might be advantageous to initialize
it under the mdev lock. On the other hand, I can't come up with a good
argument to change this.


>
>>   	return 0;
>>   }
>>   
>> @@ -1341,6 +1425,10 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
>>   	apid = AP_QID_CARD(q->apqn);
>>   	apqi = AP_QID_QUEUE(q->apqn);
>>   	vfio_ap_mdev_reset_queue(apid, apqi, 1);
>> +
>> +	if (q->matrix_mdev)
>> +		vfio_ap_mdev_unlink_queue(q);
>> +
>>   	kfree(q);
>>   	mutex_unlock(&matrix_dev->lock);
>>   }
>> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
>> index d9003de4fbad..4e5cc72fc0db 100644
>> --- a/drivers/s390/crypto/vfio_ap_private.h
>> +++ b/drivers/s390/crypto/vfio_ap_private.h
>> @@ -18,6 +18,7 @@
>>   #include <linux/delay.h>
>>   #include <linux/mutex.h>
>>   #include <linux/kvm_host.h>
>> +#include <linux/hashtable.h>
>>   
>>   #include "ap_bus.h"
>>   
>> @@ -86,6 +87,7 @@ struct ap_matrix_mdev {
>>   	struct kvm *kvm;
>>   	struct kvm_s390_module_hook pqap_hook;
>>   	struct mdev_device *mdev;
>> +	DECLARE_HASHTABLE(qtable, 8);
>>   };
>>   
>>   extern int vfio_ap_mdev_register(void);
>> @@ -97,6 +99,7 @@ struct vfio_ap_queue {
>>   	int	apqn;
>>   #define VFIO_AP_ISC_INVALID 0xff
>>   	unsigned char saved_isc;
>> +	struct hlist_node mdev_qnode;
>>   };
>>   
>>   int vfio_ap_mdev_probe_queue(struct ap_device *queue);

