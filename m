Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F27559654A
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 00:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237888AbiHPWPj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 18:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237912AbiHPWPb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 18:15:31 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2EA178225;
        Tue, 16 Aug 2022 15:15:29 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27GLjsEY002968;
        Tue, 16 Aug 2022 22:15:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=d0V+gitQ+pENDmKEI1yQuDeN9jRxsYsOaUJNKg4xUKY=;
 b=R1SSE4jXVrYJww6k3e+Svf/qOCmOi6s01otGX1RRvA5HIGN85ABQImKnNWAPC7I7yI4a
 piVrbBcR5l7q0eoAd9uHSyL6HNq5/yB7QHIO2zhK5aBhvqqistbFGeNZ6ogXTOKRUPFv
 TOeIo7L3jMbP/q/A/DZ0SAHsvhswgMIdO3RklM6EAhaJvM7oMALYHlNMx61rjyI5HXh7
 QegP6zR6L+VIQP8Royq+u2Du59+PIBFv9/H/B9XZYOSdz7LICjDwFUNB20xb271NpyPf
 UfkyjfuV4Ogc1QAYbboXLxiTl/ryjZg0k+vuzscTh2/TXzVT46qRdegxwGonaqkSZTT0 fg== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j0kekrmfr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 22:15:23 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27GM6c5K001852;
        Tue, 16 Aug 2022 22:15:22 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma04dal.us.ibm.com with ESMTP id 3hx3ka1pqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 22:15:22 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27GMFKKH14287466
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Aug 2022 22:15:20 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF1B8BE058;
        Tue, 16 Aug 2022 22:15:20 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EDBECBE053;
        Tue, 16 Aug 2022 22:15:18 +0000 (GMT)
Received: from [9.211.48.181] (unknown [9.211.48.181])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 16 Aug 2022 22:15:18 +0000 (GMT)
Message-ID: <b03be97f-cc03-cb58-bd1b-5eda3abd249a@linux.ibm.com>
Date:   Tue, 16 Aug 2022 18:15:17 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] KVM: s390: pci: VFIO_PCI ZDEV configuration fix
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     rdunlap@infradead.org, linux-kernel@vger.kernel.org, lkp@intel.com,
        borntraeger@linux.ibm.com, farman@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <1f2dd65e-b79b-44df-cc6a-8b3aa8fd61af@linux.ibm.com>
 <20220816202855.189410-1-pmorel@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220816202855.189410-1-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WFXgZDDTnst9prixxtIFQYqqMmzhVs9A
X-Proofpoint-ORIG-GUID: WFXgZDDTnst9prixxtIFQYqqMmzhVs9A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-16_08,2022-08-16_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxscore=0 priorityscore=1501 mlxlogscore=999
 malwarescore=0 impostorscore=0 clxscore=1015 bulkscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208160080
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/16/22 4:28 PM, Pierre Morel wrote:
> Fixing configuration for VFIO PCI interpretation.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Fixes: 09340b2fca007 ("KVM: s390: pci: add routines to start/stop inter..")
> Fixes: c435c54639aa5 ("vfio/pci: introduce CONFIG_VFIO_PCI_ZDEV_KVM..")
> Cc: <stable@vger.kernel.org>
> ---
>  arch/s390/include/asm/kvm_host.h | 9 ---------
>  arch/s390/kvm/Makefile           | 2 +-
>  arch/s390/kvm/pci.c              | 4 ++--
>  drivers/vfio/pci/Kconfig         | 4 ++--
>  include/linux/vfio_pci_core.h    | 2 +-
>  5 files changed, 6 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index f39092e0ceaa..f6cf961731af 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -1038,16 +1038,7 @@ static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>  #define __KVM_HAVE_ARCH_VM_FREE
>  void kvm_arch_free_vm(struct kvm *kvm);
>  
> -#ifdef CONFIG_VFIO_PCI_ZDEV_KVM
>  int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm);
>  void kvm_s390_pci_unregister_kvm(struct zpci_dev *zdev);
> -#else
> -static inline int kvm_s390_pci_register_kvm(struct zpci_dev *dev,
> -					    struct kvm *kvm)
> -{
> -	return -EPERM;
> -}
> -static inline void kvm_s390_pci_unregister_kvm(struct zpci_dev *dev) {}
> -#endif
>  
>  #endif
> diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
> index 02217fb4ae10..be36afcfd6ff 100644
> --- a/arch/s390/kvm/Makefile
> +++ b/arch/s390/kvm/Makefile
> @@ -9,6 +9,6 @@ ccflags-y := -Ivirt/kvm -Iarch/s390/kvm
>  
>  kvm-y += kvm-s390.o intercept.o interrupt.o priv.o sigp.o
>  kvm-y += diag.o gaccess.o guestdbg.o vsie.o pv.o
> +kvm-y += pci.o
>  
> -kvm-$(CONFIG_VFIO_PCI_ZDEV_KVM) += pci.o

