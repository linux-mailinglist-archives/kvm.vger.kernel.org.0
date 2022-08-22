Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 531FD59BBBD
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 10:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233654AbiHVIgo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 04:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233165AbiHVIgj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 04:36:39 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F6B2B601;
        Mon, 22 Aug 2022 01:36:38 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27M8DkTW022065;
        Mon, 22 Aug 2022 08:36:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=BZ9FJcxb7PQETdvtuVkYIl4AIf6QqXOJHUn4XibynCY=;
 b=L4YAPJX66dzFGoQj2gDF8Hsmr7344A2ZUtNOmI2Nf5tjiFnoDKfgAyIKINgihl1hmM3m
 wD44Lb5IZ0EBjCfYYs/LaFLQV4ekuDicxPXBkEY/Aj7HtmqAcd4mm8LLb2eu6R5rv+fh
 3oazPEwkYgE1lcZt7pUuiqkCAWAci1nEF7MSOZ78D7Dn9t6QmvH75Gy6HZhsh+bzA4S7
 JmFumxVZ+EhGGeXeYXe4RsUi8uIVpH3bdlgbAkDvHT7PBqSKIXqA40hwX3/txvPnMC3K
 5N4JwlN1Vqr0dSN8Z/TNObzrjeRY/wVGe+dlJPLsYjW7PQs4FBunkPVXyPnLiF6GZowh bQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j463srkt0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Aug 2022 08:36:10 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27M8FNam031973;
        Mon, 22 Aug 2022 08:36:09 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j463srks0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Aug 2022 08:36:09 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27M8L55l011993;
        Mon, 22 Aug 2022 08:36:07 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3j2q88t57s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Aug 2022 08:36:07 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27M8X8vW34275586
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Aug 2022 08:33:08 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B45011C04A;
        Mon, 22 Aug 2022 08:36:04 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB14E11C052;
        Mon, 22 Aug 2022 08:36:03 +0000 (GMT)
Received: from [9.171.10.26] (unknown [9.171.10.26])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 22 Aug 2022 08:36:03 +0000 (GMT)
Message-ID: <388e7af7-be76-61a3-a9ce-9a148097610e@linux.ibm.com>
Date:   Mon, 22 Aug 2022 10:36:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2] KVM: s390: pci: Hook to access KVM lowlevel from VFIO
Content-Language: en-US
To:     Randy Dunlap <rdunlap@infradead.org>, mjrosato@linux.ibm.com
Cc:     linux-kernel@vger.kernel.org, lkp@intel.com,
        borntraeger@linux.ibm.com, farman@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org, gor@linux.ibm.com,
        hca@linux.ibm.com, schnelle@linux.ibm.com, frankja@linux.ibm.com,
        alex.williamson@redhat.com, cohuck@redhat.com
References: <20220819122945.9309-1-pmorel@linux.ibm.com>
 <0bea8b2c-3345-e475-01f7-fd9c44096244@infradead.org>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <0bea8b2c-3345-e475-01f7-fd9c44096244@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3WOxVt9VlURVIiO71LjIWo_pDSyUMHk9
X-Proofpoint-ORIG-GUID: KJhfxuCNCsMQiYYq1V0c_lSoKffrfNLH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-22_04,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208220036
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/19/22 23:10, Randy Dunlap wrote:
> 
> 
> On 8/19/22 05:29, Pierre Morel wrote:
>> We have a cross dependency between KVM and VFIO when using
>> s390 vfio_pci_zdev extensions for PCI passthrough
>> To be able to keep both subsystem modular we add a registering
>> hook inside the S390 core code.
>>
>> This fixes a build problem when VFIO is built-in and KVM is built
>> as a module.
>>
>> Reported-by: Randy Dunlap <rdunlap@infradead.org>
>> Reported-by: kernel test robot <lkp@intel.com>
>> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Fixes: 09340b2fca007 ("KVM: s390: pci: add routines to start/stop interpretive execution")
>> Cc: <stable@vger.kernel.org>
> 
> Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
> 
> Thanks.

Thanks Randy,

Regards,
Pierre


