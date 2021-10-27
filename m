Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFE843C983
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 14:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240257AbhJ0MY5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 08:24:57 -0400
Received: from ssh.movementarian.org ([139.162.205.133]:58822 "EHLO
        movementarian.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S240243AbhJ0MY4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Oct 2021 08:24:56 -0400
Received: from movement by movementarian.org with local (Exim 4.94)
        (envelope-from <movement@movementarian.org>)
        id 1mfhwq-002PuS-9X; Wed, 27 Oct 2021 13:22:28 +0100
Date:   Wed, 27 Oct 2021 13:22:28 +0100
From:   John Levon <levon@movementarian.org>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Elena <elena.ufimtseva@oracle.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, mst@redhat.com, john.g.johnson@oracle.com,
        dinechin@redhat.com, cohuck@redhat.com, jasowang@redhat.com,
        felipe@nutanix.com, jag.raman@oracle.com, eafanasova@gmail.com
Subject: Re: MMIO/PIO dispatch file descriptors (ioregionfd) design discussion
Message-ID: <YXlEhCYAJuhsVwDv@movementarian.org>
References: <88ca79d2e378dcbfb3988b562ad2c16c4f929ac7.camel@gmail.com>
 <YWUeZVnTVI7M/Psr@heatpipe>
 <YXamUDa5j9uEALYr@stefanha-x1.localdomain>
 <20211025152122.GA25901@nuker>
 <YXhQk/Sh0nLOmA2n@movementarian.org>
 <YXkmx3V0VklA6qHl@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXkmx3V0VklA6qHl@stefanha-x1.localdomain>
X-Url:  http://www.movementarian.org/
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 27, 2021 at 11:15:35AM +0100, Stefan Hajnoczi wrote:

> > > I like this approach as well.
> > > As you have mentioned, the device emulation code with first approach
> > > does have to how to handle the region accesses. The second approach will
> > > make things more transparent. Let me see how can I modify what there is
> > > there now and may ask further questions.
> > 
> > Sorry I'm a bit late to this discussion, I'm not clear on the above WRT
> > vfio-user. If an ioregionfd has to cover a whole BAR0 (?), how would this
> > interact with partly-mmap()able regions like we do with SPDK/vfio-user/NVMe?
> 
> The ioregionfd doesn't need to cover an entire BAR. QEMU's MemoryRegions
> form a hierarchy, so it's possible to sub-divide the BAR into several
> MemoryRegions.

I think you're saying that when vfio-user client in qemu calls
VFIO_USER_DEVICE_GET_REGION_IO_FDS, it would create a sub-MR corresponding to
each one, before asking KVM to configure them?

thanks
john
