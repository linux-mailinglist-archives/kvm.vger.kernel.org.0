Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA8E30A753
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 13:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbhBAMNY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 07:13:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54546 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229613AbhBAMNX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 07:13:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612181517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dO623eSNgH7DvF/7OvXP3qdhfM/12DhAQtD7zNGbpMo=;
        b=a9W53ul0kuQp3kYX2jGQ4vICwqI6zsZid7196D7eLO/Byj6lA3Q+yVt//UfWCDFCei24xW
        JTn6YiEnlqC3BQoLBYBCs5z6BgSGp3ohmdsauU6I7rMTkEcbyP2XcG4FJnX50LXSZbiMIe
        3hkXn4/Uc+s2U0tvkEUykrT3sp8VUyw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-rrdzj298MnGPSJoa_OaoYw-1; Mon, 01 Feb 2021 07:11:55 -0500
X-MC-Unique: rrdzj298MnGPSJoa_OaoYw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8EAAB18B9F0A;
        Mon,  1 Feb 2021 12:11:54 +0000 (UTC)
Received: from gondolin (ovpn-113-126.ams2.redhat.com [10.36.113.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B574910013C0;
        Mon,  1 Feb 2021 12:11:50 +0000 (UTC)
Date:   Mon, 1 Feb 2021 13:11:48 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH V3 5/9] vfio/type1: massage unmap iteration
Message-ID: <20210201131148.22f24bbf.cohuck@redhat.com>
In-Reply-To: <1611939252-7240-6-git-send-email-steven.sistare@oracle.com>
References: <1611939252-7240-1-git-send-email-steven.sistare@oracle.com>
        <1611939252-7240-6-git-send-email-steven.sistare@oracle.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 29 Jan 2021 08:54:08 -0800
Steve Sistare <steven.sistare@oracle.com> wrote:

> Modify the iteration in vfio_dma_do_unmap so it does not depend on deletion
> of each dma entry.  Add a variant of vfio_find_dma that returns the entry
> with the lowest iova in the search range to initialize the iteration.  No
> externally visible change, but this behavior is needed in the subsequent
> update-vaddr patch.
> 
> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 35 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 34 insertions(+), 1 deletion(-)

With the function name tweak:

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

