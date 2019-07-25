Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26AF374841
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2019 09:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388159AbfGYHdk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jul 2019 03:33:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42198 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387738AbfGYHdj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jul 2019 03:33:39 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AC8AC308339B;
        Thu, 25 Jul 2019 07:33:39 +0000 (UTC)
Received: from gondolin (dhcp-192-232.str.redhat.com [10.33.192.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5851060497;
        Thu, 25 Jul 2019 07:33:38 +0000 (UTC)
Date:   Thu, 25 Jul 2019 09:33:35 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Farhan Ali <alifm@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     farman@linux.ibm.com, pasic@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 1/1] MAINTAINERS: vfio-ccw: Remove myself as the
 maintainer
Message-ID: <20190725093335.09c96c0d.cohuck@redhat.com>
In-Reply-To: <19aee1ab0e5bcc01053b515117a66426a9332086.1564003585.git.alifm@linux.ibm.com>
References: <cover.1564003585.git.alifm@linux.ibm.com>
        <19aee1ab0e5bcc01053b515117a66426a9332086.1564003585.git.alifm@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Thu, 25 Jul 2019 07:33:39 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 24 Jul 2019 17:32:03 -0400
Farhan Ali <alifm@linux.ibm.com> wrote:

> I will not be able to continue with my maintainership responsibilities
> going forward, so remove myself as the maintainer.

::sadface::

Thank you for all of your good work!

> 
> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> ---
>  MAINTAINERS | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0e90487..dd07a23 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13696,7 +13696,6 @@ F:	drivers/pci/hotplug/s390_pci_hpc.c
>  
>  S390 VFIO-CCW DRIVER
>  M:	Cornelia Huck <cohuck@redhat.com>
> -M:	Farhan Ali <alifm@linux.ibm.com>
>  M:	Eric Farman <farman@linux.ibm.com>
>  R:	Halil Pasic <pasic@linux.ibm.com>
>  L:	linux-s390@vger.kernel.org

Acked-by: Cornelia Huck <cohuck@redhat.com>

Heiko/Vasily/Christian: can you take this one directly through the s390
tree?
