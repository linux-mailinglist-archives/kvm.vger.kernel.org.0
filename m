Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80DFF492C6D
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 18:33:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347216AbiARRdJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 12:33:09 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61490 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1347149AbiARRdI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 12:33:08 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20IH3H40005968;
        Tue, 18 Jan 2022 17:33:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=39328zvZ2uGEJHdkCDp9nnhra7xAap49UzWa7tf+/1Q=;
 b=hcMvmnzMjg+yCnR/5C77G3roJcU2+8mt/vmsijGrn+eiHUx0Id3rKy9uPj3XVs9El7Zw
 MF3KW/Wl/k1AwCrcy0UgSkoayWiK9yR6a8L9s1+EYlQ2S6lnzJVjmPFljX8ZRku6xzA1
 Q3hnqfpteQNnNXGkEwyWVUHRe1lIerJKrciig1op7Gbt9S6BgsWC4DRtIhVJ9+rG7XKu
 SF2PgBmMveSROK4ThBPe3d7G36aJsa+y9Z+GaiIQTdM+/27eY4GgVvIxV3FVq4OR3PrO
 YMbrtP4z4WFmQa3LEdJM2Yeu4PQqzL+x8Hw76GvJrU72vxQaNveRhoCGMQkRi7cPzIJP 4Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dnvpmt1mq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 17:33:07 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20IH0vht006339;
        Tue, 18 Jan 2022 17:33:06 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dnvpmt1m7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 17:33:06 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20IHWAHK005358;
        Tue, 18 Jan 2022 17:33:05 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3dknw9dcr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 17:33:04 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20IHX0pR37028348
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 17:33:00 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09A53AE04D;
        Tue, 18 Jan 2022 17:33:00 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0081BAE045;
        Tue, 18 Jan 2022 17:32:59 +0000 (GMT)
Received: from [9.171.70.230] (unknown [9.171.70.230])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 17:32:58 +0000 (GMT)
Message-ID: <0af94334-27ac-7e05-86ea-465857e9dadd@linux.ibm.com>
Date:   Tue, 18 Jan 2022 18:34:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2 24/30] vfio-pci/zdev: wire up group notifier
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
 <20220114203145.242984-25-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220114203145.242984-25-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: utkXg9xHv9wsjsiOQ8IMQKkAbL3jZUpn
