Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3270675DB21
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 10:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjGVIvm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Jul 2023 04:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjGVIvl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Jul 2023 04:51:41 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C803226A5;
        Sat, 22 Jul 2023 01:51:38 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-4fa16c6a85cso4220146e87.3;
        Sat, 22 Jul 2023 01:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690015897; x=1690620697;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QyYUMX0Di+DYHpFJu8zvRU6It7/9y7UIhzZCenvkn0o=;
        b=PyACiV3FFTcr3SXC45LvL0AMrRejdovuWeJyIdUJq4Ntmpjp5tyxrQlkvsrPxcazyo
         9XJWOsLfbjH5ZX8+hwn/L5XiGN7zdXwVOsTG4muw56tiw2n0siY7doXTRL+yPUHhQhe8
         4/riAhBHiwge2ju/lh5Opp72mIilzAnseQHtSJcd2UeHXQxQhaEq4pEaRBBa90S3yQF7
         ajoveOW6QI03LDikm+Kum1HSOdRC9yoFmI3mpOnB1ljOc9h836t8jQmwOeV5D0xEdxmo
         Y46dxWa+QQ/3q/f6UswTlfGFy2qm4Vq/b57NXPCvqheu6SkWd0FcmMCxm8MK0pz8Mo1p
         mdUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690015897; x=1690620697;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QyYUMX0Di+DYHpFJu8zvRU6It7/9y7UIhzZCenvkn0o=;
        b=eVxWpbWoPtNWocQsDms61MQvz5TVHiR59cS7IUbq5wZm2M6Xm/YHl+c6VEpc5kkOf5
         k23sFZdYapJ0jqicf5cYh+8ceJmx0UEPVQYtX9H5NBKUzBTCVlukRpKCFHORj+JTgz88
         KAdZkP2kRR2QHZ8wjhaCsEGK3dmiTg51XbxRmcySrfuFp6y6Nf+M82RMZlgIoaPpIR+h
         tG0Y/jhzsW84fs/ufqvm1/cb9MnKcsspiGU/2ds/sGmlScaBzd3rQgAjCRBa7bqwh6ch
         VCvZ6gePK+U1MMNN/jWb99WfCqSt9chVDuu8XzkFphwlU63nmiKIRb8eDba49l4W4bv5
         546A==
X-Gm-Message-State: ABy/qLar3l+fzfyaOXSTveBdw/LV7guVHHAIx9+M3TmrIFrbKxCCE5Ec
        rgjOthHVzqScqU8PVgZ2u08=
X-Google-Smtp-Source: APBJJlHZiay/vG5qJe7SYemuevXI5WIiusNMSOjqJB85qcc9x4u5uZvontbXoDTx18+kimnguQRLYw==
X-Received: by 2002:a05:6512:e9a:b0:4f6:1433:fca0 with SMTP id bi26-20020a0565120e9a00b004f61433fca0mr3008113lfb.0.1690015896866;
        Sat, 22 Jul 2023 01:51:36 -0700 (PDT)
Received: from ?IPV6:2a00:1e88:c228:ec00:1b41:4959:c1a0:b9eb? ([2a00:1e88:c228:ec00:1b41:4959:c1a0:b9eb])
        by smtp.gmail.com with ESMTPSA id v15-20020a056512048f00b004fbbf9e58bbsm1123695lfq.126.2023.07.22.01.51.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Jul 2023 01:51:36 -0700 (PDT)
Message-ID: <713f3fe4-2249-2d13-c25f-5a6f673201da@gmail.com>
Date:   Sat, 22 Jul 2023 11:51:34 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH RFC net-next v5 00/14] virtio/vsock: support datagrams
Content-Language: en-US
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
Cc:     Dan Carpenter <dan.carpenter@linaro.org>,
        Simon Horman <simon.horman@corigine.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        bpf@vger.kernel.org, Jiang Wang <jiang.wang@bytedance.com>
References: <20230413-b4-vsock-dgram-v5-0-581bd37fdb26@bytedance.com>
From:   Arseniy Krasnov <oxffffaa@gmail.com>
In-Reply-To: <20230413-b4-vsock-dgram-v5-0-581bd37fdb26@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Bobby!

Thanks for this patchset! I left some comments and continue review and tests in
the next few days

Thanks, Arseniy

