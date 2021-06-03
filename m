Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CED839983B
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 04:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbhFCCwn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 22:52:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36547 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229568AbhFCCwm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Jun 2021 22:52:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622688658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=axWy42FNcYCinIuczFvW033N1IzY7BuvZJoBLU9MXh0=;
        b=OVLMWkAXYX+qg00YoD1AdsaEtDazdaghsk6VdudM7htZ09G3foSFeeOkhrbhrhrWEU2SPZ
        fxyJyDdKn+9Xf+vxtfEyK58aSTpGEnc3nb+YZ+bBAZARetTftDlI2oh7S7b2fLrW5v0p6w
        fkOkGPgDeLDvNF8BLHVgFG6Erei5Qps=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-KrTFaE4mOcyB2h91IeHkng-1; Wed, 02 Jun 2021 22:50:57 -0400
X-MC-Unique: KrTFaE4mOcyB2h91IeHkng-1
Received: by mail-oi1-f199.google.com with SMTP id x10-20020a54400a0000b02901e9af7e39cbso2248770oie.22
        for <kvm@vger.kernel.org>; Wed, 02 Jun 2021 19:50:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=axWy42FNcYCinIuczFvW033N1IzY7BuvZJoBLU9MXh0=;
        b=FBV+19738QfKaq8cO/FXMPrdAQ+o34fTp/RjTAy9PQ7Wkqe90vEmu7nJa1ru84nbIt
         7ikqt0PVQMmuTSFioTdMJDdkiyQKznrmccW6V4VrPgpSYFWt488kia3JoDx8pSgj4oLP
         qeix/hoGnDfQ8hUZWRoOqLxKxw3tv3FKIpgXW3KQNrtdg51pMlR3JnS3OH+SMGZLtYc2
         Mit4egvxgow4rX2mJWZh3fT5wEdp65KanQihYZvoM5iQ3JplOKZivD/0sFNDkoNl9ghs
         ytXuG19MyMWL03y52NyFmOBwXwl59ZYmg1TfGlng4eNMQPhT1ICF9vnDb00ChuGhBCHs
         yQWQ==
X-Gm-Message-State: AOAM531c8pjwBiHec7icjuViiXk/6+zseQTORTAxHAM5l+OJaD2PE/TX
        qATRI5i82l9J2V06WFlnofd/K9Kakju7MN//+4kPzR/fR/UjBHMiIXqZ51HI6Prv+N3Qtts4Gr2
        NNjU4N/FRqrDq
X-Received: by 2002:a05:6830:1d0:: with SMTP id r16mr4027065ota.116.1622688656868;
        Wed, 02 Jun 2021 19:50:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzuwJmm05loclZmkVCVWQVnwxKgIEoGf6EmbF0Iu9rFnz/PZ9y74D9ApsDmv+T7LVn7CtVHPQ==
X-Received: by 2002:a05:6830:1d0:: with SMTP id r16mr4027052ota.116.1622688656589;
        Wed, 02 Jun 2021 19:50:56 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id l1sm378451oos.37.2021.06.02.19.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 19:50:56 -0700 (PDT)
Date:   Wed, 2 Jun 2021 20:50:54 -0600
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
Message-ID: <20210602205054.3505c9c3.alex.williamson@redhat.com>
In-Reply-To: <20210602224536.GJ1002214@nvidia.com>
References: <20210601162225.259923bc.alex.williamson@redhat.com>
        <MWHPR11MB1886E8454A58661DC2CDBA678C3D9@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210602160140.GV1002214@nvidia.com>
        <20210602111117.026d4a26.alex.williamson@redhat.com>
        <20210602173510.GE1002214@nvidia.com>
        <20210602120111.5e5bcf93.alex.williamson@redhat.com>
        <20210602180925.GH1002214@nvidia.com>
        <20210602130053.615db578.alex.williamson@redhat.com>
        <20210602195404.GI1002214@nvidia.com>
        <20210602143734.72fb4fa4.alex.williamson@redhat.com>
        <20210602224536.GJ1002214@nvidia.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2 Jun 2021 19:45:36 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Jun 02, 2021 at 02:37:34PM -0600, Alex Williamson wrote:
> 
> > Right.  I don't follow where you're jumping to relaying DMA_PTE_SNP
> > from the guest page table... what page table?    
> 
> I see my confusion now, the phrasing in your earlier remark led me
> think this was about allowing the no-snoop performance enhancement in
> some restricted way.
> 
> It is really about blocking no-snoop 100% of the time and then
> disabling the dangerous wbinvd when the block is successful.
> 
> Didn't closely read the kvm code :\
> 
> If it was about allowing the optimization then I'd expect the guest to
> enable no-snoopable regions via it's vIOMMU and realize them to the
> hypervisor and plumb the whole thing through. Hence my remark about
> the guest page tables..
> 
> So really the test is just 'were we able to block it' ?

Yup.  Do we really still consider that there's some performance benefit
to be had by enabling a device to use no-snoop?  This seems largely a
legacy thing.

> > This support existed before mdev, IIRC we needed it for direct
> > assignment of NVIDIA GPUs.  
> 
> Probably because they ignored the disable no-snoop bits in the control
> block, or reset them in some insane way to "fix" broken bioses and
> kept using it even though by all rights qemu would have tried hard to
> turn it off via the config space. Processing no-snoop without a
> working wbinvd would be fatal. Yeesh
> 
> But Ok, back the /dev/ioasid. This answers a few lingering questions I
> had..
> 
> 1) Mixing IOMMU_CAP_CACHE_COHERENCY and !IOMMU_CAP_CACHE_COHERENCY
>    domains.
> 
>    This doesn't actually matter. If you mix them together then kvm
>    will turn on wbinvd anyhow, so we don't need to use the DMA_PTE_SNP
>    anywhere in this VM.
> 
>    This if two IOMMU's are joined together into a single /dev/ioasid
>    then we can just make them both pretend to be
>    !IOMMU_CAP_CACHE_COHERENCY and both not set IOMMU_CACHE.

Yes and no.  Yes, if any domain is !IOMMU_CAP_CACHE_COHERENCY then we
need to emulate wbinvd, but no we'll use IOMMU_CACHE any time it's
available based on the per domain support available.  That gives us the
most consistent behavior, ie. we don't have VMs emulating wbinvd
because they used to have a device attached where the domain required
it and we can't atomically remap with new flags to perform the same as
a VM that never had that device attached in the first place.

> 2) How to fit this part of kvm in some new /dev/ioasid world
> 
>    What we want to do here is iterate over every ioasid associated
>    with the group fd that is passed into kvm.

Yeah, we need some better names, binding a device to an ioasid (fd) but
then attaching a device to an allocated ioasid (non-fd)... I assume
you're talking about the latter ioasid.

>    Today the group fd has a single container which specifies the
>    single ioasid so this is being done trivially.
> 
>    To reorg we want to get the ioasid from the device not the
>    group (see my note to David about the groups vs device rational)
> 
>    This is just iterating over each vfio_device in the group and
>    querying the ioasid it is using.

The IOMMU API group interfaces is largely iommu_group_for_each_dev()
anyway, we still need to account for all the RIDs and aliases of a
group.

>    Or perhaps more directly: an op attaching the vfio_device to the
>    kvm and having some simple helper 
>          '(un)register ioasid with kvm (kvm, ioasid)'
>    that the vfio_device driver can call that just sorts this out.

We could almost eliminate the device notion altogether here, use an
ioasidfd_for_each_ioasid() but we really want a way to trigger on each
change to the composition of the device set for the ioasid, which is
why we currently do it on addition or removal of a group, where the
group has a consistent set of IOMMU properties.  Register a notifier
callback via the ioasidfd?  Thanks,

Alex