You would need to switch this to CONFIG_PCI at least, else we get build errors with CONFIG_PCI=n.

>  obj-$(CONFIG_KVM) += kvm.o
> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
> index 4946fb7757d6..cf8ab72a2109 100644
> --- a/arch/s390/kvm/pci.c
> +++ b/arch/s390/kvm/pci.c
> @@ -435,7 +435,7 @@ int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm)
>  {
>  	int rc;
>  
> -	if (!zdev)
> +	if (!IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM) || !zdev)
>  		return -EINVAL;
>  
>  	mutex_lock(&zdev->kzdev_lock);
> @@ -516,7 +516,7 @@ void kvm_s390_pci_unregister_kvm(struct zpci_dev *zdev)
>  {
>  	struct kvm *kvm;
>  
> -	if (!zdev)
> +	if (!IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM) || !zdev)
>  		return;
>  
>  	mutex_lock(&zdev->kzdev_lock);
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index f9d0c908e738..bbc375b028ef 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -45,9 +45,9 @@ config VFIO_PCI_IGD
>  endif
>  
>  config VFIO_PCI_ZDEV_KVM
> -	bool "VFIO PCI extensions for s390x KVM passthrough"
> +	def_tristate y
> +	prompt "VFIO PCI extensions for s390x KVM passthrough"
>  	depends on S390 && KVM
> -	default y
>  	help
>  	  Support s390x-specific extensions to enable support for enhancements
>  	  to KVM passthrough capabilities, such as interpretive execution of
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index 5579ece4347b..7db3bb8129b1 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -205,7 +205,7 @@ static inline int vfio_pci_igd_init(struct vfio_pci_core_device *vdev)
>  }
>  #endif
>  
> -#ifdef CONFIG_VFIO_PCI_ZDEV_KVM
> +#if IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM)
>  int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
>  				struct vfio_info_cap *caps);
>  int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev);

This still doesn't seem quite right...  I tried some variations:

1)
CONFIG_KVM=m
CONFIG_VFIO_PCI_CORE=m
CONFIG_VFIO_PCI=m
CONFIG_VFIO_PCI_ZDEV_KVM=m

compiles, works with a small change:

diff --git a/include/linux/sched/user.h b/include/linux/sched/user.h
index f054d0360a75..99734e135420 100644
--- a/include/linux/sched/user.h
+++ b/include/linux/sched/user.h
@@ -25,7 +25,7 @@ struct user_struct {
 
 #if defined(CONFIG_PERF_EVENTS) || defined(CONFIG_BPF_SYSCALL) || \
        defined(CONFIG_NET) || defined(CONFIG_IO_URING) || \
-       defined(CONFIG_VFIO_PCI_ZDEV_KVM)
+       IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM)


2)
CONFIG_KVM=y
CONFIG_VFIO_PCI_CORE=m
CONFIG_VFIO_PCI=m
CONFIG_VFIO_PCI_ZDEV_KVM=m

compiles, works with above user.h change

3)
CONFIG_KVM=y
CONFIG_VFIO_PCI_CORE=y
CONFIG_VFIO_PCI=y
CONFIG_VFIO_PCI_ZDEV_KVM=y

compiles, works with above user.h change

4)
CONFIG_KVM=m
CONFIG_VFIO_PCI_CORE=y
CONFIG_VFIO_PCI=y
CONFIG_VFIO_PCI_ZDEV_KVM=m

fails with:

ld: drivers/vfio/pci/vfio_pci_core.o: in function `vfio_pci_core_enable':
/usr/src/linux/drivers/vfio/pci/vfio_pci_core.c:320: undefined reference to `vfio_pci_zdev_open_device'
ld: /usr/src/linux/drivers/vfio/pci/vfio_pci_core.c:349: undefined reference to `vfio_pci_zdev_close_device'
ld: drivers/vfio/pci/vfio_pci_core.o: in function `vfio_pci_core_disable':
/usr/src/linux/drivers/vfio/pci/vfio_pci_core.c:428: undefined reference to `vfio_pci_zdev_close_device'
ld: drivers/vfio/pci/vfio_pci_core.o: in function `vfio_pci_core_ioctl':
/usr/src/linux/drivers/vfio/pci/vfio_pci_core.c:712: undefined reference to `vfio_pci_info_zdev_add_caps'


5)
CONFIG_KVM=m
CONFIG_VFIO_PCI_CORE=y
CONFIG_VFIO_PCI=y
CONFIG_VFIO_PCI_ZDEV_KVM=y

This forces CONFIG_VFIO_PCI_ZDEV_KVM to 'm' and fails as above.



