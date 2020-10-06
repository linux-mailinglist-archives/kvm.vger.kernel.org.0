Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8A1D284F12
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 17:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbgJFPed (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 11:34:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25692 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725972AbgJFPed (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Oct 2020 11:34:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601998472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5V+iIuHxnndGp3MRUYQx3w9G9gKoG1QSYazA/Q9Znxw=;
        b=VF64P7Tqb6unm1lJl4XWlVMjlhkEBUt65YfIRy/lh6rdgVy8FXKeVsSIXd8x+9i7Twiuup
        GE1QaU43tD94BHLI6320sdk+ckZtPP9zPZgC13nSrNQbWiP4Lp9+sYTXV4QgBD54loiTdt
        uGIJhvkkU8PpTbGDanr59O6uffuGHNU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-q2lo-KasP9eZMbEqlcV9VA-1; Tue, 06 Oct 2020 11:34:28 -0400
X-MC-Unique: q2lo-KasP9eZMbEqlcV9VA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B033E18C521F;
        Tue,  6 Oct 2020 15:34:26 +0000 (UTC)
Received: from gondolin (ovpn-112-156.ams2.redhat.com [10.36.112.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 35E925DA33;
        Tue,  6 Oct 2020 15:34:12 +0000 (UTC)
Date:   Tue, 6 Oct 2020 17:34:09 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     thuth@redhat.com, pmorel@linux.ibm.com, schnelle@linux.ibm.com,
        rth@twiddle.net, david@redhat.com, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, qemu-s390x@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/9] MAINTAINERS: Update s390 PCI entry to include
 headers
Message-ID: <20201006173409.7fa1822b.cohuck@redhat.com>
In-Reply-To: <1601669191-6731-3-git-send-email-mjrosato@linux.ibm.com>
References: <1601669191-6731-1-git-send-email-mjrosato@linux.ibm.com>
        <1601669191-6731-3-git-send-email-mjrosato@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  2 Oct 2020 16:06:24 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> Accomodate changes to file locations.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b76fb31..dd4e0ea 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1442,6 +1442,7 @@ S390 PCI
>  M: Matthew Rosato <mjrosato@linux.ibm.com>
>  S: Supported
>  F: hw/s390x/s390-pci*
> +F: include/hw/s390x/s390-pci*
>  L: qemu-s390x@nongnu.org
>  
>  UniCore32 Machines

I'd probably merge this into the previous patch.

