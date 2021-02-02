Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9293830B914
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 09:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbhBBH7m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 02:59:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30490 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231494AbhBBH7l (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 02:59:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612252695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RSs+hI92LA+WjDbN8bdyYyPQ3riB041flC5bDy3Nc0E=;
        b=ZPBYW7fdH1dJvERxQOJEAEd6EiigMcz0cFu9wH2dZQzLpMDV/d8OODVVrN91TkGk5v7fDR
        Zuhu4b6oAIUla2uj9erBmXG5jvSuGelPEeYSgXVRM6buCM1qe9/qhJCZIwgDbWgKtyImVc
        weHkniopk0z+xafvwRDgkOmqvavCJe8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-OpISDnU8NjOlwL1voug-oQ-1; Tue, 02 Feb 2021 02:58:07 -0500
X-MC-Unique: OpISDnU8NjOlwL1voug-oQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4858B107ACE3;
        Tue,  2 Feb 2021 07:58:05 +0000 (UTC)
Received: from gondolin (ovpn-113-169.ams2.redhat.com [10.36.113.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F058060BE5;
        Tue,  2 Feb 2021 07:57:57 +0000 (UTC)
Date:   Tue, 2 Feb 2021 08:57:55 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     <jgg@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <alex.williamson@redhat.com>,
        <liranl@nvidia.com>, <oren@nvidia.com>, <tzahio@nvidia.com>,
        <leonro@nvidia.com>, <yarong@nvidia.com>, <aviadye@nvidia.com>,
        <shahafs@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <gmataev@nvidia.com>, <cjia@nvidia.com>,
        <mjrosato@linux.ibm.com>, <yishaih@nvidia.com>, <aik@ozlabs.ru>
Subject: Re: [PATCH 5/9] vfio-pci/zdev: remove unused vdev argument
Message-ID: <20210202085755.3e06184e.cohuck@redhat.com>
In-Reply-To: <20210201162828.5938-6-mgurtovoy@nvidia.com>
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
        <20210201162828.5938-6-mgurtovoy@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 1 Feb 2021 16:28:24 +0000
Max Gurtovoy <mgurtovoy@nvidia.com> wrote:

> Zdev static functions does not use vdev argument. Remove it.

s/does not use/do not use the/

> 
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_zdev.c | 20 ++++++++------------
>  1 file changed, 8 insertions(+), 12 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

