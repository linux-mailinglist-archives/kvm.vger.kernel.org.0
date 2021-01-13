Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9352F4A49
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 12:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbhAMLbD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 06:31:03 -0500
Received: from verein.lst.de ([213.95.11.211]:59643 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727194AbhAMLbC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 06:31:02 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0514168AFE; Wed, 13 Jan 2021 12:30:18 +0100 (CET)
Date:   Wed, 13 Jan 2021 12:30:17 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Martin Radev <martin.b.radev@gmail.com>
Cc:     konrad.wilk@oracle.com, hch@lst.de, m.szyprowski@samsung.com,
        robin.murphy@arm.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, joro@8bytes.org,
        kirill.shutemov@linux.intel.com, thomas.lendacky@amd.com,
        robert.buhren@sect.tu-berlin.de, file@sect.tu-berlin.de,
        mathias.morbitzer@aisec.fraunhofer.de,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH] swiotlb: Validate bounce size in the sync/unmap path
Message-ID: <20210113113017.GA28106@lst.de>
References: <X/27MSbfDGCY9WZu@martin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/27MSbfDGCY9WZu@martin>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 12, 2021 at 04:07:29PM +0100, Martin Radev wrote:
> The size of the buffer being bounced is not checked if it happens
> to be larger than the size of the mapped buffer. Because the size
> can be controlled by a device, as it's the case with virtio devices,
> this can lead to memory corruption.
> 

I'm really worried about all these hodge podge hacks for not trusted
hypervisors in the I/O stack.  Instead of trying to harden protocols
that are fundamentally not designed for this, how about instead coming
up with a new paravirtualized I/O interface that is specifically
designed for use with an untrusted hypervisor from the start?
