Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1FBA2FBC4B
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 17:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729306AbhASQV4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 11:21:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21963 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729319AbhASQUv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Jan 2021 11:20:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611073165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BH8ph4x6tbslCUU39Kg1nnfczx3x5anbI8SBaxkZVBo=;
        b=SWT/2v8M7UxjHcv2RxGhGz75jK1+kJUxLPLi3hlserwHOSMqYHL0dX5m/u1tZw+lHGOeH9
        hpGR8x5wBMfY/mak/Rz/qqLdSmxBH0ZOck9QBlcEY+eXHm8Dm8sbnifOaWnHkpO6yWsxLg
        ehKFireewN6z+/wEZ5KEzbb5DdY2gAo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-l5EMvfv2MhK1e8-RZb0Ofw-1; Tue, 19 Jan 2021 11:19:22 -0500
X-MC-Unique: l5EMvfv2MhK1e8-RZb0Ofw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 047851800D41;
        Tue, 19 Jan 2021 16:19:21 +0000 (UTC)
Received: from gondolin (ovpn-113-246.ams2.redhat.com [10.36.113.246])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 05FD519CB0;
        Tue, 19 Jan 2021 16:19:15 +0000 (UTC)
Date:   Tue, 19 Jan 2021 17:19:13 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        thuth@redhat.com, david@redhat.com, borntraeger@de.ibm.com,
        imbrenda@linux.ibm.com, linux-s390@vger.kernel.org,
        gor@linux.ibm.com, mihajlov@linux.ibm.com
Subject: Re: [PATCH 1/2] s390: uv: Fix sysfs max number of VCPUs reporting
Message-ID: <20210119171913.29cc4a0d.cohuck@redhat.com>
In-Reply-To: <20210119100402.84734-2-frankja@linux.ibm.com>
References: <20210119100402.84734-1-frankja@linux.ibm.com>
        <20210119100402.84734-2-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 19 Jan 2021 05:04:01 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> The number reported by the query is N-1 and I think people reading the
> sysfs file would expect N instead. For users creating VMs there's no
> actual difference because KVM's limit is currently below the UV's
> limit.
> 
> The naming of the field is a bit misleading. Number in this context is
> used like ID and starts at 0. The query field denotes the maximum
> number that can be put into the VCPU number field in the "create
> secure CPU" UV call.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Fixes: a0f60f8431999 ("s390/protvirt: Add sysfs firmware interface for Ultravisor information")
> Cc: stable@vger.kernel.org
> ---
>  arch/s390/boot/uv.c        | 2 +-
>  arch/s390/include/asm/uv.h | 4 ++--
>  arch/s390/kernel/uv.c      | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)

Acked-by: Cornelia Huck <cohuck@redhat.com>