> 
>> ---
>>   arch/s390/include/asm/kvm_host.h | 17 ++++++-----------
>>   arch/s390/kvm/pci.c              | 12 ++++++++----
>>   arch/s390/pci/Makefile           |  2 +-
>>   arch/s390/pci/pci_kvm_hook.c     | 11 +++++++++++
>>   drivers/vfio/pci/vfio_pci_zdev.c |  8 ++++++--
>>   5 files changed, 32 insertions(+), 18 deletions(-)
>>   create mode 100644 arch/s390/pci/pci_kvm_hook.c
>>
>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
>> index f39092e0ceaa..b1e98a9ed152 100644
>> --- a/arch/s390/include/asm/kvm_host.h
>> +++ b/arch/s390/include/asm/kvm_host.h
>> @@ -1038,16 +1038,11 @@ static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>>   #define __KVM_HAVE_ARCH_VM_FREE
>>   void kvm_arch_free_vm(struct kvm *kvm);
>>   
>> -#ifdef CONFIG_VFIO_PCI_ZDEV_KVM
>> -int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm);
>> -void kvm_s390_pci_unregister_kvm(struct zpci_dev *zdev);
>> -#else
>> -static inline int kvm_s390_pci_register_kvm(struct zpci_dev *dev,
>> -					    struct kvm *kvm)
>> -{
>> -	return -EPERM;
>> -}
>> -static inline void kvm_s390_pci_unregister_kvm(struct zpci_dev *dev) {}
>> -#endif
>> +struct zpci_kvm_hook {
>> +	int (*kvm_register)(void *opaque, struct kvm *kvm);
>> +	void (*kvm_unregister)(void *opaque);
>> +};
>> +
>> +extern struct zpci_kvm_hook zpci_kvm_hook;
>>   
>>   #endif
>> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
>> index 4946fb7757d6..bb8c335d17b9 100644
>> --- a/arch/s390/kvm/pci.c
>> +++ b/arch/s390/kvm/pci.c
>> @@ -431,8 +431,9 @@ static void kvm_s390_pci_dev_release(struct zpci_dev *zdev)
>>    * available, enable them and let userspace indicate whether or not they will
>>    * be used (specify SHM bit to disable).
>>    */
>> -int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm)
>> +static int kvm_s390_pci_register_kvm(void *opaque, struct kvm *kvm)
>>   {
>> +	struct zpci_dev *zdev = opaque;
>>   	int rc;
>>   
>>   	if (!zdev)
>> @@ -510,10 +511,10 @@ int kvm_s390_pci_register_kvm(struct zpci_dev *zdev, struct kvm *kvm)
>>   	kvm_put_kvm(kvm);
>>   	return rc;
>>   }
>> -EXPORT_SYMBOL_GPL(kvm_s390_pci_register_kvm);
>>   
>> -void kvm_s390_pci_unregister_kvm(struct zpci_dev *zdev)
>> +static void kvm_s390_pci_unregister_kvm(void *opaque)
>>   {
>> +	struct zpci_dev *zdev = opaque;
>>   	struct kvm *kvm;
>>   
>>   	if (!zdev)
>> @@ -566,7 +567,6 @@ void kvm_s390_pci_unregister_kvm(struct zpci_dev *zdev)
>>   
>>   	kvm_put_kvm(kvm);
>>   }
>> -EXPORT_SYMBOL_GPL(kvm_s390_pci_unregister_kvm);
>>   
>>   void kvm_s390_pci_init_list(struct kvm *kvm)
>>   {
>> @@ -678,6 +678,8 @@ int kvm_s390_pci_init(void)
>>   
>>   	spin_lock_init(&aift->gait_lock);
>>   	mutex_init(&aift->aift_lock);
>> +	zpci_kvm_hook.kvm_register = kvm_s390_pci_register_kvm;
>> +	zpci_kvm_hook.kvm_unregister = kvm_s390_pci_unregister_kvm;
>>   
>>   	return 0;
>>   }
>> @@ -685,6 +687,8 @@ int kvm_s390_pci_init(void)
>>   void kvm_s390_pci_exit(void)
>>   {
>>   	mutex_destroy(&aift->aift_lock);
>> +	zpci_kvm_hook.kvm_register = NULL;
>> +	zpci_kvm_hook.kvm_unregister = NULL;
>>   
>>   	kfree(aift);
>>   }
>> diff --git a/arch/s390/pci/Makefile b/arch/s390/pci/Makefile
>> index bf557a1b789c..5ae31ca9dd44 100644
>> --- a/arch/s390/pci/Makefile
>> +++ b/arch/s390/pci/Makefile
>> @@ -5,5 +5,5 @@
>>   
>>   obj-$(CONFIG_PCI)	+= pci.o pci_irq.o pci_dma.o pci_clp.o pci_sysfs.o \
>>   			   pci_event.o pci_debug.o pci_insn.o pci_mmio.o \
>> -			   pci_bus.o
>> +			   pci_bus.o pci_kvm_hook.o
>>   obj-$(CONFIG_PCI_IOV)	+= pci_iov.o
>> diff --git a/arch/s390/pci/pci_kvm_hook.c b/arch/s390/pci/pci_kvm_hook.c
>> new file mode 100644
>> index 000000000000..ff34baf50a3e
>> --- /dev/null
>> +++ b/arch/s390/pci/pci_kvm_hook.c
>> @@ -0,0 +1,11 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * VFIO ZPCI devices support
>> + *
>> + * Copyright (C) IBM Corp. 2022.  All rights reserved.
>> + *	Author(s): Pierre Morel <pmorel@linux.ibm.com>
>> + */
>> +#include <linux/kvm_host.h>
>> +
>> +struct zpci_kvm_hook zpci_kvm_hook;
>> +EXPORT_SYMBOL_GPL(zpci_kvm_hook);
>> diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
>> index e163aa9f6144..0cbdcd14f1c8 100644
>> --- a/drivers/vfio/pci/vfio_pci_zdev.c
>> +++ b/drivers/vfio/pci/vfio_pci_zdev.c
>> @@ -151,7 +151,10 @@ int vfio_pci_zdev_open_device(struct vfio_pci_core_device *vdev)
>>   	if (!vdev->vdev.kvm)
>>   		return 0;
>>   
>> -	return kvm_s390_pci_register_kvm(zdev, vdev->vdev.kvm);
>> +	if (zpci_kvm_hook.kvm_register)
>> +		return zpci_kvm_hook.kvm_register(zdev, vdev->vdev.kvm);
>> +
>> +	return -ENOENT;
>>   }
>>   
>>   void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev)
>> @@ -161,5 +164,6 @@ void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev)
>>   	if (!zdev || !vdev->vdev.kvm)
>>   		return;
>>   
>> -	kvm_s390_pci_unregister_kvm(zdev);
>> +	if (zpci_kvm_hook.kvm_unregister)
>> +		zpci_kvm_hook.kvm_unregister(zdev);
>>   }
> 

-- 
Pierre Morel
IBM Lab Boeblingen
