Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD912278217
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 09:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727686AbgIYH7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 03:59:05 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31716 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727238AbgIYH7E (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 03:59:04 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08P7hoUX087633;
        Fri, 25 Sep 2020 03:59:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=vM6Zjw8IKDbZNdiUj0mjH4/SPLuNvvyuqwaKXvvJk9U=;
 b=R/KTDJordHYF0WbATfHDuzlHoeXk26dqhdm+Dc4PDvBIuzkZAchICwGD58NjgBw3pgkt
 TAfZ2aQpFVRsD2iGkFXjP5cM9N2Whh2Dqwi02aDqi5JVmCrScYGNqdJXWghtll+fAazf
 /0mKStnUyfOCwisf9An5xmmeRRmuBd2Hdbsit9cVVp9VxFfC0udZMqLoVV7Gfl+vGzrR
 v8xH7ANi08Yl9/SfX75MLsZnvlWADA1TOfOXWyRPuCtOn4H/RqoaB1km4R1zV+K31cyM
 STTVFc5U5N8Sxma1VuQc/IymLRndjOPcEV5t80x/dVJ3CPPTxG2X9iV+UPDqSVE9nQZN jA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33scdkrbaq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Sep 2020 03:59:03 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08P7jfE1095813;
        Fri, 25 Sep 2020 03:59:03 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33scdkrb9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Sep 2020 03:59:03 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08P7rv8b023875;
        Fri, 25 Sep 2020 07:59:00 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 33n98gu5bd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Sep 2020 07:59:00 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08P7wvqb26870186
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Sep 2020 07:58:57 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 48B5252069;
        Fri, 25 Sep 2020 07:58:57 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.53.230])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 87A6652059;
        Fri, 25 Sep 2020 07:58:56 +0000 (GMT)
Date:   Fri, 25 Sep 2020 09:58:54 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v10 03/16] s390/vfio-ap: manage link between queue
 struct and matrix mdev
Message-ID: <20200925095854.41eb1c05.pasic@linux.ibm.com>
In-Reply-To: <20200821195616.13554-4-akrowiak@linux.ibm.com>
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
        <20200821195616.13554-4-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-25_02:2020-09-24,2020-09-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=2 clxscore=1015
 impostorscore=0 spamscore=0 bulkscore=0 phishscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009250050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 Aug 2020 15:56:03 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> Let's create links between each queue device bound to the vfio_ap device

How about: Let us establish a bidirectional link...

we kind of had a shaky queue --> matrix_mdev link prior to this patch,
you are making this one solid and you are adding the matrix_mdev -->
queue link.

> driver and the matrix mdev to which the queue is assigned. The idea is to
> facilitate efficient retrieval of the objects representing the queue
> devices and matrix mdevs as well as to verify that a queue assigned to
> a matrix mdev is bound to the driver.
> 

I will have to look at the rest of the series to figure the usage out.
One thought in the back of my head is that if vfio_ap_get_queue(apqn) is
already O(1) the there is not much efficiency to gain by adding another
hashtable whose keys are apqns and values queues.

But I don't want to hang up myself on this.

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

Except for the things pointed out by Connie and Christian, LGTM.

