Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3E82F54E1
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 23:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbhAMWU3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 17:20:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729296AbhAMWS2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 17:18:28 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 379D5C061794
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 14:17:20 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id hs11so3003656ejc.1
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 14:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9Oh0h11UBIKy1oYgMCzDb1sJgrvgJbu3dk5WkSDn3kg=;
        b=PbeSsVzXpk1VyQb2KVaURjeeNgdINQA/RD870opv4Wku4a5mBVywV/w1EfG+f/AdoZ
         jW6v2D5O2N9oNRgLYsQEboKTTADTqe6Xagr4vJhGbdq0/0ZszrQSUyr90no4Qo62mu4F
         xgc6Dhra1m1T4S2NlgW9PW2u/UEKAME7sphCgeM99s/+ZVSbcM+3CMd33vAJyJa1Z1+D
         zm9t2oc9X5qnoTe6vc64rme+4G+aqB/xHnTvRFn0+v7SdBlGMrP5bi2OWN0CyYZOtyAu
         yx/hBs1mcwRJxrFtCfugQNzJ3qrLmOszh/r0sVo9Oub4jLCIN1T4YOY7XSsl64IGrq6l
         eg/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9Oh0h11UBIKy1oYgMCzDb1sJgrvgJbu3dk5WkSDn3kg=;
        b=JqY/ZNAKNK17LcPnuiLb6uGn9pnM4cew99ZrYuOffLCe9SsodE/GbrBOjabbRXtOHR
         pblvpXZHiokpA0X4OhSyglDZDHWdaRODyrcy1+tzqO8VTBy4Jl9UoFXUqphE1jRkWJa9
         7oGSSX593Pk9SfH/f6RZcuKlakeqaUFte6gUoo7+FRmuo9nuWP2xZoMchYJN7UhqR2jg
         II3PpFreSJ3nJMrT1UprKigcHySAN1qE+unW6GvvCxHKRXoC8P9FTNMkxRgqZIAdZWhY
         80wDNuqAzKTuvNtKN5zQIDIpftqru03rr/rpn8gGphnwrAxnxkaP0P3gUDL1c7GgeEtE
         Qbyg==
X-Gm-Message-State: AOAM531mImlbxIJGaz7eAQ01ae3z3WcayKyd1nA+gClH0UmI5cOYXhWz
        tCzIad2cchCoQOn2SMw7hXE=
X-Google-Smtp-Source: ABdhPJyXjHnfvr2BZISdU6zpl34VqNZTdttvLQnUM4CBWna7wFm72ku7fLRmMbH/IQ+AqA6TS6delQ==
X-Received: by 2002:a17:906:aec6:: with SMTP id me6mr3071148ejb.542.1610576238972;
        Wed, 13 Jan 2021 14:17:18 -0800 (PST)
Received: from vm1 (ip-86-49-65-192.net.upcbroadband.cz. [86.49.65.192])
        by smtp.gmail.com with ESMTPSA id k6sm1193175ejb.84.2021.01.13.14.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 14:17:18 -0800 (PST)
Date:   Wed, 13 Jan 2021 23:17:15 +0100
From:   Zdenek Kaspar <zkaspar82@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: Bad performance since 5.9-rc1
Message-ID: <20210113231715.615b8d1b.zkaspar82@gmail.com>
In-Reply-To: <X/9VT6ZgLPZW3dxc@google.com>
References: <20201119040526.5263f557.zkaspar82@gmail.com>
        <20201201073537.6749e2d7.zkaspar82@gmail.com>
        <20201218203310.5025c17e.zkaspar82@gmail.com>
        <X+D6eJn92Vt6v+U1@google.com>
        <20201221221339.030684c4.zkaspar82@gmail.com>
        <X+In2zIA40Ku19cM@google.com>
        <20201222222645.0d8e96b2.zkaspar82@gmail.com>
        <20210112121811.408e32fe.zkaspar82@gmail.com>
        <X/9VT6ZgLPZW3dxc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 13 Jan 2021 12:17:19 -0800
Sean Christopherson <seanjc@google.com> wrote:

