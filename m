Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 564A12F391B
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 19:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729128AbhALSo5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 13:44:57 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11896 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726438AbhALSo4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 13:44:56 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10CIWKN6104076;
        Tue, 12 Jan 2021 13:44:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=yy9kfdiIyrOdhHu20ahazxEqKo9oPc1BA8FCG05MhIQ=;
 b=aBNyxMoQRxGmUJHEa+5/kHBU0XkwFxc5x3wPNGTDGnxV8qE6RkFFoodRfXRQEbpHU0X6
 5elK2Xj2qRqaCuIgd3TQvIam6NLX+yR+jAk52qnMULBh/OViMEKuKOJv2D09mJFzBmKQ
 gworortEc/dOuDOlzYdAoH49jXFSReaMludBLA57CAnSaHyimZhLv/cM88ib0/All08C
 2fSxEHQ0LmNnYg5/uDXYejcJ2XzGgBkCpJWTeHTr16eKglEBFp73FHTZvZkmjx6KfhPI
 C0DrQqTGatKRK+GY2KpjZF8Jl66vvNDxpYyHOFJuhECgYah3YmN2XBcTN+8tk2UDPh64 ZA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361gkqscqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 13:44:11 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10CIWqZM108940;
        Tue, 12 Jan 2021 13:44:11 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361gkqscq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 13:44:10 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10CIajD1003038;
        Tue, 12 Jan 2021 18:44:09 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 35y3rha2qe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 18:44:09 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10CIi10324117506
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 18:44:01 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3554CAE051;
        Tue, 12 Jan 2021 18:44:06 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E71CAE045;
        Tue, 12 Jan 2021 18:44:04 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.60.135])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Tue, 12 Jan 2021 18:44:04 +0000 (GMT)
Date:   Tue, 12 Jan 2021 19:44:00 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v13 14/15] s390/vfio-ap: handle AP bus scan completed
 notification
Message-ID: <20210112194400.095707c1.pasic@linux.ibm.com>
In-Reply-To: <20201223011606.5265-15-akrowiak@linux.ibm.com>
References: <20201223011606.5265-1-akrowiak@linux.ibm.com>
        <20201223011606.5265-15-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_12:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101120106
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 22 Dec 2020 20:16:05 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> Implements the driver callback invoked by the AP bus when the AP bus
> scan has completed. Since this callback is invoked after binding the newly
> added devices to their respective device drivers, the vfio_ap driver will
> attempt to hot plug the adapters, domains and control domains into each
> guest using the matrix mdev to which they are assigned. Keep in mind that
> an adapter or domain can be plugged in only if:
> * Each APQN derived from the newly added APID of the adapter and the APQIs
>   already assigned to the guest's APCB references an AP queue device bound
>   to the vfio_ap driver
> * Each APQN derived from the newly added APQI of the domain and the APIDs
>   already assigned to the guest's APCB references an AP queue device bound
>   to the vfio_ap driver

As stated in my comment to your previous patch, I don't see the promised
mechanism for delaying hotplug (from probe). Without that we can't
consolidate, and the handling of on_scan_complete() is useless, because
the hotplugs are already done.

Regards,
Halil

> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_drv.c     |  1 +
>  drivers/s390/crypto/vfio_ap_ops.c     | 21 +++++++++++++++++++++
>  drivers/s390/crypto/vfio_ap_private.h |  2 ++
>  3 files changed, 24 insertions(+)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
> index 2029d8392416..075495fc44c0 100644
> --- a/drivers/s390/crypto/vfio_ap_drv.c
> +++ b/drivers/s390/crypto/vfio_ap_drv.c
> @@ -149,6 +149,7 @@ static int __init vfio_ap_init(void)
>  	vfio_ap_drv.remove = vfio_ap_mdev_remove_queue;
>  	vfio_ap_drv.in_use = vfio_ap_mdev_resource_in_use;
>  	vfio_ap_drv.on_config_changed = vfio_ap_on_cfg_changed;
> +	vfio_ap_drv.on_scan_complete = vfio_ap_on_scan_complete;
>  	vfio_ap_drv.ids = ap_queue_ids;
>  
>  	ret = ap_driver_register(&vfio_ap_drv, THIS_MODULE, VFIO_AP_DRV_NAME);
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 8bbbd1dc7546..b8ed01297812 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1592,3 +1592,24 @@ void vfio_ap_on_cfg_changed(struct ap_config_info *new_config_info,
>  	vfio_ap_mdev_on_cfg_add();
>  	mutex_unlock(&matrix_dev->lock);
>  }
> +
> +void vfio_ap_on_scan_complete(struct ap_config_info *new_config_info,
> +			      struct ap_config_info *old_config_info)
> +{
> +	struct ap_matrix_mdev *matrix_mdev;
> +
> +	mutex_lock(&matrix_dev->lock);
> +	list_for_each_entry(matrix_mdev, &matrix_dev->mdev_list, node) {
> +		if (bitmap_intersects(matrix_mdev->matrix.apm,
> +				      matrix_dev->ap_add, AP_DEVICES) ||
> +		    bitmap_intersects(matrix_mdev->matrix.aqm,
> +				      matrix_dev->aq_add, AP_DOMAINS) ||
> +		    bitmap_intersects(matrix_mdev->matrix.adm,
> +				      matrix_dev->ad_add, AP_DOMAINS))
> +			vfio_ap_mdev_refresh_apcb(matrix_mdev);
> +	}
> +
> +	bitmap_clear(matrix_dev->ap_add, 0, AP_DEVICES);
> +	bitmap_clear(matrix_dev->aq_add, 0, AP_DOMAINS);
> +	mutex_unlock(&matrix_dev->lock);
> +}
> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
> index b99b68968447..7f0f7c92e686 100644
> --- a/drivers/s390/crypto/vfio_ap_private.h
> +++ b/drivers/s390/crypto/vfio_ap_private.h
> @@ -117,5 +117,7 @@ int vfio_ap_mdev_resource_in_use(unsigned long *apm, unsigned long *aqm);
>  
>  void vfio_ap_on_cfg_changed(struct ap_config_info *new_config_info,
>  			    struct ap_config_info *old_config_info);
> +void vfio_ap_on_scan_complete(struct ap_config_info *new_config_info,
> +			      struct ap_config_info *old_config_info);
>  
>  #endif /* _VFIO_AP_PRIVATE_H_ */

