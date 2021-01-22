Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1E4300CEE
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 20:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbhAVTv2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 14:51:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60839 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728393AbhAVONm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Jan 2021 09:13:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611324736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U+5hhVODmVZUXrMaQZ3WvoWcwPtBk3RWxhHDoH69d9U=;
        b=JrXUj6umzxrbgp/EQ35k3XhA/YbvN6dZSlyP8gNC5oAi0RrzqO5xoEdQU/ubq+3p70F8fX
        HYZHOZUOHz6BzJzvanKq+FHrq+uKzChYSL40heMsTbgvpD2tP50n+TgZSsSYscu+ZWutjo
        MZPX1LajakNtA4GhnjOMU4WtTS9plxA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-SK5t-NwiPRuApJmmbcE52A-1; Fri, 22 Jan 2021 09:12:14 -0500
X-MC-Unique: SK5t-NwiPRuApJmmbcE52A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E3111922047;
        Fri, 22 Jan 2021 14:12:08 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-109.ams2.redhat.com [10.36.112.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 282D460C13;
        Fri, 22 Jan 2021 14:12:05 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v5 2/3] s390x: define UV compatible I/O
 allocation
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
        drjones@redhat.com, pbonzini@redhat.com
References: <1611322060-1972-1-git-send-email-pmorel@linux.ibm.com>
 <1611322060-1972-3-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <0393eaa1-e3e8-21c4-4e8f-b8dc2cc82983@redhat.com>
Date:   Fri, 22 Jan 2021 15:12:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1611322060-1972-3-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/01/2021 14.27, Pierre Morel wrote:
> To centralize the memory allocation for I/O we define
> the alloc_io_mem/free_io_mem functions which share the I/O
> memory with the host in case the guest runs with
> protected virtualization.
> 
> These functions allocate on a page integral granularity to
> ensure a dedicated sharing of the allocated objects.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>   lib/s390x/malloc_io.c | 71 +++++++++++++++++++++++++++++++++++++++++++
>   lib/s390x/malloc_io.h | 45 +++++++++++++++++++++++++++
>   s390x/Makefile        |  1 +
>   3 files changed, 117 insertions(+)
>   create mode 100644 lib/s390x/malloc_io.c
>   create mode 100644 lib/s390x/malloc_io.h

Acked-by: Thomas Huth <thuth@redhat.com>

