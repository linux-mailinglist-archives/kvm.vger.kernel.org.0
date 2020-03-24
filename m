Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDF8190D50
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 13:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbgCXMYv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 08:24:51 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:24703 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727283AbgCXMYu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 08:24:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585052690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cu9euEyYx+ciZ8ZNIcsZwrXvO3cfy0g5OYFNxQJa10w=;
        b=VQYrO1SRB02zblbEnGOS/GGemcJzUw1r1vtZmGlY4LWRKx8f1URd0WKH+pWC0anQQO7yMP
        YKCYi+q3BL1PilculWcry4+k5w1Pe8F/Ff/x1sAjbXIMJyXn7WQeNiO/CeYv9lAqUhbtHu
        r9OuS7N/xeOQeKIushc2mo19oG3kxqg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-33-QyfhmQdbNqylyH9nQ10wCQ-1; Tue, 24 Mar 2020 08:24:47 -0400
X-MC-Unique: QyfhmQdbNqylyH9nQ10wCQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BBA2DDB20;
        Tue, 24 Mar 2020 12:24:46 +0000 (UTC)
Received: from gondolin (ovpn-113-109.ams2.redhat.com [10.36.113.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D7F9A19C6A;
        Tue, 24 Mar 2020 12:24:42 +0000 (UTC)
Date:   Tue, 24 Mar 2020 13:24:40 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, linux-s390@vger.kernel.org,
        david@redhat.com
Subject: Re: [kvm-unit-tests PATCH 10/10] s390x: Fix library constant
 definitions
Message-ID: <20200324132440.0cc4173c.cohuck@redhat.com>
In-Reply-To: <20200324081251.28810-11-frankja@linux.ibm.com>
References: <20200324081251.28810-1-frankja@linux.ibm.com>
        <20200324081251.28810-11-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 24 Mar 2020 04:12:51 -0400
Janosch Frank <frankja@linux.ibm.com> wrote:

> Seems like I uppercased the whole region instead of only the ULs when
> I added those definitions. Lets make the x lowercase again.

s/Lets/Let's/ :)

> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/asm/arch_def.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

