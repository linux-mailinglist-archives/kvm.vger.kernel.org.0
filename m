Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185F54041A3
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 01:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240620AbhIHXN6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 19:13:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26051 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236792AbhIHXN4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Sep 2021 19:13:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631142767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nOaLPYWvCmKA3+gZFk6HgMiMUXXOGyn19f1P8xgHAEI=;
        b=i160cRuAoPVRNn1BH+O7x8O1MY0mErXj8LBbUUNntdT56rt3hC0ajIcscofusSMBYMrfcY
        ZP30Oak3mtCuvEaFgMNd85DTNgGS+TluiyycY1hzsurvxRP0rSaBHTacfk9vbtq4txe8sk
        UwILLbpyASKG0RWOmnJO4EHBeTnR99M=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-SJqXzpCKO8OHHRIKyVENPg-1; Wed, 08 Sep 2021 19:12:44 -0400
X-MC-Unique: SJqXzpCKO8OHHRIKyVENPg-1
Received: by mail-oi1-f199.google.com with SMTP id v24-20020a056808005800b00268eee6bf2cso30429oic.11
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 16:12:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=nOaLPYWvCmKA3+gZFk6HgMiMUXXOGyn19f1P8xgHAEI=;
        b=QLXCME87FZsSwEfkGfQLktt/bWJ2/nFiBPOZI1yAg9KCT3DKuipOvDPHde5g2wIv6P
         TH8lSIXa9imIkTaEho0BzfYDPzDtftZBf671m6CEi6qDDx/XRnvKf5PDspjRl16HqYYR
         AkxzLFE/cBkjhY4lG2h0OB2rihQHXI6BDmjbshP0oTcgJ5b4Fpo4EpFAveeWGhTqtSbd
         7TGo7+URtRXr3dA+vVg0CCh+jsh9nPCoorXLwUPBdlHOFGOQrpRuB8twOovFB2CQDY82
         8M/2lxJQ4JtI9NrJntmfZmFFbINld9eiByOeUzocJHsZsM+yc3M8BHycGGGkpeRXK7CE
         oe2w==
X-Gm-Message-State: AOAM532NNf9dDUwhoPkEE3px3Ws9vBY7e5yNoeh9lob9KQd/dzOiL2hg
        2yu1HKRaorZWFLkGH08afX0dvj+tSpoicGKPvluynR6v3y6F+ZyGKie03F9RDY7kQkBI2VCzJur
        YzM8Ps9QG/RIC
X-Received: by 2002:a9d:63cf:: with SMTP id e15mr498577otl.172.1631142763553;
        Wed, 08 Sep 2021 16:12:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxqJXuGzjBMZyjx4FIV1ALqedQxy0ByHV+FDgb9944WAR2nbxG24k2RxSKOZtXTYszMG+qinQ==
X-Received: by 2002:a9d:63cf:: with SMTP id e15mr498561otl.172.1631142763201;
        Wed, 08 Sep 2021 16:12:43 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id j10sm11655oiw.32.2021.09.08.16.12.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 16:12:42 -0700 (PDT)
Date:   Wed, 8 Sep 2021 17:12:41 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        linux-remoteproc <linux-remoteproc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Vutla, Lokesh" <lokeshvutla@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>
Subject: Re: [QUERY] Flushing cache from userspace using VFIO
Message-ID: <20210908171241.63b0b89c.alex.williamson@redhat.com>
In-Reply-To: <d338414f-ed88-20d4-7da0-6742dedb8579@ti.com>
References: <d338414f-ed88-20d4-7da0-6742dedb8579@ti.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kishon,

On Mon, 6 Sep 2021 21:22:15 +0530
Kishon Vijay Abraham I <kishon@ti.com> wrote:

> Hi Alex, Cornelia,
> 
> I'm trying to see if I can use VFIO (Versatile Framework for userspace I/O
> [1]) for communication between two cores within the same SoC. I've tried to put
> down a picture like below which tries to communicate between ARM64 (running
> Linux) and CORTEX R5 (running firmware). It uses rpmsg/remoteproc for the
> control messages and the actual data buffers are directly accessed from the
> userspace. The location of the data buffers can be informed to the userspace via
> rpmsg_vfio (which has to be built as a rpmsg endpoint).

In the vfio model, the user gets access to a device that's a member of
an IOMMU isolation group whose IOMMU context is managed by a vfio
container.  What "device" is the user getting access to here and is an
IOMMU involved?

> My question is after the userspace application in ARM64 writes to a buffer in
> the SYSTEM MEMORY, can it flush it (through a VFIO IOCTL) before handing the
> buffer to the CORTEX R5.

No such vfio ioctl currently exists.  Now you're starting to get into
KVM space if userspace requires elevated privileges to flush memory.
See for example the handling of wbinvd (write-back-invalidate) in x86
KVM based on an assigned device and coherency model supported by the
IOMMU.  vfio is only facilitating isolated access to the device. 
 
> If it's implemented within kernel either we use dma_alloc_coherent() for
> allocating coherent memory or streaming DMA APIs like
> dma_map_single()/dma_unmap_single() for flushing/invalidate the cache.

In vfio, DMA is mapped to userspace buffers.  The user allocates a
buffer and maps it for device access.  The IOMMU restricts the device to
only allow access to those buffers.  Accessing device memory in vfio is
done via regions on the device file descriptor, a device specific
region could allow a user to mmap that buffer, but the fact that this
buffer actually lives in host memory per your model and requires DMA
programming for the cortex core makes that really troubling.

For a vfio model to work, I think userspace would need to allocate the
buffers and the cortex core would need to be represented as a device
that supports isolation via an IOMMU.  Otherwise I'm not sure what
benefit you're getting from vfio.
 
> Trying to see if that is already supported in VFIO or if not, would it be
> acceptable to implement it.

vfio provides a user with privilege to access an isolated device, what
you're proposing could possibly be mangled to fit that model, but it
seems pretty awkward and there are existing solutions such as KVM for
processor virtualization if userspace needs elevated privileges to
handle CPU/RAM coherency.  Thanks,

Alex

