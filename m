Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE6D73A8D5B
	for <lists+kvm@lfdr.de>; Wed, 16 Jun 2021 02:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbhFPAY4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 20:24:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47206 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230265AbhFPAY4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Jun 2021 20:24:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623802970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=96W9ObeAa9W1zLErX3qE6onuuwnGd7cmFxO+aYCStiU=;
        b=iTq7vf3JBcp+8PltTpMSQ2sVB+2eY2jkzQ2fRfpjpj1kd6YtIXTCysm7EYgpFHSK5IzAm9
        BsiebksNUC2ovfYhUySyNwftQSj9X8EH5f3makU58s2PvePWGnx5NiYUwotFFgp7uqwhzN
        Ux3yoTYS+OCidd1fn16Ga07VE/qLYQQ=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-YNYqGPiWMaGGonLD8ljXHg-1; Tue, 15 Jun 2021 20:22:49 -0400
X-MC-Unique: YNYqGPiWMaGGonLD8ljXHg-1
Received: by mail-ot1-f72.google.com with SMTP id e28-20020a9d491c0000b02903daf90867beso408833otf.11
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 17:22:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=96W9ObeAa9W1zLErX3qE6onuuwnGd7cmFxO+aYCStiU=;
        b=IjOrgyVVKlFkvbSTUkmLI2Rvm1ax4ZUpuKuw21Tqs827TndyrYE/aCkfIzo4zF6bJt
         TYqfs7ydTr3quUlWpkRbpsjo98SoSKBrZINuO5Vr5zZbtNOr7Wb+3DM7rfhC8HMryGpj
         g4xFTE/N0Rrv/auqJIXF6b4LGOqmioffDLNtPzCgQIRpGYIEN+wIvFriaRvxVvRuXPdS
         zlKI246ua7/EdWfW04O0Ryy0ilXJ5iSTK4CThd+LbBA5rtuqjFvjhsHJaDkD3hxKQpFP
         NHNy0J2Vc+azQFWu65mmDuPQ6pmRk+PtxIqojwRbaLyFS066hdXM3s+DoYzhOXzRY+Ih
         8IUw==
X-Gm-Message-State: AOAM531FqIXOV7tBAMHUxt2yOpvTrd6W5wQvY7/72WXqGLR6/Nn3Xsqn
        10dZ7LVUg2sAeUb4BPk99H7Fcc13CUSTaRYyRHWhvWQyg8+crMdIHgw0ivGcXF0zL32RnluGXwz
        18vmHdCrj2C4L
X-Received: by 2002:a9d:748e:: with SMTP id t14mr1480310otk.354.1623802969012;
        Tue, 15 Jun 2021 17:22:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwUy1kGs8W5keA7171knm6ubxaHOrsyjoknw7ilTs6B57C9ucbR3SJSu0kyztVx1znGvA80VA==
X-Received: by 2002:a9d:748e:: with SMTP id t14mr1480295otk.354.1623802968818;
        Tue, 15 Jun 2021 17:22:48 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id l10sm135120otj.17.2021.06.15.17.22.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 17:22:48 -0700 (PDT)
Date:   Tue, 15 Jun 2021 18:22:45 -0600
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
Message-ID: <20210615182245.54944509.alex.williamson@redhat.com>
In-Reply-To: <20210615233257.GB1002214@nvidia.com>
References: <117a5e68-d16e-c146-6d37-fcbfe49cb4f8@nvidia.com>
        <20210614124250.0d32537c.alex.williamson@redhat.com>
        <70a1b23f-764d-8b3e-91a4-bf5d67ac9f1f@nvidia.com>
        <20210615090029.41849d7a.alex.williamson@redhat.com>
        <20210615150458.GR1002214@nvidia.com>
        <20210615102049.71a3c125.alex.williamson@redhat.com>
        <20210615204216.GY1002214@nvidia.com>
        <20210615155900.51f09c15.alex.williamson@redhat.com>
        <20210615230017.GZ1002214@nvidia.com>
        <20210615172242.4b2be854.alex.williamson@redhat.com>
        <20210615233257.GB1002214@nvidia.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 15 Jun 2021 20:32:57 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Jun 15, 2021 at 05:22:42PM -0600, Alex Williamson wrote:
> 
> > > > b) alone is a functional, runtime difference.    
> > > 
> > > I would state b) differently:
> > > 
> > > b) Ignore the driver-override-only match entries in the ID table.  
> > 
> > No, pci_match_device() returns NULL if a match is found that is marked
> > driver-override-only and a driver_override is not specified.  That's
> > the same as no match at all.  We don't then go on to search past that
> > match in the table, we fail to bind the driver.  That's effectively an
> > anti-match when there's no driver_override on the device.  
> 
> anti-match isn't the intention. The deployment will have match tables
> where all entires are either flags=0 or are driver-override-only.

I'd expect pci-pf-stub to have one of each, an any-id with
override-only flag and the one device ID currently in the table with
no flag.

> I would say that mixed match tables make driver-override-only into an
> anti-match is actually a minor bug in the patch.
> 
> The series isn't about adding some new anti-match scheme.
> 
> > I understand that's not your intended use case, but I think this allows
> > that and justifies handling a dynamic ID the same as a static ID.
> > Adding a field to pci_device_id, which is otherwise able to be fully
> > specified via new_id, except for this field, feels like a bug.  Thanks,  
> 
> Okay, I see what you are saying clearly now.
> 
> Your example usage seems legit to me, but I really don't want to
> entangle it with this series. It is a seperate idea, it can go as a
> seperate work that uses the new flags and an updated new_id and
> related parts by someone who wants it.
> 
> I hope you'll understand that having NVIDIA Mellanox persue what you
> describe above is just not going to work..

I understand that use case might hit a nerve, but I don't particularly
see why handling static and dynamic IDs consistently wrt to this new
flags field is controversial.  Thanks,

Alex

