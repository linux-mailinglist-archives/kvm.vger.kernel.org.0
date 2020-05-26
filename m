Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 590AE1E29B8
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 20:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389023AbgEZSJD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 14:09:03 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:60688 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388968AbgEZSJC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 14:09:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590516541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=eF8Fiiqz5mjsBEnN7IDl2UFyCPFX0GAmkHB+9UJSPi4=;
        b=MxF69FH3yHt0zTM9/1dQ1Xi5oM54PTWXBZXKZjGcfIUmrD6IAT+Dhwv8UxuixD9q7zWbvi
        OkGnmuPfNGLmg2NNp10SRL0SDTElXVJwIfFmz/Q5XAS33N3qJyjwvpS/YB+jRDod1g/V9m
        kEb4AXo+e4qNEey45XTA/eZpo7o5Q8E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-_fEPTeDEOSiuiZ9DYojw-A-1; Tue, 26 May 2020 14:09:00 -0400
X-MC-Unique: _fEPTeDEOSiuiZ9DYojw-A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 293E1107ACF2;
        Tue, 26 May 2020 18:08:59 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-8.ams2.redhat.com [10.36.112.8])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C1F679C51;
        Tue, 26 May 2020 18:08:54 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v7 04/12] s390x: interrupt registration
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1589818051-20549-1-git-send-email-pmorel@linux.ibm.com>
 <1589818051-20549-5-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <dcfa518e-ce93-fb71-3e70-b95c12b0b32e@redhat.com>
Date:   Tue, 26 May 2020 20:08:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1589818051-20549-5-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/05/2020 18.07, Pierre Morel wrote:
> Let's make it possible to add and remove a custom io interrupt handler,
> that can be used instead of the normal one.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/interrupt.c | 23 ++++++++++++++++++++++-
>  lib/s390x/interrupt.h |  8 ++++++++
>  2 files changed, 30 insertions(+), 1 deletion(-)
>  create mode 100644 lib/s390x/interrupt.h
...
> diff --git a/lib/s390x/interrupt.h b/lib/s390x/interrupt.h
> new file mode 100644
> index 0000000..323258d
> --- /dev/null
> +++ b/lib/s390x/interrupt.h
> @@ -0,0 +1,8 @@
> +#ifndef __INTERRUPT_H
> +#define __INTERRUPT_H

Looking at this patch again, I noticed another nit: No double
underscores at the beginning of header guards, please! That's reserved
namespace. Simply use INTERRUPT_H or S390X_INTERRUPT_H or something
similar instead.

 Thanks,
  Thomas

