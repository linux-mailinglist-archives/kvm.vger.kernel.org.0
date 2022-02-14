Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9199A4B5186
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 14:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354198AbiBNNU6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 08:20:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232754AbiBNNU4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 08:20:56 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2CD483A6;
        Mon, 14 Feb 2022 05:20:47 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21ECOacG006978;
        Mon, 14 Feb 2022 13:20:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=UwukFCsKi6SSXCr1VulAbtr3/TEKFsM186944EFpi9I=;
 b=SJWtSZN11Jf5JEtB7Ufw8nwU2JzjiBXHibKTnpBLbw0B68zrw2SlfN+EfupDTPTNMIWv
 qqjN9Y77ijEmxjYlep3WhgRtW6pZhBs5yPQ+BmrBnNNVtXM3eJaX2ycU8ONDlIfiWh9s
 MvglacoAZ+U7Ln3B+D6Qc7cC2T+95MwXtLpIfb+5X3I2YvIcqeSwYVUaMvx7EDKwcVK1
 ok61z4TMsEc9NRf7oJZ7lyifs+0j66yG4sT557bSNXOQgYRPpIV7wnllhC86ctUFy2QO
 sgJ4oYK2bVM39Snj83MC/kKDVvMKN/l+R3ngYYnmjQFPZ231kK4cBpsHkOprvEXlLOfA qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e7c4dx96c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 13:20:46 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21ED6ZqN029828;
        Mon, 14 Feb 2022 13:20:46 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e7c4dx95q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 13:20:46 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21EDDmmA001177;
        Mon, 14 Feb 2022 13:20:44 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 3e64h9ctq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 13:20:44 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21EDKcx541484612
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 13:20:38 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 54FBBA405C;
        Mon, 14 Feb 2022 13:20:38 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 635A2A4066;
        Mon, 14 Feb 2022 13:20:37 +0000 (GMT)
Received: from [9.171.42.254] (unknown [9.171.42.254])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 14 Feb 2022 13:20:37 +0000 (GMT)
Message-ID: <107d60a4-e31f-5bfa-fc1c-8340b8bbf573@linux.ibm.com>
Date:   Mon, 14 Feb 2022 14:22:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v3 19/30] KVM: s390: pci: provide routines for
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
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
 <20220204211536.321475-20-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220204211536.321475-20-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XuyCLGJ_4RvWelsUqXWaU1hyih50-u-1
X-Proofpoint-ORIG-GUID: avgdvanuDC-i9YT0_ndxk42QXidTDxQ8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_06,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 adultscore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0
 suspectscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202140076
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/4/22 22:15, Matthew Rosato wrote:
> These routines will be wired into the vfio_pci_zdev ioctl handlers to
> respond to requests to enable / disable a device for zPCI Load/Store
> interpretation.
> 
> The first time such a request is received, enable the necessary facilities
> for the guest.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   arch/s390/include/asm/kvm_pci.h |   4 ++
>   arch/s390/kvm/pci.c             | 102 ++++++++++++++++++++++++++++++++
>   arch/s390/pci/pci.c             |   3 +
>   3 files changed, 109 insertions(+)
> 
> diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
> index ef10f9e46e37..422701d526dd 100644
> --- a/arch/s390/include/asm/kvm_pci.h
> +++ b/arch/s390/include/asm/kvm_pci.h
> @@ -24,4 +24,8 @@ struct kvm_zdev {
>   int kvm_s390_pci_dev_open(struct zpci_dev *zdev);
>   void kvm_s390_pci_dev_release(struct zpci_dev *zdev);
>   
> +int kvm_s390_pci_interp_probe(struct zpci_dev *zdev);
> +int kvm_s390_pci_interp_enable(struct zpci_dev *zdev);
> +int kvm_s390_pci_interp_disable(struct zpci_dev *zdev);
> +
>   #endif /* ASM_KVM_PCI_H */
> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
> index 9b8390133e15..16bef3935284 100644
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
> @@ -153,6 +155,106 @@ int kvm_s390_pci_aen_init(u8 nisc)
>   	return rc;
>   }
>   
> +int kvm_s390_pci_interp_probe(struct zpci_dev *zdev)
> +{
> +	/* Must have appropriate hardware facilities */
> +	if (!sclp.has_zpci_lsi || !sclp.has_aisii || !sclp.has_aeni ||
> +	    !sclp.has_aisi || !test_facility(69) || !test_facility(70) ||
> +	    !test_facility(71) || !test_facility(72)) {
> +		return -EINVAL;
> +	}

I do not think we need to check STFLE facilities when the SCLP bit 
indicating the interpretation of a facility is installed the STFLE bit 
indicating the interpreted facility is also installed.


Otherwise, look good to me, with this change:
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>

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
> +	u32 gisa;
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
> +	gisa = (u32)virt_to_phys(&zdev->kzdev->kvm->arch.sie_page2->gisa);
> +	if (zdev->gisa != 0 && zdev->gisa != gisa)
> +		return -EPERM;
> +
> +	if (zdev_enabled(zdev)) {
> +		zdev->gisa = 0;
> +		rc = zpci_disable_device(zdev);
> +		if (rc)
> +			return rc;
> +	}
> +
> +	/*
> +	 * Store information about the identity of the kvm guest allowed to
> +	 * access this device via interpretation to be used by host CLP
> +	 */
> +	zdev->gisa = gisa;
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
> +	zdev->gisa = 0;
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(kvm_s390_pci_interp_enable);
> +
> +int kvm_s390_pci_interp_disable(struct zpci_dev *zdev)
> +{
> +	int rc;
> +
> +	if (zdev->gisa == 0)
> +		return -EINVAL;
> +
> +	/* Remove the host CLP guest designation */
> +	zdev->gisa = 0;
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
> index 13033717cd4e..5dbe49ec325e 100644
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
