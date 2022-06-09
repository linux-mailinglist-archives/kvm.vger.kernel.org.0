Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7E0A54455B
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 10:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234862AbiFIIKU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 04:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbiFIIKQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 04:10:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 19B8D1775DE
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 01:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654762215;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tiLrsl9taTyGSrJjDKI7N8ule2WbsgbzAGcFN4T087E=;
        b=QnDZ/zpnoBPIfL0ChLL/ZgP3gW/8rD45bOJfgopwGME7wZ+WCRJ/kYIh9AgEqLC/7cqCDb
        Ej+347IIPXnO8BULK9RHc8epaghFw7/SYgeau/H6iO30NSSgXBZkDQS6Q3eSdqZux6irWk
        LnduEw1eX2kfmAfkzSVwTTVG30ZLUaE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-sFd4YcckPoi0xEo8ZlBU9g-1; Thu, 09 Jun 2022 04:10:14 -0400
X-MC-Unique: sFd4YcckPoi0xEo8ZlBU9g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8A7AB3C0E216;
        Thu,  9 Jun 2022 08:10:13 +0000 (UTC)
Received: from localhost (unknown [10.39.192.115])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B475492C3B;
        Thu,  9 Jun 2022 08:10:12 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        alex.williamson@redhat.com
Cc:     kwankhede@nvidia.com, farman@linux.ibm.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, diana.craciun@oss.nxp.com,
        eric.auger@redhat.com, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, jgg@nvidia.com, yishaih@nvidia.com,
        hch@lst.de
Subject: Re: [PATCH] vfio: de-extern-ify function prototypes
In-Reply-To: <165471414407.203056.474032786990662279.stgit@omen>
Organization: Red Hat GmbH
References: <165471414407.203056.474032786990662279.stgit@omen>
User-Agent: Notmuch/0.36 (https://notmuchmail.org)
Date:   Thu, 09 Jun 2022 10:10:11 +0200
Message-ID: <87tu8u9s0s.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 08 2022, Alex Williamson <alex.williamson@redhat.com> wrote:

> The use of 'extern' in function prototypes has been disrecommended in
> the kernel coding style for several years now, remove them from all vfio
> related files so contributors no longer need to decide between style and
> consistency.
>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>
> A patch in the same vein was proposed about a year ago, but tied to an ill
> fated series and forgotten.  Now that we're at the beginning of a new
> development cycle, I'd like to propose kicking off the v5.20 vfio next
> branch with this patch and would kindly ask anyone with pending respins or
> significant conflicts to rebase on top of this patch.  Thanks!
>
>  Documentation/driver-api/vfio-mediated-device.rst |   10 ++-
>  drivers/s390/cio/vfio_ccw_cp.h                    |   12 ++--
>  drivers/s390/cio/vfio_ccw_private.h               |    6 +-
>  drivers/vfio/fsl-mc/vfio_fsl_mc_private.h         |    2 -
>  drivers/vfio/platform/vfio_platform_private.h     |   21 +++---
>  include/linux/vfio.h                              |   70 ++++++++++-----------
>  include/linux/vfio_pci_core.h                     |   65 ++++++++++----------
>  7 files changed, 91 insertions(+), 95 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

