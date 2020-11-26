Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCF5B2C55D8
	for <lists+kvm@lfdr.de>; Thu, 26 Nov 2020 14:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389980AbgKZNhr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Nov 2020 08:37:47 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62270 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389919AbgKZNhq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Nov 2020 08:37:46 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AQDWBSV166420;
        Thu, 26 Nov 2020 08:37:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=WSfkROi48m72xER+NaUnW8SnHhGr58DL6BR1O3Z2HfE=;
 b=WmbMh72gkMsyG/gHCfLMLQHNFpWfLKLn03+PX5sRZMz0zRPN0J7UqSjY1kfZ7SW7JxBW
 y4uxgrWF07qvIPnnWKrwsabYKwTA7HJu2KSl/qgv4NOB17ushmvIjCnYqVNl286qAJPH
 +hUfqn+EYA+PpJVot0LCguIsXhTUE+7mLbBMlRP5+ka/0Lh5ztq9YNme/vcloHtiiSug
 02B2un7sS26PAT5IdIByy4SGzpmNYESqYYkNBFsgx87lHZ0NbK7D8GKUr5vXGd3J2vOT
 8EC6wyATQGmGln773Ndl8OUTWS5YWRuxYltR2LuFN/lwLt9XGpkXZ83LW9P3Fm8XhbBF kQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3527ys1fkg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 08:37:43 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AQDXKoB170447;
        Thu, 26 Nov 2020 08:37:43 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3527ys1fjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 08:37:43 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AQDX2AM025464;
        Thu, 26 Nov 2020 13:37:41 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 34xth8dndw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Nov 2020 13:37:41 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AQDbciW59244862
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Nov 2020 13:37:38 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F7A342047;
        Thu, 26 Nov 2020 13:37:38 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44F4542041;
        Thu, 26 Nov 2020 13:37:37 +0000 (GMT)
Received: from oc2783563651 (unknown [9.171.0.176])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Thu, 26 Nov 2020 13:37:37 +0000 (GMT)
Date:   Thu, 26 Nov 2020 14:37:35 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v12 04/17] s390/vfio-ap: No need to disable IRQ after
 queue reset
Message-ID: <20201126143735.65e5d5e8.pasic@linux.ibm.com>
In-Reply-To: <20201124214016.3013-5-akrowiak@linux.ibm.com>
References: <20201124214016.3013-1-akrowiak@linux.ibm.com>
        <20201124214016.3013-5-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-26_04:2020-11-26,2020-11-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 phishscore=0 spamscore=0
 malwarescore=0 suspectscore=2 bulkscore=0 impostorscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011260078
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 24 Nov 2020 16:40:03 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> The queues assigned to a matrix mediated device are currently reset when:
> 
> * The VFIO_DEVICE_RESET ioctl is invoked
> * The mdev fd is closed by userspace (QEMU)
> * The mdev is removed from sysfs.
> 
> Immediately after the reset of a queue, a call is made to disable
> interrupts for the queue. This is entirely unnecessary because the reset of
> a queue disables interrupts, so this will be removed.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>

Reviewed-by: Halil Pasic <pasic@linux.ibm.com>

As I said previously, I would prefer the cleanup of the airq
resources being part of reset_queue(), but I can propose that
later.

> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 28 +++++-----------------------
>  1 file changed, 5 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 8e6972495daa..dc699fd54505 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -26,14 +26,6 @@
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
> -
>  /**
>   * vfio_ap_get_queue: Retrieve a queue with a specific APQN.
>   * @matrix_mdev: the associated mediated matrix
> @@ -1121,20 +1113,6 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>  	return NOTIFY_OK;
>  }
>  
> -static void vfio_ap_irq_disable_apqn(int apqn)
> -{
> -	struct device *dev;
> -	struct vfio_ap_queue *q;
> -
> -	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
> -				 &apqn, match_apqn);
> -	if (dev) {
> -		q = dev_get_drvdata(dev);
> -		vfio_ap_irq_disable(q);
> -		put_device(dev);
> -	}
> -}
> -
>  static int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
>  				    unsigned int retry)
>  {
> @@ -1169,6 +1147,7 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
>  {
>  	int ret;
>  	int rc = 0;
> +	struct vfio_ap_queue *q;
>  	unsigned long apid, apqi;
>  	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>  
> @@ -1184,7 +1163,10 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
>  			 */
>  			if (ret)
>  				rc = ret;
> -			vfio_ap_irq_disable_apqn(AP_MKQID(apid, apqi));
> +
> +			q = vfio_ap_get_queue(matrix_mdev, AP_MKQID(apid, apqi);
> +			if (q)
> +				vfio_ap_free_aqic_resources(q);
>  		}
>  	}
>  

