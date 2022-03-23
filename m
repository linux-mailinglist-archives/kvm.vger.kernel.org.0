Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F68C4E5982
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 21:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238744AbiCWUGX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 16:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235103AbiCWUGW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 16:06:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 42D7B8564D
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 13:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648065890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bGz+TFNC14CQU3pjAYcKlEhO5o+YwP5watp7iY8Dy4Y=;
        b=dMXH5cL22UsQirNK5lZPWe151C+vMxa44fmwGiqrO1Sd54GKWpCHqABpw0F+s7bdxBRn42
        0tiH4ClaCV//6o/5eKzKKo9iF4RxVmvicOA/LAOMb8Pq3od6/zPAFnKqLCV7C8bCVWqQpl
        qR8c9mRG0t6d3cjspTFfah7UGY9hkP0=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-154-b__8X_BdMPeWzhyJwVkgzA-1; Wed, 23 Mar 2022 16:04:49 -0400
X-MC-Unique: b__8X_BdMPeWzhyJwVkgzA-1
Received: by mail-il1-f200.google.com with SMTP id x6-20020a923006000000b002bea39c3974so1512652ile.12
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 13:04:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=bGz+TFNC14CQU3pjAYcKlEhO5o+YwP5watp7iY8Dy4Y=;
        b=EnWUdpr17VgYFfS8s4jbSICKk2MD8nK7B/Gqsw75L18cnKXjebky7mB1wFe+rYWHQ2
         aPG8gVaNaidH5lnAA3Md00krS9VXr9pGqMp7CFIeQJxg0v5P1Qak6DfdGq3K24sRhACW
         Ncc70e6wEazbtI7YMd5GTNSZzfuUXNA5c2bp/2gz+ByyjpHj6Oee2eRnlpAPB8LInT3+
         YG/1p+pAEdU0RLgGRrtal5jJ/qltzKKhtuuqxjZQu4nrE4tHFrepAJgNiGy4pTCFIiZe
         AqxAMLvAp79kiUzoQIyfT5ezs/ExbTc5rE+7812igfZs5NhGSaKtxBnAmZ/wH3V0y0YU
         AlPw==
X-Gm-Message-State: AOAM530FaoD1WTQ4W9KfBtnSd4DXPoSeRa7hRGTZOhNBWHsOR1nXWDCO
        +GUUm0JctgGX4OOKfOQifwXllkr0edtnK9AhQevt1wb6dMoEbm9w0SkhvcartwkVrQvo0Jbjsw9
        LY5/k1aTOXUPe
X-Received: by 2002:a05:6638:ec3:b0:321:367c:a325 with SMTP id q3-20020a0566380ec300b00321367ca325mr950220jas.156.1648065888421;
        Wed, 23 Mar 2022 13:04:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxi4Uc0TDUDV75l1oBqwHgylR118BxFgoAIzQq/nFzh0iyGv7+dfItdpVxdNTEbmSJZU9IBnw==
X-Received: by 2002:a05:6638:ec3:b0:321:367c:a325 with SMTP id q3-20020a0566380ec300b00321367ca325mr950206jas.156.1648065888213;
        Wed, 23 Mar 2022 13:04:48 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id j15-20020a056e02154f00b002c7828da4desm458912ilu.0.2022.03.23.13.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 13:04:47 -0700 (PDT)
Date:   Wed, 23 Mar 2022 14:04:46 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC 08/12] iommufd: IOCTLs for the io_pagetable
Message-ID: <20220323140446.097fd8cc.alex.williamson@redhat.com>
In-Reply-To: <20220323193439.GS11336@nvidia.com>
References: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
        <8-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
        <20220323131038.3b5cb95b.alex.williamson@redhat.com>
        <20220323193439.GS11336@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 23 Mar 2022 16:34:39 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Mar 23, 2022 at 01:10:38PM -0600, Alex Williamson wrote:
> > On Fri, 18 Mar 2022 14:27:33 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > +static int conv_iommu_prot(u32 map_flags)
> > > +{
> > > +	int iommu_prot;
> > > +
> > > +	/*
> > > +	 * We provide no manual cache coherency ioctls to userspace and most
> > > +	 * architectures make the CPU ops for cache flushing privileged.
> > > +	 * Therefore we require the underlying IOMMU to support CPU coherent
> > > +	 * operation.
> > > +	 */
> > > +	iommu_prot = IOMMU_CACHE;  
> > 
> > Where is this requirement enforced?  AIUI we'd need to test
> > IOMMU_CAP_CACHE_COHERENCY somewhere since functions like
> > intel_iommu_map() simply drop the flag when not supported by HW.  
> 
> You are right, the correct thing to do is to fail device
> binding/attach entirely if IOMMU_CAP_CACHE_COHERENCY is not there,
> however we can't do that because Intel abuses the meaning of
> IOMMU_CAP_CACHE_COHERENCY to mean their special no-snoop behavior is
> supported.
> 
> I want Intel to split out their special no-snoop from IOMMU_CACHE and
> IOMMU_CAP_CACHE_COHERENCY so these things have a consisent meaning in
> all iommu drivers. Once this is done vfio and iommufd should both
> always set IOMMU_CACHE and refuse to work without
> IOMMU_CAP_CACHE_COHERENCY. (unless someone knows of an !IOMMU_CACHE
> arch that does in fact work today with vfio, somehow, but I don't..)

IIRC, the DMAR on Intel CPUs dedicated to IGD was where we'd often see
lack of snoop-control support, causing us to have mixed coherent and
non-coherent domains.  I don't recall if you go back far enough in VT-d
history if the primary IOMMU might have lacked this support.  So I
think there are systems we care about with IOMMUs that can't enforce
DMA coherency.

As it is today, if the IOMMU reports IOMMU_CAP_CACHE_COHERENCY and all
mappings make use of IOMMU_CACHE, then all DMA is coherent.  Are you
suggesting IOMMU_CAP_CACHE_COHERENCY should indicate that all mappings
are coherent regardless of mapping protection flags?  What's the point
of IOMMU_CACHE at that point?

> I added a fixme about this.
> 
> > This also seems like an issue relative to vfio compatibility that I
> > don't see mentioned in that patch.  Thanks,  
> 
> Yes, it was missed in the notes for vfio compat that Intel no-snoop is
> not working currently, I fixed it.

Right, I see it in the comments relative to extensions, but missed in
the commit log.  Thanks,

Alex

