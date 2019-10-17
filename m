Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DAD3DA9C7
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2019 12:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501954AbfJQKTa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Oct 2019 06:19:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40926 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731515AbfJQKT2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Oct 2019 06:19:28 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DBBBA3078469;
        Thu, 17 Oct 2019 10:19:27 +0000 (UTC)
Received: from gondolin (dhcp-192-202.str.redhat.com [10.33.192.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AAA325C1B5;
        Thu, 17 Oct 2019 10:19:26 +0000 (UTC)
Date:   Thu, 17 Oct 2019 12:19:24 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 0/4] vfio-ccw: A couple trace changes
Message-ID: <20191017121924.3597aa7f.cohuck@redhat.com>
In-Reply-To: <20191016142040.14132-1-farman@linux.ibm.com>
References: <20191016142040.14132-1-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 17 Oct 2019 10:19:28 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 16 Oct 2019 16:20:36 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> Here a couple updates to the vfio-ccw traces in the kernel,
> based on things I've been using locally.  Perhaps they'll
> be useful for future debugging.
> 
> v2 -> v3:
>  - Added Conny's r-b to patches 1, 2, 4
>  - s/command=%d/command=0x%x/ in patch 3 [Cornelia Huck]
> 
> v1/RFC -> v2:
>  - Convert state/event=%x to %d [Steffen Maier]
>  - Use individual fields for cssid/ssid/sch_no, to enable
>    filtering by device [Steffen Maier]
>  - Add 0x prefix to remaining %x substitution in existing trace
> 
> Eric Farman (4):
>   vfio-ccw: Refactor how the traces are built
>   vfio-ccw: Trace the FSM jumptable
>   vfio-ccw: Add a trace for asynchronous requests
>   vfio-ccw: Rework the io_fctl trace
> 
>  drivers/s390/cio/Makefile           |  4 +-
>  drivers/s390/cio/vfio_ccw_cp.h      |  1 +
>  drivers/s390/cio/vfio_ccw_fsm.c     | 11 +++--
>  drivers/s390/cio/vfio_ccw_private.h |  1 +
>  drivers/s390/cio/vfio_ccw_trace.c   | 14 ++++++
>  drivers/s390/cio/vfio_ccw_trace.h   | 76 ++++++++++++++++++++++++++---
>  6 files changed, 93 insertions(+), 14 deletions(-)
>  create mode 100644 drivers/s390/cio/vfio_ccw_trace.c
> 

Thanks, applied.
