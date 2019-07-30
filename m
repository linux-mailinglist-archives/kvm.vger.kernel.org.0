Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF05779E8D
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 04:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731182AbfG3CSL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jul 2019 22:18:11 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:33700 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730481AbfG3CSL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jul 2019 22:18:11 -0400
Received: by mail-ot1-f66.google.com with SMTP id q20so64606634otl.0;
        Mon, 29 Jul 2019 19:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eT2pD5eKBMx5gGTM/NsO7JF/ZYMOot8wTiCyMk+wWBg=;
        b=rmZD631c3zb9t37DEReR0m+DgU4V6ZollHW2wnFI1NyISMUcIdtkksOmIcmGPxMtaq
         4xtZ0xtypLnOkX62UMC1Xcx02LLuvbAWfkrSapRzU3mlDsK1RiHzvBieMW+X5ttZ/RpF
         FE6++BN88pAbV0gsO5fw3Q8LN5tZfL8X68/FbUbvxrAaFqq467XmnmAuAKhpS96vFDR8
         sLtnyIFg6kr5pAs+3pmY5uJF3tTl/Ntju7JGRAERgggL7kRdQ/1qdD93rpg8L8UPBbf+
         Ol/px6I5F7TK06c5MhuFy68gIvzs8cqR3Z8oENBFakoxF0LjXzUOe1WmmcPuNO5bt1bA
         UJdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eT2pD5eKBMx5gGTM/NsO7JF/ZYMOot8wTiCyMk+wWBg=;
        b=uTaM7cT8h3DTHdzmeIWNZx2owTbWypmpPtNAxAhdIXcKe5zNGVgySPrT3XKYB+XjaE
         v1od5K+IUgk2pNhQMxsxZtaBW9CLTY9ja9nW/xtsYfi4gzf+x/zzMpgqnQDTaWjWFzym
         fRL/DhrPalwoS5+WXfd47g3gpi+xsuvpg8KxyKARjhzY3JTAWiQYLlp+zFnwFthrXxVM
         bTchoOG8sY1qk8uwwd6Zz7spwwdbg290wVD6I8Gk9R1wZv5B0GWxZmpBNPmY79m0XGMz
         2hW20Jni6Cs/gr1yAF5UG/kbv1oDPHyMEfhzzPk27cmygxRVnu3mCC5BAqZ2vEP9CtgO
         QLig==
X-Gm-Message-State: APjAAAV7rzWgD3yznXY15H+yQlXUQFoH2onbs3HkiPioAzZ2hWkseFeE
        9J78x0rluhye6RDhP91SXQy1rFbIRkNOmncSaRs=
X-Google-Smtp-Source: APXvYqyMQKZMpF1kw4G8VsqHgyMUcb+C/7YHXkVtxVIOSct89bGJlyUWASr7+1L2U+PjU9MPMhOMDgp2QzhoiFNqTAo=
X-Received: by 2002:a9d:62c4:: with SMTP id z4mr79917934otk.56.1564453089852;
 Mon, 29 Jul 2019 19:18:09 -0700 (PDT)
MIME-Version: 1.0
References: <1564121727-30020-1-git-send-email-wanpengli@tencent.com> <20190729175044.GI21120@linux.intel.com>
In-Reply-To: <20190729175044.GI21120@linux.intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 30 Jul 2019 10:17:58 +0800
Message-ID: <CANRm+CwL7ZsMS7DyA-vwbj00x3gRvTHLgbfYj0TdeEa1vmi-kw@mail.gmail.com>
Subject: Re: [PATCH RESEND] KVM: X86: Use IPI shorthands in kvm guest when support
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Nadav Amit <namit@vmware.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 30 Jul 2019 at 01:50, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Fri, Jul 26, 2019 at 02:15:27PM +0800, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > IPI shorthand is supported now by linux apic/x2apic driver, switch to
> > IPI shorthand for all excluding self and all including self destination
> > shorthand in kvm guest, to avoid splitting the target mask into servera=
l
> > PV IPI hypercalls.
> >
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> > Cc: Nadav Amit <namit@vmware.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> > Note: rebase against tip tree's x86/apic branch
> >
> >  arch/x86/kernel/kvm.c | 14 ++++++++++++--
> >  1 file changed, 12 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > index b7f34fe..87b73b8 100644
> > --- a/arch/x86/kernel/kvm.c
> > +++ b/arch/x86/kernel/kvm.c
> > @@ -34,7 +34,9 @@
> >  #include <asm/hypervisor.h>
> >  #include <asm/tlb.h>
> >
> > +static struct apic orig_apic;
>
> Copying the entire struct apic to snapshot two functions is funky,
> explicitly capturing the two functions would be more intuitive.
>
> Tangentially related, kvm_setup_pv_ipi() can be annotated __init,
> which means the function snapshots can be __ro_after_init.
>
> That being said, can't we just remove kvm_send_ipi_all() and
> kvm_send_ipi_allbutself()?  AFAICT, the variations that lead to shorthand
> are only used when apic_use_ipi_shorthand is true.  If that isn't the
> case, fixing the callers in the APIC code seems like the correct thing to
> do.

The callers in the APIC codes have already done this, so I just remove
the two hooks in v2.

Regards,
Wanpeng Li
