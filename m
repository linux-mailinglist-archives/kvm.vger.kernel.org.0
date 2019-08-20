Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93D3C95813
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2019 09:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729283AbfHTHQi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Aug 2019 03:16:38 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:32997 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfHTHQh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Aug 2019 03:16:37 -0400
Received: by mail-ot1-f66.google.com with SMTP id q20so4144324otl.0;
        Tue, 20 Aug 2019 00:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/HHjg0frQhplyQkLIENoQEPH8BOJA1EYcGzaVFRRncA=;
        b=VXWFA2/uLolpSCzI6N+HhX+txsqjmTRAauRxwHfrgMNZGU2V9VCSjW2MDu54rkNYef
         1RvpYn6oucqGeeuUEGr4c3PpBPe/q/m+hLAZUmng6AJe0VIOvVpQPK1fis9foOvn9MMt
         Zt2e89rq+0cmZQom/DuE2nppd1jdazuudHryu/SWBFG7KuS61Wd21gX0u84l6QKv7+5M
         bjpdwIs5b6sE3VVKqYri6zssO2GlyepnBIcbz9u0kE8d++j8YFkp8XNw6CQ9ygUJw29C
         upV/xfFnBVy9XOBA8pzY0lz4Nl05aKtd4XbHqjd+Lb/7oSaoGeYpKTx0pehJOQyr99aM
         z67w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/HHjg0frQhplyQkLIENoQEPH8BOJA1EYcGzaVFRRncA=;
        b=ZGkvNoq2iG7VDoKcdITnrX+0dFfKlvpZfoNVPGR2o5bkhirFP6l7JlBASYR9mAS15f
         Zxfu9NRJFHLEbBrMGY4P8+xJAZAb/flnDEhhDV9QwF8qKhY9f9l+u0d64HWxQftOTL5q
         56uzVIa2FHoxqfM2L3iQkQMUBQr2DvZi5ZPcVkbcqn+5J5thtGIIvoDhs8haGgfzPGI1
         nmG/3emdAj8jm0LQdFEDcIAWx77X6vthNfB5f3RsKjeS4zRxcVTGm8No37xRjSFdISsv
         LeSe1QoDP9DhTDtUNtDUtO7v5h5CZD0WsUH/SdLUPk3aeU/ZeqqqB+gGv5ZFfSM+iyoe
         Bzrg==
X-Gm-Message-State: APjAAAVY8SI6GbgIp0pUCsaOt2P7sAlegdZBS/x6Y0Xfz80OfK6neNn3
        ekHVjfYlCctltwsrgL8U59DtCB/QNZJmE8VQKzs=
X-Google-Smtp-Source: APXvYqyYvsxBipznmmC7MbFxscfLBciDnba1XHQSD0gxItRctOtusV6fO8/dD/I7nz4ILppxtHGb8d5CtfOp/cZoOBo=
X-Received: by 2002:a9d:7754:: with SMTP id t20mr20252119otl.56.1566285396712;
 Tue, 20 Aug 2019 00:16:36 -0700 (PDT)
MIME-Version: 1.0
References: <1563154124-18579-1-git-send-email-wanpengli@tencent.com> <ba3ae595-7f82-d17b-e8ed-6e86e9195ce5@redhat.com>
In-Reply-To: <ba3ae595-7f82-d17b-e8ed-6e86e9195ce5@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 20 Aug 2019 15:16:07 +0800
Message-ID: <CANRm+Cx1bEOXBx50K9gv08UWEGadKOCtCbAwVo0CFC-g1gS+Xg@mail.gmail.com>
Subject: Re: [PATCH RESEND] i386/kvm: support guest access CORE cstate
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kindly reminder, :)
On Mon, 15 Jul 2019 at 17:16, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 15/07/19 03:28, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Allow guest reads CORE cstate when exposing host CPU power management c=
apabilities
> > to the guest. PKG cstate is restricted to avoid a guest to get the whol=
e package
> > information in multi-tenant scenario.
> >
> > Cc: Eduardo Habkost <ehabkost@redhat.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
>
> Hi,
>
> QEMU is in hard freeze now.  This will be applied after the release.
>
> Thanks,
>
> Paolo
>
> > ---
> >  linux-headers/linux/kvm.h | 4 +++-
> >  target/i386/kvm.c         | 3 ++-
> >  2 files changed, 5 insertions(+), 2 deletions(-)
> >
> > diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
> > index b53ee59..d648fde 100644
> > --- a/linux-headers/linux/kvm.h
> > +++ b/linux-headers/linux/kvm.h
> > @@ -696,9 +696,11 @@ struct kvm_ioeventfd {
> >  #define KVM_X86_DISABLE_EXITS_MWAIT          (1 << 0)
> >  #define KVM_X86_DISABLE_EXITS_HLT            (1 << 1)
> >  #define KVM_X86_DISABLE_EXITS_PAUSE          (1 << 2)
> > +#define KVM_X86_DISABLE_EXITS_CSTATE         (1 << 3)
> >  #define KVM_X86_DISABLE_VALID_EXITS          (KVM_X86_DISABLE_EXITS_MW=
AIT | \
> >                                                KVM_X86_DISABLE_EXITS_HL=
T | \
> > -                                              KVM_X86_DISABLE_EXITS_PA=
USE)
> > +                                              KVM_X86_DISABLE_EXITS_PA=
USE | \
> > +                                              KVM_X86_DISABLE_EXITS_CS=
TATE)
> >
> >  /* for KVM_ENABLE_CAP */
> >  struct kvm_enable_cap {
> > diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> > index 3b29ce5..49a0cc1 100644
> > --- a/target/i386/kvm.c
> > +++ b/target/i386/kvm.c
> > @@ -1645,7 +1645,8 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
> >          if (disable_exits) {
> >              disable_exits &=3D (KVM_X86_DISABLE_EXITS_MWAIT |
> >                                KVM_X86_DISABLE_EXITS_HLT |
> > -                              KVM_X86_DISABLE_EXITS_PAUSE);
> > +                              KVM_X86_DISABLE_EXITS_PAUSE |
> > +                              KVM_X86_DISABLE_EXITS_CSTATE);
> >          }
> >
> >          ret =3D kvm_vm_enable_cap(s, KVM_CAP_X86_DISABLE_EXITS, 0,
> >
>
