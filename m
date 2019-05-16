Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 655EB20923
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 16:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727553AbfEPOJN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 May 2019 10:09:13 -0400
Received: from esa2.hc3370-68.iphmx.com ([216.71.145.153]:45133 "EHLO
        esa2.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbfEPOJM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 May 2019 10:09:12 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 May 2019 10:09:11 EDT
Authentication-Results: esa2.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none; spf=None smtp.pra=andrew.cooper3@citrix.com; spf=SoftFail smtp.mailfrom=Andrew.Cooper3@citrix.com; spf=None smtp.helo=postmaster@MIAPEX02MSOL01.citrite.net
Received-SPF: None (esa2.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  andrew.cooper3@citrix.com) identity=pra;
  client-ip=23.29.105.83; receiver=esa2.hc3370-68.iphmx.com;
  envelope-from="Andrew.Cooper3@citrix.com";
  x-sender="andrew.cooper3@citrix.com";
  x-conformance=sidf_compatible
Received-SPF: SoftFail (esa2.hc3370-68.iphmx.com: domain of
  Andrew.Cooper3@citrix.com is inclined to not designate
  23.29.105.83 as permitted sender) identity=mailfrom;
  client-ip=23.29.105.83; receiver=esa2.hc3370-68.iphmx.com;
  envelope-from="Andrew.Cooper3@citrix.com";
  x-sender="Andrew.Cooper3@citrix.com";
  x-conformance=sidf_compatible; x-record-type="v=spf1";
  x-record-text="v=spf1 include:spf.citrix.com
  include:spf2.citrix.com include:ironport.citrix.com
  exists:%{i}._spf.mta.salesforce.com ~all"
Received-SPF: None (esa2.hc3370-68.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@MIAPEX02MSOL01.citrite.net) identity=helo;
  client-ip=23.29.105.83; receiver=esa2.hc3370-68.iphmx.com;
  envelope-from="Andrew.Cooper3@citrix.com";
  x-sender="postmaster@MIAPEX02MSOL01.citrite.net";
  x-conformance=sidf_compatible
IronPort-SDR: HcVBmlO1x+Q8pCdVa7mQ8N381jQDVlZZ4vv7SgTKHxQ3lY49oi3LiRPA6S1KVvFzX418mGrrCJ
 Py1PPO0evuhASkpu3w1o6F3Po27Hb5fcnPc/f3j8WvaZ6sZehWdvV3q/viDAHgo1vRcy2MdpkK
 qIfqpS1b1TBDsMyEdToFslPpR4Q0IKWrD0XqLucNeE/9lE5Uqe/f3lj52Xgrjs+xpLAlQGpHqw
 Drl+Q38k3TgDdGlLaNp5onnFx4D3z3aQZotsIdUv/D9qi8UKQ4Y3LUZUHmr6/gx7KeZJYhiNHw
 8hc=
X-SBRS: 2.7
X-MesageID: 516975
X-Ironport-Server: esa2.hc3370-68.iphmx.com
X-Remote-IP: 23.29.105.83
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.60,476,1549947600"; 
   d="scan'208";a="516975"
Subject: Re: [Xen-devel] [PATCH v2 1/2] KVM: Start populating /sys/hypervisor
 with KVM entries
To:     Alexander Graf <graf@amazon.com>,
        Filippo Sironi <sironi@amazon.de>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <borntraeger@de.ibm.com>, <boris.ostrovsky@oracle.com>,
        <cohuck@redhat.com>, <konrad.wilk@oracle.com>,
        <xen-devel@lists.xenproject.org>, <vasu.srinivasan@oracle.com>
References: <1539078879-4372-1-git-send-email-sironi@amazon.de>
 <1557847002-23519-1-git-send-email-sironi@amazon.de>
 <1557847002-23519-2-git-send-email-sironi@amazon.de>
 <e976f31b-2ccd-29ba-6a32-2edde49f867f@amazon.com>
From:   Andrew Cooper <andrew.cooper3@citrix.com>
Openpgp: preference=signencrypt
Autocrypt: addr=andrew.cooper3@citrix.com; prefer-encrypt=mutual; keydata=
 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
 6+ahAA==
Message-ID: <7aae3e49-5b1c-96d1-466e-5b061305dc9d@citrix.com>
Date:   Thu, 16 May 2019 15:02:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <e976f31b-2ccd-29ba-6a32-2edde49f867f@amazon.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-ClientProxiedBy: AMSPEX02CAS01.citrite.net (10.69.22.112) To
 AMSPEX02CL02.citrite.net (10.69.22.126)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/05/2019 14:50, Alexander Graf wrote:
> On 14.05.19 08:16, Filippo Sironi wrote:
>> Start populating /sys/hypervisor with KVM entries when we're running on
>> KVM. This is to replicate functionality that's available when we're
>> running on Xen.
>>
>> Start with /sys/hypervisor/uuid, which users prefer over
>> /sys/devices/virtual/dmi/id/product_uuid as a way to recognize a virtual
>> machine, since it's also available when running on Xen HVM and on Xen PV
>> and, on top of that doesn't require root privileges by default.
>> Let's create arch-specific hooks so that different architectures can
>> provide different implementations.
>>
>> Signed-off-by: Filippo Sironi <sironi@amazon.de>
> I think this needs something akin to
>
>   https://www.kernel.org/doc/Documentation/ABI/stable/sysfs-hypervisor-xen
>
> to document which files are available.
>
>> ---
>> v2:
>> * move the retrieval of the VM UUID out of uuid_show and into
>>   kvm_para_get_uuid, which is a weak function that can be overwritten
>>
>>  drivers/Kconfig              |  2 ++
>>  drivers/Makefile             |  2 ++
>>  drivers/kvm/Kconfig          | 14 ++++++++++++++
>>  drivers/kvm/Makefile         |  1 +
>>  drivers/kvm/sys-hypervisor.c | 30 ++++++++++++++++++++++++++++++
>>  5 files changed, 49 insertions(+)
>>  create mode 100644 drivers/kvm/Kconfig
>>  create mode 100644 drivers/kvm/Makefile
>>  create mode 100644 drivers/kvm/sys-hypervisor.c
>>
> [...]
>
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
>> +	const char *uuid = kvm_para_get_uuid();
>> +	return sprintf(buf, "%s\n", uuid);
> The usual return value for the Xen /sys/hypervisor interface is
> "<denied>".

This string comes straight from Xen.

It was an effort to reduce the quantity of interesting fingerprintable
data accessable by default to unprivileged guests.

See
https://xenbits.xen.org/gitweb/?p=xen.git;a=commitdiff;h=a2fc8d514df2b38c310d4f4432fe06520b0769ed

~Andrew
