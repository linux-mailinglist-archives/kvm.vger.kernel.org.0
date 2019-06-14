Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66143458FE
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 11:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbfFNJmG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 05:42:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51978 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726900AbfFNJmG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 05:42:06 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CD929307D850;
        Fri, 14 Jun 2019 09:42:05 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BB15D9833;
        Fri, 14 Jun 2019 09:42:04 +0000 (UTC)
Date:   Fri, 14 Jun 2019 11:42:02 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 8/9] vfio-ccw: Rearrange IDAL allocation in direct
 CCW
Message-ID: <20190614114202.1ddb6264.cohuck@redhat.com>
In-Reply-To: <20190606202831.44135-9-farman@linux.ibm.com>
References: <20190606202831.44135-1-farman@linux.ibm.com>
        <20190606202831.44135-9-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Fri, 14 Jun 2019 09:42:05 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  6 Jun 2019 22:28:30 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> This is purely deck furniture, to help understand the merge of the
> direct and indirect handlers.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 25 +++++++++++++++----------
>  1 file changed, 15 insertions(+), 10 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
