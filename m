Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD1AA3058D8
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 11:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235748AbhA0KwL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 05:52:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40674 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236021AbhA0KtL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Jan 2021 05:49:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611744457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PP9Ul/YBsk5CTiiCyoAnHai9JYjJsBJOgzDDyFHnB7c=;
        b=gl/aG2nOqlpp5usBhYpb65qMhc2bHzfo62dy2LD6ga1m/Sm3tBWZ0MdDkcrmCGAYjqE8XG
        YCvlMPOVJvyUgsMVimSXLEstX2SYrwHX/d/QeHykLEODAmjTJxlZdjTHi7J+IEBSV1Faqd
        Y80/3gP+nCBtIoXjo4cH7aRUDMU8Jyg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-nJC8auqJNRmuy2_Fu7Z3iw-1; Wed, 27 Jan 2021 05:47:36 -0500
X-MC-Unique: nJC8auqJNRmuy2_Fu7Z3iw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ECC9A1005E40;
        Wed, 27 Jan 2021 10:47:34 +0000 (UTC)
Received: from gondolin (ovpn-112-95.ams2.redhat.com [10.36.112.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 158A65D9C6;
        Wed, 27 Jan 2021 10:47:29 +0000 (UTC)
Date:   Wed, 27 Jan 2021 11:47:27 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        imbrenda@linux.ibm.com, drjones@redhat.com, pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH v5 2/3] s390x: define UV compatible I/O
 allocation
Message-ID: <20210127114727.1be31923.cohuck@redhat.com>
In-Reply-To: <1611322060-1972-3-git-send-email-pmorel@linux.ibm.com>
References: <1611322060-1972-1-git-send-email-pmorel@linux.ibm.com>
        <1611322060-1972-3-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 22 Jan 2021 14:27:39 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

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
>  lib/s390x/malloc_io.c | 71 +++++++++++++++++++++++++++++++++++++++++++
>  lib/s390x/malloc_io.h | 45 +++++++++++++++++++++++++++
>  s390x/Makefile        |  1 +
>  3 files changed, 117 insertions(+)
>  create mode 100644 lib/s390x/malloc_io.c
>  create mode 100644 lib/s390x/malloc_io.h

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

