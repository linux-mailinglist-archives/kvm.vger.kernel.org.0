Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33DD41C06A6
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 21:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgD3TnM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 15:43:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50780 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726415AbgD3TnM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 15:43:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588275789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=goZrpEqp3iJA4lm/Yersej+JnT7xdVa2cM94+kQqyoY=;
        b=Zb1cfWPLIB7n3SeMSq8hiSrfC6kOfbUB0biBdyhGfCzYtf/3ePGyb4McRdIB0NcjmfAduA
        6ewgjsajOZox6md0o3iHKsHC0CfBqchxk/P6GFCpnxkBXsAEU8eCD5O00s8bOGNsi17whx
        fIE1coiCRmQ8ULdGSP6ruVNHC2NpuIY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-WJU0tUkWP5aJktBj8lY18g-1; Thu, 30 Apr 2020 15:43:05 -0400
X-MC-Unique: WJU0tUkWP5aJktBj8lY18g-1
Received: by mail-wm1-f70.google.com with SMTP id s12so1423125wmj.6
        for <kvm@vger.kernel.org>; Thu, 30 Apr 2020 12:43:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=goZrpEqp3iJA4lm/Yersej+JnT7xdVa2cM94+kQqyoY=;
        b=j7OMCWhk4s6YZqtZbeaaWjrs4zB8VbTzllxBCDE0yGeyJkmjX5MTuWsNCHipcuuwgY
         +sUmMGKRo0eSR0JKgu3/6WLtKMN5OW6Utb2He4MRw54aFFCjIFc38Q4bjDrtbbJ+cl5S
         eVG56osNQTCrlyXVZ7MJJQ8Wa3/wwG5PwqUh+/EPHFBROkZ87cOUFIt6gTqQeb3xYKfe
         yJDPZ9vD6ZDZ8nQV5e//0YxbBz2azy/16uii8LIogqQi60G38mNBYIxPK9o7sgykGWAS
         s9Q/kZAN53SPwi5DJ7TQQOZ6W+LrL4o+I20EyyM7KHK6PApjoNjY6ozGO2ueRNu9wMCt
         M2lw==
X-Gm-Message-State: AGi0PuYEE3uLBa8Tx2T6jb0GkDJYwQMDO0+3My+2sQG67RLut1vk6ItN
        vLdEMbVH/bAEINL9ZDkFuEPijMK/yG+6tUoQxeRI2B0p8B/LpY/HbsdPaybWVeTT4L2k1SNydaJ
        ShZBxanFlES3z
X-Received: by 2002:adf:ff82:: with SMTP id j2mr212150wrr.96.1588275784220;
        Thu, 30 Apr 2020 12:43:04 -0700 (PDT)
X-Google-Smtp-Source: APiQypJP4633C/my4n/K8zqJjQ2v4iHZ/3Ga7TQmDfKlaDhXNPhcVGMIgFpD+nIhpUi8UUTY1AEZNw==
X-Received: by 2002:adf:ff82:: with SMTP id j2mr212131wrr.96.1588275783996;
        Thu, 30 Apr 2020 12:43:03 -0700 (PDT)
Received: from redhat.com (bzq-109-66-7-121.red.bezeqint.net. [109.66.7.121])
        by smtp.gmail.com with ESMTPSA id h6sm797729wmf.31.2020.04.30.12.43.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 12:43:03 -0700 (PDT)
Date:   Thu, 30 Apr 2020 15:43:00 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Justin He <Justin.He@arm.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kaly Xin <Kaly.Xin@arm.com>
Subject: Re: [PATCH] vhost: vsock: don't send pkt when vq is not started
Message-ID: <20200430153929-mutt-send-email-mst@kernel.org>
References: <20200430021314.6425-1-justin.he@arm.com>
 <20200430082608.wbtqgglmtnd7e5ci@steredhat>
 <AM6PR08MB4069D4AB611B8C8180DC4B9CF7AA0@AM6PR08MB4069.eurprd08.prod.outlook.com>
 <20200430162521.k4b4t3vttfabgqal@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200430162521.k4b4t3vttfabgqal@steredhat>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 30, 2020 at 06:25:21PM +0200, Stefano Garzarella wrote:
