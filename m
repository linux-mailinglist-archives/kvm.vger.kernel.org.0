Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 360B84B3D2
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 10:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731135AbfFSIRN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jun 2019 04:17:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33740 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730783AbfFSIRM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jun 2019 04:17:12 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CE8613082263;
        Wed, 19 Jun 2019 08:17:12 +0000 (UTC)
Received: from gondolin (dhcp-192-192.str.redhat.com [10.33.192.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B8F4F5C220;
        Wed, 19 Jun 2019 08:17:11 +0000 (UTC)
Date:   Wed, 19 Jun 2019 10:17:09 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH v1 2/5] vfio-ccw: Skip second copy of guest cp to
 host
Message-ID: <20190619101709.2985e80e.cohuck@redhat.com>
In-Reply-To: <20190618202352.39702-3-farman@linux.ibm.com>
References: <20190618202352.39702-1-farman@linux.ibm.com>
        <20190618202352.39702-3-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Wed, 19 Jun 2019 08:17:12 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 Jun 2019 22:23:49 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> We already pinned/copied/unpinned 2K (256 CCWs) of guest memory
> to the host space anchored off vfio_ccw_private.  There's no need
> to do that again once we have the length calculated, when we could
> just copy the section we need to the "permanent" space for the I/O.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
