Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78E1A36B6C3
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 18:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234161AbhDZQ0q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 12:26:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34617 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233736AbhDZQ0o (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Apr 2021 12:26:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619454362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=70ixX72CpuOv/S5XCIQiALpW30YWzP0sOJPlrd+z28g=;
        b=gTyuVqjXVPljKVZJAa3pMEmvNL4IQsthFuXUgGMltLhZiXRx78d/NDEdhxMvU5/sxA4Ysh
        fSsleRM2n6OUY1DNioU8RZAY8ZGJ0LOJdCPpUOf1mtvBwI2TZb1qQnIFzeHnD0S+vFAbMc
        fi5YpN9nU43+84QDwAhhZrupjl/S7ek=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-6CgpiC-XPLaKvEL9Wlk6jA-1; Mon, 26 Apr 2021 12:26:00 -0400
X-MC-Unique: 6CgpiC-XPLaKvEL9Wlk6jA-1
Received: by mail-ej1-f71.google.com with SMTP id w2-20020a1709062f82b0290378745f26d5so10362747eji.6
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 09:25:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=70ixX72CpuOv/S5XCIQiALpW30YWzP0sOJPlrd+z28g=;
        b=N2b5RDfohW+ziBHx5+3laXA8Lp+/v+/zEFPsDJQVvKzlRCTCb+SNJ5qT0idXX/VK6O
         VYgZrJFA2HMXdl4DJnbeAnz4ZyTl/GRKjlSH8R82BW3RX+w9OeaxdQ6aOlzyTG8zY6yn
         7egGMNiUc/vRO8QedbkLi+BQ6PGwJxK9zfGpEjGU2m2gA1ZC5HH35SGZnuMo4rb7mcas
         KRyFuUqqgdTZZspPSNB6xDf76bS62lNdYjngueY0q913mOdMD8ooUyIwEzRJcZGVQ3DB
         5QnL0jK5LmBLfVlD6IplhdN903V9kXaQFnaLRg/GDdA3JhT1hj0CjGHj0E2O97aM7fo3
         3opQ==
X-Gm-Message-State: AOAM5334gWOZ3pLiMkwYMNxmTRzeT9Gpr61ItfRD7amrpW6MbpBki8zG
        4YsLKWZHSApGDGcALgyWrIVWJSd/TfxZh06T5WX2LbcHF/k+lAXCluHR1n0PFnqglzcKzhltrD7
        JAvoi0f/Y86Ex
X-Received: by 2002:a17:907:3f9f:: with SMTP id hr31mr19130352ejc.349.1619454358826;
        Mon, 26 Apr 2021 09:25:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJykfCOdce13T0w3AGSbMqOMU+sBokC9lLdCIV+VvXxvAAEuh2C3hTjNa9JMUC4P4WAQER+J6w==
X-Received: by 2002:a17:907:3f9f:: with SMTP id hr31mr19130345ejc.349.1619454358676;
        Mon, 26 Apr 2021 09:25:58 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id i8sm233255edu.64.2021.04.26.09.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 09:25:58 -0700 (PDT)
Date:   Mon, 26 Apr 2021 18:25:56 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     kvm@vger.kernel.org, alexandru.elisei@arm.com,
        nikos.nikoleris@arm.com, eric.auger@redhat.com
Subject: Re: [PATCH kvm-unit-tests v2 3/8] pci-testdev: ioremap regions
Message-ID: <20210426162556.krirq2gxzigrprqq@gator>
References: <20210420190002.383444-1-drjones@redhat.com>
 <20210420190002.383444-4-drjones@redhat.com>
 <20210426160326.65daca85@slackpad.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426160326.65daca85@slackpad.fritz.box>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 26, 2021 at 04:03:26PM +0100, Andre Przywara wrote:
> On Tue, 20 Apr 2021 20:59:57 +0200
> Andrew Jones <drjones@redhat.com> wrote:
> 
> Hi,
> 
> > Don't assume the physical addresses used with PCI have already been
> > identity mapped.
> > 
> > Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  lib/pci-host-generic.c | 5 ++---
> >  lib/pci-host-generic.h | 4 ++--
> >  lib/pci-testdev.c      | 4 ++++
> >  3 files changed, 8 insertions(+), 5 deletions(-)
> > 
> > diff --git a/lib/pci-host-generic.c b/lib/pci-host-generic.c
> > index 818150dc0a66..de93b8feac39 100644
> > --- a/lib/pci-host-generic.c
> > +++ b/lib/pci-host-generic.c
> > @@ -122,7 +122,7 @@ static struct pci_host_bridge *pci_dt_probe(void)
> >  		      sizeof(host->addr_space[0]) * nr_addr_spaces);
> >  	assert(host != NULL);
> >  
> > -	host->start		= base.addr;
> > +	host->start		= ioremap(base.addr, base.size);
> >  	host->size		= base.size;
> >  	host->bus		= bus;
> >  	host->bus_max		= bus_max;
> > @@ -279,8 +279,7 @@ phys_addr_t pci_host_bridge_get_paddr(u64 pci_addr)
> >  
> >  static void __iomem *pci_get_dev_conf(struct pci_host_bridge *host, int devfn)
> >  {
> > -	return (void __iomem *)(unsigned long)
> > -		host->start + (devfn << PCI_ECAM_DEVFN_SHIFT);
> > +	return (void __iomem *)host->start + (devfn << PCI_ECAM_DEVFN_SHIFT);
> 
> But host->start's type is now exactly "void __iomem *", so why the cast?

Only because I didn't think to remove it. Will do for v3.

> And are we OK with doing pointer arithmetic on a void pointer?

I'm pretty sure we have other cases, but if you'd prefer I can create a
local char* for the arithmetic and then return it as a void*. (Assuming
that's what you're suggesting I do.)

> 
> >  }
> >  
> >  u8 pci_config_readb(pcidevaddr_t dev, u8 off)
> > diff --git a/lib/pci-host-generic.h b/lib/pci-host-generic.h
> > index fd30e7c74ed8..0ffe6380ec8f 100644
> > --- a/lib/pci-host-generic.h
> > +++ b/lib/pci-host-generic.h
> > @@ -18,8 +18,8 @@ struct pci_addr_space {
> >  };
> >  
> >  struct pci_host_bridge {
> > -	phys_addr_t		start;
> > -	phys_addr_t		size;
> > +	void __iomem		*start;
> > +	size_t			size;
> >  	int			bus;
> >  	int			bus_max;
> >  	int			nr_addr_spaces;
> > diff --git a/lib/pci-testdev.c b/lib/pci-testdev.c
> > index 039bb44781c1..4f2e5663b2d6 100644
> > --- a/lib/pci-testdev.c
> > +++ b/lib/pci-testdev.c
> > @@ -185,7 +185,11 @@ int pci_testdev(void)
> >  	mem = ioremap(addr, PAGE_SIZE);
> >  
> >  	addr = pci_bar_get_addr(&pci_dev, 1);
> > +#if defined(__i386__) || defined(__x86_64__)
> >  	io = (void *)(unsigned long)addr;
> > +#else
> > +	io = ioremap(addr, PAGE_SIZE);
> > +#endif
> 
> I am bit puzzled: For anything but x86 ioremap() is implemented like the
> first statement, so why do we differentiate here? Shouldn't either one
> of the statements be fine, for all architectures?

The addresses in this context are pio. So x86 should use them verbatim,
but other architectures that don't have pio will need to avoid them or
remap them and use them with fake pio instructions (e.g. inb/outb wrappers
for readb/writeb).

Thanks,
drew