X-Proofpoint-GUID: MmR8zVuAnW-usI_EFMDF5_PEPy2C9a0G
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_05,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 clxscore=1015 priorityscore=1501
 phishscore=0 bulkscore=0 mlxlogscore=999 impostorscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180105
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/14/22 21:31, Matthew Rosato wrote:
> KVM zPCI passthrough device logic will need a reference to the associated
> kvm guest that has access to the device.  Let's register a group notifier
> for VFIO_GROUP_NOTIFY_SET_KVM to catch this information in order to create
> an association between a kvm guest and the host zdev.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   arch/s390/include/asm/kvm_pci.h  |  2 ++
>   drivers/vfio/pci/vfio_pci_core.c |  2 ++
>   drivers/vfio/pci/vfio_pci_zdev.c | 46 ++++++++++++++++++++++++++++++++
>   include/linux/vfio_pci_core.h    | 10 +++++++
>   4 files changed, 60 insertions(+)
> 
> diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
> index fa90729a35cf..97a90b37c87d 100644
> --- a/arch/s390/include/asm/kvm_pci.h
> +++ b/arch/s390/include/asm/kvm_pci.h
> @@ -17,6 +17,7 @@
>   #include <linux/kvm.h>
>   #include <linux/pci.h>
>   #include <linux/mutex.h>
> +#include <linux/notifier.h>
>   #include <asm/pci_insn.h>
>   #include <asm/pci_dma.h>
>   
> @@ -33,6 +34,7 @@ struct kvm_zdev {
>   	u64 rpcit_count;
>   	struct kvm_zdev_ioat ioat;
>   	struct zpci_fib fib;
> +	struct notifier_block nb;
>   };
>   
>   int kvm_s390_pci_dev_open(struct zpci_dev *zdev);
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index f948e6cd2993..fc57d4d0abbe 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -452,6 +452,7 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
>   
>   	vfio_pci_vf_token_user_add(vdev, -1);
>   	vfio_spapr_pci_eeh_release(vdev->pdev);
> +	vfio_pci_zdev_release(vdev);
>   	vfio_pci_core_disable(vdev);
>   
>   	mutex_lock(&vdev->igate);
> @@ -470,6 +471,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_close_device);
>   void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev)
>   {
>   	vfio_pci_probe_mmaps(vdev);
> +	vfio_pci_zdev_open(vdev);
>   	vfio_spapr_pci_eeh_open(vdev->pdev);
>   	vfio_pci_vf_token_user_add(vdev, 1);
>   }
> diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
> index ea4c0d2b0663..5c2bddc57b39 100644
> --- a/drivers/vfio/pci/vfio_pci_zdev.c
> +++ b/drivers/vfio/pci/vfio_pci_zdev.c
> @@ -13,6 +13,7 @@
>   #include <linux/vfio_zdev.h>
>   #include <asm/pci_clp.h>
>   #include <asm/pci_io.h>
> +#include <asm/kvm_pci.h>
>   
>   #include <linux/vfio_pci_core.h>
>   
> @@ -136,3 +137,48 @@ int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
>   
>   	return ret;
>   }
> +
> +static int vfio_pci_zdev_group_notifier(struct notifier_block *nb,
> +					unsigned long action, void *data)
> +{
> +	struct kvm_zdev *kzdev = container_of(nb, struct kvm_zdev, nb);
> +
> +	if (action == VFIO_GROUP_NOTIFY_SET_KVM) {
> +		if (!data || !kzdev->zdev)
> +			return NOTIFY_DONE;
> +		kvm_s390_pci_attach_kvm(kzdev->zdev, data);

Why not just set kzdev->kvm = data ?

alternatively, define kvm_s390_pci_attach_kvm() as an inline instead of 
a global function.

otherwise LGTM

> +	}
> +
> +	return NOTIFY_OK;
> +}
> +
> +void vfio_pci_zdev_open(struct vfio_pci_core_device *vdev)
> +{
> +	unsigned long events = VFIO_GROUP_NOTIFY_SET_KVM;
> +	struct zpci_dev *zdev = to_zpci(vdev->pdev);
> +
> +	if (!zdev)
> +		return;
> +
> +	if (kvm_s390_pci_dev_open(zdev))
> +		return;
> +
> +	zdev->kzdev->nb.notifier_call = vfio_pci_zdev_group_notifier;
> +
> +	if (vfio_register_notifier(vdev->vdev.dev, VFIO_GROUP_NOTIFY,
> +				   &events, &zdev->kzdev->nb))
> +		kvm_s390_pci_dev_release(zdev);
> +}
> +
> +void vfio_pci_zdev_release(struct vfio_pci_core_device *vdev)
> +{
> +	struct zpci_dev *zdev = to_zpci(vdev->pdev);
> +
> +	if (!zdev || !zdev->kzdev)
> +		return;
> +
> +	vfio_unregister_notifier(vdev->vdev.dev, VFIO_GROUP_NOTIFY,
> +				 &zdev->kzdev->nb);
> +
> +	kvm_s390_pci_dev_release(zdev);
> +}
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index 5e2bca3b89db..05287f8ac855 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -198,12 +198,22 @@ static inline int vfio_pci_igd_init(struct vfio_pci_core_device *vdev)
>   #ifdef CONFIG_VFIO_PCI_ZDEV
>   extern int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
>   				       struct vfio_info_cap *caps);
> +void vfio_pci_zdev_open(struct vfio_pci_core_device *vdev);
> +void vfio_pci_zdev_release(struct vfio_pci_core_device *vdev);
>   #else
>   static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
>   					      struct vfio_info_cap *caps)
>   {
>   	return -ENODEV;
>   }
> +
> +static inline void vfio_pci_zdev_open(struct vfio_pci_core_device *vdev)
> +{
> +}
> +
> +static inline void vfio_pci_zdev_release(struct vfio_pci_core_device *vdev)
> +{
> +}
>   #endif
>   
>   /* Will be exported for vfio pci drivers usage */
> 

-- 
Pierre Morel
IBM Lab Boeblingen
