Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A68C473FBE
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 10:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbhLNJpW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 04:45:22 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17950 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229744AbhLNJpV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Dec 2021 04:45:21 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE7HPLa007433;
        Tue, 14 Dec 2021 09:45:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=BMEHBz4PDAsOphQeP/CmIWFCJg6QXaZymYB2PlIQVKM=;
 b=JDTUylcPl5tMGdYvpg3D4o3JKOCtUwfpjG9eocP+qiafmBETysbB8ESU76xpCdJ1SL/1
 JRhDTKFKsK+xzVZt/4ab9HmILxbJ6kHEja76IiZAykdYTcR40btOTgVyjh8ntakMMMHE
 miRm6RcOSK+j8AmOUDhy16l4u6jk+/pYqWcQ6gx0sE98pRe88xb74HEMHDf34uE4bN1R
 81ttIci0UxBWo6AUSyJC/DkHcV9nTjeQb2dvOZpmmYlAcDHzvoxVneAaCe949yPIpMHx
 U1WaLa+BH0v8XefGg8tyjxgI3MLMVyxifF35AUmQjfTQ5GDqXyg4eKnyj8ZTNmdrRsgp Tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cx9r9ep5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 09:45:20 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BE9fHfG009695;
        Tue, 14 Dec 2021 09:45:19 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cx9r9ep4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 09:45:19 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BE9gCj9007469;
        Tue, 14 Dec 2021 09:45:17 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3cvk8hvwvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 09:45:16 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BE9jDX347645094
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 09:45:13 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D27DFA404D;
        Tue, 14 Dec 2021 09:45:13 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE404A405B;
        Tue, 14 Dec 2021 09:45:12 +0000 (GMT)
Received: from [9.171.24.181] (unknown [9.171.24.181])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Dec 2021 09:45:12 +0000 (GMT)
Message-ID: <c23778c4-902e-4fe1-46e0-53a896111dc4@linux.ibm.com>
Date:   Tue, 14 Dec 2021 10:46:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 29/32] vfio-pci/zdev: wire up zPCI IOAT assist support
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
 <20211207205743.150299-30-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20211207205743.150299-30-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qtmNt_Bx9ds4uqLnaXti-sCVdFRiIlbD
X-Proofpoint-GUID: ByOnMSFFWWl7f342aQmuzUOrdBfJVOcd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-14_05,2021-12-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 adultscore=0 priorityscore=1501 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112140054
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/7/21 21:57, Matthew Rosato wrote:
> Introduce support for VFIO_DEVICE_FEATURE_ZPCI_IOAT, which is a new
> VFIO_DEVICE_FEATURE ioctl.  This interface is used to indicate that an
> s390x vfio-pci device wishes to enable/disable zPCI I/O Address
> Translation assistance, allowing the host to perform address translation
> and shadowing.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   arch/s390/include/asm/kvm_pci.h  |  1 +
>   drivers/vfio/pci/vfio_pci_core.c |  2 ++
>   drivers/vfio/pci/vfio_pci_zdev.c | 61 ++++++++++++++++++++++++++++++++
>   include/linux/vfio_pci_core.h    | 10 ++++++
>   include/uapi/linux/vfio.h        |  8 +++++
>   include/uapi/linux/vfio_zdev.h   | 13 +++++++
>   6 files changed, 95 insertions(+)
> 
> diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
> index 0a0e42e1db1c..0b362d55c7b2 100644
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
> index dd98808b9139..85be77492a6d 100644
> --- a/drivers/vfio/pci/vfio_pci_zdev.c
> +++ b/drivers/vfio/pci/vfio_pci_zdev.c
> @@ -298,6 +298,66 @@ int vfio_pci_zdev_feat_aif(struct vfio_pci_core_device *vdev,
>   	return rc;
>   }
>   
> +int vfio_pci_zdev_feat_ioat(struct vfio_pci_core_device *vdev,
> +			    struct vfio_device_feature feature,
> +			    unsigned long arg)
> +{
> +	struct zpci_dev *zdev = to_zpci(vdev->pdev);
> +	struct vfio_device_zpci_ioat *data;
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
> +		rc = kvm_s390_pci_ioat_probe(zdev);
> +		if (rc)
> +			return rc;
> +	}
> +	if (!(feature.flags & (VFIO_DEVICE_FEATURE_GET +
> +			       VFIO_DEVICE_FEATURE_SET)))
> +		return 0;
> +

I think you should verify the argsz.

> +	size = sizeof(*feat) + sizeof(*data);
> +	feat = kzalloc(size, GFP_KERNEL);
> +	if (!feat)
> +		return -ENOMEM;
> +
> +	data = (struct vfio_device_zpci_ioat *)&feat->data;
> +	minsz = offsetofend(struct vfio_device_feature, flags);
> +
> +	/* Get the rest of the payload for GET/SET */
> +	rc = copy_from_user(data, (void __user *)(arg + minsz),
> +			sizeof(*data));

Alignment

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
> +	}
> +
> +	kfree(feat);
> +	return rc;
> +}
> +
>   static int vfio_pci_zdev_group_notifier(struct notifier_block *nb,
>   					unsigned long action, void *data)
>   {
> @@ -353,6 +413,7 @@ int vfio_pci_zdev_release(struct vfio_pci_core_device *vdev)
>   	 */
>   	if (zdev->gd != 0) {
>   		kvm_s390_pci_aif_disable(zdev);
> +		kvm_s390_pci_ioat_disable(zdev);
>   		kvm_s390_pci_interp_disable(zdev);
>   	}
>   
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index 5442d3fa1662..7c45a425e7f8 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -204,6 +204,9 @@ int vfio_pci_zdev_feat_interp(struct vfio_pci_core_device *vdev,
>   int vfio_pci_zdev_feat_aif(struct vfio_pci_core_device *vdev,
>   			   struct vfio_device_feature feature,
>   			   unsigned long arg);
> +int vfio_pci_zdev_feat_ioat(struct vfio_pci_core_device *vdev,
> +			    struct vfio_device_feature feature,
> +			    unsigned long arg);
>   int vfio_pci_zdev_open(struct vfio_pci_core_device *vdev);
>   int vfio_pci_zdev_release(struct vfio_pci_core_device *vdev);
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
>   static inline int vfio_pci_zdev_open(struct vfio_pci_core_device *vdev)
>   {
>   	return -ENODEV;
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
