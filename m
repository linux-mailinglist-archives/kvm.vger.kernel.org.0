Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32791473F15
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 10:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbhLNJPT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 04:15:19 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50064 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230171AbhLNJPS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Dec 2021 04:15:18 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE7S205017422;
        Tue, 14 Dec 2021 09:15:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=oDC4IRSFKY0txGQB8AWc4BivnGXbuXXnrHV/xH8ISs4=;
 b=F7NB0a+iZWTI79K2kxmEYa79n6pbxPP0WUd5HIIgwpXh2RCUDRaxbLUIlIx/gtSjK7cs
 Tls3g00GXMLHe11XjYFG3b9nw9iai4terN5gbXOzjk9Ti2/3UB4mNvPozeEEgYeiisth
 BIeXKqAXP9KutLigN3gWLIMawBCnnTN5AeXRyV91KGkweWsBgYdeHVg8SoS+7NftbOCm
 rS3HP3GuqeO8sBcT3Ip6Cep9oYOyOlABXMRqBy+ftZr4Eu+sIcAlZtbveyZMEX+FtgpJ
 5tBw93UV1Vltvox4uK1U4b/i1cCWvWcdrhv+u+5+kEXHDqAdKip1TGRcGSsrWNnWeLUz 6w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cx9r95t48-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 09:15:17 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BE8xYTM018363;
        Tue, 14 Dec 2021 09:15:16 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cx9r95t3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 09:15:16 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BE9EMhn017374;
        Tue, 14 Dec 2021 09:15:14 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3cvkm9bg2e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Dec 2021 09:15:14 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BE9FBlY34734562
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 09:15:11 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C74EA405E;
        Tue, 14 Dec 2021 09:15:11 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52AC1A405B;
        Tue, 14 Dec 2021 09:15:10 +0000 (GMT)
Received: from [9.171.24.181] (unknown [9.171.24.181])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Dec 2021 09:15:10 +0000 (GMT)
Message-ID: <e0aa5f47-2fd3-e4bd-2383-e2672d206712@linux.ibm.com>
Date:   Tue, 14 Dec 2021 10:16:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 20/32] KVM: s390: pci: provide routines for
 enabling/disabling interpretation
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
 <20211207205743.150299-21-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20211207205743.150299-21-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 66MQM-L294xiPSaygs6i2S-EY-gE8vOY
X-Proofpoint-ORIG-GUID: Oxu3BzblluDjAdMlsuzctxvHDrBu96D6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-14_05,2021-12-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 impostorscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 adultscore=0 clxscore=1015 mlxscore=0 phishscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112140052
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/7/21 21:57, Matthew Rosato wrote:
> These routines will be wired into the vfio_pci_zdev ioctl handlers to
> respond to requests to enable / disable a device for zPCI Load/Store
> interpretation.
> 
> The first time such a request is received, enable the necessary facilities
> for the guest.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   arch/s390/include/asm/kvm_pci.h |  4 ++
>   arch/s390/kvm/pci.c             | 91 +++++++++++++++++++++++++++++++++
>   arch/s390/pci/pci.c             |  3 ++
>   3 files changed, 98 insertions(+)
> 
> diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
> index 3e491a39704c..5d6283acb54c 100644
> --- a/arch/s390/include/asm/kvm_pci.h
> +++ b/arch/s390/include/asm/kvm_pci.h
> @@ -26,4 +26,8 @@ extern int kvm_s390_pci_dev_open(struct zpci_dev *zdev);
>   extern void kvm_s390_pci_dev_release(struct zpci_dev *zdev);
>   extern int kvm_s390_pci_attach_kvm(struct zpci_dev *zdev, struct kvm *kvm);
>   
> +extern int kvm_s390_pci_interp_probe(struct zpci_dev *zdev);
> +extern int kvm_s390_pci_interp_enable(struct zpci_dev *zdev);
> +extern int kvm_s390_pci_interp_disable(struct zpci_dev *zdev);

extern prototypes should be avoided in .h files


