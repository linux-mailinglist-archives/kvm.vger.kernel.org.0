Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1732F1B00
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 17:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731400AbhAKQc7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 11:32:59 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17838 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728828AbhAKQc6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Jan 2021 11:32:58 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10BG3ZER138970;
        Mon, 11 Jan 2021 11:32:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=OaLs4hT9XBUJrJ2iA9T+167zE8uCTFn9nm39hf8oNV8=;
 b=IU4uuQC66IK6mlREy5BOXCPZ08d3bmmgCrET+Fsn3/xkPg6BWrJ8V9sOZz0etUzcxJq2
 rdKDJSU8jsoFfetEfHxVYvlfVdbt2z2ksXwl9l1v6E/qcZGcqIsYilSzQNOqNZjfMmxk
 znaMAMyxwXLi0ZjavGuCUKvLeROCNLNg5spzXO+xf+H0x81Kk0OX9vlXREAv4zLdi0po
 LroF2G/fzGuZxDerIMnYykHZGjx8vOB8jtvEv/Urqx2ShaSX9nCOwrS9lkJMv6PK1gZr
 sZFIa7RGBru9rl9WV9t53J4+LYNhX5XHp9UxEsnkEHP4SczgRxV3/OybbVKvLAGPhXoj Tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 360s3xtnpp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 11:32:15 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10BG3ouM140877;
        Mon, 11 Jan 2021 11:32:14 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 360s3xtnnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 11:32:14 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10BGO8Jx003731;
        Mon, 11 Jan 2021 16:32:13 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 35ydrda2uu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 16:32:12 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10BGW5FA32047552
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Jan 2021 16:32:05 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12816A4054;
        Mon, 11 Jan 2021 16:32:10 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 48BD5A405B;
        Mon, 11 Jan 2021 16:32:09 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.62.86])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Mon, 11 Jan 2021 16:32:09 +0000 (GMT)
Date:   Mon, 11 Jan 2021 17:32:06 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v13 02/15] s390/vfio-ap: No need to disable IRQ after
 queue reset
Message-ID: <20210111173206.27808b79.pasic@linux.ibm.com>
In-Reply-To: <20201223011606.5265-3-akrowiak@linux.ibm.com>
References: <20201223011606.5265-1-akrowiak@linux.ibm.com>
        <20201223011606.5265-3-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_26:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 spamscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101110096
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 22 Dec 2020 20:15:53 -0500
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
> ---
>  drivers/s390/crypto/vfio_ap_drv.c     |  1 -
>  drivers/s390/crypto/vfio_ap_ops.c     | 40 +++++++++++++++++----------
>  drivers/s390/crypto/vfio_ap_private.h |  1 -
>  3 files changed, 26 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
> index be2520cc010b..ca18c91afec9 100644
> --- a/drivers/s390/crypto/vfio_ap_drv.c
> +++ b/drivers/s390/crypto/vfio_ap_drv.c
> @@ -79,7 +79,6 @@ static void vfio_ap_queue_dev_remove(struct ap_device *apdev)
>  	apid = AP_QID_CARD(q->apqn);
>  	apqi = AP_QID_QUEUE(q->apqn);
>  	vfio_ap_mdev_reset_queue(apid, apqi, 1);
> -	vfio_ap_irq_disable(q);
>  	kfree(q);
>  	mutex_unlock(&matrix_dev->lock);
>  }
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 7339043906cf..052f61391ec7 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -25,6 +25,7 @@
>  #define VFIO_AP_MDEV_NAME_HWVIRT "VFIO AP Passthrough Device"
>  
>  static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
> +static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
>  
>  static int match_apqn(struct device *dev, const void *data)
>  {
> @@ -49,20 +50,15 @@ static struct vfio_ap_queue *(
>  					int apqn)
>  {
>  	struct vfio_ap_queue *q;
> -	struct device *dev;
>  
>  	if (!test_bit_inv(AP_QID_CARD(apqn), matrix_mdev->matrix.apm))
>  		return NULL;
>  	if (!test_bit_inv(AP_QID_QUEUE(apqn), matrix_mdev->matrix.aqm))
>  		return NULL;
>  
> -	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
> -				 &apqn, match_apqn);
> -	if (!dev)
> -		return NULL;
> -	q = dev_get_drvdata(dev);
> -	q->matrix_mdev = matrix_mdev;
> -	put_device(dev);
> +	q = vfio_ap_find_queue(apqn);
> +	if (q)
> +		q->matrix_mdev = matrix_mdev;
>  
>  	return q;
>  }
> @@ -1126,24 +1122,27 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>  	return notify_rc;
>  }
>  
> -static void vfio_ap_irq_disable_apqn(int apqn)
> +static struct vfio_ap_queue *vfio_ap_find_queue(int apqn)
>  {
>  	struct device *dev;
> -	struct vfio_ap_queue *q;
> +	struct vfio_ap_queue *q = NULL;
>  
>  	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
>  				 &apqn, match_apqn);
>  	if (dev) {
>  		q = dev_get_drvdata(dev);
> -		vfio_ap_irq_disable(q);
>  		put_device(dev);
>  	}
> +
> +	return q;
>  }

