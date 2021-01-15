Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDCF2F7539
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 10:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729426AbhAOJ0Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 04:26:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36475 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725950AbhAOJ0O (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 04:26:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610702686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ws2F730VN2fbq90WuzsMpLC9UjZzVl4J3RF/sAqGHt4=;
        b=JOjXVuz9K/Isp+kukkEiG3lExFK6pf9uXxH2PJm9BGwkJfnHh5z5Gr5fpPq3osHWiX8Q7e
        Ju/GysQwod77LLYHVDz5GPl9no402e0TTeGITKI4C0PCnB3RFgwwrvdHFwPdCZLd4lyC0k
        wWh2cGF4wrXeF8f0aUugI+ayw2El978=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-R7ynSWHhPn2cHKelC4L-ew-1; Fri, 15 Jan 2021 04:24:43 -0500
X-MC-Unique: R7ynSWHhPn2cHKelC4L-ew-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7DE328464D4;
        Fri, 15 Jan 2021 09:24:41 +0000 (UTC)
Received: from [10.36.114.165] (ovpn-114-165.ams2.redhat.com [10.36.114.165])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 52E316F922;
        Fri, 15 Jan 2021 09:24:35 +0000 (UTC)
Subject: Re: [RFC v3 2/2] vfio/platform: msi: add Broadcom platform devices
To:     Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vikram Prakash <vikram.prakash@broadcom.com>,
        Srinath Mannam <srinath.mannam@broadcom.com>,
        Ashwin Kamath <ashwin.kamath@broadcom.com>,
        Zac Schroff <zachary.schroff@broadcom.com>,
        Manish Kurup <manish.kurup@broadcom.com>
References: <20201124161646.41191-1-vikas.gupta@broadcom.com>
 <20201214174514.22006-1-vikas.gupta@broadcom.com>
 <20201214174514.22006-3-vikas.gupta@broadcom.com>
 <b3dcbca3-c85a-d327-e64e-5830286dfbba@redhat.com>
 <CAHLZf_u860kCfpExucwOxWmTDzH_QXnR_O=X8Yq3NAtXesmZ0w@mail.gmail.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <25199e7e-4a42-c69a-0d16-4bf1764ee87b@redhat.com>
Date:   Fri, 15 Jan 2021 10:24:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAHLZf_u860kCfpExucwOxWmTDzH_QXnR_O=X8Yq3NAtXesmZ0w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vikas,
On 1/15/21 7:35 AM, Vikas Gupta wrote:
> Hi Eric,
> 
> On Tue, Jan 12, 2021 at 2:52 PM Auger Eric <eric.auger@redhat.com> wrote:
>>
>> Hi Vikas,
>>
>> On 12/14/20 6:45 PM, Vikas Gupta wrote:
>>> Add msi support for Broadcom platform devices
>>>
>>> Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
>>> ---
>>>  drivers/vfio/platform/Kconfig                 |  1 +
>>>  drivers/vfio/platform/Makefile                |  1 +
>>>  drivers/vfio/platform/msi/Kconfig             |  9 ++++
>>>  drivers/vfio/platform/msi/Makefile            |  2 +
>>>  .../vfio/platform/msi/vfio_platform_bcmplt.c  | 49 +++++++++++++++++++
>>>  5 files changed, 62 insertions(+)
>>>  create mode 100644 drivers/vfio/platform/msi/Kconfig
>>>  create mode 100644 drivers/vfio/platform/msi/Makefile
>>>  create mode 100644 drivers/vfio/platform/msi/vfio_platform_bcmplt.c
>> what does plt mean?
> This(plt) is a generic name for Broadcom platform devices, which we`ll
>  plan to add in this file. Currently we have only one in this file.
> Do you think this name does not sound good here?

we have VFIO_PLATFORM_BCMFLEXRM_RESET config which also applied to vfio
flex-rm platform device.

I think it would be more homegenous to have VFIO_PLATFORM_BCMFLEXRM_MSI
in case we keep a separate msi module.

also in reset dir we have vfio_platform_bcmflexrm.c


>>>
>>> diff --git a/drivers/vfio/platform/Kconfig b/drivers/vfio/platform/Kconfig
>>> index dc1a3c44f2c6..7b8696febe61 100644
>>> --- a/drivers/vfio/platform/Kconfig
>>> +++ b/drivers/vfio/platform/Kconfig
>>> @@ -21,3 +21,4 @@ config VFIO_AMBA
>>>         If you don't know what to do here, say N.
>>>
>>>  source "drivers/vfio/platform/reset/Kconfig"
>>> +source "drivers/vfio/platform/msi/Kconfig"
>>> diff --git a/drivers/vfio/platform/Makefile b/drivers/vfio/platform/Makefile
>>> index 3f3a24e7c4ef..9ccdcdbf0e7e 100644
>>> --- a/drivers/vfio/platform/Makefile
>>> +++ b/drivers/vfio/platform/Makefile
>>> @@ -5,6 +5,7 @@ vfio-platform-y := vfio_platform.o
>>>  obj-$(CONFIG_VFIO_PLATFORM) += vfio-platform.o
>>>  obj-$(CONFIG_VFIO_PLATFORM) += vfio-platform-base.o
>>>  obj-$(CONFIG_VFIO_PLATFORM) += reset/
>>> +obj-$(CONFIG_VFIO_PLATFORM) += msi/
>>>
>>>  vfio-amba-y := vfio_amba.o
>>>
>>> diff --git a/drivers/vfio/platform/msi/Kconfig b/drivers/vfio/platform/msi/Kconfig
>>> new file mode 100644
>>> index 000000000000..54d6b70e1e32
>>> --- /dev/null
>>> +++ b/drivers/vfio/platform/msi/Kconfig
>>> @@ -0,0 +1,9 @@
>>> +# SPDX-License-Identifier: GPL-2.0-only
>>> +config VFIO_PLATFORM_BCMPLT_MSI
>>> +     tristate "MSI support for Broadcom platform devices"
>>> +     depends on VFIO_PLATFORM && (ARCH_BCM_IPROC || COMPILE_TEST)
>>> +     default ARCH_BCM_IPROC
>>> +     help
>>> +       Enables the VFIO platform driver to handle msi for Broadcom devices
>>> +
>>> +       If you don't know what to do here, say N.
>>> diff --git a/drivers/vfio/platform/msi/Makefile b/drivers/vfio/platform/msi/Makefile
>>> new file mode 100644
>>> index 000000000000..27422d45cecb
>>> --- /dev/null
>>> +++ b/drivers/vfio/platform/msi/Makefile
>>> @@ -0,0 +1,2 @@
>>> +# SPDX-License-Identifier: GPL-2.0
>>> +obj-$(CONFIG_VFIO_PLATFORM_BCMPLT_MSI) += vfio_platform_bcmplt.o
>>> diff --git a/drivers/vfio/platform/msi/vfio_platform_bcmplt.c b/drivers/vfio/platform/msi/vfio_platform_bcmplt.c
>>> new file mode 100644
>>> index 000000000000..a074b5e92d77
>>> --- /dev/null
>>> +++ b/drivers/vfio/platform/msi/vfio_platform_bcmplt.c
>>> @@ -0,0 +1,49 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +/*
>>> + * Copyright 2020 Broadcom.
>>> + */
>>> +
>>> +#include <linux/module.h>
>>> +#include <linux/device.h>
>>> +#include <linux/interrupt.h>
>>> +#include <linux/msi.h>
>>> +#include <linux/vfio.h>
>>> +
>>> +#include "../vfio_platform_private.h"
>>> +
>>> +#define RING_SIZE            (64 << 10)
>>> +
>>> +#define RING_MSI_ADDR_LS     0x03c
>>> +#define RING_MSI_ADDR_MS     0x040
>>> +#define RING_MSI_DATA_VALUE  0x064
>> Those 3 defines would not be needed anymore with that implementation option.
>>> +
>>> +static u32 bcm_num_msi(struct vfio_platform_device *vdev)
>>> +{
>>> +     struct vfio_platform_region *reg = &vdev->regions[0];
>>> +
>>> +     return (reg->size / RING_SIZE);
>>> +}
>>> +
>>> +static struct vfio_platform_msi_node vfio_platform_bcmflexrm_msi_node = {
>>> +     .owner = THIS_MODULE,
>>> +     .compat = "brcm,iproc-flexrm-mbox",
>>> +     .of_get_msi = bcm_num_msi,
>>> +};
>>> +
>>> +static int __init vfio_platform_bcmflexrm_msi_module_init(void)
>>> +{
>>> +     __vfio_platform_register_msi(&vfio_platform_bcmflexrm_msi_node);
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static void __exit vfio_platform_bcmflexrm_msi_module_exit(void)
>>> +{
>>> +     vfio_platform_unregister_msi("brcm,iproc-flexrm-mbox");
>>> +}
>>> +
>>> +module_init(vfio_platform_bcmflexrm_msi_module_init);
>>> +module_exit(vfio_platform_bcmflexrm_msi_module_exit);
>> One thing I would like to discuss with Alex.
>>
>> As the reset module is mandated (except if reset_required is forced to
>> 0), I am wondering if we shouldn't try to turn the reset module into a
>> "specialization" module and put the msi hooks there. I am afraid we may
>> end up having modules for each and every vfio platform feature
>> specialization. At the moment that's fully bearable but I can't predict
>> what's next.
>>
>> As the mandated feature is the reset capability maybe we could just keep
>> the config/module name terminology, tune the kconfig help message to
>> mention the msi support in case of flex-rm?
>>
> As I understand, your proposal is that we should not have a separate
> module for MSI, rather we add in the existing reset module for
> flex-rm. Thus, this way reset modules do not seem to be specialized
> just for reset functionality only but for MSI as well. Apart from this
> we need not to load the proposed msi module in this patch series. Is
> my understanding correct?

yes it is.
> For me it looks OK to consolidate MSI in the existing 'reset' module.
> Let me know your views so that I can work for the next patch set accordingly.

Before you launch into the rewriting I would like to get the
confirmation Alex is OK or if he prefers to keep separate modules.

Thanks

Eric
> 
> Thanks,
> Vikas
> 
>> What do you think?
>>
>> Thanks
>>
>> Eric
>>
>>
>>
>>
>>> +
>>> +MODULE_LICENSE("GPL v2");
>>> +MODULE_AUTHOR("Broadcom");
>>>
>>

