Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85D3FE000A
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 10:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729458AbfJVIyI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 04:54:08 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:33307 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728346AbfJVIyI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 04:54:08 -0400
Received: by mail-ot1-f67.google.com with SMTP id 60so13507042otu.0
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2019 01:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dOQT7brDSLVHQZ5HYLvcbdrbSrflixmCqXUksIzgvXw=;
        b=cZ1syUpG4BDXz4x9vbWpQpOBDQHUzdQVmv622hIDd9Iq8NqPyHYpyPGBK6L8luxWvW
         1UAS+rL8Vo+ESS6ZFIHbq4YI+XlFzcO0sWM9XZRC9l1KGd4OjP6wjCdS36HV+8fN7xIF
         9vApZeRLpgWm+Diwcr4F2Zz/jMN05W9vPl1yDfOizFICzf6iC/nNK7zODi0r+yqGL9yD
         MW4RO5sTmVz4YNTTEcaAFC54naokSGcCFbXqDSe/Vho24zcDzaa7u0RtZOJx7HgzJMNC
         lnXwvql6ny2jsFhMLNVnbBlnHT/RwlpqKZdeskTJZ5N/2M7fIS0+l9++eQt4DvBTcPGq
         Ox5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dOQT7brDSLVHQZ5HYLvcbdrbSrflixmCqXUksIzgvXw=;
        b=saD++4dSxpCQ0RMOtkvB7wmp/y4s63ghzciELCmzm1LgNJ+UHfuj9SHDUqv/2WOc5Y
         L2xMqagskIm5ZE06BXWek5VvOyXdXCnEisTAV9VeQMBZtoKYHbmqYfwvM2Ngb/y/SryY
         vQgjr0B9dSw3AGekrKsorI7+/YoerwyjZKhLNT68ueZUwQtsjNWy43h6pWxfw6jqEViO
         EXDsulr6UcnKztiUIHp9SLNzZ4T3hqjGIBCddwrLEJ6rXjNluRN06adnbizfKGZjRtyY
         PfP9U/hmU0PIDEXjbyXD77MK85tac1LLdXZRTDMcrYdPsU77jD0m+XIWWKwddeCPziho
         jd/g==
X-Gm-Message-State: APjAAAXLj1MYdkxkXmqm3kaQCufdCVsRbLWK8wWadJOuXG2B92WVLYjX
        0ZOtcpN0beSxNDOPby6nNDwyc5PC7hXLvr6hvfA=
X-Google-Smtp-Source: APXvYqz+PV8aHY2sm6m3qwOLsTh94rRDTl+fMhPUyv3gYhq+pnU2GkwOs8Pn1jFD59sHDXSzIHEe0twWwjEH342N3xU=
X-Received: by 2002:a9d:61d1:: with SMTP id h17mr1670381otk.254.1571734447037;
 Tue, 22 Oct 2019 01:54:07 -0700 (PDT)
MIME-Version: 1.0
References: <20191017235036.25624-1-sjitindarsingh@gmail.com>
 <87pniu0zcw.fsf@vitty.brq.redhat.com> <34e212a851eb0d490fad49f8b712b2c6e652db76.camel@gmail.com>
In-Reply-To: <34e212a851eb0d490fad49f8b712b2c6e652db76.camel@gmail.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 22 Oct 2019 16:53:56 +0800
Message-ID: <CANRm+CyqTeE4XmqL0KFY=Un2=nfRb1degsJJz1m080mgeE10HQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86/apic: Skip pv ipi test if hcall not available
To:     Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm <kvm@vger.kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Radim Krcmar <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 22 Oct 2019 at 06:51, Suraj Jitindar Singh
<sjitindarsingh@gmail.com> wrote:
>
> Hi,
>
> On Fri, 2019-10-18 at 18:53 +0200, Vitaly Kuznetsov wrote:
> > Suraj Jitindar Singh <sjitindarsingh@gmail.com> writes:
> >
> > > From: Suraj Jitindar Singh <surajjs@amazon.com>
> > >
> > > The test in x86/apic.c named test_pv_ipi is used to test for a
> > > kernel
> > > bug where a guest making the hcall KVM_HC_SEND_IPI can trigger an
> > > out of
> > > bounds access.
> > >
> > > If the host doesn't implement this hcall then the out of bounds
> > > access
> > > cannot be triggered.
> > >
> > > Detect the case where the host doesn't implement the
> > > KVM_HC_SEND_IPI
> > > hcall and skip the test when this is the case, as the test doesn't
> > > apply.
> > >
> > > Output without patch:
> > > FAIL: PV IPIs testing
> > >
> > > With patch:
> > > SKIP: PV IPIs testing: h-call not available
> > >
> > > Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
> > > ---
> > >  x86/apic.c | 11 +++++++++++
> > >  1 file changed, 11 insertions(+)
> > >
> > > diff --git a/x86/apic.c b/x86/apic.c
> > > index eb785c4..bd44b54 100644
> > > --- a/x86/apic.c
> > > +++ b/x86/apic.c
> > > @@ -8,6 +8,8 @@
> > >  #include "atomic.h"
> > >  #include "fwcfg.h"
> > >
> > > +#include <linux/kvm_para.h>
> > > +
> > >  #define MAX_TPR                    0xf
> > >
> > >  static void test_lapic_existence(void)
> > > @@ -638,6 +640,15 @@ static void test_pv_ipi(void)
> > >      unsigned long a0 = 0xFFFFFFFF, a1 = 0, a2 = 0xFFFFFFFF, a3 =
> > > 0x0;
> > >
> > >      asm volatile("vmcall" : "=a"(ret) :"a"(KVM_HC_SEND_IPI),
> > > "b"(a0), "c"(a1), "d"(a2), "S"(a3));
> > > +    /*
> > > +     * Detect the case where the hcall is not implemented by the
> > > hypervisor and
> > > +     * skip this test if this is the case. Is the hcall isn't
> > > implemented then
> > > +     * the bug that this test is trying to catch can't be
> > > triggered.
> > > +     */
> > > +    if (ret == -KVM_ENOSYS) {
> > > +       report_skip("PV IPIs testing: h-call not available");
> > > +       return;
> > > +    }
> > >      report("PV IPIs testing", !ret);
> > >  }
> >
> > Should we be checking CPUID bit (KVM_FEATURE_PV_SEND_IPI) instead?
> >
>
> That's also an option. It will produce the same result.
>
> Would that be the preferred approach or is the method used in the
> current patch ok?

Btw, is it amazon using pv ipis? I don't think. I suspect there is an
extra hardware assistant to benefit broadcast ipis in amazon.

    Wanpeng