> On Tue, Jan 12, 2021, Zdenek Kaspar wrote:
> > On Tue, 22 Dec 2020 22:26:45 +0100
> > Zdenek Kaspar <zkaspar82@gmail.com> wrote:
> > 
> > > On Tue, 22 Dec 2020 09:07:39 -0800
> > > Sean Christopherson <seanjc@google.com> wrote:
> > > 
> > > > On Mon, Dec 21, 2020, Zdenek Kaspar wrote:
> > > > > [  179.364305] WARNING: CPU: 0 PID: 369 at
> > > > > kvm_mmu_zap_oldest_mmu_pages+0xd1/0xe0 [kvm] [  179.365415]
> > > > > Call Trace: [  179.365443]  paging64_page_fault+0x244/0x8e0
> > > > > [kvm]
> > > > 
> > > > This means the shadow page zapping is occuring because KVM is
> > > > hitting the max number of allowed MMU shadow pages.  Can you
> > > > provide your QEMU command line?  I can reproduce the performance
> > > > degredation, but only by deliberately overriding the max number
> > > > of MMU pages via `-machine kvm-shadow-mem` to be an absurdly
> > > > low value.
> > > > 
> > > > > [  179.365596]  kvm_mmu_page_fault+0x376/0x550 [kvm]
> > > > > [  179.365725]  kvm_arch_vcpu_ioctl_run+0xbaf/0x18f0 [kvm]
> > > > > [  179.365772]  kvm_vcpu_ioctl+0x203/0x520 [kvm]
> > > > > [  179.365938]  __x64_sys_ioctl+0x338/0x720
> > > > > [  179.365992]  do_syscall_64+0x33/0x40
> > > > > [  179.366013]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > 
> > > It's one long line, added "\" for mail readability:
> > > 
> > > qemu-system-x86_64 -machine type=q35,accel=kvm            \
> > > -cpu host,host-cache-info=on -smp cpus=2,cores=2          \
> > > -m size=1024 -global virtio-pci.disable-legacy=on         \
> > > -global virtio-pci.disable-modern=off                     \
> > > -device virtio-balloon                                    \
> > > -device virtio-net,netdev=tap-build,mac=DE:AD:BE:EF:00:80 \
> > > -object rng-random,filename=/dev/urandom,id=rng0          \
> > > -device virtio-rng,rng=rng0                               \
> > > -name build,process=qemu-build                            \
> > > -drive
> > > file=/mnt/data/export/unix/kvm/build/openbsd-amd64.img,if=virtio,cache=none,format=raw,aio=native
> > > \ -netdev type=tap,id=tap-build,vhost=on                    \
> > > -serial none                                              \
> > > -parallel none \ -monitor
> > > unix:/dev/shm/kvm-build.sock,server,nowait       \ -enable-kvm
> > > -daemonize -runas qemu
> > > 
> > > Z.
> > 
> > BTW, v5.11-rc3 with kvm-shadow-mem=1073741824 it seems OK.
> >
> > Just curious what v5.8 does
> 
> Aha!  Figured it out.  v5.9 (the commit you bisected to) broke the
> zapping, that's what it did.  The list of MMU pages is a FIFO list,
> meaning KVM adds entries to the head, not the tail.  I botched the
> zapping flow and used for_each instead of for_each_reverse, which
> meant KVM would zap the _newest_ pages instead of the _oldest_ pages.
>  So once a VM hit its limit, KVM would constantly zap the shadow
> pages it just allocated.
> 
> This should resolve the performance regression, or at least make it
> far less painful.  It's possible you may still see some performance
> degredation due to other changes in the the zapping, e.g. more
> aggressive recursive zapping.  If that's the case, I can explore
> other tweaks, e.g. skip higher levels when possible.  I'll get a
> proper patch posted later today.
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c478904af518..2c6e6fdb26ad 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2417,7 +2417,7 @@ static unsigned long
> kvm_mmu_zap_oldest_mmu_pages(struct kvm *kvm, return 0;
> 
>  restart:
> -       list_for_each_entry_safe(sp, tmp,
> &kvm->arch.active_mmu_pages, link) {
> +       list_for_each_entry_safe_reverse(sp, tmp,
> &kvm->arch.active_mmu_pages, link) { /*
>                  * Don't zap active root pages, the page itself can't
> be freed
>                  * and zapping it will just force vCPUs to realloc
> and reload.
> 
> Side topic, I still can't figure out how on earth your guest kernel
> is hitting the max number of default pages.  Even with large pages
> completely disabled, PTI enabled, multiple guest processes running,
> etc... I hit OOM in the guest before the host's shadow page limit
> kicks in.  I had to force the limit down to 25% of the default to
> reproduce the bad behavior.  All I can figure is that BSD has a
> substantially different paging scheme than Linux.
> 
> > so by any chance is there command for kvm-shadow-mem value via qemu
> > monitor?
> > 
> > Z.

Cool, tested by quick compile in guest and it's a good fix!

5.11.0-rc3-amd64 (list_for_each_entry_safe):
 - with kvm-shadow-mem=1073741824 (without == unusable)
    0m14.86s real     0m10.87s user     0m12.15s system

5.11.0-rc3-2-amd64 (list_for_each_entry_safe_reverse):
    0m14.36s real     0m10.50s user     0m12.43s system

Thanks, Z.
