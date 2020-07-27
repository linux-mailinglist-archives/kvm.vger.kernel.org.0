Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1182522EE35
	for <lists+kvm@lfdr.de>; Mon, 27 Jul 2020 16:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728458AbgG0OE4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 10:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbgG0OEz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jul 2020 10:04:55 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F94C061794;
        Mon, 27 Jul 2020 07:04:55 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id g67so9576870pgc.8;
        Mon, 27 Jul 2020 07:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RyHF/+puhzg55DCNoaFMk4tPij78gjhmB7e2S31c+Mw=;
        b=qi4gB50pKm/HTNHxwz2l1Wt6UHixmVaBVfd095HTeG1HF7fPr2fgjtU/lhdRFdLtpg
         5GkR6ciAukxRBC+6p/hijprEOWr6N/ti21TRGyJLkERBWKbcmHE61jktGdd4ng2S4kqi
         WShBSGiN26EzaKt5iiyEqR8/iq4Fkh1VgbsnEp0nPozR9K0APamac8qJVtU3IUVRLUjq
         x5cjgotwkcFr5An8m7dLJTN+EeWNro1wS4oBt4ArK1Nh5ki2EP6RTF3iqXgM+RkuW7+r
         /WL01dMKNkEocdqD8nVLUF1cENjPhpwaNbqiU1Go0XOwsAHSJ3tNCtaC6VS+os8eeaa8
         e5Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RyHF/+puhzg55DCNoaFMk4tPij78gjhmB7e2S31c+Mw=;
        b=ISPI0Z4WhibWSsl8pqyvWApTkmpBtJSq8peGBvhwvxipy8Tu4fHheKjWEPvrl3y8C4
         rgKeYkX7RDNLYb9p0/8QeI/pi6BSqAKaxGlLi0Jse//jZw9G4GDQ+ULe3iJ2XhYbqY+I
         HxyuT716ZVVbGIqgNphmcq9aEqHlpTqn5dQzfGUJalu5kN3q99WsBv6nYInWWxddhTFa
         ty65LFLLzob7soynnqCiCk1ylMhvyYda2GE3dIg2y/CWQz2n5EFGFO++VeZkEO2MTP0g
         GLLDYMpiavy8r0CZg0smT3tCVROedpgXPNuUN6A8YtX3xX5MPIn7Mpt3ACGP/BtWQ5LS
         YM2Q==
X-Gm-Message-State: AOAM531auIsid3FBpJymUN4y+YUcPl9dbXnXcecaAc+FQFaPdNqutbCH
        w0vX3eH8Qzj/9cttIPqp7Up0e/Az+2Qqq35Z2vk=
X-Google-Smtp-Source: ABdhPJzovOawUCJEI4j6HaCrflDk4hy4VX1DIO68Q/H7U8G0USPW7WPLKWfPlN3cxl4gmpC7xS9QZFiZXbVUBcWcqIA=
X-Received: by 2002:a63:ce41:: with SMTP id r1mr20428734pgi.203.1595858694737;
 Mon, 27 Jul 2020 07:04:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200722001513.298315-1-jusual@redhat.com> <87d04nq40h.fsf@vitty.brq.redhat.com>
In-Reply-To: <87d04nq40h.fsf@vitty.brq.redhat.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 27 Jul 2020 17:04:39 +0300
Message-ID: <CAHp75VfLjYvFUVw+uHbMJCeoNfs6nb4Qh1OoQraA5bTkR9SeRg@mail.gmail.com>
Subject: Re: [PATCH] x86/PCI: Use MMCONFIG by default for KVM guests
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Julia Suvorova <jusual@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 22, 2020 at 12:47 PM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> Julia Suvorova <jusual@redhat.com> writes:

> > Scanning for PCI devices at boot takes a long time for KVM guests. It
> > can be reduced if KVM will handle all configuration space accesses for
> > non-existent devices without going to userspace [1]. But for this to
> > work, all accesses must go through MMCONFIG.
> > This change allows to use pci_mmcfg as raw_pci_ops for 64-bit KVM
> > guests making MMCONFIG the default access method.

I'm not sure it won't break anything.

> > [1] https://lkml.org/lkml/2020/5/14/936

use Link: tag and better to use lore.kernel.org.

> This implies mmconfig access method is always functional (when present)
> for all KVM guests, regardless of hypervisor version/which KVM userspace
> is is use/... In case the assumption is true the patch looks good (to
> me) but in case it isn't or if we think that more control over this
> is needed we may want to introduce a PV feature bit for KVM.
>
> Also, I'm thinking about moving this to arch/x86/kernel/kvm.c: we can
> override x86_init.pci.arch_init and reassign raw_pci_ops after doing
> pci_arch_init().

% git grep -n -w x86_init.pci.arch_init -- arch/x86/
arch/x86/hyperv/hv_init.c:400:  x86_init.pci.arch_init = hv_pci_init;
arch/x86/kernel/apic/apic_numachip.c:203:       x86_init.pci.arch_init
= pci_numachip_init;
arch/x86/kernel/jailhouse.c:207:        x86_init.pci.arch_init
 = jailhouse_pci_arch_init;
arch/x86/pci/init.c:20: if (x86_init.pci.arch_init && !x86_init.pci.arch_init())
arch/x86/platform/intel-mid/intel-mid.c:172:    x86_init.pci.arch_init
= intel_mid_pci_init;
arch/x86/platform/olpc/olpc.c:309:              x86_init.pci.arch_init
= pci_olpc_init;
arch/x86/xen/enlighten_pv.c:1411:
x86_init.pci.arch_init = pci_xen_init;

Are you going to update all these? Or how this is supposed to work (I
may be missing something)?

-- 
With Best Regards,
Andy Shevchenko
