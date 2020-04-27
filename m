Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4D81BA64D
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 16:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbgD0OZi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 10:25:38 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:57863 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727104AbgD0OZf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Apr 2020 10:25:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587997532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G2OKqHupmsX6p6eOVsvAeEE5c4vTAldIJ9QKI6xeIiI=;
        b=XEbYlLxhVEJbyb/H5a89UsZmZ715k/yneNwCCZHVPl1COF+Ubb9xzBk2OkkV9jdukiCJuX
        ly9O2ZbFtaYI5IAWU7f13RJDfPUdNv/0vkqpJrH7ZzC0eJXl785NIFS7TiW5oHvzgo1bPl
        wrmHpZ9J54ci3gvjD0AbE7EE8PB1tE8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-uCzr8ur1OmuyWvVe41fcfw-1; Mon, 27 Apr 2020 10:25:23 -0400
X-MC-Unique: uCzr8ur1OmuyWvVe41fcfw-1
Received: by mail-wr1-f72.google.com with SMTP id f2so10609937wrm.9
        for <kvm@vger.kernel.org>; Mon, 27 Apr 2020 07:25:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=G2OKqHupmsX6p6eOVsvAeEE5c4vTAldIJ9QKI6xeIiI=;
        b=YPf/zad1k6mi9XbpgnRXeE8V2QAx/gfEsw6jVKqosx9/hAES6kubskydWHqXDskHDO
         km0/xaq+UAhwm15/NaAPDUI1g+PSYlRBhKBIlsQ7IIN0BV1fS+cFtNzT1+nqP6o5bvFm
         wRxjdU1PG760JYSk/awgKPhxWEjBPr8OrcOWcPVzRSjsqAb+Yn8XeQQQ+NCFr7lgnWNV
         qCEtU2j2PI0JYZyY9aCuE11BJZfcKc7OkNcCLoQd5zOhZbBYFlYwatoafRnx7cFUC4Yz
         RQloeWWZvPIZH8ImYKUfIkfll9ucWFGrtsWPfToN3Nhiy7N9SKHFPPcz6V7JyckFojva
         eACg==
X-Gm-Message-State: AGi0PuZtqA9IqeK0XpCXghGYogxTKQztlF/HsvU7b2X73FTzCfYq0qlJ
        hQbaJzSUekZpgnWeQCZd1gLpGqDOieFBu04dePuhIUx4tCwhDPOnUVc/wvJ4gTg7nkJj+3IKGH6
        Q6Jp4RSxn4IQN
X-Received: by 2002:a1c:ed04:: with SMTP id l4mr26738558wmh.93.1587997522578;
        Mon, 27 Apr 2020 07:25:22 -0700 (PDT)
X-Google-Smtp-Source: APiQypIxTLUJV76JfSV7akvjZLc8gxRNuDLQT/3botMuSslAXyKAEmVDR+5C/do/K4W5YD7K308fCA==
X-Received: by 2002:a1c:ed04:: with SMTP id l4mr26738539wmh.93.1587997522273;
        Mon, 27 Apr 2020 07:25:22 -0700 (PDT)
Received: from steredhat (host108-207-dynamic.49-79-r.retail.telecomitalia.it. [79.49.207.108])
        by smtp.gmail.com with ESMTPSA id m1sm20657589wro.64.2020.04.27.07.25.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 07:25:21 -0700 (PDT)
Date:   Mon, 27 Apr 2020 16:25:18 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     davem@davemloft.net, Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Jorgen Hansen <jhansen@vmware.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-hyperv@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] vsock: support network namespace
Message-ID: <20200427142518.uwssa6dtasrp3bfc@steredhat>
References: <20200116172428.311437-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116172428.311437-1-sgarzare@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi David, Michael, Stefan,
I'm restarting to work on this topic since Kata guys are interested to
have that, especially on the guest side.

While working on the v2 I had few doubts, and I'd like to have your
suggestions:

 1. netns assigned to the device inside the guest

   Currently I assigned this device to 'init_net'. Maybe it is better
   if we allow the user to decide which netns assign to the device
   or to disable this new feature to have the same behavior as before
   (host reachable from any netns).
   I think we can handle this in the vsock core and not in the single
   transports.

   The simplest way that I found, is to add a new
   IOCTL_VM_SOCKETS_ASSIGN_G2H_NETNS to /dev/vsock to enable the feature
   and assign the device to the same netns of the process that do the
   ioctl(), but I'm not sure it is clean enough.

   Maybe it is better to add new rtnetlink messages, but I'm not sure if
   it is feasible since we don't have a netdev device.

   What do you suggest?


 2. netns assigned in the host

    As Michael suggested, I added a new /dev/vhost-vsock-netns to allow
    userspace application to use this new feature, leaving to
    /dev/vhost-vsock the previous behavior (guest reachable from any
    netns).

    I like this approach, but I had these doubts:

    - I need to allocate a new minor for that device (e.g.
      VHOST_VSOCK_NETNS_MINOR) or is there an alternative way that I can
      use?

    - It is vhost-vsock specific, should we provide something handled in
      the vsock core, maybe centralizing the CID allocation and adding a
      new IOCTL or rtnetlink message like for the guest side?
      (maybe it could be a second step, and for now we can continue with
      the new device)


