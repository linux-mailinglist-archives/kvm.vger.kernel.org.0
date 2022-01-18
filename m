Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE53492D8B
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 19:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348010AbiARSj7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 13:39:59 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58336 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233142AbiARSj6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 13:39:58 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20IIRJng021149;
        Tue, 18 Jan 2022 18:39:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Rs2al6LS+eqYTKg9jzmsQkX16EoAs2C/zzCF8/DEQTc=;
 b=PNUrTXfEHVgvSVNDENuyDnnUVyw0Z2GcNGyC8Vzm/RNQhDFYupcvzDaU+8+t3mO0/kkg
 UiwwS66CAAvPMVTLjSEkyrh16RSBSrFvsfstdMD9/My368nITtlDr0pSOBuxJAb7fKKA
 G1egqZOjoOpnN/2AALF59w1PKWPFV3boT1CpXE4focGLkBfCrSqqAQWMrJziVeyfDwWf
 LEnHjo5v2XrVV2AqHnk9sYOJLJ9WJumD398D/5oT9VE0pXBN25pLBYwz1pBBmQnGp+Fz
 moaWE5lVIybNtQCrdy9mHHx700W3IyQa9KzFA8uwSRMJ1xLCjM6Ws4+TmkELoMteKXtw /Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dp2uh0esn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 18:39:57 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20IIRatJ022028;
        Tue, 18 Jan 2022 18:39:57 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dp2uh0esb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 18:39:57 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20IIbBcK032228;
        Tue, 18 Jan 2022 18:39:56 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma03dal.us.ibm.com with ESMTP id 3dknwc57yn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 18:39:56 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20IIdsJ722479156
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 18:39:54 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C64466E04E;
        Tue, 18 Jan 2022 18:39:54 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B50A96E053;
        Tue, 18 Jan 2022 18:39:52 +0000 (GMT)
Received: from [9.163.19.30] (unknown [9.163.19.30])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 18:39:52 +0000 (GMT)
Message-ID: <03cc0e2b-13df-02b3-f6d6-0bef3e9e64a7@linux.ibm.com>
Date:   Tue, 18 Jan 2022 13:39:52 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 14/30] KVM: s390: pci: add basic kvm_zdev structure
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
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
 <4d181623-24b5-980d-d78f-36472a622538@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <4d181623-24b5-980d-d78f-36472a622538@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: TyePBEiAxcduLqWnRXuB6a9eLGJSHsY_
