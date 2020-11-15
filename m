Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 616722B349D
	for <lists+kvm@lfdr.de>; Sun, 15 Nov 2020 12:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbgKOL0Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Nov 2020 06:26:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbgKOL0Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Nov 2020 06:26:24 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77A6C0613D1;
        Sun, 15 Nov 2020 03:26:24 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1605439583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=saojbe8LdPKGDAiEz1jquPkUf3s7kcI/f55Y0htbe4s=;
        b=gX6z1dqvU6cHYqV4K37jeiKwqt9/r5FZtOrjMklEE164vtcEPLoskDnhjpLpkwXVi/mkok
        a0d3XbPvOVslLTwHh5GyzUkLTfx2n4KWvHpAVhPYjeH4g4YvKYP0EjeSz8THofHULnMrVa
        gjV8K9OelqUuMEpkTClS3sMIbflOe1yTG9xANj0CWOZL2KrvdPM0UkjA39dmqiKi7NdffM
        b19/rbwfkxLIcJaXvwaaVtU+ThIhr5bLyWhfZsHD/PKKOoh64RBlWJLQVlfWnBT7RsuzSF
        y+KdnS+0d2STzdiulCS6F9rjlC51PGr76OwksQDHNYj0DzPMurPxgPyTyy+f5Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1605439583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=saojbe8LdPKGDAiEz1jquPkUf3s7kcI/f55Y0htbe4s=;
        b=uDucKq0Zw4iyNGZ4Yc4IghjkqXIuPJiROE8suqA7ipywdSIASEW260Z8Nix9NpRG3KHIS/
        ECkoErT6aeUjNVBg==
To:     "Raj\, Ashok" <ashok.raj@intel.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Tian\, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Williams\, Dan J" <dan.j.williams@intel.com>,
        "Jiang\, Dave" <dave.jiang@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "vkoul\@kernel.org" <vkoul@kernel.org>,
        "Dey\, Megha" <megha.dey@intel.com>,
        "maz\@kernel.org" <maz@kernel.org>,
        "bhelgaas\@google.com" <bhelgaas@google.com>,
        "alex.williamson\@redhat.com" <alex.williamson@redhat.com>,
        "Pan\, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu\, Yi L" <yi.l.liu@intel.com>,
        "Lu\, Baolu" <baolu.lu@intel.com>,
        "Kumar\, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck\, Tony" <tony.luck@intel.com>,
        "kwankhede\@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger\@redhat.com" <eric.auger@redhat.com>,
        "parav\@mellanox.com" <parav@mellanox.com>,
        "rafael\@kernel.org" <rafael@kernel.org>,
        "netanelg\@mellanox.com" <netanelg@mellanox.com>,
        "shahafs\@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao\@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini\@redhat.com" <pbonzini@redhat.com>,
        "Ortiz\, Samuel" <samuel.ortiz@intel.com>,
        "Hossain\, Mona" <mona.hossain@intel.com>,
        "dmaengine\@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        Ashok Raj <ashok.raj@intel.com>
Subject: Re: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
In-Reply-To: <20201114211837.GB12197@araj-mobl1.jf.intel.com>
References: <874klykc7h.fsf@nanos.tec.linutronix.de> <20201109173034.GG2620339@nvidia.com> <87pn4mi23u.fsf@nanos.tec.linutronix.de> <20201110051412.GA20147@otc-nc-03> <875z6dik1a.fsf@nanos.tec.linutronix.de> <20201110141323.GB22336@otc-nc-03> <MWHPR11MB16455B594B1B48B6E3C97C108CE80@MWHPR11MB1645.namprd11.prod.outlook.com> <20201112193253.GG19638@char.us.oracle.com> <877dqqmc2h.fsf@nanos.tec.linutronix.de> <20201114103430.GA9810@infradead.org> <20201114211837.GB12197@araj-mobl1.jf.intel.com>
Date:   Sun, 15 Nov 2020 12:26:22 +0100
Message-ID: <877dqmamjl.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 14 2020 at 13:18, Ashok Raj wrote:
> On Sat, Nov 14, 2020 at 10:34:30AM +0000, Christoph Hellwig wrote:
>> On Thu, Nov 12, 2020 at 11:42:46PM +0100, Thomas Gleixner wrote:
>> Which is why I really think we need explicit opt-ins for "native"
>> SIOV handling and for paravirtualized SIOV handling, with the kernel
>> not offering support at all without either or a manual override on
>> the command line.
>
> opt-in by device or kernel? The way we are planning to support this is:
>
> Device support for IMS - Can discover in device specific means
> Kernel support for IMS. - Supported by IOMMU driver.

And why exactly do we have to enforce IOMMU support? Please stop looking
at IMS purely from the IDXD perspective. We are talking about the
general concept here and not about the restricted Intel universe.

> each driver can check 
>
> if (dev_supports_ims() && iommu_supports_ims()) {
> 	/* Then IMS is supported in the platform.*/
> }

Please forget this 'each driver can check'. That's just wrong.

The only thing the driver has to check is whether the device supports
IMS or not. Everything else has to be handled by the underlying
infrastructure.

That's pretty much the same thing like PCI/MSI[X]. The driver does not
have to check 'device_has_msix() && platform_supports_msix()'. Enabling
MSI[X] will simply fail if it's not supported.

So for IMS creating the underlying irqdomain has to fail when the
platform does not support it and the driver can act upon the fail and
fallback to MSI[X] or just refuse to load when IMS is required for the
device to be functional.

Thanks,

        tglx
