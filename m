Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC4C63A2E38
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 16:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbhFJOcK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 10:32:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26001 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231459AbhFJOcJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 10:32:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623335412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mAPolvPdCtosCSBNT7nx1vnRaVFZGlqk6ub5hr2adSs=;
        b=JxtGQhtnkp5NMnZfjXsHzEpxs5P9av+VSeRiL2TN9k29Ez87nnoO/JS/0ix2m1uGzimXPA
        BAMWimfdyi2a+9N/U9AM5MocUgtVwbrL0AGScTMDZH+UwKd9ZdjtWki+jA4pNeWiWqj9hP
        T1q80Oll5t+EWm24zSmmA25SpGhRt78=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-3VkCdjZzMQuHy9wIJqPruQ-1; Thu, 10 Jun 2021 10:30:10 -0400
X-MC-Unique: 3VkCdjZzMQuHy9wIJqPruQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A32280364C
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 14:30:09 +0000 (UTC)
Received: from [10.36.114.17] (ovpn-114-17.ams2.redhat.com [10.36.114.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F14BB60CC9;
        Thu, 10 Jun 2021 14:30:04 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 2/2] add header guards for non-trivial
 headers
To:     Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20210610135937.94375-1-cohuck@redhat.com>
 <20210610135937.94375-3-cohuck@redhat.com>
From:   Laurent Vivier <lvivier@redhat.com>
Message-ID: <02572808-10e8-ca53-0fd7-d13ba1baedb3@redhat.com>
Date:   Thu, 10 Jun 2021 16:30:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210610135937.94375-3-cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/06/2021 15:59, Cornelia Huck wrote:
> Add header guards to headers that do not simply include another one.
> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  lib/argv.h       | 5 +++++
>  lib/arm/io.h     | 5 +++++
>  lib/powerpc/io.h | 5 +++++
>  3 files changed, 15 insertions(+)
> 
> diff --git a/lib/argv.h b/lib/argv.h
> index e5fcf8482ca8..1fd746dc2177 100644
> --- a/lib/argv.h
> +++ b/lib/argv.h
> @@ -5,7 +5,12 @@
>   * under the terms of the GNU Library General Public License version 2.
>   */
>  
> +#ifndef _ARGV_H_
> +#define _ARGV_H_
> +
>  extern void __setup_args(void);
>  extern void setup_args_progname(const char *args);
>  extern void setup_env(char *env, int size);
>  extern void add_setup_arg(const char *arg);
> +
> +#endif
> diff --git a/lib/arm/io.h b/lib/arm/io.h
> index 2746d72e8280..183479c899a9 100644
> --- a/lib/arm/io.h
> +++ b/lib/arm/io.h
> @@ -4,4 +4,9 @@
>   * This work is licensed under the terms of the GNU GPL, version 2.
>   */
>  
> +#ifndef _ARM_IO_H_
> +#define _ARM_IO_H_
> +
>  extern void io_init(void);
> +
> +#endif
> diff --git a/lib/powerpc/io.h b/lib/powerpc/io.h
> index 1f5a7bd6d745..d4f21ba15a54 100644
> --- a/lib/powerpc/io.h
> +++ b/lib/powerpc/io.h
> @@ -4,5 +4,10 @@
>   * This work is licensed under the terms of the GNU GPL, version 2.
>   */
>  
> +#ifndef _POWERPC_IO_H_
> +#define _POWERPC_IO_H_
> +
>  extern void io_init(void);
>  extern void putchar(int c);
> +
> +#endif
> 

Reviewed-by: Laurent Vivier <lvivier@redhat.com>

