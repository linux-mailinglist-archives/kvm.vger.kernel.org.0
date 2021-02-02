Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB7F30C79E
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 18:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237514AbhBBRZl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 12:25:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53416 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236637AbhBBRXb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 12:23:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612286526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c3tNOzSSX48fk87F3yP6GVgcUiDHmEx0tM3rnjbmDtU=;
        b=W+KxEgS+jMqbP2JoargjwGZXrv5CoCvXxiGA/K4bJU973F5BW9MxdCLcoaUJAzqxvysGkX
        zH3nTJlq8MnnXUXWn7GHxkQ/70tBKMF3AxoSNNRjHNG8UPv1wZ/0t/ZrDwAW6+krZ3+WCL
        H9hYhFP3F0V/k1RKNbydILZ+0fsfnFE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-0KyRTmpPNlGuBE9gPKJx7g-1; Tue, 02 Feb 2021 12:22:02 -0500
X-MC-Unique: 0KyRTmpPNlGuBE9gPKJx7g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 675548049D0;
        Tue,  2 Feb 2021 17:21:58 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F4F65D9D5;
        Tue,  2 Feb 2021 17:21:56 +0000 (UTC)
Date:   Tue, 2 Feb 2021 10:21:55 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Keqian Zhu <zhukeqian1@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <iommu@lists.linux-foundation.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Cornelia Huck" <cohuck@redhat.com>, Will Deacon <will@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "James Morse" <james.morse@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "Joerg Roedel" <joro@8bytes.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>
Subject: Re: [PATCH v3 0/2] vfio/iommu_type1: some fixes
Message-ID: <20210202102155.60341d38@omen.home.shazbot.org>
In-Reply-To: <20210122092635.19900-1-zhukeqian1@huawei.com>
References: <20210122092635.19900-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 22 Jan 2021 17:26:33 +0800
Keqian Zhu <zhukeqian1@huawei.com> wrote:

> v3:
>  - Populate bitmap unconditionally.
>  - Sanity check notifier when remove all domains.
> 
> v2:
>  - Address suggestions from Alex.
>  - Remove unnecessary patches.
>  
> 
> Keqian Zhu (2):
>   vfio/iommu_type1: Populate full dirty when detach non-pinned group
>   vfio/iommu_type1: Fix some sanity checks in detach group
> 
>  drivers/vfio/vfio_iommu_type1.c | 50 +++++++++++++++++----------------
>  1 file changed, 26 insertions(+), 24 deletions(-)
> 

Applied to vfio next branch for v5.12, dropped WARN_ON in release on
patch 2.  Thanks,

Alex

