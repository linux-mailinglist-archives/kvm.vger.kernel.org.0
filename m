Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F01B430A7D8
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 13:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbhBAMme (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 07:42:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28593 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231517AbhBAMmP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 07:42:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612183248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AdYn7na+NzTK/spe57QCaXtrSieiZs9GaEBQ4LcelM0=;
        b=gvgfCdXCY4t+B8Hz5nZQTPv09WzM94PrHrWtLGJRDlakHsk0I2JmLaq/sFsCuLOi+QRZrf
        lVnM1rMCNirDEpsnA0XEp7BwdxHu+Xl5NCSedAoal/z426gs2VOzVZoMwKDlrJ/5TOSu2l
        +18Ohftdt+DMoekbqu8JQxQCYB7X/mQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-Qkb9BigIOCK12Prz_5lgFw-1; Mon, 01 Feb 2021 07:40:47 -0500
X-MC-Unique: Qkb9BigIOCK12Prz_5lgFw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDFD28049C0;
        Mon,  1 Feb 2021 12:40:45 +0000 (UTC)
Received: from gondolin (ovpn-113-126.ams2.redhat.com [10.36.113.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EFE641975E;
        Mon,  1 Feb 2021 12:40:41 +0000 (UTC)
Date:   Mon, 1 Feb 2021 13:40:39 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH V3 8/9] vfio/type1: implement notify callback
Message-ID: <20210201134039.3bfd39a4.cohuck@redhat.com>
In-Reply-To: <1611939252-7240-9-git-send-email-steven.sistare@oracle.com>
References: <1611939252-7240-1-git-send-email-steven.sistare@oracle.com>
        <1611939252-7240-9-git-send-email-steven.sistare@oracle.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 29 Jan 2021 08:54:11 -0800
Steve Sistare <steven.sistare@oracle.com> wrote:

> Implement a notify callback that remembers if the container's file
> descriptor has been closed.
> 
> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 15 +++++++++++++++

For the version in Alex' git branch:

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

