Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBF81CC85
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 18:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbfENQJI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 12:09:08 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:52846 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfENQJI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 12:09:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1557850146; x=1589386146;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:mime-version:
   content-transfer-encoding;
  bh=plFXiYh0xL6L4GZRf8G+HDY7MbdFYndRHWvRX7zth/w=;
  b=ZBiTgtcSutWm4WZq0zTbkOwSaN4geL/hEhvYq6dspPnOV3Xc/OtTP8Oj
   pFGvBuO2BJ6SPY4u4cIWAKOr+ydJuZfbuFBx3bUhEVWdRunzA8bXLvCiX
   3GwbkHQEC2Qh+K4cmXU4H9fKZ0P0INV+8/jl+cODcWyAq0HgK89v2VDU4
   s=;
X-IronPort-AV: E=Sophos;i="5.60,469,1549929600"; 
   d="scan'208";a="402102493"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 14 May 2019 16:09:04 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com (8.14.7/8.14.7) with ESMTP id x4EG8wr5099411
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 14 May 2019 16:09:03 GMT
Received: from EX13D02EUC004.ant.amazon.com (10.43.164.117) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 14 May 2019 16:09:03 +0000
Received: from EX13D02EUC001.ant.amazon.com (10.43.164.92) by
 EX13D02EUC004.ant.amazon.com (10.43.164.117) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 14 May 2019 16:09:02 +0000
Received: from EX13D02EUC001.ant.amazon.com ([10.43.164.92]) by
 EX13D02EUC001.ant.amazon.com ([10.43.164.92]) with mapi id 15.00.1367.000;
 Tue, 14 May 2019 16:09:02 +0000
From:   "Sironi, Filippo" <sironi@amazon.de>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
CC:     LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "vasu.srinivasan@oracle.com" <vasu.srinivasan@oracle.com>
Subject: Re: [PATCH v2 1/2] KVM: Start populating /sys/hypervisor with KVM
 entries
Thread-Topic: [PATCH v2 1/2] KVM: Start populating /sys/hypervisor with KVM
 entries
Thread-Index: AQHVCmguTMwTmVyYP0+tMrT8Z/dQMaZqvgUAgAAL5IA=
Date:   Tue, 14 May 2019 16:09:01 +0000
Message-ID: <56DAB9BD-2543-49DA-9886-C9C8F2B814F9@amazon.de>
References: <1539078879-4372-1-git-send-email-sironi@amazon.de>
 <1557847002-23519-1-git-send-email-sironi@amazon.de>
 <1557847002-23519-2-git-send-email-sironi@amazon.de>
 <d03f6be5-d8dc-4389-e14c-295f36a68827@de.ibm.com>
In-Reply-To: <d03f6be5-d8dc-4389-e14c-295f36a68827@de.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.163]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CCC5E4FD52492B49A46973EAD664A3EF@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 14. May 2019, at 17:26, Christian Borntraeger <borntraeger@de.ibm.com>=
 wrote:
> =

> =

> =

> On 14.05.19 17:16, Filippo Sironi wrote:
>> Start populating /sys/hypervisor with KVM entries when we're running on
>> KVM. This is to replicate functionality that's available when we're
>> running on Xen.
>> =

>> Start with /sys/hypervisor/uuid, which users prefer over
>> /sys/devices/virtual/dmi/id/product_uuid as a way to recognize a virtual
>> machine, since it's also available when running on Xen HVM and on Xen PV
>> and, on top of that doesn't require root privileges by default.
>> Let's create arch-specific hooks so that different architectures can
>> provide different implementations.
>> =

>> Signed-off-by: Filippo Sironi <sironi@amazon.de>
>> ---
>> v2:
>> * move the retrieval of the VM UUID out of uuid_show and into
>>  kvm_para_get_uuid, which is a weak function that can be overwritten
>> =

>> drivers/Kconfig              |  2 ++
>> drivers/Makefile             |  2 ++
>> drivers/kvm/Kconfig          | 14 ++++++++++++++
>> drivers/kvm/Makefile         |  1 +
>> drivers/kvm/sys-hypervisor.c | 30 ++++++++++++++++++++++++++++++
>> 5 files changed, 49 insertions(+)
>> create mode 100644 drivers/kvm/Kconfig
>> create mode 100644 drivers/kvm/Makefile
>> create mode 100644 drivers/kvm/sys-hypervisor.c
>> =

