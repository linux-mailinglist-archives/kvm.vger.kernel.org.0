Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E131830C51F
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 17:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235242AbhBBQM3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 11:12:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47264 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236108AbhBBQJV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 11:09:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612282074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O71cDLBuABlq68uxjVA8PNdzcXK2MNKOvfY02eC6730=;
        b=SwU9WeVtF5xuYENdDa51Qt/TdquUpwTiXj8L0FLETbzk5tDCtl69Q9w5NOv+Ns24KnAjy/
        v31/8ExGcCrGp89zoyiPoSt4ki4vdXkLHmMcpCZyJMusFo0d9/zt3kXuqebQk1DJDn+cRx
        sPowg4MbAAbBwX5wFH0QFxZbhdUgJeU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-wKGR_R_0O4Ke0pcKG9bafg-1; Tue, 02 Feb 2021 11:07:50 -0500
X-MC-Unique: wKGR_R_0O4Ke0pcKG9bafg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5377C10C3C9A;
        Tue,  2 Feb 2021 16:07:06 +0000 (UTC)
Received: from gondolin (ovpn-113-169.ams2.redhat.com [10.36.113.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 621C519C71;
        Tue,  2 Feb 2021 16:07:02 +0000 (UTC)
Date:   Tue, 2 Feb 2021 17:06:59 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>, jgg@nvidia.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        liranl@nvidia.com, oren@nvidia.com, tzahio@nvidia.com,
        leonro@nvidia.com, yarong@nvidia.com, aviadye@nvidia.com,
        shahafs@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, gmataev@nvidia.com, cjia@nvidia.com,
        yishaih@nvidia.com, aik@ozlabs.ru
Subject: Re: [PATCH 8/9] vfio/pci: use x86 naming instead of igd
Message-ID: <20210202170659.1c62a9e8.cohuck@redhat.com>
In-Reply-To: <20210201114230.37c18abd@omen.home.shazbot.org>
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
        <20210201162828.5938-9-mgurtovoy@nvidia.com>
        <20210201181454.22112b57.cohuck@redhat.com>
        <599c6452-8ba6-a00a-65e7-0167f21eac35@linux.ibm.com>
        <20210201114230.37c18abd@omen.home.shazbot.org>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 1 Feb 2021 11:42:30 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Mon, 1 Feb 2021 12:49:12 -0500
> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> 
> > On 2/1/21 12:14 PM, Cornelia Huck wrote:  
> > > On Mon, 1 Feb 2021 16:28:27 +0000
> > > Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
> > >     
> > >> This patch doesn't change any logic but only align to the concept of
> > >> vfio_pci_core extensions. Extensions that are related to a platform
> > >> and not to a specific vendor of PCI devices should be part of the core
> > >> driver. Extensions that are specific for PCI device vendor should go
> > >> to a dedicated vendor vfio-pci driver.    
> > > 
> > > My understanding is that igd means support for Intel graphics, i.e. a
> > > strict subset of x86. If there are other future extensions that e.g.
> > > only make sense for some devices found only on AMD systems, I don't
> > > think they should all be included under the same x86 umbrella.
> > > 
> > > Similar reasoning for nvlink, that only seems to cover support for some
> > > GPUs under Power, and is not a general platform-specific extension IIUC.
> > > 
> > > We can arguably do the zdev -> s390 rename (as zpci appears only on
> > > s390, and all PCI devices will be zpci on that platform), although I'm
> > > not sure about the benefit.    
> > 
> > As far as I can tell, there isn't any benefit for s390 it's just 
> > "re-branding" to match the platform name rather than the zdev moniker, 
> > which admittedly perhaps makes it more clear to someone outside of s390 
> > that any PCI device on s390 is a zdev/zpci type, and thus will use this 
> > extension to vfio_pci(_core).  This would still be true even if we added 
> > something later that builds atop it (e.g. a platform-specific device 
> > like ism-vfio-pci).  Or for that matter, mlx5 via vfio-pci on s390x uses 
> > these zdev extensions today and would need to continue using them in a 
> > world where mlx5-vfio-pci.ko exists.
> > 
> > I guess all that to say: if such a rename matches the 'grand scheme' of 
> > this design where we treat arch-level extensions to vfio_pci(_core) as 
> > "vfio_pci_(arch)" then I'm not particularly opposed to the rename.  But 
> > by itself it's not very exciting :)  
> 
> This all seems like the wrong direction to me.  The goal here is to
> modularize vfio-pci into a core library and derived vendor modules that
> make use of that core library.  If existing device specific extensions
> within vfio-pci cannot be turned into vendor modules through this
> support and are instead redefined as platform specific features of the
> new core library, that feels like we're already admitting failure of
> this core library to support known devices, let alone future devices.
> 
> IGD is a specific set of devices.  They happen to rely on some platform
> specific support, whose availability should be determined via the
> vendor module probe callback.  Packing that support into an "x86"
> component as part of the core feels not only short sighted, but also
> avoids addressing the issues around how userspace determines an optimal
> module to use for a device.

Hm, it seems that not all current extensions to the vfio-pci code are
created equal.

IIUC, we have igd and nvlink, which are sets of devices that only show
up on x86 or ppc, respectively, and may rely on some special features
of those architectures/platforms. The important point is that you have
a device identifier that you can match a driver against.

On the other side, we have the zdev support, which both requires s390
and applies to any pci device on s390. If we added special handling for
ISM on s390, ISM would be in a category similar to igd/nvlink.

Now, if somebody plugs a mlx5 device into an s390, we would want both
the zdev support and the specialized mlx5 driver. Maybe zdev should be
some kind of library that can be linked into normal vfio-pci, into
vfio-pci-mlx5, and a hypothetical vfio-pci-ism? You always want zdev on
s390 (if configured into the kernel).

