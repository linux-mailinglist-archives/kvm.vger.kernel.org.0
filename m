Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB1D1FD2B6
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 18:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbgFQQsw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 12:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727824AbgFQQsu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jun 2020 12:48:50 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE677C06174E
        for <kvm@vger.kernel.org>; Wed, 17 Jun 2020 09:48:49 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id c75so2828050ila.8
        for <kvm@vger.kernel.org>; Wed, 17 Jun 2020 09:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C1m1sNsxt+pmFyO9zmeOR+ZlQ1V+PNbNheSbC5K30NE=;
        b=JkZDV62Xlw71dz/JaoZYaNaeZVHyaykn5PqCcWpXFcgmP2FaVyOzYM9uQyskKGZsm8
         NIB1EC5Vekm3hgbkejg1xlC+wxcZErRmV/voBrD+Rox0gMIxeNRnYohjCCuxpqwgfapC
         4gtKysxvI2pb0Wa2kIAjzvcoi6YvsvepYEiJnXncnHVZs6d+bpUNvH67tLmllvDptL8U
         zto623piIjWSwrrrPA/TLNNT2W8cOMFeCUeAn8ZRpxgE+lM8AjFlWBxxxnrtv8evDgid
         jKiVRfng8bjGIhRloq7tdFTnaZia7MkC+cFAm89sXZRTZ/NqQ9GrhPeQEeDtNug9ipie
         RDcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C1m1sNsxt+pmFyO9zmeOR+ZlQ1V+PNbNheSbC5K30NE=;
        b=FIS5NsvuS9oQhil5quwnzPt9r8FL80CSkD8LbOEyeJzhevs23qD2Y3/HTGm7RD6K8c
         sH89/+K+rb3/Ailw4y8Gu2kHyDk+5sES/UmUaM6BgvfHx5DVp3DhKoowa/ujYdG3F2Vy
         +oi59El3aXMd75l1A4u/TYZJbtvBV4b3jpVFYhCIMtUmy43lJplXrUVxQMLoeSf43ZGO
         vI2Sm1akv5bvVwqd+k/9h+DsJF32/VNXhJI1Pvyny/2h+cOh8SkEXChLgfgraihJV3uC
         8IorATqWkWZkXajS0sEayF/2zv0Yf/yoQ8ZK2zXdOE2BIFx45ufXe8vdHevduhBjdQur
         MF9w==
X-Gm-Message-State: AOAM532gRhdvFsZiHg+4Ei8TUBS7OXKObon6PEGRB+xJGlHDJIrUqHFF
        xAXPEGHHejnA6/wQb6ZUZ1dsSLmRbcSsX88tr0dtBA==
X-Google-Smtp-Source: ABdhPJyVtkt5I4e5RgBLgLKo2zuqJOAam0dFZZsYuMOSxQd+NK4vd4yPrgYH/ZRsMJwSuDuAD7kVSfJd9U6pUtYCN/Q=
X-Received: by 2002:a05:6e02:11a5:: with SMTP id 5mr9655996ilj.108.1592412529122;
 Wed, 17 Jun 2020 09:48:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200617034123.25647-1-sean.j.christopherson@intel.com> <87zh92gic9.fsf@vitty.brq.redhat.com>
In-Reply-To: <87zh92gic9.fsf@vitty.brq.redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 17 Jun 2020 09:48:38 -0700
Message-ID: <CALMp9eR-O6ikxYaqi5iYQsVp9KaHDAm_7h4f8FPvssBi2-7Eyw@mail.gmail.com>
Subject: Re: [PATCH] KVM: VMX: Remove vcpu_vmx's defunct copy of host_pkru
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 17, 2020 at 2:19 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
>
> > Remove vcpu_vmx.host_pkru, which got left behind when PKRU support was
> > moved to common x86 code.
> >
> > No functional change intended.
> >
> > Fixes: 37486135d3a7b ("KVM: x86: Fix pkru save/restore when guest CR4.PKE=0, move it to x86.c")
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.h | 2 --
> >  1 file changed, 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > index 8a83b5edc820..639798e4a6ca 100644
> > --- a/arch/x86/kvm/vmx/vmx.h
> > +++ b/arch/x86/kvm/vmx/vmx.h
> > @@ -288,8 +288,6 @@ struct vcpu_vmx {
> >
> >       u64 current_tsc_ratio;
> >
> > -     u32 host_pkru;
> > -
> >       unsigned long host_debugctlmsr;
> >
> >       /*
>
> (Is there a better [automated] way to figure out whether the particular
> field is being used or not than just dropping it and trying to compile
> the whole thing? Leaving #define-s, configs,... aside ...)
>
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
