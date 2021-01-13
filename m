Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57FAE2F53FB
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 21:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728825AbhAMUSN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 15:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728757AbhAMUSN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 15:18:13 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2865AC061786
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 12:17:27 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id q7so2212836pgm.5
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 12:17:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=l2BFPSaz93Fb6fOe6rKogs3O1900//0j+GKkOO5VwZE=;
        b=t4OR/s7XqNhQY+0p7wCLQsT2lJDGuUbTCetqTrnVXhARDKbDNpAWKbJ3H9p1xKYH6U
         a4o2t/kxwANFjPo7BFtwR1KER7dp333WqQa/+WHmcd2Xl0Fy1tqqq/0nJzz/fAo1moXC
         h1JVl38Ot3+qKGK5ENuVVW3z0Q6BAqWPXy4KK48YnJgHHSxkJil3NY1Kdxb4WYbbnvTR
         SInCAH2cWrqLyMj/bANMigzXLllot9AsQXPfBZI8dbIiBMbIS6+kcgW89IPbW1ZhB1Dx
         Y+aR2vZul/VBZ2fZZmEfdUxZ5E6bO9moRGSwPPfCZJq7y5Fw+mjOkLFZsl8/iolEfUPe
         2O0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l2BFPSaz93Fb6fOe6rKogs3O1900//0j+GKkOO5VwZE=;
        b=n3KuypsL7KmrgKedyGB2EF8Qeo6o2BpB7sUyA2Pm9H4lok/c+2NTlSEm59WaSGrnpB
         Vs3MjyhecgUpvYOmSI8SGj949T8R5ocVtrec7AovgQyhyyT+FqSx04pHzJBrvVprC/at
         FvWoIF8UgyXngxiB11EtHE9IT5/5ke3l/Evn2isRifiv2MyFn1+ImUz2dGvjv6+xl6OY
         wbze+xdKvUDcwuUL9a1KSV1q49+8fQ0YnwGvtHPhUQeHCWftS0Z+wYbZDOBHOEb9dcUe
         PBANDpU/iwA4H2t1ibwzyo9/rIYqhLBbv9oOL+6AWxCCpRRCQ6XzZeoauUQG3bHFKHNA
         yRGA==
X-Gm-Message-State: AOAM5306FT7AkIMySbIbEDHI96u1vVoYcYjIgjTK30lZGjLfjgH8HNlv
        tqTCJlWtnp9FJZm7puP8pXhcug==
X-Google-Smtp-Source: ABdhPJzRk7nALa741bswku4iIFtNb9KAkbAmw1NjHve2+MKA+QkPhbzvLMUfqFWAfJTZ33NMgPXt6w==
X-Received: by 2002:a62:1d43:0:b029:1ab:7f7a:4ab8 with SMTP id d64-20020a621d430000b02901ab7f7a4ab8mr3804956pfd.43.1610569046480;
        Wed, 13 Jan 2021 12:17:26 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id j20sm3291586pfd.106.2021.01.13.12.17.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 12:17:25 -0800 (PST)
Date:   Wed, 13 Jan 2021 12:17:19 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Zdenek Kaspar <zkaspar82@gmail.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: Bad performance since 5.9-rc1
Message-ID: <X/9VT6ZgLPZW3dxc@google.com>
References: <20201119040526.5263f557.zkaspar82@gmail.com>
 <20201201073537.6749e2d7.zkaspar82@gmail.com>
 <20201218203310.5025c17e.zkaspar82@gmail.com>
 <X+D6eJn92Vt6v+U1@google.com>
 <20201221221339.030684c4.zkaspar82@gmail.com>
 <X+In2zIA40Ku19cM@google.com>
 <20201222222645.0d8e96b2.zkaspar82@gmail.com>
 <20210112121811.408e32fe.zkaspar82@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112121811.408e32fe.zkaspar82@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 12, 2021, Zdenek Kaspar wrote:
