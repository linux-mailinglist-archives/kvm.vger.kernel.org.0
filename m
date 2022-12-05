Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE7F642C37
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 16:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbiLEPrQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 10:47:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiLEPrN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 10:47:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92BA79590
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 07:46:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670255179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2ubCGRQj6GOcObtEyB9OZewRUThLVB4rcOtIPrRG0FU=;
        b=f7M3qB6UaAg/JtDsmPWd1SIC02+RnafzelDkOUPRnmCWDyoY061PdA3o1GJCMyoCKm0bHT
        LFhXfj+JaiOH1UBxZVYQP+c2IefI9KpUClp1LFzCLPWbZ08PYSs2LuWS5+jNGI8VnHVaqd
        5R7CgfhKFp2Wm/1PrUq6FiKebZ70gws=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-468-9vYQsM8tN3StvONqNpQgTg-1; Mon, 05 Dec 2022 10:46:10 -0500
X-MC-Unique: 9vYQsM8tN3StvONqNpQgTg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 73FDE85A59D;
        Mon,  5 Dec 2022 15:46:10 +0000 (UTC)
Received: from localhost (unknown [10.39.193.33])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B39C49BB60;
        Mon,  5 Dec 2022 15:46:10 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: Re: [PATCH v5 1/5] vfio/pci: Move all the SPAPR PCI specific logic
 to vfio_pci_core.ko
In-Reply-To: <1-v5-fc5346cacfd4+4c482-vfio_modules_jgg@nvidia.com>
Organization: Red Hat GmbH
References: <1-v5-fc5346cacfd4+4c482-vfio_modules_jgg@nvidia.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Mon, 05 Dec 2022 16:46:04 +0100
Message-ID: <87mt81hn0j.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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

> The vfio_spapr_pci_eeh_open/release() functions are one line wrappers
> around an arch function. Just call them directly. This eliminates some
> weird exported symbols that don't need to exist.
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 11 +++++++++--
>  drivers/vfio/vfio_spapr_eeh.c    | 13 -------------
>  include/linux/vfio.h             | 11 -----------
>  3 files changed, 9 insertions(+), 26 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