X-Proofpoint-GUID: zwZzuN1M4ydZqKlcEAOT471U40VAQKRa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_05,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 mlxscore=0
 spamscore=0 impostorscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180112
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/18/22 12:32 PM, Pierre Morel wrote:
> 
> 
> On 1/17/22 17:25, Pierre Morel wrote:
>>
>>
>> On 1/14/22 21:31, Matthew Rosato wrote:
>>> This structure will be used to carry kvm passthrough information 
>>> related to
>>> zPCI devices.
>>>
>>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>> ---
>>>   arch/s390/include/asm/kvm_pci.h | 29 +++++++++++++++++++++
>>>   arch/s390/include/asm/pci.h     |  3 +++
>>>   arch/s390/kvm/Makefile          |  2 +-
>>>   arch/s390/kvm/pci.c             | 46 +++++++++++++++++++++++++++++++++
>>>   4 files changed, 79 insertions(+), 1 deletion(-)
>>>   create mode 100644 arch/s390/include/asm/kvm_pci.h
>>>   create mode 100644 arch/s390/kvm/pci.c
>>>
>>> diff --git a/arch/s390/include/asm/kvm_pci.h 
>>> b/arch/s390/include/asm/kvm_pci.h
>>> new file mode 100644
>>> index 000000000000..aafee2976929
>>> --- /dev/null
>>> +++ b/arch/s390/include/asm/kvm_pci.h
>>> @@ -0,0 +1,29 @@
>>> +/* SPDX-License-Identifier: GPL-2.0 */
>>> +/*
>>> + * KVM PCI Passthrough for virtual machines on s390
>>> + *
>>> + * Copyright IBM Corp. 2021
>>> + *
>>> + *    Author(s): Matthew Rosato <mjrosato@linux.ibm.com>
>>> + */
>>> +
>>> +
>>
>> One blank line too much.
>>
>> Otherwise, look good to me.
>>
>> Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
>>
>>> +#ifndef ASM_KVM_PCI_H
>>> +#define ASM_KVM_PCI_H
>>> +
>>> +#include <linux/types.h>
>>> +#include <linux/kvm_types.h>
>>> +#include <linux/kvm_host.h>
>>> +#include <linux/kvm.h>
>>> +#include <linux/pci.h>
>>> +
>>> +struct kvm_zdev {
>>> +    struct zpci_dev *zdev;
>>> +    struct kvm *kvm;
>>> +};
>>> +
>>> +int kvm_s390_pci_dev_open(struct zpci_dev *zdev);
>>> +void kvm_s390_pci_dev_release(struct zpci_dev *zdev);
>>> +void kvm_s390_pci_attach_kvm(struct zpci_dev *zdev, struct kvm *kvm);
>>> +
>>> +#endif /* ASM_KVM_PCI_H */
>>> diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
>>> index f3cd2da8128c..9b6c657d8d31 100644
>>> --- a/arch/s390/include/asm/pci.h
>>> +++ b/arch/s390/include/asm/pci.h
>>> @@ -97,6 +97,7 @@ struct zpci_bar_struct {
>>>   };
>>>   struct s390_domain;
>>> +struct kvm_zdev;
>>>   #define ZPCI_FUNCTIONS_PER_BUS 256
>>>   struct zpci_bus {
>>> @@ -190,6 +191,8 @@ struct zpci_dev {
>>>       struct dentry    *debugfs_dev;
>>>       struct s390_domain *s390_domain; /* s390 IOMMU domain data */
>>> +
>>> +    struct kvm_zdev *kzdev; /* passthrough data */
>>>   };
>>>   static inline bool zdev_enabled(struct zpci_dev *zdev)
>>> diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
>>> index b3aaadc60ead..a26f4fe7b680 100644
>>> --- a/arch/s390/kvm/Makefile
>>> +++ b/arch/s390/kvm/Makefile
>>> @@ -11,5 +11,5 @@ ccflags-y := -Ivirt/kvm -Iarch/s390/kvm
>>>   kvm-objs := $(common-objs) kvm-s390.o intercept.o interrupt.o 
>>> priv.o sigp.o
>>>   kvm-objs += diag.o gaccess.o guestdbg.o vsie.o pv.o
>>> -
>>> +kvm-$(CONFIG_PCI) += pci.o

As discussed in other threads, I will look at changing this to
kvm-$(CONFIG_VFIO_PCI_ZDEV) += pci.o
Along with other IS_ENABLE(CONFIG_PCI) -> 
IS_ENABLED(CONFIG_VFIO_PCI_ZDDEV) changes

>>>   obj-$(CONFIG_KVM) += kvm.o
>>> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
>>> new file mode 100644
>>> index 000000000000..1c33bc7bf2bd
>>> --- /dev/null
>>> +++ b/arch/s390/kvm/pci.c
>>> @@ -0,0 +1,46 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +/*
>>> + * s390 kvm PCI passthrough support
>>> + *
>>> + * Copyright IBM Corp. 2021
>>> + *
>>> + *    Author(s): Matthew Rosato <mjrosato@linux.ibm.com>
>>> + */
>>> +
>>> +#include <linux/kvm_host.h>
>>> +#include <linux/pci.h>
>>> +#include <asm/kvm_pci.h>
>>> +
>>> +int kvm_s390_pci_dev_open(struct zpci_dev *zdev)
>>> +{
>>> +    struct kvm_zdev *kzdev;
>>> +
>>> +    kzdev = kzalloc(sizeof(struct kvm_zdev), GFP_KERNEL);
>>> +    if (!kzdev)
>>> +        return -ENOMEM;
>>> +
>>> +    kzdev->zdev = zdev;
>>> +    zdev->kzdev = kzdev;
>>> +
>>> +    return 0;
>>> +}
>>> +EXPORT_SYMBOL_GPL(kvm_s390_pci_dev_open);
>>> +
>>> +void kvm_s390_pci_dev_release(struct zpci_dev *zdev)
>>> +{
>>> +    struct kvm_zdev *kzdev;
>>> +
>>> +    kzdev = zdev->kzdev;
>>> +    WARN_ON(kzdev->zdev != zdev);
>>> +    zdev->kzdev = 0;
>>> +    kfree(kzdev);
>>> +}
>>> +EXPORT_SYMBOL_GPL(kvm_s390_pci_dev_release);
>>> +
>>> +void kvm_s390_pci_attach_kvm(struct zpci_dev *zdev, struct kvm *kvm)
>>> +{
>>> +    struct kvm_zdev *kzdev = zdev->kzdev;
>>> +
>>> +    kzdev->kvm = kvm;
>>> +}
>>> +EXPORT_SYMBOL_GPL(kvm_s390_pci_attach_kvm);
>>>
>>
> 
> Working now on patch 24, I am not sure that this function is necessary.
> the only purpose seems to set kzdev->kvm = kvm while we already know 
> kzdev in the caller.
> 

Yep, as mentioned in the patch 24 thread I will drop this function and 
set kzdev->kvm = kvm directly in patch 24.

