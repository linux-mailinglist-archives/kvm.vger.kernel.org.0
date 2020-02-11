Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 839AF159112
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 14:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730017AbgBKN5u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 08:57:50 -0500
Received: from wnew1-smtp.messagingengine.com ([64.147.123.26]:41711 "EHLO
        wnew1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729509AbgBKN5t (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Feb 2020 08:57:49 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id 3E42970F;
        Tue, 11 Feb 2020 08:57:47 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 11 Feb 2020 08:57:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=monjalon.net; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding:content-type; s=mesmtp;
         bh=noAzCHI04Ek8RDpgVHZPtuU30mmVFLmEki2n2dFXUfk=; b=hEAdjWREXeec
        UBe4OGm3aAkBhgEuC6s/I22PkSk8Qp5WD9sZd2YG3U1I9YFFI1jI2JPfe7CE8kua
        a9cwQ8EDSb1wXlcDnnJxxz05qpS73YVTsL1jk9BUPMwYuZQo55VetRWR4jgubvkw
        VE0SEnS5aHX6ey2GRCcfRVDcGKBgVuY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=noAzCHI04Ek8RDpgVHZPtuU30mmVFLmEki2n2dFXU
        fk=; b=y5Paqyy4NiV6O7SNz07Qb80FTYAjxZH4YjIhM2t1gTxOdGMvkqxirSsjJ
        Q6fSwKqri9dK8G3gtNgxo1R640+6+xgzBlaGD1ayurch2P6wA5yLj8n78rvxaiGI
        Yd544n7+BS/0xChp4rzcHA5C4jkZDNiP2D4jcv+yyhWPyakBFyKM+hF5ezz0B+Tv
        wVJpwUb4yM7QOHA7St4ivDthMER/Mxt+eMyQio8kRsUURkvHDRfHa5hZOTeTu77r
        M0V9DbaHQcHuuWh7yYn1Tou9rsdsc1u3gZLL/OpXADtsIVOv9fN1fTxIelwXcRg2
        zRedtOWfwsJyFjmaVOP8u1ziPH/5g==
X-ME-Sender: <xms:2rJCXpDm4fNVO8qyaB36A6ti_RSmVSf2tsLD7ela3qvNr7hgN6edGA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrieefgdehlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkjghfggfgtgesthfuredttddtvdenucfhrhhomhepvfhhohhmrghs
    ucfoohhnjhgrlhhonhcuoehthhhomhgrshesmhhonhhjrghlohhnrdhnvghtqeenucfkph
    epjeejrddufeegrddvtdefrddukeegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghr
    rghmpehmrghilhhfrhhomhepthhhohhmrghssehmohhnjhgrlhhonhdrnhgvth
X-ME-Proxy: <xmx:2rJCXq7fF8aqvNdXEcyrvltANgu3CGdUxC0WpymCsa7MaNj8jgW4VA>
    <xmx:2rJCXv2jjxQEkHCAQQYcMaI-DJDPYIKZPbiGvfK8f24-MoY664lTzw>
    <xmx:2rJCXlSQdpgKERW12Dki5jngEP_sTxf67BMK7q97PS56vK1cDBp-dA>
    <xmx:2rJCXuSprx1LlVxeacnKLUvMQm8fKQ7rvAe4dbSq2z_2yE6U4nH1TxQxK-0>
Received: from xps.localnet (184.203.134.77.rev.sfr.net [77.134.203.184])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4AB833060840;
        Tue, 11 Feb 2020 08:57:45 -0500 (EST)
From:   Thomas Monjalon <thomas@monjalon.net>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     dev@dpdk.org, kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dev@dpdk.org, mtosatti@redhat.com,
        Luca Boccassi <bluca@debian.org>,
        "Richardson, Bruce" <bruce.richardson@intel.com>,
        cohuck@redhat.com, Vamsi Attunuru <vattunuru@marvell.com>,
        Jerin Jacob <jerinjacobk@gmail.com>
Subject: Re: [dpdk-dev] [RFC PATCH 0/7] vfio/pci: SR-IOV support
Date:   Tue, 11 Feb 2020 14:57:44 +0100
Message-ID: <2203508.9fHWaBTJ5E@xps>
In-Reply-To: <CALBAE1Oz2u+cmoL8LhEZ-4paXEebKh3DzfWGLQLQx0oaW=tBXw@mail.gmail.com>
References: <158085337582.9445.17682266437583505502.stgit@gimli.home> <CALBAE1Oz2u+cmoL8LhEZ-4paXEebKh3DzfWGLQLQx0oaW=tBXw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

11/02/2020 12:18, Jerin Jacob:
> On Wed, Feb 5, 2020 at 4:35 AM Alex Williamson wrote:
> >
> > There seems to be an ongoing desire to use userspace, vfio-based
> > drivers for both SR-IOV PF and VF devices.  The fundamental issue
> > with this concept is that the VF is not fully independent of the PF
> > driver.  Minimally the PF driver might be able to deny service to the
> > VF, VF data paths might be dependent on the state of the PF device,
> > or the PF my have some degree of ability to inspect or manipulate the
> > VF data.  It therefore would seem irresponsible to unleash VFs onto
> > the system, managed by a user owned PF.
> >
> > We address this in a few ways in this series.  First, we can use a bus
> > notifier and the driver_override facility to make sure VFs are bound
> > to the vfio-pci driver by default.  This should eliminate the chance
> > that a VF is accidentally bound and used by host drivers.  We don't
> > however remove the ability for a host admin to change this override.
> >
> > The next issue we need to address is how we let userspace drivers
> > opt-in to this participation with the PF driver.  We do not want an
> > admin to be able to unwittingly assign one of these VFs to a tenant
> > that isn't working in collaboration with the PF driver.  We could use
> > IOMMU grouping, but this seems to push too far towards tightly coupled
> > PF and VF drivers.  This series introduces a "VF token", implemented
> > as a UUID, as a shared secret between PF and VF drivers.  The token
> > needs to be set by the PF driver and used as part of the device
> > matching by the VF driver.  Provisions in the code also account for
> > restarting the PF driver with active VF drivers, requiring the PF to
> > use the current token to re-gain access to the PF.
> 
> Thanks Alex for the series. DPDK realizes this use-case through, an out of
> tree igb_uio module, for non VFIO devices. Supporting this use case, with
> VFIO, will be a great enhancement for DPDK as we are planning to
> get rid of out of tree modules any focus only on userspace aspects.
[..]
> Regarding the use case where  PF bound to DPDK/VFIO and
> VF bound to DPDK/VFIO are _two different_ processes then sharing the UUID
> will be a little tricky thing in terms of usage. But if that is the
> purpose of bringing UUID to the equation then it fine.
> 
> Overall this series looks good to me.  We can test the next non-RFC
> series and give
> Tested-by by after testing with DPDK.
[..]
> > Please comment.  In particular, does this approach meet the DPDK needs
> > for userspace PF and VF drivers, with the hopefully minor hurdle of
> > sharing a token between drivers.  The token is of course left to
> > userspace how to manage, and might be static (and not very secret) for
> > a given set of drivers.  Thanks,

Thanks Alex, it looks to be a great improvement.

In the meantime, DPDK is going to move igb_uio (an out-of-tree
Linux kernel module) from the main DPDK repository to a side-repo.
This move and this patchset will hopefully encourage using VFIO.
As Jerin said, DPDK prefers relying on upstream Linux modules.


