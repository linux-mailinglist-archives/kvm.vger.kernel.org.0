Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8C730DC50
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 15:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232317AbhBCOLc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 09:11:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232306AbhBCOLZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 09:11:25 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1557BC0613D6
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 06:10:45 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id m22so33527868lfg.5
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 06:10:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=09KPk/n059WXdQl8E+jqgXMgLAAYdPBKwXAhIWYMTts=;
        b=JWyKnLo59f0EZz2HZxDmPSp5o8rc6KdEMTuPEA/Ejx3Yj9bF3Df7UTeWI1FKikvb2x
         Zi26Qgi9aozDO0v7H21t3vZ2abLj7zTKDLNxksFeG/BvbggYyEvwhDOPO/eS82BjYbjW
         xcQ292MzBZFOH175H4XzXnNJrZHVeJfYHU4tggTj49xFUapvZ7yDyBZ20iKs01ocTVnR
         WIv7a5VECdlX6IrhHhHdfgb/WQWFeepsIyX7bAbVcgBxrJXRevdisl5ij/177DaYt/1W
         tEiLxPKpJAezs/nIuQWAny8T1xQhttHLWrcNpzyf38ssoVQPnCdaLZuj++FqVV57bImF
         1y9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=09KPk/n059WXdQl8E+jqgXMgLAAYdPBKwXAhIWYMTts=;
        b=l/eOZ6uEvEFUtEIRIdp4nrz0U4cD5knqheTJdHCwn5DOmNl/Qyq6452/UbhjJs/fD7
         ws3JKZbLVoeU72qonrPO7zLu3KI3RNKjZ2GLUNqYT518GP8tlfcqT9tWnxfls3GawK+g
         xoMB9P/Bp6IwFHswwCvrlEs91hCI41jSOhRM3DK0Mp7UXX9xO28GWjZ5f3l0mtt4QXyp
         jhPKlhcWOPpLAbOpCBHj7WeEZsX+734f4gi5ao9oI0667n46p0er+ZZZOcFoIIz2vO3a
         /VaDd1SBAQOYdCbThifubmeadsDK29Jvoq0GVhzN8OaVgHU2ayEhQpUZ6v/dQ6vmV8XW
         ITgw==
X-Gm-Message-State: AOAM5338RVYxwSjmPi9cjupgM/+N69RI8ggnbmlThv5cS7cpY+F19z66
        JoNFcU7i0OEd6cQLrCpQflIXNo3luGr8FQ==
X-Google-Smtp-Source: ABdhPJyOOCHZTfxQuPqnWSircnOLYmypXJ0BDhCrlliqBmr7shUnhnSCkwWYII615s61CdlxKkoQpw==
X-Received: by 2002:ac2:5396:: with SMTP id g22mr1831262lfh.4.1612361443471;
        Wed, 03 Feb 2021 06:10:43 -0800 (PST)
Received: from [192.168.167.128] (37-145-186-126.broadband.corbina.ru. [37.145.186.126])
        by smtp.gmail.com with ESMTPSA id c123sm253317lfd.95.2021.02.03.06.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 06:10:42 -0800 (PST)
Message-ID: <dc35fdd3eb2febbe49cfd6561da6faf045f12ee3.camel@gmail.com>
Subject: Re: [RFC v2 3/4] KVM: add support for ioregionfd cmds/replies
 serialization
From:   Elena Afanasova <eafanasova@gmail.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     kvm@vger.kernel.org, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com
Date:   Wed, 03 Feb 2021 06:10:25 -0800
In-Reply-To: <20210130185415.GD98016@stefanha-x1.localdomain>
References: <cover.1611850290.git.eafanasova@gmail.com>
         <294d8a0e08eff4ec9c8f8f62492f29163e6c4319.1611850291.git.eafanasova@gmail.com>
         <20210130185415.GD98016@stefanha-x1.localdomain>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2021-01-30 at 18:54 +0000, Stefan Hajnoczi wrote:
