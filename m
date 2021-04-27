Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B97D936CEC1
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 00:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236487AbhD0Wuy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 18:50:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59287 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235382AbhD0Wux (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Apr 2021 18:50:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619563807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cO8rq0W/UXy84srQ0IqQ4LM9BXhfScB/i6+15e8JVlQ=;
        b=AZsCSvHbVfhdblRv1aYTL/oXHv9stfJvprEipEUH5K923u/0igJ8H2fA/kaQANOBYSv8OH
        hFCZYy4DGoCQZdOUoAniIZWncASM6fGAIsqI6YXM/MHj4nPAbQf4unBNH1Ckm6B/Iuo1SE
        ihyA2c7K7sgVtcfBGBfCWb7LMvaA5XA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-CSLUtTQ9PMOJSlhk6jA_JQ-1; Tue, 27 Apr 2021 18:50:03 -0400
X-MC-Unique: CSLUtTQ9PMOJSlhk6jA_JQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 19B9A803620;
        Tue, 27 Apr 2021 22:49:59 +0000 (UTC)
Received: from redhat.com (ovpn-113-225.phx2.redhat.com [10.3.113.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1845D5D9F2;
        Tue, 27 Apr 2021 22:49:57 +0000 (UTC)
Date:   Tue, 27 Apr 2021 16:49:56 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org,
        Eric Farman <farman@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, linux-s390@vger.kernel.org,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 00/13] Remove vfio_mdev.c, mdev_parent_ops and more
Message-ID: <20210427164956.750aea67@redhat.com>
In-Reply-To: <20210427222026.GL1370958@nvidia.com>
References: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
        <20210427153042.103e12ab@redhat.com>
        <20210427222026.GL1370958@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 27 Apr 2021 19:20:26 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Apr 27, 2021 at 03:30:42PM -0600, Alex Williamson wrote:
>  
> > It'd be really helpful if you could consistently copy at least one
> > list, preferably one monitored by patchwork, for an entire series.  The
> > kvm list is missing patches 06 and 08.  I can find the latter hopping
> > over to the intel-gfx or dri-devel projects as I did for the last
> > series, but 06 only copied linux-s390, where I need to use lore and
> > can't find a patchwork.  Thanks,  
> 
> Oh wow, that is not intentional, sorry! Thanks for pointing it out
> 
> I didn't notice this was happening, basically a side effect of having
> so many different people and lists to get on this series - kvm should
> have been CC on them all, I fixed it up going forward.
> 
> FWIW you may be interested in b4 if you haven't seen it before, it is
> a good alternative if there isn't an offical patchworks.

I'm sold!  Thanks,

Alex

