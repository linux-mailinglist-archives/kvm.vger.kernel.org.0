Return-Path: <kvm+bounces-587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 28EE97E1097
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 19:28:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A7A01C20A7A
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 18:28:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C06A823753;
	Sat,  4 Nov 2023 18:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="ScwqdFiH"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB0122301
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 18:28:35 +0000 (UTC)
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666B9D45
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 11:28:32 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-6bd0e1b1890so2624153b3a.3
        for <kvm@vger.kernel.org>; Sat, 04 Nov 2023 11:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1699122512; x=1699727312; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1Raflo2MBCaVxBeRy7GF6tekllGnegpXQwpqv2rpEa4=;
        b=ScwqdFiHbXZNgbXoMVlLHyOWjkB3JCmJGcSM1LgTY1yV3eOfjh0d7ddz0j74dkmzGp
         xQHsfNaSo7NW+aSpEV0GV7/H4XAHxPjN/ZxqhlI3ACUhkiWgI1+PkzyueL1yMM1gkq2J
         S2UZBkIwbFO7sNJYOz9XivhzOkvLm47TrjhcWt5NVuX0/XAkO8R57XmCTXKxZLNSC0zW
         FCfGnHlJClnbdX79VS2+azRCS0eqY9oMSz34+IDKZ4H+sZaG8J8ZWbPIIsxpCgbdgu5T
         9Q5rPh21kJ+6FwfB6JUPBS5YC9TJsLDGc9z+e5SXy3szoiANAZwhEBXuulcyQzCRvNkL
         aeow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699122512; x=1699727312;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1Raflo2MBCaVxBeRy7GF6tekllGnegpXQwpqv2rpEa4=;
        b=TgIC6b/c6DFrcAe8DwYfB5JVKBrcEf06Pul+g8FUH1U+5WQbKfIVMYgRcGCreGMEVv
         ySo6JVIqgtXPW7jKSmjOHclrusAq0ZLmjY5MwJWxRWC5dCPdDdXeH/Fog88L9Jl4S8pS
         owkjdw19s+4RDob4oROJsLABEDV2Do0UZjjTQaeoEjh7I2grwAAukxPMzZFZjGu6vjre
         RKEZ7za4/ZCxbs3JJD3hi+DGfa7P8Ppcr2Df0i/7CVwvOh0zlds1ZdHHdKtWk74jaTAQ
         vedF4IXN2H3mtuviOm8wBVfZYAFLVrvis8sGrH0wtOMHJcpsgo1SdrKvjS7G6LuuVXIr
         gnXg==
X-Gm-Message-State: AOJu0YzitQ1PEOVCWpcphGNrib5WaTfWb0RreOiXCqwRuDxQFVnr0D2d
	/3TbAXuRc4OJl6AP7ok/fELZ1+E8/Hw8iqSsrUZlpyvN
X-Google-Smtp-Source: AGHT+IGaDGG/WtGKuZ1zNNq+ppYZY512/uaLCsfdkoU+LYbpvTT3T/3A11TecaxZQDaizKJ+OJEyaA==
X-Received: by 2002:a05:6a00:3a0e:b0:6c3:402a:d54d with SMTP id fj14-20020a056a003a0e00b006c3402ad54dmr6843336pfb.11.1699122511816;
        Sat, 04 Nov 2023 11:28:31 -0700 (PDT)
Received: from ?IPV6:2620:10d:c085:21e1::1052? ([2620:10d:c090:400::4:56eb])
        by smtp.gmail.com with ESMTPSA id h1-20020a056a00230100b006889511ab14sm3187642pfh.37.2023.11.04.11.28.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Nov 2023 11:28:31 -0700 (PDT)
Message-ID: <67c45ff3-4f98-4ca5-bd68-2d90cc52a775@davidwei.uk>
Date: Sat, 4 Nov 2023 11:28:28 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v2] virtio/vsock: Fix uninit-value in
 virtio_transport_recv_pkt()
To: Shigeru Yoshida <syoshida@redhat.com>, stefanha@redhat.com,
 sgarzare@redhat.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+0c8ce1da0ac31abbadcd@syzkaller.appspotmail.com
