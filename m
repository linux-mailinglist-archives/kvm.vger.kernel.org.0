Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70D7576A857
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 07:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbjHAFbc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 01:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjHAFba (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 01:31:30 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3114B2D61;
        Mon, 31 Jul 2023 22:31:03 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-686f94328a4so3078278b3a.0;
        Mon, 31 Jul 2023 22:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690867842; x=1691472642;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nqWAF22RstBS1tGS4yV0AwAq4FB3FJTFpBhfM6sE4dE=;
        b=SGjp1jBd6U+xAiBQVxPDidkD6EbzHrvMBp2VhYLTxu3exqJAEKzqU/Tb780Wrq3Ry0
         tdsGApUrGOqtMVTRHB4iGcjRj9MhvwUCFdkSctlg+wPHlqNO3HyvYh8EULZLPz0+AjOt
         xuYd0hMjkBILUV/DyHtrMwF0MYBo8tVAW8QFnbadZ63iXugnDEG0dM7VPb6LCj+ceNLE
         vJR3ODRNJliIw11rbC0Y5ZUcjqLPjEz4UBP7BWQztCtxqNXbTPnvbmMirvy3CroTYp9t
         mRC3PklfkjRBwt8yTzCiEg0hqtjJoBT6FojMhA4ihMjaNM4CDjeO6LR0EgDVr+8pLFTi
         NSVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690867842; x=1691472642;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nqWAF22RstBS1tGS4yV0AwAq4FB3FJTFpBhfM6sE4dE=;
        b=G5x6J2J41NZtfy7N4ddf+l9V6BMsXXXb+BDP6m6nESP7sVG16lQk096d2gymz16VzK
         /8OQmpY3QYlt2cF91ZHT2UHS3dwp8M49B4CxGdJ7M7u6CaPBrlQ8TpkD2lG9S7CKh1v7
         +St/Jz18I92NF4Spi0qHBt672QbQoFknchttZHhWfpcm4RIjfywzHNP0TepAPrrOUX3D
         fwxjwfgwU7nc/G5JKKMRf02A+bdzCB1oJMiED93iSycu9lDGYWbwCkvz0weolsfP9fob
         /1kqUZwwP5DdQJRACK6W2R+4P5KQOX7JwImgT+Jh23SFNZ5UvhT41Xq1l52NFottCp89
         HLbA==
X-Gm-Message-State: ABy/qLb+LdPybXcPxnyO/9XZJbOW4w35T1RHa50CyYxXw96/nVGFanp/
        bzdh7qzlQCPkOXCvaEqloYc=
X-Google-Smtp-Source: APBJJlFievjHlQxWtYiAHh/QmASEiUYMImGOwyD0Iz4AYv5+vCanWbm/6XgiBdhS0kXxv1fpeukrKw==
X-Received: by 2002:a05:6a00:16c8:b0:666:eaaf:a2af with SMTP id l8-20020a056a0016c800b00666eaafa2afmr13691945pfc.14.1690867841668;
        Mon, 31 Jul 2023 22:30:41 -0700 (PDT)
Received: from localhost (c-67-166-91-86.hsd1.wa.comcast.net. [67.166.91.86])
        by smtp.gmail.com with ESMTPSA id ey14-20020a056a0038ce00b00686bdff1d6fsm8225653pfb.77.2023.07.31.22.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 22:30:41 -0700 (PDT)
Date:   Tue, 1 Aug 2023 05:30:40 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        linux-hyperv@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Simon Horman <simon.horman@corigine.com>,
        virtualization@lists.linux-foundation.org,
        Eric Dumazet <edumazet@google.com>,
        Dan Carpenter <dan.carpenter@linaro.org>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        Jiang Wang <jiang.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH RFC net-next v5 00/14] virtio/vsock: support datagrams
Message-ID: <ZMiYgDjm0IxXglP/@bullseye>
References: <20230413-b4-vsock-dgram-v5-0-581bd37fdb26@bytedance.com>
 <20230727035004-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230727035004-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 27, 2023 at 03:51:42AM -0400, Michael S. Tsirkin wrote:
