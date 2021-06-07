Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C5939E6F1
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 20:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbhFGTBo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 15:01:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60845 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230494AbhFGTBm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Jun 2021 15:01:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623092390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0ife/jm9NgTe8HtyBunu2/HSrkqZCWtIQ558to+xkpk=;
        b=YZhb6RnRuFifZFYneebaKg1ILMD1SGiR2eG768tXFI2CxbzC/IZwbDKGwZy7/yQccbIm7H
        M56voKaX4CmrO7YUeW+MEssWjMPkH7TYVhHAyVCYTa41/ce8UH+hP4Yvr4W5MFgoHh1Gso
        o+nfZzcfnNRfBYWxzgoyT5w5FTsKCl8=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-OXO-MwdQPj6v8ouFBiXwtg-1; Mon, 07 Jun 2021 14:59:49 -0400
X-MC-Unique: OXO-MwdQPj6v8ouFBiXwtg-1
Received: by mail-oo1-f72.google.com with SMTP id r130-20020a4a37880000b029024987ad471cso4490111oor.17
        for <kvm@vger.kernel.org>; Mon, 07 Jun 2021 11:59:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0ife/jm9NgTe8HtyBunu2/HSrkqZCWtIQ558to+xkpk=;
        b=ps7MKz7Hxbm/cipj55AJ7P9mG5WWf7tumjQJhj8N0ReNrF56FqtoRyIUDhAqSgyZZo
         zPsMdX2gZFguu5yNLnj7Wx3ETQrF+aHUGcbYSTtCEbX7RiMFqb02na5FLjUncRlFUAxT
         sB0ytU4v85p9maL7XoboVyRncIl0LNDW4ShNalwHTytPsEMi65QBuABAtdbza3Nb6iA/
         oYXWbHwPrq/AuL4JYCu5a9Qbrd9ODBC1iEnc2SMx5sBxJwtJmBvOMI6nM6xQrpeDbf+p
         WlV5pNJXfqhRGztPM1Ag4n37OJ1octfwZkobQMaDFP6hjUb4uEI193Co5YO6RgBhaESG
         RYzA==
X-Gm-Message-State: AOAM532QKWRUryu77On5JOaNfnvhNEKJsqWGZuG6KrlQC1qLmqSv/uGu
        V2i+vSKv0vmlGVE+XenInXqrHUYJS52ho/NQeKWUWWUojYpEEz4MRC1lCxsIVE16oiFSmCbY8du
        bF8foA296Mww4
X-Received: by 2002:a4a:b98e:: with SMTP id e14mr14415948oop.82.1623092388651;
        Mon, 07 Jun 2021 11:59:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxhoXmKMGHpe3MLRxm5Hs89CDspIbwCeiZmAq0yRDSAs5fLzu0UTQgxwdz09tDxbh6R4mj+Yw==
X-Received: by 2002:a4a:b98e:: with SMTP id e14mr14415930oop.82.1623092388374;
        Mon, 07 Jun 2021 11:59:48 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id b26sm2221621otf.69.2021.06.07.11.59.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 11:59:47 -0700 (PDT)
Date:   Mon, 7 Jun 2021 12:59:46 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
Message-ID: <20210607125946.056aafa2.alex.williamson@redhat.com>
In-Reply-To: <20210607181858.GM1002214@nvidia.com>
References: <20210604092620.16aaf5db.alex.williamson@redhat.com>
        <815fd392-0870-f410-cbac-859070df1b83@redhat.com>
        <20210604155016.GR1002214@nvidia.com>
        <30e5c597-b31c-56de-c75e-950c91947d8f@redhat.com>
        <20210604160336.GA414156@nvidia.com>
        <2c62b5c7-582a-c710-0436-4ac5e8fd8b39@redhat.com>
        <20210604172207.GT1002214@nvidia.com>
        <20210604152918.57d0d369.alex.williamson@redhat.com>
        <20210604230108.GB1002214@nvidia.com>
        <20210607094148.7e2341fc.alex.williamson@redhat.com>
        <20210607181858.GM1002214@nvidia.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 7 Jun 2021 15:18:58 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Jun 07, 2021 at 09:41:48AM -0600, Alex Williamson wrote:
