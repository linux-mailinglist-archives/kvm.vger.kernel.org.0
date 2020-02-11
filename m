Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 174031597A1
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 19:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730140AbgBKSDi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 13:03:38 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:46137 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728712AbgBKSDi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 13:03:38 -0500
Received: by mail-il1-f193.google.com with SMTP id t17so4197589ilm.13;
        Tue, 11 Feb 2020 10:03:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1x8g+GZrx9UI30UQ428luOfA3vU/d+bR1M2CImC2i24=;
        b=G3+hWX2bEWAklGq4AzNSV1VIQT/5QGIZhOpYbFrKtW5yO7PFvgRlFCFn1OkCv7sqSZ
         L+R38a5iS9BWBAxanexVNJZq8NV2eIsWjUS3NvyvREkzavqHkJgj+dVhJY5hsG4ErN5e
         wW0iRcLxy2kZDPM3sM5uBg63ZMwfa5xnXN5lJku3CeDXmXRjcBV4To2AnIqLGAW0ppbc
         bX/o6S+1PtVRLAVvDvDnbaqbWL1QiXVZnvwTqcetk2fWqIFqHoxo3xBl35LIeEQdQTYd
         MeT859bNIKuRZyjPbrs1+tcMnVyvcEx+m+AdnumPpGVNZ5R/P90ETSsP5KqXqb4aZqzR
         bT2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1x8g+GZrx9UI30UQ428luOfA3vU/d+bR1M2CImC2i24=;
        b=Gm/dprC2JX1A6eOQa6eOiPjKvNx1tfBvl2Bz5Yzs2uOzq0lbE5v5wPbF8JX58uApgl
         CkSrXLsnRbFpW3n7TxxvcX4c7tSfZcl7nRZQAvvyCIuoa5//3+2hb5BhcQeGWYvNCQII
         TBChUB6Ho23P9w7FYilsHIIO1+33z2ftLRHn4aBF65FzNJ+v0uPs0SePo1WzeH/wn3d7
         bdWBNdg3CbeFaBVvH8cXbd1h4dTl8w1H7I+ybbtUgs839wz2Zy42xAwk5YeBKqNb4I+1
         slT9TKu1u8O2hkx+aHSpTmSz/hvKeSD2dFjaz188j0ppBofyNRGs1ET+Icv6wgPEDILK
         RgzQ==
X-Gm-Message-State: APjAAAWTarIjd53TG7jFJ8YZy/EihsgpF+wCv3OuLJvVaPFPI92jGAyE
        bNY0WsTEAF/DE4Pojqb1RtTKUueKpCW7AWiolrM=
X-Google-Smtp-Source: APXvYqyIl9xAGOG4Dv9gUsKlKYBC1e6XhYVcwA4py9BJZof1NgKuj455lQCD42QmQK+XV8GOKiC7eKcKti9WaSF1xvc=
X-Received: by 2002:a92:481d:: with SMTP id v29mr7445801ila.271.1581444216868;
 Tue, 11 Feb 2020 10:03:36 -0800 (PST)
MIME-Version: 1.0
References: <158085337582.9445.17682266437583505502.stgit@gimli.home>
 <CALBAE1Oz2u+cmoL8LhEZ-4paXEebKh3DzfWGLQLQx0oaW=tBXw@mail.gmail.com> <20200211100612.65cf2433@w520.home>
In-Reply-To: <20200211100612.65cf2433@w520.home>
From:   Jerin Jacob <jerinjacobk@gmail.com>
Date:   Tue, 11 Feb 2020 23:33:20 +0530
Message-ID: <CALBAE1MrEoCc8Ch6MNUNTsOcZyJnhr+z+iD0VWjHagQsEdBWCw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/7] vfio/pci: SR-IOV support
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dpdk-dev <dev@dpdk.org>,
        mtosatti@redhat.com, Thomas Monjalon <thomas@monjalon.net>,
        Luca Boccassi <bluca@debian.org>,
        "Richardson, Bruce" <bruce.richardson@intel.com>,
        cohuck@redhat.com, Vamsi Attunuru <vattunuru@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 11, 2020 at 10:36 PM Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> On Tue, 11 Feb 2020 16:48:47 +0530
