Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 557FF4BEFB0
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 03:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239281AbiBVCvC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 21:51:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232960AbiBVCvA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 21:51:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 12A9D25C77
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 18:50:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645498235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sMERnC5Lx3ZdDjMyWgRECzQ+geOBGfR8Zn1RSSoIhoE=;
        b=asXGZ6ltdQl6llfZZyqUulCI4PWgQqsTQMgAi5t+TQp92F4T33sVVfBpZYzDHcI1XoDa80
        Kq70/xzehSU+MTcOKPB7OqJXqUd5k44mM4Il+VZtQrfrwyt6BnfOK8Qqk3unrygded++Rs
        /sjuZB7cNHfuaJBxGWSnt0vhMs/45Ws=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-17fD4GECPq6K3OOXcON0fw-1; Mon, 21 Feb 2022 21:50:33 -0500
X-MC-Unique: 17fD4GECPq6K3OOXcON0fw-1
Received: by mail-lj1-f198.google.com with SMTP id b27-20020a2ebc1b000000b00246209c497dso4991220ljf.11
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 18:50:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sMERnC5Lx3ZdDjMyWgRECzQ+geOBGfR8Zn1RSSoIhoE=;
        b=H3NTuLftG49gi/wC44Q60PVUiy6bg+YJMbfEEwdP5WES0Igmj4fBhg6XWEvAn3VSg6
         EviZX7KfGpIdWIWuutO25pQFzP+nyzH3lbbd1e90XJRPsdrEYuWduFz1r23mwUlxW713
         IaG2vCaJwTfiqBpAjA1yjFWAy5fBPl9SVrFtSuWNabl4xb0Zkm9khaMxzoYNp6O1A/Fl
         T/BqLD+amVhaUPlv7aejkyWZjneB7vM5SF7nephlBV1ltOh1V2vZm8aEEjxhInLbUFRP
         l33KUm6CJetesF58b4z36OCta1Yy/0nP8Z3ElatEu64kK9DLENWFkDf4QfeDT6ikAkmM
         DJfg==
X-Gm-Message-State: AOAM533R6PkBH7hUGsEmDfVihB4QROZK6vxE2cWSgi8BwWbpDnYnaFZW
        Gx/PebXGFGRi7Lx8VziO1ApUv3zDbjnmD7ky59aoNB19Bh1ispmtbAy6Ot05eyWaZKixsnVaGRI
        OD3zE5jJnGq3yfUoWhusNy/2Ksw44
X-Received: by 2002:ac2:5dc9:0:b0:443:5db1:244c with SMTP id x9-20020ac25dc9000000b004435db1244cmr16189696lfq.84.1645498232049;
        Mon, 21 Feb 2022 18:50:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyCDJBSK5aeabUkY9YzJtmGlAXsaWKwi+31r65bcAa3YUsXyGltr5v5jpXObhmF/f1wYMJQ7FAIEVVK/vj/AiU=
X-Received: by 2002:ac2:5dc9:0:b0:443:5db1:244c with SMTP id
 x9-20020ac25dc9000000b004435db1244cmr16189687lfq.84.1645498231872; Mon, 21
 Feb 2022 18:50:31 -0800 (PST)
MIME-Version: 1.0
References: <20220221195303.13560-1-mail@anirudhrb.com>
In-Reply-To: <20220221195303.13560-1-mail@anirudhrb.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 22 Feb 2022 10:50:20 +0800
Message-ID: <CACGkMEvLE=kV4PxJLRjdSyKArU+MRx6b_mbLGZHSUgoAAZ+-Fg@mail.gmail.com>
Subject: Re: [PATCH] vhost: validate range size before adding to iotlb
To:     Anirudh Rayabharam <mail@anirudhrb.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com,
        kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
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

On Tue, Feb 22, 2022 at 3:53 AM Anirudh Rayabharam <mail@anirudhrb.com> wrote:
>
> In vhost_iotlb_add_range_ctx(), validate the range size is non-zero
> before proceeding with adding it to the iotlb.
>
> Range size can overflow to 0 when start is 0 and last is (2^64 - 1).
> One instance where it can happen is when userspace sends an IOTLB
> message with iova=size=uaddr=0 (vhost_process_iotlb_msg). So, an
> entry with size = 0, start = 0, last = (2^64 - 1) ends up in the
> iotlb. Next time a packet is sent, iotlb_access_ok() loops
> indefinitely due to that erroneous entry:
>
>         Call Trace:
>          <TASK>
>          iotlb_access_ok+0x21b/0x3e0 drivers/vhost/vhost.c:1340
>          vq_meta_prefetch+0xbc/0x280 drivers/vhost/vhost.c:1366
>          vhost_transport_do_send_pkt+0xe0/0xfd0 drivers/vhost/vsock.c:104
>          vhost_worker+0x23d/0x3d0 drivers/vhost/vhost.c:372
>          kthread+0x2e9/0x3a0 kernel/kthread.c:377
>          ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
>          </TASK>
>
> Reported by syzbot at:
>         https://syzkaller.appspot.com/bug?extid=0abd373e2e50d704db87
>
> Reported-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
> Tested-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
> Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
> ---
>  drivers/vhost/iotlb.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vhost/iotlb.c b/drivers/vhost/iotlb.c
> index 670d56c879e5..b9de74bd2f9c 100644
> --- a/drivers/vhost/iotlb.c
> +++ b/drivers/vhost/iotlb.c
> @@ -53,8 +53,10 @@ int vhost_iotlb_add_range_ctx(struct vhost_iotlb *iotlb,
>                               void *opaque)
>  {
>         struct vhost_iotlb_map *map;
> +       u64 size = last - start + 1;
>
> -       if (last < start)
> +       // size can overflow to 0 when start is 0 and last is (2^64 - 1).
> +       if (last < start || size == 0)
>                 return -EFAULT;

I'd move this check to vhost_chr_iter_write(), then for the device who
has its own msg handler (e.g vDPA) can benefit from it as well.

Thanks

>
>         if (iotlb->limit &&
> @@ -69,7 +71,7 @@ int vhost_iotlb_add_range_ctx(struct vhost_iotlb *iotlb,
>                 return -ENOMEM;
>
>         map->start = start;
> -       map->size = last - start + 1;
> +       map->size = size;
>         map->last = last;
>         map->addr = addr;
>         map->perm = perm;
> --
> 2.35.1
>

