Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15C302795FF
	for <lists+kvm@lfdr.de>; Sat, 26 Sep 2020 03:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729823AbgIZBjA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 21:39:00 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39390 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729495AbgIZBi7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 21:38:59 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08Q1Vr7H067259;
        Fri, 25 Sep 2020 21:38:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=uV8Vh3fc7vEJHjDeoJjuIKClvllNULVP7xW2RQva/70=;
 b=GgZlbcNCi47xbKsITeg5WDx/z5yfIXIrgcgQrtYu7dsNvK1L4QM+H20dx+WaCZhnrl7N
 OVunNK6CAnAgLaZfS06N6LfhJi77IWAZD/eJ3mq/0HV7gWxvzah3moYIaw/N7qmdvcOY
 omjI/enCGTQ9kXvajgpSmYV6C7lqSltHKBRdcsC200n8982IxpCEwY/j5lmO41MNh2CR
 G75asWLaFCFWemVF+aiqlUeUGVUHmkeWKoa8Gt29LVBq5Y+0kQZq9Ik6NgiBdHtz2sjd
 ltcfTKTgLtiQIpEgcKBD2NoilJfhHoISV34E/xAu5IcV6ZazP/FMnWFqzqWeOFYe+Igh 7Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33stw69br2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Sep 2020 21:38:57 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08Q1Vt8L067320;
        Fri, 25 Sep 2020 21:38:56 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33stw69bqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Sep 2020 21:38:56 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08Q1c2ik012554;
        Sat, 26 Sep 2020 01:38:54 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 33n9m7uhx3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 26 Sep 2020 01:38:54 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08Q1cphi30671314
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Sep 2020 01:38:51 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CACF911C04C;
        Sat, 26 Sep 2020 01:38:51 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17AD811C04A;
        Sat, 26 Sep 2020 01:38:51 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.172.136])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 26 Sep 2020 01:38:51 +0000 (GMT)
Date:   Sat, 26 Sep 2020 03:38:08 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v10 06/16] s390/vfio-ap: introduce shadow APCB
Message-ID: <20200926033808.07e9d04f.pasic@linux.ibm.com>
In-Reply-To: <20200821195616.13554-7-akrowiak@linux.ibm.com>
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
 <20200821195616.13554-7-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-25_19:2020-09-24,2020-09-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 adultscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009260004
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 Aug 2020 15:56:06 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> The APCB is a field within the CRYCB that provides the AP configuration
> to a KVM guest. Let's introduce a shadow copy of the KVM guest's APCB and
> maintain it for the lifespan of the guest.
> 

AFAIU this is supposed to be a no change in behavior patch that lays the
groundwork.

> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c     | 32 ++++++++++++++++++++++-----
>  drivers/s390/crypto/vfio_ap_private.h |  2 ++
>  2 files changed, 29 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index fc1aa6f947eb..efb229033f9e 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -305,14 +305,35 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> +static void vfio_ap_matrix_clear_masks(struct ap_matrix *matrix)
> +{
> +	bitmap_clear(matrix->apm, 0, AP_DEVICES);
> +	bitmap_clear(matrix->aqm, 0, AP_DOMAINS);
> +	bitmap_clear(matrix->adm, 0, AP_DOMAINS);
> +}
> +
>  static void vfio_ap_matrix_init(struct ap_config_info *info,
>  				struct ap_matrix *matrix)
>  {
> +	vfio_ap_matrix_clear_masks(matrix);

I don't quite understand the idea behind this. The only place
vfio_ap_matrix_init() is used, is in create right after the whole
matrix_mdev got allocated with kzalloc.

>  	matrix->apm_max = info->apxa ? info->Na : 63;
>  	matrix->aqm_max = info->apxa ? info->Nd : 15;
>  	matrix->adm_max = info->apxa ? info->Nd : 15;
>  }
>  
> +static bool vfio_ap_mdev_has_crycb(struct ap_matrix_mdev *matrix_mdev)
> +{
> +	return (matrix_mdev->kvm && matrix_mdev->kvm->arch.crypto.crycbd);
> +}
> +
> +static void vfio_ap_mdev_commit_crycb(struct ap_matrix_mdev *matrix_mdev)
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
> @@ -1202,13 +1223,12 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
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

A note on the thread safety of the access to matrix_mdev->matrix. I
guess the idea is, that this is still safe because we did
vfio_ap_mdev_set_kvm() and that is supposed to inhibit changes the
matrix.

There are two things that bother me with this:
1) the assign operations don't check matrix_mdev->kvm under the lock
2) with dynamic, this is supposed to change (So I have to be careful
about it when reviewing the following patches. A sneak-peek at the end
result makes me worried).

> +	vfio_ap_mdev_commit_crycb(matrix_mdev);
>  
>  	return NOTIFY_OK;
>  }
> @@ -1323,6 +1343,8 @@ static void vfio_ap_mdev_release(struct mdev_device *mdev)
>  		kvm_put_kvm(matrix_mdev->kvm);
>  		matrix_mdev->kvm = NULL;
>  	}
> +
> +	vfio_ap_matrix_clear_masks(&matrix_mdev->shadow_apcb);

What is the idea behind this? From the above, it looks like we are going
to overwrite matrix_mdev->shadow_apcb with matrix_mdev->matrix before
the next commit anyway.

I suppose this is probably about no guest unolies no resources passed
through at the moment. If that is the case maybe we can document it
below. 

>  	mutex_unlock(&matrix_dev->lock);
>  
>  	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
> index 0c796ef11426..055bce6d45db 100644
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

