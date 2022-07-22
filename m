Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6019057DAC4
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 09:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234364AbiGVHN2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 03:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbiGVHN1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 03:13:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D48858E6D9
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 00:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658474005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Wsed93BuNRJkapkugRn/nwfX0SXje/qBsJN6NO73XG0=;
        b=X/ImYPqPy/txfCCPHa6W4jadNo+S1NuOHVTtFaPYXw810zBQr96xj+poRQEgqVnclkvxhG
        smH/UvFDbpAUMbYTVM6IhUckgpzHYvdc5M7WENDLovd4105AZTWkLnZjppdp3y13gJJ3dq
        UZWCsrxU9QW8yGiEBhnJ1JQDTDVYIwk=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-Euz-AMPtPAOsfAnjjU8A2g-1; Fri, 22 Jul 2022 03:13:24 -0400
X-MC-Unique: Euz-AMPtPAOsfAnjjU8A2g-1
Received: by mail-qv1-f72.google.com with SMTP id u14-20020a0ced2e000000b004741065d449so2279158qvq.11
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 00:13:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wsed93BuNRJkapkugRn/nwfX0SXje/qBsJN6NO73XG0=;
        b=WxscaRVB7BL2/QVsjZNe2RqZyn+kmIqJ5PxOPuu0myVvRa2V8p12S47ewe1NInFajq
         uSS8HJ1Y2ySAGe3fCaDNla81rmj7jg4ajcIzZI0AfuXl/aXtREg55xvYhdtJyFbX7eJ5
         TKwkeZya51IxmbBDuBgF6uPB7GUDFsp/h+77QUMYiaDJbFFOY3Pi9msVo1d08JC4a22k
         tnUbm8odQh7o1YJhs5ysCMHlXxs1oGr0OTI5dkoPLQAyMzknlPGMcBfBPgRLBRX7+vlp
         7dZ3EVAhUdnem8P0aQn1jl3Y+bYpM0/Wu3Be1K2xZs0j6gYykQUDCuz/eqrDpaSo6EpR
         jFgw==
X-Gm-Message-State: AJIora+aSIn/FG3rBKZbMjEEsGuU+N5I24qSWfQ3P/Ps7TTsN6sgtssF
        NmjlBInqpEqDA/hLcfAsNLvzH8rtYya5oe+kjzw4GkXPpTgHS7YGACsfSX/f2pFD9UUpKAg62K5
        fO6da9egRySAsCyKmh9NJXzm+/3CO
X-Received: by 2002:a0c:be91:0:b0:474:1d6:b1a4 with SMTP id n17-20020a0cbe91000000b0047401d6b1a4mr1734954qvi.108.1658474003804;
        Fri, 22 Jul 2022 00:13:23 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tEcyOOrz8ulXALLU3lOqBWBPAhsUJqLPMU34S78oArx1JQGAQejfV6MMkgWmFYInqi0IgRkgNkqkYPfZYae8I=
X-Received: by 2002:a0c:be91:0:b0:474:1d6:b1a4 with SMTP id
 n17-20020a0cbe91000000b0047401d6b1a4mr1734938qvi.108.1658474003579; Fri, 22
 Jul 2022 00:13:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220721084341.24183-1-qtxuning1999@sjtu.edu.cn> <20220721084341.24183-4-qtxuning1999@sjtu.edu.cn>
In-Reply-To: <20220721084341.24183-4-qtxuning1999@sjtu.edu.cn>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Fri, 22 Jul 2022 09:12:47 +0200
Message-ID: <CAJaqyWfgUqdP6mkOUdouvQSst=qc7MOTaigC-EiTg9-gojHqzg@mail.gmail.com>
Subject: Re: [RFC 3/5] vhost_test: batch used buffer
To:     Guo Zhi <qtxuning1999@sjtu.edu.cn>
Cc:     Jason Wang <jasowang@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Michael Tsirkin <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 21, 2022 at 10:44 AM Guo Zhi <qtxuning1999@sjtu.edu.cn> wrote:
>
> Only add to used ring when a batch a buffer have all been used.  And if
> in order feature negotiated, add randomness to the used buffer's order,
> test the ability of vhost to reorder batched buffer.
>
> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
> ---
>  drivers/vhost/test.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
> index bc8e7fb1e..1c9c40c11 100644
> --- a/drivers/vhost/test.c
> +++ b/drivers/vhost/test.c
> @@ -43,6 +43,9 @@ struct vhost_test {
>  static void handle_vq(struct vhost_test *n)
>  {
>         struct vhost_virtqueue *vq = &n->vqs[VHOST_TEST_VQ];
> +       struct vring_used_elem *heads = kmalloc(sizeof(*heads)
> +                       * vq->num, GFP_KERNEL);
> +       int batch_idx = 0;
>         unsigned out, in;
>         int head;
>         size_t len, total_len = 0;
> @@ -84,11 +87,21 @@ static void handle_vq(struct vhost_test *n)
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
> +       if (batch_idx) {
> +               if (vhost_has_feature(vq, VIRTIO_F_IN_ORDER) && batch_idx >= 2) {

Maybe to add a module parameter to test this? Instead of trusting in
feature negotiation, "unorder_used=1" or something like that.

vhost.c:vhost_add_used_and_signal_n should support receiving buffers
in order or out of order whether F_IN_ORDER is negotiated or not.

Thanks!

> +                       vhost_add_used_and_signal_n(&n->dev, vq, &heads[batch_idx / 2],
> +                                                   batch_idx - batch_idx / 2);
> +                       vhost_add_used_and_signal_n(&n->dev, vq, heads, batch_idx / 2);
> +               } else {
> +                       vhost_add_used_and_signal_n(&n->dev, vq, heads, batch_idx);
> +               }
> +       }
>
>         mutex_unlock(&vq->mutex);
>  }
> --
> 2.17.1
>