Thanks for the help,
Stefano


On Thu, Jan 16, 2020 at 06:24:25PM +0100, Stefano Garzarella wrote:
> RFC -> v1:
>  * added 'netns' module param to vsock.ko to enable the
>    network namespace support (disabled by default)
>  * added 'vsock_net_eq()' to check the "net" assigned to a socket
>    only when 'netns' support is enabled
> 
> RFC: https://patchwork.ozlabs.org/cover/1202235/
> 
> Now that we have multi-transport upstream, I started to take a look to
> support network namespace in vsock.
> 
> As we partially discussed in the multi-transport proposal [1], it could
> be nice to support network namespace in vsock to reach the following
> goals:
> - isolate host applications from guest applications using the same ports
>   with CID_ANY
> - assign the same CID of VMs running in different network namespaces
> - partition VMs between VMMs or at finer granularity
> 
> This new feature is disabled by default, because it changes vsock's
> behavior with network namespaces and could break existing applications.
> It can be enabled with the new 'netns' module parameter of vsock.ko.
> 
> This implementation provides the following behavior:
> - packets received from the host (received by G2H transports) are
>   assigned to the default netns (init_net)
> - packets received from the guest (received by H2G - vhost-vsock) are
>   assigned to the netns of the process that opens /dev/vhost-vsock
>   (usually the VMM, qemu in my tests, opens the /dev/vhost-vsock)
>     - for vmci I need some suggestions, because I don't know how to do
>       and test the same in the vmci driver, for now vmci uses the
>       init_net
> - loopback packets are exchanged only in the same netns
> 
> I tested the series in this way:
> l0_host$ qemu-system-x86_64 -m 4G -M accel=kvm -smp 4 \
>             -drive file=/tmp/vsockvm0.img,if=virtio --nographic \
>             -device vhost-vsock-pci,guest-cid=3
> 
> l1_vm$ echo 1 > /sys/module/vsock/parameters/netns
> 
> l1_vm$ ip netns add ns1
> l1_vm$ ip netns add ns2
>  # same CID on different netns
> l1_vm$ ip netns exec ns1 qemu-system-x86_64 -m 1G -M accel=kvm -smp 2 \
>             -drive file=/tmp/vsockvm1.img,if=virtio --nographic \
>             -device vhost-vsock-pci,guest-cid=4
> l1_vm$ ip netns exec ns2 qemu-system-x86_64 -m 1G -M accel=kvm -smp 2 \
>             -drive file=/tmp/vsockvm2.img,if=virtio --nographic \
>             -device vhost-vsock-pci,guest-cid=4
> 
>  # all iperf3 listen on CID_ANY and port 5201, but in different netns
> l1_vm$ ./iperf3 --vsock -s # connection from l0 or guests started
>                            # on default netns (init_net)
> l1_vm$ ip netns exec ns1 ./iperf3 --vsock -s
> l1_vm$ ip netns exec ns1 ./iperf3 --vsock -s
> 
> l0_host$ ./iperf3 --vsock -c 3
> l2_vm1$ ./iperf3 --vsock -c 2
> l2_vm2$ ./iperf3 --vsock -c 2
> 
> [1] https://www.spinics.net/lists/netdev/msg575792.html
> 
> Stefano Garzarella (3):
>   vsock: add network namespace support
>   vsock/virtio_transport_common: handle netns of received packets
>   vhost/vsock: use netns of process that opens the vhost-vsock device
> 
>  drivers/vhost/vsock.c                   | 29 ++++++++++++-----
>  include/linux/virtio_vsock.h            |  2 ++
>  include/net/af_vsock.h                  |  7 +++--
>  net/vmw_vsock/af_vsock.c                | 41 +++++++++++++++++++------
>  net/vmw_vsock/hyperv_transport.c        |  5 +--
>  net/vmw_vsock/virtio_transport.c        |  2 ++
>  net/vmw_vsock/virtio_transport_common.c | 12 ++++++--
>  net/vmw_vsock/vmci_transport.c          |  5 +--
>  8 files changed, 78 insertions(+), 25 deletions(-)
> 
> -- 
> 2.24.1
> 

