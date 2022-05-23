Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3344953087A
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 06:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbiEWEl0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 00:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiEWElX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 00:41:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CAC8364DB
        for <kvm@vger.kernel.org>; Sun, 22 May 2022 21:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653280881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=08y9EJtcz+7a/JcW5CAQJh1vaSn+lYtCa1y1S5/rUOM=;
        b=jGg1sllm/kVZNZMCnI+gR20IdAlNmMODGXMtJ9VyF7XAWDqfocdAHmwytYgdR6aF0R3edK
        uPvnIX789pP3h5T5l3GGeDoa7nSRcbTeD65i+Ozlmj1YIkUx3BEhdTFCTyYslD6jdMPqKP
        W4WkYhcpDvqE30jq1R+r3wABXzanE+o=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-38Af2ls4OGuHheKMy9_bPA-1; Mon, 23 May 2022 00:41:17 -0400
X-MC-Unique: 38Af2ls4OGuHheKMy9_bPA-1
Received: by mail-lf1-f70.google.com with SMTP id b2-20020a0565120b8200b00477a4532448so7092121lfv.22
        for <kvm@vger.kernel.org>; Sun, 22 May 2022 21:41:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=08y9EJtcz+7a/JcW5CAQJh1vaSn+lYtCa1y1S5/rUOM=;
        b=21MocxOfmGRlb0yMmgx6q25hclSKz192063XwgYlbsEc/AwJdpPzCNxIAF0x2ynFtQ
         lal/ffRpAwHaeoYro8ef/e5gw1/cNmYw3t+AN9UZWvjIyms3AgzceoT6rUo4E/zdqMsa
         60Jq9kjWLQOvvqiI/1DiR1RZisPqjeW9E73fdHIUq1FGVht1i9H1WSCBzfKdVzyNJPYk
         8xanlGqFkgJxCPhY/nIrVOxuov1PNwd7KIA+VIAfjT3XZQenns6STBgV5dbm78uHv7ni
         sLVnFIv7KDD6HCIoO7K4xwq++8wQDbuSYnCXP8yO4uCKmmMFfVevRohvNdXZiCx+GSp5
         Qxew==
X-Gm-Message-State: AOAM530XJ/BIRPhFMV/jBY7q8HtjUehxYX29MqHjBz/BNoR+lcqXJ2bk
        WfP+tsrR16ePYn3M3Jfs+/nrKX5u3d4XJ0kM5+T3MWg27tUMSRzgdV8A955vzvvg6lZ5lErHFO+
        h+MCKpVr3Do0WbICFX2i2gYOiKZZM
X-Received: by 2002:a05:6512:1588:b0:477:a556:4ab2 with SMTP id bp8-20020a056512158800b00477a5564ab2mr15008561lfb.376.1653280875765;
        Sun, 22 May 2022 21:41:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxqRetp33JcfidVaUk+iFKExKrB3v7QK7jBSPRLyLJwJHS8cGFd1P5dpWd3xCNGBT0hiuY9YQ5gpi2GOTwnZdI=
X-Received: by 2002:a05:6512:1588:b0:477:a556:4ab2 with SMTP id
 bp8-20020a056512158800b00477a5564ab2mr15008553lfb.376.1653280875600; Sun, 22
 May 2022 21:41:15 -0700 (PDT)
MIME-Version: 1.0
References: <89ef0ae4c26ac3cfa440c71e97e392dcb328ac1b.1653227924.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <89ef0ae4c26ac3cfa440c71e97e392dcb328ac1b.1653227924.git.christophe.jaillet@wanadoo.fr>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 23 May 2022 12:41:03 +0800
Message-ID: <CACGkMEtvgL+MxBmhWZ-Hn-QjfS-MBm7gvLoQHhazOiwrLxxUJA@mail.gmail.com>
Subject: Re: [PATCH] vhost-vdpa: Fix some error handling path in vhost_vdpa_process_iotlb_msg()
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Gautam Dawar <gautam.dawar@xilinx.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, May 22, 2022 at 9:59 PM Christophe JAILLET
<christophe.jaillet@wanadoo.fr> wrote:
>
> In the error paths introduced by the commit in the Fixes tag, a mutex may
> be left locked.
> Add the correct goto instead of a direct return.
>
> Fixes: a1468175bb17 ("vhost-vdpa: support ASID based IOTLB API")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> WARNING: This patch only fixes the goto vs return mix-up in this function.
> However, the 2nd hunk looks really spurious to me. I think that the:
> -               return -EINVAL;
> +               r = -EINVAL;
> +               goto unlock;
> should be done only in the 'if (!iotlb)' block.

It should be fine, the error happen if

1) the batched ASID based request is not equal (the first if)
2) there's no IOTLB for this ASID (the second if)

But I agree the code could be tweaked to use two different if instead
of using a or condition here.

Acked-by: Jason Wang <jasowang@redhat.com>

>
> As I don't know this code, I just leave it as-is but draw your attention
> in case this is another bug lurking.
> ---
>  drivers/vhost/vdpa.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 1f1d1c425573..3e86080041fc 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -1000,7 +1000,8 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev, u32 asid,
>                 if (!as) {
>                         dev_err(&v->dev, "can't find and alloc asid %d\n",
>                                 asid);
> -                       return -EINVAL;
> +                       r = -EINVAL;
> +                       goto unlock;
>                 }
>                 iotlb = &as->iotlb;
>         } else
> @@ -1013,7 +1014,8 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev, u32 asid,
>                 }
>                 if (!iotlb)
>                         dev_err(&v->dev, "no iotlb for asid %d\n", asid);
> -               return -EINVAL;
> +               r = -EINVAL;
> +               goto unlock;
>         }
>
>         switch (msg->type) {
> --
> 2.34.1
>