> On Wed, Jul 19, 2023 at 12:50:04AM +0000, Bobby Eshleman wrote:
> > Hey all!
> > 
> > This series introduces support for datagrams to virtio/vsock.
> > 
> > It is a spin-off (and smaller version) of this series from the summer:
> >   https://lore.kernel.org/all/cover.1660362668.git.bobby.eshleman@bytedance.com/
> > 
> > Please note that this is an RFC and should not be merged until
> > associated changes are made to the virtio specification, which will
> > follow after discussion from this series.
> > 
> > Another aside, the v4 of the series has only been mildly tested with a
> > run of tools/testing/vsock/vsock_test. Some code likely needs cleaning
> > up, but I'm hoping to get some of the design choices agreed upon before
> > spending too much time making it pretty.
> > 
> > This series first supports datagrams in a basic form for virtio, and
> > then optimizes the sendpath for all datagram transports.
> > 
> > The result is a very fast datagram communication protocol that
> > outperforms even UDP on multi-queue virtio-net w/ vhost on a variety
> > of multi-threaded workload samples.
> > 
> > For those that are curious, some summary data comparing UDP and VSOCK
> > DGRAM (N=5):
> > 
> > 	vCPUS: 16
> > 	virtio-net queues: 16
> > 	payload size: 4KB
> > 	Setup: bare metal + vm (non-nested)
> > 
> > 	UDP: 287.59 MB/s
> > 	VSOCK DGRAM: 509.2 MB/s
> > 
> > Some notes about the implementation...
> > 
> > This datagram implementation forces datagrams to self-throttle according
> > to the threshold set by sk_sndbuf. It behaves similar to the credits
> > used by streams in its effect on throughput and memory consumption, but
> > it is not influenced by the receiving socket as credits are.
> > 
> > The device drops packets silently.
> > 
> > As discussed previously, this series introduces datagrams and defers
> > fairness to future work. See discussion in v2 for more context around
> > datagrams, fairness, and this implementation.
> 
> it's a big thread - can't you summarize here?
> 

Sure, no problem. I'll add that in the next rev. For the sake of readers
here, the fairness of vsock streams and vsock datagrams per this
implementation was experimentally demonstrated to be nearly equal.

Fairness was measured as a percentage reduction of throughput on an
active and concurrent stream flow. The socket type under test (datagram
or stream) was overprovisioned into a large pool of sockets and were
exercised to maximum sending throughput. Each socket was given a unique
port and single-threaded sender to avoid any scalability differences
between datagrams and streams. Meanwhile, the throughput of a single,
lone stream socket was measured before and throughout the lifetime the
pool of sockets, to detect fairness as an amount of reduced throughput.
It was demonstrated that there was no real difference in this fairness
characteristic of datagrams and streams for vsock. In fact, datagrams
faired better (that is, datagrams were nicer to streams than streams
were to other streams), although the effect was not statistically
significant. From the design perspective, the queuing policy is always
FIFO regardless of socket type. Credits, despite being a perfect
mechanism for synchronizing send and receive buffer sizes, have no
effect on queuing fairness either.

> 
> > Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> 
> 
> could you give a bit more motivation? which applications do
> you have in mind? for example, on localhost loopback datagrams
> are actually reliable and a bunch of apps came to depend
> on that even if they shouldn't.
> 
> 

Our use case is sending various metrics from VMs to the host.
Ultimately, we just like the performance numbers we get from this
datagram implementation compared to what we get from UDP.

Currently the system is:
  producers <-> UDS <-> guest proxy <-> UDP <-> host <-> UDS <-> consumers
  ^-------- guest ----------------^ ^------------ host ------------------^

And the numbers look really promising when using vsock dgram:
  producers <-> UDS <-> guest proxy <-> VSOCK dgram <-> host <-> UDS <-> consumers
  ^-------- guest ----------------^ ^------------ host ---------------------------^

The numbers also look really promising when using sockmap in lieu of the
proxies.

Best,
Bobby

