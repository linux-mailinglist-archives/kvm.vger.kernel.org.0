Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 642EB49C540
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 09:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238456AbiAZI3N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 03:29:13 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:2176 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238420AbiAZI3N (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Jan 2022 03:29:13 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20Q7gEjX011988;
        Wed, 26 Jan 2022 08:29:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=4O1LaYBtBVXXFfGMFvzbd33V2xh8PK+DDgbSDlxs7Gk=;
 b=BdINqNs1l8zRqShM4YbVbhKxiTItX3O+ogHZYq6DaLCjHn1xLR96olx/CcDoLWJrkSbr
 Y6P+Ws0dlqGRQAcO7brHfEEPwkKLA6rqcFH37RCPFDilHFJDKozb81vWinXQ6K0eDlQr
 /+CrbotsBCFzdKaXTcLIpYE5I3ROJNKfGdtempuK2ZGTpS8ArKqG4/wDhkSdkysPU/Ml
 IjJ8z/pU4VPyMORPSxH9ma5CTLDfx+Lrjvzc1JFIPZBlur6eDoQBHflEIxa8zos2Uzwq
 ezqb5MhkzeANsaICw7zCOn6c5KeqmS5imAM9CK4FhhWewaIyNyYP+qT2Nr+xnv0l64tI zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3du24xrtf2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jan 2022 08:29:12 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20Q7he43014250;
        Wed, 26 Jan 2022 08:29:11 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3du24xrteq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jan 2022 08:29:11 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20Q8Rndu028204;
        Wed, 26 Jan 2022 08:29:10 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3dr9j9c8sm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jan 2022 08:29:09 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20Q8T5Ge24183142
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jan 2022 08:29:05 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7363DAE04D;
        Wed, 26 Jan 2022 08:29:05 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C9DDAE056;
        Wed, 26 Jan 2022 08:29:04 +0000 (GMT)
Received: from [9.171.51.88] (unknown [9.171.51.88])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 Jan 2022 08:29:04 +0000 (GMT)
Message-ID: <6fe34d89-5e38-86ef-ded1-cc1463c95294@linux.ibm.com>
Date:   Wed, 26 Jan 2022 09:30:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2 20/30] KVM: s390: pci: provide routines for
 enabling/disabling IOAT assist
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
 <20220114203145.242984-21-mjrosato@linux.ibm.com>
 <12b9fba1-38b4-057d-49f4-969f2e7e1be3@linux.ibm.com>
 <5de7c3ef-9c25-56d3-cc46-e002f8742dbe@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <5de7c3ef-9c25-56d3-cc46-e002f8742dbe@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: htvxpfVF0lNJ49hP64-XMALOR51Q5SP4
