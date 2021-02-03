Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9874430DA38
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 13:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbhBCMwX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 07:52:23 -0500
Received: from verein.lst.de ([213.95.11.211]:51025 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229753AbhBCMuH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 07:50:07 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3E31267357; Wed,  3 Feb 2021 13:49:23 +0100 (CET)
Date:   Wed, 3 Feb 2021 13:49:22 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Martin Radev <martin.b.radev@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>, konrad.wilk@oracle.com,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        joro@8bytes.org, kirill.shutemov@linux.intel.com,
        thomas.lendacky@amd.com, robert.buhren@sect.tu-berlin.de,
        file@sect.tu-berlin.de, mathias.morbitzer@aisec.fraunhofer.de,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH] swiotlb: Validate bounce size in the sync/unmap path
Message-ID: <20210203124922.GB16923@lst.de>
References: <X/27MSbfDGCY9WZu@martin> <20210113113017.GA28106@lst.de> <YAV0uhfkimXn1izW@martin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAV0uhfkimXn1izW@martin>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 18, 2021 at 12:44:58PM +0100, Martin Radev wrote:
> Your comment makes sense but then that would require the cooperation
> of these vendors and the cloud providers to agree on something meaningful.
> I am also not sure whether the end result would be better than hardening
> this interface to catch corruption. There is already some validation in
> unmap path anyway.

So what?  If you guys want to provide a new capability you'll have to do
work.  And designing a new protocol based around the fact that the
hardware/hypervisor is not trusted and a copy is always required makes
a lot of more sense than throwing in band aids all over the place.
