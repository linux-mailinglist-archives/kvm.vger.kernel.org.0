Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 422FB7BAEA9
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 00:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjJEWNH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 18:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjJEWNG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 18:13:06 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A849495
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 15:13:05 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-27731a63481so1361650a91.2
        for <kvm@vger.kernel.org>; Thu, 05 Oct 2023 15:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696543985; x=1697148785; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GnXAgmYjWV4CQ2aJrszJtrf0PhF8V6dwxv1eIYoBHbA=;
        b=WIz++95TqsFjgAVZaUECJs0CXL69KM0wCA9ZH6iut7g2Ok7BlZqIe+Sv8X/FbuE/MT
         7cv4kbUbz7Fiafz2tQ3DtMiekijYvi0YlC1lluAtycRvkylyveNaFHS+5oC4Ezz/CQC/
         Bf/1fr0j5kYW8XLoGQO59ib7UJRbMDHnzUwRHwO2vWrIdXNMtlbNu0hF5j44NMKJwnbi
         MuFOClApav5KbuhE37vlE+Yhya/7guyFVzg70ICvHJeqdHNY+F1ILFyIbUAzTCOQ1tjl
         ofH8r1M9muyMYvy5AUym8XtpeTX9HIeMgj9Jm8Xq86kk82zMLujvCib4XqvYoGoMrW6I
         +ZRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696543985; x=1697148785;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GnXAgmYjWV4CQ2aJrszJtrf0PhF8V6dwxv1eIYoBHbA=;
        b=dz458EdQgGOeRo4NW65+5p1SqSGf21n+4u8fF5AGOB2L/fxVBYh9PDVn8q0/KTAR2O
         WmcpdXL5/E33/DRO/UcIoEzNtBsEK7Z5ux5o7Qoimuo8cex6oXuGLMfjXWXKwoNnIW2U
         4KzMR0t5C+XFTyqLLZuAXzNHvtDTX6xLAniiaJm7C6H+e4U4SVOgoGngnqHgYpqK134N
         6Ax6RM+aHgyYdn2EJ9Fks+8StnmT/MDXVmMMXAALWmqUdKywnuSP3NjIfzflTILkoY8/
         e+FSXeAk0mq3Q8/uHEytvb3gVjhMCT78ykpNNgGi3Wsbc73ysJXGY0mEIsM+4Q7c6CGC
         OZJQ==
X-Gm-Message-State: AOJu0Yw1h8luwPqu940F2xvrAjS26AcvnT9+1Vm5G3EiVkPDvLgf+XnN
        4mNJesD4Zp2+Imtw8C2KLoQ3+IN/ENM=
X-Google-Smtp-Source: AGHT+IF1mCbw2/u0ploN08QMjX7gv1FuTEbeeim8gFeu1LQBP/sup1ckQwFmhuEJoEnMwmMZs/vciGiNjEw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:a393:b0:274:90a4:f29 with SMTP id
 x19-20020a17090aa39300b0027490a40f29mr104682pjp.1.1696543985158; Thu, 05 Oct
 2023 15:13:05 -0700 (PDT)
Date:   Thu, 5 Oct 2023 15:13:03 -0700
In-Reply-To: <CAF7b7moE19p+kDXuwaxHCY6=NXB95fNJ7ectNRxdUMMBpgT0Fg@mail.gmail.com>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-5-amoorthy@google.com>
 <ZR4N8cwzTMDanPUY@google.com> <CAF7b7moE19p+kDXuwaxHCY6=NXB95fNJ7ectNRxdUMMBpgT0Fg@mail.gmail.com>
Message-ID: <ZR807zVvDytyO1zV@google.com>
Subject: Re: [PATCH v5 04/17] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        nadav.amit@gmail.com, isaku.yamahata@gmail.com,
        kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 05, 2023, Anish Moorthy wrote:
> On Wed, Oct 4, 2023 at 6:14=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > And peeking at future patches, pass in the RWX flags as bools, that way=
 this
> > helper can deal with the bools=3D>flags conversion.  Oh, and fill the f=
lags with
> > bitwise ORs, that way future conflicts with private memory will be triv=
ial to
> > resolve.
> >
> > E.g.
> >
> > static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
> >                                                  gpa_t gpa, gpa_t size,
> >                                                  bool is_write, bool is=
_exec)
> > {
> >         vcpu->run->exit_reason =3D KVM_EXIT_MEMORY_FAULT;
> >         vcpu->run->memory_fault.gpa =3D gpa;
> >         vcpu->run->memory_fault.size =3D size;
> >
> >         vcpu->run->memory_fault.flags =3D 0;
> >         if (is_write)
> >                 vcpu->run->memory_fault.flags |=3D KVM_MEMORY_FAULT_FLA=
G_WRITE;
> >         else if (is_exec)
> >                 vcpu->run->memory_fault.flags |=3D KVM_MEMORY_FAULT_FLA=
G_EXEC;
> >         else
> >                 vcpu->run->memory_fault.flags |=3D KVM_MEMORY_FAULT_FLA=
G_READ;
> > }
>=20
> Is a BUG/VM_BUG_ON() warranted in the (is_write && is_exec) case do
> you think?

Nah, not here.  If we really wanted to add a sanity check, a KVM_MMU_WARN_O=
N()
in kvm_mmu_page_fault() would be the way to go.

> I see that user_mem_abort already VM_BUG_ON()s for this case, but if ther=
e's
> one in the x86 page fault path I don't immediately see it. Also this help=
er
> could be called from other paths, so maybe there's some value in it.
>=20
> > I'll send you a clean-ish patch to use as a starting point sometime nex=
t week.
>=20
> You mean something containing the next spin of the guest memfd stuff?
> Or parts of David's series as well?

guest_memfd stuff.  Effectively this patch, just massaged to splice togethe=
r all
of the fixups.
