Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD71314A40
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 09:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbhBII1W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 03:27:22 -0500
Received: from verein.lst.de ([213.95.11.211]:45420 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229706AbhBII1I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Feb 2021 03:27:08 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 313FB67373; Tue,  9 Feb 2021 09:26:24 +0100 (CET)
Date:   Tue, 9 Feb 2021 09:26:23 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Martin Radev <martin.b.radev@gmail.com>,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        joro@8bytes.org, kirill.shutemov@linux.intel.com,
        thomas.lendacky@amd.com, robert.buhren@sect.tu-berlin.de,
        file@sect.tu-berlin.de, mathias.morbitzer@aisec.fraunhofer.de,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH] swiotlb: Validate bounce size in the sync/unmap path
Message-ID: <20210209082623.GA31955@lst.de>
References: <X/27MSbfDGCY9WZu@martin> <20210113113017.GA28106@lst.de> <YAV0uhfkimXn1izW@martin> <20210203124922.GB16923@lst.de> <20210203193638.GA325136@fedora> <20210205175852.GA1021@lst.de> <YCFxiTB//Iz6aIhk@Konrads-MacBook-Pro.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCFxiTB//Iz6aIhk@Konrads-MacBook-Pro.local>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 08, 2021 at 12:14:49PM -0500, Konrad Rzeszutek Wilk wrote:
> > ring buffer or whatever because you know I/O will be copied anyway
> > and none of all the hard work higher layers do to make the I/O suitable
> > for a normal device apply.
> 
> I lost you here. Sorry, are you saying have a simple ring protocol
> (like NVME has), where the ring entries (SG or DMA phys) are statically
> allocated and whenever NVME driver gets data from user-space it
> would copy it in there?

Yes.  Basically extend the virtio or NVMe ring/queue concept to not just
cover commands and completions, but also the data transfers.
