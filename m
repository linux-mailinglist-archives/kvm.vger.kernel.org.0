Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1038048F1C3
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 21:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiANU4T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 15:56:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiANU4T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jan 2022 15:56:19 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C58FC061574
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 12:56:18 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id o7-20020a05600c510700b00347e10f66d1so4164221wms.0
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 12:56:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=a2LK+XCzRUQuX/FKJ8hTnpMWPOfnbChf1uqBe6evn14=;
        b=TatznFHqz4q/JNQk6ZcSu00tRi1lJns+grkgt68v4JlRwWUwEWskbD7Eo1/QtiimJb
         2DsQk8udeSaRNeTIxoGMeKXeBZLrdk5C8MmBA4y49hugKr6IyKWjGfjAL5lix6bsA8YK
         ulzIzHwIN6eFqCez+iFzFoHBlMIrO4dXddOB4EumZ7hYABe22bNEHQyiXlH2ZL2a1DS4
         d/xnj0pe6mNUK9HfdoYjZ/VFHGZuZpM3k77VpECd0aRmjZop+vebKg17agfiYCAZxTlm
         IYmfdW7BsxqYNuk4Fh3pl1C5qn2hoPNWzFvLJ5AmgrMfDaJ/Bt2nismRmwww3tSSzu+R
         r6OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=a2LK+XCzRUQuX/FKJ8hTnpMWPOfnbChf1uqBe6evn14=;
        b=5fIwam40aInH5hpO2AaHTbEj238Ul8Uwfs+Z0ePwLI8dL2wf3jHMkOZLNTTzFXkK6E
         9CftnSsVJYxicjQ296RLMY1Mo1LAOF6TzhRw1THvhx+xm0pfLbLiDIsFlLFya956Uasc
         /rvDeMz1PQ/fQa5YSZ5Tdq1Dot4qPtPURITfcJPDA2i4KOnvU2f6Ek9Rt+CjYPJQt3NQ
         jhGkjz7B1nE8zXtl7GShahxBXt9LMS1tZ/B9z8UeijXehyrtYoc9KTiHnqDmazBGXlnc
         /T1EuANG0UzBeU2Ply6AtoThU8eXgGMZyB3HHmj2JjAo7W46NWJRkCawGRkzdx3EAdPu
         TBjw==
X-Gm-Message-State: AOAM533wfjKJ6+gI2d/idmPidvOvbDD9etZE2v9jYCkZ2NoGwscpP7qt
        kICtzZ5M8ndCCu9Wi4KX6zN5bg==
X-Google-Smtp-Source: ABdhPJxEOp2Wo1ezLBKMdg3Rs8D9/4m/Bwa6/dloggb4D57MyDeWhvpnWUAVCmPkdzXMY6R9wWCD9A==
X-Received: by 2002:a1c:1d17:: with SMTP id d23mr9767788wmd.46.1642193777164;
        Fri, 14 Jan 2022 12:56:17 -0800 (PST)
Received: from larix (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id p62sm6050452wmp.10.2022.01.14.12.56.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 12:56:16 -0800 (PST)
Date:   Fri, 14 Jan 2022 20:56:14 +0000
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        christophe.jaillet@wanadoo.fr, dapeng1.mi@intel.com,
        david@redhat.com, elic@nvidia.com, eperezma@redhat.com,
        flyingpenghao@gmail.com, flyingpeng@tencent.com,
        gregkh@linuxfoundation.org, guanjun@linux.alibaba.com,
        jasowang@redhat.com, jiasheng@iscas.ac.cn, johan@kernel.org,
        keescook@chromium.org, labbott@kernel.org, lingshan.zhu@intel.com,
        lkp@intel.com, luolikang@nsfocus.com, lvivier@redhat.com,
        pasic@linux.ibm.com, sgarzare@redhat.com, somlo@cmu.edu,
        trix@redhat.com, wu000273@umn.edu, xianting.tian@linux.alibaba.com,
        xuanzhuo@linux.alibaba.com, yun.wang@linux.alibaba.com
Subject: Re: [GIT PULL] virtio,vdpa,qemu_fw_cfg: features, cleanups, fixes
Message-ID: <YeHjbqjY8Dd+3o1E@larix>
References: <20220114153515-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220114153515-mutt-send-email-mst@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Fri, Jan 14, 2022 at 03:35:15PM -0500, Michael S. Tsirkin wrote:
> Jean-Philippe Brucker (5):
>       iommu/virtio: Add definitions for VIRTIO_IOMMU_F_BYPASS_CONFIG
>       iommu/virtio: Support bypass domains
>       iommu/virtio: Sort reserved regions
>       iommu/virtio: Pass end address to viommu_add_mapping()
>       iommu/virtio: Support identity-mapped domains

Please could you drop these patches, they are from an old version of the
series. The newer version was already in Joerg's pull request and was
merged, so this will conflict.

Thanks,
Jean