> On Thu, Jan 28, 2021 at 09:32:22PM +0300, Elena Afanasova wrote:
> > Add ioregionfd context and kvm_io_device_ops->prepare/finish()
> > in order to serialize all bytes requested by guest.
> > 
> > Signed-off-by: Elena Afanasova <eafanasova@gmail.com>
> > ---
> >  arch/x86/kvm/x86.c       |  19 ++++++++
> >  include/kvm/iodev.h      |  14 ++++++
> >  include/linux/kvm_host.h |   4 ++
> >  virt/kvm/ioregion.c      | 102 +++++++++++++++++++++++++++++++++
> > ------
> >  virt/kvm/kvm_main.c      |  32 ++++++++++++
> >  5 files changed, 157 insertions(+), 14 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index a04516b531da..393fb0f4bf46 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -5802,6 +5802,8 @@ static int vcpu_mmio_write(struct kvm_vcpu
> > *vcpu, gpa_t addr, int len,
> >  	int ret = 0;
> >  	bool is_apic;
> >  
> > +	kvm_io_bus_prepare(vcpu, KVM_MMIO_BUS, addr, len);
> > +
> >  	do {
> >  		n = min(len, 8);
> >  		is_apic = lapic_in_kernel(vcpu) &&
> > @@ -5823,8 +5825,10 @@ static int vcpu_mmio_write(struct kvm_vcpu
> > *vcpu, gpa_t addr, int len,
> >  	if (ret == -EINTR) {
> >  		vcpu->run->exit_reason = KVM_EXIT_INTR;
> >  		++vcpu->stat.signal_exits;
> > +		return handled;
> >  	}
> >  #endif
> > +	kvm_io_bus_finish(vcpu, KVM_MMIO_BUS, addr, len);
> 
> Hmm...it would be nice for kvm_io_bus_prepare() to return the idx or
> the
> device pointer so the devices don't need to be searched in
> read/write/finish. However, it's complicated by the loop which may
> access multiple devices.
> 
Agree

> > @@ -9309,6 +9325,7 @@ static int complete_ioregion_mmio(struct
> > kvm_vcpu *vcpu)
> >  		vcpu->mmio_cur_fragment++;
> >  	}
> >  
> > +	vcpu->ioregion_ctx.dev->ops->finish(vcpu->ioregion_ctx.dev);
> >  	vcpu->mmio_needed = 0;
> >  	if (!vcpu->ioregion_ctx.in) {
> >  		srcu_read_unlock(&vcpu->kvm->srcu, idx);
> > @@ -9333,6 +9350,7 @@ static int complete_ioregion_pio(struct
> > kvm_vcpu *vcpu)
> >  		vcpu->ioregion_ctx.val += vcpu->ioregion_ctx.len;
> >  	}
> >  
> > +	vcpu->ioregion_ctx.dev->ops->finish(vcpu->ioregion_ctx.dev);
> >  	if (vcpu->ioregion_ctx.in)
> >  		r = kvm_emulate_instruction(vcpu, EMULTYPE_NO_DECODE);
> >  	srcu_read_unlock(&vcpu->kvm->srcu, idx);
> > @@ -9352,6 +9370,7 @@ static int complete_ioregion_fast_pio(struct
> > kvm_vcpu *vcpu)
> >  	complete_ioregion_access(vcpu, vcpu->ioregion_ctx.addr,
> >  				 vcpu->ioregion_ctx.len,
> >  				 vcpu->ioregion_ctx.val);
> > +	vcpu->ioregion_ctx.dev->ops->finish(vcpu->ioregion_ctx.dev);
> >  	srcu_read_unlock(&vcpu->kvm->srcu, idx);
> >  
> >  	if (vcpu->ioregion_ctx.in) {
> 
> Normally userspace will invoke ioctl(KVM_RUN) and reach one of these
> completion functions, but what if the vcpu fd is closed instead?
> ->finish() should still be called to avoid leaks.
> 
Will fix

> > diff --git a/include/kvm/iodev.h b/include/kvm/iodev.h
> > index d75fc4365746..db8a3c69b7bb 100644
> > --- a/include/kvm/iodev.h
> > +++ b/include/kvm/iodev.h
> > @@ -25,6 +25,8 @@ struct kvm_io_device_ops {
> >  		     gpa_t addr,
> >  		     int len,
> >  		     const void *val);
> > +	void (*prepare)(struct kvm_io_device *this);
> > +	void (*finish)(struct kvm_io_device *this);
> >  	void (*destructor)(struct kvm_io_device *this);
> >  };
> >  
> > @@ -55,6 +57,18 @@ static inline int kvm_iodevice_write(struct
> > kvm_vcpu *vcpu,
> >  				 : -EOPNOTSUPP;
> >  }
> >  
> > +static inline void kvm_iodevice_prepare(struct kvm_io_device *dev)
> > +{
> > +	if (dev->ops->prepare)
> > +		dev->ops->prepare(dev);
> > +}
> > +
> > +static inline void kvm_iodevice_finish(struct kvm_io_device *dev)
> > +{
> > +	if (dev->ops->finish)
> > +		dev->ops->finish(dev);
> > +}
> 
> A performance optimization: keep a separate list of struct
> kvm_io_devices that implement prepare/finish. That way the search
> doesn't need to iterate over devices that don't support this
> interface.
> 
Thanks for the idea

> Before implementing an optimization like this it would be good to
> check
> how this patch affects performance on guests with many in-kernel
> devices
> (e.g. a guest that has many multi-queue virtio-net/blk devices with
> ioeventfd). ioregionfd shouldn't reduce performance of existing KVM
> configurations, so it's worth measuring.
> 
> > diff --git a/virt/kvm/ioregion.c b/virt/kvm/ioregion.c
> > index da38124e1418..3474090ccc8c 100644
> > --- a/virt/kvm/ioregion.c
> > +++ b/virt/kvm/ioregion.c
> > @@ -1,6 +1,6 @@
> >  // SPDX-License-Identifier: GPL-2.0-only
> >  #include <linux/kvm_host.h>
> > -#include <linux/fs.h>
> > +#include <linux/wait.h>
> >  #include <kvm/iodev.h>
> >  #include "eventfd.h"
> >  #include <uapi/linux/ioregion.h>
> > @@ -12,15 +12,23 @@ kvm_ioregionfd_init(struct kvm *kvm)
> >  	INIT_LIST_HEAD(&kvm->ioregions_pio);
> >  }
> >  
> > +/* Serializes ioregionfd cmds/replies */
> 
> Please expand on this comment:
> 
>   ioregions that share the same rfd are serialized so that only one
> vCPU
>   thread sends a struct ioregionfd_cmd to userspace at a time. This
>   ensures that the struct ioregionfd_resp received from userspace
> will
>   be processed by the one and only vCPU thread that sent it.
> 
>   A waitqueue is used to wake up waiting vCPU threads in order. Most
> of
>   the time the waitqueue is unused and the lock is not contended.
>   For best performance userspace should set up ioregionfds so that
> there
>   is no contention (e.g. dedicated ioregionfds for queue doorbell
>   registers on multi-queue devices).
> 
> A comment along these lines will give readers an idea of why the code
> does this.

Ok, thank you

