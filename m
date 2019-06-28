Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E238594F3
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2019 09:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfF1HaL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 03:30:11 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:40444 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbfF1HaK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jun 2019 03:30:10 -0400
Received: by mail-oi1-f193.google.com with SMTP id w196so3572490oie.7;
        Fri, 28 Jun 2019 00:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rPmAc12QB/dObXVaxjhcY1vUDZ7bOEFU41CSHx26tMU=;
        b=XFw2v0vUl8eRU/wUY4labQGC/L3Xpzfs0JErb+60DwJAFeE71kvau/gD2oXLIvctoJ
         wLnkCpZ0WoE3jJt2GlComIIxLpzIsjP4ZIBuQMdkwFGB2rj+ETsNSCuH+hYVOByQPSYz
         Uwr8ogq5xo/jiXPV0GkONlcLvUzzWYxYN68s7Hzu767HeNiNOvBH+KH6lmUm80Q3Gdi8
         BXtnkifah9yfJAWxdLth5dWVhb9CKWZqhaEMOU+Dc1ApZoSiDsDLmGKVm5igVdxjvQ5Q
         K82ZuIJMdcI7ek+r64pQ0eYvotbuAV/IS8gexPBJFeAdRv5qcrl6XCJwsqo45OkzNYgL
         +Qfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rPmAc12QB/dObXVaxjhcY1vUDZ7bOEFU41CSHx26tMU=;
        b=YUnQITPBEV2RUb2krGGU7zQHevrNxrNe0pFiM7rZ/UhXM0lUXZnvNi5qbU5Po9k69i
         1M6s2EiUYvRLnCa4xkrmEzB0ouWIUYYQPxJqlwjrJqlmfM5Gv4jinpFGR6PvApQXgTCd
         +oKv5Z+zQGtKkS/0sPc8sc99AAZcXlSom7EBtP7c8GzinTkJ3jJn4VPnbqMx90INGLTc
         rLShRcLv9+nBnJs+MGG9yZc0DEosKb6dEQgPUuSSOFQInH4hCscLCH6gV0tI8TfuUNik
         14/V6Yo9qOuLKLgqZDBiYmuOCwkhcjdgGI3wtoAcfisTa6T/0RdOOCoJp5PPuWXT834Y
         h3Cw==
X-Gm-Message-State: APjAAAV8l1sG/itWGnoRDsVdE4J5WkJq+2bnsYBI2H0ux7Fft26peGe7
        AMROpIWWQuTsc9A3ubDky1mSZHVxT6K46ukeUE5gG3Zx
X-Google-Smtp-Source: APXvYqxceegnIIzidgYPuyNqFkqwb4errG5wPWapwIBSFWnQsfooB5k7ZDHMtD1YCtRxXhmdT7wAuB4Thjs6r4joL2s=
X-Received: by 2002:aca:544b:: with SMTP id i72mr909821oib.174.1561707009875;
 Fri, 28 Jun 2019 00:30:09 -0700 (PDT)
MIME-Version: 1.0
References: <1560255830-8656-1-git-send-email-wanpengli@tencent.com> <CANRm+CwfXViF34eLma5ZnqjT96Sq=XehpBiTZTj1TfJnkevVMA@mail.gmail.com>
In-Reply-To: <CANRm+CwfXViF34eLma5ZnqjT96Sq=XehpBiTZTj1TfJnkevVMA@mail.gmail.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 28 Jun 2019 15:29:58 +0800
Message-ID: <CANRm+Cz6vX587uLV__FheXuiOe7pzfGeUZb++ZJ1y9Cmk6GkoA@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] KVM: Yield to IPI target if necessary
To:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ping again,
On Tue, 18 Jun 2019 at 17:00, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> ping, :)
> On Tue, 11 Jun 2019 at 20:23, Wanpeng Li <kernellwp@gmail.com> wrote:
> >
> > The idea is from Xen, when sending a call-function IPI-many to vCPUs,
> > yield if any of the IPI target vCPUs was preempted. 17% performance
> > increasement of ebizzy benchmark can be observed in an over-subscribe
> > environment. (w/ kvm-pv-tlb disabled, testing TLB flush call-function
> > IPI-many since call-function is not easy to be trigged by userspace
> > workload).
> >
> > v3 -> v4:
> >  * check map->phys_map[dest_id]
> >  * more cleaner kvm_sched_yield()
> >
> > v2 -> v3:
> >  * add bounds-check on dest_id
> >
> > v1 -> v2:
> >  * check map is not NULL
> >  * check map->phys_map[dest_id] is not NULL
> >  * make kvm_sched_yield static
> >  * change dest_id to unsinged long
> >
> > Wanpeng Li (3):
> >   KVM: X86: Yield to IPI target if necessary
> >   KVM: X86: Implement PV sched yield hypercall
> >   KVM: X86: Expose PV_SCHED_YIELD CPUID feature bit to guest
> >
> >  Documentation/virtual/kvm/cpuid.txt      |  4 ++++
> >  Documentation/virtual/kvm/hypercalls.txt | 11 +++++++++++
> >  arch/x86/include/uapi/asm/kvm_para.h     |  1 +
> >  arch/x86/kernel/kvm.c                    | 21 +++++++++++++++++++++
> >  arch/x86/kvm/cpuid.c                     |  3 ++-
> >  arch/x86/kvm/x86.c                       | 21 +++++++++++++++++++++
> >  include/uapi/linux/kvm_para.h            |  1 +
> >  7 files changed, 61 insertions(+), 1 deletion(-)
> >
> > --
> > 2.7.4
> >