>> diff --git a/drivers/Kconfig b/drivers/Kconfig
>> index 45f9decb9848..90eb835fe951 100644
>> --- a/drivers/Kconfig
>> +++ b/drivers/Kconfig
>> @@ -146,6 +146,8 @@ source "drivers/hv/Kconfig"
>> =

>> source "drivers/xen/Kconfig"
>> =

>> +source "drivers/kvm/Kconfig"
>> +
>> source "drivers/staging/Kconfig"
>> =

>> source "drivers/platform/Kconfig"
>> diff --git a/drivers/Makefile b/drivers/Makefile
>> index c61cde554340..79cc92a3f6bf 100644
>> --- a/drivers/Makefile
>> +++ b/drivers/Makefile
>> @@ -44,6 +44,8 @@ obj-y				+=3D soc/
>> obj-$(CONFIG_VIRTIO)		+=3D virtio/
>> obj-$(CONFIG_XEN)		+=3D xen/
>> =

>> +obj-$(CONFIG_KVM_GUEST)		+=3D kvm/
>> +
>> # regulators early, since some subsystems rely on them to initialize
>> obj-$(CONFIG_REGULATOR)		+=3D regulator/
>> =

>> diff --git a/drivers/kvm/Kconfig b/drivers/kvm/Kconfig
>> new file mode 100644
>> index 000000000000..3fc041df7c11
>> --- /dev/null
>> +++ b/drivers/kvm/Kconfig
>> @@ -0,0 +1,14 @@
>> +menu "KVM driver support"
>> +        depends on KVM_GUEST
>> +
>> +config KVM_SYS_HYPERVISOR
>> +        bool "Create KVM entries under /sys/hypervisor"
>> +        depends on SYSFS
>> +        select SYS_HYPERVISOR
>> +        default y
>> +        help
>> +          Create KVM entries under /sys/hypervisor (e.g., uuid). When r=
unning
>> +          native or on another hypervisor, /sys/hypervisor may still be
>> +          present, but it will have no KVM entries.
>> +
>> +endmenu
>> diff --git a/drivers/kvm/Makefile b/drivers/kvm/Makefile
>> new file mode 100644
>> index 000000000000..73a43fc994b9
>> --- /dev/null
>> +++ b/drivers/kvm/Makefile
>> @@ -0,0 +1 @@
>> +obj-$(CONFIG_KVM_SYS_HYPERVISOR) +=3D sys-hypervisor.o
>> diff --git a/drivers/kvm/sys-hypervisor.c b/drivers/kvm/sys-hypervisor.c
>> new file mode 100644
>> index 000000000000..43b1d1a09807
>> --- /dev/null
>> +++ b/drivers/kvm/sys-hypervisor.c
>> @@ -0,0 +1,30 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +
>> +#include <asm/kvm_para.h>
>> +
>> +#include <linux/kobject.h>
>> +#include <linux/sysfs.h>
>> +
>> +__weak const char *kvm_para_get_uuid(void)
>> +{
>> +	return NULL;
>> +}
>> +
>> +static ssize_t uuid_show(struct kobject *obj,
>> +			 struct kobj_attribute *attr,
>> +			 char *buf)
>> +{
>> +	const char *uuid =3D kvm_para_get_uuid();
> =

> I would prefer to have kvm_para_get_uuid return a uuid_t
> but char * will probably work out as well.

Let me give this a quick spin.

>> +	return sprintf(buf, "%s\n", uuid);
>> +}
>> +
>> +static struct kobj_attribute uuid =3D __ATTR_RO(uuid);
>> +
>> +static int __init uuid_init(void)
>> +{
>> +	if (!kvm_para_available())
> =

> Isnt kvm_para_available a function that is defined in the context of the =
HOST
> and not of the guest?

No, kvm_para_available is defined in the guest context.
On x86, it checks for the presence of the KVM CPUID leafs.

>> +		return 0;
>> +	return sysfs_create_file(hypervisor_kobj, &uuid.attr);
>> +}
>> +
>> +device_initcall(uuid_init);




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrer: Christian Schlaeger, Ralf Herbrich
Ust-ID: DE 289 237 879
Eingetragen am Amtsgericht Charlottenburg HRB 149173 B


