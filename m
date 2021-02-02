Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C1530C8BD
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 19:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238118AbhBBR7l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 12:59:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57947 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237787AbhBBR4b (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 12:56:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612288504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gFJ77sSEB+f8Sj3B0GeEC2N3cMa86PYsToA2l7/Kaqo=;
        b=LRw1Gyr8w4sbHjh41M2OlYzMQJDVfDewWIfpB6tB6FYTNdnLEe34xjKup2V8gdRwSedc5U
        VtmPWLkU6nNFezXeCaXBKArj5VwgDQ+tTPcZ/aLB1aQazLdyLWjfFJl/1O9sgKQ5amrq6s
        JTSFH2a2qR6wE5GakSsK54QYuPGY14w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-7p1PFqffPMSlCCwUTHedbQ-1; Tue, 02 Feb 2021 12:55:00 -0500
X-MC-Unique: 7p1PFqffPMSlCCwUTHedbQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D55F5107ACE4;
        Tue,  2 Feb 2021 17:54:57 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AAD7110016FD;
        Tue,  2 Feb 2021 17:54:56 +0000 (UTC)
Date:   Tue, 2 Feb 2021 10:54:55 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>, <jgg@nvidia.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <liranl@nvidia.com>, <oren@nvidia.com>, <tzahio@nvidia.com>,
        <leonro@nvidia.com>, <yarong@nvidia.com>, <aviadye@nvidia.com>,
        <shahafs@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <gmataev@nvidia.com>, <cjia@nvidia.com>,
        <yishaih@nvidia.com>, <aik@ozlabs.ru>
Subject: Re: [PATCH 8/9] vfio/pci: use x86 naming instead of igd
Message-ID: <20210202105455.5a358980@omen.home.shazbot.org>
In-Reply-To: <a413334c-3319-c6a3-3d8a-0bb68a10b9c1@nvidia.com>
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
        <20210201162828.5938-9-mgurtovoy@nvidia.com>
        <20210201181454.22112b57.cohuck@redhat.com>
        <599c6452-8ba6-a00a-65e7-0167f21eac35@linux.ibm.com>
        <20210201114230.37c18abd@omen.home.shazbot.org>
        <20210202170659.1c62a9e8.cohuck@redhat.com>
        <a413334c-3319-c6a3-3d8a-0bb68a10b9c1@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2 Feb 2021 19:41:16 +0200
Max Gurtovoy <mgurtovoy@nvidia.com> wrote:

> On 2/2/2021 6:06 PM, Cornelia Huck wrote:
> > On Mon, 1 Feb 2021 11:42:30 -0700
> > Alex Williamson <alex.williamson@redhat.com> wrote:
> >  
> >> On Mon, 1 Feb 2021 12:49:12 -0500
> >> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> >>  
> >>> On 2/1/21 12:14 PM, Cornelia Huck wrote:  
> >>>> On Mon, 1 Feb 2021 16:28:27 +0000
> >>>> Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
> >>>>        
> >>>>> This patch doesn't change any logic but only align to the concept of
> >>>>> vfio_pci_core extensions. Extensions that are related to a platform
> >>>>> and not to a specific vendor of PCI devices should be part of the core
> >>>>> driver. Extensions that are specific for PCI device vendor should go
> >>>>> to a dedicated vendor vfio-pci driver.  
> >>>> My understanding is that igd means support for Intel graphics, i.e. a
> >>>> strict subset of x86. If there are other future extensions that e.g.
> >>>> only make sense for some devices found only on AMD systems, I don't
> >>>> think they should all be included under the same x86 umbrella.
> >>>>
> >>>> Similar reasoning for nvlink, that only seems to cover support for some
> >>>> GPUs under Power, and is not a general platform-specific extension IIUC.
> >>>>
> >>>> We can arguably do the zdev -> s390 rename (as zpci appears only on
> >>>> s390, and all PCI devices will be zpci on that platform), although I'm
> >>>> not sure about the benefit.  
> >>> As far as I can tell, there isn't any benefit for s390 it's just
> >>> "re-branding" to match the platform name rather than the zdev moniker,
> >>> which admittedly perhaps makes it more clear to someone outside of s390
> >>> that any PCI device on s390 is a zdev/zpci type, and thus will use this
> >>> extension to vfio_pci(_core).  This would still be true even if we added
> >>> something later that builds atop it (e.g. a platform-specific device
> >>> like ism-vfio-pci).  Or for that matter, mlx5 via vfio-pci on s390x uses
> >>> these zdev extensions today and would need to continue using them in a
> >>> world where mlx5-vfio-pci.ko exists.
> >>>
> >>> I guess all that to say: if such a rename matches the 'grand scheme' of
> >>> this design where we treat arch-level extensions to vfio_pci(_core) as
> >>> "vfio_pci_(arch)" then I'm not particularly opposed to the rename.  But
> >>> by itself it's not very exciting :)  
> >> This all seems like the wrong direction to me.  The goal here is to
> >> modularize vfio-pci into a core library and derived vendor modules that
> >> make use of that core library.  If existing device specific extensions
> >> within vfio-pci cannot be turned into vendor modules through this
> >> support and are instead redefined as platform specific features of the
> >> new core library, that feels like we're already admitting failure of
> >> this core library to support known devices, let alone future devices.
> >>
> >> IGD is a specific set of devices.  They happen to rely on some platform
> >> specific support, whose availability should be determined via the
> >> vendor module probe callback.  Packing that support into an "x86"
> >> component as part of the core feels not only short sighted, but also
> >> avoids addressing the issues around how userspace determines an optimal
> >> module to use for a device.  
> > Hm, it seems that not all current extensions to the vfio-pci code are
> > created equal.
> >
> > IIUC, we have igd and nvlink, which are sets of devices that only show
> > up on x86 or ppc, respectively, and may rely on some special features
> > of those architectures/platforms. The important point is that you have
> > a device identifier that you can match a driver against.  
> 
> maybe you can supply the ids ?
> 
> Alexey K, I saw you've been working on the NVLINK2 for P9. can you 
> supply the exact ids for that should be bounded to this driver ?
> 
> I'll add it to V3.

As noted previously, if we start adding ids for vfio drivers then we
create conflicts with the native host driver.  We cannot register a
vfio PCI driver that automatically claims devices.  At best, this
NVLink driver and an IGD driver could reject devices that they don't
support, ie. NVIDIA GPUs where there's not the correct platform
provided support or Intel GPUs without an OpRegion.  Thanks,

Alex

