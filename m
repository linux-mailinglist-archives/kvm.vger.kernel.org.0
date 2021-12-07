Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6628A46C09D
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 17:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239581AbhLGQ0O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 11:26:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57372 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239076AbhLGQ0N (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 11:26:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638894163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5dWEJ9c8++LVXaHGOhvY7UvwYL58fanu4ep9vZhGWL4=;
        b=RYp6nhVkfR4bEZqVIufNopvmikVkVUSQwmOnGxdtZZ0Pg75pvi/R0Tmhdo1NgnsHHee1fn
        rrcdMcsOcal6XsZ1gFGOJOSo9WK66TlQg54lom9ITNgVZPGWFELukuCe0td5CQsIp17YCw
        UXn3QfULfY9qErQeh1kDswm+RuI0qJ0=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-DsUjmGzaOpi-tMPhazoB-Q-1; Tue, 07 Dec 2021 11:22:41 -0500
X-MC-Unique: DsUjmGzaOpi-tMPhazoB-Q-1
Received: by mail-oi1-f199.google.com with SMTP id y20-20020acaaf14000000b002a817a23a1eso10786452oie.23
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 08:22:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5dWEJ9c8++LVXaHGOhvY7UvwYL58fanu4ep9vZhGWL4=;
        b=tipUjDSHgkpIg+QV0KpsmR2DHDulC7cyr/FCsX0zWtvwR0OXhCQiYAEl4qnFZU4nMz
         94vxsO3h760Jl62/0YqHdFKnXAJKW7PYoV0vK0BoCe8qqK2WWl/oHniqISAV8o+p7ms7
         le6yNRidq5GbV6p6uzbBes+x2NpwIipemBg2UPa6lXMYhIOx5Ll9wHn0hXrypSpgj3gr
         OZPVZMOEjD1BpYA7cPEnfkPiPSwFtGRflmnpGDvHUNxzduVls8sjbPn3qEhyNbn6/g8L
         QzBZ7kMJlFIneBnV/L0fddMxt3AiFoaSdAutCikG3uHZniAOKguhC7o1Phbb8WxYDI0l
         ZNvw==
X-Gm-Message-State: AOAM530xbGNWKHhRWPggGToSoeu8mPm8CeBPe07SSI4jnMNsnyMvlV2q
        8olt1fp65HSLuKuHP9sDn0vCQklViY+7nKu/hEdgD8e5HVBeO/2y3FJ+ZKfrKLY8g7Euh6B1ylp
        QHb4T/bzLpeRu
X-Received: by 2002:a05:6830:30b7:: with SMTP id g23mr35396046ots.159.1638894161030;
        Tue, 07 Dec 2021 08:22:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxZMvcNR04K1Vmy5XZ2Jw3TYWZeIxKkNDyCS+buh3PvL8l52qh5BGivekPK+ZJaMApGq8wAuw==
X-Received: by 2002:a05:6830:30b7:: with SMTP id g23mr35396026ots.159.1638894160784;
        Tue, 07 Dec 2021 08:22:40 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id i16sm23403oig.15.2021.12.07.08.22.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 08:22:40 -0800 (PST)
Date:   Tue, 7 Dec 2021 09:22:39 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC v2] vfio: Documentation for the migration region
Message-ID: <20211207092239.5359f20a.alex.williamson@redhat.com>
In-Reply-To: <20211207153743.GC6385@nvidia.com>
References: <0-v2-45a95932a4c6+37-vfio_mig_doc_jgg@nvidia.com>
        <20211130102611.71394253.alex.williamson@redhat.com>
        <20211130185910.GD4670@nvidia.com>
        <20211130153541.131c9729.alex.williamson@redhat.com>
        <20211201031407.GG4670@nvidia.com>
        <20211201130314.69ed679c@omen>
        <20211201232502.GO4670@nvidia.com>
        <20211203110619.1835e584.alex.williamson@redhat.com>
        <20211206191500.GL4670@nvidia.com>
        <87r1aou1rs.fsf@redhat.com>
        <20211207153743.GC6385@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 7 Dec 2021 11:37:43 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Dec 07, 2021 at 11:50:47AM +0100, Cornelia Huck wrote:
> > On Mon, Dec 06 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Fri, Dec 03, 2021 at 11:06:19AM -0700, Alex Williamson wrote:  
> >   
> > >> This is exactly the sort of "designed for QEMU implementation"
> > >> inter-operability that I want to avoid.  It doesn't take much of a
> > >> crystal ball to guess that gratuitous and redundant device resets
> > >> slow VM instantiation and are a likely target for optimization.  
> > >
> > > Sorry, but Linus's "don't break userspace" forces us to this world.
> > >
> > > It does not matter what is written in text files, only what userspace
> > > actually does and the kernel must accommodate existing userspace going
> > > forward. So once released qemu forms some definitive spec and the
> > > guardrails that limit what we can do going forward.  
> > 
> > But QEMU support is *experimental*, i.e. if it breaks, you get to keep
> > the pieces, things may change in incompatible ways. And it is
> > experimental for good reason!  
> 
> And we can probably make an breakage exception for this existing
> experimental qemu.
> 
> My point was going forward, once we userspace starts to become
> deployed, it doesn't matter what we write in these text files and
> comments. It only matters what deployed userspace actually does.

I think we're losing sight of my concern in designing for QEMU.  The
document included a statement that migration driver writers could rely
on userspace performing a device reset prior to entering the RESUMING
device_state because of an unfounded correlation that QEMU resets the
VM on the way to loading device state.  Now, if we say QEMU does this
thing and we need to support that usage model, I'm 100% on board.  If
we turn it around and say QEMU does this thing therefore migration
drivers can expect exactly this usage model, full stop, that's the
wrong direction.  That is what I'm trying to avoid.

The obvious way to remove the any question of breaking userspace is to
simply rev the migration region sub-type.  The kernel stops exposing any
v1 sub-types, we don't break any userspaces, userspaces need to be
updated to v2 in order to continue having any functionality.  Thanks,

Alex

