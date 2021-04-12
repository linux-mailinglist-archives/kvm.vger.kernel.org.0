Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B9935C8A7
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 16:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242004AbhDLOXk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 10:23:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58529 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241780AbhDLOXh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Apr 2021 10:23:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618237399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GrF4YEmMpBSr4tpcoU2zsLDVhSyzm4Z4HeHxtyh0vvU=;
        b=Xnwp44JOnlo79bJRIgQ3yNvde8Cg+en753bMxg5K11m23ezkN+jwEsUPpveNaHgLKYHnkO
        aPL4Ws+MHTirvBLnq0qk/iPjyPYd7OeX+Tvw6yJqr8ll/ozP4hRZmlYcL4C5cac7F/Seq7
        fl6oyrFW8PIqHskRc08bX/khpHUte8c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-OL_3aR56Mdyv0DeVj_LUSg-1; Mon, 12 Apr 2021 10:23:12 -0400
X-MC-Unique: OL_3aR56Mdyv0DeVj_LUSg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52AFC10054F6;
        Mon, 12 Apr 2021 14:23:08 +0000 (UTC)
Received: from omen (ovpn-117-254.rdu2.redhat.com [10.10.117.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E97905D9DE;
        Mon, 12 Apr 2021 14:23:04 +0000 (UTC)
Date:   Mon, 12 Apr 2021 08:23:04 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Christoph Hellwig <hch@lst.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH 1/2] vfio/pci: remove vfio_pci_nvlink2
Message-ID: <20210412082304.5e7c0a80@omen>
In-Reply-To: <87y2dndelm.fsf@mpe.ellerman.id.au>
References: <20210326061311.1497642-1-hch@lst.de>
        <20210326061311.1497642-2-hch@lst.de>
        <20210406133805.715120bd@omen>
        <87y2dndelm.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 12 Apr 2021 19:41:41 +1000
Michael Ellerman <mpe@ellerman.id.au> wrote:

> Alex Williamson <alex.williamson@redhat.com> writes:
> > On Fri, 26 Mar 2021 07:13:10 +0100
> > Christoph Hellwig <hch@lst.de> wrote:
> >  
> >> This driver never had any open userspace (which for VFIO would include
> >> VM kernel drivers) that use it, and thus should never have been added
> >> by our normal userspace ABI rules.
> >> 
> >> Signed-off-by: Christoph Hellwig <hch@lst.de>
> >> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >> ---
> >>  drivers/vfio/pci/Kconfig            |   6 -
> >>  drivers/vfio/pci/Makefile           |   1 -
> >>  drivers/vfio/pci/vfio_pci.c         |  18 -
> >>  drivers/vfio/pci/vfio_pci_nvlink2.c | 490 ----------------------------
> >>  drivers/vfio/pci/vfio_pci_private.h |  14 -
> >>  include/uapi/linux/vfio.h           |  38 +--
> >>  6 files changed, 4 insertions(+), 563 deletions(-)
> >>  delete mode 100644 drivers/vfio/pci/vfio_pci_nvlink2.c  
> >
> > Hearing no objections, applied to vfio next branch for v5.13.  Thanks,  
> 
> Looks like you only took patch 1?
> 
> I can't take patch 2 on its own, that would break the build.
> 
> Do you want to take both patches? There's currently no conflicts against
> my tree. It's possible one could appear before the v5.13 merge window,
> though it would probably just be something minor.
> 
> Or I could apply both patches to my tree, which means patch 1 would
> appear as two commits in the git history, but that's not a big deal.

I've already got a conflict in my next branch with patch 1, so it's
best to go through my tree.  Seems like a shared branch would be
easiest to allow you to merge and manage potential conflicts against
patch 2, I've pushed a branch here:

https://github.com/awilliam/linux-vfio.git v5.13/vfio/nvlink

Thanks,
Alex

