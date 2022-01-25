Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2DA49B71A
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 16:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389699AbiAYPAi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 10:00:38 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3900 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1581111AbiAYO51 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Jan 2022 09:57:27 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20PElpep016074;
        Tue, 25 Jan 2022 14:57:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Nf3VGbuEa9NgDLjSbsvh58gLX9qjCGzfLwEMH/artt4=;
 b=QIOD+RwLSNZCcyR1DLNcQVs4qBiKcD4bF4E+FGB86CF34WzfUtRsfOQGTW9prqT5J4bi
 QW6o/FKQ2MhiA58XdjsjbEyLRQRNmXqfE9onu5y6HfGMnQ1C0GpYMowz0yilk/q4YvWl
 5PhOTb9ruVXRAZC/5J3JMt7RQJAONLcDnK3ji+Mc1k3cC//AZeZhjtBaThv5JByF7G+Q
 IfVXa7q1iz97hVEJ5oECvcKQhheWgPsv6k3XDKW5l7KymA6uZeCdhmHQMhLh0gPz7Uov
 EvQkvNPpRbcKlWD5AUXuO/KO+Xc6RRe2nArpTTV3Y4RxeruZbHCJ9M8i3SEnmVT0Uuah jA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dtk9h86mx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 14:57:21 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20PEvLhn010292;
        Tue, 25 Jan 2022 14:57:21 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dtk9h86mg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 14:57:21 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20PEv1e9017165;
        Tue, 25 Jan 2022 14:57:20 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma02dal.us.ibm.com with ESMTP id 3dt1x9e6tc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 14:57:20 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20PEvIRG23003470
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jan 2022 14:57:18 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE8AEC606E;
        Tue, 25 Jan 2022 14:57:18 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E8241C6067;
        Tue, 25 Jan 2022 14:57:16 +0000 (GMT)
Received: from [9.163.21.206] (unknown [9.163.21.206])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 25 Jan 2022 14:57:16 +0000 (GMT)
Message-ID: <2d9c8cd8-94cf-a1aa-e5e9-d25f607b0b67@linux.ibm.com>
Date:   Tue, 25 Jan 2022 09:57:16 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 15/30] KVM: s390: pci: do initial setup for AEN
 interpretation
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
 <20220114203145.242984-16-mjrosato@linux.ibm.com>
 <9df849f6-dd99-93ea-8e35-3daffd38e694@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <9df849f6-dd99-93ea-8e35-3daffd38e694@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MSQrLXi2GrqVvHFcDLOY20_s4TOyKrA7
X-Proofpoint-GUID: nUSSeGzWLQ0nC3Ff0GZT5tPGmmMt9wrM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_02,2022-01-25_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 phishscore=0 bulkscore=0 adultscore=0 clxscore=1015 malwarescore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201250094
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/25/22 7:23 AM, Pierre Morel wrote:
> 
> 
> On 1/14/22 21:31, Matthew Rosato wrote:
>> Initial setup for Adapter Event Notification Interpretation for zPCI
>> passthrough devices.  Specifically, allocate a structure for 
>> forwarding of
>> adapter events and pass the address of this structure to firmware.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/pci.h      |   4 +
>>   arch/s390/include/asm/pci_insn.h |  12 +++
>>   arch/s390/kvm/interrupt.c        |  14 +++
>>   arch/s390/kvm/kvm-s390.c         |   9 ++
>>   arch/s390/kvm/pci.c              | 144 +++++++++++++++++++++++++++++++
>>   arch/s390/kvm/pci.h              |  42 +++++++++
>>   arch/s390/pci/pci.c              |   6 ++
>>   7 files changed, 231 insertions(+)
>>   create mode 100644 arch/s390/kvm/pci.h
>>
> ...snip...
> 
>> new file mode 100644
>> index 000000000000..b2000ed7b8c3
>> --- /dev/null
>> +++ b/arch/s390/kvm/pci.h
>> @@ -0,0 +1,42 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * s390 kvm PCI passthrough support
>> + *
>> + * Copyright IBM Corp. 2021
>> + *
>> + *    Author(s): Matthew Rosato <mjrosato@linux.ibm.com>
>> + */
>> +
>> +#ifndef __KVM_S390_PCI_H
>> +#define __KVM_S390_PCI_H
>> +
>> +#include <linux/pci.h>
>> +#include <linux/mutex.h>
>> +#include <asm/airq.h>
>> +#include <asm/kvm_pci.h>
>> +
>> +struct zpci_gaite {
>> +    u32 gisa;
>> +    u8 gisc;
>> +    u8 count;
>> +    u8 reserved;
>> +    u8 aisbo;
>> +    u64 aisb;
>> +};
>> +
>> +struct zpci_aift {
>> +    struct zpci_gaite *gait;
>> +    struct airq_iv *sbv;
>> +    struct kvm_zdev **kzdev;
>> +    spinlock_t gait_lock; /* Protects the gait, used during AEN 
>> forward */
>> +    struct mutex lock; /* Protects the other structures in aift */
> 
> To facilitate review and debug, can we please rename the lock aift_lock?
> 
> 

OK, sure

