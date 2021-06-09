Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 095303A1626
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 15:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236825AbhFINyb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 09:54:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18192 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236601AbhFINya (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 09:54:30 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 159DX8SS035352;
        Wed, 9 Jun 2021 09:52:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=reply-to : subject : to
 : cc : references : from : message-id : date : mime-version : in-reply-to
 : content-type : content-transfer-encoding; s=pp1;
 bh=GMrzNFFgUs7qfkOL7nPr/So4LfCK/9yU/maWUS/v4GQ=;
 b=gltyn1dAXdf7FysBD5ET4wIwMA+AIhS947dY+EGajsZvS7aiBKJwB0/3W1NjUepC0Dtd
 KX618YsbhGVgJXKc1xTzPI3eUcWlzT0a93gv17rSXKkgQa/hBkHwN1WlSrotWLCw+SLP
 X34wesKUgAKm5+bf6ADldFBUl+9FRZ3GEwjaI5MGu0radkWhE6TJygX2IpV0pfb2zP4Q
 b0jbQkJjY+Qg1aG/2+fXIy+39J2bkPDsjkuJQjO2jNeDyb1b21iHw8kqGxtoMNRpXtV3
 RuzXFs9JOY9+xMfp5u+u3ATPGU6powjr8TJyDAMFijvu66k04oBCQc0PDV27SV1Rv5Eh 8A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 392qae6k3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Jun 2021 09:52:33 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 159Db6EL054161;
        Wed, 9 Jun 2021 09:52:33 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 392qae6k39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Jun 2021 09:52:33 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 159Dpf5Z017790;
        Wed, 9 Jun 2021 13:52:31 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma03wdc.us.ibm.com with ESMTP id 3900wa0290-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Jun 2021 13:52:31 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 159DqU3428836282
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Jun 2021 13:52:30 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 56B71AE066;
        Wed,  9 Jun 2021 13:52:30 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6710AE060;
        Wed,  9 Jun 2021 13:52:29 +0000 (GMT)
Received: from [9.85.129.42] (unknown [9.85.129.42])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  9 Jun 2021 13:52:29 +0000 (GMT)
Reply-To: jjherne@linux.ibm.com
Subject: Re: [PATCH v16 02/14] s390/vfio-ap: use new AP bus interface to
 search for queue devices
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20210510164423.346858-1-akrowiak@linux.ibm.com>
 <20210510164423.346858-3-akrowiak@linux.ibm.com>
From:   "Jason J. Herne" <jjherne@linux.ibm.com>
Organization: IBM
Message-ID: <06270f45-898b-5869-874d-008e3410c0de@linux.ibm.com>
Date:   Wed, 9 Jun 2021 09:52:29 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20210510164423.346858-3-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ItsiQf8RQRW91hEkkI7sRXtRTrnHgonA
X-Proofpoint-ORIG-GUID: vdB4Tvs2_hHdyJCk8gapm8qJrmaBkEC6
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-09_04:2021-06-04,2021-06-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 phishscore=0
 spamscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 suspectscore=0 priorityscore=1501 clxscore=1011
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106090067
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/10/21 12:44 PM, Tony Krowiak wrote:
> This patch refactors the vfio_ap device driver to use the AP bus's
> ap_get_qdev() function to retrieve the vfio_ap_queue struct containing
> information about a queue that is bound to the vfio_ap device driver.
> The bus's ap_get_qdev() function retrieves the queue device from a
> hashtable keyed by APQN. This is much more efficient than looping over
> the list of devices attached to the AP bus by several orders of
> magnitude.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
> ---
>   drivers/s390/crypto/vfio_ap_ops.c | 23 +++++++++--------------
>   1 file changed, 9 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 757166da947e..8a50aa650b65 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -27,13 +27,6 @@
>   static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev);
>   static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
>   
> -static int match_apqn(struct device *dev, const void *data)
> -{
> -	struct vfio_ap_queue *q = dev_get_drvdata(dev);
> -
> -	return (q->apqn == *(int *)(data)) ? 1 : 0;
> -}
> -
>   /**
>    * vfio_ap_get_queue: Retrieve a queue with a specific APQN from a list
>    * @matrix_mdev: the associated mediated matrix
> @@ -1253,15 +1246,17 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>   
>   static struct vfio_ap_queue *vfio_ap_find_queue(int apqn)
>   {
> -	struct device *dev;
> +	struct ap_queue *queue;
>   	struct vfio_ap_queue *q = NULL;

The use of q and queue as variable names was a little confusing to me at first. I tried 
renaming them a few times, the best I could come up with was this:

struct ap_queue *queue;
struct vfio_ap_queue *vfio_queue = NULL;

Take it or leave it :) Other than that, LGTM.
Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>


> -	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
> -				 &apqn, match_apqn);
> -	if (dev) {
> -		q = dev_get_drvdata(dev);
> -		put_device(dev);
> -	}
> +	queue = ap_get_qdev(apqn);
> +	if (!queue)
> +		return NULL;
> +
> +	if (queue->ap_dev.device.driver == &matrix_dev->vfio_ap_drv->driver)
> +		q = dev_get_drvdata(&queue->ap_dev.device);
> +
> +	put_device(&queue->ap_dev.device);
>   
>   	return q;
>   }
> 


-- 
-- Jason J. Herne (jjherne@linux.ibm.com)
