Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69D5666B95
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 13:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbfGLL00 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 07:26:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49404 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbfGLL0Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 07:26:25 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CF4583082E46;
        Fri, 12 Jul 2019 11:26:25 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C0C635D739;
        Fri, 12 Jul 2019 11:26:24 +0000 (UTC)
Date:   Fri, 12 Jul 2019 13:26:22 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Farhan Ali <alifm@linux.ibm.com>
Cc:     farman@linux.ibm.com, pasic@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 2/5] vfio-ccw: Fix memory leak and don't call cp_free
 in cp_init
Message-ID: <20190712132622.750cf61f.cohuck@redhat.com>
In-Reply-To: <3173c4216f4555d9765eb6e4922534982bc820e4.1562854091.git.alifm@linux.ibm.com>
References: <cover.1562854091.git.alifm@linux.ibm.com>
        <3173c4216f4555d9765eb6e4922534982bc820e4.1562854091.git.alifm@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Fri, 12 Jul 2019 11:26:25 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 11 Jul 2019 10:28:52 -0400
Farhan Ali <alifm@linux.ibm.com> wrote:

> We don't set cp->initialized to true so calling cp_free
> will just return and not do anything.
> 
> Also fix a memory leak where we fail to free a ccwchain
> on an error.
> 
> Fixes: 812271b910 ("s390/cio: Squash cp_free() and cp_unpin_free()")
> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
