Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFC637ABDF
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 18:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbhEKQ0p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 12:26:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23735 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230505AbhEKQ0p (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 12:26:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620750338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OusyYXiQhXg6c3vs/eYfyDHu27HZNA8tSA4FHdbDiJY=;
        b=Xhp1y67peyIDPjtFCjThOzXJDV6a9xOXIUrjFn4LfbemDrkUvfAcIXDDdZepXC1mXdxG+k
        aGqAzVuaTROAroKg6uPGPwi42nuARjsx93o/GxUahcvPOHHFF51v0AAA2QMsN3EFowQnb7
        vpLUUJe1/XsXmzFg5VQFPYr/JTi9s18=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-519-VND6uriHPsqgId46I-eZqQ-1; Tue, 11 May 2021 12:25:33 -0400
X-MC-Unique: VND6uriHPsqgId46I-eZqQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90CCB8015F5;
        Tue, 11 May 2021 16:25:32 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-172.ams2.redhat.com [10.36.113.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F374610016F4;
        Tue, 11 May 2021 16:25:27 +0000 (UTC)
Date:   Tue, 11 May 2021 18:25:25 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 6/6] s390x: Add UV host test
Message-ID: <20210511182525.1bdfb934.cohuck@redhat.com>
In-Reply-To: <20210510135148.1904-7-frankja@linux.ibm.com>
References: <20210510135148.1904-1-frankja@linux.ibm.com>
        <20210510135148.1904-7-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 10 May 2021 13:51:48 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Let's also test the UV host interfaces.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  s390x/Makefile  |   1 +
>  s390x/uv-host.c | 480 ++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 481 insertions(+)
>  create mode 100644 s390x/uv-host.c
> 

(...)

> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
> new file mode 100644
> index 00000000..2e4cba10
> --- /dev/null
> +++ b/s390x/uv-host.c
> @@ -0,0 +1,480 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Guest Ultravisor Call tests

s/Guest/Host/ ?

> + *
> + * Copyright (c) 2021 IBM Corp
> + *
> + * Authors:
> + *  Janosch Frank <frankja@linux.ibm.com>
> + */
> +

(...)

Looks reasonable, even though I cannot verify the implementation.

Acked-by: Cornelia Huck <cohuck@redhat.com>

