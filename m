Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2E889AE61
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 13:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393107AbfHWLss (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 07:48:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55776 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392870AbfHWLss (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 07:48:48 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6954C3090FC1;
        Fri, 23 Aug 2019 11:48:48 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C49E2636B;
        Fri, 23 Aug 2019 11:48:47 +0000 (UTC)
Date:   Fri, 23 Aug 2019 13:48:45 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFC 1/1] vfio-ccw: add some logging
Message-ID: <20190823134845.1f7ce449.cohuck@redhat.com>
In-Reply-To: <20190816151505.9853-2-cohuck@redhat.com>
References: <20190816151505.9853-1-cohuck@redhat.com>
        <20190816151505.9853-2-cohuck@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Fri, 23 Aug 2019 11:48:48 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 16 Aug 2019 17:15:05 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> Usually, the common I/O layer logs various things into the s390
> cio debug feature, which has been very helpful in the past when
> looking at crash dumps. As vfio-ccw devices unbind from the
> standard I/O subchannel driver, we lose some information there.
> 
> Let's introduce some vfio-ccw debug features and log some things
> there. (Unfortunately we cannot reuse the cio debug feature from
> a module.)
> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  drivers/s390/cio/vfio_ccw_drv.c     | 50 ++++++++++++++++++++++++++--
>  drivers/s390/cio/vfio_ccw_fsm.c     | 51 ++++++++++++++++++++++++++++-
>  drivers/s390/cio/vfio_ccw_ops.c     | 10 ++++++
>  drivers/s390/cio/vfio_ccw_private.h | 17 ++++++++++
>  4 files changed, 124 insertions(+), 4 deletions(-)

Queued.
