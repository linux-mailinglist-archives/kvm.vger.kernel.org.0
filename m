Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7462FA45A
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 16:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405566AbhARPQp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 10:16:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393345AbhARPPN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jan 2021 10:15:13 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF2B4C061573;
        Mon, 18 Jan 2021 07:14:32 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id f26so18911471qka.0;
        Mon, 18 Jan 2021 07:14:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8/QgAqc0aRwKS3j1sw2jdEshnvLA6NQrB2MHBO445ps=;
        b=OUW4fmwJMB3DlPjCqHB4ucAnBizINKGQ12AtxdzV3oB+3hP2fbkuv7APF3wIwz7gxB
         eLzm0xZ72V4Ik+o0FJ1nGNVDTa0IdK8zErtabD5BxcdFoDUfYzMYU9FNFoiXehK4bFfY
         o66vD4IUoz0JL7mFUJHX0nJNZAox9hH62vtj7O/MRiMbimGSAa0PJFb6nz22YYGt44vs
         +ZH0BmrZRSd+y378d6AI4WH1Gj4IeTReIMC+ZGsx4nFs5fjMxC8/o1/dSIhZnB2zVQ+k
         roAXFRXrZ7834DS2oaP5u/AxxsvrK27zPRWheQYHoQefLNV/cqwUp/Dq5gLaM3Au0cDT
         qQjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=8/QgAqc0aRwKS3j1sw2jdEshnvLA6NQrB2MHBO445ps=;
        b=bwX8pSSEh0tDlZHrRh9+Ql1CxG65rb5VDEkmXKB9n69r62gP5gZ136soAAS1itnnGo
         lO7W/+TPrZJSKsdhn4nPqKjD1n1Gx+UFn60qmdW0ODqiOkqnm2oRKNkGLs1/5ALHvN/B
         ItaPmAvegUXTPZm50RK/iCp2DK8CF4eBLp8Zv+IU4v2OS60ZMUXvffwIAAs0dx7QWdx8
         OTeT6MVdUrlsUmnnAx+gcozAqXf3RzPnDhR8V2+FlHDEJ/xyAnCHnAbgPsoH+mzDf8CH
         MBzAP1hsaAa12mKLLTxMbXwWMcfuACFaHE+BUdHiQg4rdz+e5StIlgIVM4sj7Q6R5h83
         ZsAA==
X-Gm-Message-State: AOAM533wDRFayp2aH2rEp5P14U40zXaEcpvSNzAlNZwX5gSwyE4B+Zgp
        dx/mroGqjH73HjjSyTDwZTUketKujx9Vs6S1
X-Google-Smtp-Source: ABdhPJzMTKjmpH2iOukLV0Kxa2DXEPChKiYHkmNYSdAGutYV5YUYETku4jkS1p49oIw5G9DUl099YQ==
X-Received: by 2002:a05:620a:63c:: with SMTP id 28mr105003qkv.26.1610982871901;
        Mon, 18 Jan 2021 07:14:31 -0800 (PST)
Received: from fedora (209-6-208-110.s8556.c3-0.smr-cbr2.sbo-smr.ma.cable.rcncustomer.com. [209.6.208.110])
        by smtp.gmail.com with ESMTPSA id 133sm10893311qkd.94.2021.01.18.07.14.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 07:14:31 -0800 (PST)
Sender: Konrad Rzeszutek Wilk <konrad.r.wilk@gmail.com>
Date:   Mon, 18 Jan 2021 10:14:28 -0500
From:   Konrad Rzeszutek Wilk <konrad@darnok.org>
To:     Martin Radev <martin.b.radev@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>, thomas.lendacky@amd.com,
        file@sect.tu-berlin.de, robert.buhren@sect.tu-berlin.de,
        kvm@vger.kernel.org, konrad.wilk@oracle.com,
        mathias.morbitzer@aisec.fraunhofer.de,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        iommu@lists.linux-foundation.org, robin.murphy@arm.com,
        kirill.shutemov@linux.intel.com
Subject: Re: [PATCH] swiotlb: Validate bounce size in the sync/unmap path
Message-ID: <20210118151428.GA72213@fedora>
References: <X/27MSbfDGCY9WZu@martin>
 <20210113113017.GA28106@lst.de>
 <YAV0uhfkimXn1izW@martin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAV0uhfkimXn1izW@martin>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 18, 2021 at 12:44:58PM +0100, Martin Radev wrote:
> On Wed, Jan 13, 2021 at 12:30:17PM +0100, Christoph Hellwig wrote:
> > On Tue, Jan 12, 2021 at 04:07:29PM +0100, Martin Radev wrote:
> > > The size of the buffer being bounced is not checked if it happens
> > > to be larger than the size of the mapped buffer. Because the size
> > > can be controlled by a device, as it's the case with virtio devices,
> > > this can lead to memory corruption.
> > > 
> > 
> > I'm really worried about all these hodge podge hacks for not trusted
> > hypervisors in the I/O stack.  Instead of trying to harden protocols
> > that are fundamentally not designed for this, how about instead coming
> > up with a new paravirtualized I/O interface that is specifically
> > designed for use with an untrusted hypervisor from the start?
> 
> Your comment makes sense but then that would require the cooperation
> of these vendors and the cloud providers to agree on something meaningful.
> I am also not sure whether the end result would be better than hardening
> this interface to catch corruption. There is already some validation in
> unmap path anyway.
> 
> Another possibility is to move this hardening to the common virtio code,
> but I think the code may become more complicated there since it would
> require tracking both the dma_addr and length for each descriptor.

Christoph,

I've been wrestling with the same thing - this is specific to busted
drivers. And in reality you could do the same thing with a hardware
virtio device (see example in http://thunderclap.io/) - where the
mitigation is 'enable the IOMMU to do its job.'.

AMD SEV documents speak about utilizing IOMMU to do this (AMD SEV-SNP)..
and while that is great in the future, SEV without IOMMU is now here.

Doing a full circle here, this issue can be exploited with virtio
but you could say do that with real hardware too if you hacked the
firmware, so if you say used Intel SR-IOV NIC that was compromised
on an AMD SEV machine, and plumbed in the guest - the IOMMU inside
of the guest would be SWIOTLB code. Last line of defense against
bad firmware to say.

As such I am leaning towards taking this code, but I am worried
about the performance hit .. but perhaps I shouldn't as if you
are using SWIOTLB=force already you are kind of taking a
performance hit?

