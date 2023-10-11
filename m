Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4145D7C5833
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 17:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346262AbjJKPiZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 11:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232741AbjJKPiX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 11:38:23 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4AC0A4
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 08:38:21 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-69101022969so6247668b3a.3
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 08:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1697038701; x=1697643501; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1bZpkRgovz51AKO2Ok87+Y9u7MeLQt0Mw3B5ANlnfec=;
        b=msVb2fwfQ0RSkKlGNIjoO0jg/GdEFZEW3wB/D9iCFdHefI+rOovi7bK23pRnKEFl34
         j9dQcZUvwhKjm7SijzDg9SK2xWuulSyDufCg912mTL4d8SDcDH60Q6eJYGiZ+wQXGyiw
         o5/sJgRhEjY16tpPh8+EAA3UqahUfJiWAZz4tBAaoQRe/TYkSGbNwB1auAYePf2S25Ux
         2XYB9T51z32d2HIFdHAaiWRjbEQSGDdLFCt9aBwBVhcC5pqqKD8VacGPrDEQBvSedBTU
         vN3o/73ahdhhys9XduvBE16auxNNdSTlnyLJ7g3JWzsCM40lxaZAuEKJIkK56cFxH5FO
         mNlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697038701; x=1697643501;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1bZpkRgovz51AKO2Ok87+Y9u7MeLQt0Mw3B5ANlnfec=;
        b=TWPzcA17rcNqGclEDCdbGWO7Ng7jQNzpClnEiiYBiwJqD09aHfk+KlLTiX0O61WIGb
         1WwuZ1WwGWR/5i+seMrXFwobtXdzmHrx/vB1P8O+aLMwdZhWUqcVYXm/dchnLN/33eFu
         CMAuTYuU5FuFNHkltH7uv+wIDOUJ0AYp4nhzxrql4G6KwZpZJrqW1bBH4vp/p3wyKHga
         uUJTwvRaptuZzVJgbfM3yzPsWoB6bAwSieaXo2xJjHqJ9p3CDe/HTl6BCt2DeP1EsXgq
         i4B8tABjaVDjqQMSSk7seuJkdJa7YZI4yAbji175Mq2/3MsptG1/eXfwLhPFPIltC0Q1
         EEDA==
X-Gm-Message-State: AOJu0YxU+mazsT6KuQAmSZHVOb5pPru2mbNmaxLPowvY55BSEPtSTRCj
        OKAwYWPMgMa3NCbY+ig9Mv1nj+Y049u0uarmJI+lRg==
X-Google-Smtp-Source: AGHT+IH+Duhf61q+4YQ+h+trrczoreLWiVAuNX7LPf/svKzSeewv2TIyrBxClNtHOHej4LGq2AeV1O2tRvRwJwp6muo=
X-Received: by 2002:a17:90a:5383:b0:27c:ea4c:d8c5 with SMTP id
 y3-20020a17090a538300b0027cea4cd8c5mr5192162pjh.19.1697038701054; Wed, 11 Oct
 2023 08:38:21 -0700 (PDT)
MIME-Version: 1.0
References: <20231010170503.657189-1-apatel@ventanamicro.com>
 <20231010170503.657189-3-apatel@ventanamicro.com> <2023101013-overfeed-online-7f69@gregkh>
 <CAK9=C2WbW_WvoU59Ba9VrKf5GbbXmMOhB2jsiAp0a=SJYh3d7w@mail.gmail.com>
 <2023101107-endorse-large-ef50@gregkh> <CAK9=C2XYQ0U9CbuCg6cTf79sSsy+0BxF5mBE0R+E3s9iZFzEWw@mail.gmail.com>
 <2023101148-anatomy-mantis-a0f5@gregkh>
