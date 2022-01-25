Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB6149B3E2
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 13:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382231AbiAYM0C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 07:26:02 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64122 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1448003AbiAYMVk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Jan 2022 07:21:40 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20PCK3Xl009939;
        Tue, 25 Jan 2022 12:21:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=DSC4tF8JBAB/RYcyPBdMDahatWCJeXMwVRaiqjTudKw=;
 b=k3tTxNJUykPlLxHQ4+C5L6F+0fDTKJFiMZX5rdCCPS22AAF2+7Vx73wQZSOYbh3oQBmv
 Z/4ysrk1ufIkXoeGnUs9dxyHfZ1P1hbW78e/S/ylRDOo6nAVNwCm3eevRqUN9jkv+ePk
 1DHbnFmR8zyy8tqhI5zS9MH0NJP7K6ZAv9fK/gRaxmvsohqHXnI/QngnHH7jKZ0+n56V
 NIJDXiRIY3W2m3zGovvt+wRjgvjKKy9opLierbZplYMvEKTqJTKZa+zFJbHPZVG+5JH7
 TfsatcukEY7j5VP+hoZMlUOjhm12LQ+wBls0vxk8yKeDyPOSGXelVfWv1h/IRf3zj0gz Wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dtgj68taa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 12:21:28 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20PCK4UM009982;
        Tue, 25 Jan 2022 12:21:28 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dtgj68t9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 12:21:27 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20PCI6ue015267;
        Tue, 25 Jan 2022 12:21:25 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3dr9j8vhu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 12:21:25 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20PCLLIK40567078
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jan 2022 12:21:21 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 74BBCAE05D;
        Tue, 25 Jan 2022 12:21:21 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8838AAE053;
        Tue, 25 Jan 2022 12:21:20 +0000 (GMT)
Received: from [9.171.58.95] (unknown [9.171.58.95])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Jan 2022 12:21:20 +0000 (GMT)
Message-ID: <9df849f6-dd99-93ea-8e35-3daffd38e694@linux.ibm.com>
Date:   Tue, 25 Jan 2022 13:23:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2 15/30] KVM: s390: pci: do initial setup for AEN
 interpretation
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
 <20220114203145.242984-16-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220114203145.242984-16-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: S5PrdewDgWoiq6HanT2AfCrqJNJX_R9I
X-Proofpoint-GUID: 7nA0Zl6bEdcQ2DuoV6JU8y0LH4XESY5o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_02,2022-01-25_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 spamscore=0 malwarescore=0
 adultscore=0 impostorscore=0 clxscore=1015 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201250078
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/14/22 21:31, Matthew Rosato wrote:
> Initial setup for Adapter Event Notification Interpretation for zPCI
> passthrough devices.  Specifically, allocate a structure for forwarding of
> adapter events and pass the address of this structure to firmware.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   arch/s390/include/asm/pci.h      |   4 +
>   arch/s390/include/asm/pci_insn.h |  12 +++
>   arch/s390/kvm/interrupt.c        |  14 +++
>   arch/s390/kvm/kvm-s390.c         |   9 ++
>   arch/s390/kvm/pci.c              | 144 +++++++++++++++++++++++++++++++
>   arch/s390/kvm/pci.h              |  42 +++++++++
>   arch/s390/pci/pci.c              |   6 ++
>   7 files changed, 231 insertions(+)
>   create mode 100644 arch/s390/kvm/pci.h
> 
...snip...

> new file mode 100644
> index 000000000000..b2000ed7b8c3
> --- /dev/null
> +++ b/arch/s390/kvm/pci.h
> @@ -0,0 +1,42 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * s390 kvm PCI passthrough support
> + *
> + * Copyright IBM Corp. 2021
> + *
> + *    Author(s): Matthew Rosato <mjrosato@linux.ibm.com>
> + */
> +
> +#ifndef __KVM_S390_PCI_H
> +#define __KVM_S390_PCI_H
> +
> +#include <linux/pci.h>
> +#include <linux/mutex.h>
> +#include <asm/airq.h>
> +#include <asm/kvm_pci.h>
> +
> +struct zpci_gaite {
> +	u32 gisa;
> +	u8 gisc;
> +	u8 count;
> +	u8 reserved;
> +	u8 aisbo;
> +	u64 aisb;
> +};
> +
> +struct zpci_aift {
> +	struct zpci_gaite *gait;
> +	struct airq_iv *sbv;
> +	struct kvm_zdev **kzdev;
> +	spinlock_t gait_lock; /* Protects the gait, used during AEN forward */
> +	struct mutex lock; /* Protects the other structures in aift */

To facilitate review and debug, can we please rename the lock aift_lock?


> +};
> +
> +extern struct zpci_aift *aift;
> +
...snip...


-- 
Pierre Morel
IBM Lab Boeblingen
