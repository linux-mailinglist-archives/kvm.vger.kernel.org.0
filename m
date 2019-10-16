Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5451D8D50
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 12:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392221AbfJPKIq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 06:08:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49024 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727451AbfJPKIq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 06:08:46 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E5DC2801682;
        Wed, 16 Oct 2019 10:08:45 +0000 (UTC)
Received: from gondolin (dhcp-192-233.str.redhat.com [10.33.192.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B64475C1D6;
        Wed, 16 Oct 2019 10:08:44 +0000 (UTC)
Date:   Wed, 16 Oct 2019 12:08:43 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Steffen Maier <maier@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 1/4] vfio-ccw: Refactor how the traces are built
Message-ID: <20191016120843.21a868ed.cohuck@redhat.com>
In-Reply-To: <20191016015822.72425-2-farman@linux.ibm.com>
References: <20191016015822.72425-1-farman@linux.ibm.com>
        <20191016015822.72425-2-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.67]); Wed, 16 Oct 2019 10:08:46 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 16 Oct 2019 03:58:19 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> Commit 3cd90214b70f ("vfio: ccw: add tracepoints for interesting error
> paths") added a quick trace point to determine where a channel program
> failed while being processed.  It's a great addition, but adding more
> traces to vfio-ccw is more cumbersome than it needs to be.
> 
> Let's refactor how this is done, so that additional traces are easier
> to add and can exist outside of the FSM if we ever desire.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/Makefile         |  4 ++--
>  drivers/s390/cio/vfio_ccw_cp.h    |  1 +
>  drivers/s390/cio/vfio_ccw_fsm.c   |  3 ---
>  drivers/s390/cio/vfio_ccw_trace.c | 12 ++++++++++++
>  drivers/s390/cio/vfio_ccw_trace.h |  2 ++
>  5 files changed, 17 insertions(+), 5 deletions(-)
>  create mode 100644 drivers/s390/cio/vfio_ccw_trace.c

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
