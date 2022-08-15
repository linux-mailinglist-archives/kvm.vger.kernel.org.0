Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F20BF592CBD
	for <lists+kvm@lfdr.de>; Mon, 15 Aug 2022 12:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242024AbiHOJi1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 05:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbiHOJiZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 05:38:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B3B1EC7C;
        Mon, 15 Aug 2022 02:38:22 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27F88sgu016417;
        Mon, 15 Aug 2022 09:38:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=IbpeGsBI/BRs+5EysySHvJxSdnMw6gNwuIS9nFUKMGg=;
 b=Tl6kCUSCoLUk3uONjRsb8DPo1WTTL2BCskI+cE5BbgzwoMt1kZT5jDf4I/y9IXCMxfg1
 ZESlB+fessZyv25ggqTN+P5V1hH48IthqmbnRA0tRCIbc6jGrimwEuoFD3qDOeZpvqdg
 t7ILsuxm9YhyusBuYVD3iNCVAdX9Z7WuJX4ArMjcD/RgNbfLc/K/1RYOSR6v4cye90dS
 ncx1eUx6cHLMcupLGlm3FHme1Ssi8twrfpvhq0TYCJtO12fRrYWuvVbAyRihuKLc4unF
 8zMRRJM0NxxB5nHmlIAf9kxkxzqsgeHB2HWIK+4Q7xgStob2TvPrU4Y2n4YfoyUSW5LE Tg== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hyj0gtbj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Aug 2022 09:38:14 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27F9aiJK008239;
        Mon, 15 Aug 2022 09:38:13 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3hx3k91c9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Aug 2022 09:38:12 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27F9c9p732178532
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Aug 2022 09:38:09 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CDE4CAE045;
        Mon, 15 Aug 2022 09:38:09 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6488BAE04D;
        Mon, 15 Aug 2022 09:38:09 +0000 (GMT)
Received: from [9.171.34.81] (unknown [9.171.34.81])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 15 Aug 2022 09:38:09 +0000 (GMT)
Message-ID: <663c7595-1c18-043e-5f12-b0ce880b84bf@linux.ibm.com>
Date:   Mon, 15 Aug 2022 11:43:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] vfio-pci/zdev: require KVM to be built-in
Content-Language: en-US
To:     Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20220814215154.32112-1-rdunlap@infradead.org>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220814215154.32112-1-rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dU61yVc1_xRQs_b-j0KqvCVIZOL7u_iF
X-Proofpoint-ORIG-GUID: dU61yVc1_xRQs_b-j0KqvCVIZOL7u_iF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-15_06,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 spamscore=0 mlxscore=0 phishscore=0 adultscore=0
 bulkscore=0 impostorscore=0 clxscore=1011 lowpriorityscore=0
 mlxlogscore=999 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2207270000 definitions=main-2208150034
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thank you Randy for this good catch.
However forcing KVM to be include statically in the kernel when using 
VFIO_PCI extensions is not a good solution for us I think.

I suggest we better do something like:

----

diff --git a/arch/s390/include/asm/kvm_host.h 
b/arch/s390/include/asm/kvm_host.h
index 6287a843e8bc..1733339cc4eb 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -1038,7 +1038,7 @@ static inline void kvm_arch_vcpu_unblocking(struct 
kvm_vcpu *vcpu) {}
  #define __KVM_HAVE_ARCH_VM_FREE
  void kvm_arch_free_vm(struct kvm *kvm);

-#ifdef CONFIG_VFIO_PCI_ZDEV_KVM
+#if defined(CONFIG_VFIO_PCI_ZDEV_KVM) || 
defined(CONFIG_VFIO_PCI_ZDEV_KVM_MODULE)
  int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm);
  void kvm_s390_pci_unregister_kvm(struct zpci_dev *zdev);
  #else
diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index f9d0c908e738..bbc375b028ef 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -45,9 +45,9 @@ config VFIO_PCI_IGD
  endif

  config VFIO_PCI_ZDEV_KVM
-       bool "VFIO PCI extensions for s390x KVM passthrough"
+       def_tristate y
+       prompt "VFIO PCI extensions for s390x KVM passthrough"
         depends on S390 && KVM
-       default y
         help
           Support s390x-specific extensions to enable support for 
enhancements
           to KVM passthrough capabilities, such as interpretive 
execution of

----

What do you think? It seems to me it solves the problem, what do you think?

Regards,
Pierre

On 8/14/22 23:51, Randy Dunlap wrote:
> Fix build errors when CONFIG_KVM=m:
> 
> s390-linux-ld: drivers/vfio/pci/vfio_pci_zdev.o: in function `vfio_pci_zdev_open_device':
> vfio_pci_zdev.c:(.text+0x242): undefined reference to `kvm_s390_pci_register_kvm'
> s390-linux-ld: drivers/vfio/pci/vfio_pci_zdev.o: in function `vfio_pci_zdev_close_device':
> vfio_pci_zdev.c:(.text+0x296): undefined reference to `kvm_s390_pci_unregister_kvm'
> 
> Having a bool Kconfig symbol depend on a tristate symbol can often
> lead to problems like this.
> 
> Fixes: 8061d1c31f1a ("vfio-pci/zdev: add open/close device hooks")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: Matthew Rosato <mjrosato@linux.ibm.com>
> Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
> Cc: Pierre Morel <pmorel@linux.ibm.com>
> Cc: Eric Farman <farman@linux.ibm.com>
> Cc: linux-s390@vger.kernel.org
> Cc: kvm@vger.kernel.org
> ---
>   drivers/vfio/pci/Kconfig |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -46,7 +46,7 @@ endif
>   
>   config VFIO_PCI_ZDEV_KVM
>   	bool "VFIO PCI extensions for s390x KVM passthrough"
> -	depends on S390 && KVM
> +	depends on S390 && KVM=y
>   	default y
>   	help
>   	  Support s390x-specific extensions to enable support for enhancements
> 

-- 
Pierre Morel
IBM Lab Boeblingen
