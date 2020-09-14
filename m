Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3682D268577
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 09:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbgINHGS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 03:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbgINHGO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 03:06:14 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D2CC061788
        for <kvm@vger.kernel.org>; Mon, 14 Sep 2020 00:06:13 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id e23so21648392eja.3
        for <kvm@vger.kernel.org>; Mon, 14 Sep 2020 00:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YzjHK93gF6TNt+MS+qTD/b9Ejjchu3tiLLiAmnKOigs=;
        b=GVuyGNCHt3OvQ6eF2rUvSOr0rU/reUiaOsL5AQskvAlBtwEICewg7AIjbQWATNAvsg
         0QOTbsPNg1FuPEykHQ4PIO2slHHDdVbY+esAt0zfaIcpyCYpi0nAc8lvByqsT/Pw5WFq
         yI/HcgRHr3XCgFrnJdqsQQNUQzaPLg3qEx9Zw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YzjHK93gF6TNt+MS+qTD/b9Ejjchu3tiLLiAmnKOigs=;
        b=ZICyMLU9gxQp4RHaPsBDoeabF4aYW+JWyGVifeKyawRnbo9qbug8xRyqE1e4gbVTiS
         etDy6lWBy1rEnZ/1bPWtpu/SxT8QlDi3bbX+wfx5i1unnQEwM91Iz7yW5erETr9q1kPm
         gQjJkvBO4cTvhC/OgvC6Q6jLq2tBVWNmP7vFFFRQ/gxOj0ym4BtxDw/a6cIFbVYjm+Pw
         fKLdFcizy3nOffgZYl5EaAwZa1q/okb4bQV3bWTxlBDvQQdaJr6X/RgsoDt5rYxuxQct
         N/MCLg/0DCVcilEeVLm4PDCYAO3xqRAvaEj8MU4jeGZFkhFMgGerVcW1XoUQxJAiOwDl
         Z3rg==
X-Gm-Message-State: AOAM533mRcNAOmzW3ptnJItiDME4P4r+UBPHkapZ9/5uzYKWb9S9oi0K
        2qzrFmLYZRFpQBfgLdh5u2iowi3NZhfHBCkF10TeRw==
X-Google-Smtp-Source: ABdhPJwwMHTxbNFbv1ZDSMvwtnnv5t/6jACLhtDPjF+BAh7AYeJ1VPMt4OX16E+iT8UDf1zr5E8OnqzZABT/VwMrjqE=
X-Received: by 2002:a17:906:4c51:: with SMTP id d17mr13102661ejw.28.1600067172080;
 Mon, 14 Sep 2020 00:06:12 -0700 (PDT)
MIME-Version: 1.0
References: <c94c36305980f80674aa699e27b9895b@mail.gmail.com>
 <20200910105735.1e060b95@w520.home> <f9b3c805-cd64-3402-ff73-339c35c4c27a@redhat.com>
In-Reply-To: <f9b3c805-cd64-3402-ff73-339c35c4c27a@redhat.com>
From:   Vikas Gupta <vikas.gupta@broadcom.com>
Date:   Mon, 14 Sep 2020 12:36:01 +0530
Message-ID: <CAHLZf_vfyDR5SrtC48j9jaBK3sONhfDtkDnqHVE8NB8_up=B+g@mail.gmail.com>
Subject: Re: MSI/MSIX for VFIO platform
To:     Auger Eric <eric.auger@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vikram Prakash <vikram.prakash@broadcom.com>,
        Srinath Mannam <srinath.mannam@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric/Alex,
Thanks for your valuable suggestions and get back to you if anything
is required.

Thanks,
Vikas

On Fri, Sep 11, 2020 at 7:23 PM Auger Eric <eric.auger@redhat.com> wrote:
>
> Hi Vikas,
>
> On 9/10/20 6:57 PM, Alex Williamson wrote:
> > On Thu, 10 Sep 2020 16:15:27 +0530
> > Vikas Gupta <vikas.gupta@broadcom.com> wrote:
> >
> >> Hi Alex/Cornelia,
> >>
> >> We are looking for MSI interrupts for platform devices in user-space
> >> applications via event/poll mechanism using VFIO.
> >>
> >> Since there is no support for MSI/MSIX handling in VFIO-platform in kernel,
> >> it may not possible to get this feature in user-space.
> >>
> >> Is there any other way we can get this feature in user-space OR can you
> >> please suggest if any patch or feature is in progress for same in VFIO
> >> platform?
> >>
> >> Any suggestions would be helpful.
> >
> > Eric (Cc'd) is the maintainer of vfio-platform.
> >
> > vfio-platform devices don't have IRQ indexes dedicated to MSI and MSI-X
> > like vfio-pci devices do (technically these are PCI concepts, but I
> > assume we're referring generically to message signaled interrupts), but
> > that's simply due to the lack of standardization in platform devices.
> > Logically these are simply collections of edge triggered interrupts,
> > which the vfio device API supports generically, it's simply a matter
> > that the vfio bus driver exposing a vfio-platform device create an IRQ
> > index exposing these vectors.  Thanks,
>
> I have not worked on MSI support and I am not aware of any work
> happening in this area.
>
> First I would recommend to look at IRQ related uapis exposed by VFIO:
> VFIO_DEVICE_GET_IRQ_INFO
> VFIO_DEVICE_SET_IRQS
>
> and try to understand if they can be implemented for MSIs in a generic
> way in the vfio_platform driver using platform-msi helpers.
>
> For instance VFIO_DEVICE_GET_IRQ_INFO would need to return the number of
> requested vectors. On init I guess we should allocate vectors using
> platform_msi_domain_alloc_irqs/ devm_request_irq and in the handler
> trigger the eventfd provided through VFIO_DEVICE_SET_IRQS.
>
> On userspace where you have to trap the MSI setup to call the above
> functions and setup irqfd injection. This would be device specific as
> opposed to PCI. That's just rough ideas at the moment.
>
> Thanks
>
> Eric
>
> >
> > Alex
> >
>
