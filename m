Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 777B54911BD
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 23:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243616AbiAQWbq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 17:31:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24339 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229546AbiAQWbp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 17:31:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642458704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FL822A+VhuSR8ouSoFdCDXJX7fbLnOA4cmggcaKq1ko=;
        b=X9kdFCS15zxFmC++ouhL56o/sQub5mCxYt2HhEYwDQNq1AQU178ANEk9UtYq1aQVZpgpdY
        FwFbRWGdKtbIbXlGNzom0rdnk+cPwBXa22xRZSQb/6MqTKoLLy0Fw6g5zfoGrVS1gk6KY6
        HVWKGJyEZJ2Fk6+tKQ+vqIq0RIPU1kQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-90-M9f-OG-HOeC8HTcfpKe7yg-1; Mon, 17 Jan 2022 17:31:43 -0500
X-MC-Unique: M9f-OG-HOeC8HTcfpKe7yg-1
Received: by mail-ed1-f70.google.com with SMTP id t5-20020aa7db05000000b00402670daeb9so4300044eds.5
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 14:31:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FL822A+VhuSR8ouSoFdCDXJX7fbLnOA4cmggcaKq1ko=;
        b=lDbe4BFLThGoP7ys6N1RNtpRUW1mSqfpkFqpkr0cSh2gq8zUZSNHLm94xH5de02Ra2
         QuN/O3Xisj6QiSOUOo+aZQXErAOvhfuKTaN4zVu7qqLiWH0K+qBt/qGIN+Pfy+BLG9bl
         dRRzF21RAPLqujtJIIYlS+oV7x74TfPtIcOQLMDK8WGZjEe6veCWU4CnwBuHAQLbnD73
         wLZsbNIvh3DY1Ks469JCgpGbGu8Gfrp00wUZBiKBW7QOT1ofP5MviTVJ6ggha5A9b/rM
         mFVdy/5lnEY4X35E2s8+kM7sltbV1KObPDl/lVBgIKGHIr9pDBAYEC2mpuXaRGydZ0S9
         avcw==
X-Gm-Message-State: AOAM532HUWte6goqIBdiO5GyQEVPvF7IZYs507BT6ei/K3JpXuvWya7q
        fjjOPYT6p5YnipqIxcRP4zC/fLH06KsKydJyzujvsZmTB94yE3wKPWNbMg9z83NDLLEzGX+U1TO
        1mn7BDT0o8pSk
X-Received: by 2002:a17:907:3f94:: with SMTP id hr20mr8801502ejc.88.1642458702580;
        Mon, 17 Jan 2022 14:31:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzFtcIaT07HfzGtTIKKXfoD/SNDOq7+REx2KhQH3zo4ePI7rSI/H0kRcW3ViUs+z49kNyQvBw==
X-Received: by 2002:a17:907:3f94:: with SMTP id hr20mr8801484ejc.88.1642458702391;
        Mon, 17 Jan 2022 14:31:42 -0800 (PST)
Received: from redhat.com ([2.55.154.241])
        by smtp.gmail.com with ESMTPSA id a1sm6330754edu.17.2022.01.17.14.31.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 14:31:39 -0800 (PST)
Date:   Mon, 17 Jan 2022 17:31:30 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        christophe.jaillet@wanadoo.fr, dapeng1.mi@intel.com,
        david@redhat.com, elic@nvidia.com, eperezma@redhat.com,
        flyingpenghao@gmail.com, flyingpeng@tencent.com,
        gregkh@linuxfoundation.org, guanjun@linux.alibaba.com,
        jasowang@redhat.com, jean-philippe@linaro.org,
        jiasheng@iscas.ac.cn, johan@kernel.org, keescook@chromium.org,
        labbott@kernel.org, lingshan.zhu@intel.com, lkp@intel.com,
        luolikang@nsfocus.com, lvivier@redhat.com, pasic@linux.ibm.com,
        sgarzare@redhat.com, somlo@cmu.edu, trix@redhat.com,
        wu000273@umn.edu, xianting.tian@linux.alibaba.com,
        xuanzhuo@linux.alibaba.com, yun.wang@linux.alibaba.com
Subject: Re: [GIT PULL] virtio,vdpa,qemu_fw_cfg: features, cleanups, fixes
Message-ID: <20220117172924-mutt-send-email-mst@kernel.org>
References: <20220114153515-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220114153515-mutt-send-email-mst@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 14, 2022 at 03:35:15PM -0500, Michael S. Tsirkin wrote:
> Jean-Philippe Brucker (5):
>       iommu/virtio: Add definitions for VIRTIO_IOMMU_F_BYPASS_CONFIG
>       iommu/virtio: Support bypass domains
>       iommu/virtio: Sort reserved regions
>       iommu/virtio: Pass end address to viommu_add_mapping()
>       iommu/virtio: Support identity-mapped domains

Linus, just making sure we are on the same page: Jean-Philippe
asked me to drop these patches since another version has been
accepted into another tree. So I did and sent v2 of the pull.
Hope that's clear and sorry about the noise.

-- 
MST

