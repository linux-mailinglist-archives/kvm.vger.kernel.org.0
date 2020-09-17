Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5BDA26DA62
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 13:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgIQLgd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 07:36:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51339 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726721AbgIQLgK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Sep 2020 07:36:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600342559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5n7wJKyexD2oiZEydGT+/+g5eqfjGOnTvWw7VQtJAzQ=;
        b=A4pPjILlgYHTYSplI3Dm5zsEv4NxoqQTtQmJwBnZPD7p/P01GywYYMAqhI0LJU0yfLl/PP
        uMkdBgAzHQ/S7MfdDIe8wJHBG9H9XXQvxgYBB8XYgDo8GSmtAUUgoNb9RQ5tHK+GnOg157
        qhpO+zzm3k3DOtc8Mpt83sDuSF0E1EE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-dqePwP51NmafVBHYPjGY7g-1; Thu, 17 Sep 2020 07:35:55 -0400
X-MC-Unique: dqePwP51NmafVBHYPjGY7g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C1BC685C731;
        Thu, 17 Sep 2020 11:35:54 +0000 (UTC)
Received: from gondolin (ovpn-113-19.ams2.redhat.com [10.36.113.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A2662101416C;
        Thu, 17 Sep 2020 11:35:50 +0000 (UTC)
Date:   Thu, 17 Sep 2020 13:35:37 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <alex.williamson@redhat.com>, <wanghaibin.wang@huawei.com>
Subject: Re: [PATCH 2/2] vfio/pci: Remove bardirty from vfio_pci_device
Message-ID: <20200917133537.17af2ef3.cohuck@redhat.com>
In-Reply-To: <20200917033128.872-2-yuzenghui@huawei.com>
References: <20200917033128.872-1-yuzenghui@huawei.com>
        <20200917033128.872-2-yuzenghui@huawei.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 17 Sep 2020 11:31:28 +0800
Zenghui Yu <yuzenghui@huawei.com> wrote:

> It isn't clear what purpose the @bardirty serves. It might be used to avoid
> the unnecessary vfio_bar_fixup() invoking on a user-space BAR read, which
> is not required when bardirty is unset.
> 
> The variable was introduced in commit 89e1f7d4c66d ("vfio: Add PCI device
> driver") but never actually used, so it shouldn't be that important. Remove
> it.
> 
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> ---
>  drivers/vfio/pci/vfio_pci_config.c  | 7 -------
>  drivers/vfio/pci/vfio_pci_private.h | 1 -
>  2 files changed, 8 deletions(-)

Yes, it seems to have been write-only all the time.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

