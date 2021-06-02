Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBE539930D
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 21:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbhFBTCl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 15:02:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43534 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229650AbhFBTCl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Jun 2021 15:02:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622660457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MXz63wHFCtBChG1iHvZvXLJp7K/v2y7oMTVIZRydq2I=;
        b=b2X2uSLOiD2nTJfjhPhwh6TPwda/5s3DBuavmbeqah5Z+vB5hs2pS0bqsUlF4UQd+styPE
        ZBvVWOMn0t7RD+qhvJqXukltV6MBimHPL+QMKaGI5L9K1+Akn/FVjHTSvX68/TvJZiWsFz
        ni+smoPMiJ0/tScx+PkOaF6QD2cYWU4=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-8E7u3yulNV6fM1AbeBJOnQ-1; Wed, 02 Jun 2021 15:00:56 -0400
X-MC-Unique: 8E7u3yulNV6fM1AbeBJOnQ-1
Received: by mail-oi1-f200.google.com with SMTP id i6-20020a5440860000b02901f1ccd87497so970446oii.10
        for <kvm@vger.kernel.org>; Wed, 02 Jun 2021 12:00:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MXz63wHFCtBChG1iHvZvXLJp7K/v2y7oMTVIZRydq2I=;
        b=AGGFqzh6Nrhx7+FaqN4Wl3ljugvSD0APPGAa9Lo+uMxWwI+Z58WXKDo2F3On1EEW4q
         EKa45wk+YJIq3IOIikgSJiieF3uGGwmRwSEjuvf8/FuaOQrz5r41NzDpO9AW/bObod3y
         ps1RjWiqkgVDONjy29pCnbhpYYQuGiS/s8qPyXafLYtR9bnvItMz8tA17OAevRYJoQ9d
         brFF7JMhH3iCpO+FXhA4LxGC1YdjRJWZPjve3nMenxeZN/BsM0RBnGsCBDyAS91PYwO7
         Vyao5SNSREvKtA98lns5sX1YQVSh25ci39GthHGF+OphBREvibinTt16fENU4wXGnvh3
         Qnig==
X-Gm-Message-State: AOAM533A8doP6FJEdcsyIAUlwh5BOVpG8o3mg7e72ytolfkVsUUGgvyh
        Y/p2hhho5fTmvoUwdcB8/9J0M0Y4EmfNQgKXcoWIX5NXujvAC7KLadl9MFrN6cRMz/y7A/2aK8l
        zq8KuYJl48G3E
X-Received: by 2002:a05:6830:15c2:: with SMTP id j2mr26008323otr.367.1622660455933;
        Wed, 02 Jun 2021 12:00:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx/5Q90CWT9NIdQ1XwO+Gtz3HwUCNmtONxlvq8I6Bn9cXQgzMIAVDQ/kll8JXgHVYLqh2a7KA==
X-Received: by 2002:a05:6830:15c2:: with SMTP id j2mr26008303otr.367.1622660455621;
        Wed, 02 Jun 2021 12:00:55 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id q5sm163159oia.31.2021.06.02.12.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 12:00:54 -0700 (PDT)
Date:   Wed, 2 Jun 2021 13:00:53 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210602130053.615db578.alex.williamson@redhat.com>
In-Reply-To: <20210602180925.GH1002214@nvidia.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210528200311.GP1002214@nvidia.com>
        <MWHPR11MB188685D57653827B566BF9B38C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210601162225.259923bc.alex.williamson@redhat.com>
        <MWHPR11MB1886E8454A58661DC2CDBA678C3D9@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210602160140.GV1002214@nvidia.com>
        <20210602111117.026d4a26.alex.williamson@redhat.com>
        <20210602173510.GE1002214@nvidia.com>
        <20210602120111.5e5bcf93.alex.williamson@redhat.com>
        <20210602180925.GH1002214@nvidia.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2 Jun 2021 15:09:25 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Jun 02, 2021 at 12:01:11PM -0600, Alex Williamson wrote:
> > On Wed, 2 Jun 2021 14:35:10 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Wed, Jun 02, 2021 at 11:11:17AM -0600, Alex Williamson wrote:
> > >   
> > > > > > > present and be able to test if DMA for that device is cache
> > > > > > > coherent.      
> > > > > 
> > > > > Why is this such a strong linkage to VFIO and not just a 'hey kvm
> > > > > emulate wbinvd' flag from qemu?    
> > > > 
> > > > IIRC, wbinvd has host implications, a malicious user could tell KVM to
> > > > emulate wbinvd then run the op in a loop and induce a disproportionate
> > > > load on the system.  We therefore wanted a way that it would only be
> > > > enabled when required.    
> > > 
> > > I think the non-coherentness is vfio_device specific? eg a specific
> > > device will decide if it is coherent or not?  
> > 
> > No, this is specifically whether DMA is cache coherent to the
> > processor, ie. in the case of wbinvd whether the processor needs to
> > invalidate its cache in order to see data from DMA.  
> 
> I'm confused. This is x86, all DMA is cache coherent unless the device
> is doing something special.
> 
> > > If yes I'd recast this to call kvm_arch_register_noncoherent_dma()
> > > from the VFIO_GROUP_NOTIFY_SET_KVM in the struct vfio_device
> > > implementation and not link it through the IOMMU.  
> > 
> > The IOMMU tells us if DMA is cache coherent, VFIO_DMA_CC_IOMMU maps to
> > IOMMU_CAP_CACHE_COHERENCY for all domains within a container.  
> 
> And this special IOMMU mode is basically requested by the device
> driver, right? Because if you use this mode you have to also use
> special programming techniques.
> 
> This smells like all the "snoop bypass" stuff from PCIE (for GPUs
> even) in a different guise - it is device triggered, not platform
> triggered behavior.

Right, the device can generate the no-snoop transactions, but it's the
IOMMU that essentially determines whether those transactions are
actually still cache coherent, AIUI.

I did experiment with virtually hardwiring the Enable No-Snoop bit in
the Device Control Register to zero, which would be generically allowed
by the PCIe spec, but then we get into subtle dependencies in the device
drivers and clearing the bit again after any sort of reset and the
backdoor accesses to config space which exist mostly in the class of
devices that might use no-snoop transactions (yes, GPUs suck).

It was much easier and more robust to ignore the device setting and rely
on the IOMMU behavior.  Yes, maybe we sometimes emulate wbinvd for VMs
where the device doesn't support no-snoop, but it seemed like platforms
were headed in this direction where no-snoop was ignored anyway.
Thanks,

Alex

