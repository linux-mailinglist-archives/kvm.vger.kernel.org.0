Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8D942E0FD4
	for <lists+kvm@lfdr.de>; Tue, 22 Dec 2020 22:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgLVV1a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Dec 2020 16:27:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbgLVV1a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Dec 2020 16:27:30 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED438C0613D3
        for <kvm@vger.kernel.org>; Tue, 22 Dec 2020 13:26:49 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id b9so20172015ejy.0
        for <kvm@vger.kernel.org>; Tue, 22 Dec 2020 13:26:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Pb3fDswk6YSg+H//M9stnTo9YFgK32WUyn6PMLNAiis=;
        b=R6YlMvBo0W/qPzVHT7LzFRvJVNaJsVEDwoDb6ikny2SUNCvLiyr9wgt/hsbl3lPRut
         DM5QTMB0/DmLnycpDgKrVvYS4e1CvZAMxVANKk0ORDHND1G8zxsu8Y48yfF/ovuvCaFe
         80IZcG/qeEnUIuVdwbO7XwS3WgYxeGghGB/54P3A1kwrDvUKLd9ca55v0+u1yaXycjr9
         D++BEWggaVZDbhGjjptHj52E+w8bBqTc2Dl/b2RHppcFtCEwOS/F0Cor/aMs1mYLr5u0
         cD4uLML7OHjunK+kCkkBlAd/mpGURISwj/gZ29CnZ1G6J9tWfLZG+6UG8gZ2yIXvkhiv
         wfqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pb3fDswk6YSg+H//M9stnTo9YFgK32WUyn6PMLNAiis=;
        b=XtqfRlDKdTef4z2DUtRmwIZnhRUF/Q3LiWuX7RhFavtpTBMCstvvzlnXhHXxEQ0XxQ
         iM43SK8V2yx6myeJrNZB8/xs4zSHT2wTVp27dejkbNO3dCUNjrZFunhSErG8cn3U67oP
         ZOZGrQ1m7pAZTWemoWWPpEkmIMWxHlJbZ79q8ZtzUgiHm+LV4YJnqc4+hcH8sdLbVxkm
         qSiK85jcfRCEXWeJVPlHUd8ZIWad3LA9D26lAfzxe6LK8yvHPeQBK4b6lUUem9icGFxG
         0J2717iWEvFYbdlPfTZKWPpVpr9aUGXUqVfsMfm6+uF+BmddkOjyB/GDghP651bvL1km
         NzGQ==
X-Gm-Message-State: AOAM533woKRnePkbU/GkD05gRfO7SX5ToiPMVXGvLIPwKyqZdkLciqiU
        Jrt6y5f3yDYgRNAfG08Z9jc=
X-Google-Smtp-Source: ABdhPJycdl6ZD9l87f47xEv78ZOKa9AXgjF5D1TzB9LMdo3lx70cfHfbv29XUHaNME2MzXGRwN4rww==
X-Received: by 2002:a17:906:254b:: with SMTP id j11mr21514626ejb.326.1608672408626;
        Tue, 22 Dec 2020 13:26:48 -0800 (PST)
Received: from vm1 (ip-86-49-65-192.net.upcbroadband.cz. [86.49.65.192])
        by smtp.gmail.com with ESMTPSA id dh19sm21592706edb.78.2020.12.22.13.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 13:26:48 -0800 (PST)
Date:   Tue, 22 Dec 2020 22:26:45 +0100
From:   Zdenek Kaspar <zkaspar82@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: Bad performance since 5.9-rc1
Message-ID: <20201222222645.0d8e96b2.zkaspar82@gmail.com>
In-Reply-To: <X+In2zIA40Ku19cM@google.com>
References: <20201119040526.5263f557.zkaspar82@gmail.com>
        <20201201073537.6749e2d7.zkaspar82@gmail.com>
        <20201218203310.5025c17e.zkaspar82@gmail.com>
        <X+D6eJn92Vt6v+U1@google.com>
        <20201221221339.030684c4.zkaspar82@gmail.com>
        <X+In2zIA40Ku19cM@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 22 Dec 2020 09:07:39 -0800
Sean Christopherson <seanjc@google.com> wrote:

> On Mon, Dec 21, 2020, Zdenek Kaspar wrote:
> > [  179.364305] WARNING: CPU: 0 PID: 369 at
> > kvm_mmu_zap_oldest_mmu_pages+0xd1/0xe0 [kvm] [  179.365415] Call
> > Trace: [  179.365443]  paging64_page_fault+0x244/0x8e0 [kvm]
> 
> This means the shadow page zapping is occuring because KVM is hitting
> the max number of allowed MMU shadow pages.  Can you provide your
> QEMU command line?  I can reproduce the performance degredation, but
> only by deliberately overriding the max number of MMU pages via
> `-machine kvm-shadow-mem` to be an absurdly low value.
> 
> > [  179.365596]  kvm_mmu_page_fault+0x376/0x550 [kvm]
> > [  179.365725]  kvm_arch_vcpu_ioctl_run+0xbaf/0x18f0 [kvm]
> > [  179.365772]  kvm_vcpu_ioctl+0x203/0x520 [kvm]
> > [  179.365938]  __x64_sys_ioctl+0x338/0x720
> > [  179.365992]  do_syscall_64+0x33/0x40
> > [  179.366013]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

It's one long line, added "\" for mail readability:

qemu-system-x86_64 -machine type=q35,accel=kvm            \
-cpu host,host-cache-info=on -smp cpus=2,cores=2          \
-m size=1024 -global virtio-pci.disable-legacy=on         \
-global virtio-pci.disable-modern=off                     \
-device virtio-balloon                                    \
-device virtio-net,netdev=tap-build,mac=DE:AD:BE:EF:00:80 \
-object rng-random,filename=/dev/urandom,id=rng0          \
-device virtio-rng,rng=rng0                               \
-name build,process=qemu-build                            \
-drive file=/mnt/data/export/unix/kvm/build/openbsd-amd64.img,if=virtio,cache=none,format=raw,aio=native \
-netdev type=tap,id=tap-build,vhost=on                    \
-serial none                                              \
-parallel none                                            \
-monitor unix:/dev/shm/kvm-build.sock,server,nowait       \
-enable-kvm -daemonize -runas qemu

Z.
