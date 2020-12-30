Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1F52E7BB5
	for <lists+kvm@lfdr.de>; Wed, 30 Dec 2020 18:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgL3R5N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Dec 2020 12:57:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgL3R5N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Dec 2020 12:57:13 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BDB7C061573
        for <kvm@vger.kernel.org>; Wed, 30 Dec 2020 09:56:32 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id h22so39341127lfu.2
        for <kvm@vger.kernel.org>; Wed, 30 Dec 2020 09:56:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=QilQFJ/x4jx3OTqqSV1nFT2A84/fjygT27YQFSizG7I=;
        b=gWe5qkAovhIh+3StiS98NiWzsFF4rPYdyamGQcf5AjlwlU1gg6+n0sI67Trm1sG4Zn
         R08xcVam3AJkcKt7I5xBaQRno2AcjDZbtqUAFWYU4R4s9v72h9RY4O7K8sb3QCheBULE
         PpLzu+sbn33kC3MK309K8PlFLlgePglmpR1aUCcoy8E/WsL3yZEbwrcUGK5wyWX8dxS6
         zmEnzDABNbIiKhwPlcjP7C4nOZy4QjzcqMEN8NkwgVUxrD01NDpAWVfbHvvEo9Du0uJk
         cw0lc3vXQghmpEYJl1EDxdqx5XNSI9tPnIoSuBdMXNVmE+nEApPqfrfEd++z8RuVY8gq
         nNEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=QilQFJ/x4jx3OTqqSV1nFT2A84/fjygT27YQFSizG7I=;
        b=bF6LmWwy1V1HoEurTMyy956zT49egU6NKsA4RJH4XBGvIJLffA8aASkh4qBo79aDT+
         18/JOd3a0VTctFKRtYkQkVUV61XKoeByvrJsRJYR0EupARJIlO1jufYJM9I0P8VYWB1V
         TTfPWEmrAxIi1C10a2qZ6h9kl8YS0fPtdubesrVaxtQnNuPF7ptK7U5v97Qo4uzGtVR1
         xtl/NFmcqs8SLeswDiAX4vcqIuz8m7m23gtdFNyktk8dxpyWnsK2+35WFA/+8q5wqmTV
         xfpohF3OaWBGSsl+LuSaRqt9v4PT4ocxOzOAo/2wR7npnm49NrBjZBxC6xQ0jch68mEh
         ep6Q==
X-Gm-Message-State: AOAM530utIMDEtm71dUc4DnQakP93Mcz1q2TtHkl0QMtezssawdKoPOm
        fod2CjtTU6lew/xi2cS81I8=
X-Google-Smtp-Source: ABdhPJzar6emGYYHJP5xsQBWbMHS1VnLpPRZNj91E3qwGdHiq3onYPNuPT6/Ghpfj5gJMfpXeY40dw==
X-Received: by 2002:a19:4b8e:: with SMTP id y136mr21807968lfa.90.1609350990761;
        Wed, 30 Dec 2020 09:56:30 -0800 (PST)
Received: from [192.168.167.128] (37-145-186-126.broadband.corbina.ru. [37.145.186.126])
        by smtp.gmail.com with ESMTPSA id v23sm7278796ljd.78.2020.12.30.09.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Dec 2020 09:56:30 -0800 (PST)
Message-ID: <b795d2b10916816fb3fe3a9bdcfdc57d87e53cbc.camel@gmail.com>
Subject: Re: [RFC 0/2] Introduce MMIO/PIO dispatch file descriptors
 (ioregionfd)
From:   Elena Afanasova <eafanasova@gmail.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     kvm@vger.kernel.org, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com, "Michael S. Tsirkin" <mst@redhat.com>,
        jasowang@redhat.com
Date:   Wed, 30 Dec 2020 09:56:16 -0800
In-Reply-To: <20201229120635.GD55616@stefanha-x1.localdomain>
References: <cover.1609231373.git.eafanasova@gmail.com>
         <20201229120635.GD55616@stefanha-x1.localdomain>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2020-12-29 at 12:06 +0000, Stefan Hajnoczi wrote:
> On Tue, Dec 29, 2020 at 01:02:42PM +0300, Elena Afanasova wrote:
> > This patchset introduces a KVM dispatch mechanism which can be
> > used 
> > for handling MMIO/PIO accesses over file descriptors without
> > returning 
> > from ioctl(KVM_RUN). This allows device emulation to run in another
> > task 
> > separate from the vCPU task.
> > 
> > This is achieved through KVM vm ioctl for registering MMIO/PIO
> > regions and 
> > a wire protocol that KVM uses to communicate with a task handling
> > an 
> > MMIO/PIO access.
> > 
> > ioregionfd relies on kmemcg in order to limit the amount of kernel
> > memory 
> > that userspace can consume. Can NR_IOBUS_DEVS hardcoded limit be
> > enforced 
> > only in case kmemcg is disabled?
> 
> Thanks for sharing this! Can you describe the todos? I noticed some
> in
> Patch 1 and highlighted them. In addition:
>  * Signal handling when the vCPU thread is interrupted in
>    kernel_read()/kernel_write()
> 
TODOs:

* Signal handling when the vCPU thread is interrupted in
   kernel_read()/kernel_write()
* Add ioregionfd cmds/replies serialization
* Implement KVM_EXIT_IOREGIONFD_FAILURE
* Add non-x86 arch support
* Add kvm-unittests

> > Elena Afanasova (2):
> >   KVM: add initial support for KVM_SET_IOREGION
> >   KVM: add initial support for ioregionfd blocking read/write
> > operations
> > 
> >  arch/x86/kvm/Kconfig     |   1 +
> >  arch/x86/kvm/Makefile    |   1 +
> >  arch/x86/kvm/x86.c       |   1 +
> >  include/linux/kvm_host.h |  17 ++
> >  include/uapi/linux/kvm.h |  23 +++
> >  virt/kvm/Kconfig         |   3 +
> >  virt/kvm/eventfd.c       |  25 +++
> >  virt/kvm/eventfd.h       |  14 ++
> >  virt/kvm/ioregion.c      | 390
> > +++++++++++++++++++++++++++++++++++++++
> >  virt/kvm/ioregion.h      |  15 ++
> >  virt/kvm/kvm_main.c      |  20 +-
> >  11 files changed, 507 insertions(+), 3 deletions(-)
> >  create mode 100644 virt/kvm/eventfd.h
> >  create mode 100644 virt/kvm/ioregion.c
> >  create mode 100644 virt/kvm/ioregion.h
> > 
> > -- 
> > 2.25.1
> > 

