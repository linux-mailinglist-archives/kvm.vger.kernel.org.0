Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 253BF642C3E
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 16:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbiLEPtO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 10:49:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbiLEPtN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 10:49:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A1E3B1DE
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 07:48:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670255295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MN1Y1RGuP/IZbtfUFOBeBBJ4/cQlsXmngnFpNKuuIAM=;
        b=MPRQ/Kn5klS3iaVE70z4k+6SyYD8KhtBz/Ah/bblLjr5IZF8ORl58muAq6SVBEx70XeXTZ
        4WQs2/vUhGP9ig7Jq7YAe2eCqVYUUr5R+YRz06HMYV29mRnMhuFpT5e1kpegTtFeJvRrCy
        qUfMjCYQrXwyxhiL268Xb6NQtBEOFow=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-27-qAu6eXC5MguyzylXQ2PqAg-1; Mon, 05 Dec 2022 10:48:12 -0500
X-MC-Unique: qAu6eXC5MguyzylXQ2PqAg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D93EF2999B4C;
        Mon,  5 Dec 2022 15:48:11 +0000 (UTC)
Received: from localhost (unknown [10.39.193.33])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 895A8145BA44;
        Mon,  5 Dec 2022 15:48:11 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: Re: [PATCH v5 5/5] vfio: Fold vfio_virqfd.ko into vfio.ko
In-Reply-To: <5-v5-fc5346cacfd4+4c482-vfio_modules_jgg@nvidia.com>
Organization: Red Hat GmbH
References: <5-v5-fc5346cacfd4+4c482-vfio_modules_jgg@nvidia.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Mon, 05 Dec 2022 16:48:08 +0100
Message-ID: <87k035hmx3.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 05 2022, Jason Gunthorpe <jgg@nvidia.com> wrote:

> This is only 1.8k, putting it in its own module is not really
> necessary. The kconfig infrastructure is still there to completely remove
> it for systems that are trying for small footprint.
>
> Put it in the main vfio.ko module now that kbuild can support multiple .c
> files.
>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/Kconfig     |  2 +-
>  drivers/vfio/Makefile    |  4 +---
>  drivers/vfio/vfio.h      | 13 +++++++++++++
>  drivers/vfio/vfio_main.c |  7 +++++++
>  drivers/vfio/virqfd.c    | 17 +++--------------
>  5 files changed, 25 insertions(+), 18 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

