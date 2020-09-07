Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8FA825FBD4
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 16:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729698AbgIGOJY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 10:09:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729756AbgIGOI6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Sep 2020 10:08:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03EEB20714;
        Mon,  7 Sep 2020 14:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599487707;
        bh=booZ9KCft0J1xaFhwDEBtifCIVwXTkQmEWPw53bkz+U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FsjiRmJ1BhfkekpBQhB2EZ6JM4FTiz6TnaaFeFlmecBdtKJM63KTRCQRCfEDMBD9A
         XuujBW2FlMZte4GeRNxvgBTQDmM5qmQnC0FiRBFQ/7gDSWMKAnIP6Qkym6jLnaN6H7
         666rCp5hnoFF+hGOZ119OnP6bGYvP2mJ4GFiQRNs=
Date:   Mon, 7 Sep 2020 16:08:41 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        David Duncan <davdunc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>, Karen Noel <knoel@redhat.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>
Subject: Re: [PATCH v8 15/18] nitro_enclaves: Add Makefile for the Nitro
 Enclaves driver
Message-ID: <20200907140841.GB3719869@kroah.com>
References: <20200904173718.64857-1-andraprs@amazon.com>
 <20200904173718.64857-16-andraprs@amazon.com>
 <20200907090011.GC1101646@kroah.com>
 <f5c0f79c-f581-fab5-9a3b-97380ef7fc2a@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5c0f79c-f581-fab5-9a3b-97380ef7fc2a@amazon.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 07, 2020 at 04:35:23PM +0300, Paraschiv, Andra-Irina wrote:
> 
> 
> On 07/09/2020 12:00, Greg KH wrote:
> > 
> > 
> > On Fri, Sep 04, 2020 at 08:37:15PM +0300, Andra Paraschiv wrote:
> > > Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> > > Reviewed-by: Alexander Graf <graf@amazon.com>
> > > ---
> > > Changelog
> > > 
> > > v7 -> v8
> > > 
> > > * No changes.
> > > 
> > > v6 -> v7
> > > 
> > > * No changes.
> > > 
> > > v5 -> v6
> > > 
> > > * No changes.
> > > 
> > > v4 -> v5
> > > 
> > > * No changes.
> > > 
> > > v3 -> v4
> > > 
> > > * No changes.
> > > 
> > > v2 -> v3
> > > 
> > > * Remove the GPL additional wording as SPDX-License-Identifier is
> > >    already in place.
> > > 
> > > v1 -> v2
> > > 
> > > * Update path to Makefile to match the drivers/virt/nitro_enclaves
> > >    directory.
> > > ---
> > >   drivers/virt/Makefile                |  2 ++
> > >   drivers/virt/nitro_enclaves/Makefile | 11 +++++++++++
> > >   2 files changed, 13 insertions(+)
> > >   create mode 100644 drivers/virt/nitro_enclaves/Makefile
> > > 
> > > diff --git a/drivers/virt/Makefile b/drivers/virt/Makefile
> > > index fd331247c27a..f28425ce4b39 100644
> > > --- a/drivers/virt/Makefile
> > > +++ b/drivers/virt/Makefile
> > > @@ -5,3 +5,5 @@
> > > 
> > >   obj-$(CONFIG_FSL_HV_MANAGER) += fsl_hypervisor.o
> > >   obj-y                                += vboxguest/
> > > +
> > > +obj-$(CONFIG_NITRO_ENCLAVES) += nitro_enclaves/
> > > diff --git a/drivers/virt/nitro_enclaves/Makefile b/drivers/virt/nitro_enclaves/Makefile
> > > new file mode 100644
> > > index 000000000000..e9f4fcd1591e
> > > --- /dev/null
> > > +++ b/drivers/virt/nitro_enclaves/Makefile
> > > @@ -0,0 +1,11 @@
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +#
> > > +# Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
> > > +
> > > +# Enclave lifetime management support for Nitro Enclaves (NE).
> > > +
> > > +obj-$(CONFIG_NITRO_ENCLAVES) += nitro_enclaves.o
> > > +
> > > +nitro_enclaves-y := ne_pci_dev.o ne_misc_dev.o
> > > +
> > > +ccflags-y += -Wall
> > That flag is _really_ risky over time, are you _SURE_ that all new
> > versions of clang and gcc will never produce any warnings?  People work
> > to fix up build warnings quite quickly for new compilers, you shouldn't
> > prevent the code from being built at all just for that, right?
> > 
> 
> That would also need Werror, to have warnings treated as errors and prevent
> building the codebase. If it's about something more, just let me know.

No, you are right, Werror would be needed here too.

W=1 gives you -Wall if you really want that, no need to add it by hand.

thanks,

greg k-h
