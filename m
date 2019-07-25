Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBA4E74850
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2019 09:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388203AbfGYHk5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jul 2019 03:40:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47682 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387989AbfGYHk4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jul 2019 03:40:56 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B8D43A836;
        Thu, 25 Jul 2019 07:40:56 +0000 (UTC)
Received: from gondolin (dhcp-192-232.str.redhat.com [10.33.192.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 458A95D9DE;
        Thu, 25 Jul 2019 07:40:55 +0000 (UTC)
Date:   Thu, 25 Jul 2019 09:40:53 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Farhan Ali <alifm@linux.ibm.com>
Cc:     farman@linux.ibm.com, pasic@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-s390x@nongnu.org
Subject: Re: [PATCH 1/1] MAINTAINERS: vfio-ccw: Remove myself as the
 maintainer
Message-ID: <20190725094053.2367e272.cohuck@redhat.com>
In-Reply-To: <355a4ac2923ff3dcf2171cb23d477440bd010b34.1564003698.git.alifm@linux.ibm.com>
References: <cover.1564003698.git.alifm@linux.ibm.com>
        <355a4ac2923ff3dcf2171cb23d477440bd010b34.1564003698.git.alifm@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Thu, 25 Jul 2019 07:40:56 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[added the missing qemu mailing lists]

On Wed, 24 Jul 2019 17:35:46 -0400
Farhan Ali <alifm@linux.ibm.com> wrote:

> I will not be able to continue with my maintainership responsibilities
> going forward, so remove myself as the maintainer.

Thank you again for your work!

> 
> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> ---
>  MAINTAINERS | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index acbad13..fe2797a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1452,7 +1452,6 @@ F: include/hw/vfio/
>  vfio-ccw
>  M: Cornelia Huck <cohuck@redhat.com>
>  M: Eric Farman <farman@linux.ibm.com>
> -M: Farhan Ali <alifm@linux.ibm.com>
>  S: Supported
>  F: hw/vfio/ccw.c
>  F: hw/s390x/s390-ccw.c

Queued to s390-fixes.
