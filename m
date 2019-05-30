Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98E752EA19
	for <lists+kvm@lfdr.de>; Thu, 30 May 2019 03:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbfE3BKC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 May 2019 21:10:02 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:38239 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbfE3BKB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 May 2019 21:10:01 -0400
Received: by mail-oi1-f195.google.com with SMTP id 18so2888461oij.5;
        Wed, 29 May 2019 18:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/QWOK7mvM11aBaoeWXjkLlMbPoa5BTdf7AzqNiYer/E=;
        b=QqyttgTda14aWjZEGL+vqbJe+Gqk+CrytZgAWK7eMyvrA/Fw9Exa0E7jAnMXzMIS7z
         nG21x87aCzYhdPyXoRG4SzqztHrpBojU5kBhe1ifDRAHrk+WSJR8HZbA4ITrBBARyJ9Z
         uJVvy+8o3hakeiiV2GyriQscVFvw30D+e3oTuk6SxPWdZDUcQMBuG9Yhlk836xQgaGkt
         mQkpjLOYyp+dYa6ZpdaFSOVTOuDlD1e49snQKH0EhOnZvHjiHactytiptNCNrE3ASs4o
         YotJe4wePJrBfhKDlR2N1l9FXC+XTRS7cdhIXHedVrvejYdksvWIjtjMYyTf1HUk9MOF
         Ch8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/QWOK7mvM11aBaoeWXjkLlMbPoa5BTdf7AzqNiYer/E=;
        b=WKQ2poLCrSA7x2//WbSjNFt0rX77mB2KWPCfmGRlen+beIgAHpTFJt5OpCvK5Lz8N+
         shHzCxdR6b1Znf/SaQLR+kA1wkYD2xoMCAuah7CwPwbb7eU2UuO7UOjCAHhriCZT93c6
         ycxYawWNCpSDNvx086/ODfllWaRL5KH6SCw4SLCPjS5FwF0MB5GEm6XWzbdPocgtepBG
         GfFjyDpN7Dl9vkNCNxH6+61wo1LloyUezQc/24zTGPkdikMqJTh/GoXrah2e49xSI+3L
         QtWys/bFXFFqYWIPAnQw4GcsHd2G2CMT3CIiQNz7fSf6eQtPG1P+4yjccD7PKRFUKcLf
         CeNg==
X-Gm-Message-State: APjAAAWWn1RCimyd7xWolplfP/E90JbsGTiRE9R1KpIRo1yElCA+pyZL
        m6oJYHEN92h4wrxUorJMecxvUGwbYHFuHwf3WT4=
X-Google-Smtp-Source: APXvYqxCkJSeNEhIZqehOdT0ggm5DxLVr7eFQV74uVDL2C73BkBr5yTXL43P98cFkuzwgRNI0rbpXynnIghxR55zcpQ=
X-Received: by 2002:aca:3305:: with SMTP id z5mr762027oiz.141.1559178601213;
 Wed, 29 May 2019 18:10:01 -0700 (PDT)
MIME-Version: 1.0
References: <1559004795-19927-1-git-send-email-wanpengli@tencent.com>
 <1559004795-19927-3-git-send-email-wanpengli@tencent.com> <D119BC9B-3097-4453-BC17-5AE532EDB995@oracle.com>
In-Reply-To: <D119BC9B-3097-4453-BC17-5AE532EDB995@oracle.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 30 May 2019 09:09:52 +0800
Message-ID: <CANRm+Cx4egTwvbwwrS0Mi23QmesFDY+DkBAgVsC67o4ea3tYTg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] KVM: X86: Implement PV sched yield hypercall
To:     Liran Alon <liran.alon@oracle.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 29 May 2019 at 20:28, Liran Alon <liran.alon@oracle.com> wrote:
>
>
>
> > On 28 May 2019, at 3:53, Wanpeng Li <kernellwp@gmail.com> wrote:
> >
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > The target vCPUs are in runnable state after vcpu_kick and suitable
> > as a yield target. This patch implements the sched yield hypercall.
> >
> > 17% performace increase of ebizzy benchmark can be observed in an
> > over-subscribe environment. (w/ kvm-pv-tlb disabled, testing TLB flush
> > call-function IPI-many since call-function is not easy to be trigged
> > by userspace workload).
> >
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> > arch/x86/kvm/x86.c | 24 ++++++++++++++++++++++++
> > 1 file changed, 24 insertions(+)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index e7e57de..2ceef51 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -7172,6 +7172,26 @@ void kvm_vcpu_deactivate_apicv(struct kvm_vcpu *=
vcpu)
> >       kvm_x86_ops->refresh_apicv_exec_ctrl(vcpu);
> > }
> >
> > +void kvm_sched_yield(struct kvm *kvm, u64 dest_id)
> > +{
> > +     struct kvm_vcpu *target;
> > +     struct kvm_apic_map *map;
> > +
> > +     rcu_read_lock();
> > +     map =3D rcu_dereference(kvm->arch.apic_map);
> > +
> > +     if (unlikely(!map))
> > +             goto out;
> > +
>
> We should have a bounds-check here on =E2=80=9Cdest_id=E2=80=9D.

Yeah, fix it in v3.

Regards,
Wanpeng Li
