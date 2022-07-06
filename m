Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC795690E2
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 19:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234055AbiGFRma (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 13:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233941AbiGFRmY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 13:42:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 351F024094
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 10:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657129342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bm6ni0e0Z3ZqDaHM6VmzfCaa2VxT43x1YW4zQJliK1o=;
        b=ARIhqBTzHZQ3VgDQMRTAdHi9Y8jPgiIXohT0OxHDSwtw6gl1N1h3ET1DRL3mNkdAKR4gl6
        XQbWPvIJwfAF+rAqbPWyMz8zjxbXnMlgxddojke0zmTnLcIx8i0t1Pk9r4FXhENIQ8ANqy
        gM0XkDbbUUOpgle8EGk3Q9y5Rv5Z12k=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-437-opk7TiHhMZu_q7qFtdi3kw-1; Wed, 06 Jul 2022 13:42:21 -0400
X-MC-Unique: opk7TiHhMZu_q7qFtdi3kw-1
Received: by mail-il1-f197.google.com with SMTP id i8-20020a056e020d8800b002d931252904so8056173ilj.23
        for <kvm@vger.kernel.org>; Wed, 06 Jul 2022 10:42:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Bm6ni0e0Z3ZqDaHM6VmzfCaa2VxT43x1YW4zQJliK1o=;
        b=f2Zy49NZYIQ/qLs6uFXkvSN76+BZJbUg3oA8KtgqYFIRyuF1KtWTG2MxwfLYEel3jj
         jfWMN1fvRYWs0+f+I7q7APmYQtJNhl1V1HRA/Cd9XUJhGQX3ambEE3lRkBVTgVdBCaSj
         J37NPK5qk30GPivaYwpZuKXGShKEL1Nwy7tJIcfZy+XvJ6ixaegv+lZfwJUOWkKqAiWl
         CZo0QLVmhO/lufBXlWUoyOnQf1z3nyjJFzD4SBVLuEzoesN8txaQBS/Ag9kX9+OUlxwq
         KhhiaQaAIOigOv8Crg38LQJ7zmUs+GznSf4ICyNvf8vOxYVO0+XnN9BWf9nZp2aUPIKO
         JGxw==
X-Gm-Message-State: AJIora9SVu5yishTEpiGAMqjlYSFjyxjpr2n52uILcPTfCy3QYUObAYr
        qMO+WRP5zvR69WuKZ3RPaZi69AvXh9kmbj4GLFenJB66p4w/831jDxlYXDSGpZBxOBVo7OU88/J
        kLdmWBJst6VYi
X-Received: by 2002:a05:6e02:1be6:b0:2db:ea7f:10c4 with SMTP id y6-20020a056e021be600b002dbea7f10c4mr17220917ilv.248.1657129340280;
        Wed, 06 Jul 2022 10:42:20 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tKW5hHrIbN8D8MKAPlov0FsaTgJJCZrivyPi82ikNP5NQmibHb26OWtdHiMispm5nOi3tbJA==
X-Received: by 2002:a05:6e02:1be6:b0:2db:ea7f:10c4 with SMTP id y6-20020a056e021be600b002dbea7f10c4mr17220872ilv.248.1657129339926;
        Wed, 06 Jul 2022 10:42:19 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id i83-20020a6bb856000000b0065a47e16f53sm17005663iof.37.2022.07.06.10.42.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 10:42:19 -0700 (PDT)
Date:   Wed, 6 Jul 2022 11:42:17 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Nicolin Chen <nicolinc@nvidia.com>
Cc:     <joro@8bytes.org>, <will@kernel.org>, <marcan@marcan.st>,
        <sven@svenpeter.dev>, <robin.murphy@arm.com>,
        <robdclark@gmail.com>, <baolu.lu@linux.intel.com>,
        <orsonzhai@gmail.com>, <baolin.wang7@gmail.com>,
        <zhang.lyra@gmail.com>, <jean-philippe@linaro.org>,
        <jgg@nvidia.com>, <kevin.tian@intel.com>,
        <suravee.suthikulpanit@amd.com>, <alyssa@rosenzweig.io>,
        <dwmw2@infradead.org>, <mjrosato@linux.ibm.com>,
        <gerald.schaefer@linux.ibm.com>, <thierry.reding@gmail.com>,
        <vdumpa@nvidia.com>, <jonathanh@nvidia.com>, <cohuck@redhat.com>,
        <thunder.leizhen@huawei.com>, <christophe.jaillet@wanadoo.fr>,
        <chenxiang66@hisilicon.com>, <john.garry@huawei.com>,
        <yangyingliang@huawei.com>, <iommu@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 0/5] cover-letter: Simplify vfio_iommu_type1
 attach/detach routine
