Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0882121AD3
	for <lists+kvm@lfdr.de>; Fri, 17 May 2019 17:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729214AbfEQPlq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 May 2019 11:41:46 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:13948 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728861AbfEQPlp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 May 2019 11:41:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1558107704; x=1589643704;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:mime-version:
   content-transfer-encoding;
  bh=5PwOvUa2QeUYezBMIw7pLuLH7aeDi9x8dxh6Bcuj1T0=;
  b=pkPNEBpTfId2pSiHw35G46whRha12mw7LuOjkWbLFW2QpZWK7Pd+iACu
   O9gxMfRMILX+TNuS8NM+T6gt8jmnEgS3RVQZ97Z/RbsbLBTnGrfhWnprs
   fGsVAVV/HQWJ2e/faBWiCUigmoPh2x/kKqHIgD7t1w41Cx5QIu+r9lcCa
   c=;
X-IronPort-AV: E=Sophos;i="5.60,480,1549929600"; 
   d="scan'208";a="402579638"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-57e1d233.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 17 May 2019 15:41:43 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-57e1d233.us-east-1.amazon.com (8.14.7/8.14.7) with ESMTP id x4HFffwv037521
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL);
        Fri, 17 May 2019 15:41:42 GMT
Received: from EX13D02EUC004.ant.amazon.com (10.43.164.117) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 17 May 2019 15:41:41 +0000
Received: from EX13D02EUC001.ant.amazon.com (10.43.164.92) by
 EX13D02EUC004.ant.amazon.com (10.43.164.117) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 17 May 2019 15:41:40 +0000
Received: from EX13D02EUC001.ant.amazon.com ([10.43.164.92]) by
 EX13D02EUC001.ant.amazon.com ([10.43.164.92]) with mapi id 15.00.1367.000;
 Fri, 17 May 2019 15:41:40 +0000
From:   "Sironi, Filippo" <sironi@amazon.de>
To:     "Graf, Alexander" <graf@amazon.com>
CC:     LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Subject: Re: [PATCH v2 1/2] KVM: Start populating /sys/hypervisor with KVM
 entries
Thread-Topic: [PATCH v2 1/2] KVM: Start populating /sys/hypervisor with KVM
 entries
Thread-Index: AQHVCmguTMwTmVyYP0+tMrT8Z/dQMaZtx8qAgAGxboA=
Date:   Fri, 17 May 2019 15:41:39 +0000
Message-ID: <3D2C4EE3-1C2E-4032-9964-31A066E542AA@amazon.de>
References: <1539078879-4372-1-git-send-email-sironi@amazon.de>
 <1557847002-23519-1-git-send-email-sironi@amazon.de>
 <1557847002-23519-2-git-send-email-sironi@amazon.de>
 <e976f31b-2ccd-29ba-6a32-2edde49f867f@amazon.com>
In-Reply-To: <e976f31b-2ccd-29ba-6a32-2edde49f867f@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.155]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <10D2265497ECB941BB8FCEB5614DF2F7@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> On 16. May 2019, at 15:50, Graf, Alexander <graf@amazon.com> wrote:
> =

> On 14.05.19 08:16, Filippo Sironi wrote:
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
> =

> I think this needs something akin to
> =

>  https://www.kernel.org/doc/Documentation/ABI/stable/sysfs-hypervisor-xen
> =

> to document which files are available.
> =

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

> =

> [...]
> =

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
>> +	return sprintf(buf, "%s\n", uuid);
> =

> The usual return value for the Xen /sys/hypervisor interface is
> "<denied>". Wouldn't it make sense to follow that pattern for the KVM
> one too? Currently, if we can not determine the UUID this will just
> return (null).
> =

> Otherwise, looks good to me. Are you aware of any other files we should
> provide? Also, is there any reason not to implement ARM as well while at =
it?
> =

> Alex

This originated from a customer request that was using /sys/hypervisor/uuid.
My guess is that we would want to expose "type" and "version" moving
forward and that's when we hypervisor hooks will be useful on top
of arch hooks.

On a different note, any idea how to check whether the OS is running
virtualized on KVM on ARM and ARM64?  kvm_para_available() isn't an
option and the same is true for S390 where kvm_para_available()
always returns true and it would even if a KVM enabled kernel would
be running on bare metal.

I think we will need another arch hook to call a function that says
whether the OS is running virtualized on KVM.

>> +}
>> +
>> +static struct kobj_attribute uuid =3D __ATTR_RO(uuid);
>> +
>> +static int __init uuid_init(void)
>> +{
>> +	if (!kvm_para_available())
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


