Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0171C3E0E
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 17:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729468AbgEDPF7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 11:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728381AbgEDPF6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 May 2020 11:05:58 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F11EC061A0F
        for <kvm@vger.kernel.org>; Mon,  4 May 2020 08:05:58 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id x12so14187785qts.9
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 08:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=W9SfBfk/u14rl2gH53J+GCo3+J3XKQlUdBUevAtgsvg=;
        b=hQy9jhSSW/Ku+IvObuEN+74pDIyl494WQ3X87xYprHIOt8NXWmSVnGSc3RT3eOD2BM
         3L5xnD/n3wrksd/OOtLeNfEtW7pEC5YybNtOI5aZtP26PhWfzFuxE5G3KV+w6wyK6S1N
         OllFS1VbcAfROvmzpJVr9vhxOACAm7jjtxvSjhB2z8VG0ZBsCdSaZ7L85inRw7H7OQaj
         ZpjhjI2MawebL+SsjUYZG//o1Xv5fTACocobMH7y7ACBlLqayobAQW1oQpV0v0bVjHV8
         n8E3fYv7EF16OQ7kk0VL8eW73lDAKGSlcZkbVuhFSHJb+NmZQ3YGvoM1uUzYSxmcPVy1
         YILQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=W9SfBfk/u14rl2gH53J+GCo3+J3XKQlUdBUevAtgsvg=;
        b=Ng18PqX5jNH6RuDwXKxrlFlMgRUzFjXJH+WXvcXwjwu5Wvos3Bbd1m9cw7UfQ7lrzo
         hqVE0KUg2Iex7VjSlv7yPHL5iGj6dElBqS5qBO2peMlZusYZswG8i7TWhdZDZ3wOWKKN
         8cBPsXZjHcmWK9gqdMTnFOK4Sfew2pwyG3oHHpjdlqBH9hL1KUyMdWHO5Gv2t1NBoGwF
         J9nLGSHV/DXOwlS2siPv0NUCfanwb5PxXnG2fIvvaYSjfnSdSzZQRI2MfNIUih6yQpHS
         8DK3BHa/ymxJXQ8AqrITCpTu9tq/P5hd1JqRTIX0D+WHf/6tnv5lW/mNM+cHvoyOZxDO
         cfsg==
X-Gm-Message-State: AGi0PuaQdBXZu3GdamIMSKMOr2ac/6ImuCRK5+ICqlJSsTF+8o1pMX6v
        kzZ5gQGedZ+JmcsH/Vl1HHs8Z7Wq2eU=
X-Google-Smtp-Source: APiQypL5Sg4OJm1P2mb7CDrW9ftmb7zH1hc234vBHyttVYZLd71RZJd513T2KlxdS697uXkd6I+R1A==
X-Received: by 2002:ac8:6f6c:: with SMTP id u12mr219677qtv.103.1588604757260;
        Mon, 04 May 2020 08:05:57 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id 193sm5659558qkl.42.2020.05.04.08.05.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 04 May 2020 08:05:56 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jVcfM-0000LM-1C; Mon, 04 May 2020 12:05:56 -0300
Date:   Mon, 4 May 2020 12:05:56 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, peterx@redhat.com
Subject: Re: [PATCH 2/3] vfio-pci: Fault mmaps to enable vma tracking
Message-ID: <20200504150556.GX26002@ziepe.ca>
References: <158836742096.8433.685478071796941103.stgit@gimli.home>
 <158836915917.8433.8017639758883869710.stgit@gimli.home>
 <20200501232550.GP26002@ziepe.ca>
 <20200504082055.0faeef8b@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200504082055.0faeef8b@x1.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 04, 2020 at 08:20:55AM -0600, Alex Williamson wrote:
> On Fri, 1 May 2020 20:25:50 -0300
> Jason Gunthorpe <jgg@ziepe.ca> wrote:
> 
> > On Fri, May 01, 2020 at 03:39:19PM -0600, Alex Williamson wrote:
> > > Rather than calling remap_pfn_range() when a region is mmap'd, setup
> > > a vm_ops handler to support dynamic faulting of the range on access.
> > > This allows us to manage a list of vmas actively mapping the area that
> > > we can later use to invalidate those mappings.  The open callback
> > > invalidates the vma range so that all tracking is inserted in the
> > > fault handler and removed in the close handler.
> > > 
> > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > >  drivers/vfio/pci/vfio_pci.c         |   76 ++++++++++++++++++++++++++++++++++-
> > >  drivers/vfio/pci/vfio_pci_private.h |    7 +++
> > >  2 files changed, 81 insertions(+), 2 deletions(-)  
> > 
> > > +static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
> > > +{
> > > +	struct vm_area_struct *vma = vmf->vma;
> > > +	struct vfio_pci_device *vdev = vma->vm_private_data;
> > > +
> > > +	if (vfio_pci_add_vma(vdev, vma))
> > > +		return VM_FAULT_OOM;
> > > +
> > > +	if (remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
> > > +			    vma->vm_end - vma->vm_start, vma->vm_page_prot))
> > > +		return VM_FAULT_SIGBUS;
> > > +
> > > +	return VM_FAULT_NOPAGE;
> > > +}
> > > +
> > > +static const struct vm_operations_struct vfio_pci_mmap_ops = {
> > > +	.open = vfio_pci_mmap_open,
> > > +	.close = vfio_pci_mmap_close,
> > > +	.fault = vfio_pci_mmap_fault,
> > > +};
> > > +
> > >  static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
> > >  {
> > >  	struct vfio_pci_device *vdev = device_data;
> > > @@ -1357,8 +1421,14 @@ static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
> > >  	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> > >  	vma->vm_pgoff = (pci_resource_start(pdev, index) >> PAGE_SHIFT) + pgoff;
> > >  
> > > -	return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
> > > -			       req_len, vma->vm_page_prot);
> > > +	/*
> > > +	 * See remap_pfn_range(), called from vfio_pci_fault() but we can't
> > > +	 * change vm_flags within the fault handler.  Set them now.
> > > +	 */
> > > +	vma->vm_flags |= VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP;
> > > +	vma->vm_ops = &vfio_pci_mmap_ops;  
> > 
> > Perhaps do the vfio_pci_add_vma & remap_pfn_range combo here if the
> > BAR is activated ? That way a fully populated BAR is presented in the
> > common case and avoids taking a fault path?
> > 
> > But it does seem OK as is
> 
> Thanks for reviewing.  There's also an argument that we defer
> remap_pfn_range() until the device is actually touched, which might
> reduce the startup latency.

But not startup to a functional VM as that will now have to take the
slower fault path.

> It's also a bit inconsistent with the vm_ops.open() path where I
> can't return error, so I can't call vfio_pci_add_vma(), I can only
> zap the vma so that the fault handler can return an error if
> necessary.

open could allocate memory so the zap isn't needed. If allocation
fails then do the zap and take the slow path.

> handler.  If there's a good reason to do otherwise, I can make the
> change, but I doubt I'd have encountered the dma mapping of an
> unfaulted vma issue had I done it this way, so maybe there's a test
> coverage argument as well.  Thanks,

This test is best done by having one thread disable the other bar
while another thread is trying to map it

Jason
