Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E06344E5B74
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 23:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241331AbiCWWxD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 18:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233476AbiCWWxB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 18:53:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 21DC28FE72
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 15:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648075889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zXrtNBop4eytCkK2KN6cn5OV3XYINsz2pixN2ZjW6Ik=;
        b=bubOzKKHrDSveK3Qnn2pQ831cFYZARexybcO7MF5E8Rjc0Ld26+XX98F3TODytd4dsTrN1
        2uTsovIx1vB05pmjMyU4/MOgnCQ1l3MNwyZiKKkJPqMqidLlT6LEJEYOLGnXpjIis5Kmem
        DHbdstc7SX77/0Cl8gndtmVtNryqjro=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-374-kpNKX_9kPC-FvH_Hlc-W-Q-1; Wed, 23 Mar 2022 18:51:28 -0400
X-MC-Unique: kpNKX_9kPC-FvH_Hlc-W-Q-1
Received: by mail-io1-f72.google.com with SMTP id f5-20020a6be805000000b00649b9faf257so1969872ioh.9
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 15:51:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=zXrtNBop4eytCkK2KN6cn5OV3XYINsz2pixN2ZjW6Ik=;
        b=w+sk1oza/x5ZBbu+QJ0hvphP3EuJk3RcRvuQFpqJtxkeVglTMNr5Dqs/s8SUd+D+JW
         LsTCAvoAXpQSvYSDy5/GwJd2F/Lks3NV6r1KF+8GzjA0340DZPx025OLdlR1qBWV2N7A
         mC4UWwS4bnC7iAya7buFzytgyFh/vhBS8mht6xHITLMg8glwtqVckFkmIpiNfNpxCZxT
         0gKvhbMMFGRMyqwDnPbCFcYpTwZcLExd9VAtcK8bFwgWF5mmlhxUEUiZdfJ/02NMuEQM
         0shSDzNxb6I98/ABbM27eexrh6aXo/Z/xmYZqeMrHEtEGfIjS0eZlc4V9f1Mz8Cyr4ZG
         dT4w==
X-Gm-Message-State: AOAM533wuynzOyIhWpmXnIjdD3dfpJbYVdlQn6zW1BgX+ADBGntUc6Nu
        MfYeg0Q6VB479/dw8k8iWjVY+jdsDgJ1xWSywQT0f3Tudj+ewTH6gg8q+ZkFTJ+RQnmUXMxU4l+
        m2X509sh5122n
X-Received: by 2002:a02:6a60:0:b0:315:4758:1be1 with SMTP id m32-20020a026a60000000b0031547581be1mr1206119jaf.316.1648075887553;
        Wed, 23 Mar 2022 15:51:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzaJn0eLN0Gn/0djTc0vdh5GoRl0UtWStWyphWNYG4Z5xTQIQiC8E7G1j0lHiTi9xOjH2m+wQ==
X-Received: by 2002:a02:6a60:0:b0:315:4758:1be1 with SMTP id m32-20020a026a60000000b0031547581be1mr1206105jaf.316.1648075887341;
        Wed, 23 Mar 2022 15:51:27 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id b11-20020a92c56b000000b002c76a618f52sm697615ilj.63.2022.03.23.15.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 15:51:27 -0700 (PDT)
Date:   Wed, 23 Mar 2022 16:51:25 -0600
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
Subject: Re: [PATCH RFC 11/12] iommufd: vfio container FD ioctl
 compatibility
Message-ID: <20220323165125.5efd5976.alex.williamson@redhat.com>
In-Reply-To: <11-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
References: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
        <11-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
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

On Fri, 18 Mar 2022 14:27:36 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> iommufd can directly implement the /dev/vfio/vfio container IOCTLs by
> mapping them into io_pagetable operations. Doing so allows the use of
> iommufd by symliking /dev/vfio/vfio to /dev/iommufd. Allowing VFIO to
> SET_CONTAINER using a iommufd instead of a container fd is a followup
> series.
> 
> Internally the compatibility API uses a normal IOAS object that, like
> vfio, is automatically allocated when the first device is
> attached.
> 
> Userspace can also query or set this IOAS object directly using the
> IOMMU_VFIO_IOAS ioctl. This allows mixing and matching new iommufd only
> features while still using the VFIO style map/unmap ioctls.
> 
> While this is enough to operate qemu, it is still a bit of a WIP with a
> few gaps to be resolved:
> 
>  - Only the TYPE1v2 mode is supported where unmap cannot punch holes or
>    split areas. The old mode can be implemented with a new operation to
>    split an iopt_area into two without disturbing the iopt_pages or the
>    domains, then unmapping a whole area as normal.
> 
>  - Resource limits rely on memory cgroups to bound what userspace can do
>    instead of the module parameter dma_entry_limit.
> 
>  - VFIO P2P is not implemented. Avoiding the follow_pfn() mis-design will
>    require some additional work to properly expose PFN lifecycle between
>    VFIO and iommfd
> 
>  - Various components of the mdev API are not completed yet
>
>  - Indefinite suspend of SW access (VFIO_DMA_MAP_FLAG_VADDR) is not
>    implemented.
> 
>  - The 'dirty tracking' is not implemented
> 
>  - A full audit for pedantic compatibility details (eg errnos, etc) has
>    not yet been done
> 
>  - powerpc SPAPR is left out, as it is not connected to the iommu_domain
>    framework. My hope is that SPAPR will be moved into the iommu_domain
>    framework as a special HW specific type and would expect power to
>    support the generic interface through a normal iommu_domain.

My overall question here would be whether we can actually achieve a
compatibility interface that has sufficient feature transparency that we
can dump vfio code in favor of this interface, or will there be enough
niche use cases that we need to keep type1 and vfio containers around
through a deprecation process?

The locked memory differences for one seem like something that libvirt
wouldn't want hidden and we have questions regarding support for vaddr
hijacking and different ideas how to implement dirty page tracking, not
to mention the missing features that are currently well used, like p2p
mappings, coherency tracking, mdev, etc.

It seems like quite an endeavor to fill all these gaps, while at the
same time QEMU will be working to move to use iommufd directly in order
to gain all the new features.

Where do we focus attention?  Is symlinking device files our proposal
to userspace and is that something achievable, or do we want to use
this compatibility interface as a means to test the interface and
allow userspace to make use of it for transition, if their use cases
allow it, perhaps eventually performing the symlink after deprecation
and eventual removal of the vfio container and type1 code?  Thanks,

Alex

