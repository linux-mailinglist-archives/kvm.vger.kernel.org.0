Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 865803AD343
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 21:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233490AbhFRUBW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 16:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232605AbhFRUBV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Jun 2021 16:01:21 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90596C061574
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 12:59:11 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id i13so10124523edb.9
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 12:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xqdl9WxaRz+ahiguAKY7lYcwwWxP8V/AbVUI+tYqFLM=;
        b=hN7RpTNblbTlarjeSnPiDmXKLh6NBFgh0WxOWuxPD8IqeSQV3Bc7WuM39s5ivUxtEn
         sPzWL/Uc7e6hZEZyeNaO57a9Urd4BvCJkUVbz571kd9SRAKE2lHAonZh6mtGvCtnMkOu
         i4aY1AS174sinRec/oKnlLM9TwvL7f/YTCZoWYqtX3+PRYNm1/Ka+TqLPhnEKU3g5oqB
         wqMgEdwNkvw5/njLs9115ujWBpnmw3sqoT7VfWZW1oJtqyrvezOCvFuB5lycMpOUZXh4
         J6oEV8FCc/ksZATr22cOb2p/pykDBCwuaNtxAB0jJy65j1moDkovPEOEZEozNjZB7TZh
         BmbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xqdl9WxaRz+ahiguAKY7lYcwwWxP8V/AbVUI+tYqFLM=;
        b=hLOGYjYHPJ7eKhm0xHkKS+QXEcFLOHXB6jDBqSpiWd1mfGBHIJPDYY+hkdLJtPLRYH
         wqF7mCwp4Nx9go/PMS4x29YVeYekXmm/A0tMetf6+Qu6s2y2K/9hnUGRhpr+u9ztfzi9
         ijJbD8ltdd9SqazLd9Ql9a5s0Mk0N7LzqpBmO0BkROQNkHTWFZI462wsA7bn6igDadD2
         BCZ0SFEn/KsBVrLVPprHEJDLXE532xmKIz1baSBLTR6e1ZEJZFJJ5QbQwnASUuQUPhln
         an+9QayMMMLa5Y8J8oyqjtJx5LNCIHXbCeMtSBerJbwxrJgyOg2P0qoy/jKLAsCiFjgj
         fp4g==
X-Gm-Message-State: AOAM533b15UoOdy4MCDFV/5IoTj5nsJ/FV9NY+pzgS8zasBW5GW4bYrJ
        a1LWwNWK2saCKQTPuz90OT2wG6tL+A+M4pusLqtU/v2xvouUTw==
X-Google-Smtp-Source: ABdhPJyOm52tSrVpOAz6YuJ4Y9rToSqjXQuUnwwXxedZa0kF6dBk7a9/YjhTqq0D7XlkgR0DurzJp4G1cSgZ90i4HWg=
X-Received: by 2002:a05:6402:5109:: with SMTP id m9mr7377068edd.68.1624046350193;
 Fri, 18 Jun 2021 12:59:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210618113118.70621-1-laramglazier@gmail.com> <ca3ca9a0-f6be-be85-b2a1-5f80dd9dd693@oracle.com>
In-Reply-To: <ca3ca9a0-f6be-be85-b2a1-5f80dd9dd693@oracle.com>
From:   Lara Lazier <laramglazier@gmail.com>
Date:   Fri, 18 Jun 2021 21:58:58 +0200
Message-ID: <CANX1H+3LC1FrGaJ+eo-FQnjHr8-VYAQJVW0j5H33x-hBAemGDA@mail.gmail.com>
Subject: Re: [PATCH kvm-unit-tests] svm: Updated cr4 in test_efer to fix
 report msg
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am Fr., 18. Juni 2021 um 20:28 Uhr schrieb Krish Sadhukhan
<krish.sadhukhan@oracle.com>:
>
>
> On 6/18/21 4:31 AM, Lara Lazier wrote:
> > Updated cr4 so that cr4 and vmcb->save.cr4 are the same
> > and the report statement prints out the correct cr4.
> > Moved it to the correct test.
> >
> > Signed-off-by: Lara Lazier <laramglazier@gmail.com>
> > ---
> >   x86/svm_tests.c | 3 ++-
> >   1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> > index 8387bea..080a1a8 100644
> > --- a/x86/svm_tests.c
> > +++ b/x86/svm_tests.c
> > @@ -2252,7 +2252,6 @@ static void test_efer(void)
> >       /*
> >        * EFER.LME and CR0.PG are both set and CR0.PE is zero.
> >        */
> > -     vmcb->save.cr4 = cr4_saved | X86_CR4_PAE;
>
>
> This test requires CR4.PAE to be set. The preceding test required it to
> be unset.
>
> Did I miss something ?

Hey :)

My understanding is as follows:
The "first" test should succeed with an SVM_EXIT_ERR when EFER.LME and
CR0.PG are both
non-zero and CR0.PE is zero (so I believe we do not really care
whether CR4.PAE is set or not though
I might be overlooking something here).
The "second" test checks if we also get an SVM_EXIT_ERR when EFER.LME,
CR0.PG, CR4.PAE, CS.L,
and CS.D are all non-zero. While I did not change any test internally,
the thing that I changed is to split the assignment
vmcb->save.cr4 = cr4_saved | X86_CR4_PAE;
up into
cr4 = cr4_saved | X86_CR4_PAE;
vmcb->save.cr4 = cr4;
so that we print out the correct value in

report(svm_vmrun() == SVM_EXIT_ERR, "EFER.LME=1 (%lx), CR0.PG=1 (%lx),
CR4.PAE=1 (%lx), CS.L=1 and CS.D=1 (%x)",efer, cr0, cr4, cs_attrib);

Before we printed out cr4.PAE=1 (0) as the local variable cr4 was not
updated and did not correctly reflect the state of vmcb->save.cr4,
which was a bit confusing.

>
>
> >       cr0 &= ~X86_CR0_PE;
> >       vmcb->save.cr0 = cr0;
> >       report(svm_vmrun() == SVM_EXIT_ERR, "EFER.LME=1 (%lx), "
> > @@ -2266,6 +2265,8@@ static void test_efer(void)
>
> >
> >       cr0 |= X86_CR0_PE;
> >       vmcb->save.cr0 = cr0;
> > +    cr4 = cr4_saved | X86_CR4_PAE;
> > +    vmcb->save.cr4 = cr4;
> >       cs_attrib = cs_attrib_saved | SVM_SELECTOR_L_MASK |
> >           SVM_SELECTOR_DB_MASK;
> >       vmcb->save.cs.attrib = cs_attrib;
