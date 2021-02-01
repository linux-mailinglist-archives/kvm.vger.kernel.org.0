Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1BB030A70A
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 13:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhBAMAx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 07:00:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49846 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229525AbhBAMAw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 07:00:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612180765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qFeawshsqVb5WfCKxUKcyhdc8U97+SxhZ/TVGasj6yM=;
        b=g5V+sFidErBvM0CYZKv/xk64lCMqoIiuYHcbBgNnmK+2J29XSOnBbqwJRJNxaNhOioBBih
        xDHRvCXoMJF5uUKKVh0SSd6ByvXryUn3E3wkj4qfDWdGpv0NpIewmykTL18TbbIlIUsqvC
        IxaQmViGpGfp3eOhE3adWVtaTvF2cWw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-DiLPBZwfPX-ChLm1QUf9fA-1; Mon, 01 Feb 2021 06:59:22 -0500
X-MC-Unique: DiLPBZwfPX-ChLm1QUf9fA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD086100C602;
        Mon,  1 Feb 2021 11:59:20 +0000 (UTC)
Received: from gondolin (ovpn-113-126.ams2.redhat.com [10.36.113.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 71F0E5C276;
        Mon,  1 Feb 2021 11:59:16 +0000 (UTC)
Date:   Mon, 1 Feb 2021 12:59:13 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH V3 3/9] vfio/type1: implement unmap all
Message-ID: <20210201125913.19032d8b.cohuck@redhat.com>
In-Reply-To: <1611939252-7240-4-git-send-email-steven.sistare@oracle.com>
References: <1611939252-7240-1-git-send-email-steven.sistare@oracle.com>
        <1611939252-7240-4-git-send-email-steven.sistare@oracle.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 29 Jan 2021 08:54:06 -0800
Steve Sistare <steven.sistare@oracle.com> wrote:

> Implement VFIO_DMA_UNMAP_FLAG_ALL.
> 
> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

