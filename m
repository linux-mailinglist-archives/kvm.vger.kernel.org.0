Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C21CA44021
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 18:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733311AbfFMQDJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 12:03:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35682 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731392AbfFMQDI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 12:03:08 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B446B882F2;
        Thu, 13 Jun 2019 16:03:08 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C79E31001B22;
        Thu, 13 Jun 2019 16:03:07 +0000 (UTC)
Date:   Thu, 13 Jun 2019 18:03:05 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 7/9] vfio-ccw: Remove pfn_array_table
Message-ID: <20190613180305.3aeeae1d.cohuck@redhat.com>
In-Reply-To: <20190606202831.44135-8-farman@linux.ibm.com>
References: <20190606202831.44135-1-farman@linux.ibm.com>
        <20190606202831.44135-8-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Thu, 13 Jun 2019 16:03:08 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  6 Jun 2019 22:28:29 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> Now that both CCW codepaths build this nested array:
> 
>   ccwchain->pfn_array_table[1]->pfn_array[#idaws/#pages]
> 
> We can collapse this into simply:
> 
>   ccwchain->pfn_array[#idaws/#pages]
> 
> Let's do that, so that we don't have to continually navigate two
> nested arrays when the first array always has a count of one.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 118 +++++++++------------------------
>  1 file changed, 33 insertions(+), 85 deletions(-)

That's how I like my diffstats :) Nice cleanup!

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
