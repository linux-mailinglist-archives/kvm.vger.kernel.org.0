Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49B8B2144BA
	for <lists+kvm@lfdr.de>; Sat,  4 Jul 2020 12:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbgGDKA2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Jul 2020 06:00:28 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:61441 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbgGDKA2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Jul 2020 06:00:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1593856827; x=1625392827;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=lj8o6qIN9a5pDYqi9LY2WR3SoxcoKhnmVOZo6/K7oAk=;
  b=QZyIOirxWJ3JnirVwHa8HeI9bglCw6m1rxbCJMV56NgOleVGW5gqJr96
   IOpJMY+FUqewSqcwUKSReN8iMQMB2lGgYbxS1PSi22he4mrUWY2LpKehq
   eX3sWIWMyvUN9fil5p3k2/jibT7/nHs8Fx5J4qsKPOFsCSMP5lwHlF1g5
   s=;
IronPort-SDR: yZO/v/8BUrG7uTbSiMhU3mB+iCTkCteBPb7wBaiHZWcdyUtmoRzQkD/oYVm3WGcuO502Ntn6el
 XR1KK6BWDKXw==
X-IronPort-AV: E=Sophos;i="5.75,311,1589241600"; 
   d="scan'208";a="55995232"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 04 Jul 2020 10:00:26 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com (Postfix) with ESMTPS id E5327A20C4;
        Sat,  4 Jul 2020 10:00:25 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 4 Jul 2020 10:00:25 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.161.214) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 4 Jul 2020 10:00:16 +0000
Subject: Re: [PATCH v4 04/18] nitro_enclaves: Init PCI device driver
To:     Alexander Graf <graf@amazon.de>, <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Bjoern Doebel" <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Frank van der Linden" <fllinden@amazon.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        "Stefano Garzarella" <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200622200329.52996-1-andraprs@amazon.com>
 <20200622200329.52996-5-andraprs@amazon.com>
 <d8fe8668-15c3-fe3b-1ad1-eb939a4977c2@amazon.de>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <9b9f0ab6-8413-abdf-0829-7b4563593e86@amazon.com>
Date:   Sat, 4 Jul 2020 13:00:10 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <d8fe8668-15c3-fe3b-1ad1-eb939a4977c2@amazon.de>
Content-Language: en-US
X-Originating-IP: [10.43.161.214]
X-ClientProxiedBy: EX13D25UWB004.ant.amazon.com (10.43.161.180) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 02/07/2020 18:09, Alexander Graf wrote:
>
>
> On 22.06.20 22:03, Andra Paraschiv wrote:
>> The Nitro Enclaves PCI device is used by the kernel driver as a means of
>> communication with the hypervisor on the host where the primary VM and
>> the enclaves run. It handles requests with regard to enclave lifetime.
>>
>> Setup the PCI device driver and add support for MSI-X interrupts.
>>
>> Signed-off-by: Alexandru-Catalin Vasile <lexnv@amazon.com>
>> Signed-off-by: Alexandru Ciobotaru <alcioa@amazon.com>
>> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>> ---
>> Changelog
>>
>> v3 -> v4
>>
>> * Use dev_err instead of custom NE log pattern.
>> * Update NE PCI driver name to "nitro_enclaves".
>>
>> v2 -> v3
>>
>> * Remove the GPL additional wording as SPDX-License-Identifier is
>> =A0=A0 already in place.
>> * Remove the WARN_ON calls.
>> * Remove linux/bug include that is not needed.
>> * Update static calls sanity checks.
>> * Remove "ratelimited" from the logs that are not in the ioctl call
>> =A0=A0 paths.
>> * Update kzfree() calls to kfree().
>>
>> v1 -> v2
>>
>> * Add log pattern for NE.
>> * Update PCI device setup functions to receive PCI device data =

>> structure and
>> =A0=A0 then get private data from it inside the functions logic.
>> * Remove the BUG_ON calls.
>> * Add teardown function for MSI-X setup.
>> * Update goto labels to match their purpose.
>> * Implement TODO for NE PCI device disable state check.
>> * Update function name for NE PCI device probe / remove.
>> ---
>> =A0 drivers/virt/nitro_enclaves/ne_pci_dev.c | 261 +++++++++++++++++++++=
++
>> =A0 1 file changed, 261 insertions(+)
>> =A0 create mode 100644 drivers/virt/nitro_enclaves/ne_pci_dev.c
>>
>> diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.c =

>> b/drivers/virt/nitro_enclaves/ne_pci_dev.c
>> new file mode 100644
>> index 000000000000..235fa3ecbee2
>> --- /dev/null
>> +++ b/drivers/virt/nitro_enclaves/ne_pci_dev.c
>> @@ -0,0 +1,261 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights =

