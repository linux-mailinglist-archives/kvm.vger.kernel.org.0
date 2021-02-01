Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A5B30A7F4
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 13:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbhBAMtO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 07:49:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55915 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231299AbhBAMtL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 07:49:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612183665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S/7aX9vb2/jn4cr3Se7bq0ThMQIG40s2loTMgaWB+7Y=;
        b=WX+QGm+4P85lcau5VoVQApHQMHaaM8NjhNHcTGGIiwuMboPMF2xLBpcIdIs8KAn5kvUrhJ
        H1uVIfy3+dTw/b01491zaDqKa1uraZZyg2yPY1Jw794pzHu/eKA4eI+tYqkgWADrXE4+Nx
        wrmQBfDYZr4qe7LwHP1/S9br6r0GezI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-hMSA605qOrOBIgcSe0-A9w-1; Mon, 01 Feb 2021 07:47:43 -0500
X-MC-Unique: hMSA605qOrOBIgcSe0-A9w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5429410054FF;
        Mon,  1 Feb 2021 12:47:42 +0000 (UTC)
Received: from gondolin (ovpn-113-126.ams2.redhat.com [10.36.113.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E3535D749;
        Mon,  1 Feb 2021 12:47:38 +0000 (UTC)
Date:   Mon, 1 Feb 2021 13:47:35 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH V3 9/9] vfio/type1: block on invalid vaddr
Message-ID: <20210201134735.0c216d90.cohuck@redhat.com>
In-Reply-To: <1611939252-7240-10-git-send-email-steven.sistare@oracle.com>
References: <1611939252-7240-1-git-send-email-steven.sistare@oracle.com>
        <1611939252-7240-10-git-send-email-steven.sistare@oracle.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 29 Jan 2021 08:54:12 -0800
Steve Sistare <steven.sistare@oracle.com> wrote:

> Block translation of host virtual address while an iova range has an
> invalid vaddr.
> 
> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 95 ++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 90 insertions(+), 5 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

