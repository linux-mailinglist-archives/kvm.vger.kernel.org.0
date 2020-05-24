Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA441DFD75
	for <lists+kvm@lfdr.de>; Sun, 24 May 2020 08:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgEXGmD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 May 2020 02:42:03 -0400
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:50613 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726331AbgEXGmD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 24 May 2020 02:42:03 -0400
X-Greylist: delayed 587 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 May 2020 02:42:03 EDT
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id 283E2A54;
        Sun, 24 May 2020 02:32:15 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sun, 24 May 2020 02:32:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=+9HzwLQSbQfYn3g9WBAL+QyA/zS
        EfIyEySNaCOOLJtQ=; b=DSE8S2urYUF3yKuGMCVBRHZnmBO3fLOW58BIbytOY9g
        dxEjWsEHkFuvDT5JhGyzzbFxQP0Twr9YGFR2kMGlRWiyrqUv70f0ESdlDMjzh4KE
        yzHvj+Cjhfmw1bnznaJGkq+4RrjUnBADlgoT8NZAWu6ypSH9LVV7h4wzWaQleDgC
        rpwQtUqaEcXCBt8lI2kywDY0sY4dt1rvUQeMw2Vbvie3CzFnkYOUk3WfDvGwDQ1p
        X9E/2hIr6QJmaR0HjFVAI6y+HCjxtNEhGrXkhUsW7LniXZ2ueND616AGhJ5K+cL6
        Y7zi/Tw1LaIuQr9jNzt3OYGCuYYR23Qakl3/h0D3W6A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=+9HzwL
        QSbQfYn3g9WBAL+QyA/zSEfIyEySNaCOOLJtQ=; b=yele04aEwz9btCbpulaeeW
        WXfjh5wU9s7y+4+Fknuw5veAfmbbn0X/vJMKGk433LjLvOLZO875cAYMVkDAk6ZW
        rRVsqpxhVbijBxi4ERFBZVl11gzjo1mN7T5A+tmW1ptL6nMF3bnRegJLS48yg4Bh
        CUZwRcTR7JjMRF6t+sqgBiTdjeEJIkgwWYXguwh6pSoWVRRlJ14Wwu8dGDvoG4WL
        aW/OO2KQhIbFHBiOVuHcCH8LoVNGWcdlxP4m8+3MN8F9pVTiRuEwuWLEyRBRZx1O
        ZMFX5U+Izg9cxQWzX8P/GnpX+me3aIcK7jSiUg3GVQUsqoUVNP49Wa5Q4Js24qUg
        ==
X-ME-Sender: <xms:7hTKXlxAVDK5bF3MvIkv7iSxjRAbQ6jbBR4KGMGwblTahGaDhra_Dw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddujedgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:7hTKXlQreIS6z1gUEM3WqNS3XadRWNXTjDSSm1JT47KUes_d1XUU0g>
    <xmx:7hTKXvVC6B5XKX7BYbuIM5XaFER0dmk2nW8RZnCT7h6fl4B_hn1qUA>
    <xmx:7hTKXngMzElnSVcKdDrrqvE4KE5LY-3bZWK-nrp9ca8OHsWqkInaww>
    <xmx:7hTKXpQAzwRPw_n7ZO_26S_Wq1DOQe2sGLmVLT8Qm8sMzCGjkcrgG8582_M>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 104F930664F8;
        Sun, 24 May 2020 02:32:14 -0400 (EDT)
Date:   Sun, 24 May 2020 08:32:10 +0200
From:   Greg KH <greg@kroah.com>
To:     Alexander Graf <graf@amazon.de>
Cc:     Andra Paraschiv <andraprs@amazon.com>,
        linux-kernel@vger.kernel.org,
        Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, kvm@vger.kernel.org,
        ne-devel-upstream@amazon.com
Subject: Re: [PATCH v2 04/18] nitro_enclaves: Init PCI device driver
Message-ID: <20200524063210.GA1369260@kroah.com>
References: <20200522062946.28973-1-andraprs@amazon.com>
 <20200522062946.28973-5-andraprs@amazon.com>
 <20200522070414.GB771317@kroah.com>
 <68b86d32-1255-f9ce-4366-12219ce07ba6@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68b86d32-1255-f9ce-4366-12219ce07ba6@amazon.de>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 23, 2020 at 10:25:25PM +0200, Alexander Graf wrote:
> Hey Greg,
> 
> On 22.05.20 09:04, Greg KH wrote:
> > 
> > On Fri, May 22, 2020 at 09:29:32AM +0300, Andra Paraschiv wrote:
> > > +/**
> > > + * ne_setup_msix - Setup MSI-X vectors for the PCI device.
> > > + *
> > > + * @pdev: PCI device to setup the MSI-X for.
> > > + *
> > > + * @returns: 0 on success, negative return value on failure.
> > > + */
> > > +static int ne_setup_msix(struct pci_dev *pdev)
> > > +{
> > > +     struct ne_pci_dev *ne_pci_dev = NULL;
> > > +     int nr_vecs = 0;
> > > +     int rc = -EINVAL;
> > > +
> > > +     if (WARN_ON(!pdev))
> > > +             return -EINVAL;
> > 
> > How can this ever happen?  If it can not, don't test for it.  If it can,
> > don't warn for it as that will crash systems that do panic-on-warn, just
> > test and return an error.
> 
> I think the point here is to catch situations that should never happen, but
> keep a sanity check in in case they do happen. This would've usually been a
> BUG_ON, but people tend to dislike those these days because they can bring
> down your system ...

Same for WARN_ON when you run with panic-on-warn enabled :(

> So in this particular case here I agree that it's a bit silly to check
> whether pdev is != NULL. In other device code internal APIs though it's not
> quite as clear of a cut. I by far prefer code that tells me it's broken over
> reverse engineering stray pointer accesses ...

For static calls where you control the callers, don't do checks like
this.  Otherwise the kernel would just be full of these all over the
place and things would slow down.  It's just not needed.

> > > +     ne_pci_dev = pci_get_drvdata(pdev);
> > > +     if (WARN_ON(!ne_pci_dev))
> > > +             return -EINVAL;
> > 
> > Same here, don't use WARN_ON if at all possible.
> > 
> > > +
> > > +     nr_vecs = pci_msix_vec_count(pdev);
> > > +     if (nr_vecs < 0) {
> > > +             rc = nr_vecs;
> > > +
> > > +             dev_err_ratelimited(&pdev->dev,
> > > +                                 NE "Error in getting vec count [rc=%d]\n",
> > > +                                 rc);
> > > +
> > 
> > Why ratelimited, can this happen over and over and over?
> 
> In this particular function, no, so here it really should just be dev_err.
> Other functions are implicitly callable from user space through an ioctl,
> which means they really need to stay rate limited.

Think through these as the driver seems to ONLY use these ratelimited
calls right now, which is not correct.

Also, if a user can create a printk, that almost always is not a good
idea.  But yes, those should be ratelimited.

thanks,

greg k-h
