Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21FCA355C42
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 21:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244870AbhDFTiI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 15:38:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22687 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242537AbhDFTiG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 15:38:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617737878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8dMs3nqHBT5cQBi5MtXM5AYMaRA0akJjO+wkzuphB+8=;
        b=S9jnanZNsIo5IBZdzBX8AcuCsmAb993ZhrI07yQJQoPduLbFufq6FSDs6oJYnznDWvcLEZ
        vMRhfYZBEaBTmlrllPBTZWG8KCUdowaf63i0EVKtJkZ5fqrimNYjqG3qJUtyZUN6NOhN0V
        EtSlxI/KgTpUJhlVd8soXQ/uCZAyHk8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-ZMisu-1SPDqTSaMbVSPhWA-1; Tue, 06 Apr 2021 15:37:56 -0400
X-MC-Unique: ZMisu-1SPDqTSaMbVSPhWA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AEFDC881D7C;
        Tue,  6 Apr 2021 19:37:53 +0000 (UTC)
Received: from omen (ovpn-112-85.phx2.redhat.com [10.3.112.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 38BAB60240;
        Tue,  6 Apr 2021 19:37:45 +0000 (UTC)
Date:   Tue, 6 Apr 2021 13:37:44 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] vfio: fix a couple of spelling mistakes detected by
 codespell tool
Message-ID: <20210406133744.4c7dc047@omen>
In-Reply-To: <20210326083528.1329-1-thunder.leizhen@huawei.com>
References: <20210326083528.1329-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 26 Mar 2021 16:35:24 +0800
Zhen Lei <thunder.leizhen@huawei.com> wrote:

> This detection and correction covers the entire driver/vfio directory.
> 
> Zhen Lei (4):
>   vfio/type1: fix a couple of spelling mistakes
>   vfio/mdev: Fix spelling mistake "interal" -> "internal"
>   vfio/pci: fix a couple of spelling mistakes
>   vfio/platform: Fix spelling mistake "registe" -> "register"
> 
>  drivers/vfio/mdev/mdev_private.h                         | 2 +-
>  drivers/vfio/pci/vfio_pci.c                              | 2 +-
>  drivers/vfio/pci/vfio_pci_config.c                       | 2 +-
>  drivers/vfio/pci/vfio_pci_nvlink2.c                      | 4 ++--
>  drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c | 2 +-
>  drivers/vfio/vfio_iommu_type1.c                          | 6 +++---
>  6 files changed, 9 insertions(+), 9 deletions(-)
> 

Applied to vfio next branch for v5.13.  Thanks,

Alex

