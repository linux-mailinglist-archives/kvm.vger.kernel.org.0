Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABD022F21
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 10:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730679AbfETIn4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 04:43:56 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:46891 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729934AbfETIn4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 04:43:56 -0400
Received: by mail-ot1-f68.google.com with SMTP id j49so12180494otc.13;
        Mon, 20 May 2019 01:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=poGLomknypPnnvqegI1e/8auc3NxDkJy8/MZab3jklw=;
        b=dxbouzY70Zidh7fwbXOY8MrXx/w++QKRfxIm7iIi6sTlMcp30X30MPAMiAgisdfUZQ
         u+C33znAN9PjThcSi0SI6EegQBSDfZsIn527lGsGkoufrD2CmTCob5ONCxdXuksvHKG4
         +Pf3Y5srRsG756NViTDiBb77l+C7wftiMBgK3pkOUMTfsnM3qVlP7Y11g36yjUkFJOqd
         duFiUbhKblvBjN6niTyJXf7nWomcLeXqAADUbwL3OseZYhjrS+KZQMmxPY+G92D0Zavn
         p9RR8XgozDeHAMywB8gW9WgPOtomb2OMZj3+vOkQGhZIDo6bjlHxoVJAyqs/svnWQRos
         uFjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=poGLomknypPnnvqegI1e/8auc3NxDkJy8/MZab3jklw=;
        b=Rd83rhtwwRpKzBGm7rRBp5R13v1PMyNTqt+0UQYp27TIyG2mXhoMlN3c0aBCjcMAil
         G8tgnj89ZId+hd9Im47XtV6J/WE+vWrFtCyNjF/DjNgut7xVBTx0HF0Oj5XYynSjcunk
         QtDELZo9p/SXBUgU0FAxJqwwDpja1UrhhtS09swXpjlPlmkTh0FHYnrdHGoe/tF4P3Rj
         JVRLf6cg0NnELG8MWRoYRlJ0I49sQDkic+V8e0tW7YKrJ/KxYFnD9R6LaHOZ726yWQ3r
         2wcgZyPB22t+PyaEC0oirvNUe22eQTEEUJjUSRh8ePKiLWv9QgBu2S749oIgfwKpTwHI
         yBOg==
X-Gm-Message-State: APjAAAUv15H2QfdbJ51Zgm6o+vKhuAAzNv4VlX6fLL3xkfarm9Ng8m5U
        MDcnNaUZ8fQehMaRDh6kGK4g4kzeVCOUwlQs+ac=
X-Google-Smtp-Source: APXvYqztqQBZjxQh4DiQouR9Qgf5drkSFi++nsPdTOpATzN0wEeRuUMPtXCuPqzuvcjewHKAszFeyrgoG4N99SUyw4g=
X-Received: by 2002:a9d:6312:: with SMTP id q18mr3208532otk.45.1558341835532;
 Mon, 20 May 2019 01:43:55 -0700 (PDT)
MIME-Version: 1.0
References: <1557975980-9875-1-git-send-email-wanpengli@tencent.com>
 <1557975980-9875-4-git-send-email-wanpengli@tencent.com> <20190517200509.GJ15006@linux.intel.com>
In-Reply-To: <20190517200509.GJ15006@linux.intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 20 May 2019 16:43:46 +0800
Message-ID: <CANRm+CxT96pPsqzNXMvJWU-rk3SuZ8yXGBu9BVQdrtyuqAuLdQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] KVM: LAPIC: Expose per-vCPU timer_advance_ns to userspace
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 18 May 2019 at 04:05, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Thu, May 16, 2019 at 11:06:18AM +0800, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Expose per-vCPU timer_advance_ns to userspace, so it is able to
> > query the auto-adjusted value.
> >
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> > Cc: Liran Alon <liran.alon@oracle.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/debugfs.c | 16 ++++++++++++++++
> >  1 file changed, 16 insertions(+)
> >
> > diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
> > index c19c7ed..a6f1f93 100644
> > --- a/arch/x86/kvm/debugfs.c
> > +++ b/arch/x86/kvm/debugfs.c
> > @@ -9,12 +9,22 @@
> >   */
> >  #include <linux/kvm_host.h>
> >  #include <linux/debugfs.h>
> > +#include "lapic.h"
> >
> >  bool kvm_arch_has_vcpu_debugfs(void)
> >  {
> >       return true;
> >  }
> >
> > +static int vcpu_get_timer_advance_ns(void *data, u64 *val)
> > +{
> > +     struct kvm_vcpu *vcpu =3D (struct kvm_vcpu *) data;
> > +     *val =3D vcpu->arch.apic->lapic_timer.timer_advance_ns;
>
> This needs to ensure to check lapic_in_kernel() to ensure apic isn't NULL=
.
> Actually, I think we can skip creation of the parameter entirely if
> lapic_in_kernel() is false.  VMX and SVM both instantiate the lapic
> during kvm_arch_vcpu_create(), which is (obviously) called before
> kvm_arch_create_vcpu_debugfs().

Handle this in v4.

>
> > +     return 0;
> > +}
> > +
> > +DEFINE_SIMPLE_ATTRIBUTE(vcpu_timer_advance_ns_fops, vcpu_get_timer_adv=
ance_ns, NULL, "%llu\n");
> > +
> >  static int vcpu_get_tsc_offset(void *data, u64 *val)
> >  {
> >       struct kvm_vcpu *vcpu =3D (struct kvm_vcpu *) data;
> > @@ -51,6 +61,12 @@ int kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vc=
pu)
> >       if (!ret)
> >               return -ENOMEM;
> >
> > +     ret =3D debugfs_create_file("lapic_timer_advance_ns", 0444,
> > +                                                     vcpu->debugfs_den=
try,
> > +                                                     vcpu, &vcpu_timer=
_advance_ns_fops);
> > +     if (!ret)
> > +             return -ENOMEM;
> > +
> >       if (kvm_has_tsc_control) {
> >               ret =3D debugfs_create_file("tsc-scaling-ratio", 0444,
> >                                                       vcpu->debugfs_den=
try,
> > --
> > 2.7.4
> >
