Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6611B30B73
	for <lists+kvm@lfdr.de>; Fri, 31 May 2019 11:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbfEaJ07 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 May 2019 05:26:59 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:10121 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbfEaJ06 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 May 2019 05:26:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559294817; x=1590830817;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=MKgsQte0z/+s2YR2gzMjXo/CzMEGKlYzKLUQS4Ze4mM=;
  b=tmud6NOfLbZCYwLDFvOFtZWFnMy7GXG4fHgTquLvpMn4PDThmFfR5240
   ErcfdCnN59NMZhwPnkAG9fzPvB01FB1nI2GMEgcw75GNLR5hEVlUQVza3
   Z9qSkUb6UgrbZVs09GLmr6wk50HBLanajcZ8tVBnwEbHelQajXyVKx3d0
   Y=;
X-IronPort-AV: E=Sophos;i="5.60,534,1549929600"; 
   d="scan'208";a="807789661"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-2c-397e131e.us-west-2.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 31 May 2019 09:26:56 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-397e131e.us-west-2.amazon.com (Postfix) with ESMTPS id 2FC14A25F0;
        Fri, 31 May 2019 09:26:55 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 31 May 2019 09:26:54 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.89) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 31 May 2019 09:26:51 +0000
Subject: Re: [PATCH v2 1/2] KVM: Start populating /sys/hypervisor with KVM
 entries
To:     "Raslan, KarimAllah" <karahmed@amazon.de>,
        "Sironi, Filippo" <sironi@amazon.de>
CC:     "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>,
        "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>,
        "Marc.Zyngier@arm.com" <Marc.Zyngier@arm.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
References: <1539078879-4372-1-git-send-email-sironi@amazon.de>
 <1557847002-23519-1-git-send-email-sironi@amazon.de>
 <1557847002-23519-2-git-send-email-sironi@amazon.de>
 <e976f31b-2ccd-29ba-6a32-2edde49f867f@amazon.com>
 <3D2C4EE3-1C2E-4032-9964-31A066E542AA@amazon.de>
 <6b3dadf9-6240-6440-b784-50bec605bf2c@amazon.com>
 <1559293922.14762.2.camel@amazon.de>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <2d056a1c-1763-127d-b957-0e519a8e56cd@amazon.com>
Date:   Fri, 31 May 2019 11:26:49 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1559293922.14762.2.camel@amazon.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.43.161.89]
X-ClientProxiedBy: EX13D22UWC002.ant.amazon.com (10.43.162.29) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 31.05.19 11:12, Raslan, KarimAllah wrote:
> On Fri, 2019-05-31 at 11:06 +0200, Alexander Graf wrote:
>> On 17.05.19 17:41, Sironi, Filippo wrote:
>>>> On 16. May 2019, at 15:50, Graf, Alexander <graf@amazon.com> wrote:
>>>>
>>>> On 14.05.19 08:16, Filippo Sironi wrote:
>>>>> Start populating /sys/hypervisor with KVM entries when we're running on
>>>>> KVM. This is to replicate functionality that's available when we're
>>>>> running on Xen.
>>>>>
>>>>> Start with /sys/hypervisor/uuid, which users prefer over
>>>>> /sys/devices/virtual/dmi/id/product_uuid as a way to recognize a virtual
>>>>> machine, since it's also available when running on Xen HVM and on Xen PV
>>>>> and, on top of that doesn't require root privileges by default.
>>>>> Let's create arch-specific hooks so that different architectures can
>>>>> provide different implementations.
>>>>>
>>>>> Signed-off-by: Filippo Sironi <sironi@amazon.de>
>>>> I think this needs something akin to
>>>>
>>>>    https://www.kernel.org/doc/Documentation/ABI/stable/sysfs-hypervisor-xen
>>>>
>>>> to document which files are available.
>>>>
>>>>> ---
>>>>> v2:
>>>>> * move the retrieval of the VM UUID out of uuid_show and into
>>>>>    kvm_para_get_uuid, which is a weak function that can be overwritten
>>>>>
>>>>> drivers/Kconfig              |  2 ++
>>>>> drivers/Makefile             |  2 ++
>>>>> drivers/kvm/Kconfig          | 14 ++++++++++++++
>>>>> drivers/kvm/Makefile         |  1 +
>>>>> drivers/kvm/sys-hypervisor.c | 30 ++++++++++++++++++++++++++++++
>>>>> 5 files changed, 49 insertions(+)
>>>>> create mode 100644 drivers/kvm/Kconfig
>>>>> create mode 100644 drivers/kvm/Makefile
>>>>> create mode 100644 drivers/kvm/sys-hypervisor.c
>>>>>
>>>> [...]
>>>>
>>>>> +
>>>>> +__weak const char *kvm_para_get_uuid(void)
>>>>> +{
>>>>> +	return NULL;
>>>>> +}
>>>>> +
>>>>> +static ssize_t uuid_show(struct kobject *obj,
>>>>> +			 struct kobj_attribute *attr,
>>>>> +			 char *buf)
>>>>> +{
>>>>> +	const char *uuid = kvm_para_get_uuid();
>>>>> +	return sprintf(buf, "%s\n", uuid);
>>>> The usual return value for the Xen /sys/hypervisor interface is
>>>> "<denied>". Wouldn't it make sense to follow that pattern for the KVM
>>>> one too? Currently, if we can not determine the UUID this will just
>>>> return (null).
>>>>
>>>> Otherwise, looks good to me. Are you aware of any other files we should
>>>> provide? Also, is there any reason not to implement ARM as well while at it?
>>>>
>>>> Alex
>>> This originated from a customer request that was using /sys/hypervisor/uuid.
>>> My guess is that we would want to expose "type" and "version" moving
>>> forward and that's when we hypervisor hooks will be useful on top
>>> of arch hooks.
>>>
>>> On a different note, any idea how to check whether the OS is running
>>> virtualized on KVM on ARM and ARM64?  kvm_para_available() isn't an
>>
>> Yeah, ARM doesn't have any KVM PV FWIW. I also can't find any explicit
>> hint passed into guests that we are indeed running in KVM. The closest
>> thing I can see is the SMBIOS product identifier in QEMU which gets
>> patched to "KVM Virtual Machine". Maybe we'll have to do with that for
>> the sake of backwards compatibility ...
> How about "psci_ops.conduit" (PSCI_CONDUIT_HVC vs PSCI_CONDUIT_SMC)?


This won't work for 2 reasons:

   a) You don't know it's KVM. You only know you might be running in EL1.
   b) KVM may choose to just use SMC for PSCI going forward and trap on it.


Alex


