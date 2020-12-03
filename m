Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 283602CE30D
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 00:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388033AbgLCXtk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 18:49:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20958 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387628AbgLCXtj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Dec 2020 18:49:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607039293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uSc1P8Lzj1qiZhaXI+iJNSX6yCGXukKbn3bkdNB15PE=;
        b=KXrf6fFsAijPA/QaKl7UpVIFzwTDOyQ9ISK59+IyWawhmKuYZ3hAKh+pJTVGS3zsjoXR86
        FAAX1M+eI3luVG9K3GSRmedHALvcCWjI0LA30Bgv5IodXAFPGmWOTGRaELTnJMNztGIxqY
        j1FNubZLtM9Udr/XlHYfh7YHwrXn09M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-Ql5IWQNJOFeI07Mx_7VrtQ-1; Thu, 03 Dec 2020 18:48:11 -0500
X-MC-Unique: Ql5IWQNJOFeI07Mx_7VrtQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 653C6800D62;
        Thu,  3 Dec 2020 23:48:08 +0000 (UTC)
Received: from w520.home (ovpn-112-10.phx2.redhat.com [10.3.112.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E262B1A8A9;
        Thu,  3 Dec 2020 23:48:07 +0000 (UTC)
Date:   Thu, 3 Dec 2020 16:48:07 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 0/2] Connect request callback to mdev and vfio-ccw
Message-ID: <20201203164807.5a87776f@w520.home>
In-Reply-To: <20201203213512.49357-1-farman@linux.ibm.com>
References: <20201203213512.49357-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  3 Dec 2020 22:35:10 +0100
Eric Farman <farman@linux.ibm.com> wrote:

> Alex,
> 
> As promised, here is a v3 with a message indicating a request is blocked
> until a user releases the device in question and a corresponding tweak to
> the commit message describing this change (and Conny's r-b). The remainder
> of the patches are otherwise identical.
> 
> v2      : https://lore.kernel.org/kvm/20201120180740.87837-1-farman@linux.ibm.com/
> v1(RFC) : https://lore.kernel.org/kvm/20201117032139.50988-1-farman@linux.ibm.com/
> 
> Eric Farman (2):
>   vfio-mdev: Wire in a request handler for mdev parent
>   vfio-ccw: Wire in the request callback
> 
>  drivers/s390/cio/vfio_ccw_ops.c     | 26 ++++++++++++++++++++++++++
>  drivers/s390/cio/vfio_ccw_private.h |  4 ++++
>  drivers/vfio/mdev/mdev_core.c       |  4 ++++
>  drivers/vfio/mdev/vfio_mdev.c       | 13 +++++++++++++
>  include/linux/mdev.h                |  4 ++++
>  include/uapi/linux/vfio.h           |  1 +
>  6 files changed, 52 insertions(+)
> 

Thanks!  Applied to vfio next branch for v5.11.

Alex

