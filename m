Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F5022C0F2
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 10:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgGXIiQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 04:38:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46890 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726573AbgGXIiP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Jul 2020 04:38:15 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06O8WmDB172246;
        Fri, 24 Jul 2020 04:38:12 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32fae1k9dv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jul 2020 04:38:11 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06O8YR5i177736;
        Fri, 24 Jul 2020 04:38:11 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32fae1k9da-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jul 2020 04:38:11 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06O8aZ45014818;
        Fri, 24 Jul 2020 08:38:09 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 32brq7x3da-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Jul 2020 08:38:09 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06O8c6qC31654192
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jul 2020 08:38:06 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 985A8A405F;
        Fri, 24 Jul 2020 08:38:06 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4A06A4060;
        Fri, 24 Jul 2020 08:38:05 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.28.3])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 24 Jul 2020 08:38:05 +0000 (GMT)
Subject: Re: [PATCH v9 02/15] s390/vfio-ap: use new AP bus interface to search
 for queue devices
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, kernel test robot <lkp@intel.com>
References: <20200720150344.24488-1-akrowiak@linux.ibm.com>
 <20200720150344.24488-3-akrowiak@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <a946e992-ff36-ca45-1811-7c6b0aaa161f@linux.ibm.com>
Date:   Fri, 24 Jul 2020 10:38:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200720150344.24488-3-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-24_02:2020-07-24,2020-07-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 bulkscore=0
 impostorscore=0 spamscore=0 clxscore=1011 malwarescore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007240059
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-07-20 17:03, Tony Krowiak wrote:
> This patch refactor's the vfio_ap device driver to use the AP bus's
> ap_get_qdev() function to retrieve the vfio_ap_queue struct containing
> information about a queue that is bound to the vfio_ap device driver.
> The bus's ap_get_qdev() function retrieves the queue device from a
> hashtable keyed by APQN. This is much more efficient than looping over
> the list of devices attached to the AP bus by several orders of
> magnitude.

The patch does much more than modifying this line. ;)

> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> Reported-by: kernel test robot <lkp@intel.com>
> ---
>   drivers/s390/crypto/vfio_ap_drv.c     | 27 ++-------
>   drivers/s390/crypto/vfio_ap_ops.c     | 86 +++++++++++++++------------
>   drivers/s390/crypto/vfio_ap_private.h |  8 ++-
>   3 files changed, 59 insertions(+), 62 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
> index f4ceb380dd61..24cdef60039a 100644
> --- a/drivers/s390/crypto/vfio_ap_drv.c
> +++ b/drivers/s390/crypto/vfio_ap_drv.c
> @@ -53,15 +53,9 @@ MODULE_DEVICE_TABLE(vfio_ap, ap_queue_ids);
>    */
>   static int vfio_ap_queue_dev_probe(struct ap_device *apdev)
>   {
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
>   }

You should explain the reason why this function is modified.

>   
>   /**
> @@ -72,18 +66,9 @@ static int vfio_ap_queue_dev_probe(struct ap_device *apdev)
>    */
>   static void vfio_ap_queue_dev_remove(struct ap_device *apdev)
>   {
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
>   }

... and this one?

>   
>   static void vfio_ap_matrix_dev_release(struct device *dev)
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index e0bde8518745..ad3925f04f61 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -26,43 +26,26 @@
>   
>   static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
>   
> -static int match_apqn(struct device *dev, const void *data)
> -{
> -	struct vfio_ap_queue *q = dev_get_drvdata(dev);
> -
> -	return (q->apqn == *(int *)(data)) ? 1 : 0;
> -}
> -
>   /**
> - * vfio_ap_get_queue: Retrieve a queue with a specific APQN from a list
> - * @matrix_mdev: the associated mediated matrix
> + * vfio_ap_get_queue: Retrieve a queue with a specific APQN.
>    * @apqn: The queue APQN
>    *
> - * Retrieve a queue with a specific APQN from the list of the
> - * devices of the vfio_ap_drv.
> - * Verify that the APID and the APQI are set in the matrix.
> + * Retrieve a queue with a specific APQN from the AP queue devices attached to
> + * the AP bus.
>    *
> - * Returns the pointer to the associated vfio_ap_queue
> + * Returns the pointer to the vfio_ap_queue with the specified APQN, or NULL.
>    */
> -static struct vfio_ap_queue *vfio_ap_get_queue(
> -					struct ap_matrix_mdev *matrix_mdev,
> -					int apqn)
> +static struct vfio_ap_queue *vfio_ap_get_queue(unsigned long apqn)
>   {
> +	struct ap_queue *queue;
>   	struct vfio_ap_queue *q;
> -	struct device *dev;
>   
> -	if (!test_bit_inv(AP_QID_CARD(apqn), matrix_mdev->matrix.apm))
> -		return NULL;
> -	if (!test_bit_inv(AP_QID_QUEUE(apqn), matrix_mdev->matrix.aqm))
> +	queue = ap_get_qdev(apqn);
> +	if (!queue)
>   		return NULL;
>   
> -	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
> -				 &apqn, match_apqn);
> -	if (!dev)
> -		return NULL;
> -	q = dev_get_drvdata(dev);
> -	q->matrix_mdev = matrix_mdev;
> -	put_device(dev);
> +	q = dev_get_drvdata(&queue->ap_dev.device);
> +	put_device(&queue->ap_dev.device);
>   
>   	return q;
>   }

this function changed a lot too, you should explain the goal in the 
patch comment.

...snip...

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
