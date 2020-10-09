Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1136F288666
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 11:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733299AbgJIJxg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 05:53:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21116 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733276AbgJIJxf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Oct 2020 05:53:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602237214;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hrSI6NSIpxXuYWKScjiFJm+DPNDOs+FTqniVLav/KZY=;
        b=gRBEOpXvdY3G+l2JgsK1rU+kmWJi0Uf2nl61QadX8jstgUJ5+SrGlq1Sy9Jk7gYMQfjmMi
        fc6MoacYFj49DHsKwgFqt+flGm/25LrPB+Yf43R8Dwr4V09vgxPSnvDaB3yFRkUNdDiy5l
        A4kqCawCzMNDyptEl1Cmwz8AE++gG14=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-3VnSz4nuOGqe6W8olt_zWg-1; Fri, 09 Oct 2020 05:53:33 -0400
X-MC-Unique: 3VnSz4nuOGqe6W8olt_zWg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 750E057050;
        Fri,  9 Oct 2020 09:53:31 +0000 (UTC)
Received: from gondolin (ovpn-113-40.ams2.redhat.com [10.36.113.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 72C6B10002A4;
        Fri,  9 Oct 2020 09:53:19 +0000 (UTC)
Date:   Fri, 9 Oct 2020 11:53:16 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     thuth@redhat.com, pmorel@linux.ibm.com, schnelle@linux.ibm.com,
        rth@twiddle.net, david@redhat.com, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, qemu-s390x@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 09/10] vfio: Add routine for finding
 VFIO_DEVICE_GET_INFO capabilities
Message-ID: <20201009115316.04b82a3d.cohuck@redhat.com>
In-Reply-To: <1602097455-15658-10-git-send-email-mjrosato@linux.ibm.com>
References: <1602097455-15658-1-git-send-email-mjrosato@linux.ibm.com>
        <1602097455-15658-10-git-send-email-mjrosato@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  7 Oct 2020 15:04:14 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> Now that VFIO_DEVICE_GET_INFO supports capability chains, add a helper
> function to find specific capabilities in the chain.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  hw/vfio/common.c              | 10 ++++++++++
>  include/hw/vfio/vfio-common.h |  2 ++
>  2 files changed, 12 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

