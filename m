Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 041A46A1110
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 21:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbjBWULP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 15:11:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbjBWULN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 15:11:13 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9841631E02
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 12:11:04 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id r3-20020a17090aa08300b00237541d0c22so180351pjp.3
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 12:11:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=55699jwMjbFJeBpbG2LE+BTnQXK31us786DsAXZgIPE=;
        b=hTRQs+IlFB2czaT78epgbSkW7NJ8wSJnDnuRCBte4p5S/ALVRjLCKHjShVSrlqlGRB
         bPDNG3CPPATHJ6JYHrLK3edkw/K0AeMhae0St31kEfWksA7kO2qAEGw6C/7xx+lIUTFt
         w3HYo1y9OFrfBqTnWOLx8/DM3Im3H7WNdAsHbnII8klQ4PboKK/QO8bhLJ32hokFQDCS
         roFjYu5iIpVl15bmLSiHgh/R+6pvgnBfMwPnCGxd4DI2GC3StAlvzXWAJGOI9J6AIWr8
         2FaZdIvO0cLTISL4KAt2/p+5Q0ppMkZZ2tomQmymCk75C9ANTiDsU43f5TXzpQ2SIaEY
         ZsOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=55699jwMjbFJeBpbG2LE+BTnQXK31us786DsAXZgIPE=;
        b=KRRYrtTOChndFzp5gswoL5GLijj7avExAAzq/vlnIJFYm68A2gJM4wwm4Y2u9HPnLh
         gxU2bH631fNC9MljtxYX/9RHplFd9N9NmOSmPqAKatJyH3lBE/UJjj6/7pWknnecP/LS
         pi4wjgNgluKD7TKJ7LZtCgMHu6pmPwk09D/BhyQYOkSMyp1ci68IXvwMSuidG3MMqVkY
         CFZ4R6kdYUZpad6Zlc/tsjtFIuUa2Gd9QjQL1ogojjwOkKhXRGaX4pVBZmRK62IsHK75
         Cze/3iIdckxOWAZcJVoj99ZDNC1T1ulgsaLAtzEY5+xpFuXdEXIPnXltk6JlFvRwGsoL
         /UyA==
X-Gm-Message-State: AO0yUKWZomBok4yhSuCWa489nk0DtJmS4i4zvygWqaiptgV7rC/vtWcr
        g6nhBbq+fxaTPp8ktFUrf9GgJ34OuWA=
X-Google-Smtp-Source: AK7set/xVU7e+hcQGopYGt0G0UxcObhRMKgAuOrglBsZ+Kh49SNgMlfHyd+w7UyIxZTuaBRQUdOK7V+VDrU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:a386:b0:19b:b3da:13d1 with SMTP id
 x6-20020a170902a38600b0019bb3da13d1mr2115573pla.0.1677183064010; Thu, 23 Feb
 2023 12:11:04 -0800 (PST)
Date:   Thu, 23 Feb 2023 12:11:02 -0800
In-Reply-To: <CAF7b7mor-QHwLCLQ_sp4sOJTztRGVOzpBupeuiCicA3YG=-TTQ@mail.gmail.com>
Mime-Version: 1.0
References: <20230215011614.725983-1-amoorthy@google.com> <20230215011614.725983-7-amoorthy@google.com>
 <Y+0VK6vZpMqAQ2Dc@google.com> <CAF7b7mor-QHwLCLQ_sp4sOJTztRGVOzpBupeuiCicA3YG=-TTQ@mail.gmail.com>
Message-ID: <Y/fIVp5GUS35vCH1@google.com>
Subject: Re: [PATCH 6/8] kvm/x86: Add mem fault exit on EPT violations
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 22, 2023, Anish Moorthy wrote:
> On Wed, Feb 15, 2023 at 9:24=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Wed, Feb 15, 2023, Anish Moorthy wrote:
> > > +     if (mem_fault_nowait) {
> > > +             if (fault->pfn =3D=3D KVM_PFN_ERR_FAULT) {
> > > +                     vcpu->run->exit_reason =3D KVM_EXIT_MEMORY_FAUL=
T;
> > > +                     vcpu->run->memory_fault.gpa =3D fault->gfn << P=
AGE_SHIFT;
> > > +                     vcpu->run->memory_fault.size =3D PAGE_SIZE;
> >
> > This belongs in a separate patch, and the exit stuff should be filled i=
n by
> > kvm_handle_error_pfn().  Then this if-statement goes away entirely beca=
use the
> > "if (!async)" will always evaluate true in the nowait case.
>=20
> Hi Sean, what exactly did you want "in a separate patch"?

Separate "exit if fast gup() fails", a.k.a. nowait, from "exit with KVM_EXI=
T_MEMORY_FAULT
instead of -EFAULT on errors".  I.e. don't tie KVM_EXIT_MEMORY_FAULT to the=
 fast
gup() capability (or memslot flag?).  That way filing vcpu->run->memory_fau=
lt
lands in a separate, largely generic patch, and this patch only introduces =
the
fast gup() logic.

That probably means adding yet another capability, but capabilities are che=
ap.