>> Reserved.
>> + */
>> +
>> +/* Nitro Enclaves (NE) PCI device driver. */
>> +
>> +#include <linux/delay.h>
>> +#include <linux/device.h>
>> +#include <linux/list.h>
>> +#include <linux/mutex.h>
>> +#include <linux/module.h>
>> +#include <linux/nitro_enclaves.h>
>> +#include <linux/pci.h>
>> +#include <linux/types.h>
>> +#include <linux/wait.h>
>> +
>> +#include "ne_misc_dev.h"
>> +#include "ne_pci_dev.h"
>> +
>> +#define NE_DEFAULT_TIMEOUT_MSECS (120000) /* 120 sec */
>> +
>> +static const struct pci_device_id ne_pci_ids[] =3D {
>> +=A0=A0=A0 { PCI_DEVICE(PCI_VENDOR_ID_AMAZON, PCI_DEVICE_ID_NE) },
>> +=A0=A0=A0 { 0, }
>> +};
>> +
>> +MODULE_DEVICE_TABLE(pci, ne_pci_ids);
>> +
>> +/**
>> + * ne_setup_msix - Setup MSI-X vectors for the PCI device.
>> + *
>> + * @pdev: PCI device to setup the MSI-X for.
>> + *
>> + * @returns: 0 on success, negative return value on failure.
>> + */
>> +static int ne_setup_msix(struct pci_dev *pdev)
>> +{
>> +=A0=A0=A0 struct ne_pci_dev *ne_pci_dev =3D pci_get_drvdata(pdev);
>> +=A0=A0=A0 int nr_vecs =3D 0;
>> +=A0=A0=A0 int rc =3D -EINVAL;
>> +
>> +=A0=A0=A0 if (!ne_pci_dev)
>> +=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
>> +
>> +=A0=A0=A0 nr_vecs =3D pci_msix_vec_count(pdev);
>> +=A0=A0=A0 if (nr_vecs < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0 rc =3D nr_vecs;
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 dev_err(&pdev->dev, "Error in getting vec count [=
rc=3D%d]\n", =

>> rc);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 return rc;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 rc =3D pci_alloc_irq_vectors(pdev, nr_vecs, nr_vecs, PCI_IRQ_=
MSIX);
>> +=A0=A0=A0 if (rc < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0 dev_err(&pdev->dev, "Error in alloc MSI-X vecs [r=
c=3D%d]\n", rc);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 return rc;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 return 0;
>> +}
>> +
>> +/**
>> + * ne_teardown_msix - Teardown MSI-X vectors for the PCI device.
>> + *
>> + * @pdev: PCI device to teardown the MSI-X for.
>> + */
>> +static void ne_teardown_msix(struct pci_dev *pdev)
>> +{
>> +=A0=A0=A0 struct ne_pci_dev *ne_pci_dev =3D pci_get_drvdata(pdev);
>> +
>> +=A0=A0=A0 if (!ne_pci_dev)
>> +=A0=A0=A0=A0=A0=A0=A0 return;
>> +
>> +=A0=A0=A0 pci_free_irq_vectors(pdev);
>> +}
>> +
>> +/**
>> + * ne_pci_dev_enable - Select PCI device version and enable it.
>> + *
>> + * @pdev: PCI device to select version for and then enable.
>> + *
>> + * @returns: 0 on success, negative return value on failure.
>> + */
>> +static int ne_pci_dev_enable(struct pci_dev *pdev)
>> +{
>> +=A0=A0=A0 u8 dev_enable_reply =3D 0;
>> +=A0=A0=A0 u16 dev_version_reply =3D 0;
>> +=A0=A0=A0 struct ne_pci_dev *ne_pci_dev =3D pci_get_drvdata(pdev);
>> +
>> +=A0=A0=A0 if (!ne_pci_dev || !ne_pci_dev->iomem_base)
>> +=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
>
> How can this ever happen?

This check and the following one are part of that checks added before =

for the situations that shouldn't happen, only if buggy system or broken =

logic at all. Removed the checks.

Thanks,
Andra

>
>> +
>> +=A0=A0=A0 iowrite16(NE_VERSION_MAX, ne_pci_dev->iomem_base + NE_VERSION=
);
>> +
>> +=A0=A0=A0 dev_version_reply =3D ioread16(ne_pci_dev->iomem_base + NE_VE=
RSION);
>> +=A0=A0=A0 if (dev_version_reply !=3D NE_VERSION_MAX) {
>> +=A0=A0=A0=A0=A0=A0=A0 dev_err(&pdev->dev, "Error in pci dev version cmd=
\n");
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 return -EIO;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 iowrite8(NE_ENABLE_ON, ne_pci_dev->iomem_base + NE_ENABLE);
>> +
>> +=A0=A0=A0 dev_enable_reply =3D ioread8(ne_pci_dev->iomem_base + NE_ENAB=
LE);
>> +=A0=A0=A0 if (dev_enable_reply !=3D NE_ENABLE_ON) {
>> +=A0=A0=A0=A0=A0=A0=A0 dev_err(&pdev->dev, "Error in pci dev enable cmd\=
n");
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 return -EIO;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 return 0;
>> +}
>> +
>> +/**
>> + * ne_pci_dev_disable - Disable PCI device.
>> + *
>> + * @pdev: PCI device to disable.
>> + */
>> +static void ne_pci_dev_disable(struct pci_dev *pdev)
>> +{
>> +=A0=A0=A0 u8 dev_disable_reply =3D 0;
>> +=A0=A0=A0 struct ne_pci_dev *ne_pci_dev =3D pci_get_drvdata(pdev);
>> +=A0=A0=A0 const unsigned int sleep_time =3D 10; /* 10 ms */
>> +=A0=A0=A0 unsigned int sleep_time_count =3D 0;
>> +
>> +=A0=A0=A0 if (!ne_pci_dev || !ne_pci_dev->iomem_base)
>> +=A0=A0=A0=A0=A0=A0=A0 return;
>
> How can this ever happen?
>
>
> Alex




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar=
 Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in R=
omania. Registration number J22/2621/2005.

