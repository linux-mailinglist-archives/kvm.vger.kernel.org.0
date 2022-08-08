Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED94058C64C
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 12:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242553AbiHHKXw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 06:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242508AbiHHKXv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 06:23:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9F5F81277F
        for <kvm@vger.kernel.org>; Mon,  8 Aug 2022 03:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659954229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CZ+7qMtAooG6dh841vB4xXZOc4YcIi/wWT2HlYib+T4=;
        b=F4xuVoQefaFtd2hMeUFYJ5sWl318QhAp4S3OwAF/1V0ERfhH5k4aClst9WWTbqOM41GHCa
        qx4my3fY/xC/J8I+mfVHw5LKD6dunFZDghWxwM96w3dtLpitszUvzXUyNA8pcY8yh8UOtK
        So+1rDgKv8dMfvWCBEdHnZT+VVc4EpU=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-5-Bvog2lqsMoO_NiS3KslJ1A-1; Mon, 08 Aug 2022 06:23:46 -0400
X-MC-Unique: Bvog2lqsMoO_NiS3KslJ1A-1
Received: by mail-qk1-f197.google.com with SMTP id bi22-20020a05620a319600b006b92f4b2ebbso4598011qkb.22
        for <kvm@vger.kernel.org>; Mon, 08 Aug 2022 03:23:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=CZ+7qMtAooG6dh841vB4xXZOc4YcIi/wWT2HlYib+T4=;
        b=j5FJMBZrO1OWhA05tJkSkejViAsvIWODgsEa8rj5JeMwVLG4cN+zrj4DFDWh0XSGfJ
         PQYjieDj2+eL9YNOLU/u8kWsHE2ABt0qwT/8gxJWCtHopGvM52metDWbdI/Vzv26Likr
         pLoOPlbim3H+eP5RVlUXoWUn4KB0LOutlx3o1b18MNhp6bZKO9X2d0NtMGcoUfEdH3bQ
         YeqjtD2EHP4Qaj8Tqy9ixZg8FLrz+bOoVUkNLUJ9l/L3JsWwGUQGJgXXddLl6uHJDiHU
         4ks1uV/rPNu4of1gcJZ4aXkRkl55AfmPTFxD8YEtiEHoIJg8SCY8EEqfckkwsaUoFAz4
         zkBA==
X-Gm-Message-State: ACgBeo3iDZDJzyDFt32vY/dY6J0PoSivOuY22zynn6HCDM+P1VqY7fdT
        4e4qouQyE+HpstNs7RciZeIiB4J39i9/UpAFT+46RZjKpCrLeF88c644aahmRRTLxRus3vtTm3J
        gOh7mSK8p703W
X-Received: by 2002:ac8:7d4e:0:b0:31f:33db:69bc with SMTP id h14-20020ac87d4e000000b0031f33db69bcmr15622440qtb.482.1659954226106;
        Mon, 08 Aug 2022 03:23:46 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6JBzf5xAfbbDtzMbPLn2U0H6BGM6n6lSlv4ISjtq6rY6A09Oo3blf5b3eQhOOQ/S3L7JLDWA==
X-Received: by 2002:ac8:7d4e:0:b0:31f:33db:69bc with SMTP id h14-20020ac87d4e000000b0031f33db69bcmr15622424qtb.482.1659954225867;
        Mon, 08 Aug 2022 03:23:45 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-178.retail.telecomitalia.it. [79.46.200.178])
        by smtp.gmail.com with ESMTPSA id k5-20020a05620a414500b006b93ef659c3sm4308518qko.39.2022.08.08.03.23.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 03:23:44 -0700 (PDT)
Date:   Mon, 8 Aug 2022 12:23:35 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v3 1/9] vsock: SO_RCVLOWAT transport set callback
Message-ID: <20220808102335.nkviqobpgcmcaqhn@sgarzare-redhat>
References: <2ac35e2c-26a8-6f6d-2236-c4692600db9e@sberdevices.ru>
 <45822644-8e37-1625-5944-63fd5fc20dd3@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <45822644-8e37-1625-5944-63fd5fc20dd3@sberdevices.ru>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 03, 2022 at 01:51:05PM +0000, Arseniy Krasnov wrote:
>This adds transport specific callback for SO_RCVLOWAT, because in some
>transports it may be difficult to know current available number of bytes
>ready to read. Thus, when SO_RCVLOWAT is set, transport may reject it.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> include/net/af_vsock.h   |  1 +
> net/vmw_vsock/af_vsock.c | 25 +++++++++++++++++++++++++
> 2 files changed, 26 insertions(+)
>
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index f742e50207fb..eae5874bae35 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -134,6 +134,7 @@ struct vsock_transport {
> 	u64 (*stream_rcvhiwat)(struct vsock_sock *);
> 	bool (*stream_is_active)(struct vsock_sock *);
> 	bool (*stream_allow)(u32 cid, u32 port);
>+	int (*set_rcvlowat)(struct vsock_sock *, int);

checkpatch suggests to add identifier names. For some we put them in, 
for others we didn't, but I suggest putting them in for the new ones 
because I think it's clearer too.

WARNING: function definition argument 'struct vsock_sock *' should also 
have an identifier name
#25: FILE: include/net/af_vsock.h:137:
+	int (*set_rcvlowat)(struct vsock_sock *, int);

WARNING: function definition argument 'int' should also have an identifier name
#25: FILE: include/net/af_vsock.h:137:
+	int (*set_rcvlowat)(struct vsock_sock *, int);

total: 0 errors, 2 warnings, 0 checks, 44 lines checked

>
> 	/* SEQ_PACKET. */
> 	ssize_t (*seqpacket_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index f04abf662ec6..016ad5ff78b7 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -2129,6 +2129,30 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
> 	return err;
> }
>
>+static int vsock_set_rcvlowat(struct sock *sk, int val)
>+{
>+	const struct vsock_transport *transport;
>+	struct vsock_sock *vsk;
>+	int err = 0;
>+
>+	vsk = vsock_sk(sk);
>+
>+	if (val > vsk->buffer_size)
>+		return -EINVAL;
>+
>+	transport = vsk->transport;
>+
>+	if (!transport)
>+		return -EOPNOTSUPP;

I don't know whether it is better in this case to write it in 
sk->sk_rcvlowat, maybe we can return EOPNOTSUPP only when the trasport 
is assigned and set_rcvlowat is not defined. This is because usually the 
options are set just after creation, when the transport is practically 
unassigned.

I mean something like this:

         if (transport) {
                 if (transport->set_rcvlowat)
                         return transport->set_rcvlowat(vsk, val);
                 else
                         return -EOPNOTSUPP;
         }

         WRITE_ONCE(sk->sk_rcvlowat, val ? : 1);

         return 0;

>+
>+	if (transport->set_rcvlowat)
>+		err = transport->set_rcvlowat(vsk, val);
>+	else
>+		WRITE_ONCE(sk->sk_rcvlowat, val ? : 1);
>+
>+	return err;
>+}
>+
> static const struct proto_ops vsock_stream_ops = {
> 	.family = PF_VSOCK,
> 	.owner = THIS_MODULE,
>@@ -2148,6 +2172,7 @@ static const struct proto_ops vsock_stream_ops = {
> 	.recvmsg = vsock_connectible_recvmsg,
> 	.mmap = sock_no_mmap,
> 	.sendpage = sock_no_sendpage,
>+	.set_rcvlowat = vsock_set_rcvlowat,
> };
>
> static const struct proto_ops vsock_seqpacket_ops = {
>-- 
>2.25.1

