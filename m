Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 041F231B7CA
	for <lists+kvm@lfdr.de>; Mon, 15 Feb 2021 12:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbhBOLHv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Feb 2021 06:07:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43979 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229945AbhBOLHs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Feb 2021 06:07:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613387182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1b8OKYqm6plkCFR5I+1HOTic8ptpFn+xfxbEv5GcZW4=;
        b=bc60VqTUCM1m5WXKbuGslaOvnn6vqCaD9c0nXH7M+L3Lzd9xINnkz/WM/r//RC5xvIzkjD
        1XvUkEqDvPoG8z5F/GQFiMsRJK8u9Nqz8Nlk1epafwST79fzdrD2U3uffuUan2iKRAtg1j
        kDccGdCSfE9lMzeHpwQcICW7JucuKn4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-525-zImforSLMv2-LxTY4sLiXQ-1; Mon, 15 Feb 2021 06:06:18 -0500
X-MC-Unique: zImforSLMv2-LxTY4sLiXQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1FDF9106BAE3;
        Mon, 15 Feb 2021 11:06:17 +0000 (UTC)
Received: from gondolin (ovpn-113-55.ams2.redhat.com [10.36.113.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B0DC272161;
        Mon, 15 Feb 2021 11:06:09 +0000 (UTC)
Date:   Mon, 15 Feb 2021 12:06:07 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jgg@nvidia.com, peterx@redhat.com
Subject: Re: [PATCH] vfio/type1: Use follow_pte()
Message-ID: <20210215120607.66b2630f.cohuck@redhat.com>
In-Reply-To: <161315649533.7249.11715726297751446001.stgit@gimli.home>
References: <161315649533.7249.11715726297751446001.stgit@gimli.home>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 12 Feb 2021 12:01:50 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> follow_pfn() doesn't make sure that we're using the correct page
> protections, get the pte with follow_pte() so that we can test
> protections and get the pfn from the pte.
> 
> Fixes: 5cbf3264bc71 ("vfio/type1: Fix VA->PA translation for PFNMAP VMAs in vaddr_get_pfn()")
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c |   14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 

With the function signature adapted:

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

