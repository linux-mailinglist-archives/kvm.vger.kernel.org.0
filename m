Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2594598E3E
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 22:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345888AbiHRUjN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 16:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346109AbiHRUjJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 16:39:09 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FEF9CB5E2;
        Thu, 18 Aug 2022 13:39:04 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27IKXo3C003864;
        Thu, 18 Aug 2022 20:38:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=v148aeGtidlwolKhgufJrMAFl/TLk02HAbEbOB3OYe0=;
 b=FGO4UwANhlN800M0LY7gPRPQj+0cOEdUiwPTSBdzmJrH5aGJKpsOLQpJ9SVxu4EMuO2U
 KYKJug+FIQGLc55JqwNWGwC8ZKLjwrhCIjojkA4XIhZxdNYyBdYdiqQYqXt3zhcdR0A0
 ot+04ax2f28gZtVtIJDdcT+HG8CEaP1IrDIAppzM+PLuLJvuH6YouUNu/xCNyxBMIppu
 uxhMfPHPJKwmf1uEkbMqOBXJTELNIzR+F4RQw27sG7MRZwfxDCQyZ+snE4jejOOeF20L
 F1ferf/R3pQyoXcWqUB4R5F32t9T3hN+/7A7nZmICMrZhTaKWJLUPuYQtEvEi9D9QfHG XA== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j1vjtg2us-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Aug 2022 20:38:36 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27IKKjJQ001509;
        Thu, 18 Aug 2022 20:38:35 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma04wdc.us.ibm.com with ESMTP id 3hx3ka10g9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Aug 2022 20:38:35 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27IKcYHd62980476
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Aug 2022 20:38:34 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C00F1124052;
        Thu, 18 Aug 2022 20:38:34 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A67E124053;
        Thu, 18 Aug 2022 20:38:32 +0000 (GMT)
Received: from [9.211.138.234] (unknown [9.211.138.234])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 18 Aug 2022 20:38:31 +0000 (GMT)
Message-ID: <3450ba5f-d6f4-d04c-3501-8cf375389347@linux.ibm.com>
Date:   Thu, 18 Aug 2022 16:38:31 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] KVM: s390: pci: Hook to access KVM lowlevel from VFIO
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     rdunlap@infradead.org, linux-kernel@vger.kernel.org, lkp@intel.com,
        borntraeger@linux.ibm.com, farman@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org, gor@linux.ibm.com,
        hca@linux.ibm.com, schnelle@linux.ibm.com, frankja@linux.ibm.com
References: <20220818164652.269336-1-pmorel@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220818164652.269336-1-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Nu1bnRBHlHpqoOulw5WF2Rko1pAY89Ei
X-Proofpoint-ORIG-GUID: Nu1bnRBHlHpqoOulw5WF2Rko1pAY89Ei
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-18_14,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 phishscore=0 bulkscore=0 clxscore=1015 suspectscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 mlxscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208180075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/18/22 12:46 PM, Pierre Morel wrote:
> We have a cross dependency between KVM and VFIO when using
> s390 vfio_pci_zdev extensions for PCI passthrough
> To be able to keep both subsystem modular we add a registering
> hook inside the S390 core code.
> 
> This fixes a build problem when VFIO is built-in and KVM is built
> as a module.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Fixes: 09340b2fca007 ("KVM: s390: pci: add routines to start/stop inter..")
> Cc: <stable@vger.kernel.org>
> ---
>  arch/s390/include/asm/kvm_host.h | 17 ++++++-----------
>  arch/s390/kvm/pci.c              | 10 ++++++----
>  arch/s390/pci/Makefile           |  2 ++
>  arch/s390/pci/pci_kvm_hook.c     | 11 +++++++++++
>  drivers/vfio/pci/vfio_pci_zdev.c |  8 ++++++--
>  5 files changed, 31 insertions(+), 17 deletions(-)
>  create mode 100644 arch/s390/pci/pci_kvm_hook.c
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index f39092e0ceaa..b1e98a9ed152 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -1038,16 +1038,11 @@ static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>  #define __KVM_HAVE_ARCH_VM_FREE
>  void kvm_arch_free_vm(struct kvm *kvm);
>  
> -#ifdef CONFIG_VFIO_PCI_ZDEV_KVM
> -int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm);
> -void kvm_s390_pci_unregister_kvm(struct zpci_dev *zdev);
> -#else
> -static inline int kvm_s390_pci_register_kvm(struct zpci_dev *dev,
> -					    struct kvm *kvm)
> -{
> -	return -EPERM;
> -}
> -static inline void kvm_s390_pci_unregister_kvm(struct zpci_dev *dev) {}
> -#endif
> +struct zpci_kvm_hook {
> +	int (*kvm_register)(void *opaque, struct kvm *kvm);
> +	void (*kvm_unregister)(void *opaque);
> +};
> +
> +extern struct zpci_kvm_hook zpci_kvm_hook;
>  
>  #endif
> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
> index 4946fb7757d6..22c025538323 100644
> --- a/arch/s390/kvm/pci.c
> +++ b/arch/s390/kvm/pci.c
> @@ -431,8 +431,9 @@ static void kvm_s390_pci_dev_release(struct zpci_dev *zdev)
>   * available, enable them and let userspace indicate whether or not they will
>   * be used (specify SHM bit to disable).
>   */
> -int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm)
> +static int kvm_s390_pci_register_kvm(void *opaque, struct kvm *kvm)
>  {
> +	struct zpci_dev *zdev = opaque;
>  	int rc;
>  
>  	if (!zdev)
> @@ -510,10 +511,10 @@ int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm)
>  	kvm_put_kvm(kvm);
>  	return rc;
>  }
> -EXPORT_SYMBOL_GPL(kvm_s390_pci_register_kvm);
>  
> -void kvm_s390_pci_unregister_kvm(struct zpci_dev *zdev)
> +static void kvm_s390_pci_unregister_kvm(void *opaque)
>  {
> +	struct zpci_dev *zdev = opaque;
>  	struct kvm *kvm;
>  
>  	if (!zdev)
> @@ -566,7 +567,6 @@ void kvm_s390_pci_unregister_kvm(struct zpci_dev *zdev)
>  
>  	kvm_put_kvm(kvm);
>  }
> -EXPORT_SYMBOL_GPL(kvm_s390_pci_unregister_kvm);
>  
>  void kvm_s390_pci_init_list(struct kvm *kvm)
>  {
> @@ -678,6 +678,8 @@ int kvm_s390_pci_init(void)
>  
>  	spin_lock_init(&aift->gait_lock);
>  	mutex_init(&aift->aift_lock);
> +	zpci_kvm_hook.kvm_register = kvm_s390_pci_register_kvm;
> +	zpci_kvm_hook.kvm_unregister = kvm_s390_pci_unregister_kvm;
>  
>  	return 0;
>  }

