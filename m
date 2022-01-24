Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34FB249827C
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 15:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238869AbiAXOfD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 09:35:03 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62544 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238851AbiAXOfC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Jan 2022 09:35:02 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20OEHr4I004956;
        Mon, 24 Jan 2022 14:35:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=jw3VQBR3L4SwMNlmNuj+3fny674ETFe88Mqy3G/OMuM=;
 b=tRcfYJ7nQ89mKnKaaBAmdRlfrRx4emUpUIEp/wzeF6X/F+xBB6Odk7NVPFKI2QuIyHhi
 GKCbdyu2Wml/8uN9JWDoKecxCX/zp6sqrMx0RGvp8FRTaHtVIQdX00YXHtQpEjWU8+lq
 6TdVxth2r6xEAI9UcytlfwalshsCn52RtwTXQJOxFlf/6WDYb5WJBRVvFFyExkRWidLN
 j8Gr+0o0tMKYTx0BqQWhIjCl5rVPuaNluTP2ecaq2mG1kavNoFAp7wtLVekp+dGBLdTh
 B3Mwe3dm5/PKDclgvGDvPI0hx4qECjaHW/Xy4Np19p5a7kNe4CTqyc8WNBPJrbLrvQNn qg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dsvbf31yb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jan 2022 14:35:01 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20OEIP3e011641;
        Mon, 24 Jan 2022 14:35:00 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dsvbf31xs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jan 2022 14:35:00 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20OESFVp019411;
        Mon, 24 Jan 2022 14:34:59 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3dr96j5fet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jan 2022 14:34:58 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20OEYtEF42664426
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jan 2022 14:34:55 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5FA7D5205A;
        Mon, 24 Jan 2022 14:34:55 +0000 (GMT)
Received: from [9.171.67.78] (unknown [9.171.67.78])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 59B655205F;
        Mon, 24 Jan 2022 14:34:54 +0000 (GMT)
Message-ID: <1c2a1e60-a4f6-2afa-6479-a2dbd0e6e849@linux.ibm.com>
Date:   Mon, 24 Jan 2022 15:36:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2 18/30] KVM: s390: pci: provide routines for
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
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
 <20220114203145.242984-19-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220114203145.242984-19-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3YnikYjHUttUuBSe3PIcp1CRipfYsn2Q
X-Proofpoint-ORIG-GUID: 6-s6tzk7Ddzw1wJTN4qKuwQ3FBVVRDLa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-24_07,2022-01-24_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 bulkscore=0 phishscore=0 suspectscore=0 priorityscore=1501 mlxlogscore=999
 spamscore=0 mlxscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201240094
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/14/22 21:31, Matthew Rosato wrote:
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
>   arch/s390/kvm/pci.c             | 99 +++++++++++++++++++++++++++++++++
>   arch/s390/pci/pci.c             |  3 +
>   3 files changed, 106 insertions(+)
> 
> diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
> index aafee2976929..072401aa7922 100644
> --- a/arch/s390/include/asm/kvm_pci.h
> +++ b/arch/s390/include/asm/kvm_pci.h
> @@ -26,4 +26,8 @@ int kvm_s390_pci_dev_open(struct zpci_dev *zdev);
>   void kvm_s390_pci_dev_release(struct zpci_dev *zdev);
>   void kvm_s390_pci_attach_kvm(struct zpci_dev *zdev, struct kvm *kvm);
>   
> +int kvm_s390_pci_interp_probe(struct zpci_dev *zdev);
> +int kvm_s390_pci_interp_enable(struct zpci_dev *zdev);
> +int kvm_s390_pci_interp_disable(struct zpci_dev *zdev);
> +
>   #endif /* ASM_KVM_PCI_H */
> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
> index dae853da6df1..122d0992b521 100644
> --- a/arch/s390/kvm/pci.c
> +++ b/arch/s390/kvm/pci.c
> @@ -12,7 +12,9 @@
>   #include <asm/kvm_pci.h>
>   #include <asm/pci.h>
>   #include <asm/pci_insn.h>
> +#include <asm/sclp.h>
>   #include "pci.h"
> +#include "kvm-s390.h"
>   
>   struct zpci_aift *aift;
>   
> @@ -143,6 +145,103 @@ int kvm_s390_pci_aen_init(u8 nisc)
>   	return rc;
>   }
>   
> +int kvm_s390_pci_interp_probe(struct zpci_dev *zdev)
> +{
> +	/* Must have appropriate hardware facilities */
> +	if (!(sclp.has_zpci_lsi && test_facility(69)))

Should'nt we also test the other facilities we need for the 
interpretation like ARNI, AISII, ASI and GISA ?

Or are we sure they are always there when ZPCI load/store interpretation 
is available?


> +		return -EINVAL;
> +
> +	/* Must have a KVM association registered */
> +	if (!zdev->kzdev || !zdev->kzdev->kvm)
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
> +	if (!zdev->kzdev || !zdev->kzdev->kvm)
> +		return -EINVAL;
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

should use the virt_to_phys transformation ?

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
> +				virt_to_phys(zdev->dma_table));
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
> +				virt_to_phys(zdev->dma_table));
> +
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(kvm_s390_pci_interp_disable);
> +
>   int kvm_s390_pci_dev_open(struct zpci_dev *zdev)
>   {
>   	struct kvm_zdev *kzdev;
> diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
> index 2a19becbc14c..58673f633869 100644
> --- a/arch/s390/pci/pci.c
> +++ b/arch/s390/pci/pci.c
> @@ -147,6 +147,7 @@ int zpci_register_ioat(struct zpci_dev *zdev, u8 dmaas,
>   		zpci_dbg(3, "reg ioat fid:%x, cc:%d, status:%d\n", zdev->fid, cc, status);
>   	return cc;
>   }
> +EXPORT_SYMBOL_GPL(zpci_register_ioat);
>   
>   /* Modify PCI: Unregister I/O address translation parameters */
>   int zpci_unregister_ioat(struct zpci_dev *zdev, u8 dmaas)
> @@ -727,6 +728,7 @@ int zpci_enable_device(struct zpci_dev *zdev)
>   		zpci_update_fh(zdev, fh);
>   	return rc;
>   }
> +EXPORT_SYMBOL_GPL(zpci_enable_device);
>   
>   int zpci_disable_device(struct zpci_dev *zdev)
>   {
> @@ -750,6 +752,7 @@ int zpci_disable_device(struct zpci_dev *zdev)
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
