Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBE744D2C5
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 08:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbhKKH7r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 02:59:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43515 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229543AbhKKH7p (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 02:59:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636617416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IsiWJOCukmBcK7kCfQJuDEL0VlH6Lf2OFetW684iiSs=;
        b=UuiD86hBsmGmJnXwGB4IhH+blp2wEAx2nznVu1AUFdw2zhFFpPB1ttxPnbgrdz3d3fY0oi
        lbPuKZX0dQ5ymdwzkl1GtXCWoiyZaWPrZAErGvEzcTo30ht9tSshJKsQPhVKM+Q0S+IdMd
        iAyh1PRodnu3EB4u8meFIDcTzdRZ6/c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-npEDT5IMMd-nhiWZMui2aQ-1; Thu, 11 Nov 2021 02:56:55 -0500
X-MC-Unique: npEDT5IMMd-nhiWZMui2aQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6AD919251A2;
        Thu, 11 Nov 2021 07:56:53 +0000 (UTC)
Received: from localhost (unknown [10.39.193.105])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A7CE45C1B4;
        Thu, 11 Nov 2021 07:56:46 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Randy Dunlap <rdunlap@infradead.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        kernel test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org
Subject: Re: drivers/vfio/vfio.c:293: warning: expecting prototype for
 Container objects(). Prototype was for vfio_container_get() instead
In-Reply-To: <38a9cb92-a473-40bf-b8f9-85cc5cfc2da4@infradead.org>
Organization: Red Hat GmbH
References: <202111102328.WDUm0Bl7-lkp@intel.com>
 <20211110164256.GY1740502@nvidia.com>
 <38a9cb92-a473-40bf-b8f9-85cc5cfc2da4@infradead.org>
User-Agent: Notmuch/0.33.1 (https://notmuchmail.org)
Date:   Thu, 11 Nov 2021 08:56:45 +0100
Message-ID: <87v90z86rm.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 10 2021, Randy Dunlap <rdunlap@infradead.org> wrote:

> On 11/10/21 8:42 AM, Jason Gunthorpe wrote:
>> On Wed, Nov 10, 2021 at 11:12:39PM +0800, kernel test robot wrote:
>>> Hi Jason,
>>>
>>> FYI, the error/warning still remains.
>> 
>> This is just a long standing kdoc misuse.
>> 
>> vfio is not W=1 kdoc clean.
>> 
>> Until someone takes a project to fix this comprehensively there is not
>> much point in reporting new complaints related the existing mis-use..
>
> Hi,
>
> Can we just remove all misused "/**" comments in vfio.c until
> someone cares enough to use proper kernel-doc there?
>
> ---
> From: Randy Dunlap <rdunlap@infradead.org>
> Subject: [PATCH] vfio/vfio: remove all kernel-doc notation
>
> vfio.c abuses (misuses) "/**", which indicates the beginning of
> kernel-doc notation in the kernel tree. This causes a bunch of
> kernel-doc complaints about this source file, so quieten all of
> them by changing all "/**" to "/*".
>
> vfio.c:236: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>   * IOMMU driver registration
> vfio.c:236: warning: missing initial short description on line:
>   * IOMMU driver registration
> vfio.c:295: warning: expecting prototype for Container objects(). Prototype was for vfio_container_get() instead
> vfio.c:317: warning: expecting prototype for Group objects(). Prototype was for __vfio_group_get_from_iommu() instead
> vfio.c:496: warning: Function parameter or member 'device' not described in 'vfio_device_put'
> vfio.c:496: warning: expecting prototype for Device objects(). Prototype was for vfio_device_put() instead
> vfio.c:599: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>   * Async device support
> vfio.c:599: warning: missing initial short description on line:
>   * Async device support
> vfio.c:693: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>   * VFIO driver API
> vfio.c:693: warning: missing initial short description on line:
>   * VFIO driver API
> vfio.c:835: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>   * Get a reference to the vfio_device for a device.  Even if the
> vfio.c:835: warning: missing initial short description on line:
>   * Get a reference to the vfio_device for a device.  Even if the
> vfio.c:969: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>   * VFIO base fd, /dev/vfio/vfio
> vfio.c:969: warning: missing initial short description on line:
>   * VFIO base fd, /dev/vfio/vfio
> vfio.c:1187: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>   * VFIO Group fd, /dev/vfio/$GROUP
> vfio.c:1187: warning: missing initial short description on line:
>   * VFIO Group fd, /dev/vfio/$GROUP
> vfio.c:1540: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>   * VFIO Device fd
> vfio.c:1540: warning: missing initial short description on line:
>   * VFIO Device fd
> vfio.c:1615: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>   * External user API, exported by symbols to be linked dynamically.
> vfio.c:1615: warning: missing initial short description on line:
>   * External user API, exported by symbols to be linked dynamically.
> vfio.c:1663: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>   * External user API, exported by symbols to be linked dynamically.
> vfio.c:1663: warning: missing initial short description on line:
>   * External user API, exported by symbols to be linked dynamically.
> vfio.c:1742: warning: Function parameter or member 'caps' not described in 'vfio_info_cap_add'
> vfio.c:1742: warning: Function parameter or member 'size' not described in 'vfio_info_cap_add'
> vfio.c:1742: warning: Function parameter or member 'id' not described in 'vfio_info_cap_add'
> vfio.c:1742: warning: Function parameter or member 'version' not described in 'vfio_info_cap_add'
> vfio.c:1742: warning: expecting prototype for Sub(). Prototype was for vfio_info_cap_add() instead
> vfio.c:2276: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>   * Module/class support
> vfio.c:2276: warning: missing initial short description on line:
>   * Module/class support
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: kvm@vger.kernel.org
> ---
>   drivers/vfio/vfio.c |   28 ++++++++++++++--------------
>   1 file changed, 14 insertions(+), 14 deletions(-)

It's been like that since the code was introduced, these were probably
never intended to be kerneldoc comments.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