> On Tue, 22 Dec 2020 22:26:45 +0100
> Zdenek Kaspar <zkaspar82@gmail.com> wrote:
> 
> > On Tue, 22 Dec 2020 09:07:39 -0800
> > Sean Christopherson <seanjc@google.com> wrote:
> > 
> > > On Mon, Dec 21, 2020, Zdenek Kaspar wrote:
> > > > [  179.364305] WARNING: CPU: 0 PID: 369 at
> > > > kvm_mmu_zap_oldest_mmu_pages+0xd1/0xe0 [kvm] [  179.365415] Call
> > > > Trace: [  179.365443]  paging64_page_fault+0x244/0x8e0 [kvm]
> > > 
> > > This means the shadow page zapping is occuring because KVM is
> > > hitting the max number of allowed MMU shadow pages.  Can you
> > > provide your QEMU command line?  I can reproduce the performance
> > > degredation, but only by deliberately overriding the max number of
> > > MMU pages via `-machine kvm-shadow-mem` to be an absurdly low value.
> > > 
> > > > [  179.365596]  kvm_mmu_page_fault+0x376/0x550 [kvm]
> > > > [  179.365725]  kvm_arch_vcpu_ioctl_run+0xbaf/0x18f0 [kvm]
> > > > [  179.365772]  kvm_vcpu_ioctl+0x203/0x520 [kvm]
> > > > [  179.365938]  __x64_sys_ioctl+0x338/0x720
> > > > [  179.365992]  do_syscall_64+0x33/0x40
> > > > [  179.366013]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > 
> > It's one long line, added "\" for mail readability:
> > 
> > qemu-system-x86_64 -machine type=q35,accel=kvm            \
> > -cpu host,host-cache-info=on -smp cpus=2,cores=2          \
> > -m size=1024 -global virtio-pci.disable-legacy=on         \
> > -global virtio-pci.disable-modern=off                     \
> > -device virtio-balloon                                    \
> > -device virtio-net,netdev=tap-build,mac=DE:AD:BE:EF:00:80 \
> > -object rng-random,filename=/dev/urandom,id=rng0          \
> > -device virtio-rng,rng=rng0                               \
> > -name build,process=qemu-build                            \
> > -drive
> > file=/mnt/data/export/unix/kvm/build/openbsd-amd64.img,if=virtio,cache=none,format=raw,aio=native
> > \ -netdev type=tap,id=tap-build,vhost=on                    \ -serial
> > none                                              \ -parallel none
> >                                         \ -monitor
> > unix:/dev/shm/kvm-build.sock,server,nowait       \ -enable-kvm
> > -daemonize -runas qemu
> > 
> > Z.
> 
> BTW, v5.11-rc3 with kvm-shadow-mem=1073741824 it seems OK.
>
> Just curious what v5.8 does

Aha!  Figured it out.  v5.9 (the commit you bisected to) broke the zapping,
that's what it did.  The list of MMU pages is a FIFO list, meaning KVM adds
entries to the head, not the tail.  I botched the zapping flow and used
for_each instead of for_each_reverse, which meant KVM would zap the _newest_
pages instead of the _oldest_ pages.  So once a VM hit its limit, KVM would
constantly zap the shadow pages it just allocated.

This should resolve the performance regression, or at least make it far less
painful.  It's possible you may still see some performance degredation due to
other changes in the the zapping, e.g. more aggressive recursive zapping.  If
that's the case, I can explore other tweaks, e.g. skip higher levels when
possible.  I'll get a proper patch posted later today.

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c478904af518..2c6e6fdb26ad 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2417,7 +2417,7 @@ static unsigned long kvm_mmu_zap_oldest_mmu_pages(struct kvm *kvm,
                return 0;

 restart:
-       list_for_each_entry_safe(sp, tmp, &kvm->arch.active_mmu_pages, link) {
+       list_for_each_entry_safe_reverse(sp, tmp, &kvm->arch.active_mmu_pages, link) {
                /*
                 * Don't zap active root pages, the page itself can't be freed
                 * and zapping it will just force vCPUs to realloc and reload.

Side topic, I still can't figure out how on earth your guest kernel is hitting
the max number of default pages.  Even with large pages completely disabled, PTI
enabled, multiple guest processes running, etc... I hit OOM in the guest before
the host's shadow page limit kicks in.  I had to force the limit down to 25% of
the default to reproduce the bad behavior.  All I can figure is that BSD has a
substantially different paging scheme than Linux.

> so by any chance is there command for kvm-shadow-mem value via qemu monitor?
> 
> Z.
