Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0294B39ABE3
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 22:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbhFCUn2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 16:43:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24322 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229617AbhFCUn1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Jun 2021 16:43:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622752901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qLv3J4sXkt9z19cRT1XYaQD2oi8vzzx5bPwW4C7AJSo=;
        b=hHTmQjM3SCzAkZZzvnw4zD6gqF3T2kCpHytvjFGzkAmkbHS7XbSGYNaPgjSsHxHlpmwHLK
        RkjYzxoA7OqoT/xgL5tOhwobwLlt8MU/XFMDo4I7W72XAnbZW1wBdyT/ZgStOBeVCPTD4x
        LHy5QNf18AebVqoupdcLk9R0UNG+2fA=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-448-dE5EYe1NMTW76Fl_UubOow-1; Thu, 03 Jun 2021 16:41:40 -0400
X-MC-Unique: dE5EYe1NMTW76Fl_UubOow-1
Received: by mail-oi1-f198.google.com with SMTP id k9-20020a0568080689b02901f1c37dd8c9so3111392oig.8
        for <kvm@vger.kernel.org>; Thu, 03 Jun 2021 13:41:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qLv3J4sXkt9z19cRT1XYaQD2oi8vzzx5bPwW4C7AJSo=;
        b=EDIJMw7g5jv+6O/E0SkK2567MZNcm+a7d6fpqZnNNHoktSCYS7vFcgP+600elZzI43
         CS5CVPT/oVnCEq9upWjYPZK5BEcuWjP2R7fco0qCFFrliUz661CDcaSeLWL3YzdicyOF
         PruItjb1OG7KLCkwJ41Uc8hGqc7f55nDXFlLmD3dB7X8SUwu6zuS8IcJMrEj94djorWl
         s9wqESl16ownOn0d1zyaAE9aurlVD2ulFbR5DGnfCYlPS55fQu+PJypl7SfkalK1GOp8
         R0gVNA+czQ9gEH10MANyqHlghXG6z2O4EDydUe61vfEDgOACPqlbkRaElnrc8nR9zoGe
         xuGA==
X-Gm-Message-State: AOAM530b+QA+mzReFD/CQESJGXzYi7b1kHPSJ+MiInbBzKzaYWPoxBUx
        mNAeMSj/DoUo0cXOx1+UvVGfbcBom24GaiX+6ce1bMHDWR2o9BZqZhu3TwVXrdjDLBv6I8uYeBl
        0M2FyO5GFYA6B
X-Received: by 2002:a05:6830:19e2:: with SMTP id t2mr986980ott.190.1622752899525;
        Thu, 03 Jun 2021 13:41:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwLIRY2X/fmxM+nr4TMws/lLcuX+l7GhTX4Ij4lEgnN5xDncIaqE9ba/YtSx5Zz0gC7BSFScA==
X-Received: by 2002:a05:6830:19e2:: with SMTP id t2mr986965ott.190.1622752899308;
        Thu, 03 Jun 2021 13:41:39 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id m28sm897060otr.81.2021.06.03.13.41.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 13:41:38 -0700 (PDT)
