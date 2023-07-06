Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0220174A2CE
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 19:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbjGFRHX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 13:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232413AbjGFRHV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 13:07:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B851BE8
        for <kvm@vger.kernel.org>; Thu,  6 Jul 2023 10:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688663197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QM/UutVaUSnuvT54IV8uHxbnE8kyc0wDH+u+J+MujRA=;
        b=Etr/KpRs3nuZbf3s4l6vc+G9s51+D6AuMrb1v+afd+ZHJaUCg8/ugIICjZa+YNsmJBfDW3
        Fyd9d7/ZGQYt3KjWKYEZ2TTAyxUDtI/dCINU+BwvcW6TL+fzF0v0jmSqwNrCXtfqlHkohj
        HXgac+RnS4tQuZniCEQhs4lKCPzCNIo=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-360-4DxVQPyROLmKD4sOGgSxCA-1; Thu, 06 Jul 2023 13:06:35 -0400
X-MC-Unique: 4DxVQPyROLmKD4sOGgSxCA-1
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-5734d919156so10522867b3.3
        for <kvm@vger.kernel.org>; Thu, 06 Jul 2023 10:06:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688663188; x=1691255188;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QM/UutVaUSnuvT54IV8uHxbnE8kyc0wDH+u+J+MujRA=;
        b=X6A/W9NWXxyW6t3HsPp37sFhYJZS2rYrPp93XwOulBa99jqnNVj1wGKLjCnYzUTfkV
         bhMKaOG/Hr52z5l6/4FCF+Axj0AiOE4t6wk5cGma2DPpr6Rf/87hBNT0lqe9vHfBbLX+
         5aUNLdnvPAKqxAEAcFHYLwixmObNFRU96xWuZShT7woqoW3K2Xnys74RqROZbeGXTtMn
         1WZSaeF7sMIjIc/3dpME4DJl6bK9juDwObbmdKPjyQ3+PnqgGp98yCs8/YEapi/SRGBA
         htrXOfeWJCQYvPIAtYgel8ZD3q7rPe/2N7u+fyJ7Qns0T1HuyP3bt48KQP5zDT+8JLL0
         u0BA==
X-Gm-Message-State: ABy/qLZkZsgdJSmXphNqQe68hv7J2cAwi6ilVSzcN4dBHZuV/yxDsSut
        xdDyT6VcsLZ8npmi7iYrqNqAfP2EO3GXZJr8TmLeUM0FPbvNWhPb3d5YiSwJfgxKiqXK8jumAAK
        YZZ8K2fJcnT8VaaZZqbantTBxD9JQ
X-Received: by 2002:a81:71c2:0:b0:577:2f3f:ddbb with SMTP id m185-20020a8171c2000000b005772f3fddbbmr2826575ywc.47.1688663188582;
        Thu, 06 Jul 2023 10:06:28 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGUPhZB++pPprAX0mNv8YwgUVnvLjCcxh4OxP6jPuw+p92V0NCOAKC1wTT6antIgmpYOn5jTkY1ZGQ2v0ndfQ4=
X-Received: by 2002:a81:71c2:0:b0:577:2f3f:ddbb with SMTP id
 m185-20020a8171c2000000b005772f3fddbbmr2826555ywc.47.1688663188348; Thu, 06
 Jul 2023 10:06:28 -0700 (PDT)
MIME-Version: 1.0
References: <20230701063947.3422088-1-AVKrasnov@sberdevices.ru> <20230701063947.3422088-15-AVKrasnov@sberdevices.ru>
In-Reply-To: <20230701063947.3422088-15-AVKrasnov@sberdevices.ru>
From:   Stefano Garzarella <sgarzare@redhat.com>
Date:   Thu, 6 Jul 2023 19:06:17 +0200
Message-ID: <CAGxU2F410NSNSzdNS4m-9UM8rZFBFpe5LeNZtkF0VzJc5_JFmg@mail.gmail.com>
Subject: Re: [RFC PATCH v5 14/17] docs: net: description of MSG_ZEROCOPY for AF_VSOCK
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 01, 2023 at 09:39:44AM +0300, Arseniy Krasnov wrote:
>This adds description of MSG_ZEROCOPY flag support for AF_VSOCK type of
>socket.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> Documentation/networking/msg_zerocopy.rst | 12 ++++++++++--
> 1 file changed, 10 insertions(+), 2 deletions(-)
>
>diff --git a/Documentation/networking/msg_zerocopy.rst b/Documentation/networking/msg_zerocopy.rst
>index b3ea96af9b49..34bc7ff411ce 100644
>--- a/Documentation/networking/msg_zerocopy.rst
>+++ b/Documentation/networking/msg_zerocopy.rst
>@@ -7,7 +7,8 @@ Intro
> =====
>
> The MSG_ZEROCOPY flag enables copy avoidance for socket send calls.
>-The feature is currently implemented for TCP and UDP sockets.
>+The feature is currently implemented for TCP, UDP and VSOCK (with
>+virtio transport) sockets.
>
>
> Opportunity and Caveats
>@@ -174,7 +175,7 @@ read_notification() call in the previous snippet. A notification
> is encoded in the standard error format, sock_extended_err.
>
> The level and type fields in the control data are protocol family
>-specific, IP_RECVERR or IPV6_RECVERR.
>+specific, IP_RECVERR or IPV6_RECVERR (for TCP or UDP socket).
>
> Error origin is the new type SO_EE_ORIGIN_ZEROCOPY. ee_errno is zero,
> as explained before, to avoid blocking read and write system calls on
>@@ -201,6 +202,7 @@ undefined, bar for ee_code, as discussed below.
>
>       printf("completed: %u..%u\n", serr->ee_info, serr->ee_data);
>
>+For VSOCK socket, cmsg_level will be SOL_VSOCK and cmsg_type will be 0.

Maybe better to move up, just under the previous change.

By the way, should we define a valid type value for vsock
(e.g. VSOCK_RECVERR)?

>
> Deferred copies
> ~~~~~~~~~~~~~~~
>@@ -235,12 +237,15 @@ Implementation
> Loopback
> --------
>
>+For TCP and UDP:
> Data sent to local sockets can be queued indefinitely if the receive
> process does not read its socket. Unbound notification latency is not
> acceptable. For this reason all packets generated with MSG_ZEROCOPY
> that are looped to a local socket will incur a deferred copy. This
> includes looping onto packet sockets (e.g., tcpdump) and tun devices.
>
>+For VSOCK:
>+Data path sent to local sockets is the same as for non-local sockets.
>
> Testing
> =======
>@@ -254,3 +259,6 @@ instance when run with msg_zerocopy.sh between a veth pair across
> namespaces, the test will not show any improvement. For testing, the
> loopback restriction can be temporarily relaxed by making
> skb_orphan_frags_rx identical to skb_orphan_frags.
>+
>+For VSOCK type of socket example can be found in  tools/testing/vsock/
>+vsock_test_zerocopy.c.

For VSOCK socket, example can be found in
tools/testing/vsock/vsock_test_zerocopy.c

(we should leave the entire path on the same line)

>--
>2.25.1
>

