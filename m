Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEEC7C50C6
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 13:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346791AbjJKLDQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 07:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234922AbjJKLCz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 07:02:55 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D022129
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 04:02:35 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id ada2fe7eead31-452c0d60616so542691137.1
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 04:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1697022154; x=1697626954; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xm0CdxGnQbe0GlEx3+GHVomKZQHiVEeERNIEs1qllzo=;
        b=VZvMO6mfkwhG4ZN258/KVtS10RK9KNdvy2Tr1pqJIawr8ZgchnndzYkT7iPrYlCDfy
         Oejz89MSEUcwBzsWyDDanwyyOj7XGMkjSecwi1EQ3piUgar2tceW/XSQqgh/3agSwSO1
         M7T10caA1HtiP+YQw8JuBpVO5eQgsZ/VfGX0p+NXKPiLzE/UZ+YCX8tcmZQ4jDZS+ybU
         7a8J/a6Sk4gPRgiTYZGSaBXX0cwnqjCvjqUtmdpMOyTPGIPCFFDlHE0h2UCoJOp1Rlcl
         bOfOe4UdTBAqPcI/FhXhmxGhFy6oMiPZ8VMemYYGomIonWivw7LGlxJ3TjH4KlbSHnA/
         DjNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697022154; x=1697626954;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xm0CdxGnQbe0GlEx3+GHVomKZQHiVEeERNIEs1qllzo=;
        b=Vqh9+6i7AV/zPuIdXYmNmXY+ChnLdEXvvxwxvKDyfjr2DGBaLyeTT4mPmHhZKmCGkg
         safmTajbN5iNfoAJ39J67tfPHMG6aNEEU8o9SRBR8n/KVAx6jqDQJ+/wzpRPvfVbadtI
         nhZwui7jJm1Sv3Xnyc7aLOLIK18Otu9zfIYq3ahRg/T5E0z1xzSEZ/LrO3vIwikzEIbo
         QYF7nVjXCcslMGrliitPrOvDyacXG4gv1EOfjPZ3lCgGZy8jkoaU6i6uZ9w80ukfuoKe
         avQBQ78e4kS7oh56Usw6K2flS375NmvijseJvgjKiNih/0E+J1jt9mYrvEoP6Y/FThKJ
         hdtg==
X-Gm-Message-State: AOJu0YzhiDfNJeEhGdQ52DhuVXk3a2W0s7K6xZ98HoMYJ95MSb6Rmlrb
        45s+POB+3+w133SEzFuZCS3FQR5v/wbGE8NJ/0g/4Q==
X-Google-Smtp-Source: AGHT+IFIHtzjwJekUc0/aKAwYGhSo8Q1f+C4Kna6UDSuc6EpwK7D5p52+dKgEnHoF5qIkm5zUTFf99ptwfMujMMVIFQ=
X-Received: by 2002:a05:6102:27c8:b0:452:79da:94a with SMTP id
 t8-20020a05610227c800b0045279da094amr8993764vsu.4.1697022154194; Wed, 11 Oct
 2023 04:02:34 -0700 (PDT)
MIME-Version: 1.0
References: <20231010170503.657189-1-apatel@ventanamicro.com>
 <20231010170503.657189-3-apatel@ventanamicro.com> <2023101013-overfeed-online-7f69@gregkh>
 <CAK9=C2WbW_WvoU59Ba9VrKf5GbbXmMOhB2jsiAp0a=SJYh3d7w@mail.gmail.com> <2023101107-endorse-large-ef50@gregkh>
In-Reply-To: <2023101107-endorse-large-ef50@gregkh>
From:   Anup Patel <apatel@ventanamicro.com>
Date:   Wed, 11 Oct 2023 16:32:22 +0530
Message-ID: <CAK9=C2XYQ0U9CbuCg6cTf79sSsy+0BxF5mBE0R+E3s9iZFzEWw@mail.gmail.com>
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

On Wed, Oct 11, 2023 at 12:57=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Oct 11, 2023 at 11:49:14AM +0530, Anup Patel wrote:
> > On Tue, Oct 10, 2023 at 10:43=E2=80=AFPM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Tue, Oct 10, 2023 at 10:34:59PM +0530, Anup Patel wrote:
> > > > We will be implementing SBI DBCN extension for KVM RISC-V so let
> > > > us change the KVM RISC-V SBI specification version to v2.0.
> > > >
> > > > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > > > ---
> > > >  arch/riscv/include/asm/kvm_vcpu_sbi.h | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/inc=
lude/asm/kvm_vcpu_sbi.h
> > > > index cdcf0ff07be7..8d6d4dce8a5e 100644
> > > > --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> > > > +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> > > > @@ -11,7 +11,7 @@
> > > >
> > > >  #define KVM_SBI_IMPID 3
> > > >
> > > > -#define KVM_SBI_VERSION_MAJOR 1
> > > > +#define KVM_SBI_VERSION_MAJOR 2
> > >
> > > What does this number mean?  Who checks it?  Why do you have to keep
> > > incrementing it?
> >
> > This number is the SBI specification version implemented by KVM RISC-V
> > for the Guest kernel.
> >
> > The original sbi_console_putchar() and sbi_console_getchar() are legacy
> > functions (aka SBI v0.1) which were introduced a few years back along
> > with the Linux RISC-V port.
> >
> > The latest SBI v2.0 specification (which is now frozen) introduces a ne=
w
> > SBI debug console extension which replaces legacy sbi_console_putchar()
> > and sbi_console_getchar() functions with better alternatives.
> > (Refer, https://github.com/riscv-non-isa/riscv-sbi-doc/releases/downloa=
d/commit-fe4562532a9cc57e5743b6466946c5e5c98c73ca/riscv-sbi.pdf)
> >
> > This series adds SBI debug console implementation in KVM RISC-V
> > so the SBI specification version advertised by KVM RISC-V must also be
> > upgraded to v2.0.
> >
> > Regarding who checks its, the SBI client drivers in the Linux kernel
> > will check SBI specification version implemented by higher privilege
> > mode (M-mode firmware or HS-mode hypervisor) before probing
> > the SBI extension. For example, the HVC SBI driver (PATCH5)
> > will ensure SBI spec version to be at least v2.0 before probing
> > SBI debug console extension.
>
> Is this api backwards compatible, or did you just break existing
> userspace that only expects version 1.0?

The legacy sbi_console_putchar() and sbi_console_getchar()
functions have not changed so it does not break existing
user-space.

The new SBI DBCN functions to be implemented by KVM
user space are:
sbi_debug_console_write()
sbi_debug_console_read()
sbi_debug_console_write_byte()

>
> thanks,
>
> greg k-h

Regards,
Anup
