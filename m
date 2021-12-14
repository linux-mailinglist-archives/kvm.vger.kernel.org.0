Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52077473FC9
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 10:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbhLNJru (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 04:47:50 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23356 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230410AbhLNJru (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Dec 2021 04:47:50 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE7LUEw016722;
        Tue, 14 Dec 2021 09:47:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=j07ENdCnQewPV9frNNYVZbE2BA0aNCLd/GsSdbuplKo=;
 b=nUs5QHQpm/pj9u65m+fOiC8Qi8zBDExFVHrVhjueSdgwkF+4YTJBWTNB/nspkNQaAx3+
 LcoZgn18edRAfXGkmjqtdoNDo8Fqzyp1oqFDwN7F16+TL0gP8kVHMdkTGMTwq1bP2M19
 jdqhZs8mpvcYxtJJ7Xp7srmcjo+v56f7cqOq1KjQCrbFIGQAEkDywnJTP+1jPVcqWZW/
 5/mRaAwoo1QtAP1WBLXb6SB1JAeSIdrBxfYltV7pgBzcDM4RtbRJ5mbPpdUf7JerJvcz
 BkuK04JlXnWmYBpqIAKOPizScropukT7TyvhZjpprEe4jR+xAXJxZDz9afDsqS5bp3q9 UQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cx9r9xnj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 09:47:49 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BE9NSE1030080;
        Tue, 14 Dec 2021 09:47:49 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cx9r9xngm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 09:47:49 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BE9iHhn027014;
        Tue, 14 Dec 2021 09:47:46 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3cvkm93sxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 09:47:46 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BE9lga116581012
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 09:47:43 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2A0EA4053;
        Tue, 14 Dec 2021 09:47:42 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D15A1A405F;
        Tue, 14 Dec 2021 09:47:41 +0000 (GMT)
Received: from [9.171.24.181] (unknown [9.171.24.181])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Dec 2021 09:47:41 +0000 (GMT)
Message-ID: <67168a5b-bb93-8caf-32ba-2990623a433b@linux.ibm.com>
Date:   Tue, 14 Dec 2021 10:48:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 28/32] vfio-pci/zdev: wire up zPCI adapter interrupt
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
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
 <20211207205743.150299-29-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20211207205743.150299-29-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Ru_QTYL1THuBW9HdKePpKK57fWPWfQ0l
X-Proofpoint-GUID: N9apbhS_FfiSkKrleRg_u1YhmAqqTLtq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-14_05,2021-12-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112140054
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/7/21 21:57, Matthew Rosato wrote:
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
>   drivers/vfio/pci/vfio_pci_zdev.c | 96 +++++++++++++++++++++++++++++++-
>   include/linux/vfio_pci_core.h    | 10 ++++
>   include/uapi/linux/vfio.h        |  7 +++
>   include/uapi/linux/vfio_zdev.h   | 20 +++++++
>   6 files changed, 136 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
> index 062bac720428..0a0e42e1db1c 100644
> --- a/arch/s390/include/asm/kvm_pci.h
> +++ b/arch/s390/include/asm/kvm_pci.h
> @@ -36,6 +36,8 @@ struct kvm_zdev {
>   	struct zpci_fib fib;
>   	struct notifier_block nb;
>   	bool interp;
> +	bool aif;
> +	bool fhost;
>   };
>   
>   extern int kvm_s390_pci_dev_open(struct zpci_dev *zdev);
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
> index b205e0ad1fd3..dd98808b9139 100644
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
> @@ -206,6 +207,97 @@ int vfio_pci_zdev_feat_interp(struct vfio_pci_core_device *vdev,
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
> +	/*
> +	 * If PROBE requested and feature not found, leave immediately.
> +	 * Otherwise, keep going as GET or SET may also be specified.
> +	 */
> +	if (feature.flags & VFIO_DEVICE_FEATURE_PROBE) {
> +		rc = kvm_s390_pci_aif_probe(zdev);
> +		if (rc)
> +			return rc;
> +	}
> +	if (!(feature.flags & (VFIO_DEVICE_FEATURE_GET +
> +			       VFIO_DEVICE_FEATURE_SET)))
> +		return 0;
> +
> +	size = sizeof(*feat) + sizeof(*data);
> +	feat = kzalloc(size, GFP_KERNEL);
> +	if (!feat)
> +		return -ENOMEM;
> +
> +	data = (struct vfio_device_zpci_aif *)&feat->data;
> +	minsz = offsetofend(struct vfio_device_feature, flags);

I think you should check the argsz.

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
> +	}
> +
> +	kfree(feat);
> +	return rc;
> +}
> +
>   static int vfio_pci_zdev_group_notifier(struct notifier_block *nb,
>   					unsigned long action, void *data)
>   {
> @@ -259,8 +351,10 @@ int vfio_pci_zdev_release(struct vfio_pci_core_device *vdev)
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
>   
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index 92dc43c827c9..5442d3fa1662 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -201,6 +201,9 @@ extern int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
>   int vfio_pci_zdev_feat_interp(struct vfio_pci_core_device *vdev,
>   			      struct vfio_device_feature feature,
>   			      unsigned long arg);
> +int vfio_pci_zdev_feat_aif(struct vfio_pci_core_device *vdev,
> +			   struct vfio_device_feature feature,
> +			   unsigned long arg);
>   int vfio_pci_zdev_open(struct vfio_pci_core_device *vdev);
>   int vfio_pci_zdev_release(struct vfio_pci_core_device *vdev);
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
>   static inline int vfio_pci_zdev_open(struct vfio_pci_core_device *vdev)
>   {
>   	return -ENODEV;
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
