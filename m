Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0723ACCB6
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 15:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233944AbhFRNwF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 09:52:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52459 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233832AbhFRNwE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Jun 2021 09:52:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624024194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6HoUIMXGDRyxX15B0OSH99zC37qr5ecUlX8BEKoHItE=;
        b=iHjXmatj1Y2LMIxRCwnCI3KuYPrejDjAJ3vz9gNI2NVNlDMeb7P/XGb98sAnD028FO8GKp
        IM8KnKIkaB4DBpE1liFcwH//c8KG30AyZ8+BRZNMAW+kQCEie2UGGdCiZoG0hSQsfohGFp
        /A8UNy4FebMLOuDOo+JhgOFEmTv0O58=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-gdrPeKKvOoK4lvUZ3CiBzg-1; Fri, 18 Jun 2021 09:49:53 -0400
X-MC-Unique: gdrPeKKvOoK4lvUZ3CiBzg-1
Received: by mail-wm1-f72.google.com with SMTP id v20-20020a05600c2154b029019a6368bfe4so3787737wml.2
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 06:49:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6HoUIMXGDRyxX15B0OSH99zC37qr5ecUlX8BEKoHItE=;
        b=iSQfMamHnjX6leIV9/DKzejaz6X/QHZcmrO8uCHHgwsjyIoptuyPvO89h9S+78zQDF
         wWF8lG+o1d7lYBlgqSTWmESuH329tnFldz2+eQ6I8VUj+QURmZmZ6n/Tb4sQOGMCM8nQ
         3kcMtukMuIDpj2uo2ufo3XENHpg1bVJUgNZAGiw0WC6cPBjoxt3UNICVJVHAevvHtpF7
         zPmNpI/I6Y+dAgL7dMeMYMpAQHccxTvaV9nya2YfwfMp2h/OPN0DesnFmdYxVZi8j7Dd
         r7t3YrtuvKm9NDYYg3fUz1a0RFAdzqKkBjUrRjNvuSxHupw8K5HQLTpDjCqjtuy94sgD
         5RcQ==
X-Gm-Message-State: AOAM530BpguFt/O2Qd1Q35NqPqhamHp6UBdVEI0uBITNTSsa3Asz4/o8
        81LdAf0Dhq6prHuCRxqveOCP4NRwG7N9fP97nGaxQbpt0ORbeblqQZ8LjJz1TLxVBHOAmNbniyV
        xLmvtYz5HF5XI
X-Received: by 2002:a7b:ce95:: with SMTP id q21mr11631730wmj.59.1624024191916;
        Fri, 18 Jun 2021 06:49:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx0yMkDjr+tukARGep0TvBKEJk88iUPh4P+McQ1eT/TSNVb46YaflNZmxNuwGdGDQ4lDKQjQg==
X-Received: by 2002:a7b:ce95:: with SMTP id q21mr11631713wmj.59.1624024191719;
        Fri, 18 Jun 2021 06:49:51 -0700 (PDT)
Received: from redhat.com ([77.126.22.11])
        by smtp.gmail.com with ESMTPSA id r6sm8645754wrt.21.2021.06.18.06.49.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 06:49:48 -0700 (PDT)
Date:   Fri, 18 Jun 2021 09:49:44 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     Arseny Krasnov <arseny.krasnov@kaspersky.com>, stefanha@redhat.com,
        sgarzare@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        kuba@kernel.org, andraprs@amazon.com, nslusarek@gmx.net,
        colin.king@canonical.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, oxffffaa@gmail.com
Subject: Re: [PATCH v11 00/18] virtio/vsock: introduce SOCK_SEQPACKET support
Message-ID: <20210618094746-mutt-send-email-mst@kernel.org>
References: <20210611110744.3650456-1-arseny.krasnov@kaspersky.com>
 <162344521373.30951.11000282953901961373.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162344521373.30951.11000282953901961373.git-patchwork-notify@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 11, 2021 at 09:00:13PM +0000, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This series was applied to netdev/net-next.git (refs/heads/master):
