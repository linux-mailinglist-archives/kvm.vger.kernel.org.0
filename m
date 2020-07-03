Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21B192137F4
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 11:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbgGCJpi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 05:45:38 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:49418 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725972AbgGCJpi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Jul 2020 05:45:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593769537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ySpXOJWsWymBGThH1fYgMecFR3cP9I6l2Ce0Wcjp214=;
        b=g1xPfCI2g+JU5lrIN2ZKgq2xZRiFUs2/T1KPE+Xf8odtGDyhqQ4M7hqvPEvjpWCDEquTt+
        ZvMRFhZ+gddq2QtPKMGEMX3wO55i2KZEWpEsw095x35A24WwiuqMvvDxBFtcNj3S3ru0lk
        hbuNIG55KqLYqvf1JLIAxE9QzxAGsGo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-dhvov17KNQy3BmkVxlLjjA-1; Fri, 03 Jul 2020 05:45:33 -0400
X-MC-Unique: dhvov17KNQy3BmkVxlLjjA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC8AC8015F5;
        Fri,  3 Jul 2020 09:45:31 +0000 (UTC)
Received: from gondolin (ovpn-113-54.ams2.redhat.com [10.36.113.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F3485BAD5;
        Fri,  3 Jul 2020 09:45:29 +0000 (UTC)
Date:   Fri, 3 Jul 2020 11:45:27 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio-ccw: Fix a build error due to missing include of
 linux/slab.h
Message-ID: <20200703114527.790ffb82.cohuck@redhat.com>
In-Reply-To: <20200703022628.6036-1-sean.j.christopherson@intel.com>
References: <20200703022628.6036-1-sean.j.christopherson@intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  2 Jul 2020 19:26:28 -0700
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> Include linux/slab.h to fix a build error due to kfree() being undefined.
> 
> Fixes: 3f02cb2fd9d2d ("vfio-ccw: Wire up the CRW irq and CRW region")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
> 
> Encountered this when cross-compiling with a pretty minimal config, didn't
> bother digging into why the error only showed up in my environment.
> 
>  drivers/s390/cio/vfio_ccw_chp.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_chp.c b/drivers/s390/cio/vfio_ccw_chp.c
> index a646fc81c872..13b26a1c7988 100644
> --- a/drivers/s390/cio/vfio_ccw_chp.c
> +++ b/drivers/s390/cio/vfio_ccw_chp.c
> @@ -8,6 +8,7 @@
>   *            Eric Farman <farman@linux.ibm.com>
>   */
>  
> +#include <linux/slab.h>
>  #include <linux/vfio.h>
>  #include "vfio_ccw_private.h"
>  

Thanks, applied.