> 
> > ---
> > Changes in v5:
> > - teach vhost to drop dgram when a datagram exceeds the receive buffer
> >   - now uses MSG_ERRQUEUE and depends on Arseniy's zerocopy patch:
> > 	"vsock: read from socket's error queue"
> > - replace multiple ->dgram_* callbacks with single ->dgram_addr_init()
> >   callback
> > - refactor virtio dgram skb allocator to reduce conflicts w/ zerocopy series
> > - add _fallback/_FALLBACK suffix to dgram transport variables/macros
> > - add WARN_ONCE() for table_size / VSOCK_HASH issue
> > - add static to vsock_find_bound_socket_common
> > - dedupe code in vsock_dgram_sendmsg() using module_got var
> > - drop concurrent sendmsg() for dgram and defer to future series
> > - Add more tests
> >   - test EHOSTUNREACH in errqueue
> >   - test stream + dgram address collision
> > - improve clarity of dgram msg bounds test code
> > - Link to v4: https://lore.kernel.org/r/20230413-b4-vsock-dgram-v4-0-0cebbb2ae899@bytedance.com
> > 
> > Changes in v4:
> > - style changes
> >   - vsock: use sk_vsock(vsk) in vsock_dgram_recvmsg instead of
> >     &sk->vsk
> >   - vsock: fix xmas tree declaration
> >   - vsock: fix spacing issues
> >   - virtio/vsock: virtio_transport_recv_dgram returns void because err
> >     unused
> > - sparse analysis warnings/errors
> >   - virtio/vsock: fix unitialized skerr on destroy
> >   - virtio/vsock: fix uninitialized err var on goto out
> >   - vsock: fix declarations that need static
> >   - vsock: fix __rcu annotation order
> > - bugs
> >   - vsock: fix null ptr in remote_info code
> >   - vsock/dgram: make transport_dgram a fallback instead of first
> >     priority
> >   - vsock: remove redundant rcu read lock acquire in getname()
> > - tests
> >   - add more tests (message bounds and more)
> >   - add vsock_dgram_bind() helper
> >   - add vsock_dgram_connect() helper
> > 
> > Changes in v3:
> > - Support multi-transport dgram, changing logic in connect/bind
> >   to support VMCI case
> > - Support per-pkt transport lookup for sendto() case
> > - Fix dgram_allow() implementation
> > - Fix dgram feature bit number (now it is 3)
> > - Fix binding so dgram and connectible (cid,port) spaces are
> >   non-overlapping
> > - RCU protect transport ptr so connect() calls never leave
> >   a lockless read of the transport and remote_addr are always
> >   in sync
> > - Link to v2: https://lore.kernel.org/r/20230413-b4-vsock-dgram-v2-0-079cc7cee62e@bytedance.com
> > 
> > ---
> > Bobby Eshleman (13):
> >       af_vsock: generalize vsock_dgram_recvmsg() to all transports
> >       af_vsock: refactor transport lookup code
> >       af_vsock: support multi-transport datagrams
> >       af_vsock: generalize bind table functions
> >       af_vsock: use a separate dgram bind table
> >       virtio/vsock: add VIRTIO_VSOCK_TYPE_DGRAM
> >       virtio/vsock: add common datagram send path
> >       af_vsock: add vsock_find_bound_dgram_socket()
> >       virtio/vsock: add common datagram recv path
> >       virtio/vsock: add VIRTIO_VSOCK_F_DGRAM feature bit
> >       vhost/vsock: implement datagram support
> >       vsock/loopback: implement datagram support
> >       virtio/vsock: implement datagram support
> > 
> > Jiang Wang (1):
> >       test/vsock: add vsock dgram tests
> > 
> >  drivers/vhost/vsock.c                   |  64 ++-
> >  include/linux/virtio_vsock.h            |  10 +-
> >  include/net/af_vsock.h                  |  14 +-
> >  include/uapi/linux/virtio_vsock.h       |   2 +
> >  net/vmw_vsock/af_vsock.c                | 281 ++++++++++---
> >  net/vmw_vsock/hyperv_transport.c        |  13 -
> >  net/vmw_vsock/virtio_transport.c        |  26 +-
> >  net/vmw_vsock/virtio_transport_common.c | 190 +++++++--
> >  net/vmw_vsock/vmci_transport.c          |  60 +--
> >  net/vmw_vsock/vsock_loopback.c          |  10 +-
> >  tools/testing/vsock/util.c              | 141 ++++++-
> >  tools/testing/vsock/util.h              |   6 +
> >  tools/testing/vsock/vsock_test.c        | 680 ++++++++++++++++++++++++++++++++
> >  13 files changed, 1320 insertions(+), 177 deletions(-)
> > ---
> > base-commit: 37cadc266ebdc7e3531111c2b3304fa01b2131e8
> > change-id: 20230413-b4-vsock-dgram-3b6eba6a64e5
> > 
> > Best regards,
> > -- 
> > Bobby Eshleman <bobby.eshleman@bytedance.com>
> 
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
