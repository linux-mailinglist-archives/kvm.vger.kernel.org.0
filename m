Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8895230A868
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 14:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbhBANPa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 08:15:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51857 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231259AbhBANPP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 08:15:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612185229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nyvxE4S+tnKGPbbqPNAixL0EJdlwj8mgAwHjE4Qon4Q=;
        b=JI60f/NXYwslTGjHvGUkKpRqMwO/7yuHSlshervhH+r9WAOqDJS9bdBam6ObfULGmqLs+y
        NeLVBy3yDB4611OBhwI62/Cn8G5aLupenSTu62Cf+7UJuN3ZqLSBWAEZo6ssBrKvjhZNgj
        H3HKLN6weEg45PAmCm1YVmUg52QFkEM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-RvuCQ1qwOsO6MWCuhYclTw-1; Mon, 01 Feb 2021 08:13:47 -0500
X-MC-Unique: RvuCQ1qwOsO6MWCuhYclTw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 645488144E6;
        Mon,  1 Feb 2021 13:13:46 +0000 (UTC)
Received: from gondolin (ovpn-113-126.ams2.redhat.com [10.36.113.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7CC505D749;
        Mon,  1 Feb 2021 13:13:42 +0000 (UTC)
Date:   Mon, 1 Feb 2021 14:13:39 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH V3 4/9] vfio: interfaces to update vaddr
Message-ID: <20210201141339.4d8b964a.cohuck@redhat.com>
In-Reply-To: <1611939252-7240-5-git-send-email-steven.sistare@oracle.com>
References: <1611939252-7240-1-git-send-email-steven.sistare@oracle.com>
        <1611939252-7240-5-git-send-email-steven.sistare@oracle.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 29 Jan 2021 08:54:07 -0800
Steve Sistare <steven.sistare@oracle.com> wrote:

> Define interfaces that allow the underlying memory object of an iova
> range to be mapped to a new host virtual address in the host process:
> 
>   - VFIO_DMA_UNMAP_FLAG_VADDR for VFIO_IOMMU_UNMAP_DMA
>   - VFIO_DMA_MAP_FLAG_VADDR flag for VFIO_IOMMU_MAP_DMA
>   - VFIO_UPDATE_VADDR extension for VFIO_CHECK_EXTENSION
> 
> Unmap vaddr invalidates the host virtual address in an iova range, and
> blocks vfio translation of host virtual addresses.  DMA to already-mapped
> pages continues.  Map vaddr updates the base VA and resumes translation.
> See comments in uapi/linux/vfio.h for more details.
> 
> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> ---
>  include/uapi/linux/vfio.h | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

