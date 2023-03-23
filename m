Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 158FA6C63B1
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 10:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbjCWJdx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 05:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbjCWJdZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 05:33:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B431D93C
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 02:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679563755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fH6RVdKUD2qMc5iJ7El8bayWDBifjWMzYWs3C5XGkao=;
        b=ZAKmfFKNfVMwsJwc8+GOAA/JJP8sHbDGummGxCbREMzmw4iyBo/dD8oOU8zdr82LwDqTXF
        QJq4ikwjiHVebQ4aW4SaA+AkJHC8NffVzhCrvwB5ZglD0HFVCagfuh3c+LZveKMOs64Ecr
        gb0cFi95GdreVGubqTOkhhUwv3OoL5o=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616-6UZPuN2OOrm5og-IKsm1IQ-1; Thu, 23 Mar 2023 05:29:14 -0400
X-MC-Unique: 6UZPuN2OOrm5og-IKsm1IQ-1
Received: by mail-qt1-f198.google.com with SMTP id r4-20020ac867c4000000b003bfefb6dd58so12574404qtp.2
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 02:29:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679563753;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fH6RVdKUD2qMc5iJ7El8bayWDBifjWMzYWs3C5XGkao=;
        b=c4TASdtCGswD1wUxhufd0np1DG+JsYwMKNBKes5//lRFKfviB81H5Ww7ToS/2lXFPD
         AyLTZ/Ujvxwj11y/bNpMANxkLpKmZzVxTJ8sNHGeY3kYDGeHu4i3naa7R9nm0/KZRUgW
         ES50jPYRPk2H2sYae2VKRUoO+lJvZ3LigsZAT+5tr58jaXfhcW9STsSw77/sZzOE8t3J
         Ekg4Mm3tBcJ6SMDYVq78af++59edtrXIhUMHykqnEZH55eYkwq0r+smgVhkwNPnNdySV
         YIAe+vva2tzdWlEmMEVzKvMWSUQxarz/OCShYOjqBLAfHB0OuRAQdhZ1W2ypJcxBxO9A
         oBAg==
X-Gm-Message-State: AO0yUKXh+RTLSW3GWhRWNhKxK9URjK+JWuFsuNtnealSJxdE+OPx0+G6
        xQXnbSlLvRB7Atf4XG2Xi/m79rexrnUQeIGJZpPrY8XnaU/8FXFdMDD/vJT9q8SokNhCOXUZyp+
        fFNbqpNRmCOCYHpCPfZXz
X-Received: by 2002:a05:622a:34e:b0:3e1:9557:123c with SMTP id r14-20020a05622a034e00b003e19557123cmr9437367qtw.52.1679563753150;
        Thu, 23 Mar 2023 02:29:13 -0700 (PDT)
X-Google-Smtp-Source: AK7set+dTXZSkoRXA666MxWsVBLAIywm8KzMAVacD1thH1ce+YO4OCqSzCTtD2lH0cRCelCFnUU+cQ==
X-Received: by 2002:a05:622a:34e:b0:3e1:9557:123c with SMTP id r14-20020a05622a034e00b003e19557123cmr9437356qtw.52.1679563752860;
        Thu, 23 Mar 2023 02:29:12 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-98.retail.telecomitalia.it. [82.53.134.98])
        by smtp.gmail.com with ESMTPSA id o10-20020a05620a228a00b007441b675e81sm12893452qkh.22.2023.03.23.02.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 02:29:12 -0700 (PDT)
Date:   Thu, 23 Mar 2023 10:29:05 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v5 2/2] virtio/vsock: check argument to avoid no
 effect call
Message-ID: <20230323092905.fpsiiaca2ba2wug3@sgarzare-redhat>
References: <f0b283a1-cc63-dc3d-cc0c-0da7f684d4d2@sberdevices.ru>
 <50bb0210-1ed7-42fb-b5f6-8d97247209b5@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <50bb0210-1ed7-42fb-b5f6-8d97247209b5@sberdevices.ru>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 22, 2023 at 09:36:24PM +0300, Arseniy Krasnov wrote:
>Both of these functions have no effect when input argument is 0, so to
>avoid useless spinlock access, check argument before it.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/virtio_transport_common.c | 6 ++++++
> 1 file changed, 6 insertions(+)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 9e87c7d4d7cf..312658c176bd 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -302,6 +302,9 @@ u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 credit)
> {
> 	u32 ret;
>
>+	if (!credit)
>+		return 0;
>+
> 	spin_lock_bh(&vvs->tx_lock);
> 	ret = vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
> 	if (ret > credit)
>@@ -315,6 +318,9 @@ EXPORT_SYMBOL_GPL(virtio_transport_get_credit);
>
> void virtio_transport_put_credit(struct virtio_vsock_sock *vvs, u32 credit)
> {
>+	if (!credit)
>+		return;
>+
> 	spin_lock_bh(&vvs->tx_lock);
> 	vvs->tx_cnt -= credit;
> 	spin_unlock_bh(&vvs->tx_lock);
>-- 
>2.25.1
>

