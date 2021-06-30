Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04AE33B81C7
	for <lists+kvm@lfdr.de>; Wed, 30 Jun 2021 14:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234481AbhF3MOq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Jun 2021 08:14:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41064 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234403AbhF3MOo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Jun 2021 08:14:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625055135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IgkWdNwml5AbnxYQNYHxxHeoFVm9yVfptJ5ZSxaAHBs=;
        b=cOE9N8F3wf7wu6EUG0j1c6FrvsiiugCu90iFKmWgoxRe+QtvahOB4ZNe7eZMnqRbBYXleD
        XHz0KqROPV4yFVYnOqANK6mfUzRFwElglu226lYfmKr9iH34KcaYXHvGu/UFV3ehIYyVWt
        h14B6tLjY69ocXjCu5u8EPlXtJTcmOU=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-HVLhVqeHPGaSTLUK8yc_Bg-1; Wed, 30 Jun 2021 08:12:14 -0400
X-MC-Unique: HVLhVqeHPGaSTLUK8yc_Bg-1
Received: by mail-ej1-f69.google.com with SMTP id ho42-20020a1709070eaab02904a77ea3380eso691190ejc.4
        for <kvm@vger.kernel.org>; Wed, 30 Jun 2021 05:12:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IgkWdNwml5AbnxYQNYHxxHeoFVm9yVfptJ5ZSxaAHBs=;
        b=rlJnL630Y6OJtbXYSLCxMyZl1Sm3Y0wKX86QQ5O4ZQa5DAZcEoO+e9yAhciwkzV/bV
         Rq0aMZppoa3iRLBZo/eslFsQIQwRYrQ15MU4s7efsGex+SKThTdNTxX01goFR1/gO/kM
         CYFT0//smps07nx88+aNw9bC479r7+g97xbsuXxIdjYE10BKfb1Dnq1fAudaPVrgHodM
         HwyZhj+xF+8nUygHKvx6+wmsjakupF6hGNvoCnXfRrUd/IiwN+550OINklhj2iIuEYub
         +oqTLBV0RXkbdMGP1yUIuOtMt0AScm9aV9moA122QFyNd/Byh2dt0er0meGctlMTPuNV
         CDQQ==
X-Gm-Message-State: AOAM532H6SR7bdI5eLpEFjP0g3NnsIKwVSivHxZHIN6XXQ1qzujMxkNU
        drneltW+mrn58kiTFu6V39yqvWNv8bScLH+NvFwvXcjrkH9mDeXJpCwPLcdRZ8kjdXEp2M/eDlZ
        tqG4hoaLyAoFf
X-Received: by 2002:a17:906:9516:: with SMTP id u22mr35503408ejx.442.1625055133032;
        Wed, 30 Jun 2021 05:12:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw1RNet7hJTadLeI9Tsu08HSFKQO+PCkN7Ksy3Me0p9lWphUkAZUHtlvFpAt4l+roFjoyUJXw==
X-Received: by 2002:a17:906:9516:: with SMTP id u22mr35503385ejx.442.1625055132807;
        Wed, 30 Jun 2021 05:12:12 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id b17sm3361405edd.58.2021.06.30.05.12.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 05:12:12 -0700 (PDT)
Date:   Wed, 30 Jun 2021 14:12:09 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        kvm <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Krasnov Arseniy <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v1 08/16] af_vsock: change SEQPACKET receive loop
Message-ID: <CAGxU2F5XtfKJ9cnK=J-gz4uW0AR9FsMc1Dq2jQx=dPGLRC+NTQ@mail.gmail.com>
References: <20210628095959.569772-1-arseny.krasnov@kaspersky.com>
 <20210628100331.571056-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628100331.571056-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 28, 2021 at 01:03:28PM +0300, Arseny Krasnov wrote:
>Receive "loop" now really loop: it reads fragments one by
>one, sleeping if queue is empty.
>
>NOTE: 'msg_ready' pointer is not passed to 'seqpacket_dequeue()'
>here - it change callback interface, so it is moved to next patch.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> net/vmw_vsock/af_vsock.c | 31 ++++++++++++++++++++++---------
> 1 file changed, 22 insertions(+), 9 deletions(-)

I think you can merge patches 8, 9, and 10 together since we
are touching the seqpacket_dequeue() behaviour.

Then you can remove in separate patches the unneeded parts (e.g.
seqpacket_has_data, msg_count, etc.).

Thanks,
Stefano

>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 59ce35da2e5b..9552f05119f2 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -2003,6 +2003,7 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
>                                    size_t len, int flags)
> {
>       const struct vsock_transport *transport;
>+      bool msg_ready;
>       struct vsock_sock *vsk;
>       ssize_t record_len;
>       long timeout;
>@@ -2013,23 +2014,36 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
>       transport = vsk->transport;
>
>       timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
>+      msg_ready = false;
>+      record_len = 0;
>
>-      err = vsock_connectible_wait_data(sk, &wait, timeout, NULL, 0);
>-      if (err <= 0)
>-              goto out;
>+      while (!msg_ready) {
>+              ssize_t fragment_len;
>+              int intr_err;
>
>-      record_len = transport->seqpacket_dequeue(vsk, msg, flags);
>+              intr_err = vsock_connectible_wait_data(sk, &wait, timeout, NULL, 0);
>+              if (intr_err <= 0) {
>+                      err = intr_err;
>+                      break;
>+              }
>
>-      if (record_len < 0) {
>-              err = -ENOMEM;
>-              goto out;
>+              fragment_len = transport->seqpacket_dequeue(vsk, msg, flags);
>+
>+              if (fragment_len < 0) {
>+                      err = -ENOMEM;
>+                      break;
>+              }
>+
>+              record_len += fragment_len;
>       }
>
>       if (sk->sk_err) {
>               err = -sk->sk_err;
>       } else if (sk->sk_shutdown & RCV_SHUTDOWN) {
>               err = 0;
>-      } else {
>+      }
>+
>+      if (msg_ready && !err) {
>               /* User sets MSG_TRUNC, so return real length of
>                * packet.
>                */
>@@ -2045,7 +2059,6 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
>                       msg->msg_flags |= MSG_TRUNC;
>       }
>
>-out:
>       return err;
> }
>
>--
>2.25.1
>

