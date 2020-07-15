Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29331220F6B
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 16:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728837AbgGOOe5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 10:34:57 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:37721 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728798AbgGOOe5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Jul 2020 10:34:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594823695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gDUnF1gX4Wln5UGQpyw0DsCZrmXKbH1BJblX2g4HkKY=;
        b=Hotuj4gGwogjH/qfP/O+0G02hzfEyeOBCNFCdy/jQCyhB1w69q/UECqoyaCLTa4YKfEhxq
        zKE2Vaf0YFyYT/dz0IM2xSP/ugYGqpY2gYJTf8NpZqeQArdpZNJ8vNRARhO274roME2pwH
        8+AsXrKM9WEJTBzkq5DRjNWxm25ZzoY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-gJKeKwYlNNmC0H1epqfImw-1; Wed, 15 Jul 2020 10:34:53 -0400
X-MC-Unique: gJKeKwYlNNmC0H1epqfImw-1
Received: by mail-wr1-f69.google.com with SMTP id j3so1464844wrq.9
        for <kvm@vger.kernel.org>; Wed, 15 Jul 2020 07:34:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gDUnF1gX4Wln5UGQpyw0DsCZrmXKbH1BJblX2g4HkKY=;
        b=nSrCPAJgnF6OFFpcONFqcYQdNN8EQgfd0PyzVMvO9ja6zMQqYyi5AiAdS0LvNOqRzO
         CgEr1mEqj3q1SxZKGlr91bhhrB4yTtcUuVF4S+Mxs45snzwJLRA+P9+nwU5Yg2B9VUKj
         iyPlIgtZnRrKL75ZXB8MzOJXwWZPOFXWXqlhhPgQz8iRqkksmtQpVSVvaS1QWca/ibPN
         h+TQ5eZSNlJpW2J1aFoOz8eOPJmEqGK5Xb2wQsQRxBfXUo6FcHOrzvlNVZfC6SzLyunq
         m8dXEek4V5p3A5/s+Kfm+Io4T3urw9EB95ti9wE9Zjb8+TUz6+qYJYVAkeWadZRofJI4
         gBoQ==
X-Gm-Message-State: AOAM532JrGjfzpspWQw/ElYlYuNmfxAXor8NR0wqJfpprT8O0gXnu0lw
        jHNBX8QOcOdbvxtPQgTqJPafNodEVBv1DRKO9W0RIUXuBY9o62nE6i6cn1c5KAi45H0slXhtSJo
        SgWSHeUjruWFj
X-Received: by 2002:a5d:6987:: with SMTP id g7mr11513367wru.79.1594823691729;
        Wed, 15 Jul 2020 07:34:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzoUwaGmSvRQhzNykS+/dS1cmb21BRdb+HUz8NopOX7oAtNCENF0Kaaj4WsT5RV7bERzyNJsQ==
X-Received: by 2002:a5d:6987:: with SMTP id g7mr11513341wru.79.1594823691514;
        Wed, 15 Jul 2020 07:34:51 -0700 (PDT)
Received: from steredhat ([5.180.207.22])
        by smtp.gmail.com with ESMTPSA id e8sm3600980wrp.26.2020.07.15.07.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 07:34:50 -0700 (PDT)
Date:   Wed, 15 Jul 2020 16:34:46 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>, davem@davemloft.net
Cc:     davem@davemloft.net, Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, kvm@vger.kernel.org
Subject: Re: [PATCH] vsock/virtio: annotate 'the_virtio_vsock' RCU pointer
Message-ID: <20200715143446.kfl3zb4vwkk4ic4r@steredhat>
References: <20200710121243.120096-1-sgarzare@redhat.com>
 <20200713065423-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713065423-mutt-send-email-mst@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 13, 2020 at 06:54:43AM -0400, Michael S. Tsirkin wrote:
> On Fri, Jul 10, 2020 at 02:12:43PM +0200, Stefano Garzarella wrote:
> > Commit 0deab087b16a ("vsock/virtio: use RCU to avoid use-after-free
> > on the_virtio_vsock") starts to use RCU to protect 'the_virtio_vsock'
> > pointer, but we forgot to annotate it.
> > 
> > This patch adds the annotation to fix the following sparse errors:
> > 
> >     net/vmw_vsock/virtio_transport.c:73:17: error: incompatible types in comparison expression (different address spaces):
> >     net/vmw_vsock/virtio_transport.c:73:17:    struct virtio_vsock [noderef] __rcu *
> >     net/vmw_vsock/virtio_transport.c:73:17:    struct virtio_vsock *
> >     net/vmw_vsock/virtio_transport.c:171:17: error: incompatible types in comparison expression (different address spaces):
> >     net/vmw_vsock/virtio_transport.c:171:17:    struct virtio_vsock [noderef] __rcu *
> >     net/vmw_vsock/virtio_transport.c:171:17:    struct virtio_vsock *
> >     net/vmw_vsock/virtio_transport.c:207:17: error: incompatible types in comparison expression (different address spaces):
> >     net/vmw_vsock/virtio_transport.c:207:17:    struct virtio_vsock [noderef] __rcu *
> >     net/vmw_vsock/virtio_transport.c:207:17:    struct virtio_vsock *
> >     net/vmw_vsock/virtio_transport.c:561:13: error: incompatible types in comparison expression (different address spaces):
> >     net/vmw_vsock/virtio_transport.c:561:13:    struct virtio_vsock [noderef] __rcu *
> >     net/vmw_vsock/virtio_transport.c:561:13:    struct virtio_vsock *
> >     net/vmw_vsock/virtio_transport.c:612:9: error: incompatible types in comparison expression (different address spaces):
> >     net/vmw_vsock/virtio_transport.c:612:9:    struct virtio_vsock [noderef] __rcu *
> >     net/vmw_vsock/virtio_transport.c:612:9:    struct virtio_vsock *
> >     net/vmw_vsock/virtio_transport.c:631:9: error: incompatible types in comparison expression (different address spaces):
> >     net/vmw_vsock/virtio_transport.c:631:9:    struct virtio_vsock [noderef] __rcu *
> >     net/vmw_vsock/virtio_transport.c:631:9:    struct virtio_vsock *
> > 
> > Fixes: 0deab087b16a ("vsock/virtio: use RCU to avoid use-after-free on the_virtio_vsock")
> > Reported-by: Michael S. Tsirkin <mst@redhat.com>
> > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> 
> 
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> 
> who's merging this? Dave?

I think so, but I forgot the 'net' tag :-(

I'll wait to see if Dave will queue this, otherwise I'll resend with
the 'net' tag.

Thanks,
Stefano

