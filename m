Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 952BE39876D
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 12:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhFBK7W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 06:59:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25665 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231974AbhFBK53 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Jun 2021 06:57:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622631346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LgQpnkzCUd/RZdtsMSWi5kjItcvrLoev8WQpuAUVPnY=;
        b=EHo8P3ql5h+Bq5xaxmxqA1/a/IWdh6A90R55uB1p//iFvi1XQE2A0bOE8zgOPc0imwlCVH
        KtGbqnNDZP4n0xI0KSPgrrVaSQVxyQQnVrITIlk+Zz3t+AIR5W4/AJlorBY0H1kFd8GSBf
        YzgSti+z+g6O+e/KXOn3bCtv5o4914s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-o05xmR8tP9G16A0ikIl17Q-1; Wed, 02 Jun 2021 06:55:43 -0400
X-MC-Unique: o05xmR8tP9G16A0ikIl17Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2499A18A2B45;
        Wed,  2 Jun 2021 10:55:12 +0000 (UTC)
Received: from localhost (ovpn-113-172.ams2.redhat.com [10.36.113.172])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BBF8A5D751;
        Wed,  2 Jun 2021 10:55:11 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH] s390x: sie: Only overwrite r3 if it
 isn't needed anymore
In-Reply-To: <20210602094352.11647-1-frankja@linux.ibm.com>
Organization: Red Hat GmbH
References: <20210602094352.11647-1-frankja@linux.ibm.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Wed, 02 Jun 2021 12:55:10 +0200
Message-ID: <87mts8pmcx.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 02 2021, Janosch Frank <frankja@linux.ibm.com> wrote:

> The lmg overwrites r3 which we later use to reference the fprs and fpc.
> Let's do the lmg at the end where overwriting is fine.
>
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>
> Finding this took me longer than I'd like to admit. :)
>
> ---
>  s390x/cpu.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

