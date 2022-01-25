Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032E349B417
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 13:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383704AbiAYMjA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 07:39:00 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59086 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242157AbiAYMej (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Jan 2022 07:34:39 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20PCK4fr008468;
        Tue, 25 Jan 2022 12:34:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=kPqyOqh/2fPvvz/05ORH+kFYe3IGEYAxdvUTR0bl6VI=;
 b=aPhKsb9pszczTRPgM3eTb4y/WurhVVEf9oJMKHad11ynpnA58jc7WXpmB7a8HhfR4Crl
 6RPwepUkLQkDF2QFOHyGdD0MFHHd96FJOia4h9OWJ9dW2qirbeBCIKZxeZ+LCNRPbsD6
 wYtrawSRPVige9PUmrKCEHL++QkZpG78pPRbW0SBW5e9NukLHXt8dBMvXrIhhFbAudUT
 YdkykdVmsD9iTZsBcIjJalD/8/1bzh8jjpySEoQxGSVrGYsz36OUnTId+gks7squy32t
 cq6whmni2HRqRH8QPQ4KyKdHtIw4R2wwWJHHhxMmhkOAonBnrvKb/TJkIlMHeZg3GFrh fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dtfret7j6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 12:34:38 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20PCYcok025012;
        Tue, 25 Jan 2022 12:34:38 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dtfret7hd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 12:34:38 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20PCW7Jk004982;
        Tue, 25 Jan 2022 12:34:36 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 3dr9j8vmw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 12:34:35 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20PCYUuK47776068
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jan 2022 12:34:30 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36DF8AE053;
        Tue, 25 Jan 2022 12:34:30 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35BBBAE045;
        Tue, 25 Jan 2022 12:34:29 +0000 (GMT)
Received: from [9.171.58.95] (unknown [9.171.58.95])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Jan 2022 12:34:29 +0000 (GMT)
Message-ID: <75c74f80-0a74-40dc-6797-473522ef2803@linux.ibm.com>
Date:   Tue, 25 Jan 2022 13:36:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2 26/30] vfio-pci/zdev: wire up zPCI adapter interrupt
 forwarding support
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
 <20220114203145.242984-27-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220114203145.242984-27-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zlNA1nzyeo-i4ZhTJDkqEfsSiE-6it_S
