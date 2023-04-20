Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87BF46E9FEE
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 01:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbjDTXaS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 19:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231504AbjDTXaS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 19:30:18 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACDDDE72
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 16:30:16 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-3f09b4a1527so11951745e9.0
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 16:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682033415; x=1684625415;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nRsiw33DYXKBM8rTcW+xozbunBMlWYP+e9GkMRlf85o=;
        b=A4at8XXuyv3notVzg4656tjZMmTA3z/aSsYPxm37+S52hqmLCI3ztJ6UvW6QjPvjFZ
         RP0EI0xZ7G0NaIZnpLnz8uNuHfE+iGmvotVqN9+UPhWRc5kJHQaUwPfdjSPZgbTHSndA
         umuIQTTyz1rBOs8z9BB0pcSF1QfaDJZ6eYKeCf9ptZcuHqkYxPHpCUbHXBjsLH7E9iR7
         03/zF79IZIL9cO43GZ2pS+kb8+dBL5xVMHka5+5bI1WW5hTiyO93ptI0XteyW6V85LmL
         iYnaU0pGqNsw+SHf+GnRpj5V4L1kz1EFjEFAThbrHWUr375ATrtg7KzVeeomHJ+izHvo
         ealA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682033415; x=1684625415;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nRsiw33DYXKBM8rTcW+xozbunBMlWYP+e9GkMRlf85o=;
        b=feHABmgDX1E5+Ssc+tbXziedqelKcFmw04q8StF3XtU24vtgT5l/rkL8wO78R7JsQK
         qZZWBzcq98bZWboqswsffME3c9I/eKpnVeKDM9bG2iQuuEHicRr7aciJSY8qE8CfaMjk
         xTtWFixUESCaT+SancDHtGBkQ/Y9rlPqiWzFTnkGc+vPZmBN1T5e9MouF9AgT77I9svF
         TQlchYgNA6k/n3WFiuvFUSRb42ZcfRa3VGKHZ8QGA2xLmMXjHGJA5Jhyb7/VxW8HRgvA
         FEZVwQhGa7SgJGzKym/xJYUi0plQVGAJL/kU3AXzY1/oOdiwW0YFppyM7XKHU4nV6L9y
         O5MQ==
X-Gm-Message-State: AAQBX9fbOjjRskIZs2GOltO/9xZ4Q48Y6xSq/ZYI7UGctMHuPSIaU47g
        e/2MyrxniCHxhwlYUwJJY8Wdb1YG0DUQ2+V8mf7Yfg==
X-Google-Smtp-Source: AKy350ZpVTpgjnmn9ovaeU5yBTjC9QP6WDTaH2r2jbAMcPM84z3sHsNZQ5pJLq8Py8ZbybqTJhTQMmmyWv0OUJ0feEk=
X-Received: by 2002:a05:600c:2113:b0:3ee:289a:43a7 with SMTP id
 u19-20020a05600c211300b003ee289a43a7mr394651wml.22.1682033415059; Thu, 20 Apr
 2023 16:30:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <20230412213510.1220557-8-amoorthy@google.com>
 <ZEGmAnnv5Dq8BgrW@x1n>
In-Reply-To: <ZEGmAnnv5Dq8BgrW@x1n>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Thu, 20 Apr 2023 16:29:38 -0700
Message-ID: <CAF7b7mqR97H=z05XN-qv97Tp=Qqr4y6kBgckkVRu5XLDpwJTUg@mail.gmail.com>
Subject: Re: [PATCH v3 07/22] KVM: Annotate -EFAULTs from kvm_vcpu_write_guest_page()
To:     Peter Xu <peterx@redhat.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev,
        seanjc@google.com, jthoughton@google.com, bgardon@google.com,
        dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 20, 2023 at 1:52=E2=80=AFPM Peter Xu <peterx@redhat.com> wrote:
>
> On Wed, Apr 12, 2023 at 09:34:55PM +0000, Anish Moorthy wrote:
> > Implement KVM_CAP_MEMORY_FAULT_INFO for efaults from
> > kvm_vcpu_write_guest_page()
> >
> > Signed-off-by: Anish Moorthy <amoorthy@google.com>
> > ---
> >  virt/kvm/kvm_main.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 63b4285d858d1..b29a38af543f0 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -3119,8 +3119,11 @@ int kvm_vcpu_write_guest_page(struct kvm_vcpu *v=
cpu, gfn_t gfn,
> >                             const void *data, int offset, int len)
> >  {
> >       struct kvm_memory_slot *slot =3D kvm_vcpu_gfn_to_memslot(vcpu, gf=
n);
> > +     int ret =3D __kvm_write_guest_page(vcpu->kvm, slot, gfn, data, of=
fset, len);
> >
> > -     return __kvm_write_guest_page(vcpu->kvm, slot, gfn, data, offset,=
 len);
> > +     if (ret =3D=3D -EFAULT)
> > +             kvm_populate_efault_info(vcpu, gfn * PAGE_SIZE + offset, =
len);
> > +     return ret;
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_vcpu_write_guest_page);
>
> Why need to trap this?  Is this -EFAULT part of the "scalable userfault"
> plan or not?
>
> My previous memory was one can still leave things like copy_to_user() to =
go
> via the userfaults channels which should work in parallel with the new vc=
pu
> MEMORY_FAULT exit.  But maybe the plan changed?

This commit isn't really part of the "scalable uffd" changes, which
basically correspond to KVM_CAP_ABSENT_MAPPING_FAULT. There should be
more details in the cover letter, but basically my v1 just included
KVM_CAP_ABSENT_MAPPING_FAULT: Sean argued that the API there ("return
to userspace whenever KVM fails a guest memory access to a page
fault") was problematic, and so I reworked the series to include a
general capability for reporting extra information for failed guest
memory accesses (KVM_CAP_MEMORY_FAULT_INFO) and
KVM_CAP_ABSENT_MAPPING_FAULT (which is meant to be used in combination
with the other cap) for the "scalable userfaultfd" changes.

As such most of the commits in this series are unrelated to
KVM_CAP_ABSENT_MAPPING_FAULT, and this is one of those commits. It
doesn't affect page faults generated by copy_to_user (which should
still be delivered via uffd).
