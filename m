Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9239A1CBD5
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 17:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbfENP0p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 11:26:45 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42228 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726107AbfENP0p (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 May 2019 11:26:45 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4EFHoXn082495
        for <kvm@vger.kernel.org>; Tue, 14 May 2019 11:26:44 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sfytc1pr5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 14 May 2019 11:26:44 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Tue, 14 May 2019 16:26:41 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 14 May 2019 16:26:38 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4EFQbpo37224662
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 May 2019 15:26:37 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4309AA405D;
        Tue, 14 May 2019 15:26:37 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D7558A4053;
        Tue, 14 May 2019 15:26:36 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.148.90])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 May 2019 15:26:36 +0000 (GMT)
Subject: Re: [PATCH v2 1/2] KVM: Start populating /sys/hypervisor with KVM
 entries
To:     Filippo Sironi <sironi@amazon.de>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, boris.ostrovsky@oracle.com, cohuck@redhat.com,
        konrad.wilk@oracle.com, xen-devel@lists.xenproject.org,
        vasu.srinivasan@oracle.com
References: <1539078879-4372-1-git-send-email-sironi@amazon.de>
 <1557847002-23519-1-git-send-email-sironi@amazon.de>
 <1557847002-23519-2-git-send-email-sironi@amazon.de>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=borntraeger@de.ibm.com; prefer-encrypt=mutual; keydata=
 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
 syiRa+UVlsKmx1hsEg==
Date:   Tue, 14 May 2019 17:26:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1557847002-23519-2-git-send-email-sironi@amazon.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19051415-0016-0000-0000-0000027B9D62
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051415-0017-0000-0000-000032D868EB
Message-Id: <d03f6be5-d8dc-4389-e14c-295f36a68827@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-14_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905140108
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 14.05.19 17:16, Filippo Sironi wrote:
> Start populating /sys/hypervisor with KVM entries when we're running on
> KVM. This is to replicate functionality that's available when we're
> running on Xen.
> 
> Start with /sys/hypervisor/uuid, which users prefer over
> /sys/devices/virtual/dmi/id/product_uuid as a way to recognize a virtual
> machine, since it's also available when running on Xen HVM and on Xen PV
> and, on top of that doesn't require root privileges by default.
> Let's create arch-specific hooks so that different architectures can
> provide different implementations.
> 
> Signed-off-by: Filippo Sironi <sironi@amazon.de>
> ---
> v2:
> * move the retrieval of the VM UUID out of uuid_show and into
>   kvm_para_get_uuid, which is a weak function that can be overwritten
> 
>  drivers/Kconfig              |  2 ++
>  drivers/Makefile             |  2 ++
>  drivers/kvm/Kconfig          | 14 ++++++++++++++
>  drivers/kvm/Makefile         |  1 +
>  drivers/kvm/sys-hypervisor.c | 30 ++++++++++++++++++++++++++++++
>  5 files changed, 49 insertions(+)
>  create mode 100644 drivers/kvm/Kconfig
>  create mode 100644 drivers/kvm/Makefile
>  create mode 100644 drivers/kvm/sys-hypervisor.c
> 
> diff --git a/drivers/Kconfig b/drivers/Kconfig
> index 45f9decb9848..90eb835fe951 100644
> --- a/drivers/Kconfig
> +++ b/drivers/Kconfig
> @@ -146,6 +146,8 @@ source "drivers/hv/Kconfig"
>  
>  source "drivers/xen/Kconfig"
>  
> +source "drivers/kvm/Kconfig"
> +
>  source "drivers/staging/Kconfig"
>  
>  source "drivers/platform/Kconfig"
> diff --git a/drivers/Makefile b/drivers/Makefile
> index c61cde554340..79cc92a3f6bf 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -44,6 +44,8 @@ obj-y				+= soc/
>  obj-$(CONFIG_VIRTIO)		+= virtio/
>  obj-$(CONFIG_XEN)		+= xen/
>  
> +obj-$(CONFIG_KVM_GUEST)		+= kvm/
> +
>  # regulators early, since some subsystems rely on them to initialize
>  obj-$(CONFIG_REGULATOR)		+= regulator/
>  
> diff --git a/drivers/kvm/Kconfig b/drivers/kvm/Kconfig
> new file mode 100644
> index 000000000000..3fc041df7c11
> --- /dev/null
> +++ b/drivers/kvm/Kconfig
> @@ -0,0 +1,14 @@
> +menu "KVM driver support"
> +        depends on KVM_GUEST
> +
> +config KVM_SYS_HYPERVISOR
> +        bool "Create KVM entries under /sys/hypervisor"
> +        depends on SYSFS
> +        select SYS_HYPERVISOR
> +        default y
> +        help
> +          Create KVM entries under /sys/hypervisor (e.g., uuid). When running
> +          native or on another hypervisor, /sys/hypervisor may still be
> +          present, but it will have no KVM entries.
> +
> +endmenu
> diff --git a/drivers/kvm/Makefile b/drivers/kvm/Makefile
> new file mode 100644
> index 000000000000..73a43fc994b9
> --- /dev/null
> +++ b/drivers/kvm/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_KVM_SYS_HYPERVISOR) += sys-hypervisor.o
> diff --git a/drivers/kvm/sys-hypervisor.c b/drivers/kvm/sys-hypervisor.c
> new file mode 100644
> index 000000000000..43b1d1a09807
> --- /dev/null
> +++ b/drivers/kvm/sys-hypervisor.c
> @@ -0,0 +1,30 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#include <asm/kvm_para.h>
> +
> +#include <linux/kobject.h>
> +#include <linux/sysfs.h>
> +
> +__weak const char *kvm_para_get_uuid(void)
> +{
> +	return NULL;
> +}
> +
> +static ssize_t uuid_show(struct kobject *obj,
> +			 struct kobj_attribute *attr,
> +			 char *buf)
> +{
> +	const char *uuid = kvm_para_get_uuid();

I would prefer to have kvm_para_get_uuid return a uuid_t
but char * will probably work out as well.


> +	return sprintf(buf, "%s\n", uuid);
> +}
> +
> +static struct kobj_attribute uuid = __ATTR_RO(uuid);
> +
> +static int __init uuid_init(void)
> +{
> +	if (!kvm_para_available())

Isnt kvm_para_available a function that is defined in the context of the HOST
and not of the guest?

> +		return 0;
> +	return sysfs_create_file(hypervisor_kobj, &uuid.attr);
> +}
> +
> +device_initcall(uuid_init);
> 

