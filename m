Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33E595EB94E
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 06:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiI0EjH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 00:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiI0EjE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 00:39:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A009B02A7
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 21:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664253543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UUYySdokudzYAu/PwShHz0v/wpwcIfbDjXPzc5w9Z/8=;
        b=GfoZp7C2dbOoqVphLjetk+U9Sz7Kbvz6T3JqrASkuSWiZOJAWBhRFvqZLem4Ks6lcqH0Vd
        DIlNHl2wM30JijUHz7JjA4XHqLtbF9xgTA4ObBqdKmE8+oPhpVX0qGsh40Wg7Eeu19llkg
        uhin8QHgxGhK4v3LDwln7uxq7xN+CL8=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-294-XD8YGXLTN4aTwuNGnosDLg-1; Tue, 27 Sep 2022 00:38:59 -0400
X-MC-Unique: XD8YGXLTN4aTwuNGnosDLg-1
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-11eadf59e50so3085354fac.8
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 21:38:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=UUYySdokudzYAu/PwShHz0v/wpwcIfbDjXPzc5w9Z/8=;
        b=AlG0B1HpBdZioyW7duXz//qOnPpLlVEqlU3ozAaID7aClyfcx8F9g3sTOcWOyfI5tB
         1xWbA2tIwa4jTVeBtG+qowDqJI4FFdOswSzvIdPqqDKjmYGPxYtwTqgp4CSTjs7PN5C8
         CfAEKuFHTigIH/rZlr8RZO+2YeDkmwtC05rDIxuqWtxvxuo9VlvALtg+cWc7QqYR+yqY
         1ft250EF8BPENvqGa/SOJFzG2WLXBjmkL4Q2n2LlNmZHGtRIr5XBekLNR1TcYfM8y6wj
         ddyM2lJuXir5oI/ybjX9YhnFlCIJBvW3ZtpBg0NttTVdLJHQdZ4IhdSMFrTivd/ywiPZ
         U6kA==
X-Gm-Message-State: ACrzQf2PduoTB2bVOqY4jbxKL0elH7zzH9fRFB0Acp98o5K3K7gqKjkV
        vWeqyvulRmgIMSksTILwexIMi1qDtgXFyPyZIlR2i3W70YjhBQPxd2ryxWfE8Kyj9uhFikvfP+I
        arNdXVFg8IWcwuRoD/aU1MzvCcljF
X-Received: by 2002:a05:6808:1b22:b0:350:c0f6:70ff with SMTP id bx34-20020a0568081b2200b00350c0f670ffmr948390oib.35.1664253538580;
        Mon, 26 Sep 2022 21:38:58 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6dtWDIDMFMsm1TLAUpFC0nEqOJfRQrv1Inh+yp5FeOdRtNy1OaIjtWjmVbiQUn0wRzZTkbR7IWTxa32X2nA7Y=
X-Received: by 2002:a05:6808:1b22:b0:350:c0f6:70ff with SMTP id
 bx34-20020a0568081b2200b00350c0f670ffmr948382oib.35.1664253538380; Mon, 26
 Sep 2022 21:38:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220927030117.5635-1-lingshan.zhu@intel.com> <20220927030117.5635-6-lingshan.zhu@intel.com>
In-Reply-To: <20220927030117.5635-6-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 27 Sep 2022 12:38:47 +0800
Message-ID: <CACGkMEtBQr9ZSdN0WUxEZ7wHb5ikpyheVAjfbiPSDRM8SqHhcQ@mail.gmail.com>
Subject: Re: [PATCH V2 RESEND 5/6] vDPA: fix spars cast warning in vdpa_dev_net_mq_config_fill
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 27, 2022 at 11:10 AM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>
> This commit fixes spars warnings: cast to restricted __le16
> in function vdpa_dev_net_mq_config_fill()
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>

Acked-by: Jason Wang <jasowang@redhat.com>

> ---
>  drivers/vdpa/vdpa.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> index 84a0c3877d7c..fa7f65279f79 100644
> --- a/drivers/vdpa/vdpa.c
> +++ b/drivers/vdpa/vdpa.c
> @@ -809,7 +809,8 @@ static int vdpa_dev_net_mq_config_fill(struct sk_buff *msg, u64 features,
>             (features & BIT_ULL(VIRTIO_NET_F_RSS)) == 0)
>                 return 0;
>
> -       val_u16 = le16_to_cpu(config->max_virtqueue_pairs);
> +       val_u16 = __virtio16_to_cpu(true, config->max_virtqueue_pairs);
> +
>         return nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, val_u16);
>  }
>
> --
> 2.31.1
>

