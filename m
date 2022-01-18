Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74BDC492C63
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 18:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347283AbiARRaa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 12:30:30 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60648 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229701AbiARRa3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 12:30:29 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20IHTlor003961;
        Tue, 18 Jan 2022 17:30:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=al7xY5FqdR2bfpfG1KWR55uPxfNyjoj1fhFF3Z/BNs4=;
 b=JKiFhfR2gfZ61WzJ6aBa1N/dEDfVpiiii+Ld+d87hFg9PDcXCdD4RMd73DzvDzCsQa/a
 mjvLViHpsSL+PDi8CGadnxYrRvMPdFD61JBeYU6wlyp/3wN7gXLyaxY91cg0l65U0pVL
 5NmLX2puOv5niQYUy+vjz5HAH+fI0d0kCZLSRfA73HTvm68ER4hDS+gcofxYndcBOXus
 LMTNxfjXzEmVkkaeTZhBApmuWPusWEFNlDyA81gNwcOIUakOR9Z2KvgJ1/J9kxEMguAU
 YBfQfIoYalVlJY01mV8wylNxbpc9c26CggXZqpLY2Doz54MUy2a8BHl/PoYWv3lG4FmI TQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnutk34sn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 17:30:28 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20IGilMP009759;
        Tue, 18 Jan 2022 17:30:28 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnutk34rh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 17:30:28 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20IHNE9V015011;
        Tue, 18 Jan 2022 17:30:26 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3dnm6r6drm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 17:30:25 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20IHUK7121627278
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 17:30:20 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1246AE058;
        Tue, 18 Jan 2022 17:30:19 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F0F81AE051;
        Tue, 18 Jan 2022 17:30:18 +0000 (GMT)
Received: from [9.171.70.230] (unknown [9.171.70.230])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 17:30:18 +0000 (GMT)
Message-ID: <4d181623-24b5-980d-d78f-36472a622538@linux.ibm.com>
Date:   Tue, 18 Jan 2022 18:32:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2 14/30] KVM: s390: pci: add basic kvm_zdev structure
Content-Language: en-US
From:   Pierre Morel <pmorel@linux.ibm.com>
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
 <20220114203145.242984-15-mjrosato@linux.ibm.com>
 <adc3ce02-050d-356e-e911-81723f17ee00@linux.ibm.com>