> +
>   #endif /* ASM_KVM_PCI_H */
> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
> index f0e5386ff943..57cbe3827ea6 100644
> --- a/arch/s390/kvm/pci.c
> +++ b/arch/s390/kvm/pci.c
> @@ -10,7 +10,9 @@
>   #include <linux/kvm_host.h>
>   #include <linux/pci.h>
>   #include <asm/kvm_pci.h>
> +#include <asm/sclp.h>
>   #include "pci.h"
> +#include "kvm-s390.h"
>   
>   static struct zpci_aift aift;
>   
> @@ -118,6 +120,95 @@ int kvm_s390_pci_aen_init(u8 nisc)
>   	return rc;
>   }
>   
> +int kvm_s390_pci_interp_probe(struct zpci_dev *zdev)
> +{
> +	if (!(sclp.has_zpci_interp && test_facility(69)))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(kvm_s390_pci_interp_probe);
> +
> +int kvm_s390_pci_interp_enable(struct zpci_dev *zdev)
> +{
> +	u32 gd;
> +	int rc;
> +
> +	/*
> +	 * If this is the first request to use an interpreted device, make the
> +	 * necessary vcpu changes
> +	 */
> +	if (!zdev->kzdev->kvm->arch.use_zpci_interp)
> +		kvm_s390_vcpu_pci_enable_interp(zdev->kzdev->kvm);
> +
> +	/*
> +	 * In the event of a system reset in userspace, the GISA designation
> +	 * may still be assigned because the device is still enabled.
> +	 * Verify it's the same guest before proceeding.
> +	 */
> +	gd = (u32)(u64)&zdev->kzdev->kvm->arch.sie_page2->gisa;
> +	if (zdev->gd != 0 && zdev->gd != gd)
> +		return -EPERM;
> +
> +	if (zdev_enabled(zdev)) {
> +		zdev->gd = 0;
> +		rc = zpci_disable_device(zdev);
> +		if (rc)
> +			return rc;
> +	}
> +
> +	/*
> +	 * Store information about the identity of the kvm guest allowed to
> +	 * access this device via interpretation to be used by host CLP
> +	 */
> +	zdev->gd = gd;
> +
> +	rc = zpci_enable_device(zdev);
> +	if (rc)
> +		goto err;
> +
> +	/* Re-register the IOMMU that was already created */
> +	rc = zpci_register_ioat(zdev, 0, zdev->start_dma, zdev->end_dma,
> +				(u64)zdev->dma_table);
> +	if (rc)
> +		goto err;
> +
> +	return rc;
> +
> +err:
> +	zdev->gd = 0;
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(kvm_s390_pci_interp_enable);
> +
> +int kvm_s390_pci_interp_disable(struct zpci_dev *zdev)
> +{
> +	int rc;
> +
> +	if (zdev->gd == 0)
> +		return -EINVAL;
> +
> +	/* Remove the host CLP guest designation */
> +	zdev->gd = 0;
> +
> +	if (zdev_enabled(zdev)) {
> +		rc = zpci_disable_device(zdev);
> +		if (rc)
> +			return rc;
> +	}
> +
> +	rc = zpci_enable_device(zdev);
> +	if (rc)
> +		return rc;
> +
> +	/* Re-register the IOMMU that was already created */
> +	rc = zpci_register_ioat(zdev, 0, zdev->start_dma, zdev->end_dma,
> +				(u64)zdev->dma_table);
> +
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(kvm_s390_pci_interp_disable);
> +
>   int kvm_s390_pci_dev_open(struct zpci_dev *zdev)
>   {
>   	struct kvm_zdev *kzdev;
> diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
> index 175854c861cd..0eac84387f3c 100644
> --- a/arch/s390/pci/pci.c
> +++ b/arch/s390/pci/pci.c
> @@ -141,6 +141,7 @@ int zpci_register_ioat(struct zpci_dev *zdev, u8 dmaas,
>   		zpci_dbg(3, "reg ioat fid:%x, cc:%d, status:%d\n", zdev->fid, cc, status);
>   	return cc;
>   }
> +EXPORT_SYMBOL_GPL(zpci_register_ioat);
>   
>   /* Modify PCI: Unregister I/O address translation parameters */
>   int zpci_unregister_ioat(struct zpci_dev *zdev, u8 dmaas)
> @@ -740,6 +741,7 @@ int zpci_enable_device(struct zpci_dev *zdev)
>   		zpci_update_fh(zdev, fh);
>   	return rc;
>   }
> +EXPORT_SYMBOL_GPL(zpci_enable_device);
>   
>   int zpci_disable_device(struct zpci_dev *zdev)
>   {
> @@ -763,6 +765,7 @@ int zpci_disable_device(struct zpci_dev *zdev)
>   	}
>   	return rc;
>   }
> +EXPORT_SYMBOL_GPL(zpci_disable_device);
>   
>   /**
>    * zpci_hot_reset_device - perform a reset of the given zPCI function
> 

-- 
Pierre Morel
IBM Lab Boeblingen
