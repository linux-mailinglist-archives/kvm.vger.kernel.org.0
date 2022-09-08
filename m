Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08B595B19F8
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 12:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbiIHK34 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 06:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbiIHK3z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 06:29:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 021144E857
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 03:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662632993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aGJyUcumRyL68D4wXJ59Cgk5pIgcqtVYT24TVj/aRJU=;
        b=W6MbleMSbQvZOXCSDkcVhZwnXO0gdve4cP3T2BWWPmZBpkhF+tKR4PgAjStETbg8B8Glpx
        xRYUTlXyeVM6hR3ldM60c0pTwIrVkUc4l8wLkR5qrf0wwMnNq+9QfLMyeDKZ1/vNW2zQts
        GTMIqUwHQuRUm4/OCx0Ew3fGnkN2/Vg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-164-vdxa0sMiOrGMtnDRxoLxTA-1; Thu, 08 Sep 2022 06:29:48 -0400
X-MC-Unique: vdxa0sMiOrGMtnDRxoLxTA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8461B1C04B48;
        Thu,  8 Sep 2022 10:29:47 +0000 (UTC)
Received: from localhost (unknown [10.39.194.28])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2941140CF8F0;
        Thu,  8 Sep 2022 10:29:47 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3] vfio/fsl-mc: Fix a typo in a message
In-Reply-To: <a7c1394346725b7435792628c8d4c06a0a745e0b.1662134821.git.christophe.jaillet@wanadoo.fr>
Organization: Red Hat GmbH
References: <a7c1394346725b7435792628c8d4c06a0a745e0b.1662134821.git.christophe.jaillet@wanadoo.fr>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Thu, 08 Sep 2022 12:29:44 +0200
Message-ID: <87pmg6rwfb.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 02 2022, Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:

> L and S are swapped in the message.
> s/VFIO_FLS_MC/VFIO_FSL_MC/
>
> Also use 'ret' instead of 'WARN_ON(ret)' to avoid a duplicated message.
>
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> Changes in v3:
>   * Remove WARN_ON() and WARN() and only keep dev_warn()   [Diana Madalina Craciun <diana.craciun@oss.nxp.com>]
>
> Changes in v2:
>   * s/comment/message/ in the subject   [Cornelia Huck <cohuck@redhat.com>]
>   * use WARN instead of WARN_ON+dev_warn   [Jason Gunthorpe <jgg@ziepe.ca>]
>   https://lore.kernel.org/all/3d2aa8434393ee8d2aa23a620e59ce1059c9d7ad.1660663440.git.christophe.jaillet@wanadoo.fr/
>
> v1:
>   https://lore.kernel.org/all/2b65bf8d2b4d940cafbafcede07c23c35f042f5a.1659815764.git.christophe.jaillet@wanadoo
> ---
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Acked-by: Cornelia Huck <cohuck@redhat.com>

