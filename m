Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3D5C4C07B6
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 03:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236767AbiBWCTS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 21:19:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233174AbiBWCTR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 21:19:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A342D3917B
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 18:18:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645582729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8m71796WnjJoiReMnJ7ljU9ui0Y+8xJ7kZ3cxcWFtwU=;
        b=UxxgCIXg3tzS/HRx6pktJSUOuGNfhl0w48VoGovQL7ARiRyvq77t+8D6zUscZYZqFuKsLs
        zIVDiRycnP4PEQxYLBIYxvY20aZEXtCfSEqZdi6a3N07DT76Z5UDjuV+0zvmxhD7uyAOXS
        dgJbNbuTTM81LWmFjXTPdXiCMqVoc0Y=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-468-i4XGsXYCOFCTUrz2xzV4AQ-1; Tue, 22 Feb 2022 21:18:48 -0500
X-MC-Unique: i4XGsXYCOFCTUrz2xzV4AQ-1
Received: by mail-lj1-f198.google.com with SMTP id 185-20020a2e05c2000000b002463aff775aso4605252ljf.17
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 18:18:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8m71796WnjJoiReMnJ7ljU9ui0Y+8xJ7kZ3cxcWFtwU=;
        b=pdhq9I+AYqpS2kHi0Up7/ezNJIiD+dgWn9HaXB/90YGFoKWvtPVRQEV6hE5tn41CCb
         dM2YqBPoR0HzUN1HFO8VD+aeI+gnnKshozJyyQLR06XcW1fSFmHdm+kk55h0KFbzcHAH
         ex3upYV8G2KMyK6ogQWWxXctb+DxgEDKgeNl6WsUxDWUshF449hSFcnHQwMQ/ACRRNpC
         WQC+vDurk3dmGjqifdHiUqOienSxoP7dWrIqNG4urP0DbteINIQZZnjV/MBJWMkwO5un
         gmemyks1xHvyTyacC9r31lMfuZ6jHwCGuq5N5g7JJo1o3Sdf39uVQc6jyUSlHZrjEamW
         zN6A==
X-Gm-Message-State: AOAM530UqDqbnTokjvnJsmBB2NsslLOQ00Uvjv/6JWJ5qj7QltXCjKGJ
        3czVleUSZPKkBVWyYN9TaFWWon/uzbOHrq8RL0iQWkG4yi1HH6/mdzktQ2fG5KsM9rpdIU4HIy9
        64dgqre5mhVnDzLGOEfnrxWZprfrO
X-Received: by 2002:a05:6512:3341:b0:433:b033:bd22 with SMTP id y1-20020a056512334100b00433b033bd22mr18560075lfd.190.1645582726514;
        Tue, 22 Feb 2022 18:18:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyk+Ofc0anUJN/HPT2fed7XHNU7yqVKhjlHv7XCMSt3esMXU6S0MVe6i/BWgb1hDC6Q3LfOqTD2YEQE/UiKZBE=
X-Received: by 2002:a05:6512:3341:b0:433:b033:bd22 with SMTP id
 y1-20020a056512334100b00433b033bd22mr18560067lfd.190.1645582726315; Tue, 22
 Feb 2022 18:18:46 -0800 (PST)
MIME-Version: 1.0
References: <20220222154847.597414-1-hch@lst.de>
In-Reply-To: <20220222154847.597414-1-hch@lst.de>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 23 Feb 2022 10:18:35 +0800
Message-ID: <CACGkMEukgGNg-NKc_Qn+oGM1Stygk-6VTFrd1wR-h_5CK41D=w@mail.gmail.com>
Subject: Re: [PATCH] vhost: use bvec_kmap_local in {get,put}u16_iotlb
To:     Christoph Hellwig <hch@lst.de>
Cc:     kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 22, 2022 at 11:49 PM Christoph Hellwig <hch@lst.de> wrote:
>
> Using local kmaps slightly reduces the chances to stray writes, and
> the bvec interface cleans up the code a little bit.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Jason Wang <jasowang@redhat.com>

> ---
>  drivers/vhost/vringh.c | 18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> index 14e2043d76852..0f22a83fd09af 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -1173,7 +1173,7 @@ static inline int getu16_iotlb(const struct vringh *vrh,
>                                u16 *val, const __virtio16 *p)
>  {
>         struct bio_vec iov;
> -       void *kaddr, *from;
> +       void *kaddr;
>         int ret;
>
>         /* Atomic read is needed for getu16 */
> @@ -1182,10 +1182,9 @@ static inline int getu16_iotlb(const struct vringh *vrh,
>         if (ret < 0)
>                 return ret;
>
> -       kaddr = kmap_atomic(iov.bv_page);
> -       from = kaddr + iov.bv_offset;
> -       *val = vringh16_to_cpu(vrh, READ_ONCE(*(__virtio16 *)from));
> -       kunmap_atomic(kaddr);
> +       kaddr = bvec_kmap_local(&iov);
> +       *val = vringh16_to_cpu(vrh, READ_ONCE(*(__virtio16 *)kaddr));
> +       kunmap_local(kaddr);
>
>         return 0;
>  }
> @@ -1194,7 +1193,7 @@ static inline int putu16_iotlb(const struct vringh *vrh,
>                                __virtio16 *p, u16 val)
>  {
>         struct bio_vec iov;
> -       void *kaddr, *to;
> +       void *kaddr;
>         int ret;
>
>         /* Atomic write is needed for putu16 */
> @@ -1203,10 +1202,9 @@ static inline int putu16_iotlb(const struct vringh *vrh,
>         if (ret < 0)
>                 return ret;
>
> -       kaddr = kmap_atomic(iov.bv_page);
> -       to = kaddr + iov.bv_offset;
> -       WRITE_ONCE(*(__virtio16 *)to, cpu_to_vringh16(vrh, val));
> -       kunmap_atomic(kaddr);
> +       kaddr = bvec_kmap_local(&iov);
> +       WRITE_ONCE(*(__virtio16 *)kaddr, cpu_to_vringh16(vrh, val));
> +       kunmap_local(kaddr);
>
>         return 0;
>  }
> --
> 2.30.2
>

