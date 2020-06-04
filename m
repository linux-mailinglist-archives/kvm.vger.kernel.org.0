Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7851EED79
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 23:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbgFDVrQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 17:47:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23162 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725943AbgFDVrQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Jun 2020 17:47:16 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 054L2h04055403;
        Thu, 4 Jun 2020 17:47:14 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31ek4swnpt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Jun 2020 17:46:48 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 054LkirM164843;
        Thu, 4 Jun 2020 17:46:44 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31ek4swncr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Jun 2020 17:46:44 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 054LUcLu030223;
        Thu, 4 Jun 2020 21:44:31 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 31bf482suq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Jun 2020 21:44:31 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 054LiTen51511446
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 Jun 2020 21:44:29 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A23242042;
        Thu,  4 Jun 2020 21:44:29 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21BE74203F;
        Thu,  4 Jun 2020 21:44:29 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.48.217])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  4 Jun 2020 21:44:29 +0000 (GMT)
Date:   Thu, 4 Jun 2020 23:44:21 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH] s390/virtio: remove unused pm callbacks
Message-ID: <20200604234421.4ada966b.pasic@linux.ibm.com>
In-Reply-To: <20200526093629.257649-1-cohuck@redhat.com>
References: <20200526093629.257649-1-cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-04_13:2020-06-04,2020-06-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 phishscore=0 suspectscore=0 spamscore=0 cotscore=-2147483648 clxscore=1011
 bulkscore=0 mlxlogscore=999 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006040150
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 26 May 2020 11:36:29 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> Support for hibernation on s390 has been recently been removed with
> commit 394216275c7d ("s390: remove broken hibernate / power management
> support"), no need to keep unused code around.
> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>

Reviewed-by: Halil Pasic <pasic@linux.ibm.com>

> ---
>  drivers/s390/virtio/virtio_ccw.c | 26 --------------------------
>  1 file changed, 26 deletions(-)
> 
> diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> index 957889a42d2e..5730572b52cd 100644
> --- a/drivers/s390/virtio/virtio_ccw.c
> +++ b/drivers/s390/virtio/virtio_ccw.c
> @@ -1372,27 +1372,6 @@ static struct ccw_device_id virtio_ids[] = {
>  	{},
>  };
>  
> -#ifdef CONFIG_PM_SLEEP
> -static int virtio_ccw_freeze(struct ccw_device *cdev)
> -{
> -	struct virtio_ccw_device *vcdev = dev_get_drvdata(&cdev->dev);
> -
> -	return virtio_device_freeze(&vcdev->vdev);
> -}
> -
> -static int virtio_ccw_restore(struct ccw_device *cdev)
> -{
> -	struct virtio_ccw_device *vcdev = dev_get_drvdata(&cdev->dev);
> -	int ret;
> -
> -	ret = virtio_ccw_set_transport_rev(vcdev);
> -	if (ret)
> -		return ret;
> -
> -	return virtio_device_restore(&vcdev->vdev);
> -}
> -#endif
> -
>  static struct ccw_driver virtio_ccw_driver = {
>  	.driver = {
>  		.owner = THIS_MODULE,
> @@ -1405,11 +1384,6 @@ static struct ccw_driver virtio_ccw_driver = {
>  	.set_online = virtio_ccw_online,
>  	.notify = virtio_ccw_cio_notify,
>  	.int_class = IRQIO_VIR,
> -#ifdef CONFIG_PM_SLEEP
> -	.freeze = virtio_ccw_freeze,
> -	.thaw = virtio_ccw_restore,
> -	.restore = virtio_ccw_restore,
> -#endif
>  };
>  
>  static int __init pure_hex(char **cp, unsigned int *val, int min_digit,