You should also set these to NULL in kvm_s390_pci_exit (which is called from kvm_arch_exit).  In practice, the kvm module would need to be loaded again before we have a nonzero vdev->vdev.kvm so it should never be an issue - but we should clean up anyway when the module is removed.

With that change:

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

> diff --git a/arch/s390/pci/Makefile b/arch/s390/pci/Makefile
> index bf557a1b789c..c02dbfb415d9 100644
> --- a/arch/s390/pci/Makefile
> +++ b/arch/s390/pci/Makefile
> @@ -7,3 +7,5 @@ obj-$(CONFIG_PCI)	+= pci.o pci_irq.o pci_dma.o pci_clp.o pci_sysfs.o \
>  			   pci_event.o pci_debug.o pci_insn.o pci_mmio.o \
>  			   pci_bus.o
>  obj-$(CONFIG_PCI_IOV)	+= pci_iov.o
> +
> +obj-y += pci_kvm_hook.o
> diff --git a/arch/s390/pci/pci_kvm_hook.c b/arch/s390/pci/pci_kvm_hook.c
> new file mode 100644
> index 000000000000..ff34baf50a3e
> --- /dev/null
> +++ b/arch/s390/pci/pci_kvm_hook.c
> @@ -0,0 +1,11 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * VFIO ZPCI devices support
> + *
> + * Copyright (C) IBM Corp. 2022.  All rights reserved.
> + *	Author(s): Pierre Morel <pmorel@linux.ibm.com>
> + */
> +#include <linux/kvm_host.h>
> +
> +struct zpci_kvm_hook zpci_kvm_hook;
> +EXPORT_SYMBOL_GPL(zpci_kvm_hook);
> diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
> index e163aa9f6144..0cbdcd14f1c8 100644
> --- a/drivers/vfio/pci/vfio_pci_zdev.c
> +++ b/drivers/vfio/pci/vfio_pci_zdev.c
> @@ -151,7 +151,10 @@ int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev)
>  	if (!vdev->vdev.kvm)
>  		return 0;
>  
> -	return kvm_s390_pci_register_kvm(zdev, vdev->vdev.kvm);
> +	if (zpci_kvm_hook.kvm_register)
> +		return zpci_kvm_hook.kvm_register(zdev, vdev->vdev.kvm);
> +
> +	return -ENOENT;
>  }
>  
>  void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev)
> @@ -161,5 +164,6 @@ void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev)
>  	if (!zdev || !vdev->vdev.kvm)
>  		return;
>  
> -	kvm_s390_pci_unregister_kvm(zdev);
> +	if (zpci_kvm_hook.kvm_unregister)
> +		zpci_kvm_hook.kvm_unregister(zdev);
>  }

