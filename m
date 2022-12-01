Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1893A63EFFB
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 12:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbiLALz0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 06:55:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbiLALzU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 06:55:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681CCC19
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 03:54:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669895664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wfsmej3HHrx0tS9FD+M12j2oAudKTTd2dHxjNHhhEoU=;
        b=M1YsDS09zusb/RyKzW5OfDIzfDC4A1RmsY9UP2q1C1hwf+p1X3mPbuzliAuRlOU0UvyLFM
        Vw704yoVJWZzjV2sNvf6XhL2vr/aWG7jJTKgQ5YFLhGPPYQPH4G9JvelcgEu+Xt0Ufu3xa
        1bP9PlqjFtm33KXKAj7LNSor7Ex/xFc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-551-jCF18RvrMj6ZPv9T7m3YUQ-1; Thu, 01 Dec 2022 06:54:21 -0500
X-MC-Unique: jCF18RvrMj6ZPv9T7m3YUQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 19543101A52A;
        Thu,  1 Dec 2022 11:54:21 +0000 (UTC)
Received: from localhost (unknown [10.39.193.98])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C421140C6EC4;
        Thu,  1 Dec 2022 11:54:20 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: Re: [PATCH v4 4/5] vfio: Remove CONFIG_VFIO_SPAPR_EEH
In-Reply-To: <4-v4-7993c351e9dc+33a818-vfio_modules_jgg@nvidia.com>
Organization: Red Hat GmbH
References: <4-v4-7993c351e9dc+33a818-vfio_modules_jgg@nvidia.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Thu, 01 Dec 2022 12:54:17 +0100
Message-ID: <87lenrwd92.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 29 2022, Jason Gunthorpe <jgg@nvidia.com> wrote:

> We don't need a kconfig symbol for this, just directly test CONFIG_EEH in
> the few places that needs it.

s/needs/need/

>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/Kconfig             | 5 -----
>  drivers/vfio/pci/vfio_pci_core.c | 6 +++---
>  2 files changed, 3 insertions(+), 8 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

