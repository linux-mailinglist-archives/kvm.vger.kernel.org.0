Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAE38159573
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 17:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbgBKQ7C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 11:59:02 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30747 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727264AbgBKQ7C (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Feb 2020 11:59:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581440340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y3V+nkHLeOz4JQ099NB1biGKPHWEnceBkoow8w0YGk8=;
        b=IstgnmVrpsUGNPYBWHLE+EE2Ju1+ood/PhSMhmdVBVpANEHbEKPOUSJG/Q1+IbnDHpPssn
        nqGnVRCT8rZKS0RYbnjuE2SHatdqndpvJc98Pt7NgnHHNO9ktfgk0Tq/OOv3WJ4ZDdzoJZ
        vZM5BEU8d121OvfoK1IEIXMrfmI30y4=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-NVTLqG6WMGm-nwskCa4RfA-1; Tue, 11 Feb 2020 11:58:47 -0500
X-MC-Unique: NVTLqG6WMGm-nwskCa4RfA-1
Received: by mail-qv1-f72.google.com with SMTP id g6so7594623qvp.0
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2020 08:58:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y3V+nkHLeOz4JQ099NB1biGKPHWEnceBkoow8w0YGk8=;
        b=nkrcRYqjRiEa9ELTIdQVAtbzFsenJjJ8f9HeYWoYuZ/TEwR/1M/aMZyCpIyCkT36ts
         N1i98n8x5C3Bix2mYdlYufQt9sLHlhkdNtCQiwq24HqmjX3lOUDjH06r3nQ8JvKBzPFr
         nanUOCIVdEOGx+4OZUwgDatzRmmvn76/AoXTQNg5JORhyf6eQ9cPK42mO+uOIy2plJHK
         iS5/qhuDmBhsocpYosRRI688klGRaz9eoAdtnNKEwECV/M8HJLJHLpAqSf5uKpkZ/gie
         0zNEmxtLHb2Elw4nOiEWQ+M2Gy8QNkUTlKzz//uOv8MF88yU5HGRhHcsk0WjyTbXmNOw
         6c9g==
X-Gm-Message-State: APjAAAXqM8pXsbb2YpGYU4Ojs3BkvVvyFa1IPz3cEYrXRzUVQWODNR2W
        MFO1RW1blQ212n4ZDfj0gXcbMI33bXcuZevkxbGfAQ5BvDWQiZQm0JCZKsUjUhC13bMODIx+a1f
        D+x9jDImAj9+8
X-Received: by 2002:ad4:58b3:: with SMTP id ea19mr3818886qvb.80.1581440326849;
        Tue, 11 Feb 2020 08:58:46 -0800 (PST)
X-Google-Smtp-Source: APXvYqw6WqLBlAKM/iCoc2pbfi9NA2KQCOkbT7LG18iuT/xB4amgNLBWMcmfTAyoYSiUyajtafWBUg==
X-Received: by 2002:ad4:58b3:: with SMTP id ea19mr3818859qvb.80.1581440326526;
        Tue, 11 Feb 2020 08:58:46 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id k50sm2554891qtc.90.2020.02.11.08.58.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 08:58:45 -0800 (PST)
Date:   Tue, 11 Feb 2020 11:58:43 -0500
From:   Peter Xu <peterx@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC v3 03/25] hw/iommu: introduce IOMMUContext
Message-ID: <20200211165843.GG984290@xz-x1>
References: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
 <1580300216-86172-4-git-send-email-yi.l.liu@intel.com>
 <20200131040644.GG15210@umbus.fritz.box>
 <A2975661238FB949B60364EF0F2C25743A199306@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A199306@SHSMSX104.ccr.corp.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 31, 2020 at 11:42:13AM +0000, Liu, Yi L wrote:
> > I'm not very clear on the relationship betwen an IOMMUContext and a
> > DualStageIOMMUObject.  Can there be many IOMMUContexts to a
> > DualStageIOMMUOBject?  The other way around?  Or is it just
> > zero-or-one DualStageIOMMUObjects to an IOMMUContext?
> 
> It is possible. As the below patch shows, DualStageIOMMUObject is per vfio
> container. IOMMUContext can be either per-device or shared across devices,
> it depends on vendor specific vIOMMU emulators.

Is there an example when an IOMMUContext can be not per-device?

It makes sense to me to have an object that is per-container (in your
case, the DualStageIOMMUObject, IIUC), then we can connect that object
to a device.  However I'm a bit confused on why we've got two abstract
layers (the other one is IOMMUContext)?  That was previously for the
whole SVA new APIs, now it's all moved over to the other new object,
then IOMMUContext only register/unregister... Can we put the reg/unreg
procedures into DualStageIOMMUObject as well?  Then we drop the
IOMMUContext (or say, keep IOMMUContext and drop DualStageIOMMUObject
but let IOMMUContext to be per-vfio-container, the major difference is
the naming here, say, PASID allocation does not seem to be related to
dual-stage at all).

Besides that, not sure I read it right... but even with your current
series, the container->iommu_ctx will always only be bound to the
first device created within that container, since you've got:

    group = vfio_get_group(groupid, pci_device_iommu_address_space(pdev),
                           pci_device_iommu_context(pdev), errp);

And:

    if (vfio_connect_container(group, as, iommu_ctx, errp)) {
        error_prepend(errp, "failed to setup container for group %d: ",
                      groupid);
        goto close_fd_exit;
    }

The iommu_ctx will be set to container->iommu_ctx if there's no
existing container.

> [RFC v3 10/25] vfio: register DualStageIOMMUObject to vIOMMU
> https://www.spinics.net/lists/kvm/msg205198.html
> 
> Take Intel vIOMMU as an example, there is a per device structure which
> includes IOMMUContext instance and a DualStageIOMMUObject pointer.
> 
> +struct VTDIOMMUContext {
> +    VTDBus *vtd_bus;
> +    uint8_t devfn;
> +    IOMMUContext iommu_context;
> +    DualStageIOMMUObject *dsi_obj;
> +    IntelIOMMUState *iommu_state;
> +};
> https://www.spinics.net/lists/kvm/msg205196.html
> 
> I think this would leave space for vendor specific vIOMMU emulators to
> design their own relationship between an IOMMUContext and a
> DualStageIOMMUObject.

-- 
Peter Xu

