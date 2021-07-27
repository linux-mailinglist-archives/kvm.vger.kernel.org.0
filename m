Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACFB3D7B11
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 18:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbhG0Qf3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 12:35:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39052 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230106AbhG0Qf2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Jul 2021 12:35:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627403728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=90tCfQVeRTH8MaC1o4KYlvgxHv2WwxCXpgUHehd5MrI=;
        b=e9PtRDJgqgSgi1Zv12JFPCzmPXrZkBI+3BR/cCxN8BaZxSv28rGYlaTbE5xht0R63yw3RI
        HWevbwAg6sdRukS6/C2S/jChEgVKbtmTSLmQidUKItoZPw5QHjcAUED0K1IYVcS+5iFI/e
        HoZnx40BU4nvlmceuAN7Lz6tfqLu8G8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-PbhXqnTjOW6wEiU_ZuHt2w-1; Tue, 27 Jul 2021 12:35:27 -0400
X-MC-Unique: PbhXqnTjOW6wEiU_ZuHt2w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A9AB4802B9F;
        Tue, 27 Jul 2021 16:35:24 +0000 (UTC)
Received: from localhost (unknown [10.39.192.46])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 986A260862;
        Tue, 27 Jul 2021 16:35:16 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Cai Huoqing <caihuoqing@baidu.com>, alex.williamson@redhat.com,
        jgg@ziepe.ca, eric.auger@redhat.com, kevin.tian@intel.com,
        giovanni.cabiddu@intel.com, mgurtovoy@nvidia.com, jannh@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cai Huoqing <caihuoqing@baidu.com>
Subject: Re: [PATCH] vfio: Add "#ifdef CONFIG_MMU" for vma operations
In-Reply-To: <20210727034000.547-1-caihuoqing@baidu.com>
Organization: Red Hat GmbH
References: <20210727034000.547-1-caihuoqing@baidu.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Tue, 27 Jul 2021 18:35:14 +0200
Message-ID: <877dhb4svx.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 27 2021, Cai Huoqing <caihuoqing@baidu.com> wrote:

> Add "#ifdef CONFIG_MMU",
> because vma mmap and vm_operations_struct depend on MMU

vfio_pci already depends on MMU -- what problems are you trying to fix?

>
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> ---
>  drivers/vfio/pci/vfio_pci.c | 4 ++++
>  drivers/vfio/vfio.c         | 8 ++++++++
>  2 files changed, 12 insertions(+)

