Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD3CB597E79
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 08:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243585AbiHRGSr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 02:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243566AbiHRGSp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 02:18:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E746CF40
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 23:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660803522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0NAawQ9XBYnysJg3OwdeE4npc8jcs/ow05KJCd8jCZk=;
        b=ChXahIuWBS55Q8cgJRjSO9na8fDH/N2VVZPxJ0XcfWV4bQS9Hx14g4U+wnQokW0crS7VF8
        zTq8Ank0jNS3PDUYasR0PbFCn5xZf62Pfy9Iyp1tv+f7vkliZBwS/KncFsPmahv2AfqtKZ
        0xjsDaXarjj0YKGR7ixLNqtqu1/ovKY=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-413-_NBedBFCOAK3zqfFBwmNxg-1; Thu, 18 Aug 2022 02:18:38 -0400
X-MC-Unique: _NBedBFCOAK3zqfFBwmNxg-1
Received: by mail-qv1-f72.google.com with SMTP id o6-20020ad443c6000000b00495d04028a6so456704qvs.18
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 23:18:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=0NAawQ9XBYnysJg3OwdeE4npc8jcs/ow05KJCd8jCZk=;
        b=Rwx7pwjRrJaNlMYlQueeH0s55cCTJ4OeMyLXveQ3UnTPO9sT5mts20NbnMKZ6N5XIH
         oexfzBKVJeXRAZ1eVGXadcKrN6FxKFR81pMxz9bA+9Ax8ZFtT39klBnLpL7MY3vFRSaV
         M+kRjLrHn5TNcNFtccHzCa4okzwT/7hmTtStCxllKYrBdNOf+p53/LNxUMCU7qabl9sO
         RM3SOySYhy+QpPjj+li9DN63x3l46HR7w1Lj8ClmIjki79v7lauY9nfAzJzXYMjavu8r
         xpVPswZ4n62v6iUYcUpkPHIqrjpx6heemFbBjI8FMWDIKDlTNK97O1cTs/jZUM+JPb2V
         86GA==
X-Gm-Message-State: ACgBeo1bsuHOW4eBX+e11gDriIoTBAk27xsvJliIJeBwy4OoAJUOnoLU
        1+jteVTt4Rl5eCl27vc2S38HL6/nlEyhA3GuvU/EjQ869l5yxWJv5oMAWIVIWcFE34Jtwe58IFJ
        EE/uyPM6J5RBPulWR3Cn3pmedwyhL
X-Received: by 2002:ad4:5bc7:0:b0:48b:e9ed:47a8 with SMTP id t7-20020ad45bc7000000b0048be9ed47a8mr1226318qvt.108.1660803517640;
        Wed, 17 Aug 2022 23:18:37 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7i9tzI1gIYnxOQajZ5xPDocGxVzPwJg4mYMy5d4vyh7LD7T4c/zanv9nEMIkZnzlA6roXFACDL2aVIZunCvdQ=
X-Received: by 2002:ad4:5bc7:0:b0:48b:e9ed:47a8 with SMTP id
 t7-20020ad45bc7000000b0048be9ed47a8mr1226308qvt.108.1660803517434; Wed, 17
 Aug 2022 23:18:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220817135718.2553-1-qtxuning1999@sjtu.edu.cn> <20220817135718.2553-3-qtxuning1999@sjtu.edu.cn>
In-Reply-To: <20220817135718.2553-3-qtxuning1999@sjtu.edu.cn>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 18 Aug 2022 08:18:01 +0200
Message-ID: <CAJaqyWdTjREaPLHLfo8ZyHoA3u5PpdX_=5-iTZOfa9fGpLMnfw@mail.gmail.com>
Subject: Re: [RFC v2 2/7] vhost_test: batch used buffer
To:     Guo Zhi <qtxuning1999@sjtu.edu.cn>
Cc:     Jason Wang <jasowang@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Michael Tsirkin <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 17, 2022 at 3:58 PM Guo Zhi <qtxuning1999@sjtu.edu.cn> wrote:
>
> Only add to used ring when a batch of buffer have all been used.  And if
> in order feature negotiated, only add the last used descriptor for a
> batch of buffer.
>
> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
> ---
>  drivers/vhost/test.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
> index bc8e7fb1e635..57cdb3a3edf6 100644
> --- a/drivers/vhost/test.c
> +++ b/drivers/vhost/test.c
> @@ -43,6 +43,9 @@ struct vhost_test {
>  static void handle_vq(struct vhost_test *n)
>  {
>         struct vhost_virtqueue *vq = &n->vqs[VHOST_TEST_VQ];
> +       struct vring_used_elem *heads = kmalloc(sizeof(*heads)
> +                       * vq->num, GFP_KERNEL);

It seems to me we can use kmalloc_array here.

Thanks!

> +       int batch_idx = 0;
>         unsigned out, in;
>         int head;
>         size_t len, total_len = 0;
> @@ -84,11 +87,14 @@ static void handle_vq(struct vhost_test *n)
>                         vq_err(vq, "Unexpected 0 len for TX\n");
>                         break;
>                 }
> -               vhost_add_used_and_signal(&n->dev, vq, head, 0);
> +               heads[batch_idx].id = cpu_to_vhost32(vq, head);
> +               heads[batch_idx++].len = cpu_to_vhost32(vq, len);
>                 total_len += len;
>                 if (unlikely(vhost_exceeds_weight(vq, 0, total_len)))
>                         break;
>         }
> +       if (batch_idx)
> +               vhost_add_used_and_signal_n(&n->dev, vq, heads, batch_idx);
>
>         mutex_unlock(&vq->mutex);
>  }
> --
> 2.17.1
>

