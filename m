Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BED94B3BC
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 10:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731186AbfFSIO1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 04:14:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51576 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726142AbfFSIO1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jun 2019 04:14:27 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F3715550CF;
        Wed, 19 Jun 2019 08:14:26 +0000 (UTC)
Received: from gondolin (dhcp-192-192.str.redhat.com [10.33.192.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 13374600C7;
        Wed, 19 Jun 2019 08:14:25 +0000 (UTC)
Date:   Wed, 19 Jun 2019 10:14:23 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH v1 1/5] vfio-ccw: Move guest_cp storage into common
 struct
Message-ID: <20190619101423.5ed567e5.cohuck@redhat.com>
In-Reply-To: <20190618202352.39702-2-farman@linux.ibm.com>
References: <20190618202352.39702-1-farman@linux.ibm.com>
        <20190618202352.39702-2-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Wed, 19 Jun 2019 08:14:27 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 Jun 2019 22:23:48 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> Rather than allocating/freeing a piece of memory every time
> we try to figure out how long a CCW chain is, let's use a piece
> of memory allocated for each device.
> 
> The io_mutex added with commit 4f76617378ee9 ("vfio-ccw: protect
> the I/O region") is held for the duration of the VFIO_CCW_EVENT_IO_REQ
> event that accesses/uses this space, so there should be no race
> concerns with another CPU attempting an (unexpected) SSCH for the
> same device.
> 
> Suggested-by: Cornelia Huck <cohuck@redhat.com>
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
> Conny, your suggestion [1] did not go unnoticed.  :)

:)

> 
> [1] https://patchwork.kernel.org/comment/22312659/
> ---
>  drivers/s390/cio/vfio_ccw_cp.c  | 23 ++++-------------------
>  drivers/s390/cio/vfio_ccw_cp.h  |  7 +++++++
>  drivers/s390/cio/vfio_ccw_drv.c |  7 +++++++
>  3 files changed, 18 insertions(+), 19 deletions(-)

Nice!

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
