Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B146C23E314
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 22:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbgHFUVS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 16:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726058AbgHFUVS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Aug 2020 16:21:18 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF37C061574;
        Thu,  6 Aug 2020 13:21:16 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1596745273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xtHNLCxJfzsiJSCp6/W+TfOKxP2aJ6UgREgy+loBHMI=;
        b=R6Q0ESn3y1nFnbdCuyGK0a83rqiXG8o7/o8w7zgwZPTxcrxycOlwCP9+kCI/nt8ak7n7Mg
        g6Fgmkcr/k7pm/ulgLm4xEo+wxRiaRf5Ov3SHz1fIwIeAt+frnBgPWY1ZpLV0T0Gh4mWMx
        lxTmOBiTx4Zt4fkY9zIv8/dbw0BUyPXIIbKc/W7VT8dguTXihqNIaqifWjlr3dkYQwPPy7
        4E9Xj5KIHhrChnRxs5vRovcAPlvzVFcp2d1fZGEI5bZKDaPtFiVQcKpSvVSF+17+JTdpq9
        TQmnaTen4VK/BEvUBXUp3A2OX2nGzdAwUhLJmPo6skT+IToB1D95OLH0712vUA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1596745273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xtHNLCxJfzsiJSCp6/W+TfOKxP2aJ6UgREgy+loBHMI=;
        b=fXJRubCjssIpQgTtL/ZduGNhVfFn7HZPRc8hhVtuSscb+ctPyf0CnqZPYi2XebcAC4VBfm
        OwvT7Zfw9fXJ0vCQ==
To:     "Dey\, Megha" <megha.dey@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        "Jiang\, Dave" <dave.jiang@intel.com>,
        "vkoul\@kernel.org" <vkoul@kernel.org>,
        "bhelgaas\@google.com" <bhelgaas@google.com>,
        "rafael\@kernel.org" <rafael@kernel.org>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hpa\@zytor.com" <hpa@zytor.com>,
        "alex.williamson\@redhat.com" <alex.williamson@redhat.com>,
        "Pan\, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj\, Ashok" <ashok.raj@intel.com>,
        "Liu\, Yi L" <yi.l.liu@intel.com>,
        "Lu\, Baolu" <baolu.lu@intel.com>,
        "Tian\, Kevin" <kevin.tian@intel.com>,
        "Kumar\, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck\, Tony" <tony.luck@intel.com>,
        "Lin\, Jing" <jing.lin@intel.com>,
        "Williams\, Dan J" <dan.j.williams@intel.com>,
        "kwankhede\@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger\@redhat.com" <eric.auger@redhat.com>,
        "parav\@mellanox.com" <parav@mellanox.com>,
        "Hansen\, Dave" <dave.hansen@intel.com>,
        "netanelg\@mellanox.com" <netanelg@mellanox.com>,
        "shahafs\@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao\@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini\@redhat.com" <pbonzini@redhat.com>,
        "Ortiz\, Samuel" <samuel.ortiz@intel.com>,
        "Hossain\, Mona" <mona.hossain@intel.com>,
        "dmaengine\@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86\@kernel.org" <x86@kernel.org>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC v2 02/18] irq/dev-msi: Add support for a new DEV_MSI irq domain
In-Reply-To: <014ffe59-38d3-b770-e065-dfa2d589adc6@intel.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com> <159534734833.28840.10067945890695808535.stgit@djiang5-desk3.ch.intel.com> <878sfbxtzi.wl-maz@kernel.org> <20200722195928.GN2021248@mellanox.com> <96a1eb5ccc724790b5404a642583919d@intel.com> <20200805221548.GK19097@mellanox.com> <70465fd3a7ae428a82e19f98daa779e8@intel.com> <20200805225330.GL19097@mellanox.com> <630e6a4dc17b49aba32675377f5a50e0@intel.com> <20200806001927.GM19097@mellanox.com> <c6a1c065ab9b46bbaf9f5713462085a5@intel.com> <87tuxfhf9u.fsf@nanos.tec.linutronix.de> <014ffe59-38d3-b770-e065-dfa2d589adc6@intel.com>
Date:   Thu, 06 Aug 2020 22:21:11 +0200
Message-ID: <87h7tfh6fc.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Megha,

"Dey, Megha" <megha.dey@intel.com> writes:
> On 8/6/2020 10:10 AM, Thomas Gleixner wrote:
>> If the DEV/MSI domain has it's own per IR unit resource management, then
>> you need one per IR unit.
>>
>> If the resource management is solely per device then having a domain per
>> device is the right choice.
>
> The dev-msi domain can be used by other devices if they too would want
> to follow the vector->intel IR->dev-msi IRQ hierarchy.  I do create
> one dev-msi IRQ domain instance per IR unit. So I guess for this case,
> it makes most sense to have a dev-msi IRQ domain per IR unit as
> opposed to create one per individual driver..

I'm not really convinced. I looked at the idxd driver and that has it's
own interrupt related resource management for the IMS slots and provides
the mask,unmask callbacks for the interrupt chip via this crude platform
data indirection.

So I don't see the value of the dev-msi domain per IR unit. The domain
itself does not provide much functionality other than indirections and
you clearly need per device interrupt resource management on the side
and a customized irq chip. I rather see it as a plain layering
violation.

The point is that your IDXD driver manages the per device IMS slots
which is a interrupt related resource. The story would be different if
the IMS slots would be managed by some central or per IR unit entity,
but in that case you'd need IMS specific domain(s).

So the obvious consequence of the hierarchical irq design is:

   vector -> IR -> IDXD

which makes the control flow of allocating an interrupt for a subdevice
straight forward following the irq hierarchy rules.

This still wants to inherit the existing msi domain functionality, but
the amount of code required is small and removes all these pointless
indirections and integrates the slot management naturally.

If you expect or know that there are other devices coming up with IMS
integrated then most of that code can be made a common library. But for
this to make sense, you really want to make sure that these other
devices do not require yet another horrible layer of indirection.

A side note: I just read back on the specification and stumbled over
the following gem:

 "IMS may also optionally support per-message masking and pending bit
  status, similar to the per-vector mask and pending bit array in the
  PCI Express MSI-X capability."

Optionally? Please tell the hardware folks to make this mandatory. We
have enough pain with non maskable MSI interrupts already so introducing
yet another non maskable interrupt trainwreck is not an option.

It's more than a decade now that I tell HW people not to repeat the
non-maskable MSI failure, but obviously they still think that
non-maskable interrupts are a brilliant idea. I know that HW folks
believe that everything they omit can be fixed in software, but they
have to finally understand that this particular issue _cannot_ be fixed
at all.

Thanks,

        tglx
