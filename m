Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88B6849B48A
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 14:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384713AbiAYNBs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 08:01:48 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22240 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1348692AbiAYM7o (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Jan 2022 07:59:44 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20PCg3W9029371;
        Tue, 25 Jan 2022 12:59:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=tl6Cs7TnQDyQv3GmXJtbo2WKbDnaVetS+2E9nqwdUHE=;
 b=AChDC8aXuSLRr21EAvtQfDQkwTOmW2sTfZmvSdYp8eLMZf1Yv6BzVVyoaYuOsN4kT+t3
 p4PSSeATdtaJBgbMIn87Z7wZeJy9ov2gNl+SEU7DbDf7FKt7iGbt3zxUvt27FI/a6Gw0
 hFPDkVRLE66WRAirEM544RJzLUOPKMrm/1Yid0khAJI71SKkwBXuMcOccDpBTAQ8p1fu
 J39uOEmpln27c/uVv3439blwQEVWOb+Z2/Z6bq5ykpWxlIc5VaFziLmscOdY6k5GeSRU
 SU8Y39hFVXggQpPWz1yWyO06UCaAsJ9CatPRxF0kKKhIeJCB0po1rGeW4QzyfUblzDbD jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dthehrap1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 12:59:38 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20PChawG003320;
        Tue, 25 Jan 2022 12:59:38 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dthehranj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 12:59:38 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20PCwL5P021981;
        Tue, 25 Jan 2022 12:59:36 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3dr96je7s7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 12:59:36 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20PCxVQr47055132
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jan 2022 12:59:31 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 61A66AE051;
        Tue, 25 Jan 2022 12:59:31 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B33B8AE045;
        Tue, 25 Jan 2022 12:59:29 +0000 (GMT)
Received: from [9.171.58.95] (unknown [9.171.58.95])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Jan 2022 12:59:29 +0000 (GMT)
Message-ID: <17ccab21-b654-636f-2dfa-57014f4cd4eb@linux.ibm.com>
Date:   Tue, 25 Jan 2022 14:01:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2 25/30] vfio-pci/zdev: wire up zPCI interpretive
 execution support
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
 <20220114203145.242984-26-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220114203145.242984-26-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: gxu6dUrP3EQJXCtEJR2aWICrbrRLS4HG
