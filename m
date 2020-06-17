Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6C91FC8FA
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 10:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726331AbgFQIh7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 04:37:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59236 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725964AbgFQIh7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jun 2020 04:37:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592383078;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hZhPmMiT5CLHIK8TZNZNWEBkUMK/F5/skLTBjlU8QKg=;
        b=S+ezTSdPagSdOvZslLTzIaXQ9Ps2OiI0hRuzuRPe6s9tT96x59Zjhna9/0KfE0OdxVPEkm
        sBgNfhxidau5wXVIhg+l1xcO3fllTsUBNb1vHumEwe1BrZxSiLcKkjeOqWYBYsNVDeB1LD
        o3Awipttm03LjPKDWWM5LutXx9m7N10=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-g6aTmZauOda8ke6AcCIbyw-1; Wed, 17 Jun 2020 04:37:56 -0400
X-MC-Unique: g6aTmZauOda8ke6AcCIbyw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C4BAB134D6;
        Wed, 17 Jun 2020 08:37:54 +0000 (UTC)
Received: from gondolin (ovpn-112-222.ams2.redhat.com [10.36.112.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 90BE819D7D;
        Wed, 17 Jun 2020 08:37:50 +0000 (UTC)
Date:   Wed, 17 Jun 2020 10:37:48 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v9 08/12] s390x: retrieve decimal and
 hexadecimal kernel parameters
Message-ID: <20200617103748.4840b43b.cohuck@redhat.com>
In-Reply-To: <1592213521-19390-9-git-send-email-pmorel@linux.ibm.com>
References: <1592213521-19390-1-git-send-email-pmorel@linux.ibm.com>
        <1592213521-19390-9-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 15 Jun 2020 11:31:57 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> We often need to retrieve hexadecimal kernel parameters.
> Let's implement a shared utility to do it.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/kernel-args.c | 60 +++++++++++++++++++++++++++++++++++++++++
>  lib/s390x/kernel-args.h | 18 +++++++++++++
>  s390x/Makefile          |  1 +
>  3 files changed, 79 insertions(+)
>  create mode 100644 lib/s390x/kernel-args.c
>  create mode 100644 lib/s390x/kernel-args.h
> 

(...)

> diff --git a/lib/s390x/kernel-args.h b/lib/s390x/kernel-args.h
> new file mode 100644
> index 0000000..a88e34e
> --- /dev/null
> +++ b/lib/s390x/kernel-args.h
> @@ -0,0 +1,18 @@
> +/*
> + * Kernel argument
> + *
> + * Copyright (c) 2020 IBM Corp
> + *
> + * Authors:
> + *  Pierre Morel <pmorel@linux.ibm.com>
> + *
> + * This code is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2.
> + */
> +
> +#ifndef KERNEL_ARGS_H
> +#define KERNEL_ARGS_H
> +
> +int kernel_arg(int argc, char *argv[], const char *str, unsigned long *val);

<bikeshed>get_kernel_arg()?</bikeshed>

> +
> +#endif

Acked-by: Cornelia Huck <cohuck@redhat.com>