X-Proofpoint-ORIG-GUID: EaM53XzZk5eumS5dYsnFCXy-mrvXAU_W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-26_02,2022-01-25_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0
 clxscore=1015 impostorscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201260044
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/25/22 15:47, Matthew Rosato wrote:
> On 1/25/22 8:29 AM, Pierre Morel wrote:
>>
>>
>> On 1/14/22 21:31, Matthew Rosato wrote:
>>> These routines will be wired into the vfio_pci_zdev ioctl handlers to
>>> respond to requests to enable / disable a device for PCI I/O Address
>>> Translation assistance.
>>>
>>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>> ---
>>>   arch/s390/include/asm/kvm_pci.h |  15 ++++
>>>   arch/s390/include/asm/pci_dma.h |   2 +
>>>   arch/s390/kvm/pci.c             | 139 ++++++++++++++++++++++++++++++++
>>>   arch/s390/kvm/pci.h             |   2 +
>>>   4 files changed, 158 insertions(+)
>>>
>>> diff --git a/arch/s390/include/asm/kvm_pci.h 
>>> b/arch/s390/include/asm/kvm_pci.h
>>> index 01fe14fffd7a..770849f13a70 100644
>>> --- a/arch/s390/include/asm/kvm_pci.h
>>> +++ b/arch/s390/include/asm/kvm_pci.h
>>> @@ -16,11 +16,21 @@
>>>   #include <linux/kvm_host.h>
>>>   #include <linux/kvm.h>
>>>   #include <linux/pci.h>
>>> +#include <linux/mutex.h>
>>>   #include <asm/pci_insn.h>
>>> +#include <asm/pci_dma.h>
>>> +
>>> +struct kvm_zdev_ioat {
>>> +    unsigned long *head[ZPCI_TABLE_PAGES];
>>> +    unsigned long **seg;
>>> +    unsigned long ***pt;
>>> +    struct mutex lock;
>>
>> Can we please rename the mutex ioat_lock to have a unique name easy to 
>> follow for maintenance.
>> Can you please add a description about when the lock should be used?
>>
> 
> OK.  The lock is meant to protect the contents of kvm_zdev_ioat -- I'll 
> think of something to describe it.
> 
>>> +};
>>>   struct kvm_zdev {
>>>       struct zpci_dev *zdev;
>>>       struct kvm *kvm;
>>> +    struct kvm_zdev_ioat ioat;
>>>       struct zpci_fib fib;
>>>   };
>>> @@ -33,6 +43,11 @@ int kvm_s390_pci_aif_enable(struct zpci_dev *zdev, 
>>> struct zpci_fib *fib,
>>>                   bool assist);
>>>   int kvm_s390_pci_aif_disable(struct zpci_dev *zdev);
>>> +int kvm_s390_pci_ioat_probe(struct zpci_dev *zdev);
>>> +int kvm_s390_pci_ioat_enable(struct zpci_dev *zdev, u64 iota);
>>> +int kvm_s390_pci_ioat_disable(struct zpci_dev *zdev);
>>> +u8 kvm_s390_pci_get_dtsm(struct zpci_dev *zdev);
>>> +
>>>   int kvm_s390_pci_interp_probe(struct zpci_dev *zdev);
>>>   int kvm_s390_pci_interp_enable(struct zpci_dev *zdev);
>>>   int kvm_s390_pci_interp_disable(struct zpci_dev *zdev);
>>> diff --git a/arch/s390/include/asm/pci_dma.h 
>>> b/arch/s390/include/asm/pci_dma.h
>>> index 91e63426bdc5..69e616d0712c 100644
>>> --- a/arch/s390/include/asm/pci_dma.h
>>> +++ b/arch/s390/include/asm/pci_dma.h
>>> @@ -50,6 +50,8 @@ enum zpci_ioat_dtype {
>>>   #define ZPCI_TABLE_ALIGN        ZPCI_TABLE_SIZE
>>>   #define ZPCI_TABLE_ENTRY_SIZE        (sizeof(unsigned long))
>>>   #define ZPCI_TABLE_ENTRIES        (ZPCI_TABLE_SIZE / 
>>> ZPCI_TABLE_ENTRY_SIZE)
>>> +#define ZPCI_TABLE_PAGES        (ZPCI_TABLE_SIZE >> PAGE_SHIFT)
>>> +#define ZPCI_TABLE_ENTRIES_PAGES    (ZPCI_TABLE_ENTRIES * 
>>> ZPCI_TABLE_PAGES)
>>>   #define ZPCI_TABLE_BITS            11
>>>   #define ZPCI_PT_BITS            8
>>> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
>>> index 7ed9abc476b6..39c13c25a700 100644
>>> --- a/arch/s390/kvm/pci.c
>>> +++ b/arch/s390/kvm/pci.c
>>> @@ -13,12 +13,15 @@
>>>   #include <asm/pci.h>
>>>   #include <asm/pci_insn.h>
>>>   #include <asm/pci_io.h>
>>> +#include <asm/pci_dma.h>
>>>   #include <asm/sclp.h>
>>>   #include "pci.h"
>>>   #include "kvm-s390.h"
>>>   struct zpci_aift *aift;
>>> +#define shadow_ioat_init zdev->kzdev->ioat.head[0]
>>> +
>>>   static inline int __set_irq_noiib(u16 ctl, u8 isc)
>>>   {
>>>       union zpci_sic_iib iib = {{0}};
>>> @@ -344,6 +347,135 @@ int kvm_s390_pci_aif_disable(struct zpci_dev 
>>> *zdev)
>>>   }
>>>   EXPORT_SYMBOL_GPL(kvm_s390_pci_aif_disable);
>>> +int kvm_s390_pci_ioat_probe(struct zpci_dev *zdev)
>>> +{
>>> +    /* Must have a KVM association registered */
>>
>> may be add something like : "The ioat structure is embeded in kzdev"
>>
>>> +    if (!zdev->kzdev || !zdev->kzdev->kvm)
>>
>> Why do we need to check for kvm ?
>> Having kzdev is already tested by the unique caller.
>>
> 
> We probably don't need to check for the kzdev because the caller already 
> did this, agreed there.
> 
> But as for checking the kvm association, Alex asked for this in a 
> comment to v1 (comment was against one of the vfio patches that call 
> these routines) -- The reason being the probe comes from a userspace 
> request and can be against any vfio-pci(-zdev) device at any time, and 
> there's no point in proceeding if this device is not associated with a 
> KVM guest -- It's possible for the KVM notifier to also pass a null KVM 
> address -- so I think it's better to just be sure here.  In a 
> well-behaved environment we would never see this (so, another case for 
> an s390dbf entry)

I thought the check could be done even if the userspace is not 
associated with KVM. But of course OK if Alex asked I would have missed 
some point.



-- 
Pierre Morel
IBM Lab Boeblingen
