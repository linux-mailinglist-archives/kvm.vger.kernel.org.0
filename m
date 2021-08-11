Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18A913E8CE3
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 11:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236634AbhHKJJ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 05:09:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54863 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236599AbhHKJJ7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Aug 2021 05:09:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628672975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MsN+R/kO/sC5UDsvg+cIZCQho4j0aHbcm1E8m8xMoHI=;
        b=Y/3A+zGV2Z8Oy4FxnskduYhm7DD+LHXbjZvqIYP0YrVripAY68OyW/Hv1NR/1damZeIsMt
        1YVyjvnb7d+cwZuAAsfEnKbA0j5NGjZHfha6J1SvQsFqfh+/FSPVodWezqhRJ0eibf6dKj
        nmAa0Mt6LgwUhluSVqlCVnCg3VHWTRw=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507--JUSnAf4OQGUOCGlWNrAug-1; Wed, 11 Aug 2021 05:09:34 -0400
X-MC-Unique: -JUSnAf4OQGUOCGlWNrAug-1
Received: by mail-ej1-f71.google.com with SMTP id q19-20020a170906b293b029058a1e75c819so417761ejz.16
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 02:09:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MsN+R/kO/sC5UDsvg+cIZCQho4j0aHbcm1E8m8xMoHI=;
        b=S0Pf7Fy5OH4XzV5FMtiN3Q1+y+TEZFsfePMfMVoQj8KO1I4UyL62RZv6xlTOyhnjVi
         mlU3W/BEaf2molfn2TAw+1UVfWlph966VfuqCN33Y4o6/ImtI9xy+UOwooFEl3suR+zc
         eoMpr/SBCl16YXlyh08gcEetN3UCJSAboehepYPzSgnqk2XcQ4KnnXAFC+uFNR1cunlJ
         xQz6ZlE4Atck1G47NbykXWuiOoWmrXzvb/x+KmPem0HNwISryotVX4wz1KRachujp9J5
         A97lpEdS3p/3Pu2Be4Kvf+PJ9HAbDObhubtxN1bcWxZ5pHHP4vXJBSVvQPy2AZwpboPx
         pqDQ==
X-Gm-Message-State: AOAM531YGBe6QJBGA+2aM8to/HH25CefcjYhPIv4Rd8IVBVSrXGXUZYF
        jyKoKagaBWV7ITlTw4S2Y3zT9eIKHPLbTkEzXjOgem3UrFhqRjWsy3Ai9iQJdXn9xPJnGeZz7Q+
        of0vjLi51cyNx
X-Received: by 2002:a17:907:d09:: with SMTP id gn9mr2650710ejc.447.1628672972940;
        Wed, 11 Aug 2021 02:09:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzlojArCBZxB67seYKuyq7LpLZcorxhEMExKVIxApxzWQgjZz0IoO7BwSDRdptosrXZNyCPQA==
X-Received: by 2002:a17:907:d09:: with SMTP id gn9mr2650687ejc.447.1628672972737;
        Wed, 11 Aug 2021 02:09:32 -0700 (PDT)
Received: from steredhat (a-nu5-14.tin.it. [212.216.181.13])
        by smtp.gmail.com with ESMTPSA id v24sm7840824edt.41.2021.08.11.02.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 02:09:32 -0700 (PDT)
Date:   Wed, 11 Aug 2021 11:09:30 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v2 4/5] af_vsock: rename variables in receive loop
Message-ID: <20210811090930.mormg24hnnle7qq3@steredhat>
References: <20210810113901.1214116-1-arseny.krasnov@kaspersky.com>
 <20210810114103.1214897-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210810114103.1214897-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 10, 2021 at 02:41:00PM +0300, Arseny Krasnov wrote:
>Record is supported via MSG_EOR flag, while current logic operates
>with message, so rename variables from 'record' to 'message'.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> net/vmw_vsock/af_vsock.c | 10 +++++-----
> 1 file changed, 5 insertions(+), 5 deletions(-)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 3e02cc3b24f8..e2c0cfb334d2 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -2014,7 +2014,7 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
> {
> 	const struct vsock_transport *transport;
> 	struct vsock_sock *vsk;
>-	ssize_t record_len;
>+	ssize_t msg_len;
> 	long timeout;
> 	int err = 0;
> 	DEFINE_WAIT(wait);
>@@ -2028,9 +2028,9 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
> 	if (err <= 0)
> 		goto out;
>
>-	record_len = transport->seqpacket_dequeue(vsk, msg, flags);
>+	msg_len = transport->seqpacket_dequeue(vsk, msg, flags);
>
>-	if (record_len < 0) {
>+	if (msg_len < 0) {
> 		err = -ENOMEM;
> 		goto out;
> 	}
>@@ -2044,14 +2044,14 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
> 		 * packet.
> 		 */
> 		if (flags & MSG_TRUNC)
>-			err = record_len;
>+			err = msg_len;
> 		else
> 			err = len - msg_data_left(msg);
>
> 		/* Always set MSG_TRUNC if real length of packet is
> 		 * bigger than user's buffer.
> 		 */
>-		if (record_len > len)
>+		if (msg_len > len)
> 			msg->msg_flags |= MSG_TRUNC;
> 	}
>
>-- 
>2.25.1
>

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

