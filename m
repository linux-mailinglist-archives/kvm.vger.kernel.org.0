Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 830F11CB6D2
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 20:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgEHSOQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 14:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726864AbgEHSOQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 May 2020 14:14:16 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A2CCC061A0C
        for <kvm@vger.kernel.org>; Fri,  8 May 2020 11:14:16 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id x2so2248377ilp.13
        for <kvm@vger.kernel.org>; Fri, 08 May 2020 11:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rSRa8YSQMkfb0kSyDR/KqHWvo8tJrzRV0hN5xGpT7hU=;
        b=l0qAV6geX4Uhl64STyjOoaVnDDgu8TOzdU3Koc+pQb8w4fPoD66whYbkWqUplQRF1s
         nMoLwFpJnPihczYtIFhUV+aFtC8dGBb9sENFrdK8RVcZjvcI6c84K1p3xzX1J3LRbAil
         Y0WpJ9sJ0dVgrTpZQYXONIMsB6AOBN/Gu5k0cw4h+hMkAmiYnKAmChnXfuwbHVlPgdUx
         h+WgK/qM3w1owPvmSYYLOChKt0qaHeeQmq4ufnDv3Ma4TS2rW4/ICovTYOvAXzLa5kHM
         NgkHc3n3x+J8rXJT68P7bOEFhjvooEQWFMkg5tM1PRvNp9xVV/Og/3sd8EWqUA4mz/Jm
         Evvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rSRa8YSQMkfb0kSyDR/KqHWvo8tJrzRV0hN5xGpT7hU=;
        b=GRuuk0enTsGBaGFjdesXCeQZqKfTcRsOHU7B2d0/yRIjheWo9i6beaGt7K0hBo/QY7
         OzcM+NlHD9i8GWPcPG9LbGkxuk16nVPBZI0uV1Eb/glsbFVfVcgBvj8ou1Rzgm8JfPvc
         BADTXznQVBViS/qhlIe7Xnk8RXJjpAjdqUDGBKruQwjjEGRL9ThFuzVH/cmxOY+aw/TD
         soSAF9opqEDYAdOC6ldWOFQlT4PBuZ371XppM9nG7IxVTe9GEEpyjyTru8r0cZ/tC6CI
         51i+19Ce6jat22dKqnuMZ7wePq7yJfxtiiRhic31zMIvCnmyaa2/lENGZe7hFYlQa/DR
         uwgQ==
X-Gm-Message-State: AGi0PuazvxEa8Y8DCWK37ywT0XRNoYeov1/6cXPiYAj61sjkdz9HzmHF
        1Ppf/pJutc4NZf49IkE4Tm2TzCEHTApboEzZPS9ZmtLw
X-Google-Smtp-Source: APiQypLBjLmB0z7hvl8Xvf+iTFYeVFqYHTs2uyTA/X/LRlmoKB9oO8VlGpLBW+ssaBsPBFABf8RdJp8WVYulalKdLN0=
X-Received: by 2002:a92:d484:: with SMTP id p4mr3968198ilg.307.1588961655347;
 Fri, 08 May 2020 11:14:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200508062753.10889-1-ubizjak@gmail.com> <20200508175737.GM27052@linux.intel.com>
In-Reply-To: <20200508175737.GM27052@linux.intel.com>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Fri, 8 May 2020 20:14:04 +0200
Message-ID: <CAFULd4aEGLB9pHXYsXdGUQGEeOMnW0283VV-_+e_j-6exMb6aA@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Move definition of __ex to kvm_host.h
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 8, 2020 at 7:57 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Fri, May 08, 2020 at 08:27:53AM +0200, Uros Bizjak wrote:
> > Move the definition of __ex to a common include to be
> > shared between VMX and SVM.
> >
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h | 2 ++
> >  arch/x86/kvm/svm/svm.c          | 2 --
> >  arch/x86/kvm/vmx/ops.h          | 2 --
> >  3 files changed, 2 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 35a915787559..4df0c07b0a62 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1620,6 +1620,8 @@ asmlinkage void kvm_spurious_fault(void);
> >       "668: \n\t"                                                     \
> >       _ASM_EXTABLE(666b, 667b)
> >
> > +#define __ex(x) __kvm_handle_fault_on_reboot(x)
>
> Moving this to asm/kvm_host.h is a bit sketchy as __ex() isn't exactly the
> most unique name.  arch/x86/kvm/x86.h would probably be a better
> destination as it's "private".  __ex() is only used in vmx.c, nested.c and
> svm.c, all of which already include x86.h.

I have put this define nearby __kvm_handle_fault_on_reboot, as __ex is
its sole user.

OTOH, it looks that __kvm_handle_fault_on_reboot definition and
kvm_spurious_fault prototype can both  be moved to x86.h.

Uros.
