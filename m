Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3809E597E7D
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 08:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243602AbiHRGUM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 02:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbiHRGUK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 02:20:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A403B8604C
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 23:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660803608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I44EBZKhY4t31AeWAM7IA5CQq5Sz2dNzjhIF4liI9pA=;
        b=GX2E3JYs45cBMEjdmfQy8Si57l2HE4t2qrUCpM+iXr+zvYo4Gt1jA9Xqo5zHbsoEyaPolh
        zSlWnBtiAkSTtlzOYySkOx2wq0IR9ZGPbyBcONnSDPVLpAewZB85KwmRluDBASFMUBz+NX
        +jyqC/z4AfNMEoZwXqMLwXzWERJ4sks=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-258-ImegNcd3Mseu-ZipD3kPFQ-1; Thu, 18 Aug 2022 02:20:07 -0400
X-MC-Unique: ImegNcd3Mseu-ZipD3kPFQ-1
Received: by mail-qk1-f200.google.com with SMTP id q20-20020a05620a0d9400b006b6540e8d79so606116qkl.14
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 23:20:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=I44EBZKhY4t31AeWAM7IA5CQq5Sz2dNzjhIF4liI9pA=;
        b=suD5z5DKY61ufmXcXM1ALBIAgjAGPTE1sfrzr+D6JI0zEpVAfJKDzgrfpeeDrDYQTm
         S+FUDjoJJeLuH6wKWdxX5ma9nzUWbymt1A+q0p9aAolbuPExlKY5BAND1pBoTUXPEPkG
         I0rtg8U5PuQYDIyqQp7Ea0tSmkhSJBLgWzlR8nPr2SVrwB4v/sq5qvM22VQpyqGwuTiR
         QheQGTR74iGmv3YavSdW5IPDTVo6EQcL7KT77jAxBO02MqtVpVdxoSCChwm7oL83IIET
         NjB6JHxz9emHhBSoYpCJVlJsoGAdpvpYymA4hF6CVmUOUJMBBN1+aB64BERt4YQRRdQ0
         ZWEA==
X-Gm-Message-State: ACgBeo0pguKeXZ+F3EPBrD4DzRHjTFQbvRTmmgi3LKWI1I1zqdCS0pin
        oX88KC0VZHOkLmiWkO9PXW8ZMQuBkVqYYEA3J5xp2V/dUNA0foPoSsV3MOy/dPGV6MX+TKn7RSs
        Qd73L6dhCOrge05FIK8WhyNTBkdWy
X-Received: by 2002:a05:6214:509e:b0:496:a98a:fd5 with SMTP id kk30-20020a056214509e00b00496a98a0fd5mr1240447qvb.2.1660803606482;
        Wed, 17 Aug 2022 23:20:06 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7XrFPF+FXrhAulcnDsApNT/29F2unpZhGwbXxLef6/vHafmNtjvY5lhCtM+F8PnEGelPXnToL8/5b60fvb7HE=
X-Received: by 2002:a05:6214:509e:b0:496:a98a:fd5 with SMTP id
 kk30-20020a056214509e00b00496a98a0fd5mr1240439qvb.2.1660803606279; Wed, 17
 Aug 2022 23:20:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220817135718.2553-1-qtxuning1999@sjtu.edu.cn> <20220817135718.2553-4-qtxuning1999@sjtu.edu.cn>
In-Reply-To: <20220817135718.2553-4-qtxuning1999@sjtu.edu.cn>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 18 Aug 2022 08:19:29 +0200
Message-ID: <CAJaqyWeCYHvKShyQu0JEfLi=N+TLXdHQtt-VJR-4eVyU0MzT+w@mail.gmail.com>
Subject: Re: [RFC v2 3/7] vsock: batch buffers in tx
To:     Guo Zhi <qtxuning1999@sjtu.edu.cn>
Cc:     Jason Wang <jasowang@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Michael Tsirkin <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 17, 2022 at 3:58 PM Guo Zhi <qtxuning1999@sjtu.edu.cn> wrote:
>
> Vsock uses buffers in order, and for tx driver doesn't have to
> know the length of the buffer. So we can do a batch for vsock if
> in order negotiated, only write one used ring for a batch of buffers
>
> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
> ---
>  drivers/vhost/vsock.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index 368330417bde..b0108009c39a 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -500,6 +500,7 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
>         int head, pkts = 0, total_len = 0;
>         unsigned int out, in;
>         bool added = false;
> +       int last_head = -1;
>
>         mutex_lock(&vq->mutex);
>
> @@ -551,10 +552,16 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
>                 else
>                         virtio_transport_free_pkt(pkt);
>
> -               vhost_add_used(vq, head, 0);
> +               if (!vhost_has_feature(vq, VIRTIO_F_IN_ORDER))
> +                       vhost_add_used(vq, head, 0);
> +               else
> +                       last_head = head;
>                 added = true;
>         } while(likely(!vhost_exceeds_weight(vq, ++pkts, total_len)));
>
> +       /* If in order feature negotiaged, we can do a batch to increase performance */
> +       if (vhost_has_feature(vq, VIRTIO_F_IN_ORDER) && last_head != -1)
> +               vhost_add_used(vq, last_head, 0);

Expanding my previous mail on patch 1, you can also use this in vsock
tx queue code. This way, no modifications to vhost.c functions are
needed.

Thanks!

>  no_more_replies:
>         if (added)
>                 vhost_signal(&vsock->dev, vq);
> --
> 2.17.1
>

