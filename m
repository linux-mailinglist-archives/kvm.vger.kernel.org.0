Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86CE728875F
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 12:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732138AbgJIK43 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 06:56:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46594 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732129AbgJIK42 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Oct 2020 06:56:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602240987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jfXEHYRtiMq8RgN0NLoCov9z8iXV0l14nLGIeMKyq2M=;
        b=SGkQSpKvdHnxKGi4wRN/rAHgJpg/ZePMyXdDx3R9UM9T5qqnzaAVG8TbT/w7eASoW/PlUy
        8w3a0GFqhW6nIJIG0Gk22ELcMakCR2TY635DX9Ybt2I1JIIoZkM1m4pCf+/tyBwVQ3x4z+
        ITSO/M0A65PPO9TE/+01QA/tRiXYHxU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-H_bzS5YLN7O5fUaUkTW4gw-1; Fri, 09 Oct 2020 06:56:25 -0400
X-MC-Unique: H_bzS5YLN7O5fUaUkTW4gw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1536010051D1;
        Fri,  9 Oct 2020 10:56:24 +0000 (UTC)
Received: from gondolin (ovpn-113-40.ams2.redhat.com [10.36.113.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4329060BFA;
        Fri,  9 Oct 2020 10:56:12 +0000 (UTC)
Date:   Fri, 9 Oct 2020 12:56:09 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     thuth@redhat.com, pmorel@linux.ibm.com, schnelle@linux.ibm.com,
        rth@twiddle.net, david@redhat.com, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, qemu-s390x@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 08/10] s390x/pci: use a PCI Function structure
Message-ID: <20201009125609.1eb5f586.cohuck@redhat.com>
In-Reply-To: <1602097455-15658-9-git-send-email-mjrosato@linux.ibm.com>
References: <1602097455-15658-1-git-send-email-mjrosato@linux.ibm.com>
        <1602097455-15658-9-git-send-email-mjrosato@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  7 Oct 2020 15:04:13 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> From: Pierre Morel <pmorel@linux.ibm.com>
> 
> We use a ClpRspQueryPci structure to hold the information related to a
> zPCI Function.
> 
> This allows us to be ready to support different zPCI functions and to
> retrieve the zPCI function information from the host.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  hw/s390x/s390-pci-bus.c         | 22 +++++++++++++++++-----
>  hw/s390x/s390-pci-inst.c        |  8 ++------
>  include/hw/s390x/s390-pci-bus.h |  1 +
>  3 files changed, 20 insertions(+), 11 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

