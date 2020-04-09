Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D42FE1A3717
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 17:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbgDIP2C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 11:28:02 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:33246 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728061AbgDIP2B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 11:28:01 -0400
Received: by mail-io1-f65.google.com with SMTP id o127so7467iof.0
        for <kvm@vger.kernel.org>; Thu, 09 Apr 2020 08:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tDujFRTI+FZL6HeDsvCOHzCg7LFMG75v0U0c7h/snhI=;
        b=PLsn0m7o7d65MnraYJPNDSRxosIuTPb+QpNG8WkFsEGuI1N5cJ8yDJoKAhx7qrc/X/
         iwoMZu/9u4mR1u/aAhYQKeECm4hSUDB5e380eBa5KMdOpKQNYVz8PH+/4s8dztIqWveK
         mBG5Qgq2kb8q7EwGDS269ptrZu/r6fVxK4hN6TfkfZ8aKOjuC+4Ty0V2+NDglfwhLsns
         Qwl1j9wDx0FKo2zUvrdZJtz7YO0zYVGvQLJXBzBkH5YsJX5pfSDcApak2YNSPI9BPI4W
         2CzmArCf5RyXI8UEtBwYuBLVX6fdac+tno7nZBiIlV/RTRBBYzjnZCbwPa18iT+OCjZE
         6NQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tDujFRTI+FZL6HeDsvCOHzCg7LFMG75v0U0c7h/snhI=;
        b=Xm8IjfwV3ZczVpvrUkVrBfwLvxQCYjAmS8yOhAtwmwr3mSahVme7qCOBXnz7W2qnIh
         qzrQA7NhXWkcta/ZlW93ncwvzgXNaEB3e8qj3XlsBVnHeWmnD3S5e2S+zGny1M5h4hi0
         4/RtP56a9qQlp8fEAtDWgWWB6eROwXdEecrUX11+MmetQQV9XTNnYt1DiI9aL6WwxcoG
         lfZzvhIg2yK+9QZdvPkp2Uq6cKDEIQwti39H+xM0CXBuspLpYZYNh/yUb4V3QDqBAzEN
         y+0yj7y2kdQIOmrUzTatWKndBW2KkOzYNzOBTOgqZzAhPPdcP/g1ujuqg0KqrFlwmpSA
         I+qA==
X-Gm-Message-State: AGi0PuZrusdox+tU64ZZ/bLz82Bk5UWZdqceoNyXV8gNeoeUI4OUntIc
        zzElgoJp7Q/GBJ9rRsfSxPsMJ+vRKZ1nTbrHnQY=
X-Google-Smtp-Source: APiQypKkIEeLFICs4j79pf2PRDNfcvCoDivDC6eYSTddq85ZWwXa5S7TbzqnhpK6vohaz7yma+lPSYJNkg1Il0wy5yA=
X-Received: by 2002:a02:90c1:: with SMTP id c1mr3280813jag.69.1586446081369;
 Thu, 09 Apr 2020 08:28:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200409114926.1407442-1-ubizjak@gmail.com> <0ee54833-bbed-4263-7c7e-4091ab956168@intel.com>
In-Reply-To: <0ee54833-bbed-4263-7c7e-4091ab956168@intel.com>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Thu, 9 Apr 2020 17:27:49 +0200
Message-ID: <CAFULd4awe3Y1xXW+umWsjE69i2Fv0R5=0V0SveqnxjVQ2ijY1g@mail.gmail.com>
Subject: Re: [PATCH] KVM: SVM: Fix __svm_vcpu_run declaration.
To:     like.xu@intel.com
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 9, 2020 at 5:11 PM Xu, Like <like.xu@intel.com> wrote:
>
> Hi Bizjak,
>
> On 2020/4/9 19:49, Uros Bizjak wrote:
> > The function returns no value.
> >
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Fixes: 199cd1d7b534 ("KVM: SVM: Split svm_vcpu_run inline assembly to separate file")
> > Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> > ---
> >   arch/x86/kvm/svm/svm.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 2be5bbae3a40..061d19e69c73 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -3276,7 +3276,7 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
> >       svm_complete_interrupts(svm);
> >   }
> >
> > -bool __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs);
> Just curious if __svm_vcpu_run() will fail to enter SVM guest mode,
> and a return value could indicate that nothing went wrong rather than
> blindly keeping silent.

vmload, vmrun and vmsave do not return anything in flags or registers,
so we can't detect anything at this point, modulo exception that is
handled below the respective instruction.

BTW: the change by itself does not change the generated code, the fake
return value from __svm_vcpu_run is already ignored. So, the change is
mostly cosmetic.

Uros.
