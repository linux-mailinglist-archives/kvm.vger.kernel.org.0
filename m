Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB08858C5F3
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 11:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242344AbiHHJ5N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 05:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234041AbiHHJ5M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 05:57:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F35BBBF76
        for <kvm@vger.kernel.org>; Mon,  8 Aug 2022 02:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659952631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LqzDiaZZFKLrzeK14Ad4zWfelyZIgkCg5mXEYloBVAQ=;
        b=WvPegFyQqs3n5UH9w5L3onCFHfBe9FcYHLzlz359+H5UqNwKRPGDuEBETRfDcpZYvCg7iA
        rSOOVtQzWErrxeLtRZVpNSmV1cz0L4Dr0aimvWFxboXLqL/cvqgcX41BBJicufNePeyCwd
        xQiVSn+9Q6tOOum1y4RjRs+w88Z2Y0E=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-313-1005c4v5Ndq1-yiUucDn0Q-1; Mon, 08 Aug 2022 05:57:07 -0400
X-MC-Unique: 1005c4v5Ndq1-yiUucDn0Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 69BC93815D26;
        Mon,  8 Aug 2022 09:57:07 +0000 (UTC)
Received: from localhost (unknown [10.39.193.46])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 22DA7C15BA1;
        Mon,  8 Aug 2022 09:57:06 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        kvm@vger.kernel.org
Subject: Re: [PATCH] vfio/fsl-mc: Fix a typo in a comment
In-Reply-To: <2b65bf8d2b4d940cafbafcede07c23c35f042f5a.1659815764.git.christophe.jaillet@wanadoo.fr>
Organization: Red Hat GmbH
References: <2b65bf8d2b4d940cafbafcede07c23c35f042f5a.1659815764.git.christophe.jaillet@wanadoo.fr>
User-Agent: Notmuch/0.36 (https://notmuchmail.org)
Date:   Mon, 08 Aug 2022 11:57:05 +0200
Message-ID: <87h72ndpn2.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Aug 06 2022, Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:

$SUBJECT: s/comment/message/

> L and S are swapped/
> s/VFIO_FLS_MC/VFIO_FSL_MC/
>
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> All the dev_ logging functions in the file have the "VFIO_FSL_MC: "
> prefix.
> As they are dev_ function, the driver should already be displayed.
>
> So, does it make sense or could they be all removed?

From a quick glance, there seem to be messages for when the device is
_not_ bound to the fsl-mc driver (e.g. in vfio_fsl_mc_bus_notifier());
I'd just fix the typo for now.

> ---
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Cornelia Huck <cohuck@redhat.com>

