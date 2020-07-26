Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB41222E206
	for <lists+kvm@lfdr.de>; Sun, 26 Jul 2020 20:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgGZSgI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Jul 2020 14:36:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36895 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726043AbgGZSgI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Jul 2020 14:36:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595788565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CCd534kbcEa29GKpOVkxv14/VG61uCp+SScamUpw60w=;
        b=eQkOKLSp4/HmH/mQc9lqo93C6Tj34Dx8bTHiCBPvI+tlRyNDScWTCCQvY7eV0r2qOesvQ/
        sfHkumiGrnAaWbH/bHtX+XzV2riFPFCGlxnv2HPXpUKPqRZ0Bxa0/gryedsGE/X4mOj+gJ
        CyiiSt616lnTnNrrXMsjKE9MJIP0Ldk=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-NcCCd2u0PnC3RY98q6ERPA-1; Sun, 26 Jul 2020 14:36:00 -0400
X-MC-Unique: NcCCd2u0PnC3RY98q6ERPA-1
Received: by mail-lf1-f71.google.com with SMTP id x9so3632277lfa.8
        for <kvm@vger.kernel.org>; Sun, 26 Jul 2020 11:36:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CCd534kbcEa29GKpOVkxv14/VG61uCp+SScamUpw60w=;
        b=Lv/zFLZMZMiNhAE7DnyV05JNktjKgLkpwOrYPwTUhFcWKeMlFXFotCgULhmDo64Uf9
         St4cPdASq/6ad87SnOgjZMQQT23piNaIHABEebYhtBeAUyodQK1yAVStNLoVnTFW28qN
         eDKw2pTum7gVTZQT3J7oON8+Efvzfs+Ihhw/9Ql00Z/XvAG+0OjZ0k/rESpB+ISxK+XF
         L/HuPJfx2TkehUEsKgUfJrIGhvT/ISe1HcMzGHUxYxz3NRMiaxNXZl+nJgqOEvOIw3AG
         mNBMsFBDoKOGa3PmaaMkaAsn52eXJstTFBff2ALrHlemcYq56+bQy5RxLkcsyzCkx0J2
         7PUw==
X-Gm-Message-State: AOAM533kVuOlDzW83FPnYhg4Bba0J0cSyRB2JZaGXqUzQZ9oDYfttfLE
        sH+uUIcZZglpuJ4kSPd3gO7urMNIYXl0Qby2/gzTOfbJcJ23f4BY4UJoLqXP4Em+2895ZryeXuH
        Ve1IsSJEoXkfp6fo03iQXdVNO0oP9
X-Received: by 2002:a2e:9b92:: with SMTP id z18mr9314066lji.364.1595788559306;
        Sun, 26 Jul 2020 11:35:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1lHoPJwvL5EM6n1PDeRsl+1rX1UoAqAxy4vd1au5G+5bbJterCXOdiLnTTIPwJ6s0wGjsAu/UhtjZxJXB7f8=
X-Received: by 2002:a2e:9b92:: with SMTP id z18mr9314053lji.364.1595788559035;
 Sun, 26 Jul 2020 11:35:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200722001513.298315-1-jusual@redhat.com> <87d04nq40h.fsf@vitty.brq.redhat.com>
In-Reply-To: <87d04nq40h.fsf@vitty.brq.redhat.com>
From:   Julia Suvorova <jusual@redhat.com>
Date:   Sun, 26 Jul 2020 20:35:47 +0200
Message-ID: <CAMDeoFX0oF3TSfzY8Yifd+9hBhdpKL40t8KFseBj2TsQYRYS8w@mail.gmail.com>
Subject: Re: [PATCH] x86/PCI: Use MMCONFIG by default for KVM guests
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Matthew Wilcox <willy@infradead.org>, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 22, 2020 at 11:43 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Julia Suvorova <jusual@redhat.com> writes:
>
> > Scanning for PCI devices at boot takes a long time for KVM guests. It
> > can be reduced if KVM will handle all configuration space accesses for
> > non-existent devices without going to userspace [1]. But for this to
> > work, all accesses must go through MMCONFIG.
> > This change allows to use pci_mmcfg as raw_pci_ops for 64-bit KVM
> > guests making MMCONFIG the default access method.
> >
> > [1] https://lkml.org/lkml/2020/5/14/936
> >
> > Signed-off-by: Julia Suvorova <jusual@redhat.com>
> > ---
> >  arch/x86/pci/direct.c      | 5 +++++
> >  arch/x86/pci/mmconfig_64.c | 3 +++
> >  2 files changed, 8 insertions(+)
> >
> > diff --git a/arch/x86/pci/direct.c b/arch/x86/pci/direct.c
> > index a51074c55982..8ff6b65d8f48 100644
> > --- a/arch/x86/pci/direct.c
> > +++ b/arch/x86/pci/direct.c
> > @@ -6,6 +6,7 @@
> >  #include <linux/pci.h>
> >  #include <linux/init.h>
> >  #include <linux/dmi.h>
> > +#include <linux/kvm_para.h>
> >  #include <asm/pci_x86.h>
> >
> >  /*
> > @@ -264,6 +265,10 @@ void __init pci_direct_init(int type)
> >  {
> >       if (type == 0)
> >               return;
> > +
> > +     if (raw_pci_ext_ops && kvm_para_available())
> > +             return;
> > +
> >       printk(KERN_INFO "PCI: Using configuration type %d for base access\n",
> >                type);
> >       if (type == 1) {
> > diff --git a/arch/x86/pci/mmconfig_64.c b/arch/x86/pci/mmconfig_64.c
> > index 0c7b6e66c644..9eb772821766 100644
> > --- a/arch/x86/pci/mmconfig_64.c
> > +++ b/arch/x86/pci/mmconfig_64.c
> > @@ -10,6 +10,7 @@
> >  #include <linux/init.h>
> >  #include <linux/acpi.h>
> >  #include <linux/bitmap.h>
> > +#include <linux/kvm_para.h>
> >  #include <linux/rcupdate.h>
> >  #include <asm/e820/api.h>
> >  #include <asm/pci_x86.h>
> > @@ -122,6 +123,8 @@ int __init pci_mmcfg_arch_init(void)
> >               }
> >
> >       raw_pci_ext_ops = &pci_mmcfg;
> > +     if (kvm_para_available())
> > +             raw_pci_ops = &pci_mmcfg;
> >
> >       return 1;
> >  }
>
> This implies mmconfig access method is always functional (when present)
> for all KVM guests, regardless of hypervisor version/which KVM userspace
> is is use/... In case the assumption is true the patch looks good (to
> me) but in case it isn't or if we think that more control over this
> is needed we may want to introduce a PV feature bit for KVM.

Ok, I'll introduce a feature bit and turn it on in QEMU.

> Also, I'm thinking about moving this to arch/x86/kernel/kvm.c: we can
> override x86_init.pci.arch_init and reassign raw_pci_ops after doing
> pci_arch_init().

This might be a good idea.

Best regards, Julia Suvorova.