In-Reply-To: <2023101148-anatomy-mantis-a0f5@gregkh>
From:   Anup Patel <apatel@ventanamicro.com>
Date:   Wed, 11 Oct 2023 21:08:10 +0530
Message-ID: <CAK9=C2XpfQc2eoBmrd5ZicR+HO34-2BZdvrNu_CQ5qC47WKBVw@mail.gmail.com>
Subject: Re: [PATCH 2/6] RISC-V: KVM: Change the SBI specification version to v2.0
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Conor Dooley <conor@kernel.org>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 11, 2023 at 8:56=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Oct 11, 2023 at 04:32:22PM +0530, Anup Patel wrote:
> > On Wed, Oct 11, 2023 at 12:57=E2=80=AFPM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Wed, Oct 11, 2023 at 11:49:14AM +0530, Anup Patel wrote:
> > > > On Tue, Oct 10, 2023 at 10:43=E2=80=AFPM Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > On Tue, Oct 10, 2023 at 10:34:59PM +0530, Anup Patel wrote:
> > > > > > We will be implementing SBI DBCN extension for KVM RISC-V so le=
t
> > > > > > us change the KVM RISC-V SBI specification version to v2.0.
> > > > > >
> > > > > > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > > > > > ---
> > > > > >  arch/riscv/include/asm/kvm_vcpu_sbi.h | 2 +-
> > > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > >
> > > > > > diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv=
/include/asm/kvm_vcpu_sbi.h
> > > > > > index cdcf0ff07be7..8d6d4dce8a5e 100644
> > > > > > --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> > > > > > +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> > > > > > @@ -11,7 +11,7 @@
> > > > > >
> > > > > >  #define KVM_SBI_IMPID 3
> > > > > >
> > > > > > -#define KVM_SBI_VERSION_MAJOR 1
> > > > > > +#define KVM_SBI_VERSION_MAJOR 2
> > > > >
> > > > > What does this number mean?  Who checks it?  Why do you have to k=
eep
> > > > > incrementing it?
> > > >
> > > > This number is the SBI specification version implemented by KVM RIS=
C-V
> > > > for the Guest kernel.
> > > >
> > > > The original sbi_console_putchar() and sbi_console_getchar() are le=
gacy
> > > > functions (aka SBI v0.1) which were introduced a few years back alo=
ng
> > > > with the Linux RISC-V port.
> > > >
> > > > The latest SBI v2.0 specification (which is now frozen) introduces =
a new
> > > > SBI debug console extension which replaces legacy sbi_console_putch=
ar()
> > > > and sbi_console_getchar() functions with better alternatives.
> > > > (Refer, https://github.com/riscv-non-isa/riscv-sbi-doc/releases/dow=
nload/commit-fe4562532a9cc57e5743b6466946c5e5c98c73ca/riscv-sbi.pdf)
> > > >
> > > > This series adds SBI debug console implementation in KVM RISC-V
> > > > so the SBI specification version advertised by KVM RISC-V must also=
 be
> > > > upgraded to v2.0.
> > > >
> > > > Regarding who checks its, the SBI client drivers in the Linux kerne=
l
> > > > will check SBI specification version implemented by higher privileg=
e
> > > > mode (M-mode firmware or HS-mode hypervisor) before probing
> > > > the SBI extension. For example, the HVC SBI driver (PATCH5)
> > > > will ensure SBI spec version to be at least v2.0 before probing
> > > > SBI debug console extension.
> > >
> > > Is this api backwards compatible, or did you just break existing
> > > userspace that only expects version 1.0?
> >
> > The legacy sbi_console_putchar() and sbi_console_getchar()
> > functions have not changed so it does not break existing
> > user-space.
> >
> > The new SBI DBCN functions to be implemented by KVM
> > user space are:
> > sbi_debug_console_write()
> > sbi_debug_console_read()
> > sbi_debug_console_write_byte()
>
> And where exactly is that code for us to review that this is tested?

The KVM selftests for KVM RISC-V are under development. Eventually,
we will have dedicated KVM selftests for the SBI extensions implemented
by KVM RISC-V.

Until then we have KVMTOOL implementation for SBI DBCN, which is
available in riscv_sbi_dbcn_v1 branch at:
https://github.com/avpatel/kvmtool.git

>
> thanks,
>
> greg k-h

Regards,
Anup
