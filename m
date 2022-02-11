Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5C064B23E6
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 12:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345616AbiBKLEL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 06:04:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243673AbiBKLEK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 06:04:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2AB5CDB0
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 03:04:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644577449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Hw1H6VxQIxqtQ0FHZtvpNccFNpBTEWMb8V9sWWOrF50=;
        b=Hq75AAksWzqpL78s2f5rKcHcJAWMxVx0jnKNLWX24eGwuiUGfEJqtaVMUVG39Uiv4q1oP4
        beXsqCLhxXwLwm2sSZpsai8iI2wP4O1QPIGMZJ7gSzsek0Xpvqc/oPNM9F9HQtPyp1z8eP
        zpG44p7SHk69Sxcq5J6Wu7F59pXxDoM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-42-J7RO8vEBNCOtqkqY8zrV9g-1; Fri, 11 Feb 2022 06:04:05 -0500
X-MC-Unique: J7RO8vEBNCOtqkqY8zrV9g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5275680D680;
        Fri, 11 Feb 2022 11:04:03 +0000 (UTC)
Received: from localhost (unknown [10.39.194.59])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 850F26F125;
        Fri, 11 Feb 2022 11:04:01 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        bhelgaas@google.com, jgg@nvidia.com, saeedm@nvidia.com
Cc:     linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, yishaih@nvidia.com,
        maorg@nvidia.com, ashok.raj@intel.com, kevin.tian@intel.com,
        shameerali.kolothum.thodi@huawei.com
Subject: Re: [PATCH V7 mlx5-next 10/15] vfio: Remove migration protocol v1
 documentation
In-Reply-To: <20220207172216.206415-11-yishaih@nvidia.com>
Organization: Red Hat GmbH
References: <20220207172216.206415-1-yishaih@nvidia.com>
 <20220207172216.206415-11-yishaih@nvidia.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Fri, 11 Feb 2022 12:03:59 +0100
Message-ID: <871r09u0kg.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 07 2022, Yishai Hadas <yishaih@nvidia.com> wrote:

> From: Jason Gunthorpe <jgg@nvidia.com>
>
> v1 was never implemented and is replaced by v2.
>
> The old uAPI documentation is removed from the header file.
>
> The old uAPI definitions are still kept in the header file till v2 will
> reach Linus's tree.

That sentence is a bit weird: If this file has reached Linus' tree,
obviously v2 has reached Linus' tree. Maybe replace with:

"The old uAPI definitions are still kept in the header file to ease
transition for userspace copying these headers."

>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  include/uapi/linux/vfio.h | 200 +-------------------------------------
>  1 file changed, 2 insertions(+), 198 deletions(-)
>
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 773895988cf1..227f55d57e06 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -323,7 +323,7 @@ struct vfio_region_info_cap_type {
>  #define VFIO_REGION_TYPE_PCI_VENDOR_MASK	(0xffff)
>  #define VFIO_REGION_TYPE_GFX                    (1)
>  #define VFIO_REGION_TYPE_CCW			(2)
> -#define VFIO_REGION_TYPE_MIGRATION              (3)
> +#define VFIO_REGION_TYPE_MIGRATION_DEPRECATED   (3)

This will still break QEMU compilation after a headers update (although
it's not hard to fix.) I think we can live with that if needed.

>  
>  /* sub-types for VFIO_REGION_TYPE_PCI_* */
>  

