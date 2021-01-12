Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7541F2F2DC0
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 12:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725779AbhALLS7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 06:18:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725859AbhALLS7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 06:18:59 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE0B5C061575
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 03:18:18 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id g24so1846485edw.9
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 03:18:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6Xza6dUDyfeH/pPU30kEn/p3DdpBur5kEztG56hp89Y=;
        b=CpvXhdydrJAp2wIZ93s4jbYbtrlCwpgfzZYFSLvS+aK9OCBOCjNzBUiUZ/2Mgkkxn/
         IlUuS/E7AOKGzAUzI0sJ7aM4pJRHKzhbQJVzSVffua2UrF7Mp5H4hJUUkmY9WM8t/ABH
         oWFYtPzP00yyhoBKvbPBJRFXJhvfNZTCEgYi9Iex4k3owe+yYAZDICw34Tv56cXLSwMs
         ktG+eZ+v0dd3kbAfQXSuYKRVXGt4j64e6S4lTqQi8j3/CsqxQ8HHvp7+Gvf/qDzWHUYA
         7fx3W79zcNVR2Y8hu8Zz6u7RsMZuTuC7M7z8Rb8WbUSaGdLV89ondf9jtnBwZsJdoDXb
         RsUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6Xza6dUDyfeH/pPU30kEn/p3DdpBur5kEztG56hp89Y=;
        b=pOdwgJ96XpaiodrFSPc6cPCtP+MVWZyEtm2m5OXWJa3v/pWZ6dqzKB0ZQrwyWPxfeF
         9m53a18DSsMcFZKL7Hmv89z8vNOz291qMw7dcfEfiGbW6wIumtgn8edLFO6h3GyW3eFT
         y/zgHHX/rqLuevnKHvhWptsTR0heCRUpSiL3aNqT53jCiL8DKUB3rrWlFxogN8zfx0Sp
         P7WeLisN1cnK/h1SlCIuZ+f443oueAAp53nVlCetwvbB/0TQF7dwQ0LE0SK0bLp3T+iX
         okZETu4gEhXV+z+EtDrPfpFh57ZiiN6qZHLiqZvcvgIE964sQN6AOGeUAzzZAEAH0Wzr
         0k6Q==
X-Gm-Message-State: AOAM533+pGxFN/gce6Mmo8K2mKS27z+HjZGnErndM54JotOSn7yTkU+R
        JnT1uz9Vag01DaXUHFX7D14=
X-Google-Smtp-Source: ABdhPJwVhge/8MyznJ09B4fkPd9M8/E3VPT+PSewCAixhOEhYETVisqUk6+Qntb78UMZerV5qABBJQ==
X-Received: by 2002:a05:6402:a52:: with SMTP id bt18mr3041911edb.228.1610450297451;
        Tue, 12 Jan 2021 03:18:17 -0800 (PST)
Received: from vm1 (ip-86-49-65-192.net.upcbroadband.cz. [86.49.65.192])
        by smtp.gmail.com with ESMTPSA id da9sm1250503edb.84.2021.01.12.03.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 03:18:17 -0800 (PST)
Date:   Tue, 12 Jan 2021 12:18:11 +0100
From:   Zdenek Kaspar <zkaspar82@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: Bad performance since 5.9-rc1
Message-ID: <20210112121811.408e32fe.zkaspar82@gmail.com>
In-Reply-To: <20201222222645.0d8e96b2.zkaspar82@gmail.com>
References: <20201119040526.5263f557.zkaspar82@gmail.com>
        <20201201073537.6749e2d7.zkaspar82@gmail.com>
        <20201218203310.5025c17e.zkaspar82@gmail.com>
        <X+D6eJn92Vt6v+U1@google.com>
        <20201221221339.030684c4.zkaspar82@gmail.com>
        <X+In2zIA40Ku19cM@google.com>
        <20201222222645.0d8e96b2.zkaspar82@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 22 Dec 2020 22:26:45 +0100
Zdenek Kaspar <zkaspar82@gmail.com> wrote:

> On Tue, 22 Dec 2020 09:07:39 -0800
> Sean Christopherson <seanjc@google.com> wrote:
> 
> > On Mon, Dec 21, 2020, Zdenek Kaspar wrote:
> > > [  179.364305] WARNING: CPU: 0 PID: 369 at
> > > kvm_mmu_zap_oldest_mmu_pages+0xd1/0xe0 [kvm] [  179.365415] Call
> > > Trace: [  179.365443]  paging64_page_fault+0x244/0x8e0 [kvm]
> > 
> > This means the shadow page zapping is occuring because KVM is
> > hitting the max number of allowed MMU shadow pages.  Can you
> > provide your QEMU command line?  I can reproduce the performance
> > degredation, but only by deliberately overriding the max number of
> > MMU pages via `-machine kvm-shadow-mem` to be an absurdly low value.
> > 
> > > [  179.365596]  kvm_mmu_page_fault+0x376/0x550 [kvm]
> > > [  179.365725]  kvm_arch_vcpu_ioctl_run+0xbaf/0x18f0 [kvm]
> > > [  179.365772]  kvm_vcpu_ioctl+0x203/0x520 [kvm]
> > > [  179.365938]  __x64_sys_ioctl+0x338/0x720
> > > [  179.365992]  do_syscall_64+0x33/0x40
> > > [  179.366013]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> It's one long line, added "\" for mail readability:
> 
> qemu-system-x86_64 -machine type=q35,accel=kvm            \
> -cpu host,host-cache-info=on -smp cpus=2,cores=2          \
> -m size=1024 -global virtio-pci.disable-legacy=on         \
> -global virtio-pci.disable-modern=off                     \
> -device virtio-balloon                                    \
> -device virtio-net,netdev=tap-build,mac=DE:AD:BE:EF:00:80 \
> -object rng-random,filename=/dev/urandom,id=rng0          \
> -device virtio-rng,rng=rng0                               \
> -name build,process=qemu-build                            \
> -drive
> file=/mnt/data/export/unix/kvm/build/openbsd-amd64.img,if=virtio,cache=none,format=raw,aio=native
> \ -netdev type=tap,id=tap-build,vhost=on                    \ -serial
> none                                              \ -parallel none
>                                         \ -monitor
> unix:/dev/shm/kvm-build.sock,server,nowait       \ -enable-kvm
> -daemonize -runas qemu
> 
> Z.

BTW, v5.11-rc3 with kvm-shadow-mem=1073741824 it seems OK.

Just curious what v5.8 does, so by any chance is there command
for kvm-shadow-mem value via qemu monitor?

Z.
