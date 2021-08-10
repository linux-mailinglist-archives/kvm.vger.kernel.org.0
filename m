Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86BC43E7BA7
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 17:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242540AbhHJPE3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 11:04:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56371 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241428AbhHJPE2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 11:04:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628607845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=saDSmbq1KyQ846SiUJnNdk6f6G6MN7+bgqLynbPPajY=;
        b=VeVhUEpb7wGosqcqiQNUtoO9xG9XNA2KSSiidTa/VxcJTzpzURGHYPNx1ay90quOXa2efC
        7purs2HchEjS/fUahfzPa8UPgWqhFLmQ3vHisXLhVqd67Ma50j0pXTeGpW4r8j7PDOAFUP
        +W70+vIwC8/HrC7KxNvD1LW9018/TAg=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-_Kr9kQWyMLmsKlyliHTBaA-1; Tue, 10 Aug 2021 11:04:04 -0400
X-MC-Unique: _Kr9kQWyMLmsKlyliHTBaA-1
Received: by mail-oo1-f72.google.com with SMTP id y10-20020a4ab40a0000b0290285068c6fc0so7170121oon.1
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 08:04:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=saDSmbq1KyQ846SiUJnNdk6f6G6MN7+bgqLynbPPajY=;
        b=jpHC8BUi5yks8ajewouL3vPjvSG5jhUrnFMzTv1EbqOVXNeg9PjcYHYGHeYOaXVgVu
         W2kPsPQ9qQBeUIXG0eWA3BsonGcYrtroDxxx+7O8R1boxtQFdGvka+oR6mf2z6qpuNPK
         4+CjWTDENlvkDX3XrIL/Mhg8nUyFrqTbaqWbxrnq7c/eyLPo1q0Ih2qlg8MuO6eaTWAF
         IcTwvHFV+sYeIEiZSLXZnD9/w+ZUtRoYbUii6mAx1v74YtRv2pRxyOFpPfunXBvenVHs
         DzBXmJoG2X7J4ptH+jtQXQ4H7PDykgzFxmYyz528SNCrOtrOesxnOTyw3/VaW20Pwp19
         0HHw==
X-Gm-Message-State: AOAM5311SVSicwdv+LDtsimQATkTEybCBeOvAKR5OomE1nOoOjFiB5b7
        QVwLajpRUqyoVcF4Jy/80X72qOGYD3HNZE5ikiV+v+JuqAHKHB8rj0B0YExDQvAlwrc1cUnrae8
        pHY9+8cCYqQAR
X-Received: by 2002:a9d:4e03:: with SMTP id p3mr20862109otf.214.1628607843793;
        Tue, 10 Aug 2021 08:04:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwa8NsTflJyoCSB3QzQu/ldQGo0dEw8Tvkv48rIc4s6fH1Ji0z48X8Eqi491aAosuf+mgaKlg==
X-Received: by 2002:a9d:4e03:: with SMTP id p3mr20862079otf.214.1628607843599;
        Tue, 10 Aug 2021 08:04:03 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id w13sm2037036otl.41.2021.08.10.08.04.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 08:04:03 -0700 (PDT)
Date:   Tue, 10 Aug 2021 09:04:02 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, peterx@redhat.com
Subject: Re: [PATCH 7/7] vfio/pci: Remove map-on-fault behavior
Message-ID: <20210810090402.0a120276.alex.williamson@redhat.com>
In-Reply-To: <YRJC1buKp67kGemh@infradead.org>
References: <162818167535.1511194.6614962507750594786.stgit@omen>
        <162818330190.1511194.10498114924408843888.stgit@omen>
        <YRJC1buKp67kGemh@infradead.org>
Organization: Red Hat
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 10 Aug 2021 11:11:49 +0200
Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Aug 05, 2021 at 11:08:21AM -0600, Alex Williamson wrote:
> > +void vfio_pci_test_and_up_write_memory_lock(struct vfio_pci_device *vdev)
> > +{
> > +	if (vdev->zapped_bars && __vfio_pci_memory_enabled(vdev)) {
> > +		WARN_ON(vfio_device_io_remap_mapping_range(&vdev->vdev,
> > +			VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_BAR0_REGION_INDEX),
> > +			VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_ROM_REGION_INDEX) -
> > +			VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_BAR0_REGION_INDEX)));
> > +		vdev->zapped_bars = false;  
> 
> Doing actual work inside a WARN_ON is pretty nasty.  Also the non-ONCE
> version here will lead to massive log splatter if it actually hits.
> 
> I'd prefer something like:
> 
> 	loff_t start = VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_BAR0_REGION_INDEX);
> 	loff_t end = VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_ROM_REGION_INDEX);
> 
> 	if (vdev->zapped_bars && __vfio_pci_memory_enabled(vdev)) {
> 		if (!vfio_device_io_remap_mapping_range(&vdev->vdev, start,
> 				end - start))
> 			vdev->zapped_bars = false;
> 		WARN_ON_ONCE(vdev->zapped_bars);
> 
> >  	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> > -	vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);  
> 
> What is the story with this appearing earlier and disappearing here
> again?

We switched from io_remap_pfn_range() which includes this flag
implicitly, to vmf_insert_pfn() which does not, and back to
io_remap_pfn_range() when the fault handler is removed.

> > +extern void vfio_pci_test_and_up_write_memory_lock(struct vfio_pci_device
> > +						   *vdev);  
> 
> No need for the extern.

Thanks much for the reviews!

Alex

