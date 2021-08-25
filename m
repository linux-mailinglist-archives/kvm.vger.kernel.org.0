Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4303F752C
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 14:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240664AbhHYMib (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 08:38:31 -0400
Received: from verein.lst.de ([213.95.11.211]:56044 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240372AbhHYMia (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 08:38:30 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1BB2E6736F; Wed, 25 Aug 2021 14:37:43 +0200 (CEST)
Date:   Wed, 25 Aug 2021 14:37:42 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 07/14] vfio: simplify iommu group allocation for
 mediated devices
Message-ID: <20210825123742.GA17251@lst.de>
References: <20210824144649.1488190-1-hch@lst.de> <20210824144649.1488190-8-hch@lst.de> <20210825001916.GN543798@ziepe.ca> <20210825053237.GB26806@lst.de> <20210825122144.GV543798@ziepe.ca> <20210825122400.GA16194@lst.de> <20210825123454.GW543798@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825123454.GW543798@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 25, 2021 at 09:34:54AM -0300, Jason Gunthorpe wrote:
> On Wed, Aug 25, 2021 at 02:24:00PM +0200, Christoph Hellwig wrote:
> > On Wed, Aug 25, 2021 at 09:21:44AM -0300, Jason Gunthorpe wrote:
> > > This feature is about creating a device that is not connected to a HW
> > > IO page table (at least by the VFIO iommu code) but the IO page table
> > > is held in software and accessed by the VFIO driver through the pin
> > > API.
> > > 
> > > virtual_iommu is somewhat overloaded with the idea of a vIOMMU created
> > > by qemu and stuffed into a guest..
> > > 
> > > "domainless" might work but I also find it confusing that the iommu
> > > code uses the word domain to refer to a HW IO page table :\
> > > 
> > > Maybe "sw io page table" ?
> > 
> > Or simply emulated?  At least looking at i915 there is very little
> > direct connection to the actual hardware, and while I don't understand
> > them fully the s390 driver look similar.  And the samples are completely
> > faked up anyway.
> 
> Emulated IO page table works for me!

Hmm, that is a full sentence for the comment that needs to be added.
Are you fine with just s/mediated/emulated/ for the symbol names or
do you want something more specific?
