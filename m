Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C00B32572E
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 20:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234282AbhBYT5a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 14:57:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38428 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233963AbhBYT4M (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Feb 2021 14:56:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614282885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S/K/VrKxrXT01TTlZtso0/RQCZwrZC1M0l+cQdsWsKQ=;
        b=VecI1qwDcqBzgCi4Jdy4QkdCqq+TMGK0Z8qJ3va+QzzoNKqQQpQAC1lnU+IhWmkElvhu8k
        QELFi5U8eyRMP0bMmCGDVb0C+tcmLdZh4qZNaQzeA5gdAE7OO+jnvLEfYaRPvenKvPHFkA
        mG9h15/dIkfM+SMD1o0W54xlKdeIgRw=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-544-c5l8Eao1PgKFcWpemMci2A-1; Thu, 25 Feb 2021 14:54:43 -0500
X-MC-Unique: c5l8Eao1PgKFcWpemMci2A-1
Received: by mail-qk1-f199.google.com with SMTP id t6so1215180qkt.14
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 11:54:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S/K/VrKxrXT01TTlZtso0/RQCZwrZC1M0l+cQdsWsKQ=;
        b=STciGOGK3VElYN039DL5kE4KX5hutOubqPp/rOoPdV7kvIQ4F06OH3GyjZBA+sEeQd
         hZauJwoqY1HOmYYmZQx3+6l+XuhCHkOiLEoXoCGuhrDIfbBwLU3TpK1eZW7uIMHBFnGn
         YoFEQOTyTjIp6MfpzGaB+e9To8UILdAtNrISHyX0pOyAZuAf5fz6AcKxCQwXm5CdJoXf
         tIHNtHYXD291dq00m2fD2XE3btKsBHFAMB4ZXrJfmuQV3+DMzfjH55fOx+upFfM75ltc
         75xC8n3wKtIKgqVI4295DDAbm8IPWdKxzCMoC2P7tIK2OMv2W58jROo+nKv+GDgfqqVM
         wsVw==
X-Gm-Message-State: AOAM530AbS4+5nWCtDrABntpHukX3zC9wp7aycQm8vQyWEs+5EX9HoiG
        7cHj3lSrgpK64KVTqZUAN4YguHk1DZmHMQJPxTvC/4P7gDmHACy/uELg1fL1OnopekqfKokhzMm
        oW4HwOKQMg8l8
X-Received: by 2002:a37:a5d0:: with SMTP id o199mr4371055qke.388.1614282883182;
        Thu, 25 Feb 2021 11:54:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzOj3Bwx+g9itY6ExJwhnXGg3VJQLOpBP9+WHxYrYR1Dl+bZXY5wtEDoB1HSpKdCihKcMr18w==
X-Received: by 2002:a37:a5d0:: with SMTP id o199mr4371040qke.388.1614282882987;
        Thu, 25 Feb 2021 11:54:42 -0800 (PST)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-25-174-95-95-253.dsl.bell.ca. [174.95.95.253])
        by smtp.gmail.com with ESMTPSA id p10sm4705606qke.92.2021.02.25.11.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 11:54:42 -0800 (PST)
Date:   Thu, 25 Feb 2021 14:54:40 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 10/10] vfio/type1: Register device notifier
Message-ID: <20210225195440.GG250483@xz-x1>
References: <161401167013.16443.8389863523766611711.stgit@gimli.home>
 <161401275279.16443.6350471385325897377.stgit@gimli.home>
 <20210222175523.GQ4247@nvidia.com>
 <20210224145508.1f0edb06@omen.home.shazbot.org>
 <20210225002216.GQ4247@nvidia.com>
 <20210225175457.GD250483@xz-x1>
 <20210225181945.GT4247@nvidia.com>
 <20210225190646.GE250483@xz-x1>
 <20210225191714.GU4247@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210225191714.GU4247@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 25, 2021 at 03:17:14PM -0400, Jason Gunthorpe wrote:
> It is a use-after-free. Once the PFN is programmed into the IOMMU it
> becomes completely divorced from the VMA. Remember there is no
> pin_user_page here, so the PFN has no reference count.
> 
> If the owner of the VMA decided to zap it or otherwise then the IOMMU
> access keeps going - but now the owner thinks the PFN is free'd and
> nobody is referencing it. Goes bad.

Sounds reasonable.  Thanks,

-- 
Peter Xu

