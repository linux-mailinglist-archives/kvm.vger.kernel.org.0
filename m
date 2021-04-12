Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 671B635CEEA
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 18:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244838AbhDLQwM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 12:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345112AbhDLQqc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 12:46:32 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76006C061366
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 09:37:44 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id l123so9529506pfl.8
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 09:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jXy89NpkCf+gU9CPVILX4dC+bFntzEIP+c30BY2gytc=;
        b=kY1RzZfgOPSYncp7WoFl8ZPspZKIXID84g698u5D7Ec7VfdfeEOcwmcl/vAiV2qYnd
         6nWkQ9hRm90+nEjeC/8KP03mkBtGsOh3eD3NITuO2vTD/6qb9i6V/dgeOIWnpJy+eJGK
         yjhADxa986q/md+T1UfyIkTcpshotLIwlIIdlkYmE8UnhnwxMoMpI8DOJkJ0NI+9wu54
         rQkNu/nWF0IPJ2I1F3mlIrdRLXHs+NEi70ZhLwOXO/A85KuzvGc+aIf710xOAsLBqQUb
         KKSm28wng/DV9ejdOUzAUgWLb0lqQmW6cyKrQV5VawlxHR1AlQageypbtLtgEM/TxiPb
         shNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jXy89NpkCf+gU9CPVILX4dC+bFntzEIP+c30BY2gytc=;
        b=aW0tVGoEXrqOk73O4vYHSa4nr93YbcOem/Lydaw9MlUBMcMNIJGoazRIlvpoyT8JoD
         ObVReKFSqUUcGQZe5DGgCjI+wdQx7/MWBLnZMIfcvwl6JTXv8WRBXWVi/UPXnqSmA2M1
         Ku4RlFiXu8SwEcghco6amvbeUnQP3ajf4gB4guj/sv6paONskKEBWgW9J0fkX/0qGFB6
         yh7Q8H1J/scUDEzHi7xC6CpEgsUgTj5iG6QzT9Fa/BWbrJ968vsSwAgegtezUDXnX+YC
         onhQUTLoSn1yaUbhwqUnAACs1B9l1DKTszsoXu2ANkZRNEdrSTtGtMOPqeIr/la8KSn5
         mNjg==
X-Gm-Message-State: AOAM531rcqLpopQOFyx2no1ZTsDao3IjEvcE3JzNqFf+I0IZx/jer7JK
        J1KRPMyOVSiTErq36frxvgHKzljb1FCVxg==
X-Google-Smtp-Source: ABdhPJz9peG0xqBJKco9E4byPdniEfTR1pQKh4HlSmr1VexYDis4XVrm35wcTBAD7IzcLmySemKGaA==
X-Received: by 2002:a62:1757:0:b029:23e:9917:7496 with SMTP id 84-20020a6217570000b029023e99177496mr25662221pfx.51.1618245463872;
        Mon, 12 Apr 2021 09:37:43 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id 23sm12074035pgo.53.2021.04.12.09.37.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 09:37:43 -0700 (PDT)
Date:   Mon, 12 Apr 2021 16:37:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Hao Sun <sunhao.th@gmail.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: general protection fault in
 kvm_vm_ioctl_unregister_coalesced_mmio
Message-ID: <YHR3U+1FEXlPJijH@google.com>
References: <CACkBjsb3WBaXya+7XeoYTOTRNSR2-Rw_C=S7YW9GrP6B3Osw2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACkBjsb3WBaXya+7XeoYTOTRNSR2-Rw_C=S7YW9GrP6B3Osw2Q@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 12, 2021, Hao Sun wrote:
> Crash log:
> ==============================================
> kvm: failed to shrink bus, removing it completely
> general protection fault, probably for non-canonical address
> 0xdead000000000100: 0000 [#1] PREEMPT SMP
> CPU: 3 PID: 7974 Comm: executor Not tainted 5.12.0-rc6+ #14
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.13.0-1ubuntu1.1 04/01/2014
> RIP: 0010:kvm_vm_ioctl_unregister_coalesced_mmio+0x88/0x1e0
> arch/x86/kvm/../../../virt/kvm/coalesced_mmio.c:183

Ugh, this code is a mess.  On allocation failure, it nukes the entire bus and
invokes the destructor for all _other_ devices on the bus.  The coalesced MMIO
code is iterating over its list of devices, and while list_for_each_entry_safe()
can handle removal of the current entry, it blows up when future entries are
deleted.

That the coalesced MMIO code continuing to iterate appears to stem from the fact
that KVM_UNREGISTER_COALESCED_MMIO doesn't require an exact match.  Whether or
not this is intentional is probably a moot point since it's now baked into the
ABI.

Assuming we can't change kvm_vm_ioctl_unregister_coalesced_mmio() to stop
iterating on match, the least awful fix would be to return success/failure from
kvm_io_bus_unregister_dev().

Note, there's a second bug in the error path in kvm_io_bus_unregister_dev(), as
it invokes the destructors before nullifying kvm->buses and synchronizing SRCU.
I.e. it's freeing devices on the bus while readers may be in flight.  That can
be fixed by deferring the destruction until after SRCU synchronization.

I'll send patches unless someone has a better idea for fixing this.

> Code: 00 4c 89 74 24 18 4c 89 6c 24 20 48 8b 44 24 10 48 83 c0 08 48
> 89 44 24 28 48 89 5c 24 08 4c 89 24 24 4c 89 ff e8 d8 9f 49 00 <4d> 8b
> 37 48 89 df e8 3d 9b 49 00 8b 2b 49 8d 7f 2c e8 32 9b 49 00
> RSP: 0018:ffffc90005dfbd58 EFLAGS: 00010246
> RAX: ffff88800c3e7188 RBX: ffffc90005dfbe3c RCX: 0000000000000af0
> RDX: 0001000000000100 RSI: 000000000000cbab RDI: dead000000000100
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0001000000000107
> R10: 0001ffffffffffff R11: 00000000000001d2 R12: ffffc90005e7dff8
> R13: 0000000000004000 R14: dead000000000100 R15: dead000000000100
> FS:  00007ff1bb092700(0000) GS:ffff88807ed00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055d8946c4918 CR3: 0000000012d88000 CR4: 0000000000752ee0
> PKRU: 55555554
> Call Trace:
>  kvm_vm_ioctl+0x6e1/0x1860 arch/x86/kvm/../../../virt/kvm/kvm_main.c:3897
>  vfs_ioctl fs/ioctl.c:48 [inline]
>  __do_sys_ioctl fs/ioctl.c:753 [inline]
>  __se_sys_ioctl+0xab/0x110 fs/ioctl.c:739
>  __x64_sys_ioctl+0x3f/0x50 fs/ioctl.c:739
>  do_syscall_64+0x39/0x80 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x47338d
