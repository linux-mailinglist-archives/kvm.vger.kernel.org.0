Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38D1630A79F
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 13:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbhBAM2u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 07:28:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28583 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229624AbhBAM2s (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 07:28:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612182440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4OIEXX4e6W6+pgAVI+wfFgF9luew8LDCGyyPGKHhAT8=;
        b=gZpNs8zBk21ilIH7j/UP+rkzVbgHPKkQI9GecGFgN2nppG5WFjw01Op6QjUyq4478YDwYp
        NaApDHiuCbMUZZg9jz8O2rjXdC1WNHVvsN11Ud4UIZdcCYf0KB10ZGFK419GfSmAYdce2V
        s3jKSPM9Fy2Ho/Jud2XCl+pCDSLA20c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-GmE8rzRUNta8oRXlmQeHzg-1; Mon, 01 Feb 2021 07:27:17 -0500
X-MC-Unique: GmE8rzRUNta8oRXlmQeHzg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D020510054FF;
        Mon,  1 Feb 2021 12:27:16 +0000 (UTC)
Received: from gondolin (ovpn-113-126.ams2.redhat.com [10.36.113.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 631BF5D9DC;
        Mon,  1 Feb 2021 12:27:12 +0000 (UTC)
Date:   Mon, 1 Feb 2021 13:27:09 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH V3 6/9] vfio/type1: implement interfaces to update vaddr
Message-ID: <20210201132709.6352a9b1.cohuck@redhat.com>
In-Reply-To: <1611939252-7240-7-git-send-email-steven.sistare@oracle.com>
References: <1611939252-7240-1-git-send-email-steven.sistare@oracle.com>
        <1611939252-7240-7-git-send-email-steven.sistare@oracle.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 29 Jan 2021 08:54:09 -0800
Steve Sistare <steven.sistare@oracle.com> wrote:

> Implement VFIO_DMA_UNMAP_FLAG_VADDR, VFIO_DMA_MAP_FLAG_VADDR, and
> VFIO_UPDATE_VADDR.  This is a partial implementation.  Blocking is
> added in a subsequent patch.
> 
> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 62 +++++++++++++++++++++++++++++++++++++----
>  1 file changed, 56 insertions(+), 6 deletions(-)

With the changes in Alex' branch:

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