> ---
>  drivers/s390/crypto/vfio_ap_ops.c     | 132 +++++++++++++++++++++++++-
>  drivers/s390/crypto/vfio_ap_private.h |   2 +
>  2 files changed, 129 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index ad3925f04f61..2e37ee82e422 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -50,6 +50,19 @@ static struct vfio_ap_queue *vfio_ap_get_queue(unsigned long apqn)
>  	return q;
>  }
>  
> +static struct vfio_ap_queue *vfio_ap_get_mdev_queue(struct ap_matrix_mdev *matrix_mdev,
> +						    unsigned long apqn)
> +{
> +	struct vfio_ap_queue *q;
> +
> +	hash_for_each_possible(matrix_mdev->qtable, q, mdev_qnode, apqn) {
> +		if (q && (q->apqn == apqn))
> +			return q;
> +	}
> +
> +	return NULL;
> +}
> +
>  /**
>   * vfio_ap_wait_for_irqclear
>   * @apqn: The AP Queue number
> @@ -160,7 +173,6 @@ static struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q)
>  		  status.response_code);
>  end_free:
>  	vfio_ap_free_aqic_resources(q);
> -	q->matrix_mdev = NULL;
>  	return status;
>  }
>  
> @@ -262,7 +274,6 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
>  	struct vfio_ap_queue *q;
>  	struct ap_queue_status qstatus = {
>  			       .response_code = AP_RESPONSE_Q_NOT_AVAIL, };
> -	struct ap_matrix_mdev *matrix_mdev;
>  
>  	/* If we do not use the AIV facility just go to userland */
>  	if (!(vcpu->arch.sie_block->eca & ECA_AIV))
> @@ -273,14 +284,11 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
>  
>  	if (!vcpu->kvm->arch.crypto.pqap_hook)
>  		goto out_unlock;
> -	matrix_mdev = container_of(vcpu->kvm->arch.crypto.pqap_hook,
> -				   struct ap_matrix_mdev, pqap_hook);
>  
>  	q = vfio_ap_get_queue(apqn);
>  	if (!q)
>  		goto out_unlock;
>  
> -	q->matrix_mdev = matrix_mdev;
>  	status = vcpu->run->s.regs.gprs[1];
>  
>  	/* If IR bit(16) is set we enable the interrupt */
> @@ -320,6 +328,7 @@ static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
>  
>  	matrix_mdev->mdev = mdev;
>  	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->matrix);
> +	hash_init(matrix_mdev->qtable);
>  	mdev_set_drvdata(mdev, matrix_mdev);
>  	matrix_mdev->pqap_hook.hook = handle_pqap;
>  	matrix_mdev->pqap_hook.owner = THIS_MODULE;
> @@ -548,6 +557,87 @@ static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev)
>  	return 0;
>  }
>  
> +enum qlink_type {
> +	LINK_APID,
> +	LINK_APQI,
> +	UNLINK_APID,
> +	UNLINK_APQI,
> +};
> +
> +static void vfio_ap_mdev_link_queue(struct ap_matrix_mdev *matrix_mdev,
> +				    unsigned long apid, unsigned long apqi)
> +{
> +	struct vfio_ap_queue *q;
> +
> +	q = vfio_ap_get_queue(AP_MKQID(apid, apqi));
> +	if (q) {
> +		q->matrix_mdev = matrix_mdev;
> +		hash_add(matrix_mdev->qtable,
> +			 &q->mdev_qnode, q->apqn);
> +	}
> +}
> +
> +static void vfio_ap_mdev_unlink_queue(unsigned long apid, unsigned long apqi)
> +{
> +	struct vfio_ap_queue *q;
> +
> +	q = vfio_ap_get_queue(AP_MKQID(apid, apqi));
> +	if (q) {
> +		q->matrix_mdev = NULL;
> +		hash_del(&q->mdev_qnode);
> +	}
> +}
> +
> +/**
> + * vfio_ap_mdev_link_queues
> + *
> + * @matrix_mdev: The matrix mdev to link.
> + * @type:	 The type of @qlink_id.
> + * @qlink_id:	 The APID or APQI of the queues to link.
> + *
> + * Sets or clears the links between the queues with the specified @qlink_id
> + * and the @matrix_mdev:
> + *     @type == LINK_APID: Set the links between the @matrix_mdev and the
> + *                         queues with the specified @qlink_id (APID)
> + *     @type == LINK_APQI: Set the links between the @matrix_mdev and the
> + *                         queues with the specified @qlink_id (APQI)
> + *     @type == UNLINK_APID: Clear the links between the @matrix_mdev and the
> + *                           queues with the specified @qlink_id (APID)
> + *     @type == UNLINK_APQI: Clear the links between the @matrix_mdev and the
> + *                           queues with the specified @qlink_id (APQI)
> + */
> +static void vfio_ap_mdev_link_queues(struct ap_matrix_mdev *matrix_mdev,
> +				     enum qlink_type type,
> +				     unsigned long qlink_id)
> +{
> +	unsigned long id;
> +
> +	switch (type) {
> +	case LINK_APID:
> +		for_each_set_bit_inv(id, matrix_mdev->matrix.aqm,
> +				     matrix_mdev->matrix.aqm_max + 1)
> +			vfio_ap_mdev_link_queue(matrix_mdev, qlink_id, id);
> +		break;
> +	case UNLINK_APID:
> +		for_each_set_bit_inv(id, matrix_mdev->matrix.aqm,
> +				     matrix_mdev->matrix.aqm_max + 1)
> +			vfio_ap_mdev_unlink_queue(qlink_id, id);
> +		break;
> +	case LINK_APQI:
> +		for_each_set_bit_inv(id, matrix_mdev->matrix.apm,
> +				     matrix_mdev->matrix.apm_max + 1)
> +			vfio_ap_mdev_link_queue(matrix_mdev, id, qlink_id);
> +		break;
> +	case UNLINK_APQI:
> +		for_each_set_bit_inv(id, matrix_mdev->matrix.apm,
> +				     matrix_mdev->matrix.apm_max + 1)
> +			vfio_ap_mdev_link_queue(matrix_mdev, id, qlink_id);
> +		break;
> +	default:
> +		WARN_ON_ONCE(1);
> +	}
> +}
> +
>  /**
>   * assign_adapter_store
>   *
> @@ -617,6 +707,7 @@ static ssize_t assign_adapter_store(struct device *dev,
>  	if (ret)
>  		goto share_err;
>  
> +	vfio_ap_mdev_link_queues(matrix_mdev, LINK_APID, apid);
>  	ret = count;
>  	goto done;
>  
> @@ -668,6 +759,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
>  
>  	mutex_lock(&matrix_dev->lock);
>  	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
> +	vfio_ap_mdev_link_queues(matrix_mdev, UNLINK_APID, apid);
>  	mutex_unlock(&matrix_dev->lock);
>  
>  	return count;
> @@ -758,6 +850,7 @@ static ssize_t assign_domain_store(struct device *dev,
>  	if (ret)
>  		goto share_err;
>  
> +	vfio_ap_mdev_link_queues(matrix_mdev, LINK_APQI, apqi);
>  	ret = count;
>  	goto done;
>  
> @@ -810,6 +903,7 @@ static ssize_t unassign_domain_store(struct device *dev,
>  
>  	mutex_lock(&matrix_dev->lock);
>  	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
> +	vfio_ap_mdev_link_queues(matrix_mdev, UNLINK_APQI, apqi);
>  	mutex_unlock(&matrix_dev->lock);
>  
>  	return count;
> @@ -1282,6 +1376,29 @@ void vfio_ap_mdev_unregister(void)
>  	mdev_unregister_device(&matrix_dev->device);
>  }
>  
> +/**
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
> +			q->matrix_mdev = matrix_mdev;
> +			hash_add(matrix_mdev->qtable, &q->mdev_qnode, q->apqn);
> +			break;
> +		}
> +	}
> +}
> +
>  int vfio_ap_mdev_probe_queue(struct ap_queue *queue)
>  {
>  	struct vfio_ap_queue *q;
> @@ -1290,9 +1407,12 @@ int vfio_ap_mdev_probe_queue(struct ap_queue *queue)
>  	if (!q)
>  		return -ENOMEM;
>  
> +	mutex_lock(&matrix_dev->lock);
>  	dev_set_drvdata(&queue->ap_dev.device, q);
>  	q->apqn = queue->qid;
>  	q->saved_isc = VFIO_AP_ISC_INVALID;
> +	vfio_ap_queue_link_mdev(q);
> +	mutex_unlock(&matrix_dev->lock);
>  
>  	return 0;
>  }
> @@ -1309,6 +1429,8 @@ void vfio_ap_mdev_remove_queue(struct ap_queue *queue)
>  	apqi = AP_QID_QUEUE(q->apqn);
>  	vfio_ap_mdev_reset_queue(apid, apqi, 1);
>  	vfio_ap_irq_disable(q);
> +	if (q->matrix_mdev)
> +		hash_del(&q->mdev_qnode);
>  	kfree(q);
>  	mutex_unlock(&matrix_dev->lock);
>  }
> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
> index a2aa05bec718..57da703b549a 100644
> --- a/drivers/s390/crypto/vfio_ap_private.h
> +++ b/drivers/s390/crypto/vfio_ap_private.h
> @@ -87,6 +87,7 @@ struct ap_matrix_mdev {
>  	struct kvm *kvm;
>  	struct kvm_s390_module_hook pqap_hook;
>  	struct mdev_device *mdev;
> +	DECLARE_HASHTABLE(qtable, 8);
>  };
>  
>  extern int vfio_ap_mdev_register(void);
> @@ -98,6 +99,7 @@ struct vfio_ap_queue {
>  	int	apqn;
>  #define VFIO_AP_ISC_INVALID 0xff
>  	unsigned char saved_isc;
> +	struct hlist_node mdev_qnode;
>  };
>  
>  int vfio_ap_mdev_probe_queue(struct ap_queue *queue);

