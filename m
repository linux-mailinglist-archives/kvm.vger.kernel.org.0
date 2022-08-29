Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 123675A4B09
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 14:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbiH2MHD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 08:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbiH2MGp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 08:06:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE6567CA9B
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 04:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661773794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B0XL6Q04nIg/XxBauGZwq9HXLIiWmzdXxQ7M/5lwYpo=;
        b=X1U3xPa+dSid4g3eLEblJS2D9gFl0szBtAEW1Y4G3khXMiqa3mpSDw2wAAJxCCBZfAo150
        xLWTBnZwhAQ4BXXV/bx1Bi5rZDydjoEJz/6Ks2ckA42kCB8vrOEOkoTdVssFgJE+OEnlKj
        bEtuCD930zRaNSLGgqPNjZC9BcFlg4Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-19-s6Sr3qtDNzSykXb1BIhHxA-1; Mon, 29 Aug 2022 07:49:51 -0400
X-MC-Unique: s6Sr3qtDNzSykXb1BIhHxA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7E837185A79C;
        Mon, 29 Aug 2022 11:49:50 +0000 (UTC)
Received: from localhost (unknown [10.39.193.155])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 362941410F36;
        Mon, 29 Aug 2022 11:49:50 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH v2 2/3] vfio/pci: Rename vfio_pci_register_dev_region()
In-Reply-To: <2-v2-1bd95d72f298+e0e-vfio_pci_priv_jgg@nvidia.com>
Organization: Red Hat GmbH
References: <2-v2-1bd95d72f298+e0e-vfio_pci_priv_jgg@nvidia.com>
User-Agent: Notmuch/0.36 (https://notmuchmail.org)
Date:   Mon, 29 Aug 2022 13:49:48 +0200
Message-ID: <874jxvfew3.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 26 2022, Jason Gunthorpe <jgg@nvidia.com> wrote:

> As this is part of the vfio_pci_core component it should be called
> vfio_pci_core_register_dev_region() like everything else exported from
> this module.
>
> Suggested-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 10 +++++-----
>  drivers/vfio/pci/vfio_pci_igd.c  |  6 +++---
>  include/linux/vfio_pci_core.h    |  8 ++++----
>  3 files changed, 12 insertions(+), 12 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

