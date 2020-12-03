Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4CBE2CD6A6
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 14:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730646AbgLCNYW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 08:24:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32854 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730521AbgLCNYS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Dec 2020 08:24:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607001772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NIUzTmMN44WwsPpuCCIwAdtMYstoCYdNFe2bwG4DXTE=;
        b=Laag8f2UqkwqtvXqpd8W0pIUT+50u4QmynlY25/wMHiAhtbP5U5En3OKwvuvMf67s1P9M0
        Q0bytVr/xpopT2tRgNqY1Gzd5jT//JpekivzMAx4HizIZcPw3V/qeg/BMhcdcBvl0cU/uo
        Fx4XRQBn338LzsTucMvqaDQf/VVv9wk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-2GAwDaFjNRe_uYdNzTiVFQ-1; Thu, 03 Dec 2020 08:22:50 -0500
X-MC-Unique: 2GAwDaFjNRe_uYdNzTiVFQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 70B5F1092BA9;
        Thu,  3 Dec 2020 13:22:49 +0000 (UTC)
Received: from gondolin (ovpn-113-106.ams2.redhat.com [10.36.113.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CE51A6085A;
        Thu,  3 Dec 2020 13:22:41 +0000 (UTC)
Date:   Thu, 3 Dec 2020 14:22:39 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v1 2/5] vfio: platform: Switch to use
 platform_get_mem_or_io_resource()
Message-ID: <20201203142239.616b6d05.cohuck@redhat.com>
In-Reply-To: <20201027175806.20305-2-andriy.shevchenko@linux.intel.com>
References: <20201027175806.20305-1-andriy.shevchenko@linux.intel.com>
        <20201027175806.20305-2-andriy.shevchenko@linux.intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 27 Oct 2020 19:58:03 +0200
Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> Switch to use new platform_get_mem_or_io_resource() instead of
> home grown analogue.
> 
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: kvm@vger.kernel.org
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/vfio/platform/vfio_platform.c | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