> 
> On Fri, 11 Jun 2021 14:07:40 +0300 you wrote:
> > This patchset implements support of SOCK_SEQPACKET for virtio
> > transport.
> > 	As SOCK_SEQPACKET guarantees to save record boundaries, so to
> > do it, new bit for field 'flags' was added: SEQ_EOR. This bit is
> > set to 1 in last RW packet of message.
> > 	Now as  packets of one socket are not reordered neither on vsock
> > nor on vhost transport layers, such bit allows to restore original
> > message on receiver's side. If user's buffer is smaller than message
> > length, when all out of size data is dropped.
> > 	Maximum length of datagram is limited by 'peer_buf_alloc' value.
> > 	Implementation also supports 'MSG_TRUNC' flags.
> > 	Tests also implemented.
> > 
> > [...]
> 
> Here is the summary with links:
>   - [v11,01/18] af_vsock: update functions for connectible socket
>     https://git.kernel.org/netdev/net-next/c/a9e29e5511b9
>   - [v11,02/18] af_vsock: separate wait data loop
>     https://git.kernel.org/netdev/net-next/c/b3f7fd54881b
>   - [v11,03/18] af_vsock: separate receive data loop
>     https://git.kernel.org/netdev/net-next/c/19c1b90e1979
>   - [v11,04/18] af_vsock: implement SEQPACKET receive loop
>     https://git.kernel.org/netdev/net-next/c/9942c192b256
>   - [v11,05/18] af_vsock: implement send logic for SEQPACKET
>     https://git.kernel.org/netdev/net-next/c/fbe70c480796
>   - [v11,06/18] af_vsock: rest of SEQPACKET support
>     https://git.kernel.org/netdev/net-next/c/0798e78b102b
>   - [v11,07/18] af_vsock: update comments for stream sockets
>     https://git.kernel.org/netdev/net-next/c/8cb48554ad82
>   - [v11,08/18] virtio/vsock: set packet's type in virtio_transport_send_pkt_info()
>     https://git.kernel.org/netdev/net-next/c/b93f8877c1f2
>   - [v11,09/18] virtio/vsock: simplify credit update function API
>     https://git.kernel.org/netdev/net-next/c/c10844c59799
>   - [v11,10/18] virtio/vsock: defines and constants for SEQPACKET
>     https://git.kernel.org/netdev/net-next/c/f07b2a5b04d4
>   - [v11,11/18] virtio/vsock: dequeue callback for SOCK_SEQPACKET
>     https://git.kernel.org/netdev/net-next/c/44931195a541
>   - [v11,12/18] virtio/vsock: add SEQPACKET receive logic
>     https://git.kernel.org/netdev/net-next/c/e4b1ef152f53
>   - [v11,13/18] virtio/vsock: rest of SOCK_SEQPACKET support
>     https://git.kernel.org/netdev/net-next/c/9ac841f5e9f2
>   - [v11,14/18] virtio/vsock: enable SEQPACKET for transport
>     https://git.kernel.org/netdev/net-next/c/53efbba12cc7
>   - [v11,15/18] vhost/vsock: support SEQPACKET for transport
>     https://git.kernel.org/netdev/net-next/c/ced7b713711f
>   - [v11,16/18] vsock/loopback: enable SEQPACKET for transport
>     https://git.kernel.org/netdev/net-next/c/6e90a57795aa
>   - [v11,17/18] vsock_test: add SOCK_SEQPACKET tests
>     https://git.kernel.org/netdev/net-next/c/41b792d7a86d
>   - [v11,18/18] virtio/vsock: update trace event for SEQPACKET
>     https://git.kernel.org/netdev/net-next/c/184039eefeae

Hmm so the virtio part was merged before the spec is ready.
What's the plan now?


> You are awesome, thank you!
> --
> Deet-doot-dot, I am a bot.
> https://korg.docs.kernel.org/patchwork/pwbot.html
> 

