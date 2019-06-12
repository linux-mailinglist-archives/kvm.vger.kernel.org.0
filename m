Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 466DC428C6
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 16:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409353AbfFLOYA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 10:24:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42708 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407783AbfFLOYA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 10:24:00 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 820E13079B8F;
        Wed, 12 Jun 2019 14:23:59 +0000 (UTC)
Received: from gondolin (ovpn-116-169.ams2.redhat.com [10.36.116.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE1D777DC8;
        Wed, 12 Jun 2019 14:23:50 +0000 (UTC)
Date:   Wed, 12 Jun 2019 16:23:48 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Sebastian Ott <sebott@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        "Jason J. Herne" <jjherne@linux.ibm.com>
Subject: Re: [PATCH v5 2/8] s390/cio: introduce DMA pools to cio
Message-ID: <20190612162348.0c43b806.cohuck@redhat.com>
In-Reply-To: <20190612111236.99538-3-pasic@linux.ibm.com>
References: <20190612111236.99538-1-pasic@linux.ibm.com>
        <20190612111236.99538-3-pasic@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Wed, 12 Jun 2019 14:24:00 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 12 Jun 2019 13:12:30 +0200
Halil Pasic <pasic@linux.ibm.com> wrote:

> To support protected virtualization cio will need to make sure the
> memory used for communication with the hypervisor is DMA memory.
> 
> Let us introduce one global pool for cio.
> 
> Our DMA pools are implemented as a gen_pool backed with DMA pages. The
> idea is to avoid each allocation effectively wasting a page, as we
> typically allocate much less than PAGE_SIZE.
> 
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> Reviewed-by: Sebastian Ott <sebott@linux.ibm.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  arch/s390/Kconfig           |   1 +
>  arch/s390/include/asm/cio.h |  11 +++
>  drivers/s390/cio/css.c      | 133 ++++++++++++++++++++++++++++++++++--
>  3 files changed, 141 insertions(+), 4 deletions(-)

Changes look good to me.
