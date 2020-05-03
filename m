Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6635A1C302B
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 00:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgECWrC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 May 2020 18:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726825AbgECWrB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 3 May 2020 18:47:01 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C8EC061A41
        for <kvm@vger.kernel.org>; Sun,  3 May 2020 15:47:01 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id i7so6559021qkl.12
        for <kvm@vger.kernel.org>; Sun, 03 May 2020 15:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=AVHGVh69i6tLRfdF4dM3020pnajApRts28JWh/00Y0k=;
        b=NWIuX6KpAG9IY19sRWEc6BhA9Y4MLZ5DPOGegagAsq5R43aRQjMXKL4tmxLu1r2GKi
         otOLbjoE6ROxgr5rq4JhGqvx02bnhdllTD1olN7hlulAvC2w5esCiu/Nc0EFkAgysv59
         LSzU/3I8wdNeTdLimHaCTGCaXZabIr8ADmw7zeHQZEsUWDOdEaufzK/U/arK50e3OWE+
         srb7/5YTcB7Egis1dZTuxvNqnbiyy82mTVRXIonASE8b8SMUBMTeLr8lh7HgToRlLROr
         FazV4ZBqBHfzUc3OvDnARG1CsEXxs1d0F5qIFzAYUh+etOpBtGZ6zTircBJNB7VujejL
         eO/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=AVHGVh69i6tLRfdF4dM3020pnajApRts28JWh/00Y0k=;
        b=B+Yn35T+WDeknmeIm9I6ns8SdUhS84JKgVbUt4X88ibrgQsX2fZDpRLYMh5A+leM5L
         /4vY0nsnWmiWCujFc0cPz4RZ4AVIWq36MxUzxgVtIG+Od/GPQrVVrbTz2XfWzCMQv2rh
         n+HvxhhtW1Om3x0mA5TXWToi0YEUHDAo+3uuOek/gZUyRs83/BPu+A0p+r60RMhye3Xg
         JMA+tHnEPNj39SUayCY/HPVw0KMMTGWiNIcg+uP/AUNx53lZZn/9cLdSO0+FdbY2Vuq2
         h8pazCWrKj0TlCZ73wV6jqnsDjgl5JaW8VmbyLxQH4H0aoeFfWwN3I2/fkdAMpOgUJ7H
         qJgA==
X-Gm-Message-State: AGi0PuZNhhjZZlyvUwGV3hhpmaettTTqWDIdmO/RMuOSw5hAlAqpL0Me
        9yq+KHVOCsYv+mhoAlcbQs9HAw==
X-Google-Smtp-Source: APiQypJiNXikqIIAx78OUQrqJwD/x2jcvOAM2ZU+xYQBxu5bXw3fn14m4nh5cR5RHVS5IPWE+HNkBA==
X-Received: by 2002:a37:7ec3:: with SMTP id z186mr14155258qkc.108.1588546020315;
        Sun, 03 May 2020 15:47:00 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id n124sm8344085qkn.136.2020.05.03.15.46.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 03 May 2020 15:46:59 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jVNNz-0002s8-C3; Sun, 03 May 2020 19:46:59 -0300
Date:   Sun, 3 May 2020 19:46:59 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Dey, Megha" <megha.dey@linux.intel.com>
Cc:     Dave Jiang <dave.jiang@intel.com>, vkoul@kernel.org,
        maz@kernel.org, bhelgaas@google.com, rafael@kernel.org,
        gregkh@linuxfoundation.org, tglx@linutronix.de, hpa@zytor.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, baolu.lu@intel.com,
        kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFC 04/15] drivers/base: Add support for a new IMS irq
 domain
Message-ID: <20200503224659.GU26002@ziepe.ca>
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
 <158751205175.36773.1874642824360728883.stgit@djiang5-desk3.ch.intel.com>
 <20200423201118.GA29567@ziepe.ca>
 <35f701d9-1034-09c7-8117-87fb8796a017@linux.intel.com>
 <20200503222513.GS26002@ziepe.ca>
 <1ededeb8-deff-4db7-40e5-1d5e8a800f52@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1ededeb8-deff-4db7-40e5-1d5e8a800f52@linux.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, May 03, 2020 at 03:40:44PM -0700, Dey, Megha wrote:
> On 5/3/2020 3:25 PM, Jason Gunthorpe wrote:
> > On Fri, May 01, 2020 at 03:30:02PM -0700, Dey, Megha wrote:
> > > Hi Jason,
> > > 
> > > On 4/23/2020 1:11 PM, Jason Gunthorpe wrote:
> > > > On Tue, Apr 21, 2020 at 04:34:11PM -0700, Dave Jiang wrote:
> > > > > diff --git a/drivers/base/ims-msi.c b/drivers/base/ims-msi.c
> > > > > new file mode 100644
> > > > > index 000000000000..738f6d153155
> > > > > +++ b/drivers/base/ims-msi.c
> > > > > @@ -0,0 +1,100 @@
> > > > > +// SPDX-License-Identifier: GPL-2.0-only
> > > > > +/*
> > > > > + * Support for Device Specific IMS interrupts.
> > > > > + *
> > > > > + * Copyright © 2019 Intel Corporation.
> > > > > + *
> > > > > + * Author: Megha Dey <megha.dey@intel.com>
> > > > > + */
> > > > > +
> > > > > +#include <linux/dmar.h>
> > > > > +#include <linux/irq.h>
> > > > > +#include <linux/mdev.h>
> > > > > +#include <linux/pci.h>
> > > > > +
> > > > > +/*
> > > > > + * Determine if a dev is mdev or not. Return NULL if not mdev device.
> > > > > + * Return mdev's parent dev if success.
> > > > > + */
> > > > > +static inline struct device *mdev_to_parent(struct device *dev)
> > > > > +{
> > > > > +	struct device *ret = NULL;
> > > > > +	struct device *(*fn)(struct device *dev);
> > > > > +	struct bus_type *bus = symbol_get(mdev_bus_type);
> > > > > +
> > > > > +	if (bus && dev->bus == bus) {
> > > > > +		fn = symbol_get(mdev_dev_to_parent_dev);
> > > > > +		ret = fn(dev);
> > > > > +		symbol_put(mdev_dev_to_parent_dev);
> > > > > +		symbol_put(mdev_bus_type);
> > > > 
> > > > No, things like this are not OK in the drivers/base
> > > > 
> > > > Whatever this is doing needs to be properly architected in some
> > > > generic way.
> > > 
> > > Basically what I am trying to do here is to determine if the device is an
> > > mdev device or not.
> > 
> > Why? mdev devices are virtual they don't have HW elements.
> 
> Hmm yeah exactly, since they are virtual, they do not have an associated IRQ
> domain right? So they use the irq domain of the parent device..
> 
> > 
> > The caller should use the concrete pci_device to allocate
> > platform_msi? What is preventing this?
> 
> hmmm do you mean to say all platform-msi adhere to the rules of a PCI
> device? 

I mean where a platform-msi can work should be defined by the arch,
and probably is related to things like having an irq_domain attached

So, like pci, drivers must only try to do platfor_msi stuff on
particular devices. eg on pci_device and platform_device types.

Even so it may not even work, but I can't think of any reason why it
should be made to work on a virtual device like mdev.

> The use case if when we have a device assigned to a guest and we
> want to allocate IMS(platform-msi) interrupts for that
> guest-assigned device. Currently, this is abstracted through a mdev
> interface.

And the mdev has the pci_device internally, so it should simply pass
that pci_device to the platform_msi machinery.

This is no different from something like pci_iomap() which must be
used with the pci_device.

Jason
