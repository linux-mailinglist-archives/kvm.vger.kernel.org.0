Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B2B273F6D
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 12:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbgIVKRW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 06:17:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44179 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726489AbgIVKRL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 06:17:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600769829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZSocmPHYqjEda5mFL2M3W+XcIJKAiTKuDLlDJf3zPUQ=;
        b=a4RZi4W71jCt9kGOzQvFBIUY+itq301hvs20311YfNU97Z8vUjs7pVmq4v/4rvHpZUtyRi
        mmnQmAF6mE5Rjr6G2pkZ/W+6o1pPo50BodMOXCykeUCukAdxE2D7GRwCqzkguVj8HPpQqf
        tAMARHLXwNRg2uW0hpai8aC/b2iiJ9g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-M3UaLETcNgSPFmAbIN35Rg-1; Tue, 22 Sep 2020 06:17:08 -0400
X-MC-Unique: M3UaLETcNgSPFmAbIN35Rg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C8491868410;
        Tue, 22 Sep 2020 10:17:05 +0000 (UTC)
Received: from gondolin (ovpn-112-114.ams2.redhat.com [10.36.112.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E5305DE19;
        Tue, 22 Sep 2020 10:16:52 +0000 (UTC)
Date:   Tue, 22 Sep 2020 12:16:50 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     alex.williamson@redhat.com, pmorel@linux.ibm.com,
        schnelle@linux.ibm.com, rth@twiddle.net, david@redhat.com,
        thuth@redhat.com, pasic@linux.ibm.com, borntraeger@de.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, philmd@redhat.com,
        qemu-s390x@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH v4 5/5] s390x/pci: Honor DMA limits set by vfio
Message-ID: <20200922121650.1bdd0ea6.cohuck@redhat.com>
In-Reply-To: <1600352445-21110-6-git-send-email-mjrosato@linux.ibm.com>
References: <1600352445-21110-1-git-send-email-mjrosato@linux.ibm.com>
        <1600352445-21110-6-git-send-email-mjrosato@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 17 Sep 2020 10:20:45 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> When an s390 guest is using lazy unmapping, it can result in a very
> large number of oustanding DMA requests, far beyond the default
> limit configured for vfio.  Let's track DMA usage similar to vfio
> in the host, and trigger the guest to flush their DMA mappings
> before vfio runs out.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  hw/s390x/s390-pci-bus.c  | 16 +++++++++++-----
>  hw/s390x/s390-pci-bus.h  |  9 +++++++++
>  hw/s390x/s390-pci-inst.c | 45 +++++++++++++++++++++++++++++++++++++++------
>  hw/s390x/s390-pci-inst.h |  3 +++
>  hw/s390x/s390-pci-vfio.c | 42 ++++++++++++++++++++++++++++++++++++++++++
>  hw/s390x/s390-pci-vfio.h |  5 +++++
>  6 files changed, 109 insertions(+), 11 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

