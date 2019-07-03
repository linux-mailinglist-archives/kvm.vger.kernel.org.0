Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55A305EDA9
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 22:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbfGCUeg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 16:34:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51212 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726833AbfGCUef (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 16:34:35 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BC912C04D2F7;
        Wed,  3 Jul 2019 20:34:26 +0000 (UTC)
Received: from x1.home (ovpn-116-83.phx2.redhat.com [10.3.116.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9A46517AB4;
        Wed,  3 Jul 2019 20:34:18 +0000 (UTC)
Date:   Wed, 3 Jul 2019 14:34:18 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     <eric.auger@redhat.com>, <pmorel@linux.vnet.ibm.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>, <linuxarm@huawei.com>,
        <john.garry@huawei.com>, <xuwei5@hisilicon.com>,
        <kevin.tian@intel.com>
Subject: Re: [PATCH v7 1/6] vfio/type1: Introduce iova list and add iommu
 aperture validity check
Message-ID: <20190703143418.34a0f1c6@x1.home>
In-Reply-To: <20190626151248.11776-2-shameerali.kolothum.thodi@huawei.com>
References: <20190626151248.11776-1-shameerali.kolothum.thodi@huawei.com>
        <20190626151248.11776-2-shameerali.kolothum.thodi@huawei.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Wed, 03 Jul 2019 20:34:35 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Welcome back Shameer ;)

On Wed, 26 Jun 2019 16:12:43 +0100
Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:

> This introduces an iova list that is valid for dma mappings. Make
> sure the new iommu aperture window doesn't conflict with the current
> one or with any existing dma mappings during attach.
> 
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 181 +++++++++++++++++++++++++++++++-
>  1 file changed, 177 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index add34adfadc7..970d1ec06aed 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -1,4 +1,3 @@
> -// SPDX-License-Identifier: GPL-2.0-only
>  /*
>   * VFIO: IOMMU DMA mapping support for Type1 IOMMU
>   *

Accidental merge deletion?  Thanks,

Alex
