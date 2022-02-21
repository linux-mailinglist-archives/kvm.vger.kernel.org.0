Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91BAB4BD7B0
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 09:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346616AbiBUH5X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 02:57:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346617AbiBUH5V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 02:57:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4B79563B2
        for <kvm@vger.kernel.org>; Sun, 20 Feb 2022 23:56:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645430204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iBw4eca/2ri514KH6J7gRLjfIuFxkyB+uZbTAnGGOyY=;
        b=TkYnFPO4IkSEcrI69mwUK7HsGjVLHdFoJzzzHS3eIrkcdNilb+AiAmtTJk2a0GR6S4JY6M
        olb0XwVo4pBGTfFxF+hMOZbMunq2GOyU5mHI7fYmp/w684U7J3wImm1HuMv3FtXEL+Gqxv
        bvkD9czQLdK9gxHBFP9upFARhJx0MZU=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-10-Jp7ptWBENUy7_h8kigYzNw-1; Mon, 21 Feb 2022 02:56:43 -0500
X-MC-Unique: Jp7ptWBENUy7_h8kigYzNw-1
Received: by mail-lj1-f198.google.com with SMTP id k33-20020a05651c062100b002460b0e948dso3681850lje.13
        for <kvm@vger.kernel.org>; Sun, 20 Feb 2022 23:56:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iBw4eca/2ri514KH6J7gRLjfIuFxkyB+uZbTAnGGOyY=;
        b=ReCWpec82N6lJozohK0dKX+Ooi8OfsU5HsQV4B3zGeAc47EtFkmUNChUKr7rdzbcDm
         5H4tVL4EzUuvjfeVtsc2pOjg8yXKqAPhSLi7J2SpPefpe8gPxQLt+hvj5MiFF/1YUlqH
         McHdEsu4vgZhXmxFOjYaVKh1TQFx7nA3fY6AQ9dNgiGSxReZx+CIi45oUp5F8v8Hmso1
         BrkWZrM8AL1/Ozd9SmmNaQn5KTbrcCTDfgybsgaKCEtiHY8HxzF7rqIwtZgpZAEFsajN
         74oh7bmH1OWNc+SqYLL54oTGMRMLMXA/nHLXTHUT7d8KhQ2f1PO0BEdfD3V+so8yKE6U
         Tlhg==
X-Gm-Message-State: AOAM531BOswDFmWsolhOzZOxA+FdyqQIQ1wKTrqsCJ0I+pvwMYmd+2a9
        lFxQ0L38sM7E111coi8ukuKs0uVg2DrOUEjMm3J9PJ4AkJ5CL+8+mRdVUgXFkDPKbaRiEBa85Om
        eS38EZ1mmM9h5lZkH0inAv77wlrON
X-Received: by 2002:a2e:bd03:0:b0:244:d446:27dc with SMTP id n3-20020a2ebd03000000b00244d44627dcmr13556133ljq.307.1645430201660;
        Sun, 20 Feb 2022 23:56:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxfI65mgIz4pkVVi5lbHZtWOT6Zpk1e/JWrK+zV9T5uVl8cjvGGwGWi+coH2R6hx6x7Zhb4LSm68t8Y7Edr3rE=
X-Received: by 2002:a2e:bd03:0:b0:244:d446:27dc with SMTP id
 n3-20020a2ebd03000000b00244d44627dcmr13556119ljq.307.1645430201411; Sun, 20
 Feb 2022 23:56:41 -0800 (PST)
MIME-Version: 1.0
References: <20220221072852.31820-1-mail@anirudhrb.com>
In-Reply-To: <20220221072852.31820-1-mail@anirudhrb.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 21 Feb 2022 15:56:29 +0800
Message-ID: <CACGkMEs6HLM3ok29rm4u=Tq2preno_60Z6cvKw2T7=nak2yzkQ@mail.gmail.com>
Subject: Re: [PATCH] vhost: handle zero regions in vhost_set_memory
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

On Mon, Feb 21, 2022 at 3:45 PM Anirudh Rayabharam <mail@anirudhrb.com> wrote:
>
> Return early when userspace sends zero regions in the VHOST_SET_MEM_TABLE
> ioctl.
>
> Otherwise, this causes an erroneous entry to be added to the iotlb. This
> entry has a range size of 0 (due to u64 overflow). This then causes
> iotlb_access_ok() to loop indefinitely resulting in a hung thread.
> Syzbot has reported this here:

Interesting, I think iotlb_access_ok() won't be called for memory
table entries, or anything I missed?

(If this is not true, we need a kernel patch as well).

Thanks

>
> https://syzkaller.appspot.com/bug?extid=0abd373e2e50d704db87
>
> Reported-and-tested-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
> Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
> ---
>  drivers/vhost/vhost.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 59edb5a1ffe2..821aba60eac2 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -1428,6 +1428,8 @@ static long vhost_set_memory(struct vhost_dev *d, struct vhost_memory __user *m)
>                 return -EFAULT;
>         if (mem.padding)
>                 return -EOPNOTSUPP;
> +       if (mem.nregions == 0)
> +               return 0;
>         if (mem.nregions > max_mem_regions)
>                 return -E2BIG;
>         newmem = kvzalloc(struct_size(newmem, regions, mem.nregions),
> --
> 2.35.1
>

