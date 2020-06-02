Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD67D1EBEDE
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 17:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbgFBPQU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 11:16:20 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43984 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726817AbgFBPQU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Jun 2020 11:16:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591110979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W+jm8RZj0eEZNUCx8pItgFj239Ty9q6VVmPvCtDVvWo=;
        b=WHU/emv2bUAgBG+CT4QOn7d9F5GZW5mcLSYSsjqfFR2L7fWbLdxiN4PqrceVx19MRa6Myb
        DAXKLDHOVU5jNjtlCFqslXvQvT7xWXrpxxfxFXHVjWEc4q+7qF4/xu6X6w2yd9ZdI/lvZP
        Hx4RNRHdpF1uYQYqnHLQV9E2G+4DAac=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-jiVHUJsONHWevsy7DxQBsg-1; Tue, 02 Jun 2020 11:16:17 -0400
X-MC-Unique: jiVHUJsONHWevsy7DxQBsg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43F27107ACCA;
        Tue,  2 Jun 2020 15:16:16 +0000 (UTC)
Received: from x1.home (ovpn-112-195.phx2.redhat.com [10.3.112.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A02155D9CC;
        Tue,  2 Jun 2020 15:16:15 +0000 (UTC)
Date:   Tue, 2 Jun 2020 09:16:15 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Randy Dunlap <rdunlap@infradead.org>,
        Kirti Wankhede <kwankhede@nvidia.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>, KVM <kvm@vger.kernel.org>
Subject: Re: linux-next: Tree for Jun 2 (vfio)
Message-ID: <20200602091615.145e6f09@x1.home>
In-Reply-To: <96573328-d6d6-8da2-e388-f448d461abb3@infradead.org>
References: <20200602203737.6eec243f@canb.auug.org.au>
        <96573328-d6d6-8da2-e388-f448d461abb3@infradead.org>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2 Jun 2020 07:36:45 -0700
Randy Dunlap <rdunlap@infradead.org> wrote:

> On 6/2/20 3:37 AM, Stephen Rothwell wrote:
> > Hi all,
> > 
> > News: The merge window has opened, so please do *not* add v5.9 material
> > to your linux-next included branches until after v5.8-rc1 has been
> > released.
> > 
> > Changes since 20200529:
> >   
> 
> on i386:
> 
> ld: drivers/vfio/vfio_iommu_type1.o: in function `vfio_dma_populate_bitmap':
> vfio_iommu_type1.c:(.text.unlikely+0x41): undefined reference to `__udivdi3'

I think Kirti received a 0-day report on this.  Kirti, could you please
post the fix you identified?  Thanks,

Alex

