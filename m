Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4A2E284F0D
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 17:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgJFPd1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 11:33:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58621 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725769AbgJFPd1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Oct 2020 11:33:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601998405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=++6yuXWN6ko8ZpTeK17UHXTRv31hemak3S9rYqylvYU=;
        b=dbezLWirblJ1woICeTbBse5sUo+6Su7skwjElQdKj4pi4Lx+jdsOBi8Sx3hznuERG+b1/q
        nNivhT5xj/qltz3yoMTUlgKT0QpKsnxqiUEMX5tFaKFbQrMQPAPCMVwwWoPCNJZCxcGnN4
        kmgus9eMOk/7/IdaJVpH/Qa4JpnqUEU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-4tpQelb_PoKxPEpOL_SIQQ-1; Tue, 06 Oct 2020 11:33:22 -0400
X-MC-Unique: 4tpQelb_PoKxPEpOL_SIQQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 641B587952A;
        Tue,  6 Oct 2020 15:33:20 +0000 (UTC)
Received: from gondolin (ovpn-112-156.ams2.redhat.com [10.36.112.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 40E685C1C4;
        Tue,  6 Oct 2020 15:33:02 +0000 (UTC)
Date:   Tue, 6 Oct 2020 17:32:59 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     thuth@redhat.com, pmorel@linux.ibm.com, schnelle@linux.ibm.com,
        rth@twiddle.net, david@redhat.com, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, qemu-s390x@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 1/9] s390x/pci: Move header files to include/hw/s390x
Message-ID: <20201006173259.1ec36597.cohuck@redhat.com>
In-Reply-To: <1601669191-6731-2-git-send-email-mjrosato@linux.ibm.com>
References: <1601669191-6731-1-git-send-email-mjrosato@linux.ibm.com>
        <1601669191-6731-2-git-send-email-mjrosato@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  2 Oct 2020 16:06:23 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> Seems a more appropriate location for them.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  hw/s390x/s390-pci-bus.c          |   4 +-
>  hw/s390x/s390-pci-bus.h          | 372 ---------------------------------------
>  hw/s390x/s390-pci-inst.c         |   4 +-
>  hw/s390x/s390-pci-inst.h         | 312 --------------------------------
>  hw/s390x/s390-virtio-ccw.c       |   2 +-
>  include/hw/s390x/s390-pci-bus.h  | 372 +++++++++++++++++++++++++++++++++++++++
>  include/hw/s390x/s390-pci-inst.h | 312 ++++++++++++++++++++++++++++++++
>  7 files changed, 689 insertions(+), 689 deletions(-)
>  delete mode 100644 hw/s390x/s390-pci-bus.h
>  delete mode 100644 hw/s390x/s390-pci-inst.h
>  create mode 100644 include/hw/s390x/s390-pci-bus.h
>  create mode 100644 include/hw/s390x/s390-pci-inst.h

Looks good, but...

<meta>Is there any way to coax out a more reviewable version of this
via git mv?</meta>

