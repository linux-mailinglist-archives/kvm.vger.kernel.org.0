Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA0BD8D61
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 12:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404496AbfJPKKP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 06:10:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37768 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727235AbfJPKKP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 06:10:15 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 073893003194;
        Wed, 16 Oct 2019 10:10:15 +0000 (UTC)
Received: from gondolin (dhcp-192-233.str.redhat.com [10.33.192.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C26791001B35;
        Wed, 16 Oct 2019 10:10:13 +0000 (UTC)
Date:   Wed, 16 Oct 2019 12:10:11 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Steffen Maier <maier@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/4] vfio-ccw: Trace the FSM jumptable
Message-ID: <20191016121011.35bf651c.cohuck@redhat.com>
In-Reply-To: <20191016015822.72425-3-farman@linux.ibm.com>
References: <20191016015822.72425-1-farman@linux.ibm.com>
        <20191016015822.72425-3-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Wed, 16 Oct 2019 10:10:15 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 16 Oct 2019 03:58:20 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> It would be nice if we could track the sequence of events within
> vfio-ccw, based on the state of the device/FSM and our calling
> sequence within it.  So let's add a simple trace here so we can
> watch the states change as things go, and allow it to be folded
> into the rest of the other cio traces.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_private.h |  1 +
>  drivers/s390/cio/vfio_ccw_trace.c   |  1 +
>  drivers/s390/cio/vfio_ccw_trace.h   | 26 ++++++++++++++++++++++++++
>  3 files changed, 28 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
