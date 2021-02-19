Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 190BE31F89A
	for <lists+kvm@lfdr.de>; Fri, 19 Feb 2021 12:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhBSLrY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 06:47:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20053 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230439AbhBSLrI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Feb 2021 06:47:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613735142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3mE7njBYMG0MxLIaO4uU6vjBuCNEmLN2HBTTtRFPAAM=;
        b=b4+KuC5UtAIdF7N2RC29N2ILItABW7jqRUv3Fx69bNIF3UWoUQ0kxhGrYgR3MMWA+5eb6/
        5FKSQiMiRhohO7OAWZWtoMDip+o7ig40S1uZoxpD+AP8/bzV77P276BgaRUQhaKppXcmzX
        ccyvKMOO9pD3Cvf+9uYCuZGY3Fe6KFI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-604-FNMI70oCMoiryk3QyfkpYw-1; Fri, 19 Feb 2021 06:45:40 -0500
X-MC-Unique: FNMI70oCMoiryk3QyfkpYw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A3199801975;
        Fri, 19 Feb 2021 11:45:39 +0000 (UTC)
Received: from gondolin (ovpn-113-92.ams2.redhat.com [10.36.113.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 72AF619C71;
        Fri, 19 Feb 2021 11:45:35 +0000 (UTC)
Date:   Fri, 19 Feb 2021 12:45:32 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     <kvm@vger.kernel.org>, <alex.williamson@redhat.com>,
        <mjrosato@linux.ibm.com>, <oren@nvidia.com>, <jgg@nvidia.com>
Subject: Re: [PATCH 1/1] vfio/pci: remove CONFIG_VFIO_PCI_ZDEV from Kconfig
Message-ID: <20210219124532.7a812ee5.cohuck@redhat.com>
In-Reply-To: <20210218104435.464773-1-mgurtovoy@nvidia.com>
References: <20210218104435.464773-1-mgurtovoy@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 18 Feb 2021 10:44:35 +0000
Max Gurtovoy <mgurtovoy@nvidia.com> wrote:

> In case we're running on s390 system always expose the capabilities for
> configuration of zPCI devices. In case we're running on different
> platform, continue as usual.
> 
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> ---
>  drivers/vfio/pci/Kconfig            | 12 ------------
>  drivers/vfio/pci/Makefile           |  2 +-
>  drivers/vfio/pci/vfio_pci.c         | 12 +++++-------
>  drivers/vfio/pci/vfio_pci_private.h |  2 +-
>  4 files changed, 7 insertions(+), 21 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

