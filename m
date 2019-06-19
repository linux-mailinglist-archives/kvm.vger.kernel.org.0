Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A16AA4B3FA
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 10:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731292AbfFSIWd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 04:22:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40934 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726142AbfFSIWd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jun 2019 04:22:33 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5F1F0C057E3C;
        Wed, 19 Jun 2019 08:22:33 +0000 (UTC)
Received: from gondolin (dhcp-192-192.str.redhat.com [10.33.192.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 724A45C220;
        Wed, 19 Jun 2019 08:22:32 +0000 (UTC)
Date:   Wed, 19 Jun 2019 10:22:30 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH v1 4/5] vfio-ccw: Factor out the ccw0-to-ccw1
 transition
Message-ID: <20190619102230.76e5638a.cohuck@redhat.com>
In-Reply-To: <20190618202352.39702-5-farman@linux.ibm.com>
References: <20190618202352.39702-1-farman@linux.ibm.com>
        <20190618202352.39702-5-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Wed, 19 Jun 2019 08:22:33 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 Jun 2019 22:23:51 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> This is a really useful function, but it's buried in the
> copy_ccw_from_iova() routine so that ccwchain_calc_length()
> can just work with Format-1 CCWs while doing its counting.
> But it means we're translating a full 2K of "CCWs" to Format-1,
> when in reality there's probably far fewer in that space.
> 
> Let's factor it out, so maybe we can do something with it later.

Agreed, this looks sensible.

> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 48 ++++++++++++++++++----------------
>  1 file changed, 25 insertions(+), 23 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