Message-ID: <20220706114217.105f4f61.alex.williamson@redhat.com>
In-Reply-To: <20220701214455.14992-1-nicolinc@nvidia.com>
References: <20220701214455.14992-1-nicolinc@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 1 Jul 2022 14:44:50 -0700
Nicolin Chen <nicolinc@nvidia.com> wrote:

> This is a preparatory series for IOMMUFD v2 patches. It enforces error
> code -EMEDIUMTYPE in iommu_attach_device() and iommu_attach_group() when
> an IOMMU domain and a device/group are incompatible. It also drops the
> useless domain->ops check since it won't fail in current environment.
> 
> These allow VFIO iommu code to simplify its group attachment routine, by
> avoiding the extra IOMMU domain allocations and attach/detach sequences
> of the old code.
> 
> Worths mentioning the exact match for enforce_cache_coherency is removed
> with this series, since there's very less value in doing that as KVM will
> not be able to take advantage of it -- this just wastes domain memory.
> Instead, we rely on Intel IOMMU driver taking care of that internally.
> 
> This is on github:
> https://github.com/nicolinc/iommufd/commits/vfio_iommu_attach

How do you foresee this going in, I'm imagining Joerg would merge the
first patch via the IOMMU tree and provide a topic branch that I'd
merge into the vfio tree along with the remaining patches.  Sound
right?  Thanks,

Alex

 
> Changelog
> v5:
>  * Rebased on top of Robin's "Simplify bus_type determination".
>  * Fixed a wrong change returning -EMEDIUMTYPE in arm-smmu driver.
>  * Added Baolu's "Reviewed-by".
> v4:
>  * Dropped -EMEDIUMTYPE change in mtk_v1 driver per Robin's input
>  * Added Baolu's and Kevin's Reviewed-by lines
> v3: https://lore.kernel.org/kvm/20220623200029.26007-1-nicolinc@nvidia.com/
>  * Dropped all dev_err since -EMEDIUMTYPE clearly indicates what error.
>  * Updated commit message of enforce_cache_coherency removing patch.
>  * Updated commit message of domain->ops removing patch.
>  * Replaced "goto out_unlock" with simply mutex_unlock() and return.
>  * Added a line of comments for -EMEDIUMTYPE return check.
>  * Moved iommu_get_msi_cookie() into alloc_attach_domain() as a cookie
>    should be logically tied to the lifetime of a domain itself.
>  * Added Kevin's "Reviewed-by".
> v2: https://lore.kernel.org/kvm/20220616000304.23890-1-nicolinc@nvidia.com/
>  * Added -EMEDIUMTYPE to more IOMMU drivers that fit the category.
>  * Changed dev_err to dev_dbg for -EMEDIUMTYPE to avoid kernel log spam.
>  * Dropped iommu_ops patch, and removed domain->ops in VFIO directly,
>    since there's no mixed-driver use case that would fail the sanity.
>  * Updated commit log of the patch removing enforce_cache_coherency.
>  * Fixed a misplace of "num_non_pinned_groups--" in detach_group patch.
>  * Moved "num_non_pinned_groups++" in PATCH-5 to the common path between
>    domain-reusing and new-domain pathways, like the code previously did.
>  * Fixed a typo in EMEDIUMTYPE patch.
> v1: https://lore.kernel.org/kvm/20220606061927.26049-1-nicolinc@nvidia.com/
> 
> Jason Gunthorpe (1):
>   vfio/iommu_type1: Prefer to reuse domains vs match enforced cache
>     coherency
> 
> Nicolin Chen (4):
>   iommu: Return -EMEDIUMTYPE for incompatible domain and device/group
>   vfio/iommu_type1: Remove the domain->ops comparison
>   vfio/iommu_type1: Clean up update_dirty_scope in detach_group()
>   vfio/iommu_type1: Simplify group attachment
> 
>  drivers/iommu/amd/iommu.c                   |   2 +-
>  drivers/iommu/apple-dart.c                  |   4 +-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  15 +-
>  drivers/iommu/arm/arm-smmu/arm-smmu.c       |   5 +-
>  drivers/iommu/arm/arm-smmu/qcom_iommu.c     |   9 +-
>  drivers/iommu/intel/iommu.c                 |  10 +-
>  drivers/iommu/iommu.c                       |  28 ++
>  drivers/iommu/ipmmu-vmsa.c                  |   4 +-
>  drivers/iommu/omap-iommu.c                  |   3 +-
>  drivers/iommu/s390-iommu.c                  |   2 +-
>  drivers/iommu/sprd-iommu.c                  |   6 +-
>  drivers/iommu/tegra-gart.c                  |   2 +-
>  drivers/iommu/virtio-iommu.c                |   3 +-
>  drivers/vfio/vfio_iommu_type1.c             | 352 ++++++++++----------
>  14 files changed, 229 insertions(+), 216 deletions(-)
> 

