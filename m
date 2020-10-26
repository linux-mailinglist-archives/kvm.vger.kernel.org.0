Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6DF29929C
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 17:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1786168AbgJZQik (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 12:38:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45884 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1775370AbgJZQik (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Oct 2020 12:38:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603730318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PjqOY2lI1bbJHURgd2W0lGLQ9gRC4wy7ubmSk6DrJuk=;
        b=Tg7rUkyW7WDQYmMxuRf4ahvlnG0us/f+i9ykLlXh84/yidLA0BCX1522ANRBOOf+4Y1huY
        zA41Og4x1oDwlqDMTOaCGj37Rik8LqfKWMgpjPieOegjhIk1kmK4S4Wk2x5qpe+1rNGDCv
        4J3+h8cTH5h1z+SIhH1S0mF6kSS0xMg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-kKHeZ6X_Pre5bTvOG9HC8Q-1; Mon, 26 Oct 2020 12:38:37 -0400
X-MC-Unique: kKHeZ6X_Pre5bTvOG9HC8Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A50E885EE94;
        Mon, 26 Oct 2020 16:38:35 +0000 (UTC)
Received: from gondolin (ovpn-113-108.ams2.redhat.com [10.36.113.108])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E5A535C1BB;
        Mon, 26 Oct 2020 16:38:23 +0000 (UTC)
Date:   Mon, 26 Oct 2020 17:38:21 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     thuth@redhat.com, pmorel@linux.ibm.com, schnelle@linux.ibm.com,
        rth@twiddle.net, david@redhat.com, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, philmd@redhat.com,
        qemu-s390x@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH 13/13] s390x/pci: get zPCI function info from host
Message-ID: <20201026173821.0bda1606.cohuck@redhat.com>
In-Reply-To: <1603726481-31824-14-git-send-email-mjrosato@linux.ibm.com>
References: <1603726481-31824-1-git-send-email-mjrosato@linux.ibm.com>
        <1603726481-31824-14-git-send-email-mjrosato@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 26 Oct 2020 11:34:41 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> We use the capability chains of the VFIO_DEVICE_GET_INFO ioctl to retrieve
> the CLP information that the kernel exports.
> 
> To be compatible with previous kernel versions we fall back on previous
> predefined values, same as the emulation values, when the ioctl is found
> to not support capability chains. If individual CLP capabilities are not
> found, we fall back on default values for only those capabilities missing
> from the chain.
> 
> This patch is based on work previously done by Pierre Morel.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  hw/s390x/s390-pci-bus.c          |   9 +-
>  hw/s390x/s390-pci-vfio.c         | 180 +++++++++++++++++++++++++++++++++++++++
>  hw/s390x/trace-events            |   6 ++
>  include/hw/s390x/s390-pci-bus.h  |   1 +
>  include/hw/s390x/s390-pci-clp.h  |  12 ++-
>  include/hw/s390x/s390-pci-vfio.h |   1 +
>  6 files changed, 202 insertions(+), 7 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

