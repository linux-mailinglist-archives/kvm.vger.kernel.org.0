Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2255EDA86D
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2019 11:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732432AbfJQJfd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Oct 2019 05:35:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44366 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728150AbfJQJfc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Oct 2019 05:35:32 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9D8083084244;
        Thu, 17 Oct 2019 09:35:32 +0000 (UTC)
Received: from gondolin (dhcp-192-202.str.redhat.com [10.33.192.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4BEA5600C4;
        Thu, 17 Oct 2019 09:35:31 +0000 (UTC)
Date:   Thu, 17 Oct 2019 11:35:29 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 3/4] vfio-ccw: Add a trace for asynchronous requests
Message-ID: <20191017113529.338bad06.cohuck@redhat.com>
In-Reply-To: <20191016142040.14132-4-farman@linux.ibm.com>
References: <20191016142040.14132-1-farman@linux.ibm.com>
        <20191016142040.14132-4-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Thu, 17 Oct 2019 09:35:32 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 16 Oct 2019 16:20:39 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> Since the asynchronous requests are typically associated with
> error recovery, let's add a simple trace when one of those is
> issued to a device.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_fsm.c   |  4 ++++
>  drivers/s390/cio/vfio_ccw_trace.c |  1 +
>  drivers/s390/cio/vfio_ccw_trace.h | 30 ++++++++++++++++++++++++++++++
>  3 files changed, 35 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