> Jerin Jacob <jerinjacobk@gmail.com> wrote:
>
> > On Wed, Feb 5, 2020 at 4:35 AM Alex Williamson
> > <alex.williamson@redhat.com> wrote:
> > >
> > > There seems to be an ongoing desire to use userspace, vfio-based
> > > drivers for both SR-IOV PF and VF devices.  The fundamental issue
> > > with this concept is that the VF is not fully independent of the PF
> > > driver.  Minimally the PF driver might be able to deny service to the
> > > VF, VF data paths might be dependent on the state of the PF device,
> > > or the PF my have some degree of ability to inspect or manipulate the
> > > VF data.  It therefore would seem irresponsible to unleash VFs onto
> > > the system, managed by a user owned PF.
> > >
> > > We address this in a few ways in this series.  First, we can use a bus
> > > notifier and the driver_override facility to make sure VFs are bound
> > > to the vfio-pci driver by default.  This should eliminate the chance
> > > that a VF is accidentally bound and used by host drivers.  We don't
> > > however remove the ability for a host admin to change this override.
> > >
> > > The next issue we need to address is how we let userspace drivers
> > > opt-in to this participation with the PF driver.  We do not want an
> > > admin to be able to unwittingly assign one of these VFs to a tenant
> > > that isn't working in collaboration with the PF driver.  We could use
> > > IOMMU grouping, but this seems to push too far towards tightly coupled
> > > PF and VF drivers.  This series introduces a "VF token", implemented
> > > as a UUID, as a shared secret between PF and VF drivers.  The token
> > > needs to be set by the PF driver and used as part of the device
> > > matching by the VF driver.  Provisions in the code also account for
> > > restarting the PF driver with active VF drivers, requiring the PF to
> > > use the current token to re-gain access to the PF.
> >
> > Thanks Alex for the series. DPDK realizes this use-case through, an out of
> > tree igb_uio module, for non VFIO devices. Supporting this use case, with
> > VFIO, will be a great enhancement for DPDK as we are planning to
> > get rid of out of tree modules any focus only on userspace aspects.
> >
> > From the DPDK perspective, we have following use-cases
> >
> > 1) VF representer or OVS/vSwitch  use cases where
> > DPDK PF acts as an HW switch to steer traffic to VF
> > using the rte_flow library backed by HW CAMs.
> >
> > 2) Unlike, other PCI class of devices, Network class of PCIe devices
> > would have additional
> > capability on the PF devices such as promiscuous mode support etc
> > leverage that in DPDK
> > PF and VF use cases.
> >
> > That would boil down to the use of the following topology.
> > a)  PF bound to DPDK/VFIO  and  VF bound to Linux
> > b)  PF bound to DPDK/VFIO  and  VF bound to DPDK/VFIO
> >
> > Tested the use case (a) and it works this patch. Tested use case(b), it
> > works with patch provided both PF and VF under the same application.
> >
> > Regarding the use case where  PF bound to DPDK/VFIO and
> > VF bound to DPDK/VFIO are _two different_ processes then sharing the UUID
> > will be a little tricky thing in terms of usage. But if that is the
> > purpose of bringing
> > UUID to the equation then it fine.
> >
> > Overall this series looks good to me.  We can test the next non-RFC
> > series and give
> > Tested-by by after testing with DPDK.
>
> Thanks Jerin, that's great feedback.  For case b), it is rather the
> intention of the shared VF token proposed here that it imposes some
> small barrier in validating the collaboration between the PF and VF
> drivers.  In a trusted environment, a common UUID might be exposed in a
> shared file and the same token could be used by all PFs and VFs on the
> system, or datacenter.  The goal is simply to make sure the
> collaboration is explicit, I don't want to be fielding support issues
> from users assigning PFs and VFs to unrelated VM instances or
> unintentionally creating your scenario a) configuration.

Yes. Makes sense from kernel PoV.

DPDK side, probably we will end in hardcoded UUID value.

The tricky part would DPDK PF and QEMU VF integration case.
I am not sure about that integration( a command-line option for UUID) or
something more sophisticated orchestration. Anyway, it is clear from
kernel side,
Something needs to be sorted with the QEMU community.

> With the positive response from you and Thomas, I'll post a non-RFC
> version and barring any blockers maybe we can get this in for the v5.7
> kernel.  Thanks,

Great.

>
> Alex
>
