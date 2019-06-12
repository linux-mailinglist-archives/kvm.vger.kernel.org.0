Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61E3942823
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 15:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409226AbfFLN4e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 09:56:34 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35976 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2408676AbfFLN4d (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Jun 2019 09:56:33 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5CDh0UX128005
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2019 09:56:31 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2t315mcu7m-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2019 09:56:30 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <freude@linux.ibm.com>;
        Wed, 12 Jun 2019 14:56:27 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 12 Jun 2019 14:56:24 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5CDuMjW41681028
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jun 2019 13:56:22 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C25142041;
        Wed, 12 Jun 2019 13:56:22 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5866342042;
        Wed, 12 Jun 2019 13:56:21 +0000 (GMT)
Received: from [10.0.2.15] (unknown [9.145.62.239])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 12 Jun 2019 13:56:21 +0000 (GMT)
Subject: Re: [PATCH v9 2/4] vfio: ap: register IOMMU VFIO notifier
To:     Pierre Morel <pmorel@linux.ibm.com>, borntraeger@de.ibm.com
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, frankja@linux.ibm.com, akrowiak@linux.ibm.com,
        pasic@linux.ibm.com, david@redhat.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, mimu@linux.ibm.com
References: <1558452877-27822-1-git-send-email-pmorel@linux.ibm.com>
 <1558452877-27822-3-git-send-email-pmorel@linux.ibm.com>
From:   Harald Freudenberger <freude@linux.ibm.com>
Date:   Wed, 12 Jun 2019 15:56:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1558452877-27822-3-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19061213-0028-0000-0000-00000379AB28
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061213-0029-0000-0000-000024399FF9
Message-Id: <a7b45837-4d0b-d2cd-eeec-455db4ba2a2a@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-12_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906120093
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21.05.19 17:34, Pierre Morel wrote:
> To be able to use the VFIO interface to facilitate the
> mediated device memory pinning/unpinning we need to register
> a notifier for IOMMU.
>
> While we will start to pin one guest page for the interrupt indicator
> byte, this is still ok with ballooning as this page will never be
> used by the guest virtio-balloon driver.
> So the pinned page will never be freed. And even a broken guest does
> so, that would not impact the host as the original page is still
> in control by vfio.
>
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c     | 43 ++++++++++++++++++++++++++++++++++-
>  drivers/s390/crypto/vfio_ap_private.h |  2 ++
>  2 files changed, 44 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 900b9cf..e8e87bf 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -759,6 +759,35 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
>  	return 0;
>  }
>  
> +/*
> + * vfio_ap_mdev_iommu_notifier: IOMMU notifier callback
> + *
> + * @nb: The notifier block
> + * @action: Action to be taken
> + * @data: data associated with the request
> + *
> + * For an UNMAP request, unpin the guest IOVA (the NIB guest address we
> + * pinned before). Other requests are ignored.
> + *
> + */
> +static int vfio_ap_mdev_iommu_notifier(struct notifier_block *nb,
> +				       unsigned long action, void *data)
> +{
> +	struct ap_matrix_mdev *matrix_mdev;
> +
> +	matrix_mdev = container_of(nb, struct ap_matrix_mdev, iommu_notifier);
> +
> +	if (action == VFIO_IOMMU_NOTIFY_DMA_UNMAP) {
> +		struct vfio_iommu_type1_dma_unmap *unmap = data;
> +		unsigned long g_pfn = unmap->iova >> PAGE_SHIFT;
> +
> +		vfio_unpin_pages(mdev_dev(matrix_mdev->mdev), &g_pfn, 1);
> +		return NOTIFY_OK;
> +	}
> +
> +	return NOTIFY_DONE;
> +}
> +
>  static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>  				       unsigned long action, void *data)
>  {
> @@ -858,7 +887,17 @@ static int vfio_ap_mdev_open(struct mdev_device *mdev)
>  		return ret;
>  	}
>  
> -	return 0;
> +	matrix_mdev->iommu_notifier.notifier_call = vfio_ap_mdev_iommu_notifier;
> +	events = VFIO_IOMMU_NOTIFY_DMA_UNMAP;
> +	ret = vfio_register_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
> +				     &events, &matrix_mdev->iommu_notifier);
> +	if (!ret)
> +		return ret;
> +
> +	vfio_unregister_notifier(mdev_dev(mdev), VFIO_GROUP_NOTIFY,
> +				 &matrix_mdev->group_notifier);
> +	module_put(THIS_MODULE);
> +	return ret;
>  }
>  
>  static void vfio_ap_mdev_release(struct mdev_device *mdev)
> @@ -869,6 +908,8 @@ static void vfio_ap_mdev_release(struct mdev_device *mdev)
>  		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
>  
>  	vfio_ap_mdev_reset_queues(mdev);
> +	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
> +				 &matrix_mdev->iommu_notifier);
>  	vfio_unregister_notifier(mdev_dev(mdev), VFIO_GROUP_NOTIFY,
>  				 &matrix_mdev->group_notifier);
>  	matrix_mdev->kvm = NULL;
> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
> index a910be1..18dcc4d 100644
> --- a/drivers/s390/crypto/vfio_ap_private.h
> +++ b/drivers/s390/crypto/vfio_ap_private.h
> @@ -81,8 +81,10 @@ struct ap_matrix_mdev {
>  	struct list_head node;
>  	struct ap_matrix matrix;
>  	struct notifier_block group_notifier;
> +	struct notifier_block iommu_notifier;
>  	struct kvm *kvm;
>  	struct kvm_s390_module_hook pqap_hook;
> +	struct mdev_device *mdev;
>  };
>  
>  extern int vfio_ap_mdev_register(void);
acked-by: Harald Freudenberger <freude@linux.ibm.com>

