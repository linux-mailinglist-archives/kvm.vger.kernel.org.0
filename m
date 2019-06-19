Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 683834B3DA
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 10:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731263AbfFSISW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 04:18:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42366 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730783AbfFSISW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jun 2019 04:18:22 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6866D7FDF5;
        Wed, 19 Jun 2019 08:18:22 +0000 (UTC)
Received: from gondolin (dhcp-192-192.str.redhat.com [10.33.192.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5625A5D9D6;
        Wed, 19 Jun 2019 08:18:21 +0000 (UTC)
Date:   Wed, 19 Jun 2019 10:18:18 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH v1 3/5] vfio-ccw: Copy CCW data outside length
 calculation
Message-ID: <20190619101818.77521a63.cohuck@redhat.com>
In-Reply-To: <20190618202352.39702-4-farman@linux.ibm.com>
References: <20190618202352.39702-1-farman@linux.ibm.com>
        <20190618202352.39702-4-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Wed, 19 Jun 2019 08:18:22 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 Jun 2019 22:23:50 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> It doesn't make much sense to "hide" the copy to the channel_program
> struct inside a routine that calculates the length of the chain.
> 
> Let's move it to the calling routine, which will later copy from
> channel_program to the memory it allocated itself.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 19 +++++++------------
>  1 file changed, 7 insertions(+), 12 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
