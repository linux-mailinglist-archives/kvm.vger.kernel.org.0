Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4D528865E
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 11:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733271AbgJIJun (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 05:50:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42298 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725917AbgJIJum (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Oct 2020 05:50:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602237041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1gs3lWzl1KSrViM+P/tfK4cPR7lXHb836vmE15Zs9uk=;
        b=feL3NE+NQn7PXif9jfWfCLAzLT9bNTsnkPoO9evX3vjroBbDPHJDAwkCpDQ1GLu7xeSJwG
        OZJPNnKGOp06KnaRQMRssQ67De4tGurOKCUgW8LApDW9KsZ1+dzUzI8wyVbx/iVGZIyUUg
        ZhYHd2ZQ1+TanzaLAvSX52IVojFgENE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-6JDRg1R2OWC8-cQyAi8uSw-1; Fri, 09 Oct 2020 05:50:39 -0400
X-MC-Unique: 6JDRg1R2OWC8-cQyAi8uSw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5988018A8230;
        Fri,  9 Oct 2020 09:50:38 +0000 (UTC)
Received: from gondolin (ovpn-113-40.ams2.redhat.com [10.36.113.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 53EE019936;
        Fri,  9 Oct 2020 09:50:27 +0000 (UTC)
Date:   Fri, 9 Oct 2020 11:50:24 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     thuth@redhat.com, pmorel@linux.ibm.com, schnelle@linux.ibm.com,
        rth@twiddle.net, david@redhat.com, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, qemu-s390x@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 01/10] s390x/pci: Move header files to
 include/hw/s390x
Message-ID: <20201009115024.064d2ba0.cohuck@redhat.com>
In-Reply-To: <1602097455-15658-2-git-send-email-mjrosato@linux.ibm.com>
References: <1602097455-15658-1-git-send-email-mjrosato@linux.ibm.com>
        <1602097455-15658-2-git-send-email-mjrosato@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  7 Oct 2020 15:04:06 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> Seems a more appropriate location for them.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  MAINTAINERS                              | 1 +
>  hw/s390x/s390-pci-bus.c                  | 4 ++--
>  hw/s390x/s390-pci-inst.c                 | 4 ++--
>  hw/s390x/s390-virtio-ccw.c               | 2 +-
>  {hw => include/hw}/s390x/s390-pci-bus.h  | 0
>  {hw => include/hw}/s390x/s390-pci-inst.h | 0
>  6 files changed, 6 insertions(+), 5 deletions(-)
>  rename {hw => include/hw}/s390x/s390-pci-bus.h (100%)
>  rename {hw => include/hw}/s390x/s390-pci-inst.h (100%)

Much better :)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

(I don't have anything on s390-next atm, or I would have queued it
straight away. Better wait until we can do a proper headers sync and
queue the whole thing.)

