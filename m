Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62143228B74
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731184AbgGUVfX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728606AbgGUVfW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 17:35:22 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07496C0619DB
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 14:35:21 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id y10so36008eje.1
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 14:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pUG6c39OxzQ8IxUpaaU1wklcT+ZDA+H9y6wrizuP1IQ=;
        b=fpVtZ5vr/bl4gwJZ660px4Eks0k0bFp5F00leanT0uPcOTgmoIVnokm+ua/STwjYYU
         9V0Le4JZ7BwvhlVhFXG7Dk6uDAL6avESZPtpqEXkGTTx7a0UAf5JI5cLpd6qdzoiV4pc
         OVZuIyutP3UYG7RX+wyFYILhVk9K+2Bf5Rkkvu4t2vAnzZGCeHNgevlyRyPEZajZKVWb
         LJx3ccmgwBWG3aOFencD4vIdccFY+YTJ+h0qq1fXsevTE8RiRwpAEsyonT9mp1hrf2yM
         MP/VlkjZk9cKmlm2n20iRO2IPBPgE/cY4y2TN8o594hbmdnreaFuvl/GYgmWrPMBcdz8
         wb2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pUG6c39OxzQ8IxUpaaU1wklcT+ZDA+H9y6wrizuP1IQ=;
        b=d4ck57QrPtf8cJfvV3OFmNOBTxqyAQ3xnwUENvTv0GaLUSNLyQq1A13ou23+quiSxf
         bcU1GOe7qU2Eaxd9YcdjWR2aWFRw+pa6ufWFZ+YgINgIEqTEzFnIUGPYWgX+eLuzINSY
         WEznCzr7nGf1KxMGI+qwBmg0CM2nR47MdQ3HFHxm/SLwdP1+10DafqbJ4NJIydbD0+xF
         M+vif7bDDqKZEQeX6wuRc5oiyus4joei4k3FtTS4n5skMru4ByVW72BRkZJHcpemDyZi
         3I/qp5+67pmGtM/GPCYjy3HLqq8EVR8XFufhQ4Y7yY15qF5gQlBVYevJzKmnRev8ecYg
         wiQg==
X-Gm-Message-State: AOAM531Qg6X0InZwHffNpIKanYLci+q61muVCv3SsQUyl7T2mpCFO6fC
        fbRQDJYVY72Yd+v1RrSj2m78g4kP1A3frwIqTckx9A==
X-Google-Smtp-Source: ABdhPJybQSo8dZkcp7h1w6spji8sbGsdM1tSDGznEquhq3K0DjuECAckH4y+EAugj+bvtxFnwhrKgK1z4PC3S6mLDA0=
X-Received: by 2002:a17:906:1a54:: with SMTP id j20mr26707162ejf.455.1595367320599;
 Tue, 21 Jul 2020 14:35:20 -0700 (PDT)
MIME-Version: 1.0
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
 <20200721162858.GA2139881@kroah.com>
In-Reply-To: <20200721162858.GA2139881@kroah.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 21 Jul 2020 14:35:09 -0700
Message-ID: <CAPcyv4gyYPNL87YnCgg6E+NL_URZfiumyaVfe4jGv4XQ0oO=0w@mail.gmail.com>
Subject: Re: [PATCH RFC v2 00/18] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Dave Jiang <dave.jiang@intel.com>, Vinod Koul <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>, maz@kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Yi L Liu <yi.l.liu@intel.com>, Baolu Lu <baolu.lu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Sanjay K Kumar <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>, Jing Lin <jing.lin@intel.com>,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        Dave Hansen <dave.hansen@intel.com>, netanelg@mellanox.com,
        shahafs@mellanox.com, yan.y.zhao@linux.intel.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Samuel Ortiz <samuel.ortiz@intel.com>, mona.hossain@intel.com,
        dmaengine@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, linux-pci@vger.kernel.org,
        KVM list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 21, 2020 at 9:29 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Jul 21, 2020 at 09:02:15AM -0700, Dave Jiang wrote:
> > v2:
>
> "RFC" to me means "I don't really think this is mergable, so I'm
> throwing it out there."  Which implies you know it needs more work
> before others should review it as you are not comfortable with it :(

There's full blown reviewed-by from me on the irq changes. The VFIO /
mdev changes looked ok to me, but I did not feel comfortable / did not
have time to sign-off on them. At the same time I did not see much to
be gained to keeping those internal. So "RFC" in this case is a bit
modest. It's more internal reviewer said this looks like it is going
in the right direction, but wants more community discussion on the
approach.

> So, back-of-the-queue you go...

Let's consider this not RFC in that context. The drivers/base/ pieces
have my review for you, the rest are dmaengine and vfio subsystem
concerns that could use some commentary.
