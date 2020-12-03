Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 570B12CDCD7
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 18:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731158AbgLCR4I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 12:56:08 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55834 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726689AbgLCR4I (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Dec 2020 12:56:08 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B3HgVBB130409;
        Thu, 3 Dec 2020 12:55:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=vnnDq3LW8NH7z3EXaRPTTKXXk2eAYKFIH7G5x9+b+n8=;
 b=qqQfzH3di/nngU2D7SwAJ6cmTu2fKJYDOCzTesOU9A80datEsjIm6HaRvmpfUPM9kuZw
 iOUGphZae+EGf7jH1LDyHZ5WZ9Q67ZgfYAsl/FPwAk5wmmyndCtsvVyE7xdB1TaxhTie
 nVpfMap992yStNx9MLanwnNyZnosS9GoHdX+Uwf1a+C8tH12Bux78x6pfh1LnJNblQHK
 BMflDSgx5Ct8dwBIHRSs1phrzt4BQfNjV8Z9KGsWywvwGI6pmaudQaJauPx4zhxXk0bt
 4zZbPIljHstd6KLpVfiPkXDoppjOhjHSxQfEwmD4bmiqOY78RrI602lZYh88dLvo5Ij2 PA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 355jjjymec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Dec 2020 12:55:26 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B3HXHZt099635;
        Thu, 3 Dec 2020 12:55:25 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 355jjjymc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Dec 2020 12:55:25 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B3HqewP010067;
        Thu, 3 Dec 2020 17:55:19 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 353dthav3t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Dec 2020 17:55:19 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B3HtGDx9765572
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Dec 2020 17:55:17 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D017B5205A;
        Thu,  3 Dec 2020 17:55:16 +0000 (GMT)
Received: from oc2783563651 (unknown [9.171.64.213])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id 52B8E5204F;
        Thu,  3 Dec 2020 17:55:16 +0000 (GMT)
Date:   Thu, 3 Dec 2020 18:55:14 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, borntraeger@de.ibm.com, cohuck@redhat.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com, david@redhat.com
Subject: Re: [PATCH] s390/vfio-ap: Clean up vfio_ap resources when KVM
 pointer invalidated
Message-ID: <20201203185514.54060568.pasic@linux.ibm.com>
In-Reply-To: <20201202234101.32169-1-akrowiak@linux.ibm.com>
References: <20201202234101.32169-1-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-03_10:2020-12-03,2020-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 impostorscore=0
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030104
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  2 Dec 2020 18:41:01 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> The vfio_ap device driver registers a group notifier with VFIO when the
> file descriptor for a VFIO mediated device for a KVM guest is opened to
> receive notification that the KVM pointer is set (VFIO_GROUP_NOTIFY_SET_KVM
> event). When the KVM pointer is set, the vfio_ap driver stashes the pointer
> and calls the kvm_get_kvm() function to increment its reference counter.
> When the notifier is called to make notification that the KVM pointer has
> been set to NULL, the driver should clean up any resources associated with
> the KVM pointer and decrement its reference counter. The current
> implementation does not take care of this clean up.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>

Do we need a Fixes tag? Do we need this backported? In my opinion
this is necessary since the interrupt patches.

> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index e0bde8518745..eeb9c9130756 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1083,6 +1083,17 @@ static int vfio_ap_mdev_iommu_notifier(struct notifier_block *nb,
>  	return NOTIFY_DONE;
>  }
>  
> +static void vfio_ap_mdev_put_kvm(struct ap_matrix_mdev *matrix_mdev)

I don't like the name. The function does more that put_kvm. Maybe
something  like _disconnect_kvm()?

> +{
> +	if (matrix_mdev->kvm) {
> +		(matrix_mdev->kvm);
> +		matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;

Is a plain assignment to arch.crypto.pqap_hook apropriate, or do we need
to take more care?

For instance kvm_arch_crypto_set_masks() takes kvm->lock before poking
kvm->arch.crypto.crycb.

> +		vfio_ap_mdev_reset_queues(matrix_mdev->mdev);
> +		kvm_put_kvm(matrix_mdev->kvm);
> +		matrix_mdev->kvm = NULL;
> +	}
> +}
> +
>  static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>  				       unsigned long action, void *data)
>  {
> @@ -1095,7 +1106,7 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>  	matrix_mdev = container_of(nb, struct ap_matrix_mdev, group_notifier);
>  
>  	if (!data) {
> -		matrix_mdev->kvm = NULL;
> +		vfio_ap_mdev_put_kvm(matrix_mdev);

The lock question was already raised.

What are the exact circumstances under which this branch can be taken?

>  		return NOTIFY_OK;
>  	}
>  
> @@ -1222,13 +1233,7 @@ static void vfio_ap_mdev_release(struct mdev_device *mdev)
>  	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>  
>  	mutex_lock(&matrix_dev->lock);
> -	if (matrix_mdev->kvm) {
> -		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
> -		matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
> -		vfio_ap_mdev_reset_queues(mdev);
> -		kvm_put_kvm(matrix_mdev->kvm);
> -		matrix_mdev->kvm = NULL;
> -	}
> +	vfio_ap_mdev_put_kvm(matrix_mdev);
>  	mutex_unlock(&matrix_dev->lock);
>  
>  	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,

