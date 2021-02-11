Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9966631915F
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 18:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbhBKRnv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 12:43:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20336 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231327AbhBKRlK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Feb 2021 12:41:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613065180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=trbDC0Yj/EmRrSd8Ug5X0sY/Ixv1JBY5u+dTjpRPajc=;
        b=Q3eVV+oaM1wHXayWQtjGw/ckLux+DB0+ZXxFzKt3qmHIfyWWDcf0hPk8lzmsULBQWQGjai
        5YxzM8n2d4zNROoCJMXYZuUjXQkI4THOUzzrokc9WaHNVdOchl2QbsWn498ESuEbnOIMlw
        NjfRGZwmwtuSYDbgOasTzIoqQvdHkUI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-Kpj6XMQdMhunvbAtUlQBRQ-1; Thu, 11 Feb 2021 12:39:36 -0500
X-MC-Unique: Kpj6XMQdMhunvbAtUlQBRQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 17470801978;
        Thu, 11 Feb 2021 17:39:34 +0000 (UTC)
Received: from gondolin (ovpn-112-229.ams2.redhat.com [10.36.112.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 363975C239;
        Thu, 11 Feb 2021 17:39:27 +0000 (UTC)
Date:   Thu, 11 Feb 2021 18:39:24 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        liranl@nvidia.com, oren@nvidia.com, tzahio@nvidia.com,
        leonro@nvidia.com, yarong@nvidia.com, aviadye@nvidia.com,
        shahafs@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, gmataev@nvidia.com, cjia@nvidia.com,
        yishaih@nvidia.com, aik@ozlabs.ru
Subject: Re: [PATCH 8/9] vfio/pci: use x86 naming instead of igd
Message-ID: <20210211183924.090ed3a9.cohuck@redhat.com>
In-Reply-To: <9fc2b752-88a3-0607-00fc-cb7414dcd5f6@linux.ibm.com>
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
        <20210201162828.5938-9-mgurtovoy@nvidia.com>
        <20210201181454.22112b57.cohuck@redhat.com>
        <599c6452-8ba6-a00a-65e7-0167f21eac35@linux.ibm.com>
        <20210201114230.37c18abd@omen.home.shazbot.org>
        <20210202170659.1c62a9e8.cohuck@redhat.com>
        <20210202171021.GW4247@nvidia.com>
        <f49512dd-9a5c-b1d8-1609-da55e270635b@nvidia.com>
        <9fc2b752-88a3-0607-00fc-cb7414dcd5f6@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 11 Feb 2021 11:29:37 -0500
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> On 2/11/21 10:47 AM, Max Gurtovoy wrote:
> > 
> > On 2/2/2021 7:10 PM, Jason Gunthorpe wrote:  
> >> On Tue, Feb 02, 2021 at 05:06:59PM +0100, Cornelia Huck wrote:
> >>  
> >>> On the other side, we have the zdev support, which both requires s390
> >>> and applies to any pci device on s390.  
> >> Is there a reason why CONFIG_VFIO_PCI_ZDEV exists? Why not just always
> >> return the s390 specific data in VFIO_DEVICE_GET_INFO if running on
> >> s390?
> >>
> >> It would be like returning data from ACPI on other platforms.  
> > 
> > Agree.
> > 
> > all agree that I remove it ?  
> 
> I did some archives digging on the discussions around 
> CONFIG_VFIO_PCI_ZDEV and whether we should/should not have a Kconfig 
> switch around this; it was something that was carried over various 
> attempts to get the zdev support upstream, but I can't really find (or 
> think of) a compelling reason that a Kconfig switch must be kept for it. 
>   The bottom line is if you're on s390, you really want zdev support.
> 
> So: I don't have an objection so long as the net result is that 
> vfio_pci_zdev.o is always built in to vfio-pci(-core) for s390.

Yes, I also don't expect presence of the zdev stuff to confuse any
older userspace.

So, let's just drop CONFIG_VFIO_PCI_ZDEV and use CONFIG_S390 in lieu of
it (not changing the file name).

