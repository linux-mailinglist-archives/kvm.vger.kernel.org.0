Return-Path: <kvm+bounces-1819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E37C7EC117
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 12:08:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31C412813AD
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 11:08:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EF9A168A3;
	Wed, 15 Nov 2023 11:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hu/bNW6/"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6BBC154B7
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 11:08:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B1AD8
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 03:08:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700046511;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=30YlxcbouoHUqbszSietM15X2VzsRmxEM5Z6VzVk+yg=;
	b=hu/bNW6/3vyAHjwBIUmADTmarsYKaL0BcL/g/tetEtgEq6YwSgME7EzDbJ9zBO4sGpwqcg
	BHxgJl1WVpLW0EoDCqkgZ/O9b2MfEQwFArs49k8R6q3YBTDZPibsSOShjNRDlcCb5KuSfE
	EsJ3DLxvFHTG/h5okMMHZ4veEfoGtlM=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-529-qxEEPq3MN_eoFCe5ancMfA-1; Wed, 15 Nov 2023 06:08:30 -0500
X-MC-Unique: qxEEPq3MN_eoFCe5ancMfA-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-9e644d94d85so98113966b.0
        for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 03:08:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700046509; x=1700651309;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=30YlxcbouoHUqbszSietM15X2VzsRmxEM5Z6VzVk+yg=;
        b=fZceo03B61kS7z3F7rixGyVFnxpLtX2MYYfCj6Aqg3sbC8KbeK8lfwQyvc7ZrdX0vu
         8O0vXjCQmNnm3YHQDgwdf8XbipRBlUSKYWyhzi4ZZ8Fe91c1B70xVPCSR0PS9/J17VxA
         l3ldOLaIGvD6p6O7jU1upQrzzJMdEnVzootXLdfmuFWr11lkn6ggz0f8DQyemaQMdYK9
         G3kyIhn3SI2/PcSRT8DwDGnSz9OLWb8UQLUmBVyGxklLbayyvo0nEITBkcD0yaj/WBQX
         HlTwuXtrFSKoHFSLuAc1Xh9994WSJrHni7MdcYMrmOA5XP+PtP0swJwSAdsCQzoqCt9O
         yXEg==
X-Gm-Message-State: AOJu0Yyhl9+FmXxoc+ZqAl2xvDETYf2MP22m4vOZK4w9utowUC6vjTzz
	FUill+6pIIQkVRhBWcF7Q1HyOg3akQM/Gk47OokTC3dq+UtwdVQFwLhWba+R3yu/6WhO7W5SEZe
	jDfa3tegdOZhm
X-Received: by 2002:a17:906:66d9:b0:9e6:2c5a:450a with SMTP id k25-20020a17090666d900b009e62c5a450amr4490048ejp.26.1700046509096;
        Wed, 15 Nov 2023 03:08:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHve6gIrQ6JWmFSezcPN9+P/sMdMQNqa9BHvI8TeelpKxEVC6UBoL04CyyICjC7dN059GHFfA==
X-Received: by 2002:a17:906:66d9:b0:9e6:2c5a:450a with SMTP id k25-20020a17090666d900b009e62c5a450amr4490025ejp.26.1700046508757;
        Wed, 15 Nov 2023 03:08:28 -0800 (PST)
Received: from sgarzare-redhat (host-79-46-200-199.retail.telecomitalia.it. [79.46.200.199])
        by smtp.gmail.com with ESMTPSA id v6-20020a056402174600b00530a9488623sm6410463edx.46.2023.11.15.03.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Nov 2023 03:08:28 -0800 (PST)
Date: Wed, 15 Nov 2023 12:08:23 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Bobby Eshleman <bobby.eshleman@bytedance.com>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel@sberdevices.ru, 
	oxffffaa@gmail.com
Subject: Re: [RFC PATCH v1 0/2] send credit update during setting SO_RCVLOWAT
Message-ID: <fqhgsbepjwftqmpv6xn7oqizdgmp25ri66seiewiikreglmmsd@uyouhusmjtby>
References: <20231108072004.1045669-1-avkrasnov@salutedevices.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20231108072004.1045669-1-avkrasnov@salutedevices.com>

On Wed, Nov 08, 2023 at 10:20:02AM +0300, Arseniy Krasnov wrote:
>Hello,
>
>                               DESCRIPTION
>
>This patchset fixes old problem with hungup of both rx/tx sides and adds
>test for it. This happens due to non-default SO_RCVLOWAT value and
>deferred credit update in virtio/vsock. Link to previous old patchset:
>https://lore.kernel.org/netdev/39b2e9fd-601b-189d-39a9-914e5574524c@sberdevices.ru/
>
>Here is what happens step by step:
>
>                                  TEST
>
>                            INITIAL CONDITIONS
>
>1) Vsock buffer size is 128KB.
>2) Maximum packet size is also 64KB as defined in header (yes it is
>   hardcoded, just to remind about that value).
>3) SO_RCVLOWAT is default, e.g. 1 byte.
>
>
>                                 STEPS
>
>            SENDER                              RECEIVER
>1) sends 128KB + 1 byte in a
>   single buffer. 128KB will
>   be sent, but for 1 byte
>   sender will wait for free
>   space at peer. Sender goes
>   to sleep.
>
>
>2)                                     reads 64KB, credit update not sent
>3)                                     sets SO_RCVLOWAT to 64KB + 1
>4)                                     poll() -> wait forever, there is
>                                       only 64KB available to read.
>
>So in step 4) receiver also goes to sleep, waiting for enough data or
>connection shutdown message from the sender. Idea to fix it is that rx
>kicks tx side to continue transmission (and may be close connection)
>when rx changes number of bytes to be woken up (e.g. SO_RCVLOWAT) and
>this value is bigger than number of available bytes to read.
>
>I've added small test for this, but not sure as it uses hardcoded value

Thanks for adding the test!

>for maximum packet length, this value is defined in kernel header and
>used to control deferred credit update. And as this is not available to
>userspace, I can't control test parameters correctly (if one day this
>define will be changed - test may become useless).

I see, I'll leave a comment in the patch!

Thanks,
Stefano

>
>Head for this patchset is:
>https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=ff269e2cd5adce4ae14f883fc9c8803bc43ee1e9
>
>Arseniy Krasnov (2):
>  virtio/vsock: send credit update during setting SO_RCVLOWAT
>  vsock/test: SO_RCVLOWAT + deferred credit update test
>
> drivers/vhost/vsock.c                   |   2 +
> include/linux/virtio_vsock.h            |   1 +
> net/vmw_vsock/virtio_transport.c        |   2 +
> net/vmw_vsock/virtio_transport_common.c |  31 ++++++
> net/vmw_vsock/vsock_loopback.c          |   2 +
> tools/testing/vsock/vsock_test.c        | 131 ++++++++++++++++++++++++
> 6 files changed, 169 insertions(+)
>
>-- 
>2.25.1
>


