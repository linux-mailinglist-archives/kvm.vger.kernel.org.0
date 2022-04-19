Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFC7F506659
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 09:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349603AbiDSHzd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 03:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349656AbiDSHza (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 03:55:30 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7324733355;
        Tue, 19 Apr 2022 00:52:37 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23J65ULh020922;
        Tue, 19 Apr 2022 07:52:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3NJX3fxwHy42fijIDZ0EQ+IlMYgeMtaKWgmaLwA0axI=;
 b=tZ64Q0+fau85GWrQDsEuGK09jp3nEU/VCjFTi0p9dfjfDZMVbDiDdwej2ORakI6jX8q4
 AbD9iAY39fbFL2178M96vWnh00NOhGtvc08xrEZdEO90l3U6RyB4wkKZc77cffv0mUUP
 Z2KLeR9lU0Ak1g5Y43NOxQQ/djdXHZwSdWqxOs8MlmhiZ7Z1RBXleO6dyU4eq57cDZeQ
 QKGk+iZKJMfUWqyYitpmOQWPh0Rk2d6Y/33FEZzXSrJckZ+rcd+FMRZy+S9LNwdg6CvY
 tsLmVI6CHCEcpRcl7TujqDVuBFYF5XFFHJIYOjXps9Vvrw5md0WEvN8Ace/wromG9moM xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fg7ekrx6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Apr 2022 07:52:35 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23J7b8mc006108;
        Tue, 19 Apr 2022 07:52:35 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fg7ekrx5k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Apr 2022 07:52:35 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23J7l6cH026712;
        Tue, 19 Apr 2022 07:52:33 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3ffne8kvxc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Apr 2022 07:52:33 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23J7djvv46399842
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 07:39:45 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0CC4042045;
        Tue, 19 Apr 2022 07:52:30 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 626004203F;
        Tue, 19 Apr 2022 07:52:28 +0000 (GMT)
Received: from [9.171.88.57] (unknown [9.171.88.57])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 Apr 2022 07:52:28 +0000 (GMT)
Message-ID: <4cf23453-e00a-c2e2-aeb1-4030e16d6d17@linux.ibm.com>
Date:   Tue, 19 Apr 2022 09:55:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v5 10/21] KVM: s390: pci: add basic kvm_zdev structure
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220404174349.58530-1-mjrosato@linux.ibm.com>
 <20220404174349.58530-11-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220404174349.58530-11-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: whuwc8zQR5Os_OIlNrUKEKV8ErpHGwFN
X-Proofpoint-GUID: JiyIKgXHGrZfYeHA4c9qY2cwhm3ds2dH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-19_02,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 mlxscore=0 bulkscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 impostorscore=0 phishscore=0 suspectscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204190040
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/4/22 19:43, Matthew Rosato wrote:
> This structure will be used to carry kvm passthrough information related to
> zPCI devices.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>


Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>

> ---
>   arch/s390/include/asm/pci.h |  3 +++
>   arch/s390/kvm/Makefile      |  1 +
>   arch/s390/kvm/pci.c         | 38 +++++++++++++++++++++++++++++++++++++
>   arch/s390/kvm/pci.h         | 21 ++++++++++++++++++++
>   4 files changed, 63 insertions(+)
>   create mode 100644 arch/s390/kvm/pci.c
>   create mode 100644 arch/s390/kvm/pci.h
> 
> diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
> index 4c5b8fbc2079..9eb20cebaa18 100644
> --- a/arch/s390/include/asm/pci.h
> +++ b/arch/s390/include/asm/pci.h
> @@ -97,6 +97,7 @@ struct zpci_bar_struct {
>   };
>   
>   struct s390_domain;
> +struct kvm_zdev;
>   
>   #define ZPCI_FUNCTIONS_PER_BUS 256
>   struct zpci_bus {
> @@ -190,6 +191,8 @@ struct zpci_dev {
>   	struct dentry	*debugfs_dev;
>   
>   	struct s390_domain *s390_domain; /* s390 IOMMU domain data */
> +
> +	struct kvm_zdev *kzdev; /* passthrough data */
>   };
>   
>   static inline bool zdev_enabled(struct zpci_dev *zdev)
> diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
> index 26f4a74e5ce4..00cf6853d93f 100644
> --- a/arch/s390/kvm/Makefile
> +++ b/arch/s390/kvm/Makefile
> @@ -10,4 +10,5 @@ ccflags-y := -Ivirt/kvm -Iarch/s390/kvm
>   kvm-y += kvm-s390.o intercept.o interrupt.o priv.o sigp.o
>   kvm-y += diag.o gaccess.o guestdbg.o vsie.o pv.o
>   
> +kvm-$(CONFIG_PCI) += pci.o
>   obj-$(CONFIG_KVM) += kvm.o
> diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
> new file mode 100644
> index 000000000000..213be236c05a
> --- /dev/null
> +++ b/arch/s390/kvm/pci.c
> @@ -0,0 +1,38 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * s390 kvm PCI passthrough support
> + *
> + * Copyright IBM Corp. 2022
> + *
> + *    Author(s): Matthew Rosato <mjrosato@linux.ibm.com>
> + */
> +
> +#include <linux/kvm_host.h>
> +#include <linux/pci.h>
> +#include "pci.h"
> +
> +int kvm_s390_pci_dev_open(struct zpci_dev *zdev)
> +{
> +	struct kvm_zdev *kzdev;
> +
> +	kzdev = kzalloc(sizeof(struct kvm_zdev), GFP_KERNEL);
> +	if (!kzdev)
> +		return -ENOMEM;
> +
> +	kzdev->zdev = zdev;
> +	zdev->kzdev = kzdev;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(kvm_s390_pci_dev_open);
> +
> +void kvm_s390_pci_dev_release(struct zpci_dev *zdev)
> +{
> +	struct kvm_zdev *kzdev;
> +
> +	kzdev = zdev->kzdev;
> +	WARN_ON(kzdev->zdev != zdev);
> +	zdev->kzdev = 0;
> +	kfree(kzdev);
> +}
> +EXPORT_SYMBOL_GPL(kvm_s390_pci_dev_release);
> diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
> new file mode 100644
> index 000000000000..ce93978e8913
> --- /dev/null
> +++ b/arch/s390/kvm/pci.h
> @@ -0,0 +1,21 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * s390 kvm PCI passthrough support
> + *
> + * Copyright IBM Corp. 2022
> + *
> + *    Author(s): Matthew Rosato <mjrosato@linux.ibm.com>
> + */
> +
> +#ifndef __KVM_S390_PCI_H
> +#define __KVM_S390_PCI_H
> +
> +#include <linux/kvm_host.h>
> +#include <linux/pci.h>
> +
> +struct kvm_zdev {
> +	struct zpci_dev *zdev;
> +	struct kvm *kvm;
> +};
> +
> +#endif /* __KVM_S390_PCI_H */
> 

-- 
Pierre Morel
IBM Lab Boeblingen
