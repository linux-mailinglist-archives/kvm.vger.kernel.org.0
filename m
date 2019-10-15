Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C65CD77C8
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 15:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732230AbfJONz7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 09:55:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44436 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731638AbfJONz6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 09:55:58 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B252C757C2;
        Tue, 15 Oct 2019 13:55:58 +0000 (UTC)
Received: from gondolin (dhcp-192-233.str.redhat.com [10.33.192.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A4FB55D9E2;
        Tue, 15 Oct 2019 13:55:57 +0000 (UTC)
Date:   Tue, 15 Oct 2019 15:55:55 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH 4/4] vfio-ccw: Rename the io_fctl trace
Message-ID: <20191015155555.24275800.cohuck@redhat.com>
In-Reply-To: <20191014180855.19400-5-farman@linux.ibm.com>
References: <20191014180855.19400-1-farman@linux.ibm.com>
        <20191014180855.19400-5-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Tue, 15 Oct 2019 13:55:58 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 14 Oct 2019 20:08:55 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> Rename this trace to the function name, so we remember what is being
> traced instead of an abstract reference to the function control bit
> of the SCSW (since that exists in the IRB, but not the ORB).
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_fsm.c   | 4 ++--
>  drivers/s390/cio/vfio_ccw_trace.c | 2 +-
>  drivers/s390/cio/vfio_ccw_trace.h | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)

That makes sense (I don't supposed this is used in any tooling, as it
is more of a low-level debug trace.)