X-Proofpoint-GUID: GWj7vNrL6JH3c9QLDOuKOzH1Yx0UaIiz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_02,2022-01-25_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201250081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/14/22 21:31, Matthew Rosato wrote:
> Introduce support for VFIO_DEVICE_FEATURE_ZPCI_AIF, which is a new
> VFIO_DEVICE_FEATURE ioctl.  This interface is used to indicate that an
> s390x vfio-pci device wishes to enable/disable zPCI adapter interrupt
> forwarding, which allows underlying firmware to deliver interrupts
> directly to the associated kvm guest.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   arch/s390/include/asm/kvm_pci.h  |  2 +
>   drivers/vfio/pci/vfio_pci_core.c |  2 +
>   drivers/vfio/pci/vfio_pci_zdev.c | 98 +++++++++++++++++++++++++++++++-
>   include/linux/vfio_pci_core.h    | 10 ++++
>   include/uapi/linux/vfio.h        |  7 +++
>   include/uapi/linux/vfio_zdev.h   | 20 +++++++
>   6 files changed, 138 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
> index dc00c3f27a00..dbab349a4a75 100644
> --- a/arch/s390/include/asm/kvm_pci.h
> +++ b/arch/s390/include/asm/kvm_pci.h
> @@ -36,6 +36,8 @@ struct kvm_zdev {
>   	struct zpci_fib fib;
>   	struct notifier_block nb;
>   	bool interp;
> +	bool aif;
> +	bool fhost;

Can we please have a comment on these booleans?
Can we have explicit naming to be able to follow their usage more easily?
May be aif_float and aif_host to match with the VFIO feature?

>   };
>   
>   int kvm_s390_pci_dev_open(struct zpci_dev *zdev);
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 2b2d64a2190c..01658de660bd 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1174,6 +1174,8 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
>   			return 0;
>   		case VFIO_DEVICE_FEATURE_ZPCI_INTERP:
>   			return vfio_pci_zdev_feat_interp(vdev, feature, arg);
> +		case VFIO_DEVICE_FEATURE_ZPCI_AIF:
> +			return vfio_pci_zdev_feat_aif(vdev, feature, arg);
>   		default:
>   			return -ENOTTY;
>   		}
> diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
> index 4339f48b98bc..891cfa016d63 100644
> --- a/drivers/vfio/pci/vfio_pci_zdev.c
> +++ b/drivers/vfio/pci/vfio_pci_zdev.c
> @@ -13,6 +13,7 @@
>   #include <linux/vfio_zdev.h>
>   #include <asm/pci_clp.h>
>   #include <asm/pci_io.h>
> +#include <asm/pci_insn.h>
>   #include <asm/kvm_pci.h>
>   
>   #include <linux/vfio_pci_core.h>
> @@ -208,6 +209,99 @@ int vfio_pci_zdev_feat_interp(struct vfio_pci_core_device *vdev,
>   	return rc;
>   }
>   
> +int vfio_pci_zdev_feat_aif(struct vfio_pci_core_device *vdev,
> +			   struct vfio_device_feature feature,
> +			   unsigned long arg)
> +{
> +	struct zpci_dev *zdev = to_zpci(vdev->pdev);
> +	struct vfio_device_zpci_aif *data;
> +	struct vfio_device_feature *feat;
> +	unsigned long minsz;
> +	int size, rc = 0;
> +
> +	if (!zdev || !zdev->kzdev)
> +		return -EINVAL;
> +
> +	/* If PROBE specified, return probe results immediately */
> +	if (feature.flags & VFIO_DEVICE_FEATURE_PROBE)
> +		return kvm_s390_pci_aif_probe(zdev);
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
> +	data = (struct vfio_device_zpci_aif *)&feat->data;
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
> +		if (zdev->kzdev->aif)
> +			data->flags = VFIO_DEVICE_ZPCI_FLAG_AIF_FLOAT;
> +		if (zdev->kzdev->fhost)
> +			data->flags |= VFIO_DEVICE_ZPCI_FLAG_AIF_HOST;
> +
> +		if (copy_to_user((void __user *)arg, feat, size))
> +			rc = -EFAULT;
> +	} else if (feature.flags & VFIO_DEVICE_FEATURE_SET) {
> +		if (data->flags & VFIO_DEVICE_ZPCI_FLAG_AIF_FLOAT) {
> +			/* create a guest fib */
> +			struct zpci_fib fib;
> +
> +			fib.fmt0.aibv = data->ibv;
> +			fib.fmt0.isc = data->isc;
> +			fib.fmt0.noi = data->noi;
> +			if (data->sb != 0) {
> +				fib.fmt0.aisb = data->sb;
> +				fib.fmt0.aisbo = data->sbo;
> +				fib.fmt0.sum = 1;
> +			} else {
> +				fib.fmt0.aisb = 0;
> +				fib.fmt0.aisbo = 0;
> +				fib.fmt0.sum = 0;
> +			}
> +			if (data->flags & VFIO_DEVICE_ZPCI_FLAG_AIF_HOST) {
> +				rc = kvm_s390_pci_aif_enable(zdev, &fib, false);
> +				if (!rc) {
> +					zdev->kzdev->aif = true;
> +					zdev->kzdev->fhost = true;
> +				}
> +			} else {
> +				rc = kvm_s390_pci_aif_enable(zdev, &fib, true);
> +				if (!rc)
> +					zdev->kzdev->aif = true;
> +			}
> +		} else if (data->flags == 0) {
> +			rc = kvm_s390_pci_aif_disable(zdev);
> +			if (!rc) {
> +				zdev->kzdev->aif = false;
> +				zdev->kzdev->fhost = false;
> +			}
> +		} else {
> +			rc = -EINVAL;
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
> @@ -255,8 +349,10 @@ void vfio_pci_zdev_release(struct vfio_pci_core_device *vdev)
>   	 * If the device was using interpretation, don't trust that userspace
>   	 * did the appropriate cleanup
>   	 */
> -	if (zdev->gd != 0)
> +	if (zdev->gd != 0) {
> +		kvm_s390_pci_aif_disable(zdev);
>   		kvm_s390_pci_interp_disable(zdev);
> +	}
>   
>   	kvm_s390_pci_dev_release(zdev);
>   }
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index 0db2b1051931..7ec5e82e7933 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -201,6 +201,9 @@ extern int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
>   int vfio_pci_zdev_feat_interp(struct vfio_pci_core_device *vdev,
>   			      struct vfio_device_feature feature,
>   			      unsigned long arg);
> +int vfio_pci_zdev_feat_aif(struct vfio_pci_core_device *vdev,
> +			   struct vfio_device_feature feature,
> +			   unsigned long arg);
>   void vfio_pci_zdev_open(struct vfio_pci_core_device *vdev);
>   void vfio_pci_zdev_release(struct vfio_pci_core_device *vdev);
>   #else
> @@ -217,6 +220,13 @@ static inline int vfio_pci_zdev_feat_interp(struct vfio_pci_core_device *vdev,
>   	return -ENOTTY;
>   }
>   
> +static inline int vfio_pci_zdev_feat_aif(struct vfio_pci_core_device *vdev,
> +					 struct vfio_device_feature feature,
> +					 unsigned long arg)
> +{
> +	return -ENOTTY;
> +}
> +
>   static inline void vfio_pci_zdev_open(struct vfio_pci_core_device *vdev)
>   {
>   }
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index b9a75485b8e7..fe3bfd99bf50 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -1009,6 +1009,13 @@ struct vfio_device_feature {
>    */
>   #define VFIO_DEVICE_FEATURE_ZPCI_INTERP		(1)
>   
> +/*
> + * Provide support for enbaling adapter interruption forwarding for zPCI
> + * devices.  This feature is only valid for s390x PCI devices.  Data provided
> + * when setting and getting this feature is further described in vfio_zdev.h
> + */
> +#define VFIO_DEVICE_FEATURE_ZPCI_AIF		(2)
> +
>   /* -------- API for Type1 VFIO IOMMU -------- */
>   
>   /**
> diff --git a/include/uapi/linux/vfio_zdev.h b/include/uapi/linux/vfio_zdev.h
> index 575f0410dc66..c574e23f9385 100644
> --- a/include/uapi/linux/vfio_zdev.h
> +++ b/include/uapi/linux/vfio_zdev.h
> @@ -90,4 +90,24 @@ struct vfio_device_zpci_interp {
>   	__u32 fh;		/* Host device function handle */
>   };
>   
> +/**
> + * VFIO_DEVICE_FEATURE_ZPCI_AIF
> + *
> + * This feature is used for enabling forwarding of adapter interrupts directly
> + * from firmware to the guest.  When setting this feature, the flags indicate
> + * whether to enable/disable the feature and the structure defined below is
> + * used to setup the forwarding structures.  When getting this feature, only
> + * the flags are used to indicate the current state.
> + */
> +struct vfio_device_zpci_aif {
> +	__u64 flags;
> +#define VFIO_DEVICE_ZPCI_FLAG_AIF_FLOAT 1
> +#define VFIO_DEVICE_ZPCI_FLAG_AIF_HOST 2

I think we need more information on these flags.
What does AIF_FLOAT and what does AIF_HOST ?

> +	__u64 ibv;		/* Address of guest interrupt bit vector */
> +	__u64 sb;		/* Address of guest summary bit */
> +	__u32 noi;		/* Number of interrupts */
> +	__u8 isc;		/* Guest interrupt subclass */
> +	__u8 sbo;		/* Offset of guest summary bit vector */
> +};
> +
>   #endif
> 

-- 
Pierre Morel
IBM Lab Boeblingen