This hunk and the previous one are a rewrite of vfio_ap_get_queue() and
have next to nothing to do with the patch's objective. If we were at an
earlier stage, I would ask to split it up.

>  
>  int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
>  			     unsigned int retry)
>  {
>  	struct ap_queue_status status;
> +	struct vfio_ap_queue *q;
> +	int ret;
>  	int retry2 = 2;
>  	int apqn = AP_MKQID(apid, apqi);
>  
> @@ -1156,18 +1155,32 @@ int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
>  				status = ap_tapq(apqn, NULL);
>  			}
>  			WARN_ON_ONCE(retry2 <= 0);
> -			return 0;
> +			ret = 0;
> +			goto free_aqic_resources;
>  		case AP_RESPONSE_RESET_IN_PROGRESS:
>  		case AP_RESPONSE_BUSY:
>  			msleep(20);
>  			break;
>  		default:
>  			/* things are really broken, give up */
> -			return -EIO;
> +			ret = -EIO;
> +			goto free_aqic_resources;

Do we really want the unpin here? I mean the reset did not work and
we are giving up. So the irqs are potentially still enabled.

Without this patch we try to disable the interrupts using AQIC, and
do the cleanup after that.

I'm aware, the comment says we should not take the default branch,
but if that's really the case we should IMHO log an error and leak the
page.

It's up to you if you want to change this. I don't want to delay the
series any further than absolutely necessary.

Acked-by: Halil Pasic <pasic@linux.ibm.com>

>  		}
>  	} while (retry--);
>  
>  	return -EBUSY;
> +
> +free_aqic_resources:
> +	/*
> +	 * In order to free the aqic resources, the queue must be linked to
> +	 * the matrix_mdev to which its APQN is assigned and the KVM pointer
> +	 * must be available.
> +	 */
> +	q = vfio_ap_find_queue(apqn);
> +	if (q && q->matrix_mdev && q->matrix_mdev->kvm)

Is this of the type "we know there are no aqic resources to be freed" if
precondition is false?

vfio_ap_free_aqic_resources() checks the matrix_mdev pointer but not the
kvm pointer. Could we just check the kvm pointer in
vfio_ap_free_aqic_resources()?

At the end of the series, is seeing q! indicating a bug, or is it
something we expect to see under certain circumstances?


> +		vfio_ap_free_aqic_resources(q);
> +
> +	return ret;
>  }
>  
>  static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
> @@ -1189,7 +1202,6 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
>  			 */
>  			if (ret)
>  				rc = ret;
> -			vfio_ap_irq_disable_apqn(AP_MKQID(apid, apqi));
>  		}
>  	}
>  
> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
> index f46dde56b464..0db6fb3d56d5 100644
> --- a/drivers/s390/crypto/vfio_ap_private.h
> +++ b/drivers/s390/crypto/vfio_ap_private.h
> @@ -100,5 +100,4 @@ struct vfio_ap_queue {
>  #define VFIO_AP_ISC_INVALID 0xff
>  	unsigned char saved_isc;
>  };
> -struct ap_queue_status vfio_ap_irq_disable(struct vfio_ap_queue *q);
>  #endif /* _VFIO_AP_PRIVATE_H_ */