> On Thu, Apr 30, 2020 at 10:06:26AM +0000, Justin He wrote:
> > Hi Stefano
> > 
> > > -----Original Message-----
> > > From: Stefano Garzarella <sgarzare@redhat.com>
> > > Sent: Thursday, April 30, 2020 4:26 PM
> > > To: Justin He <Justin.He@arm.com>
> > > Cc: Stefan Hajnoczi <stefanha@redhat.com>; Michael S. Tsirkin
> > > <mst@redhat.com>; Jason Wang <jasowang@redhat.com>;
> > > kvm@vger.kernel.org; virtualization@lists.linux-foundation.org;
> > > netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Kaly Xin
> > > <Kaly.Xin@arm.com>
> > > Subject: Re: [PATCH] vhost: vsock: don't send pkt when vq is not started
> > >
> > > Hi Jia,
> > > thanks for the patch, some comments below:
> > >
> > > On Thu, Apr 30, 2020 at 10:13:14AM +0800, Jia He wrote:
> > > > Ning Bo reported an abnormal 2-second gap when booting Kata container
> > > [1].
> > > > The unconditional timeout is caused by
> > > VSOCK_DEFAULT_CONNECT_TIMEOUT of
> > > > connect at client side. The vhost vsock client tries to connect an
> > > > initlizing virtio vsock server.
> > > >
> > > > The abnormal flow looks like:
> > > > host-userspace           vhost vsock                       guest vsock
> > > > ==============           ===========                       ============
> > > > connect()     -------->  vhost_transport_send_pkt_work()   initializing
> > > >    |                     vq->private_data==NULL
> > > >    |                     will not be queued
> > > >    V
> > > > schedule_timeout(2s)
> > > >                          vhost_vsock_start()  <---------   device ready
> > > >                          set vq->private_data
> > > >
> > > > wait for 2s and failed
> > > >
> > > > connect() again          vq->private_data!=NULL          recv connecting pkt
> > > >
> > > > 1. host userspace sends a connect pkt, at that time, guest vsock is under
> > > > initializing, hence the vhost_vsock_start has not been called. So
> > > > vq->private_data==NULL, and the pkt is not been queued to send to guest.
> > > > 2. then it sleeps for 2s
> > > > 3. after guest vsock finishes initializing, vq->private_data is set.
> > > > 4. When host userspace wakes up after 2s, send connecting pkt again,
> > > > everything is fine.
> > > >
> > > > This fixes it by checking vq->private_data in vhost_transport_send_pkt,
> > > > and return at once if !vq->private_data. This makes user connect()
> > > > be returned with ECONNREFUSED.
> > > >
> > > > After this patch, kata-runtime (with vsock enabled) boottime reduces from
> > > > 3s to 1s on ThunderX2 arm64 server.
> > > >
> > > > [1] https://github.com/kata-containers/runtime/issues/1917
> > > >
> > > > Reported-by: Ning Bo <n.b@live.com>
> > > > Signed-off-by: Jia He <justin.he@arm.com>
> > > > ---
> > > >  drivers/vhost/vsock.c | 8 ++++++++
> > > >  1 file changed, 8 insertions(+)
> > > >
> > > > diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> > > > index e36aaf9ba7bd..67474334dd88 100644
> > > > --- a/drivers/vhost/vsock.c
> > > > +++ b/drivers/vhost/vsock.c
> > > > @@ -241,6 +241,7 @@ vhost_transport_send_pkt(struct virtio_vsock_pkt
> > > *pkt)
> > > >  {
> > > >  struct vhost_vsock *vsock;
> > > >  int len = pkt->len;
> > > > +struct vhost_virtqueue *vq;
> > > >
> > > >  rcu_read_lock();
> > > >
> > > > @@ -252,6 +253,13 @@ vhost_transport_send_pkt(struct virtio_vsock_pkt
> > > *pkt)
> > > >  return -ENODEV;
> > > >  }
> > > >
> > > > +vq = &vsock->vqs[VSOCK_VQ_RX];
> > > > +if (!vq->private_data) {
> > >
> > > I think is better to use vhost_vq_get_backend():
> > >
> > > if (!vhost_vq_get_backend(&vsock->vqs[VSOCK_VQ_RX])) {
> > > ...
> > >
> > > This function should be called with 'vq->mutex' acquired as explained in
> > > the comment, but here we can avoid that, because we are not using the vq,
> > > so it is safe, because in vhost_transport_do_send_pkt() we check it again.
> > >
> > > Please add a comment explaining that.
> > >
> > 
> > Thanks, vhost_vq_get_backend is better. I chose a 5.3 kernel to develop
> > and missed this helper.
> 
> :-)
> 
> > >
> > > As an alternative to this patch, should we kick the send worker when the
> > > device is ready?
> > >
> > > IIUC we reach the timeout because the send worker (that runs
> > > vhost_transport_do_send_pkt()) exits immediately since 'vq->private_data'
> > > is NULL, and no one will requeue it.
> > >
> > > Let's do it when we know the device is ready:
> > >
> > > diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> > > index e36aaf9ba7bd..295b5867944f 100644
> > > --- a/drivers/vhost/vsock.c
> > > +++ b/drivers/vhost/vsock.c
> > > @@ -543,6 +543,11 @@ static int vhost_vsock_start(struct vhost_vsock
> > > *vsock)
> > >                 mutex_unlock(&vq->mutex);
> > >         }
> > >
> > > +       /* Some packets may have been queued before the device was started,
> > > +        * let's kick the send worker to send them.
> > > +        */
> > > +       vhost_work_queue(&vsock->dev, &vsock->send_pkt_work);
> > > +
> > Yes, it works.
> > But do you think a threshold should be set here to prevent the queue
> > from being too long? E.g. the client user sends too many connect pkts
> > in a short time before the server is completely ready.
> 
> When the user call the connect() the socket status is moved to
> SS_CONNECTING (see net/vmw_vsock/af_vsock.c), so another connect() on
> the same socket will receive EALREADY error.
> 
> If the user uses multiple sockets, the socket layer already check for
> any limits, so I don't think we should put a threshold here.
> 
> > 
> > >         mutex_unlock(&vsock->dev.mutex);
> > >         return 0;
> > >
> > > I didn't test it, can you try if it fixes the issue?
> > >
> > > I'm not sure which is better...
> > I don't know, either. Wait for more comments 😊
> 
> I prefer the second option, because the device is in a transitional
> state and a connect can block (for at most two seconds) until the device is
> started.
> 
> For the first option, I'm also not sure if ECONNREFUSED is the right error
> to return, maybe is better ENETUNREACH.
> 
> Cheers,
> Stefano

IIRC:

ECONNREFUSED is what one gets when connecting to remote a port which does not
yet have a listening socket, so remote sends back RST.
ENETUNREACH is when local network's down, so you can't even send a
connection request.
EHOSTUNREACH is remote network is down.

-- 
MST

