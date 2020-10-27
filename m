Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6407E29A523
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 08:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507065AbgJ0HCz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 03:02:55 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55810 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2409081AbgJ0HCz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Oct 2020 03:02:55 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09R72BCI072408;
        Tue, 27 Oct 2020 03:02:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=jiYXiRnfYmQeSErl7SLv/32EUQoerdoMJWU7dTGNKX4=;
 b=JprEVhk00acUFavytnTbpwN0T2e9VQkCs/Zw4ffxlNQLuzymvxY4/SdzrOFe1T6lU232
 QWL9EEuP9amV94LjPKDkw2Bdu3qbKRHlASHA9pL0nFZJiktbp2EvGDH3mrGCw0aTbwkO
 nQqgcrH2zfVH0cRuhKuyVHQLS0FI94fbhqk53aqu24UvI1yudWuHEncI2twdIujA60uh
 lWnysaHy3+jsxAnxQcIpyxPRiVA2YVMlFZzto1xDD2art13NIcQW1Eg20Q00jaxDevq8
 duI7yp7KWTK/yYLESF3YxhHwOmwXfcymIG/lwq+razQTVNT2kDeJ1EaklaTvP1ABkk6I Xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34e4jvxm4d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Oct 2020 03:02:54 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09R72rGa076285;
        Tue, 27 Oct 2020 03:02:53 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34e4jvxm2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Oct 2020 03:02:53 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09R6uv43023600;
        Tue, 27 Oct 2020 07:02:51 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 34cbhh31rq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Oct 2020 07:02:50 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09R72mpk32178478
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 07:02:48 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C3A0AE04D;
        Tue, 27 Oct 2020 07:02:48 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60D5BAE053;
        Tue, 27 Oct 2020 07:02:47 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.77.212])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 27 Oct 2020 07:02:47 +0000 (GMT)
Date:   Tue, 27 Oct 2020 08:01:58 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v11 02/14] 390/vfio-ap: use new AP bus interface to
 search for queue devices
Message-ID: <20201027080158.0a4fa6b2.pasic@linux.ibm.com>
In-Reply-To: <20201022171209.19494-3-akrowiak@linux.ibm.com>
References: <20201022171209.19494-1-akrowiak@linux.ibm.com>
        <20201022171209.19494-3-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-27_03:2020-10-26,2020-10-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010270043
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 22 Oct 2020 13:11:57 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> This patch refactors the vfio_ap device driver to use the AP bus's
> ap_get_qdev() function to retrieve the vfio_ap_queue struct containing
> information about a queue that is bound to the vfio_ap device driver.
> The bus's ap_get_qdev() function retrieves the queue device from a
> hashtable keyed by APQN. This is much more efficient than looping over
> the list of devices attached to the AP bus by several orders of
> magnitude.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>

Reviewed-by: Halil Pasic <pasic@linux.ibm.com>

> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 35 +++++++++++++------------------
>  1 file changed, 14 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index c471832f0a30..049b97d7444c 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -26,43 +26,36 @@
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
>  /**
> - * vfio_ap_get_queue: Retrieve a queue with a specific APQN from a list
> + * vfio_ap_get_queue: Retrieve a queue with a specific APQN.
>   * @matrix_mdev: the associated mediated matrix
>   * @apqn: The queue APQN
>   *
> - * Retrieve a queue with a specific APQN from the list of the
> - * devices of the vfio_ap_drv.
> - * Verify that the APID and the APQI are set in the matrix.
> + * Retrieve a queue with a specific APQN from the AP queue devices attached to
> + * the AP bus.
>   *
> - * Returns the pointer to the associated vfio_ap_queue
> + * Returns the pointer to the vfio_ap_queue with the specified APQN, or NULL.
>   */
>  static struct vfio_ap_queue *vfio_ap_get_queue(
>  					struct ap_matrix_mdev *matrix_mdev,
> -					int apqn)
> +					unsigned long apqn)
>  {
> -	struct vfio_ap_queue *q;
> -	struct device *dev;
> +	struct ap_queue *queue;
> +	struct vfio_ap_queue *q = NULL;
>  
>  	if (!test_bit_inv(AP_QID_CARD(apqn), matrix_mdev->matrix.apm))
>  		return NULL;
>  	if (!test_bit_inv(AP_QID_QUEUE(apqn), matrix_mdev->matrix.aqm))
>  		return NULL;
>  
> -	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
> -				 &apqn, match_apqn);
> -	if (!dev)
> +	queue = ap_get_qdev(apqn);
> +	if (!queue)
>  		return NULL;
> -	q = dev_get_drvdata(dev);
> -	q->matrix_mdev = matrix_mdev;
> -	put_device(dev);
> +
> +	if (queue->ap_dev.device.driver == &matrix_dev->vfio_ap_drv->driver)
> +		q = dev_get_drvdata(&queue->ap_dev.device);
> +

Needs to be called with the vfio_ap lock held, right? Otherwise the queue could
get unbound while we are working with it as a vfio_ap_queue... Noting
new, but might we worth documenting.

> +	put_device(&queue->ap_dev.device);
>  
>  	return q;
>  }

