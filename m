Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABAD9212769
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 17:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730213AbgGBPJu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 11:09:50 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:24149 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730071AbgGBPJs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 11:09:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1593702587; x=1625238587;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=nUqbRO4JQN2O8vXQu7fD3zBvcmQ+5j1BGXkH6csZfbU=;
  b=e+QuZVrYgPksW8dqofgB9OCb2wpKVx7Kc/SM8TZu8m6nsltn+/V0Dh2f
   4qMO8NLVP9xgBliKGDXLj8p78e0IBuSU7yZtXsvcEdVH/a0mw1gEZ3haE
   9ToU/3VQmR5t6SwTh81Sww9GQxrkfP49sZHryngEZbAfy2FkvzHV7aZvc
   8=;
IronPort-SDR: DZCMyW4xNZwdiPIrntjZaG4WB3JsXH3wVlLIurK2/XlOKCaCJTcnFFYfmYVPanv5sGyjgdgK4O
 bD6mFhnck3ng==
X-IronPort-AV: E=Sophos;i="5.75,304,1589241600"; 
   d="scan'208";a="55638937"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 02 Jul 2020 15:09:44 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com (Postfix) with ESMTPS id D03FDA1ED4;
        Thu,  2 Jul 2020 15:09:41 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 2 Jul 2020 15:09:41 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.145) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 2 Jul 2020 15:09:32 +0000
Subject: Re: [PATCH v4 04/18] nitro_enclaves: Init PCI device driver
To:     Andra Paraschiv <andraprs@amazon.com>,
        <linux-kernel@vger.kernel.org>
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
From:   Alexander Graf <graf@amazon.de>
Message-ID: <d8fe8668-15c3-fe3b-1ad1-eb939a4977c2@amazon.de>
Date:   Thu, 2 Jul 2020 17:09:29 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200622200329.52996-5-andraprs@amazon.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.145]
X-ClientProxiedBy: EX13D43UWA002.ant.amazon.com (10.43.160.109) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 22.06.20 22:03, Andra Paraschiv wrote:
> The Nitro Enclaves PCI device is used by the kernel driver as a means of
> communication with the hypervisor on the host where the primary VM and
> the enclaves run. It handles requests with regard to enclave lifetime.
> =

> Setup the PCI device driver and add support for MSI-X interrupts.
> =

> Signed-off-by: Alexandru-Catalin Vasile <lexnv@amazon.com>
> Signed-off-by: Alexandru Ciobotaru <alcioa@amazon.com>
> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> ---
> Changelog
> =

> v3 -> v4
> =

> * Use dev_err instead of custom NE log pattern.
> * Update NE PCI driver name to "nitro_enclaves".
> =

> v2 -> v3
> =

> * Remove the GPL additional wording as SPDX-License-Identifier is
>    already in place.
> * Remove the WARN_ON calls.
> * Remove linux/bug include that is not needed.
> * Update static calls sanity checks.
> * Remove "ratelimited" from the logs that are not in the ioctl call
>    paths.
> * Update kzfree() calls to kfree().
> =

> v1 -> v2
> =

> * Add log pattern for NE.
> * Update PCI device setup functions to receive PCI device data structure =
and
>    then get private data from it inside the functions logic.
> * Remove the BUG_ON calls.
> * Add teardown function for MSI-X setup.
> * Update goto labels to match their purpose.
> * Implement TODO for NE PCI device disable state check.
> * Update function name for NE PCI device probe / remove.
> ---
>   drivers/virt/nitro_enclaves/ne_pci_dev.c | 261 +++++++++++++++++++++++
>   1 file changed, 261 insertions(+)
>   create mode 100644 drivers/virt/nitro_enclaves/ne_pci_dev.c
> =

> diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.c b/drivers/virt/nitr=
o_enclaves/ne_pci_dev.c
> new file mode 100644
> index 000000000000..235fa3ecbee2
> --- /dev/null
> +++ b/drivers/virt/nitro_enclaves/ne_pci_dev.c
> @@ -0,0 +1,261 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserve=
d.
> + */
> +
> +/* Nitro Enclaves (NE) PCI device driver. */
> +
> +#include <linux/delay.h>
> +#include <linux/device.h>
> +#include <linux/list.h>
> +#include <linux/mutex.h>
> +#include <linux/module.h>
> +#include <linux/nitro_enclaves.h>
> +#include <linux/pci.h>
> +#include <linux/types.h>
> +#include <linux/wait.h>
> +
> +#include "ne_misc_dev.h"
> +#include "ne_pci_dev.h"
> +
> +#define NE_DEFAULT_TIMEOUT_MSECS (120000) /* 120 sec */
> +
> +static const struct pci_device_id ne_pci_ids[] =3D {
> +	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, PCI_DEVICE_ID_NE) },
> +	{ 0, }
> +};
> +
> +MODULE_DEVICE_TABLE(pci, ne_pci_ids);
> +
> +/**
> + * ne_setup_msix - Setup MSI-X vectors for the PCI device.
> + *
> + * @pdev: PCI device to setup the MSI-X for.
> + *
> + * @returns: 0 on success, negative return value on failure.
> + */
> +static int ne_setup_msix(struct pci_dev *pdev)
> +{
> +	struct ne_pci_dev *ne_pci_dev =3D pci_get_drvdata(pdev);
> +	int nr_vecs =3D 0;
> +	int rc =3D -EINVAL;
> +
> +	if (!ne_pci_dev)
> +		return -EINVAL;
> +
> +	nr_vecs =3D pci_msix_vec_count(pdev);
> +	if (nr_vecs < 0) {
> +		rc =3D nr_vecs;
> +
> +		dev_err(&pdev->dev, "Error in getting vec count [rc=3D%d]\n", rc);
> +
> +		return rc;
> +	}
> +
> +	rc =3D pci_alloc_irq_vectors(pdev, nr_vecs, nr_vecs, PCI_IRQ_MSIX);
> +	if (rc < 0) {
> +		dev_err(&pdev->dev, "Error in alloc MSI-X vecs [rc=3D%d]\n", rc);
> +
> +		return rc;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * ne_teardown_msix - Teardown MSI-X vectors for the PCI device.
> + *
> + * @pdev: PCI device to teardown the MSI-X for.
> + */
> +static void ne_teardown_msix(struct pci_dev *pdev)
> +{
> +	struct ne_pci_dev *ne_pci_dev =3D pci_get_drvdata(pdev);
> +
> +	if (!ne_pci_dev)
> +		return;
> +
> +	pci_free_irq_vectors(pdev);
> +}
> +
> +/**
> + * ne_pci_dev_enable - Select PCI device version and enable it.
> + *
> + * @pdev: PCI device to select version for and then enable.
> + *
> + * @returns: 0 on success, negative return value on failure.
> + */
> +static int ne_pci_dev_enable(struct pci_dev *pdev)
> +{
> +	u8 dev_enable_reply =3D 0;
> +	u16 dev_version_reply =3D 0;
> +	struct ne_pci_dev *ne_pci_dev =3D pci_get_drvdata(pdev);
> +
> +	if (!ne_pci_dev || !ne_pci_dev->iomem_base)
> +		return -EINVAL;

How can this ever happen?

> +
> +	iowrite16(NE_VERSION_MAX, ne_pci_dev->iomem_base + NE_VERSION);
> +
> +	dev_version_reply =3D ioread16(ne_pci_dev->iomem_base + NE_VERSION);
> +	if (dev_version_reply !=3D NE_VERSION_MAX) {
> +		dev_err(&pdev->dev, "Error in pci dev version cmd\n");
> +
> +		return -EIO;
> +	}
> +
> +	iowrite8(NE_ENABLE_ON, ne_pci_dev->iomem_base + NE_ENABLE);
> +
> +	dev_enable_reply =3D ioread8(ne_pci_dev->iomem_base + NE_ENABLE);
> +	if (dev_enable_reply !=3D NE_ENABLE_ON) {
> +		dev_err(&pdev->dev, "Error in pci dev enable cmd\n");
> +
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * ne_pci_dev_disable - Disable PCI device.
> + *
> + * @pdev: PCI device to disable.
> + */
> +static void ne_pci_dev_disable(struct pci_dev *pdev)
> +{
> +	u8 dev_disable_reply =3D 0;
> +	struct ne_pci_dev *ne_pci_dev =3D pci_get_drvdata(pdev);
> +	const unsigned int sleep_time =3D 10; /* 10 ms */
> +	unsigned int sleep_time_count =3D 0;
> +
> +	if (!ne_pci_dev || !ne_pci_dev->iomem_base)
> +		return;

How can this ever happen?


Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