Date:   Thu, 3 Jun 2021 14:41:36 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210603144136.2b68c5c5.alex.williamson@redhat.com>
In-Reply-To: <20210603124036.GU1002214@nvidia.com>
References: <20210602111117.026d4a26.alex.williamson@redhat.com>
        <20210602173510.GE1002214@nvidia.com>
        <20210602120111.5e5bcf93.alex.williamson@redhat.com>
        <20210602180925.GH1002214@nvidia.com>
        <20210602130053.615db578.alex.williamson@redhat.com>
        <20210602195404.GI1002214@nvidia.com>
        <20210602143734.72fb4fa4.alex.williamson@redhat.com>
        <20210602224536.GJ1002214@nvidia.com>
        <20210602205054.3505c9c3.alex.williamson@redhat.com>
        <MWHPR11MB1886DC8ECF5D56FE485D13D58C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210603124036.GU1002214@nvidia.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 3 Jun 2021 09:40:36 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, Jun 03, 2021 at 03:22:27AM +0000, Tian, Kevin wrote:
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Thursday, June 3, 2021 10:51 AM
> > > 
> > > On Wed, 2 Jun 2021 19:45:36 -0300
> > > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > >   
> > > > On Wed, Jun 02, 2021 at 02:37:34PM -0600, Alex Williamson wrote:
> > > >  
> > > > > Right.  I don't follow where you're jumping to relaying DMA_PTE_SNP
> > > > > from the guest page table... what page table?  
> > > >
> > > > I see my confusion now, the phrasing in your earlier remark led me
> > > > think this was about allowing the no-snoop performance enhancement in
> > > > some restricted way.
> > > >
> > > > It is really about blocking no-snoop 100% of the time and then
> > > > disabling the dangerous wbinvd when the block is successful.
> > > >
> > > > Didn't closely read the kvm code :\
> > > >
> > > > If it was about allowing the optimization then I'd expect the guest to
> > > > enable no-snoopable regions via it's vIOMMU and realize them to the
> > > > hypervisor and plumb the whole thing through. Hence my remark about
> > > > the guest page tables..
> > > >
> > > > So really the test is just 'were we able to block it' ?  
> > > 
> > > Yup.  Do we really still consider that there's some performance benefit
> > > to be had by enabling a device to use no-snoop?  This seems largely a
> > > legacy thing.  
> > 
> > Yes, there is indeed performance benefit for device to use no-snoop,
> > e.g. 8K display and some imaging processing path, etc. The problem is
> > that the IOMMU for such devices is typically a different one from the
> > default IOMMU for most devices. This special IOMMU may not have
> > the ability of enforcing snoop on no-snoop PCI traffic then this fact
> > must be understood by KVM to do proper mtrr/pat/wbinvd virtualization 
> > for such devices to work correctly.  
> 
> Or stated another way:
> 
> We in Linux don't have a way to control if the VFIO IO page table will
> be snoop or no snoop from userspace so Intel has forced the platform's
> IOMMU path for the integrated GPU to be unable to enforce snoop, thus
> "solving" the problem.

That's giving vfio a lot of credit for influencing VT-d design.

> I don't think that is sustainable in the oveall ecosystem though.

Our current behavior is a reasonable default IMO, but I agree more
control will probably benefit us in the long run.

> 'qemu --allow-no-snoop' makes more sense to me

I'd be tempted to attach it to the -device vfio-pci option, it's
specific drivers for specific devices that are going to want this and
those devices may not be permanently attached to the VM.  But I see in
the other thread you're trying to optimize IOMMU page table sharing.

There's a usability question in either case though and I'm not sure how
to get around it other than QEMU or the kernel knowing a list of
devices (explicit IDs or vendor+class) to select per device defaults.

> > When discussing I/O page fault support in another thread, the consensus
> > is that an device handle will be registered (by user) or allocated (return
> > to user) in /dev/ioasid when binding the device to ioasid fd. From this 
> > angle we can register {ioasid_fd, device_handle} to KVM and then call 
> > something like ioasidfd_device_is_coherent() to get the property. 
> > Anyway the coherency is a per-device property which is not changed 
> > by how many I/O page tables are attached to it.  
> 
> It is not device specific, it is driver specific
> 
> As I said before, the question is if the IOASID itself can enforce
> snoop, or not. AND if the device will issue no-snoop or not.
> 
> Devices that are hard wired to never issue no-snoop are safe even with
> an IOASID that cannot enforce snoop. AFAIK really only GPUs use this
> feature. Eg I would be comfortable to say mlx5 never uses the no-snoop
> TLP flag.
> 
> Only the vfio_driver could know this.

Could you clarify "vfio_driver"?  The existing vfio-pci driver can't
know this, beyond perhaps probing if the Enable No-snoop bit is
hardwired to zero.  It's the driver running on top of vfio that
ultimately controls whether a capable device actually issues no-snoop
TLPs, but that can't be known to us.  A vendor variant of vfio-pci
might certainly know more about how its device is used by those
userspace/VM drivers.  Thanks,

Alex

