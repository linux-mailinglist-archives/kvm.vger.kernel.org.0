Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 204B43A8B83
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 23:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbhFOWBK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 18:01:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25131 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230144AbhFOWBJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Jun 2021 18:01:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623794344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W7cgHmI/gY2s/cNCLnCs84lkX84ZA7FhfJX6tc1qG9M=;
        b=hoorowNG4iE9Flpu++CFnonczrb5NRbpca3+9WFQ6KZvs/JMQn4Ow1V87AuAVuRIphCkhM
        +4oh7XTZ4bdG0vqUE8hbWI75NyTyOnVhtixZFE7GA9JZpHKhbLjXW/dAt9rCrJARdxi6nE
        nLLsyNvSTFpqo+PlFMLUYVkEqnrwcdg=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-568-pcK2eNZbONqbX0UZi_zGJA-1; Tue, 15 Jun 2021 17:59:03 -0400
X-MC-Unique: pcK2eNZbONqbX0UZi_zGJA-1
Received: by mail-oo1-f72.google.com with SMTP id l13-20020a4a350d0000b029024a622ceb18so281654ooa.19
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 14:59:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=W7cgHmI/gY2s/cNCLnCs84lkX84ZA7FhfJX6tc1qG9M=;
        b=kx9B5QDYPB30OO+lFal0V8pmW244HDjUZN7sa+Bl66kdjHxPbUotEYRDRNF9Ykyjlt
         fdy6oWEapwSBWWH59wZiZV/Zgub9xbDhK29T9tooBM1tg9rIytpWnEh1BtOxhdEGupX4
         Msm9WHPOQJBjsvz/m/6CPOMB0l2Y5wum3G+lo+c2ZUZp4CpMlcJ2OQbhGINVa25d7oCy
         bViA3iHL9ivukE446clEL2edugBOCgrrKjKs6Isjyrt8cOazsTzoigrdb/1I3eYWG6Mo
         H0P4HhapbP3E7h2EWLeaaIsYJ/r0XExwEvotihQYXUkBx0cQg5GMqOTHQuD1z5iC2rMH
         m3PQ==
X-Gm-Message-State: AOAM532S57/VDBTq9aHc1LfHWwOsoIWy1TgxXhDBDLUknooI7JDt3gtx
        jOoCaW/vDjvFg4y5vS4/OTTBW6NFZauGXg1aOuujNZy0/rgMDs0lbHCveUCLUbu+iMbPLjl3htd
        d0Wozo7tmIUwl
X-Received: by 2002:a54:448f:: with SMTP id v15mr4802884oiv.18.1623794342551;
        Tue, 15 Jun 2021 14:59:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxzgoUZm5iWJHlHHKTYYvgOHDjaVmus83U433QE/SuvDL7VLCWAmMP+Y3MsN2kn+ubYK7kwPA==
X-Received: by 2002:a54:448f:: with SMTP id v15mr4802866oiv.18.1623794342194;
        Tue, 15 Jun 2021 14:59:02 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id v14sm58471ote.15.2021.06.15.14.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 14:59:01 -0700 (PDT)
Date:   Tue, 15 Jun 2021 15:59:00 -0600
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
Message-ID: <20210615155900.51f09c15.alex.williamson@redhat.com>
In-Reply-To: <20210615204216.GY1002214@nvidia.com>
References: <20210603160809.15845-10-mgurtovoy@nvidia.com>
        <20210608152643.2d3400c1.alex.williamson@redhat.com>
        <20210608224517.GQ1002214@nvidia.com>
        <20210608192711.4956cda2.alex.williamson@redhat.com>
        <117a5e68-d16e-c146-6d37-fcbfe49cb4f8@nvidia.com>
        <20210614124250.0d32537c.alex.williamson@redhat.com>
        <70a1b23f-764d-8b3e-91a4-bf5d67ac9f1f@nvidia.com>
        <20210615090029.41849d7a.alex.williamson@redhat.com>
        <20210615150458.GR1002214@nvidia.com>
        <20210615102049.71a3c125.alex.williamson@redhat.com>
        <20210615204216.GY1002214@nvidia.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 15 Jun 2021 17:42:16 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Jun 15, 2021 at 10:20:49AM -0600, Alex Williamson wrote:
> > On Tue, 15 Jun 2021 12:04:58 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Tue, Jun 15, 2021 at 09:00:29AM -0600, Alex Williamson wrote:
> > >   
> > > > "vfio" override in PCI-core plays out for other override types.  Also I
> > > > don't think dynamic IDs should be handled uniquely, new_id_store()
> > > > should gain support for flags and userspace should be able to add new
> > > > dynamic ID with override-only matches to the table.  Thanks,    
> > > 
> > > Why? Once all the enforcement is stripped out the only purpose of the
> > > new flag is to signal a different prepration of modules.alias - which
> > > won't happen for the new_id path anyhow  
> > 
> > Because new_id allows the admin to insert a new pci_device_id which has
> > been extended to include a flags field and intentionally handling
> > dynamic IDs differently from static IDs seems like generally a bad
> > thing.    
> 
> I'd agree with you if there was a functional difference at runtime,
> but since that was all removed, I don't think we should touch new_id.
> 
> This ends up effectively being only a kbuild related patch that
> changes how modules.alias is built.

But it wasn't all removed.  The proposal had:

 a) Short circuit the dynamic ID match
 b) Fail a driver-override-only match without a driver_override
 c) Fail a non-driver-override-only match with a driver_override

Max is only proposing removing c).

b) alone is a functional, runtime difference.  As per my previous
example, think about using it as effectively an anti-match.  Userspace
can create dynamic entries that will be matched before static entries
that can demote a driver to not be able to bind to a device
automatically.  That's functional and useful, I can't think of any
other way we have to effectively remove a static match entry from a
driver.  Thanks,

Alex

