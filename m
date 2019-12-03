Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3000510FC58
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 12:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbfLCLRr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 06:17:47 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37011 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725907AbfLCLRr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Dec 2019 06:17:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575371866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P0GMfVL6QAezA2eT0aIWQXB/37RirCO0eO2hEzXqpFM=;
        b=Cga3+xGIlpKFqnJN76FN5zrpazIlrdV6ZUoM4tLEhO+OHkSXsHtQlw1N+l4y3a2dDd8S7c
        azHacOdSAL27ZQOhfqNX4t2WmTDvuMbdEZ2Q3nOxGfCgGnfjxAQSGgHk/oJztaSML8XqFj
        N3WO7FgBcpP8RcRQTHTnZltnLlDKl7Q=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-eqRIC0KgPxazy3e6q5U4iA-1; Tue, 03 Dec 2019 06:17:44 -0500
Received: by mail-wr1-f71.google.com with SMTP id z10so1587378wrt.21
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2019 03:17:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8m7nF4w29pgZQB4V/SdwIROmAwTn+h+KHeQv4HnXE8M=;
        b=VqANa/QnSe0eG8oNUwvVFbOY2mR+pngsjJGYNOjgGPRT4dFx5qkI5bMb3yd2tyz8mR
         iOIdq3129X9ZixTTFGO9YISWoNh3y96lXtw+DflH7itlPeIkRoZqNqlbh2AqtKKIsspL
         kG0OrY9OOm8gKf5Kqed053ZTpxnPmfJac4DKbhY0gVkR1wS/5pztFx5CO+eOCy2ml6TB
         b2G5Oqwx2eE3mCd9aEb3jxSGV2rxmUoDDg+ZgoppdbbfBFUhKmgnYswMDjLAKw+e0pLC
         4yaOKvrESoCFWKrzKh8PwCVo/nm5ReaETJu7SXaoEDrq0BhsJdDim+ALmur0O4VZKWh8
         LaCw==
X-Gm-Message-State: APjAAAXETj8lanhxTznEKm+rFsaKiORK1yFXVNOpzhytZciZCUA42RON
        /vwhvRz8lYWOF8MmGixYk1m+RBpp22ovFGdCUKXV6gHQtUw7LozbbB7Gobn88gNp/iFgFTADN3u
        xlxkbZbb9LQBk
X-Received: by 2002:a5d:49c7:: with SMTP id t7mr4444056wrs.369.1575371862793;
        Tue, 03 Dec 2019 03:17:42 -0800 (PST)
X-Google-Smtp-Source: APXvYqxHsfuHbTjkQH8eviKJ48+Nlp7C/1JLX3I4FiWaDe4+xpQuoyOM0/YkQJewOzX/cskP8i9LEw==
X-Received: by 2002:a5d:49c7:: with SMTP id t7mr4444037wrs.369.1575371862537;
        Tue, 03 Dec 2019 03:17:42 -0800 (PST)
Received: from steredhat (host28-88-dynamic.16-87-r.retail.telecomitalia.it. [87.16.88.28])
        by smtp.gmail.com with ESMTPSA id p17sm3209682wrx.20.2019.12.03.03.17.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 03:17:41 -0800 (PST)
Date:   Tue, 3 Dec 2019 12:17:39 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     netdev@vger.kernel.org, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Dexuan Cui <decui@microsoft.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: Re: [RFC PATCH 0/3] vsock: support network namespace
Message-ID: <20191203111739.jbxptcpmvtwg7j2g@steredhat>
References: <20191128171519.203979-1-sgarzare@redhat.com>
 <20191203092649.GB153510@stefanha-x1.localdomain>
MIME-Version: 1.0
In-Reply-To: <20191203092649.GB153510@stefanha-x1.localdomain>
X-MC-Unique: eqRIC0KgPxazy3e6q5U4iA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 03, 2019 at 09:26:49AM +0000, Stefan Hajnoczi wrote:
> On Thu, Nov 28, 2019 at 06:15:16PM +0100, Stefano Garzarella wrote:
> > Hi,
> > now that we have multi-transport upstream, I started to take a look to
> > support network namespace (netns) in vsock.
> >=20
> > As we partially discussed in the multi-transport proposal [1], it could
> > be nice to support network namespace in vsock to reach the following
> > goals:
> > - isolate host applications from guest applications using the same port=
s
> >   with CID_ANY
> > - assign the same CID of VMs running in different network namespaces
> > - partition VMs between VMMs or at finer granularity
> >=20
> > This preliminary implementation provides the following behavior:
> > - packets received from the host (received by G2H transports) are
> >   assigned to the default netns (init_net)
> > - packets received from the guest (received by H2G - vhost-vsock) are
> >   assigned to the netns of the process that opens /dev/vhost-vsock
> >   (usually the VMM, qemu in my tests, opens the /dev/vhost-vsock)
> >     - for vmci I need some suggestions, because I don't know how to do
> >       and test the same in the vmci driver, for now vmci uses the
> >       init_net
> > - loopback packets are exchanged only in the same netns
> >=20
> > Questions:
> > 1. Should we make configurable the netns (now it is init_net) where
> >    packets from the host should be delivered?
>=20
> Yes, it should be possible to have multiple G2H (e.g. virtio-vsock)
> devices and to assign them to different net namespaces.  Something like
> net/core/dev.c:dev_change_net_namespace() will eventually be needed.
>=20

Make sense, but for now we support only one G2H.
How we can provide this feature to the userspace?
Should we interface vsock with ip-link(8)?

I don't know if initially we can provide through sysfs a way to set the
netns of the only G2H loaded.

> > 2. Should we provide an ioctl in vhost-vsock to configure the netns
> >    to use? (instead of using the netns of the process that opens
> >    /dev/vhost-vsock)
>=20
> Creating the vhost-vsock instance in the process' net namespace makes
> sense.  Maybe wait for a use case before adding an ioctl.
>=20

Agree.

> > 3. Should we provide a way to disable the netns support in vsock?
>=20
> The code should follow CONFIG_NET_NS semantics.  I'm not sure what they
> are exactly since struct net is always defined, regardless of whether
> network namespaces are enabled.

I think that if CONFIG_NET_NS is not defined, all sockets and processes
are assigned to init_net and this RFC should work in this case, but I'll
try this case before v1.

I was thinking about the Kata's use case, I don't know if they launch the
VM in a netns and even the runtime in the host runs inside the same netns.

I'll send an e-mail to kata mailing list.

Thanks,
Stefano

