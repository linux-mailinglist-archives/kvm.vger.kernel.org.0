Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88734493B95
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 15:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354963AbiASOBd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 09:01:33 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26132 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1354957AbiASOBc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Jan 2022 09:01:32 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20JD7MrT039159;
        Wed, 19 Jan 2022 14:01:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=KRvDz8ILq6kwF1fT8Sf1fcfbB/oh0mJaAkqSLPBewBc=;
 b=oYy5LJpXWBEJ0nB7Bp3WXhi6rzZMvKgJwCc0fVtYL1ZxqT7mNr3B6q0bH9nyQf0U3TpZ
 9EpR7vOTCOx3WEz1YRayz+wKJd6dI9K+/Pj/kVgoxNXsCbG2wzXSrybro35XbJWFV4+a
 EolgGUmXjZNNq05PhvBAXWdm0VejQkN4gk5Zn39U+E8H/ioE5e8Lg7VLOvhiQRAsoONN
 PU6Rx3DO34iEFAaCaK9G8ZnnB63NGOZ+DdX2tpOiqVnGGybovnyqtgxg+673PJteFMHl
 oNym0SaPGp5ZjpRwj7YHiTP8rZzjbTlt6TP0hGRK+OR+ZdnBwkN2SnE9YEGBPNWoiBi5 Vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dpgwycf1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 14:01:32 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20JDCwoD013846;
        Wed, 19 Jan 2022 14:01:32 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dpgwycf06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 14:01:31 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20JDvkkG010319;
        Wed, 19 Jan 2022 14:01:29 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3dknhjpj2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 14:01:29 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20JE1QGX41681320
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 14:01:26 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A4B0A4069;
        Wed, 19 Jan 2022 14:01:26 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68E63A4059;
        Wed, 19 Jan 2022 14:01:25 +0000 (GMT)
Received: from [9.171.7.240] (unknown [9.171.7.240])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 Jan 2022 14:01:25 +0000 (GMT)
Message-ID: <ec0780dc-469a-1406-a4ba-04ea22d29aa8@linux.ibm.com>
Date:   Wed, 19 Jan 2022 15:03:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2 27/30] vfio-pci/zdev: wire up zPCI IOAT assist support
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
 <20220114203145.242984-28-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220114203145.242984-28-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vRzkrYsfCzY4Qfzvcxwg6opueJXjvGnF
X-Proofpoint-ORIG-GUID: Sy1eCmFsgRwSd6rxzN0yHwnNDSDE4CIj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-19_08,2022-01-19_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0 adultscore=0
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2201190082
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/14/22 21:31, Matthew Rosato wrote:
> Introduce support for VFIO_DEVICE_FEATURE_ZPCI_IOAT, which is a new
> VFIO_DEVICE_FEATURE ioctl.  This interface is used to indicate that an
> s390x vfio-pci device wishes to enable/disable zPCI I/O Address
> Translation assistance, allowing the host to perform address translation
> and shadowing.
> 

Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>


> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   arch/s390/include/asm/kvm_pci.h  |  1 +
>   drivers/vfio/pci/vfio_pci_core.c |  2 +
>   drivers/vfio/pci/vfio_pci_zdev.c | 63 ++++++++++++++++++++++++++++++++
>   include/linux/vfio_pci_core.h    | 10 +++++
>   include/uapi/linux/vfio.h        |  8 ++++
>   include/uapi/linux/vfio_zdev.h   | 13 +++++++
>   6 files changed, 97 insertions(+)
> 
> diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
> index dbab349a4a75..7b6b6d771026 100644
> --- a/arch/s390/include/asm/kvm_pci.h
> +++ b/arch/s390/include/asm/kvm_pci.h
> @@ -32,6 +32,7 @@ struct kvm_zdev {
>   	struct zpci_dev *zdev;
>   	struct kvm *kvm;
>   	u64 rpcit_count;
> +	u64 iota;
>   	struct kvm_zdev_ioat ioat;
>   	struct zpci_fib fib;
>   	struct notifier_block nb;
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 01658de660bd..709d9ba22a60 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1176,6 +1176,8 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
>   			return vfio_pci_zdev_feat_interp(vdev, feature, arg);
>   		case VFIO_DEVICE_FEATURE_ZPCI_AIF:
>   			return vfio_pci_zdev_feat_aif(vdev, feature, arg);
> +		case VFIO_DEVICE_FEATURE_ZPCI_IOAT:
> +			return vfio_pci_zdev_feat_ioat(vdev, feature, arg);
>   		default:
>   			return -ENOTTY;
>   		}
> diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
> index 891cfa016d63..2b169d688937 100644
> --- a/drivers/vfio/pci/vfio_pci_zdev.c
> +++ b/drivers/vfio/pci/vfio_pci_zdev.c
> @@ -302,6 +302,68 @@ int vfio_pci_zdev_feat_aif(struct vfio_pci_core_device *vdev,
>   	return rc;
>   }
>   
> +int vfio_pci_zdev_feat_ioat(struct vfio_pci_core_device *vdev,
> +			    struct vfio_device_feature feature,
> +			    unsigned long arg)
> +{
> +	struct zpci_dev *zdev = to_zpci(vdev->pdev);
> +	struct vfio_device_zpci_ioat *data;

NIT: something more explicit than "data" like "ioat_feature" ?

> +	struct vfio_device_feature *feat;
> +	unsigned long minsz;
> +	int size, rc = 0;
> +
> +	if (!zdev || !zdev->kzdev)
> +		return -EINVAL;
> +
> +	/* If PROBE specified, return probe results immediately */
> +	if (feature.flags & VFIO_DEVICE_FEATURE_PROBE)
> +		return kvm_s390_pci_ioat_probe(zdev);
> +
> +	/* GET and SET are mutually exclusive */
> +	if ((feature.flags & VFIO_DEVICE_FEATURE_GET) &&
> +	    (feature.flags & VFIO_DEVICE_FEATURE_SET))
> +		return -EINVAL;
> +
> +	size = sizeof(*feat) + sizeof(*data);
> +	feat = kzalloc(size, GFP_KERNEL);
> +	if (!feat)
> +		return -ENOMEM;
> +
> +	data = (struct vfio_device_zpci_ioat *)&feat->data;
> +	minsz = offsetofend(struct vfio_device_feature, flags);
> +
> +	if (feature.argsz < minsz + sizeof(*data))
> +		return -EINVAL;
> +
> +	/* Get the rest of the payload for GET/SET */
> +	rc = copy_from_user(data, (void __user *)(arg + minsz),
> +			    sizeof(*data));
> +	if (rc)
> +		rc = -EINVAL;
> +
> +	if (feature.flags & VFIO_DEVICE_FEATURE_GET) {
> +		data->iota = (u64)zdev->kzdev->iota;
> +		if (copy_to_user((void __user *)arg, feat, size))
> +			rc = -EFAULT;
> +	} else if (feature.flags & VFIO_DEVICE_FEATURE_SET) {
> +		if (data->iota != 0) {
> +			rc = kvm_s390_pci_ioat_enable(zdev, data->iota);
> +			if (!rc)
> +				zdev->kzdev->iota = data->iota;
> +		} else if (zdev->kzdev->iota != 0) {
> +			rc = kvm_s390_pci_ioat_disable(zdev);
> +			if (!rc)
> +				zdev->kzdev->iota = 0;
> +		}
> +	} else {
> +		/* Neither GET nor SET were specified */
> +		rc = -EINVAL;
> +	}
> +
> +	kfree(feat);
> +	return rc;
> +}
> +
>   static int vfio_pci_zdev_group_notifier(struct notifier_block *nb,
>   					unsigned long action, void *data)
>   {
> @@ -351,6 +413,7 @@ void vfio_pci_zdev_release(struct vfio_pci_core_device *vdev)
>   	 */
>   	if (zdev->gd != 0) {
>   		kvm_s390_pci_aif_disable(zdev);
> +		kvm_s390_pci_ioat_disable(zdev);
>   		kvm_s390_pci_interp_disable(zdev);
>   	}
>   
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index 7ec5e82e7933..f17d761ae14e 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -204,6 +204,9 @@ int vfio_pci_zdev_feat_interp(struct vfio_pci_core_device *vdev,
>   int vfio_pci_zdev_feat_aif(struct vfio_pci_core_device *vdev,
>   			   struct vfio_device_feature feature,
>   			   unsigned long arg);
> +int vfio_pci_zdev_feat_ioat(struct vfio_pci_core_device *vdev,
> +			    struct vfio_device_feature feature,
> +			    unsigned long arg);
>   void vfio_pci_zdev_open(struct vfio_pci_core_device *vdev);
>   void vfio_pci_zdev_release(struct vfio_pci_core_device *vdev);
>   #else
> @@ -227,6 +230,13 @@ static inline int vfio_pci_zdev_feat_aif(struct vfio_pci_core_device *vdev,
>   	return -ENOTTY;
>   }
>   
> +static inline int vfio_pci_zdev_feat_ioat(struct vfio_pci_core_device *vdev,
> +					  struct vfio_device_feature feature,
> +					  unsigned long arg)
> +{
> +	return -ENOTTY;
> +}
> +
>   static inline void vfio_pci_zdev_open(struct vfio_pci_core_device *vdev)
>   {
>   }
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index fe3bfd99bf50..32c687388f48 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -1016,6 +1016,14 @@ struct vfio_device_feature {
>    */
>   #define VFIO_DEVICE_FEATURE_ZPCI_AIF		(2)
>   
> +/*
> + * Provide support for enabling guest I/O address translation assistance for
> + * zPCI devices.  This feature is only valid for s390x PCI devices.  Data
> + * provided when setting and getting this feature is further described in
> + * vfio_zdev.h
> + */
> +#define VFIO_DEVICE_FEATURE_ZPCI_IOAT		(3)
> +
>   /* -------- API for Type1 VFIO IOMMU -------- */
>   
>   /**
> diff --git a/include/uapi/linux/vfio_zdev.h b/include/uapi/linux/vfio_zdev.h
> index c574e23f9385..1a5229b7bb18 100644
> --- a/include/uapi/linux/vfio_zdev.h
> +++ b/include/uapi/linux/vfio_zdev.h
> @@ -110,4 +110,17 @@ struct vfio_device_zpci_aif {
>   	__u8 sbo;		/* Offset of guest summary bit vector */
>   };
>   
> +/**
> + * VFIO_DEVICE_FEATURE_ZPCI_IOAT
> + *
> + * This feature is used for enabling guest I/O translation assistance for
> + * passthrough zPCI devices using instruction interpretation.  When setting
> + * this feature, the iota specifies a KVM guest I/O translation anchor.  When
> + * getting this feature, the most recently set anchor (or 0) is returned in
> + * iota.
> + */
> +struct vfio_device_zpci_ioat {
> +	__u64 iota;
> +};
> +
>   #endif
> 

-- 
Pierre Morel
IBM Lab Boeblingen