On 19.07.2023 03:50, Bobby Eshleman wrote:
> Hey all!
> 
> This series introduces support for datagrams to virtio/vsock.
> 
> It is a spin-off (and smaller version) of this series from the summer:
>   https://lore.kernel.org/all/cover.1660362668.git.bobby.eshleman@bytedance.com/
> 
> Please note that this is an RFC and should not be merged until
> associated changes are made to the virtio specification, which will
> follow after discussion from this series.
> 
> Another aside, the v4 of the series has only been mildly tested with a
> run of tools/testing/vsock/vsock_test. Some code likely needs cleaning
> up, but I'm hoping to get some of the design choices agreed upon before
> spending too much time making it pretty.
> 
> This series first supports datagrams in a basic form for virtio, and
> then optimizes the sendpath for all datagram transports.
> 
> The result is a very fast datagram communication protocol that
> outperforms even UDP on multi-queue virtio-net w/ vhost on a variety
> of multi-threaded workload samples.
> 
> For those that are curious, some summary data comparing UDP and VSOCK
> DGRAM (N=5):
> 
> 	vCPUS: 16
> 	virtio-net queues: 16
> 	payload size: 4KB
> 	Setup: bare metal + vm (non-nested)
> 
> 	UDP: 287.59 MB/s
> 	VSOCK DGRAM: 509.2 MB/s
> 
> Some notes about the implementation...
> 
> This datagram implementation forces datagrams to self-throttle according
> to the threshold set by sk_sndbuf. It behaves similar to the credits
> used by streams in its effect on throughput and memory consumption, but
> it is not influenced by the receiving socket as credits are.
> 
> The device drops packets silently.
> 
> As discussed previously, this series introduces datagrams and defers
> fairness to future work. See discussion in v2 for more context around
> datagrams, fairness, and this implementation.
> 
> Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> ---
> Changes in v5:
> - teach vhost to drop dgram when a datagram exceeds the receive buffer
>   - now uses MSG_ERRQUEUE and depends on Arseniy's zerocopy patch:
> 	"vsock: read from socket's error queue"
> - replace multiple ->dgram_* callbacks with single ->dgram_addr_init()
>   callback
> - refactor virtio dgram skb allocator to reduce conflicts w/ zerocopy series
> - add _fallback/_FALLBACK suffix to dgram transport variables/macros
> - add WARN_ONCE() for table_size / VSOCK_HASH issue
> - add static to vsock_find_bound_socket_common
> - dedupe code in vsock_dgram_sendmsg() using module_got var
> - drop concurrent sendmsg() for dgram and defer to future series
> - Add more tests
>   - test EHOSTUNREACH in errqueue
>   - test stream + dgram address collision
> - improve clarity of dgram msg bounds test code
> - Link to v4: https://lore.kernel.org/r/20230413-b4-vsock-dgram-v4-0-0cebbb2ae899@bytedance.com
> 
> Changes in v4:
> - style changes
>   - vsock: use sk_vsock(vsk) in vsock_dgram_recvmsg instead of
>     &sk->vsk
>   - vsock: fix xmas tree declaration
>   - vsock: fix spacing issues
>   - virtio/vsock: virtio_transport_recv_dgram returns void because err
>     unused
> - sparse analysis warnings/errors
>   - virtio/vsock: fix unitialized skerr on destroy
>   - virtio/vsock: fix uninitialized err var on goto out
>   - vsock: fix declarations that need static
>   - vsock: fix __rcu annotation order
> - bugs
>   - vsock: fix null ptr in remote_info code
>   - vsock/dgram: make transport_dgram a fallback instead of first
>     priority
>   - vsock: remove redundant rcu read lock acquire in getname()
> - tests
>   - add more tests (message bounds and more)
>   - add vsock_dgram_bind() helper
>   - add vsock_dgram_connect() helper
> 
> Changes in v3:
> - Support multi-transport dgram, changing logic in connect/bind
>   to support VMCI case
> - Support per-pkt transport lookup for sendto() case
> - Fix dgram_allow() implementation
> - Fix dgram feature bit number (now it is 3)
> - Fix binding so dgram and connectible (cid,port) spaces are
>   non-overlapping
> - RCU protect transport ptr so connect() calls never leave
>   a lockless read of the transport and remote_addr are always
>   in sync
> - Link to v2: https://lore.kernel.org/r/20230413-b4-vsock-dgram-v2-0-079cc7cee62e@bytedance.com
> 
> ---
> Bobby Eshleman (13):
>       af_vsock: generalize vsock_dgram_recvmsg() to all transports
>       af_vsock: refactor transport lookup code
>       af_vsock: support multi-transport datagrams
>       af_vsock: generalize bind table functions
>       af_vsock: use a separate dgram bind table
>       virtio/vsock: add VIRTIO_VSOCK_TYPE_DGRAM
>       virtio/vsock: add common datagram send path
>       af_vsock: add vsock_find_bound_dgram_socket()
>       virtio/vsock: add common datagram recv path
>       virtio/vsock: add VIRTIO_VSOCK_F_DGRAM feature bit
>       vhost/vsock: implement datagram support
>       vsock/loopback: implement datagram support
>       virtio/vsock: implement datagram support
> 
> Jiang Wang (1):
>       test/vsock: add vsock dgram tests
> 
>  drivers/vhost/vsock.c                   |  64 ++-
>  include/linux/virtio_vsock.h            |  10 +-
>  include/net/af_vsock.h                  |  14 +-
>  include/uapi/linux/virtio_vsock.h       |   2 +
>  net/vmw_vsock/af_vsock.c                | 281 ++++++++++---
>  net/vmw_vsock/hyperv_transport.c        |  13 -
>  net/vmw_vsock/virtio_transport.c        |  26 +-
>  net/vmw_vsock/virtio_transport_common.c | 190 +++++++--
>  net/vmw_vsock/vmci_transport.c          |  60 +--
>  net/vmw_vsock/vsock_loopback.c          |  10 +-
>  tools/testing/vsock/util.c              | 141 ++++++-
>  tools/testing/vsock/util.h              |   6 +
>  tools/testing/vsock/vsock_test.c        | 680 ++++++++++++++++++++++++++++++++
>  13 files changed, 1320 insertions(+), 177 deletions(-)
> ---
> base-commit: 37cadc266ebdc7e3531111c2b3304fa01b2131e8
> change-id: 20230413-b4-vsock-dgram-3b6eba6a64e5
> 
> Best regards,
