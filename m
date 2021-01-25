Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABF7302A5A
	for <lists+kvm@lfdr.de>; Mon, 25 Jan 2021 19:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbhAYSfJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 13:35:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbhAYSeU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 13:34:20 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38A8C061574;
        Mon, 25 Jan 2021 10:33:39 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id bx12so16670064edb.8;
        Mon, 25 Jan 2021 10:33:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VMRVhIQIXZxzucvozlD6kGt114/L0couPU+fNeFrnDQ=;
        b=B/RNvjvh+qiB40NO59Ij5acibSeJucACNTddOI5YBI8wjrLQZCGM/n6hgYcU5ZoMIc
         7el4jsKtS3gTsDSsJodd7O6v+pVrEY2qQP7g4eDvKqFVqVzQPmJ9ki4qnqYZ0Y/AuySn
         KHW49MzPLDQZXV2BHQT/lLAsDHgQN5CnfKxD6vKy8zy6mDCSXe7IS+isMaR23ExsXdEh
         CaL9wxe38Vap6EY4cP9j1pr6fUJeLVrJKQAGnhZq7M3SrXQMx3CDXcjUMfnj+rCWX7vS
         zlpZl4WtEMVhrvjaKj83VXuZpzFOE68uikLW1v51/c81VwAO9DZ3AoOvB8Sqo+bCIELe
         mbLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VMRVhIQIXZxzucvozlD6kGt114/L0couPU+fNeFrnDQ=;
        b=TXbI15oNUEzL8QF9zBttiWRt24F+yyVo8wu+6wtqK6uKgHbjC+QzdefnoUXAgqCbYA
         scgOC5sXTFDeSpj4Mptn7i12UtvNHvdDb66YhSO9KoVV9tpRtyXWxNLUn7KVoyx2HIBl
         HFtfD6Pmq+gwEQWrMt9FiO20cXFTC+MrCghWrGuhNQBpmOTKlYtHL0c6TfKNkmFIGdt+
         bNNzd8LhD138O/xd5BtfL+ooopjnU/L9LQjOzKfUT39pJBOtcxUTYxAXpuYCrv/Hdzx6
         rSknL71Ma0F0R8nSFxacx0rlG4jZyqd6xzo9ESY+0QPHN5xSuF/kHukUUJSbfzZ6bDZA
         JEnw==
X-Gm-Message-State: AOAM530QZ5Rfwa74mykzzRXQjaEYticQCbOxyBDH88zW6vq7UobDALB+
        YwkBEiQjV/spjtgJTnEtHEmOJrUa2EMU0xZT
X-Google-Smtp-Source: ABdhPJxUJhjHWZALtw4qPBu4yxZgE6PlX7Q+SepxYV+BseqPdze5m+o668iKAr7LDljmuCzZrtec+Q==
X-Received: by 2002:aa7:d4d7:: with SMTP id t23mr1529021edr.321.1611599618531;
        Mon, 25 Jan 2021 10:33:38 -0800 (PST)
Received: from martin (p578aa711.dip0.t-ipconnect.de. [87.138.167.17])
        by smtp.gmail.com with ESMTPSA id ce7sm8584140ejb.100.2021.01.25.10.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 10:33:37 -0800 (PST)
Date:   Mon, 25 Jan 2021 19:33:35 +0100
From:   Martin Radev <martin.b.radev@gmail.com>
To:     Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc:     Christoph Hellwig <hch@lst.de>, thomas.lendacky@amd.com,
        file@sect.tu-berlin.de, robert.buhren@sect.tu-berlin.de,
        kvm@vger.kernel.org, konrad.wilk@oracle.com,
        mathias.morbitzer@aisec.fraunhofer.de,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        iommu@lists.linux-foundation.org, robin.murphy@arm.com,
        kirill.shutemov@linux.intel.com
Subject: Re: [PATCH] swiotlb: Validate bounce size in the sync/unmap path
Message-ID: <YA8O/2qBBzZo5hi7@martin>
References: <X/27MSbfDGCY9WZu@martin>
 <20210113113017.GA28106@lst.de>
 <YAV0uhfkimXn1izW@martin>
 <20210118151428.GA72213@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118151428.GA72213@fedora>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 18, 2021 at 10:14:28AM -0500, Konrad Rzeszutek Wilk wrote:
> On Mon, Jan 18, 2021 at 12:44:58PM +0100, Martin Radev wrote:
> > On Wed, Jan 13, 2021 at 12:30:17PM +0100, Christoph Hellwig wrote:
> > > On Tue, Jan 12, 2021 at 04:07:29PM +0100, Martin Radev wrote:
> > > > The size of the buffer being bounced is not checked if it happens
> > > > to be larger than the size of the mapped buffer. Because the size
> > > > can be controlled by a device, as it's the case with virtio devices,
> > > > this can lead to memory corruption.
> > > > 
> > > 
> > > I'm really worried about all these hodge podge hacks for not trusted
> > > hypervisors in the I/O stack.  Instead of trying to harden protocols
> > > that are fundamentally not designed for this, how about instead coming
> > > up with a new paravirtualized I/O interface that is specifically
> > > designed for use with an untrusted hypervisor from the start?
> > 
> > Your comment makes sense but then that would require the cooperation
> > of these vendors and the cloud providers to agree on something meaningful.
> > I am also not sure whether the end result would be better than hardening
> > this interface to catch corruption. There is already some validation in
> > unmap path anyway.
> > 
> > Another possibility is to move this hardening to the common virtio code,
> > but I think the code may become more complicated there since it would
> > require tracking both the dma_addr and length for each descriptor.
> 
> Christoph,
> 
> I've been wrestling with the same thing - this is specific to busted
> drivers. And in reality you could do the same thing with a hardware
> virtio device (see example in http://thunderclap.io/) - where the
> mitigation is 'enable the IOMMU to do its job.'.
> 
> AMD SEV documents speak about utilizing IOMMU to do this (AMD SEV-SNP)..
> and while that is great in the future, SEV without IOMMU is now here.
> 
> Doing a full circle here, this issue can be exploited with virtio
> but you could say do that with real hardware too if you hacked the
> firmware, so if you say used Intel SR-IOV NIC that was compromised
> on an AMD SEV machine, and plumbed in the guest - the IOMMU inside
> of the guest would be SWIOTLB code. Last line of defense against
> bad firmware to say.
> 
> As such I am leaning towards taking this code, but I am worried
> about the performance hit .. but perhaps I shouldn't as if you
> are using SWIOTLB=force already you are kind of taking a
> performance hit?
> 

I have not measured the performance degradation. This will hit all AMD SEV,
Intel TDX, IBM Protected Virtualization VMs. I don't expect the hit to
be large since there are only few added operations per hundreads of copied
bytes. I could try to measure the performance hit by running some benchmark
with virtio-net/virtio-blk/virtio-rng.

Earlier I said:
> > Another possibility is to move this hardening to the common virtio code,
> > but I think the code may become more complicated there since it would
> > require tracking both the dma_addr and length for each descriptor.

Unfortunately, this doesn't make sense. Even if there's validation for
the size in the common virtio layer, there will be some other device
which controls a dma_addr and length passed to dma_unmap* in the
corresponding driver. The device can target a specific dma-mapped private
buffer by changing the dma_addr and set a good length to overwrite buffers
following it.

So, instead of doing the check in every driver and hitting a performance
cost even when swiotlb is not used, it's probably better to fix it in
swiotlb.

@Tom Lendacky, do you think that it makes sense to harden swiotlb or
some other approach may be better for the SEV features?

