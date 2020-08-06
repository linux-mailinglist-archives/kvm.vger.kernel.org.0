Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C81B23D504
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 03:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725998AbgHFBXQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 21:23:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36061 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725999AbgHFBXN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 21:23:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596676991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6UMQQrEZ+Nh2Ng/k4GnJLH3osJ2CLCkGK7FDHnj5N9Y=;
        b=XJXXIKg6ompKt+iu/UjvY9yQS8z6YW8nS1ZhVeoeRrwCQ5rYImj7cnrowr0jnpzlMe39tc
        L3WgKUJwuf/hH18i2aZyT5HnicSC9lBkp4Ns0zlgNj0FB9vFNNkrnGLM0twfDfbsxXHUYf
        yDlatuRI9qeeQHmOHMDek7ist/At0iw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-114-hlfFQIgrNMqgf_91JPS2og-1; Wed, 05 Aug 2020 21:23:09 -0400
X-MC-Unique: hlfFQIgrNMqgf_91JPS2og-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A77180046B;
        Thu,  6 Aug 2020 01:23:05 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA47910013D7;
        Thu,  6 Aug 2020 01:22:59 +0000 (UTC)
Date:   Wed, 5 Aug 2020 19:22:58 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Lin, Jing" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "netanelg@mellanox.com" <netanelg@mellanox.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>,
        "Hossain, Mona" <mona.hossain@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC v2 00/18] Add VFIO mediated device support and
 DEV-MSI support for the idxd driver
Message-ID: <20200805192258.5ee7a05b@x1.home>
In-Reply-To: <20200724001930.GS2021248@mellanox.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
 <20200721164527.GD2021248@mellanox.com>
 <CY4PR11MB1638103EC73DD9C025F144C98C780@CY4PR11MB1638.namprd11.prod.outlook.com>
 <20200724001930.GS2021248@mellanox.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 23 Jul 2020 21:19:30 -0300
Jason Gunthorpe <jgg@mellanox.com> wrote:

> On Tue, Jul 21, 2020 at 11:54:49PM +0000, Tian, Kevin wrote:
> > In a nutshell, applications don't require raw WQ controllability as guest
> > kernel drivers may expect. Extending DSA user space interface to be another
> > passthrough interface just for virtualization needs is less compelling than
> > leveraging established VFIO/mdev framework (with the major merit that
> > existing user space VMMs just work w/o any change as long as they already
> > support VFIO uAPI).  
> 
> Sure, but the above is how the cover letter should have summarized
> that discussion, not as "it is not much code difference"
> 
> > In last review you said that you didn't hard nak this approach and would
> > like to hear opinion from virtualization guys. In this version we CCed KVM
> > mailing list, Paolo (VFIO/Qemu), Alex (VFIO), Samuel (Rust-VMM/Cloud
> > hypervisor), etc. Let's see how they feel about this approach.  
> 
> Yes, the VFIO community should decide.
> 
> If we are doing emulation tasks in the kernel now, then I can think of
> several nice semi-emulated mdevs to propose.
> 
> This will not be some one off, but the start of a widely copied
> pattern.

And that's definitely a concern, there should be a reason for
implementing device emulation in the kernel beyond an easy path to get
a device exposed up through a virtualization stack.  The entire idea of
mdev is the mediation of access to a device to make it safe for a user
and to fit within the vfio device API.  Mediation, emulation, and
virtualization can be hard to differentiate, and there is some degree of
emulation required to fill out the device API, for vfio-pci itself
included.  So I struggle with a specific measure of where to draw the
line, and also whose authority it is to draw that line.  I don't think
it's solely mine, that's something we need to decide as a community.

If you see this as an abuse of the framework, then let's identify those
specific issues and come up with a better approach.  As we've discussed
before, things like basic PCI config space emulation are acceptable
overhead and low risk (imo) and some degree of register emulation is
well within the territory of an mdev driver.  Drivers are accepting
some degree of increased attack surface by each addition of a uAPI and
the complexity of those uAPIs, but it seems largely a decision for
those drivers whether they're willing to take on that responsibility
and burden.

At some point, possibly in the near-ish future, we might have a
vfio-user interface with userspace vfio-over-socket servers that might
be able to consume existing uAPIs and offload some of this complexity
and emulation to userspace while still providing an easy path to insert
devices into the virtualization stack.  Hopefully if/when that comes
along, it would provide these sorts of drivers an opportunity to
offload some of the current overhead out to userspace, but I'm not sure
it's worth denying a mainline implementation now.  Thanks,

Alex

