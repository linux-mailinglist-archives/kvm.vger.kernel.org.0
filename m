Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1DBC29E2F4
	for <lists+kvm@lfdr.de>; Thu, 29 Oct 2020 03:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbgJ1Vdp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Oct 2020 17:33:45 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9868 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726220AbgJ1Vdn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Oct 2020 17:33:43 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09SF1hXV121541;
        Wed, 28 Oct 2020 11:03:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=qCy8VkwqyRNJffBI5KoK7JXyLGP0Hef+xRP8C6iyofQ=;
 b=elCbb15cO4x7L0JtC7602ZuV0IOh/v27yQwD9GtwiiPUgpkYG3yp0WoVFDO5DjIlOGj+
 6cS5biyXQttT1u8CStsUezD7mO1nBfJ3D04p4/PxUvK8PrMrhnh2BdxoSLBtpXFWibcM
 ROcHoD8fQGWmWgkvLAefzyo7snAKaIvliu54vMOVYacbk4GunlBOliTfemj+rICOCNsp
 fVeS5CJIofaNvv440zGQyqmXmnfyBRMkrssuS/SvCS8cyd2+f5sG6jHFb62rufJglv+K
 nwWItBjvPXWC8pSiILI1JGJ6o98+pSLTLOnWKcGyQuwEq8yxgskz6xSl5hitfYtx6qWA tA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34ey1xdwqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Oct 2020 11:03:39 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09SF2Dhu125140;
        Wed, 28 Oct 2020 11:03:38 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34ey1xdwpd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Oct 2020 11:03:38 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09SEqgGa026590;
        Wed, 28 Oct 2020 15:03:36 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 34cbw8acae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Oct 2020 15:03:35 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09SF3Xks20251132
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Oct 2020 15:03:33 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D56AC52052;
        Wed, 28 Oct 2020 15:03:32 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.18.81])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 260995204F;
        Wed, 28 Oct 2020 15:03:32 +0000 (GMT)
Date:   Wed, 28 Oct 2020 16:03:30 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v11 09/14] s390/vfio-ap: allow assignment of unavailable
 AP queues to mdev device
Message-ID: <20201028160330.55df0068.pasic@linux.ibm.com>
In-Reply-To: <20201022171209.19494-10-akrowiak@linux.ibm.com>
References: <20201022171209.19494-1-akrowiak@linux.ibm.com>
        <20201022171209.19494-10-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-28_06:2020-10-28,2020-10-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 spamscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0
 priorityscore=1501 adultscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010280100
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 22 Oct 2020 13:12:04 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> +static int vfio_ap_mdev_validate_masks(struct ap_matrix_mdev *matrix_mdev,
> +				       unsigned long *mdev_apm,
> +				       unsigned long *mdev_aqm)
> +{
> +	if (ap_apqn_in_matrix_owned_by_def_drv(mdev_apm, mdev_aqm))
> +		return -EADDRNOTAVAIL;
> +
> +	return vfio_ap_mdev_verify_no_sharing(matrix_mdev, mdev_apm, mdev_aqm);
> +}
> +
>  static bool vfio_ap_mdev_matrixes_equal(struct ap_matrix *matrix1,
>  					struct ap_matrix *matrix2)
>  {
> @@ -840,33 +734,21 @@ static ssize_t assign_adapter_store(struct device *dev,
>  	if (apid > matrix_mdev->matrix.apm_max)
>  		return -ENODEV;
>  
> -	/*
> -	 * Set the bit in the AP mask (APM) corresponding to the AP adapter
> -	 * number (APID). The bits in the mask, from most significant to least
> -	 * significant bit, correspond to APIDs 0-255.
> -	 */
> -	mutex_lock(&matrix_dev->lock);
> -
> -	ret = vfio_ap_mdev_verify_queues_reserved_for_apid(matrix_mdev, apid);
> -	if (ret)
> -		goto done;
> -
>  	memset(apm, 0, sizeof(apm));
>  	set_bit_inv(apid, apm);
>  
> -	ret = vfio_ap_mdev_verify_no_sharing(matrix_mdev, apm,
> -					     matrix_mdev->matrix.aqm);
> -	if (ret)
> -		goto done;
> -
> +	mutex_lock(&matrix_dev->lock);
> +	ret = vfio_ap_mdev_validate_masks(matrix_mdev, apm,
> +					  matrix_mdev->matrix.aqm);

Is this a potential deadlock?

Consider following scenario 
1) apmask_store() takes ap_perms_mutex
2) assign_adapter_store() takes matrix_dev->lock
3) apmask_store() calls vfio_ap_mdev_resource_in_use() which tries
   to take matrix_dev->lock
4) assign_adapter_store() calls ap_apqn_in_matrix_owned_by_def_drv
   which tries to take ap_perms_mutex

BANG!

I think using mutex_trylock(&matrix_dev->lock) and bailing out with busy
if we don't manage to acquire the lock would be a good idea anyway, to
prevent a bunch of mdev management operations piling up on the mutex
and starving in_use().

Regards,
Halil

 
> +	if (ret) {
> +		mutex_unlock(&matrix_dev->lock);
> +		return ret;
> +	}
>  	set_bit_inv(apid, matrix_mdev->matrix.apm);
>  	vfio_ap_mdev_link_queues(matrix_mdev, LINK_APID, apid);
> -	ret = count;
> -
> -done:
>  	mutex_unlock(&matrix_dev->lock);
>  
> -	return ret;
> +	return count;
