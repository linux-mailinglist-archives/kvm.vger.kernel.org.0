Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32C9332563C
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 20:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233337AbhBYTJR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 14:09:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28511 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233871AbhBYTIV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Feb 2021 14:08:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614280015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0ntq0VlGIcmn4gcxkIRxd3iIu35CFerEbtANCfGiVdM=;
        b=c92gdkub3c/rogDMr0M/hF5HbyhycnKiMhHhW5NCDwiiI+Zq+5vbesRRX+GasOos3BmP/U
        yQtUwhL6q95sIAkqI9j95bM66GpmHRNK9Z+R8GbJLoIAuxxc/b0/0JcdpMb5gpCH13HJMC
        V0kzSjwjwQ2zWC36RpknNjEJpBhNIaE=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-526-ROfyiNDkOnmGCVJc_cwUyg-1; Thu, 25 Feb 2021 14:06:51 -0500
X-MC-Unique: ROfyiNDkOnmGCVJc_cwUyg-1
Received: by mail-qv1-f72.google.com with SMTP id h10so4962477qvf.19
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 11:06:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0ntq0VlGIcmn4gcxkIRxd3iIu35CFerEbtANCfGiVdM=;
        b=X2sPn1MNc1HRgNYp9I5/sV5jfhTqJlG9l5cfP8V3dtzzl5Je8PLW3qHOuGfUFpv0Qe
         uA5/6+gz3uEDfuIZWA5q7oO5TY7NovffnVNgE0tPNy/W1Spz/2rzfBxXaKYkbY78ZLer
         4lOA64SOL/aNtHw48meA9km5d3TOtqOy9qj+1VM0HMua1KtNRo8u0xRhNJEhfohGmRAV
         iAaqQiJkBRJIZjDrMBR3I+7u3AAjFjJ1d/oR8juEKZYOlvrClE6yDqDonm/bYmk/BAzD
         qCSp1X+Nm9gdHSPuvTGgzLc0ggOLhTy2BhyjcKGd1pFfNpMvSNv+sjse022Lw7eOrWzf
         8+NA==
X-Gm-Message-State: AOAM531lALXtNub4Pg3So3KTMLq3JyI4MXcYCwKJIs/MjYgZgeSacV5e
        9+i0PL4q4B41GuEfVUtf6N1OmY6XhkZH39Goq5u59j0l/VbGmGr+eQIKF58+gKeDfb3xG6+aN+w
        F2uya3WOHgI7X
X-Received: by 2002:a37:a183:: with SMTP id k125mr4205722qke.332.1614280011439;
        Thu, 25 Feb 2021 11:06:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxfK+N05IVgdsA0MDZcag+sGz5potbwSbK8mKsg4vfzFYEPeycGT3qjurTXgTTNpmL/fJDJmQ==
X-Received: by 2002:a37:a183:: with SMTP id k125mr4205707qke.332.1614280011193;
        Thu, 25 Feb 2021 11:06:51 -0800 (PST)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-25-174-95-95-253.dsl.bell.ca. [174.95.95.253])
        by smtp.gmail.com with ESMTPSA id j2sm4373993qkk.96.2021.02.25.11.06.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 11:06:50 -0800 (PST)
Date:   Thu, 25 Feb 2021 14:06:46 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 10/10] vfio/type1: Register device notifier
Message-ID: <20210225190646.GE250483@xz-x1>
References: <161401167013.16443.8389863523766611711.stgit@gimli.home>
 <161401275279.16443.6350471385325897377.stgit@gimli.home>
 <20210222175523.GQ4247@nvidia.com>
 <20210224145508.1f0edb06@omen.home.shazbot.org>
 <20210225002216.GQ4247@nvidia.com>
 <20210225175457.GD250483@xz-x1>
 <20210225181945.GT4247@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210225181945.GT4247@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 25, 2021 at 02:19:45PM -0400, Jason Gunthorpe wrote:
> On Thu, Feb 25, 2021 at 12:54:57PM -0500, Peter Xu wrote:
>  
> > I can't say I fully understand the whole rational behind 5cbf3264bc71, but that
> > commit still sounds reasonable to me, since I don't see why VFIO cannot do
> > VFIO_IOMMU_MAP_DMA upon another memory range that's neither anonymous memory
> > nor vfio mapped MMIO range.
> 
> It is not so much it can't, more that it doesn't and doesn't need to.

OK.

> 
> > In those cases, vm_pgoff namespace defined by vfio may not be true
> > anymore, iiuc.
> 
> Since this series is proposing linking the VMA to an address_space all
> the vm_pgoffs must be in the same namespace

Agreed.  I saw discussions around on redefining the vm_pgoff namespace, I can't
say I followed that closely either, but yes it definitely makes sense to always
use an unified namespace.  Maybe we should even comment it somewhere on how
vm_pgoff is encoded?

> 
> > Or does it mean that we don't want to allow VFIO dma to those unknown memory
> > backends, for some reason?
> 
> Correct. VFIO can map into the IOMMU PFNs it can get a reference
> to. pin_user_pages() works for the majority, special VFIO VMAs cover
> the rest, and everthing else must be blocked for security.

If we all agree that the current follow_pfn() should only apply to vfio
internal vmas, then it seems we can drop it indeed, as long as the crash
reported in 5cbf3264b would fail gracefully at e.g. VFIO_IOMMU_MAP_DMA rather
than triggering a kernel warning somehow.

However I'm still confused on why it's more secure - the current process to do
VFIO_IOMMU_MAP_DMA should at least has proper permission for everything to be
setup, including the special vma, right?  Say, if the process can write to
those memories, then shouldn't we also allow it to grant this write permission
to other devices too?

Thanks,

-- 
Peter Xu

