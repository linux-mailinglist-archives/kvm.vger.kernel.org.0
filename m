Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 378AC3F7964
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 17:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241137AbhHYPtJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 11:49:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59051 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241083AbhHYPtJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Aug 2021 11:49:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629906502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YizQ6NoTFaMjwA1alsQBQwk9LeV8zcloPWbOJJ4V0Qc=;
        b=ZDrRLWrVWwr0O1UQPICx10D9eaonIb53wxZNHdQM4mQzsmMfYS5N+geLLwuuS5c6rDgx74
        souA+8ruHQ3Sbe2v7zJHUhyIcwIXCAGOv8Hs0wtboUiujYyuVhYl/Rt/2/luww9yAOLWVt
        GZ+qF6kU2ssQrM2uw87QyQx+W1bdmyI=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175--LuatLvXMa2egY7mo5bvlg-1; Wed, 25 Aug 2021 11:48:21 -0400
X-MC-Unique: -LuatLvXMa2egY7mo5bvlg-1
Received: by mail-oo1-f72.google.com with SMTP id o32-20020a4a95a3000000b0029018f4f7c3so5156553ooi.22
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 08:48:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=YizQ6NoTFaMjwA1alsQBQwk9LeV8zcloPWbOJJ4V0Qc=;
        b=j06mj0lpykaRKEpNrYoLemUOw/UsjD/9h3F6J9fu9/nOXLJXC5ud07oe+rnPhmViSi
         glFJVOKicc8X4iL4GlHIjF6c/rldiEW3Jl50np4OWqnQuZ3TiU4smMklN9nBxoJ82Uw0
         uul/6FCVqlDdAZC14P+88+OSciDCvnyIQ0bWlFxNPKqsJ2kQSQNHCBaicY8XCxeFYW26
         PHQKUh2ELo5Fg12HVfopZHWtZ7VIKxk/z7GGMbwbMflIbYS6MN7rniGxSfP3rHyNzo0B
         tEcTZzobJMcJLWCMi9UKcyUVdWn59t9GaJxhFec3xhdnteLQo6g2Vxf6Fq4rrHULQb8w
         kCfA==
X-Gm-Message-State: AOAM531K/sELr/JzAMo9n+83LWFNMEhNFpA1Mc9Ek6tg+3ebSwVPoIaD
        XmuAh3X7AVpEECgR8e+zjXW3frpEWoLNbAbn7/AVJGoww4K1DXat94/SiH+zpETGQQfoT58BCVf
        QYMPTiJty8klJ
X-Received: by 2002:aca:d696:: with SMTP id n144mr7317702oig.141.1629906500802;
        Wed, 25 Aug 2021 08:48:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJykrAXLh4gT0/5F4GXFkUSUlr6VavsvImrwzOuR1N0//VaqNQr/1i1UFhunk34IldHzJwPAsA==
X-Received: by 2002:aca:d696:: with SMTP id n144mr7317683oig.141.1629906500577;
        Wed, 25 Aug 2021 08:48:20 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id o8sm29340oiw.55.2021.08.25.08.48.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 08:48:20 -0700 (PDT)
Date:   Wed, 25 Aug 2021 09:48:19 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH 01/14] vfio: Move vfio_iommu_group_get() to
 vfio_register_group_dev()
Message-ID: <20210825094819.1f433068.alex.williamson@redhat.com>
In-Reply-To: <20210825124303.GA17334@lst.de>
References: <20210824144649.1488190-1-hch@lst.de>
        <20210824144649.1488190-2-hch@lst.de>
        <20210824142508.3a72fe4a.alex.williamson@redhat.com>
        <20210825124303.GA17334@lst.de>
Organization: Red Hat
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 25 Aug 2021 14:43:03 +0200
Christoph Hellwig <hch@lst.de> wrote:

> On Tue, Aug 24, 2021 at 02:25:08PM -0600, Alex Williamson wrote:
> > I think this turns into the patch below on top of Yishai's
> > vfio-pci-core series.  Please verify.  If you'd like something
> > different, please post an update.  Thanks,  
> 
> The change looks fine to me.  Does that mean you want me to rebase
> on top of the above series?

I wish the answer here was more obvious, but we're still waiting for
PCI and scripts/mod/ acks for that series.  I note however that while
the functionality of other driver's having a userspace driver discovery
mechanism hinges on patches 9 & 10 of Yishai's series, those patches
can also be cleanly moved to the end of the series, or a follow-on
series if necessary, and current vfio-pci binding continues to work.

Should we go ahead and get final reviews for {1-8,11-13} of Yishai's
series to get them in my next branch so we have a consistent base to
work from?  Thanks,

Alex