References: <20231104150531.257952-1-syoshida@redhat.com>
Content-Language: en-GB
From: David Wei <dw@davidwei.uk>
In-Reply-To: <20231104150531.257952-1-syoshida@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2023-11-04 08:05, Shigeru Yoshida wrote:
> KMSAN reported the following uninit-value access issue:
> 
> =====================================================
> BUG: KMSAN: uninit-value in virtio_transport_recv_pkt+0x1dfb/0x26a0 net/vmw_vsock/virtio_transport_common.c:1421
>  virtio_transport_recv_pkt+0x1dfb/0x26a0 net/vmw_vsock/virtio_transport_common.c:1421
>  vsock_loopback_work+0x3bb/0x5a0 net/vmw_vsock/vsock_loopback.c:120
>  process_one_work kernel/workqueue.c:2630 [inline]
>  process_scheduled_works+0xff6/0x1e60 kernel/workqueue.c:2703
>  worker_thread+0xeca/0x14d0 kernel/workqueue.c:2784
>  kthread+0x3cc/0x520 kernel/kthread.c:388
>  ret_from_fork+0x66/0x80 arch/x86/kernel/process.c:147
>  ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:304
> 
> Uninit was stored to memory at:
>  virtio_transport_space_update net/vmw_vsock/virtio_transport_common.c:1274 [inline]
>  virtio_transport_recv_pkt+0x1ee8/0x26a0 net/vmw_vsock/virtio_transport_common.c:1415
>  vsock_loopback_work+0x3bb/0x5a0 net/vmw_vsock/vsock_loopback.c:120
>  process_one_work kernel/workqueue.c:2630 [inline]
>  process_scheduled_works+0xff6/0x1e60 kernel/workqueue.c:2703
>  worker_thread+0xeca/0x14d0 kernel/workqueue.c:2784
>  kthread+0x3cc/0x520 kernel/kthread.c:388
>  ret_from_fork+0x66/0x80 arch/x86/kernel/process.c:147
>  ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:304
> 
> Uninit was created at:
>  slab_post_alloc_hook+0x105/0xad0 mm/slab.h:767
>  slab_alloc_node mm/slub.c:3478 [inline]
>  kmem_cache_alloc_node+0x5a2/0xaf0 mm/slub.c:3523
>  kmalloc_reserve+0x13c/0x4a0 net/core/skbuff.c:559
>  __alloc_skb+0x2fd/0x770 net/core/skbuff.c:650
>  alloc_skb include/linux/skbuff.h:1286 [inline]
>  virtio_vsock_alloc_skb include/linux/virtio_vsock.h:66 [inline]
>  virtio_transport_alloc_skb+0x90/0x11e0 net/vmw_vsock/virtio_transport_common.c:58
>  virtio_transport_reset_no_sock net/vmw_vsock/virtio_transport_common.c:957 [inline]
>  virtio_transport_recv_pkt+0x1279/0x26a0 net/vmw_vsock/virtio_transport_common.c:1387
>  vsock_loopback_work+0x3bb/0x5a0 net/vmw_vsock/vsock_loopback.c:120
>  process_one_work kernel/workqueue.c:2630 [inline]
>  process_scheduled_works+0xff6/0x1e60 kernel/workqueue.c:2703
>  worker_thread+0xeca/0x14d0 kernel/workqueue.c:2784
>  kthread+0x3cc/0x520 kernel/kthread.c:388
>  ret_from_fork+0x66/0x80 arch/x86/kernel/process.c:147
>  ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:304
> 
> CPU: 1 PID: 10664 Comm: kworker/1:5 Not tainted 6.6.0-rc3-00146-g9f3ebbef746f #3
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-1.fc38 04/01/2014
> Workqueue: vsock-loopback vsock_loopback_work
> =====================================================
> 
> The following simple reproducer can cause the issue described above:
> 
> int main(void)
> {
>   int sock;
>   struct sockaddr_vm addr = {
>     .svm_family = AF_VSOCK,
>     .svm_cid = VMADDR_CID_ANY,
>     .svm_port = 1234,
>   };
> 
>   sock = socket(AF_VSOCK, SOCK_STREAM, 0);
>   connect(sock, (struct sockaddr *)&addr, sizeof(addr));
>   return 0;
> }
> 
> This issue occurs because the `buf_alloc` and `fwd_cnt` fields of the
> `struct virtio_vsock_hdr` are not initialized when a new skb is allocated
> in `virtio_transport_init_hdr()`. This patch resolves the issue by
> initializing these fields during allocation.
> 
> Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
> Reported-and-tested-by: syzbot+0c8ce1da0ac31abbadcd@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=0c8ce1da0ac31abbadcd
> Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
> ---
> v1->v2:
> - Rebase on the latest net tree
> https://lore.kernel.org/all/20231026150154.3536433-1-syoshida@redhat.com/
> ---
>  net/vmw_vsock/virtio_transport_common.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index e22c81435ef7..dc65dd4d26df 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -130,6 +130,8 @@ static void virtio_transport_init_hdr(struct sk_buff *skb,
>  	hdr->dst_port	= cpu_to_le32(dst_port);
>  	hdr->flags	= cpu_to_le32(info->flags);
>  	hdr->len	= cpu_to_le32(payload_len);
> +	hdr->buf_alloc	= cpu_to_le32(0);
> +	hdr->fwd_cnt	= cpu_to_le32(0);

This change looks good to me.

I did notice that payload_len in virtio_transport_init_hdr is size_t but
len in struct virtio_vsock_hdr is __le32. But I don't think this is an
issue other than wasting some stack space, though.

>  }
>  
>  static void virtio_transport_copy_nonlinear_skb(const struct sk_buff *skb,