> > You're calling this an admin knob, which to me suggests a global module
> > option, so are you trying to implement both an administrator and a user
> > policy?  ie. the user can create scenarios where access to wbinvd might
> > be justified by hardware/IOMMU configuration, but can be limited by the
> > admin?  
> 
> Could be a per-device sysfs too. I'm not really sure what is useful
> here.
> 
> > For example I proposed that the ioasidfd would bear the responsibility
> > of a wbinvd ioctl and therefore validate the user's access to enable
> > wbinvd emulation w/ KVM, so I'm assuming this module option lives
> > there.    
> 
> Right, this is what I was thinking
> 
> > What then is "automatic" mode?  The user cannot create a non-coherent
> > IOASID with a non-coherent device if the IOMMU supports no-snoop
> > blocking?  Do they get a failure?  Does it get silently promoted to
> > coherent?  
> 
> "automatic" was just a way to keep the API the same as today. Today if
> the IOMMU can block no-snoop then vfio disables wbinvd. To get the
> same level of security automatic mode would detect that vfio would
> have blocked wbinvd because the IOMMU can do it, and then always block
> it.
> 
> It makes sense if there is an admin knob, as the admin could then move
> to an explict enable/disable to get functionality they can't get
> today.
> 
> > In "disable" mode, I think we're just narrowing the restriction
> > further, a non-coherent capable device cannot be used except in a
> > forced coherent IOASID.  
> 
> I wouldn't say "cannot be used" - just you can't get access to
> wbinvd. 
> 
> It is up to qemu if it wants to proceed or not. There is no issue with
> allowing the use of no-snoop and blocking wbinvd, other than some
> drivers may malfunction. If the user is certain they don't have
> malfunctioning drivers then no issue to go ahead.

A driver that knows how to use the device in a coherent way can
certainly proceed, but I suspect that's not something we can ask of
QEMU.  QEMU has no visibility to the in-use driver and sketchy ability
to virtualize the no-snoop enable bit to prevent non-coherent DMA from
the device.  There might be an experimental ("x-" prefixed) QEMU device
option to allow user override, but QEMU should disallow the possibility
of malfunctioning drivers by default.  If we have devices that probe as
supporting no-snoop, but actually can't generate such traffic, we might
need a quirk list somewhere.

> The current vfio arrangement (automatic) maximized compatability. The
> enable/disable options provide for max performance and max security as
> alternative targets.
> 
> > > It is the strenth of Paolo's model that KVM should not be able to do
> > > optionally less, not more than the process itself can do.  
> > 
> > I think my previous reply was working towards those guidelines.  I feel
> > like we're mostly in agreement, but perhaps reading past each other.  
> 
> Yes, I think I said we were agreeing :)
> 
> > Nothing here convinced me against my previous proposal that the
> > ioasidfd bears responsibility for managing access to a wbinvd ioctl,
> > and therefore the equivalent KVM access.  Whether wbinvd is allowed or
> > no-op'd when the use has access to a non-coherent device in a
> > configuration where the IOMMU prevents non-coherent DMA is maybe still
> > a matter of personal preference.  
> 
> I think it makes the software design much simpler if the security
> check is very simple. Possessing a suitable device in an ioasid fd
> container is enough to flip on the feature and we don't need to track
> changes from that point on. We don't need to revoke wbinvd if the
> ioasid fd changes, for instance. Better to keep the kernel very simple
> in this regard.

You're suggesting that a user isn't forced to give up wbinvd emulation
if they lose access to their device?  I suspect that like we do today,
we'll want to re-evaluate the need for wbinvd on most device changes.
I think this is why the kvm-vfio device holds a vfio group reference;
to make sure a given group can't elevate privileges for multiple
processes.  Thanks,

Alex

