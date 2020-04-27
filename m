Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 115891BA479
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 15:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgD0NTy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 09:19:54 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:41072 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726721AbgD0NTy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Apr 2020 09:19:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587993592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yT6OpqrHhtjj38PhYWZNLuSW0UlygZ75Mb7wSWJbJz8=;
        b=aPlJ/LL3xE7SQ5hbp+Gk3wIRLLtf7uRFjL2Y1W7jT4TqACGfTYmQDpjeUlW1mw+ORAofGM
        SdEboDTyP4ahhOxBZJ8cH4+X0mGaaF40BkLkhz4px+lmhnCKhDvnrvDxAKS72pSK/Eg8qQ
        3KKiSaY0CjR3TOdNf4XknH9fOhbOVm0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-6uf19V3fO6OsdruwAkISWw-1; Mon, 27 Apr 2020 09:19:49 -0400
X-MC-Unique: 6uf19V3fO6OsdruwAkISWw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A06A31895957;
        Mon, 27 Apr 2020 13:19:45 +0000 (UTC)
Received: from x1.home (ovpn-112-162.phx2.redhat.com [10.3.112.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 756BA6106A;
        Mon, 27 Apr 2020 13:19:40 +0000 (UTC)
Date:   Mon, 27 Apr 2020 07:19:39 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "megha.dey@linux.intel.com" <megha.dey@linux.intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Lin, Jing" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC 00/15] Add VFIO mediated device support and IMS
 support for the idxd driver.
Message-ID: <20200427071939.06aa300e@x1.home>
In-Reply-To: <20200427115818.GE13640@mellanox.com>
References: <20200422115017.GQ11945@mellanox.com>
        <20200422211436.GA103345@otc-nc-03>
        <20200423191217.GD13640@mellanox.com>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D8960F9@SHSMSX104.ccr.corp.intel.com>
        <20200424124444.GJ13640@mellanox.com>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D8A808B@SHSMSX104.ccr.corp.intel.com>
        <20200424181203.GU13640@mellanox.com>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D8C5486@SHSMSX104.ccr.corp.intel.com>
        <20200426191357.GB13640@mellanox.com>
        <20200426214355.29e19d33@x1.home>
        <20200427115818.GE13640@mellanox.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 27 Apr 2020 08:58:18 -0300
Jason Gunthorpe <jgg@mellanox.com> wrote:

> On Sun, Apr 26, 2020 at 09:43:55PM -0600, Alex Williamson wrote:
> > On Sun, 26 Apr 2020 16:13:57 -0300
> > Jason Gunthorpe <jgg@mellanox.com> wrote:
> >   
> > > On Sun, Apr 26, 2020 at 05:18:59AM +0000, Tian, Kevin wrote:
> > >   
> > > > > > I think providing an unified abstraction to userspace is also important,
> > > > > > which is what VFIO provides today. The merit of using one set of VFIO
> > > > > > API to manage all kinds of mediated devices and VF devices is a major
> > > > > > gain. Instead, inventing a new vDPA-like interface for every Scalable-IOV
> > > > > > or equivalent device is just overkill and doesn't scale. Also the actual
> > > > > > emulation code in idxd driver is actually small, if putting aside the PCI
> > > > > > config space part for which I already explained most logic could be shared
> > > > > > between mdev device drivers.    
> > > > > 
> > > > > If it was just config space you might have an argument, VFIO already
> > > > > does some config space mangling, but emulating BAR space is out of
> > > > > scope of VFIO, IMHO.    
> > > > 
> > > > out of scope of vfio-pci, but in scope of vfio-mdev. btw I feel that most
> > > > of your objections are actually related to the general idea of
> > > > vfio-mdev.    
> > > 
> > > There have been several abusive proposals of vfio-mdev, everything
> > > from a way to create device drivers to this kind of generic emulation
> > > framework.
> > >   
> > > > Scalable IOV just uses PASID to harden DMA isolation in mediated
> > > > pass-through usage which vfio-mdev enables. Then are you just opposing
> > > > the whole vfio-mdev? If not, I'm curious about the criteria in your mind 
> > > > about when using vfio-mdev is good...    
> > > 
> > > It is appropriate when non-PCI standard techniques are needed to do
> > > raw device assignment, just like VFIO.
> > > 
> > > Basically if vfio-pci is already doing it then it seems reasonable
> > > that vfio-mdev should do the same. This mission creep where vfio-mdev
> > > gains functionality far beyond VFIO is the problem.  
> > 
> > Ehm, vfio-pci emulates BARs too.  We also emulate FLR, power
> > management, DisINTx, and VPD.  FLR, PM, and VPD all have device
> > specific quirks in the host kernel, and I've generally taken the stance
> > that would should take advantage of those quirks, not duplicate them in
> > userspace and not invent new access mechanisms/ioctls for each of them.
> > Emulating DisINTx is convenient since we must have a mechanism to mask
> > INTx, whether it's at the device or the APIC, so we can pretend the
> > hardware supports it.  BAR emulation is really too trivial to argue
> > about, the BARs mean nothing to the physical device mapping, they're
> > simply scratch registers that we mask out the alignment bits on read.
> > vfio-pci is a mix of things that we decide are too complicated or
> > irrelevant to emulate in the kernel and things that take advantage of
> > shared quirks or are just too darn easy to worry about.  BARs fall into
> > that latter category, any sort of mapping into VM address spaces is
> > necessarily done in userspace, but scratch registers that are masked on
> > read, *shrug*, vfio-pci does that.  Thanks,  
> 
> It is not trivial masking. It is a 2000 line patch doing comprehensive
> emulation.

Not sure what you're referring to, I see about 30 lines of code in
vdcm_vidxd_cfg_write() that specifically handle writes to the 4 BARs in
config space and maybe a couple hundred lines of code in total handling
config space emulation.  Thanks,

Alex

