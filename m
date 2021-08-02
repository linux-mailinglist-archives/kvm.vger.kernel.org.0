Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7830F3DDF56
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 20:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbhHBSfO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 14:35:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54079 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232060AbhHBSfL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Aug 2021 14:35:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627929301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wminINGDgWcNHoLPUasL8rgS7uCgoeCj4rIW6d1gFd0=;
        b=YvBg4D6Ok09eOJC7TpSEwFAEQ2FIpkAD3RnFGXJllgtpEvvvY32RT1vEPaP+v9hID1svZ8
        IadKbOyRJWI8L53OId502PzHZFsdKqe9b3ZT219OP8kpZrOG124J/W9kmYAeKeXtHkZ1v6
        kb346tGfSInQ8X5ngvqAx7EFrrPb2rg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-h9TjzrjUPHaSVNe86qeVwQ-1; Mon, 02 Aug 2021 14:35:00 -0400
X-MC-Unique: h9TjzrjUPHaSVNe86qeVwQ-1
Received: by mail-ed1-f71.google.com with SMTP id n24-20020aa7c7980000b02903bb4e1d45aaso9212659eds.15
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 11:35:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wminINGDgWcNHoLPUasL8rgS7uCgoeCj4rIW6d1gFd0=;
        b=ITcRjew/AZlGOtxnCE/T8U/05Fqww7pAXq+KYDq0oq+JxkNvu+FVm+Z55ZtcOsrb0g
         CeO6QrxtBficBDH50hTiNSllG3P8Ygx615QzN3mF7cS2rEJg4OxZU35PwVYllwcho1C2
         KBVQ3ZvHNxs6oNpoiIhaReQRWAjFzHyzp9G7eiIm4lJFKBsccfEFGQCtAihlSWGMM1Ve
         EhOX6oHTFwUAXRaVLxpxCKcrvkgKMqSxTM0i4w/acFTROshVpKwYlN9ejhQwK/SAVba+
         VHmQu1zheu5PRs08plqPqcgneRDzF8ZRdxcB9uhqnze/pMYJuoe64j/Tk58+QCigW7b2
         uhXQ==
X-Gm-Message-State: AOAM533XMCUuKkSWZG999PlRgZvbKemLvtS7UsoYtj8DxH1YXqdKCHxQ
        Tj1cp9k60UWNKXEc5WM8/aKg/L4vHy1Q+8yjRowSwo7XWNzJn+M/HVvmACLUjapJ2vk7eLjgaOh
        7FBds7mLLSXSN
X-Received: by 2002:a50:fb18:: with SMTP id d24mr20985352edq.225.1627929299328;
        Mon, 02 Aug 2021 11:34:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwoCyMdXrDgg3jX2cUmgPnbyHqQZI1zsIxFF27gl9okbIV2OgI+ba2TaS/45evhjSuB8kSK5g==
X-Received: by 2002:a50:fb18:: with SMTP id d24mr20985334edq.225.1627929299147;
        Mon, 02 Aug 2021 11:34:59 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id n13sm6705376eda.36.2021.08.02.11.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 11:34:58 -0700 (PDT)
Date:   Mon, 2 Aug 2021 20:34:56 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Harshavardhan Unnibhavi <harshanavkis@gmail.com>
Cc:     stefanha@redhat.com, davem@davemloft.net, kuba@kernel.org,
        asias@redhat.com, mst@redhat.com, imbrenda@linux.vnet.ibm.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] VSOCK: handle VIRTIO_VSOCK_OP_CREDIT_REQUEST
Message-ID: <20210802183456.zvr6raqtgwrm3s52@steredhat>
References: <20210802173506.2383-1-harshanavkis@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210802173506.2383-1-harshanavkis@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 02, 2021 at 07:35:06PM +0200, Harshavardhan Unnibhavi wrote:
>The original implementation of the virtio-vsock driver does not
>handle a VIRTIO_VSOCK_OP_CREDIT_REQUEST as required by the
>virtio-vsock specification. The vsock device emulated by
>vhost-vsock and the virtio-vsock driver never uses this request,
>which was probably why nobody noticed it. However, another
>implementation of the device may use this request type.
>
>Hence, this commit introduces a way to handle an explicit credit
>request by responding with a corresponding credit update as
>required by the virtio-vsock specification.
>
>Fixes: 06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
>
>Signed-off-by: Harshavardhan Unnibhavi <harshanavkis@gmail.com>
>---
> net/vmw_vsock/virtio_transport_common.c | 3 +++
> 1 file changed, 3 insertions(+)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c 
>b/net/vmw_vsock/virtio_transport_common.c
>index 169ba8b72a63..081e7ae93cb1 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -1079,6 +1079,9 @@ virtio_transport_recv_connected(struct sock *sk,
> 		virtio_transport_recv_enqueue(vsk, pkt);
> 		sk->sk_data_ready(sk);
> 		return err;
>+	case VIRTIO_VSOCK_OP_CREDIT_REQUEST:
>+		virtio_transport_send_credit_update(vsk);
>+		break;
> 	case VIRTIO_VSOCK_OP_CREDIT_UPDATE:
> 		sk->sk_write_space(sk);
> 		break;
>-- 2.17.1
>

The patch LGTM, thanks for fixing this long-time issue!

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

