Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D42B023F176
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 18:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgHGQrz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 12:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgHGQry (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Aug 2020 12:47:54 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84665C061756;
        Fri,  7 Aug 2020 09:47:53 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1596818871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C4D6q6BH0UW7RcquNhEbypnm+YCcNqzmSG8cWhZrYzo=;
        b=NFL3dVXc8as4snv68s35F937lz3UhNjhxnxSdP6v0uD6N6pvXz/2CvDeslZIF2x/+Bkol4
        eNT+P1arxUIHxzJUpZmz73rDLB4X+DTitRojtmrV/Zr68KNMBWlcjGqt1uB1Ri3NDtIpfC
        /p0KfoxPcB32Y0O/ecx9ahEY92hM/+i9aAE3AU6+N9RzwD0dSPK4mNDdticALQ+OMWNBUL
        U6d5x/cubDHDIoCXYuAKW1nkd+4Iyvc4d2XWX9JFHI8RZBA0ZNPpH7RPzirnOiHCusAKbg
        5U829Gc4P7R/qn00MVdtEDoxJGxBaMFg8oBh81Eq7S2y13I7HDSsqMXlS3rVfg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1596818871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C4D6q6BH0UW7RcquNhEbypnm+YCcNqzmSG8cWhZrYzo=;
        b=wGmpZV5BlDXngCsY4St47Icmd8oWncMdBdSTSbtStu83dFxc0Ue46GfPvBwyusyCNvxxsw
        G3sIQK9wlJ+NzRBA==
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     "Dey\, Megha" <megha.dey@intel.com>, Marc Zyngier <maz@kernel.org>,
        "Jiang\, Dave" <dave.jiang@intel.com>,
        "vkoul\@kernel.org" <vkoul@kernel.org>,
        "bhelgaas\@google.com" <bhelgaas@google.com>,
        "rafael\@kernel.org" <rafael@kernel.org>,
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
In-Reply-To: <20200807133428.GT16789@nvidia.com>
References: <70465fd3a7ae428a82e19f98daa779e8@intel.com> <20200805225330.GL19097@mellanox.com> <630e6a4dc17b49aba32675377f5a50e0@intel.com> <20200806001927.GM19097@mellanox.com> <c6a1c065ab9b46bbaf9f5713462085a5@intel.com> <87tuxfhf9u.fsf@nanos.tec.linutronix.de> <014ffe59-38d3-b770-e065-dfa2d589adc6@intel.com> <87h7tfh6fc.fsf@nanos.tec.linutronix.de> <20200807120650.GR16789@nvidia.com> <20200807123831.GA645281@kroah.com> <20200807133428.GT16789@nvidia.com>
Date:   Fri, 07 Aug 2020 18:47:40 +0200
Message-ID: <87v9hufln7.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jason Gunthorpe <jgg@nvidia.com> writes:
> Though it is more of a rational and a cookbook on how to combine
> existing technology pieces. (eg PASID, platform_msi, etc)
>
> The basic approach of SIOV's IMS is that there is no longer a generic
> interrupt indirection from numbers to addr/data pairs like
> IOAPIC/MSI/MSI-X owned by the common OS code.
>
> Instead the driver itself is responsible to set the addr/data pair
> into the device in a device specific way, deal with masking, etc.
>
> This lets the device use an implementation that is not limited by the
> harsh MSI-X semantics.
>
> In Linux we already have 'IMS' it is called platform_msi and a few
> embedded drivers already work like this. The idea here is to bring it
> to PCI.

platform_msi as it exists today is a crutch and in hindsight I should
have payed more attention back then and shoot it down before it got
merged.

IMS can be somehow mapped to platform MSI but the proposed approach to
extend platform MSI with the extra bolts for IMS (valid for one
particular incarnation) is just going into the wrong direction.

We've been there and the main reason why hierarchical irq domains exist
is that we needed to make a clear cut between the involved hardware
pieces and their drivers. The pre hierarchy model was a maze of stuff
calling back and forth between layers with lots of duct tape added to
make it "work". This finally fell apart when Intel tried to support
I/O-APIC hotplug. The ARM people had similar issues with all the special
irq related SoC specific IP blocks which are placed between the CPU
level interrupt controller and the device.

The hierarchy strictly seperates the per layer resource management and
each layer can work mostly independent of the actual available parent
layer.

Now looking at IMS. It's a subsystem inside a physical device. It has
slot management (where to place the Message) and mask/unmask. Resource
management at that level is what irq domains are for and mask/unmask is
what a irq chip handles.

So the right thing to do is to create shared infrastructure which is
utilized by the device drivers by providing a few bog standard data
structures and the handful of device specific domain and irq functions.

That keeps the functionality common, but avoids that we end up with

  - msi_desc becoming a dump ground for random driver data

  - a zoo of platform callbacks
  
  - glued on driver specific resource management

and all the great hacks which it requires to work on hundreds of
different devices which all implement IMS differently.

I'm all for sharing code and making the life of driver writers simple
because that makes my life simple as well, but not by creating a layer
at the wrong level and then hacking it into submission until it finally
collapses.

Designing the infrastructure following the clear layering rules of
hierarchical domains so it works for IMS and also replaces the platform
MSI hack is the only sane way to go forward, not the other way round.

Thanks,

        tglx
