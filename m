Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5DE535D83B
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 08:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345072AbhDMGtP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 02:49:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49607 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244532AbhDMGtI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Apr 2021 02:49:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618296528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GJP8fy7iKl8dKDV7E0klDhAvK0oVKdzafF/dYILoImU=;
        b=LJI7/2S4imkvlvRrVQ0QleTE9OcAjzjNrDZF3FRxbM/AFLaKjc2b5H2GOqFaIJ7tB9oQx3
        fuZNVIz6ucxp1AAywhCSGSpiEnhQ70XFXBrRtIhQvNDqUTOrvtIiwXXN8DzSdxYHhN0JmA
        YZRKA5JvsHarYk7nDzVoDfNxbhcGchM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-uCC3GaStOo-ZktgeWFkllg-1; Tue, 13 Apr 2021 02:48:44 -0400
X-MC-Unique: uCC3GaStOo-ZktgeWFkllg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B3C7A18766D4;
        Tue, 13 Apr 2021 06:48:42 +0000 (UTC)
Received: from gondolin (ovpn-113-97.ams2.redhat.com [10.36.113.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 094F96062F;
        Tue, 13 Apr 2021 06:48:36 +0000 (UTC)
Date:   Tue, 13 Apr 2021 08:48:34 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     "Christian A. Ehrhardt" <lk@c--e.de>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] vfio/pci: Add missing range check in vfio_pci_mmap
Message-ID: <20210413084834.1d5cd6cb.cohuck@redhat.com>
In-Reply-To: <20210412214124.GA241759@lisa.in-ulm.de>
References: <20210410230013.GC416417@lisa.in-ulm.de>
        <20210412140238.184e141f@omen>
        <20210412214124.GA241759@lisa.in-ulm.de>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 12 Apr 2021 23:41:24 +0200
"Christian A. Ehrhardt" <lk@c--e.de> wrote:

> When mmaping an extra device region verify that the region index
> derived from the mmap offset is valid.
> 
> Fixes: a15b1883fee1 ("vfio_pci: Allow mapping extra regions")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
> ---
>  drivers/vfio/pci/vfio_pci.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