X-Proofpoint-GUID: -7CtNxsBinYA5Uo-8HgZm70o5LGwD5aL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_02,2022-01-25_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 clxscore=1015 mlxscore=0 phishscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 malwarescore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201250081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/14/22 21:31, Matthew Rosato wrote:
> Introduce support for VFIO_DEVICE_FEATURE_ZPCI_INTERP, which is a new
> VFIO_DEVICE_FEATURE ioctl.  This interface is used to indicate that an
> s390x vfio-pci device wishes to enable/disable zPCI interpretive
> execution, which allows zPCI instructions to be executed directly by
> underlying firmware without KVM involvement.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   arch/s390/include/asm/kvm_pci.h  |  1 +
>   drivers/vfio/pci/vfio_pci_core.c |  2 +
>   drivers/vfio/pci/vfio_pci_zdev.c | 78 ++++++++++++++++++++++++++++++++
>   include/linux/vfio_pci_core.h    | 10 ++++
>   include/uapi/linux/vfio.h        |  7 +++
>   include/uapi/linux/vfio_zdev.h   | 15 ++++++
>   6 files changed, 113 insertions(+)
> 
> diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
> index 97a90b37c87d..dc00c3f27a00 100644
> --- a/arch/s390/include/asm/kvm_pci.h
> +++ b/arch/s390/include/asm/kvm_pci.h
> @@ -35,6 +35,7 @@ struct kvm_zdev {
>   	struct kvm_zdev_ioat ioat;
>   	struct zpci_fib fib;
>   	struct notifier_block nb;
> +	bool interp;

NIT: s/interp/interpretation/ ?

>   };
>   
>   int kvm_s390_pci_dev_open(struct zpci_dev *zdev);
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index fc57d4d0abbe..2b2d64a2190c 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1172,6 +1172,8 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
>   			mutex_unlock(&vdev->vf_token->lock);
>   
>   			return 0;
> +		case VFIO_DEVICE_FEATURE_ZPCI_INTERP:
> +			return vfio_pci_zdev_feat_interp(vdev, feature, arg);
>   		default:
>   			return -ENOTTY;
>   		}
> diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
> index 5c2bddc57b39..4339f48b98bc 100644
> --- a/drivers/vfio/pci/vfio_pci_zdev.c
> +++ b/drivers/vfio/pci/vfio_pci_zdev.c
> @@ -54,6 +54,10 @@ static int zpci_group_cap(struct zpci_dev *zdev, struct vfio_info_cap *caps)
>   		.version = zdev->version
>   	};
>   
> +	/* Some values are different for interpreted devices */
> +	if (zdev->kzdev && zdev->kzdev->interp)
> +		cap.maxstbl = zdev->maxstbl;
> +
>   	return vfio_info_add_capability(caps, &cap.header, sizeof(cap));
>   }
>   
> @@ -138,6 +142,72 @@ int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
>   	return ret;
>   }
>   
> +int vfio_pci_zdev_feat_interp(struct vfio_pci_core_device *vdev,
> +			      struct vfio_device_feature feature,
> +			      unsigned long arg)
> +{
> +	struct zpci_dev *zdev = to_zpci(vdev->pdev);
> +	struct vfio_device_zpci_interp *data;
> +	struct vfio_device_feature *feat;
> +	unsigned long minsz;
> +	int size, rc;
> +
> +	if (!zdev || !zdev->kzdev)
> +		return -EINVAL;
> +
> +	/* If PROBE specified, return probe results immediately */
> +	if (feature.flags & VFIO_DEVICE_FEATURE_PROBE)
> +		return kvm_s390_pci_interp_probe(zdev);
> +
> +	/* GET and SET are mutually exclusive */
> +	if ((feature.flags & VFIO_DEVICE_FEATURE_GET) &&
> +	    (feature.flags & VFIO_DEVICE_FEATURE_SET))
> +		return -EINVAL;

Isn't the check already done in VFIO core?

> +
> +	size = sizeof(*feat) + sizeof(*data);
> +	feat = kzalloc(size, GFP_KERNEL);
> +	if (!feat)
> +		return -ENOMEM;
> +
> +	data = (struct vfio_device_zpci_interp *)&feat->data;
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
> +		if (zdev->gd != 0)
> +			data->flags = VFIO_DEVICE_ZPCI_FLAG_INTERP;
> +		else
> +			data->flags = 0;
> +		data->fh = zdev->fh;
> +		/* userspace is using host fh, give interpreted clp values */
> +		zdev->kzdev->interp = true;
> +
> +		if (copy_to_user((void __user *)arg, feat, size))
> +			rc = -EFAULT;
> +	} else if (feature.flags & VFIO_DEVICE_FEATURE_SET) {
> +		if (data->flags == VFIO_DEVICE_ZPCI_FLAG_INTERP)
> +			rc = kvm_s390_pci_interp_enable(zdev);
> +		else if (data->flags == 0)
> +			rc = kvm_s390_pci_interp_disable(zdev);
> +		else
> +			rc = -EINVAL;
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
> @@ -164,6 +234,7 @@ void vfio_pci_zdev_open(struct vfio_pci_core_device *vdev)
>   		return;
>   
>   	zdev->kzdev->nb.notifier_call = vfio_pci_zdev_group_notifier;
> +	zdev->kzdev->interp = false;
>   
>   	if (vfio_register_notifier(vdev->vdev.dev, VFIO_GROUP_NOTIFY,
>   				   &events, &zdev->kzdev->nb))
> @@ -180,5 +251,12 @@ void vfio_pci_zdev_release(struct vfio_pci_core_device *vdev)
>   	vfio_unregister_notifier(vdev->vdev.dev, VFIO_GROUP_NOTIFY,
>   				 &zdev->kzdev->nb);
>   
> +	/*
> +	 * If the device was using interpretation, don't trust that userspace
> +	 * did the appropriate cleanup
> +	 */
> +	if (zdev->gd != 0)
> +		kvm_s390_pci_interp_disable(zdev);
> +
>   	kvm_s390_pci_dev_release(zdev);
>   }
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index 05287f8ac855..0db2b1051931 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -198,6 +198,9 @@ static inline int vfio_pci_igd_init(struct vfio_pci_core_device *vdev)
>   #ifdef CONFIG_VFIO_PCI_ZDEV
>   extern int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
>   				       struct vfio_info_cap *caps);
> +int vfio_pci_zdev_feat_interp(struct vfio_pci_core_device *vdev,
> +			      struct vfio_device_feature feature,
> +			      unsigned long arg);
>   void vfio_pci_zdev_open(struct vfio_pci_core_device *vdev);
>   void vfio_pci_zdev_release(struct vfio_pci_core_device *vdev);
>   #else
> @@ -207,6 +210,13 @@ static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
>   	return -ENODEV;
>   }
>   
> +static inline int vfio_pci_zdev_feat_interp(struct vfio_pci_core_device *vdev,
> +					    struct vfio_device_feature feature,
> +					    unsigned long arg)
> +{
> +	return -ENOTTY;
> +}
> +
>   static inline void vfio_pci_zdev_open(struct vfio_pci_core_device *vdev)
>   {
>   }
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index ef33ea002b0b..b9a75485b8e7 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -1002,6 +1002,13 @@ struct vfio_device_feature {
>    */
>   #define VFIO_DEVICE_FEATURE_PCI_VF_TOKEN	(0)
>   
> +/*
> + * Provide support for enabling interpretation of zPCI instructions.  This
> + * feature is only valid for s390x PCI devices.  Data provided when setting
> + * and getting this feature is futher described in vfio_zdev.h
> + */
> +#define VFIO_DEVICE_FEATURE_ZPCI_INTERP		(1)
> +
>   /* -------- API for Type1 VFIO IOMMU -------- */
>   
>   /**
> diff --git a/include/uapi/linux/vfio_zdev.h b/include/uapi/linux/vfio_zdev.h
> index b4309397b6b2..575f0410dc66 100644
> --- a/include/uapi/linux/vfio_zdev.h
> +++ b/include/uapi/linux/vfio_zdev.h
> @@ -75,4 +75,19 @@ struct vfio_device_info_cap_zpci_pfip {
>   	__u8 pfip[];
>   };
>   
> +/**
> + * VFIO_DEVICE_FEATURE_ZPCI_INTERP
> + *
> + * This feature is used for enabling zPCI instruction interpretation for a
> + * device.  No data is provided when setting this feature.  When getting
> + * this feature, the following structure is provided which details whether
> + * or not interpretation is active and provides the guest with host device
> + * information necessary to enable interpretation.
> + */
> +struct vfio_device_zpci_interp {
> +	__u64 flags;
> +#define VFIO_DEVICE_ZPCI_FLAG_INTERP 1
> +	__u32 fh;		/* Host device function handle */
> +};
> +
>   #endif
> 

Otherwise LGTM

-- 
Pierre Morel
IBM Lab Boeblingen
