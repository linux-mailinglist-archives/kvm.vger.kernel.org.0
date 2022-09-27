Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2B25EB946
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 06:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbiI0EiU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 00:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiI0EiT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 00:38:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC56ACA2A
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 21:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664253497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YvoMQQlEryHzODM1sEcbq2UTTJwK38dUW+JesBnUtoI=;
        b=T2kq8cnGJCfK7RyuE4xfAG50U9HtpGtT9pN2o/22kNSWQPO7ByPDkQ6KDaZjJG79UVr0Rc
        CARn5V60f3y+DV5T/zx1cxYZDycaXbzeIdT8CpEts0K/3EsMak7QY0NvCxPk1BjgzJeEY6
        Iz8IXOL8i2HWH9no/xMBiJF9Sq0mPtI=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-115-ILz223RPMQ2GCZ9-PD0oHg-1; Tue, 27 Sep 2022 00:38:16 -0400
X-MC-Unique: ILz223RPMQ2GCZ9-PD0oHg-1
Received: by mail-ot1-f72.google.com with SMTP id a5-20020a9d2605000000b006554fc97188so4197442otb.16
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 21:38:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=YvoMQQlEryHzODM1sEcbq2UTTJwK38dUW+JesBnUtoI=;
        b=QnIx5FKnr7JNNzxZb1ef7pMkMOBevChcNjFVq8/Of9W3XVcE0f6OB+OHLOYKiZ9mF5
         dJIbV8dCrRmhdsmL5rviczLlcW4kSjHWkQmctiD5YCgUmk2VrS/PldVP7nfKj6E/bbz/
         b9XpM4IHm7nG6PTiQ8OItUauig10kxxwzhdXdUUIzenLJSdKtxaFFzq21lixArsgCjmf
         JWWmpVrTpsPb20fr9qnQO+kiNil0VAmzfz75uSxzGOLYxhqDdmixUMIBCJhTo/aVLvbr
         rk59e5LaN/fpyiFOw/KQrNdYUROEDIGSkAKNW5Z5/+mFioN19GB1U0HxzdonX23FOFkL
         Zctg==
X-Gm-Message-State: ACrzQf2JnKtxTH7BOv/UObIlYzCio2cvLtXvK9S91j24IOXSz8ihaxTy
        1cIhgEE+9X69+WL2mc3WAyvbtkGELK7q3OTbFI2Wq0v9Zht8S2cEmOlO++bTDIRMiOBNWqOaHNV
        tO1Tma0MVT7hc0oFY3H9VvyaWP1c2
X-Received: by 2002:a05:6808:1b22:b0:350:c0f6:70ff with SMTP id bx34-20020a0568081b2200b00350c0f670ffmr947696oib.35.1664253494788;
        Mon, 26 Sep 2022 21:38:14 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5Y2cfb+vwgFJjFYaenS5cjGkB+F68aaugASVk8P/h+ix7i0pb9U9SgX0ojSutoniNgQV3lWGR/xhFLwDhdg2E=
X-Received: by 2002:a05:6808:1b22:b0:350:c0f6:70ff with SMTP id
 bx34-20020a0568081b2200b00350c0f670ffmr947690oib.35.1664253494632; Mon, 26
 Sep 2022 21:38:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220927030117.5635-1-lingshan.zhu@intel.com> <20220927030117.5635-4-lingshan.zhu@intel.com>
In-Reply-To: <20220927030117.5635-4-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 27 Sep 2022 12:38:03 +0800
Message-ID: <CACGkMEs3C==_sJBC94enpj=4a9KxDbFKcwMsCsECbPn2QYBv4w@mail.gmail.com>
Subject: Re: [PATCH V2 RESEND 3/6] vDPA: check VIRTIO_NET_F_RSS for
 max_virtqueue_paris's presence
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 27, 2022 at 11:09 AM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>
> virtio 1.2 spec says:
> max_virtqueue_pairs only exists if VIRTIO_NET_F_MQ or
> VIRTIO_NET_F_RSS is set.
>
> So when reporint MQ to userspace, it should check both
> VIRTIO_NET_F_MQ and VIRTIO_NET_F_RSS.
>
> unused parameter struct vdpa_device *vdev is removed
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>

Acked-by: Jason Wang <jasowang@redhat.com>

> ---
>  drivers/vdpa/vdpa.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> index e7765953307f..829fd4cfc038 100644
> --- a/drivers/vdpa/vdpa.c
> +++ b/drivers/vdpa/vdpa.c
> @@ -800,13 +800,13 @@ static int vdpa_nl_cmd_dev_get_dumpit(struct sk_buff *msg, struct netlink_callba
>         return msg->len;
>  }
>
> -static int vdpa_dev_net_mq_config_fill(struct vdpa_device *vdev,
> -                                      struct sk_buff *msg, u64 features,
> +static int vdpa_dev_net_mq_config_fill(struct sk_buff *msg, u64 features,
>                                        const struct virtio_net_config *config)
>  {
>         u16 val_u16;
>
> -       if ((features & BIT_ULL(VIRTIO_NET_F_MQ)) == 0)
> +       if ((features & BIT_ULL(VIRTIO_NET_F_MQ)) == 0 &&
> +           (features & BIT_ULL(VIRTIO_NET_F_RSS)) == 0)
>                 return 0;
>
>         val_u16 = le16_to_cpu(config->max_virtqueue_pairs);
> --
> 2.31.1
>

