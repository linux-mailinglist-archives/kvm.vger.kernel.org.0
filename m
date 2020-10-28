Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F054D29D43B
	for <lists+kvm@lfdr.de>; Wed, 28 Oct 2020 22:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbgJ1Vug (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Oct 2020 17:50:36 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49776 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728049AbgJ1Vud (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Oct 2020 17:50:33 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09S81Je7034609;
        Wed, 28 Oct 2020 04:11:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Xjcl4QL6d3IFw54Qeh5O0ngW2PwMHNTczq+fLXfbPrM=;
 b=XKG7ly6tRPOq/Zl7A1Gb6/t6fRybHwfDsSH9+lyHNJ9tmfq73Y3NdeHu1RvbDZ4s0G9H
 gbXNGtgISqJVl1pncZuteh+Q6HwhnpOAShw0AMXOObSFeVc73Hi/Fr8cwJOaXgh+lzCI
 5HUka4GVKozziDWUW8mQ75e86W/US33l2Of4iUw4qbXNOHShFixcKJKUCgZuBzyYat/A
 qShbKidpcHum2xDenMvHX/CAs2oX7RK0TJg9iAEL2Hf42zWHR6pu6SJ2d6dPgfihE52P
 JRo2LGd15yuE1xr2BmkBDt03TITGFDuuapR6hsv59Fn0fdDjT10ufOKUWvrmxU1h6xSK 5Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34ejc2d5tu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Oct 2020 04:11:29 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09S81jsQ037896;
        Wed, 28 Oct 2020 04:11:28 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34ejc2d5rv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Oct 2020 04:11:28 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09S877n3001765;
        Wed, 28 Oct 2020 08:11:26 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 34cbw7v7sj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Oct 2020 08:11:26 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09S8BNQt27918754
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Oct 2020 08:11:24 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D45464C040;
        Wed, 28 Oct 2020 08:11:23 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1FBE54C046;
        Wed, 28 Oct 2020 08:11:23 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.18.81])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Oct 2020 08:11:23 +0000 (GMT)
Date:   Wed, 28 Oct 2020 09:11:21 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v11 06/14] s390/vfio-ap: introduce shadow APCB
Message-ID: <20201028091121.0db418cf.pasic@linux.ibm.com>
In-Reply-To: <20201022171209.19494-7-akrowiak@linux.ibm.com>
References: <20201022171209.19494-1-akrowiak@linux.ibm.com>
        <20201022171209.19494-7-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-28_01:2020-10-26,2020-10-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 malwarescore=0 impostorscore=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 suspectscore=0 bulkscore=0 phishscore=0
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010280049
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 22 Oct 2020 13:12:01 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> The APCB is a field within the CRYCB that provides the AP configuration
> to a KVM guest. Let's introduce a shadow copy of the KVM guest's APCB and
> maintain it for the lifespan of the guest.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c     | 24 +++++++++++++++++++-----
>  drivers/s390/crypto/vfio_ap_private.h |  2 ++
>  2 files changed, 21 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 9e9fad560859..9791761aa7fd 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -320,6 +320,19 @@ static void vfio_ap_matrix_init(struct ap_config_info *info,
>  	matrix->adm_max = info->apxa ? info->Nd : 15;
>  }
>  
> +static bool vfio_ap_mdev_has_crycb(struct ap_matrix_mdev *matrix_mdev)
> +{
> +	return (matrix_mdev->kvm && matrix_mdev->kvm->arch.crypto.crycbd);
> +}
> +
> +static void vfio_ap_mdev_commit_shadow_apcb(struct ap_matrix_mdev *matrix_mdev)
> +{
> +	kvm_arch_crypto_set_masks(matrix_mdev->kvm,
> +				  matrix_mdev->shadow_apcb.apm,
> +				  matrix_mdev->shadow_apcb.aqm,
> +				  matrix_mdev->shadow_apcb.adm);
> +}
> +
>  static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
>  {
>  	struct ap_matrix_mdev *matrix_mdev;
> @@ -335,6 +348,7 @@ static int vfio_ap_mdev_create(struct kobject *kobj, struct mdev_device *mdev)
>  
>  	matrix_mdev->mdev = mdev;
>  	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->matrix);
> +	vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->shadow_apcb);
>  	hash_init(matrix_mdev->qtable);
>  	mdev_set_drvdata(mdev, matrix_mdev);
>  	matrix_mdev->pqap_hook.hook = handle_pqap;
> @@ -1213,13 +1227,12 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>  	if (ret)
>  		return NOTIFY_DONE;
>  
> -	/* If there is no CRYCB pointer, then we can't copy the masks */
> -	if (!matrix_mdev->kvm->arch.crypto.crycbd)
> +	if (!vfio_ap_mdev_has_crycb(matrix_mdev))
>  		return NOTIFY_DONE;
>  
> -	kvm_arch_crypto_set_masks(matrix_mdev->kvm, matrix_mdev->matrix.apm,
> -				  matrix_mdev->matrix.aqm,
> -				  matrix_mdev->matrix.adm);
> +	memcpy(&matrix_mdev->shadow_apcb, &matrix_mdev->matrix,
> +	       sizeof(matrix_mdev->shadow_apcb));
> +	vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
>  
>  	return NOTIFY_OK;
>  }
> @@ -1329,6 +1342,7 @@ static void vfio_ap_mdev_release(struct mdev_device *mdev)
>  		kvm_put_kvm(matrix_mdev->kvm);
>  		matrix_mdev->kvm = NULL;
>  	}
> +

Unrelated change.

Otherwise patch looks OK.

Reviewed-by: Halil Pasic <pasic@linux.ibm.com>

>  	mutex_unlock(&matrix_dev->lock);
>  
>  	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
> index c1d8b5507610..fc8634cee485 100644
> --- a/drivers/s390/crypto/vfio_ap_private.h
> +++ b/drivers/s390/crypto/vfio_ap_private.h
> @@ -75,6 +75,7 @@ struct ap_matrix {
>   * @list:	allows the ap_matrix_mdev struct to be added to a list
>   * @matrix:	the adapters, usage domains and control domains assigned to the
>   *		mediated matrix device.
> + * @shadow_apcb:    the shadow copy of the APCB field of the KVM guest's CRYCB
>   * @group_notifier: notifier block used for specifying callback function for
>   *		    handling the VFIO_GROUP_NOTIFY_SET_KVM event
>   * @kvm:	the struct holding guest's state
> @@ -82,6 +83,7 @@ struct ap_matrix {
>  struct ap_matrix_mdev {
>  	struct list_head node;
>  	struct ap_matrix matrix;
> +	struct ap_matrix shadow_apcb;
>  	struct notifier_block group_notifier;
>  	struct notifier_block iommu_notifier;
>  	struct kvm *kvm;

