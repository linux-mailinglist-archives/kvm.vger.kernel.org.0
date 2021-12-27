Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4264847FB29
	for <lists+kvm@lfdr.de>; Mon, 27 Dec 2021 09:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbhL0Ixm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Dec 2021 03:53:42 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44736 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233014AbhL0Ixk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Dec 2021 03:53:40 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BR7c7Al031189;
        Mon, 27 Dec 2021 08:53:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=BBMz5NVKQZoTZlCMryuP+HM5bfRARlR4Vc5ME0Y57vM=;
 b=nXF8CgLQgI7+JaJHGKS5X8GYgNxhsU/3BXWWSotHXz6e8bYS3GJt+IWkgjk4cKUIhuOL
 rVmSOXrAA77cH1grgWuArzA0cBv+OUmL0oyqDjdVI8P9lLx2Lfwe3Nt7Ww5iOPMJZ707
 2HcgQ27UUwxc6pBraQ6KdBIG2mVbjp7r+4ojy4KcD9LIdOMGjt09v+YK8eDvYBUVsthy
 FaTjPdXTZ7Tp86zcrP3ricB7OK9CPaIxuBkuNSwJvtxxl9kdOZ+aNTcGZZLAjcK9UJNo
 QpRV69OsqXxXBN6kCJJMKN5E9ElSQhpQMBpigdyTU5aSuSTsP4ZFPtcKLT8UtNn8KZms cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d75tamett-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Dec 2021 08:53:38 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BR8iXSJ016594;
        Mon, 27 Dec 2021 08:53:38 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d75tametc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Dec 2021 08:53:38 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BR8n5gG007532;
        Mon, 27 Dec 2021 08:53:36 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3d5tjj8xq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Dec 2021 08:53:35 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BR8rW2940042964
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Dec 2021 08:53:32 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 097534C04E;
        Mon, 27 Dec 2021 08:53:32 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44FF54C04A;
        Mon, 27 Dec 2021 08:53:31 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.90.67])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Mon, 27 Dec 2021 08:53:31 +0000 (GMT)
Date:   Mon, 27 Dec 2021 09:53:01 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH v17 06/15] s390/vfio-ap: refresh guest's APCB by
 filtering APQNs assigned to mdev
Message-ID: <20211227095301.34a91ca4.pasic@linux.ibm.com>
In-Reply-To: <20211021152332.70455-7-akrowiak@linux.ibm.com>
References: <20211021152332.70455-1-akrowiak@linux.ibm.com>
        <20211021152332.70455-7-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rpwm1l4QYHWeK-z9DTh8Ozb4ECHTZLyG
X-Proofpoint-GUID: vYwBtzo5mbh-tMK_dYLYrX6WfzfWgEiR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-27_02,2021-12-24_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 impostorscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112270042
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 21 Oct 2021 11:23:23 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> Refresh the guest's APCB by filtering the APQNs assigned to the matrix mdev
> that do not reference an AP queue device bound to the vfio_ap device
> driver. The mdev's APQNs will be filtered according to the following rules:
> 
> * The APID of each adapter and the APQI of each domain that is not in the
> host's AP configuration is filtered out.
> 
> * The APID of each adapter comprising an APQN that does not reference a
> queue device bound to the vfio_ap device driver is filtered. The APQNs
> are derived from the Cartesian product of the APID of each adapter and
> APQI of each domain assigned to the mdev.
> 
> The control domains that are not assigned to the host's AP configuration
> will also be filtered before assigning them to the guest's APCB.

The v16 version used to filer on queue removal from vfio_ap, which makes
a ton of sense.

This version will "filter back" the queues once these become bound, but
if a queue is removed form vfio_ap, we don't seem to care to filter. Is
this intentional?

Also we could probably do the filtering incrementally. In a sense that
at a time only so much changes, and we know that the invariant was
preserved without that change. But that would probably end up trading
complexity for cycles. I will trust your judgment and your tests on this
matter.

> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 66 ++++++++++++++++++++++++++++++-
>  1 file changed, 64 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 4305177029bf..46c179363aca 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -314,6 +314,62 @@ static void vfio_ap_matrix_init(struct ap_config_info *info,
>  	matrix->adm_max = info->apxa ? info->Nd : 15;
>  }
>  
> +static void vfio_ap_mdev_filter_cdoms(struct ap_matrix_mdev *matrix_mdev)
> +{
> +	bitmap_and(matrix_mdev->shadow_apcb.adm, matrix_mdev->matrix.adm,
> +		   (unsigned long *)matrix_dev->info.adm, AP_DOMAINS);
> +}
> +
> +/*
> + * vfio_ap_mdev_filter_matrix - copy the mdev's AP configuration to the KVM
> + *				guest's APCB then filter the APIDs that do not
> + *				comprise at least one APQN that references a
> + *				queue device bound to the vfio_ap device driver.
> + *
> + * @matrix_mdev: the mdev whose AP configuration is to be filtered.
> + */
> +static void vfio_ap_mdev_filter_matrix(struct ap_matrix_mdev *matrix_mdev)
> +{
> +	int ret;
> +	unsigned long apid, apqi, apqn;
> +
> +	ret = ap_qci(&matrix_dev->info);
> +	if (ret)
> +		return;
> +
> +	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->shadow_apcb);
> +
> +	/*
> +	 * Copy the adapters, domains and control domains to the shadow_apcb
> +	 * from the matrix mdev, but only those that are assigned to the host's
> +	 * AP configuration.
> +	 */
> +	bitmap_and(matrix_mdev->shadow_apcb.apm, matrix_mdev->matrix.apm,
> +		   (unsigned long *)matrix_dev->info.apm, AP_DEVICES);
> +	bitmap_and(matrix_mdev->shadow_apcb.aqm, matrix_mdev->matrix.aqm,
> +		   (unsigned long *)matrix_dev->info.aqm, AP_DOMAINS);
> +
> +	for_each_set_bit_inv(apid, matrix_mdev->shadow_apcb.apm, AP_DEVICES) {
> +		for_each_set_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm,
> +				     AP_DOMAINS) {
> +			/*
> +			 * If the APQN is not bound to the vfio_ap device
> +			 * driver, then we can't assign it to the guest's
> +			 * AP configuration. The AP architecture won't
> +			 * allow filtering of a single APQN, so if we're
> +			 * filtering APIDs, then filter the APID; otherwise,
> +			 * filter the APQI.
> +			 */
> +			apqn = AP_MKQID(apid, apqi);
> +			if (!vfio_ap_mdev_get_queue(matrix_mdev, apqn)) {
> +				clear_bit_inv(apid,
> +					      matrix_mdev->shadow_apcb.apm);
> +				break;
> +			}
> +		}
> +	}
> +}
> +
>  static int vfio_ap_mdev_probe(struct mdev_device *mdev)
>  {
>  	struct ap_matrix_mdev *matrix_mdev;
> @@ -703,6 +759,7 @@ static ssize_t assign_adapter_store(struct device *dev,
>  		goto share_err;
>  
>  	vfio_ap_mdev_link_adapter(matrix_mdev, apid);
> +	vfio_ap_mdev_filter_matrix(matrix_mdev);
>  	ret = count;
>  	goto done;
>  
> @@ -771,6 +828,7 @@ static ssize_t unassign_adapter_store(struct device *dev,
>  
>  	clear_bit_inv((unsigned long)apid, matrix_mdev->matrix.apm);
>  	vfio_ap_mdev_unlink_adapter(matrix_mdev, apid);
> +	vfio_ap_mdev_filter_matrix(matrix_mdev);
>  	ret = count;
>  done:
>  	mutex_unlock(&matrix_dev->lock);
> @@ -874,6 +932,7 @@ static ssize_t assign_domain_store(struct device *dev,
>  		goto share_err;
>  
>  	vfio_ap_mdev_link_domain(matrix_mdev, apqi);
> +	vfio_ap_mdev_filter_matrix(matrix_mdev);
>  	ret = count;
>  	goto done;
>  
> @@ -942,6 +1001,7 @@ static ssize_t unassign_domain_store(struct device *dev,
>  
>  	clear_bit_inv((unsigned long)apqi, matrix_mdev->matrix.aqm);
>  	vfio_ap_mdev_unlink_domain(matrix_mdev, apqi);
> +	vfio_ap_mdev_filter_matrix(matrix_mdev);
>  	ret = count;
>  
>  done:
> @@ -995,6 +1055,7 @@ static ssize_t assign_control_domain_store(struct device *dev,
>  	 * number of control domains that can be assigned.
>  	 */
>  	set_bit_inv(id, matrix_mdev->matrix.adm);
> +	vfio_ap_mdev_filter_cdoms(matrix_mdev);
>  	ret = count;
>  done:
>  	mutex_unlock(&matrix_dev->lock);
> @@ -1042,6 +1103,7 @@ static ssize_t unassign_control_domain_store(struct device *dev,
>  	}
>  
>  	clear_bit_inv(domid, matrix_mdev->matrix.adm);
> +	clear_bit_inv(domid, matrix_mdev->shadow_apcb.adm);
>  	ret = count;
>  done:
>  	mutex_unlock(&matrix_dev->lock);
> @@ -1179,8 +1241,6 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
>  		kvm_get_kvm(kvm);
>  		matrix_mdev->kvm = kvm;
>  		kvm->arch.crypto.data = matrix_mdev;
> -		memcpy(&matrix_mdev->shadow_apcb, &matrix_mdev->matrix,
> -		       sizeof(struct ap_matrix));
>  		kvm_arch_crypto_set_masks(kvm, matrix_mdev->shadow_apcb.apm,
>  					  matrix_mdev->shadow_apcb.aqm,
>  					  matrix_mdev->shadow_apcb.adm);
> @@ -1536,6 +1596,8 @@ int vfio_ap_mdev_probe_queue(struct ap_device *apdev)
>  	q->apqn = to_ap_queue(&apdev->device)->qid;
>  	q->saved_isc = VFIO_AP_ISC_INVALID;
>  	vfio_ap_queue_link_mdev(q);
> +	if (q->matrix_mdev)
> +		vfio_ap_mdev_filter_matrix(q->matrix_mdev);
>  	dev_set_drvdata(&apdev->device, q);
>  	mutex_unlock(&matrix_dev->lock);
>  

