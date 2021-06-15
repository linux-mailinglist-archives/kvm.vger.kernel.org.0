Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B96723A8C68
	for <lists+kvm@lfdr.de>; Wed, 16 Jun 2021 01:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbhFOXY4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 19:24:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49512 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231403AbhFOXYy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Jun 2021 19:24:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623799369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LXUq5cb1UWu1BCLlmGyskR+e5MH/GTRwiZlW5p72XDU=;
        b=TewOlL+kSD9AyTFEZdJZtHbf2XA4bdUzcTqC7GJwazEpFbyr8fu+COCD3nKDl+8OfGWlmK
        3SmnCT86Jj+Ocl0BEfSfhYudnkTRRrVNGABi3nXXl+oIsWZBkGoPtfQKByYrDtcVlWViRx
        0PBu6M3zsPysWXTDk5NZo4CtkT7dswA=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-85-YIMdWomQN9Cl_G_xCr3M9Q-1; Tue, 15 Jun 2021 19:22:46 -0400
X-MC-Unique: YIMdWomQN9Cl_G_xCr3M9Q-1
Received: by mail-ot1-f72.google.com with SMTP id 35-20020a9d03260000b029040539236725so336583otv.2
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 16:22:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=LXUq5cb1UWu1BCLlmGyskR+e5MH/GTRwiZlW5p72XDU=;
        b=s4WdWp0j96EZMNbfSYP7f+TJ8EgdrWYUp1+DfyjT5D1C0+1/llc6kiJGSpwSLQac9j
         kW03ygEgChx8UO3M737SzXgaIkiGhJCYNQ2+NOXW+l6lcsi0FGLY7biUNYZBlb63S2F/
         yETQPrixSvWvYO+M4HQxerBMAq2YiXOYFQUO0t5NyrkXHTSY3bTzsY+to0ZKePrviFSc
         ZDVBye2nSLGUEjdLJC7VHh/r7AB0AIOknvlMANznRAAzLZiygxnhJkAVg6hVKitK8Sdt
         Pi2Q+Ai8lS4wzXGXed5E/xylvRzkQy+nfo8AexmZGNXFK7b5czvM1QSR0fYWnJZGCK+L
         whrw==
X-Gm-Message-State: AOAM533Y6Fm0WUBmJIVTr1uLn0QNUNnbuMY+MkS5iDRqbgzPTQvOfGue
        nSmd8Iu87AQYZhedp41KzEOqPsCOzvUPlIjg7mN964nFjirraLnh4md8pN5BZ1MHMPhuVd+m6eX
        VtqeDMnU5NRVu
X-Received: by 2002:a05:6808:1482:: with SMTP id e2mr1519063oiw.150.1623799365346;
        Tue, 15 Jun 2021 16:22:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxtpMcQE3vDixojPJ646O+KOAK/rMnaA9TlvDaXP1d75MjQEzIGZCfuYwCxhBANgFA+MjDXWw==
X-Received: by 2002:a05:6808:1482:: with SMTP id e2mr1519037oiw.150.1623799365123;
        Tue, 15 Jun 2021 16:22:45 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id q6sm85178oot.40.2021.06.15.16.22.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 16:22:44 -0700 (PDT)
Date:   Tue, 15 Jun 2021 17:22:42 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Max Gurtovoy <mgurtovoy@nvidia.com>, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        aviadye@nvidia.com, oren@nvidia.com, shahafs@nvidia.com,
        parav@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, cjia@nvidia.com, yishaih@nvidia.com,
        kevin.tian@intel.com, hch@infradead.org, targupta@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, liulongfang@huawei.com,
        yan.y.zhao@intel.com
Subject: Re: [PATCH 09/11] PCI: add matching checks for driver_override
 binding
Message-ID: <20210615172242.4b2be854.alex.williamson@redhat.com>
In-Reply-To: <20210615230017.GZ1002214@nvidia.com>
References: <20210608224517.GQ1002214@nvidia.com>
        <20210608192711.4956cda2.alex.williamson@redhat.com>
        <117a5e68-d16e-c146-6d37-fcbfe49cb4f8@nvidia.com>
        <20210614124250.0d32537c.alex.williamson@redhat.com>
        <70a1b23f-764d-8b3e-91a4-bf5d67ac9f1f@nvidia.com>
        <20210615090029.41849d7a.alex.williamson@redhat.com>
        <20210615150458.GR1002214@nvidia.com>
        <20210615102049.71a3c125.alex.williamson@redhat.com>
        <20210615204216.GY1002214@nvidia.com>
        <20210615155900.51f09c15.alex.williamson@redhat.com>
        <20210615230017.GZ1002214@nvidia.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 15 Jun 2021 20:00:17 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Jun 15, 2021 at 03:59:00PM -0600, Alex Williamson wrote:
> > On Tue, 15 Jun 2021 17:42:16 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Tue, Jun 15, 2021 at 10:20:49AM -0600, Alex Williamson wrote:  
> > > > On Tue, 15 Jun 2021 12:04:58 -0300
> > > > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > > >     
> > > > > On Tue, Jun 15, 2021 at 09:00:29AM -0600, Alex Williamson wrote:
> > > > >     
> > > > > > "vfio" override in PCI-core plays out for other override types.  Also I
> > > > > > don't think dynamic IDs should be handled uniquely, new_id_store()
> > > > > > should gain support for flags and userspace should be able to add new
> > > > > > dynamic ID with override-only matches to the table.  Thanks,      
> > > > > 
> > > > > Why? Once all the enforcement is stripped out the only purpose of the
> > > > > new flag is to signal a different prepration of modules.alias - which
> > > > > won't happen for the new_id path anyhow    
> > > > 
> > > > Because new_id allows the admin to insert a new pci_device_id which has
> > > > been extended to include a flags field and intentionally handling
> > > > dynamic IDs differently from static IDs seems like generally a bad
> > > > thing.      
> > > 
> > > I'd agree with you if there was a functional difference at runtime,
> > > but since that was all removed, I don't think we should touch new_id.
> > > 
> > > This ends up effectively being only a kbuild related patch that
> > > changes how modules.alias is built.  
> > 
> > But it wasn't all removed.  The proposal had:
> > 
> >  a) Short circuit the dynamic ID match
> >  b) Fail a driver-override-only match without a driver_override
> >  c) Fail a non-driver-override-only match with a driver_override
> > 
> > Max is only proposing removing c).
> > 
> > b) alone is a functional, runtime difference.  
> 
> I would state b) differently:
> 
> b) Ignore the driver-override-only match entries in the ID table.

No, pci_match_device() returns NULL if a match is found that is marked
driver-override-only and a driver_override is not specified.  That's
the same as no match at all.  We don't then go on to search past that
match in the table, we fail to bind the driver.  That's effectively an
anti-match when there's no driver_override on the device.

> As if we look at new_id, I can't think of any reason for userspace to
> add an entry to the ID table and then tell the kernel to ignore
> it. If you want the kernel to ignore it then just don't add it in the
> first place.
> 
> Do you have some other scenario in mind?

Sure, what if I have two different GPUs in my system, one works fine
with the FOSS driver, the other requires a 3rd party driver.  I don't
want to blacklist the FOSS driver, but I don't want it to claim the
other GPU.  I can create an anti-match that effectively removes one GPU
from the FOSS driver unless it's bound with a driver_override.

I understand that's not your intended use case, but I think this allows
that and justifies handling a dynamic ID the same as a static ID.
Adding a field to pci_device_id, which is otherwise able to be fully
specified via new_id, except for this field, feels like a bug.  Thanks,

Alex