In-Reply-To: <adc3ce02-050d-356e-e911-81723f17ee00@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mhOEpSlWhj4Dv51Z8Wn0dn9aYNv3BAhT
X-Proofpoint-ORIG-GUID: uR4AxiaHDVPjI69kLf3rpWgJB9ZbXfoO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_04,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxlogscore=999 spamscore=0 phishscore=0 adultscore=0
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180103
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/17/22 17:25, Pierre Morel wrote:
> 
> 
> On 1/14/22 21:31, Matthew Rosato wrote:
>> This structure will be used to carry kvm passthrough information 
>> related to
>> zPCI devices.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/kvm_pci.h | 29 +++++++++++++++++++++
>>   arch/s390/include/asm/pci.h     |  3 +++
>>   arch/s390/kvm/Makefile          |  2 +-
>>   arch/s390/kvm/pci.c             | 46 +++++++++++++++++++++++++++++++++
>>   4 files changed, 79 insertions(+), 1 deletion(-)
>>   create mode 100644 arch/s390/include/asm/kvm_pci.h
>>   create mode 100644 arch/s390/kvm/pci.c
>>
>> diff --git a/arch/s390/include/asm/kvm_pci.h 
>> b/arch/s390/include/asm/kvm_pci.h
>> new file mode 100644
>> index 000000000000..aafee2976929
>> --- /dev/null
>> +++ b/arch/s390/include/asm/kvm_pci.h
>> @@ -0,0 +1,29 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * KVM PCI Passthrough for virtual machines on s390
>> + *
>> + * Copyright IBM Corp. 2021
>> + *
>> + *    Author(s): Matthew Rosato <mjrosato@linux.ibm.com>
>> + */
>> +
>> +
> 
> One blank line too much.
> 
> Otherwise, look good to me.
> 
> Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
> 
>> +#ifndef ASM_KVM_PCI_H
>> +#define ASM_KVM_PCI_H
>> +
>> +#include <linux/types.h>
>> +#include <linux/kvm_types.h>
>> +#include <linux/kvm_host.h>
>> +#include <linux/kvm.h>
>> +#include <linux/pci.h>
>> +
>> +struct kvm_zdev {
>> +    struct zpci_dev *zdev;
>> +    struct kvm *kvm;
>> +};
>> +
>> +int kvm_s390_pci_dev_open(struct zpci_dev *zdev);
>> +void kvm_s390_pci_dev_release(struct zpci_dev *zdev);
>> +void kvm_s390_pci_attach_kvm(struct zpci_dev *zdev, struct kvm *kvm);
>> +
>> +#endif /* ASM_KVM_PCI_H */
>> diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
>> index f3cd2da8128c..9b6c657d8d31 100644
>> --- a/arch/s390/include/asm/pci.h
>> +++ b/arch/s390/include/asm/pci.h
>> @@ -97,6 +97,7 @@ struct zpci_bar_struct {
>>   };
>>   struct s390_domain;
>> +struct kvm_zdev;
>>   #define ZPCI_FUNCTIONS_PER_BUS 256
>>   struct zpci_bus {
>> @@ -190,6 +191,8 @@ struct zpci_dev {
>>       struct dentry    *debugfs_dev;
>>       struct s390_domain *s390_domain; /* s390 IOMMU domain data */
>> +
>> +    struct kvm_zdev *kzdev; /* passthrough data */
>>   };
>>   static inline bool zdev_enabled(struct zpci_dev *zdev)
>> diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
>> index b3aaadc60ead..a26f4fe7b680 100644
>> --- a/arch/s390/kvm/Makefile
>> +++ b/arch/s390/kvm/Makefile
>> @@ -11,5 +11,5 @@ ccflags-y := -Ivirt/kvm -Iarch/s390/kvm
>>   kvm-objs := $(common-objs) kvm-s390.o intercept.o interrupt.o priv.o 
>> sigp.o
>>   kvm-objs += diag.o gaccess.o guestdbg.o vsie.o pv.o
>> -
>> +kvm-$(CONFIG_PCI) += pci.o
>>   obj-$(CONFIG_KVM) += kvm.o
>> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
>> new file mode 100644
>> index 000000000000..1c33bc7bf2bd
>> --- /dev/null
>> +++ b/arch/s390/kvm/pci.c
>> @@ -0,0 +1,46 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * s390 kvm PCI passthrough support
>> + *
>> + * Copyright IBM Corp. 2021
>> + *
>> + *    Author(s): Matthew Rosato <mjrosato@linux.ibm.com>
>> + */
>> +
>> +#include <linux/kvm_host.h>
>> +#include <linux/pci.h>
>> +#include <asm/kvm_pci.h>
>> +
>> +int kvm_s390_pci_dev_open(struct zpci_dev *zdev)
>> +{
>> +    struct kvm_zdev *kzdev;
>> +
>> +    kzdev = kzalloc(sizeof(struct kvm_zdev), GFP_KERNEL);
>> +    if (!kzdev)
>> +        return -ENOMEM;
>> +
>> +    kzdev->zdev = zdev;
>> +    zdev->kzdev = kzdev;
>> +
>> +    return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(kvm_s390_pci_dev_open);
>> +
>> +void kvm_s390_pci_dev_release(struct zpci_dev *zdev)
>> +{
>> +    struct kvm_zdev *kzdev;
>> +
>> +    kzdev = zdev->kzdev;
>> +    WARN_ON(kzdev->zdev != zdev);
>> +    zdev->kzdev = 0;
>> +    kfree(kzdev);
>> +}
>> +EXPORT_SYMBOL_GPL(kvm_s390_pci_dev_release);
>> +
>> +void kvm_s390_pci_attach_kvm(struct zpci_dev *zdev, struct kvm *kvm)
>> +{
>> +    struct kvm_zdev *kzdev = zdev->kzdev;
>> +
>> +    kzdev->kvm = kvm;
>> +}
>> +EXPORT_SYMBOL_GPL(kvm_s390_pci_attach_kvm);
>>
> 

Working now on patch 24, I am not sure that this function is necessary.
the only purpose seems to set kzdev->kvm = kvm while we already know 
kzdev in the caller.



-- 
Pierre Morel
IBM Lab Boeblingen
