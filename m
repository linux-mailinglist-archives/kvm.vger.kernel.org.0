Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 141DD7A48F8
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 13:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241674AbjIRL63 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 07:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241933AbjIRL61 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 07:58:27 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A3B12E
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 04:56:52 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id 98e67ed59e1d1-26934bc3059so3916942a91.1
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 04:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1695038211; x=1695643011; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CKu7B1gjsHcSR5evDqOMmJj5qj7vRYDOB1s9PImJ6SU=;
        b=KutiWdi58fhlzSITexl9BWWrf3rEDtw8ox6vl8OR12jirJkAKP8x5YOpiLB9rgTvEg
         u2b0tmw8Om2SXJBFRUryoY127dpiK2N1c1OIH9pxBcN1oAUyIUiWi1fygxfumYWF4c5r
         FQHnREkCx7kjrKvdePlDxcM658m30eyfhKR9CTc0GeqebbQM+RdBBIH6G1yVLWVI8SVl
         +lgYP3yzXeUl8ILLRdCTLFao87dUPbT58T73uryxhEppMQEkjBc+7Oav/Ucco27AoyR4
         2REeyQXOL1I7tXSIxmckmvY4CZlPf9hs/ULrEA8FrySxyPRFhz7PcPPvZJztDISwT68R
         XN0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695038211; x=1695643011;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CKu7B1gjsHcSR5evDqOMmJj5qj7vRYDOB1s9PImJ6SU=;
        b=Eh4B66wnOsj58os7mfzyUJlhTykG7to4fjIxQ74GLeG0B6TuU6lVFCR6+GOXxl52rP
         JFuGUmmkzolnTUfmsLI6fzlco8GiyCRLVXPnbNQiOAWf0NCAvflCReV/pDYz1Ms6c8K6
         UuvN6eoQpNmLBYAR1BGYXIeitFeafyOpTq4p0+0tU/FL1p+eUi61R+QCtYvJin9iOdsr
         zYacCNrtZA+zr9IesaC0WgSbyhlVZcZPu8mwHJGbvvO1f6cvJlJyUxT3Fq2vLbfkMwYf
         5ytzyF1d+xf4rIUcG3K5FbGZUD/Omn+O69ynsUp0tIV2SEE2T5mJwKfXcxeFk0+EOWvR
         H+6A==
X-Gm-Message-State: AOJu0YxOmYz0n5RLrDCBYRCzRyGOVkflwLypdctwkPHpTHHouKV1G3IA
        ADKuq4qe6Yz6eCWgpkc3IesO5R1plulWdUImSnxghw==
X-Google-Smtp-Source: AGHT+IFk6GwT2n3/8RHsRmG8tJoXTeY4d/RJuA4xlQ6xpx5D+cUnBiv8FUca7FjjX4wCW3XgjgkdV4Q8vRbg73AMh2Y=
X-Received: by 2002:a17:90a:2ac9:b0:26f:392f:f901 with SMTP id
 i9-20020a17090a2ac900b0026f392ff901mr10937303pjg.14.1695038211527; Mon, 18
 Sep 2023 04:56:51 -0700 (PDT)
MIME-Version: 1.0
References: <20230725152430.3351564-1-apatel@ventanamicro.com>
 <CAK9=C2WkkEpA3YM99HMNRk743mkhk2FDEpV_ffG3UWH9Vy3YkA@mail.gmail.com> <20230918111609.GB18214@willie-the-truck>
In-Reply-To: <20230918111609.GB18214@willie-the-truck>
From:   Anup Patel <apatel@ventanamicro.com>
Date:   Mon, 18 Sep 2023 17:26:40 +0530
Message-ID: <CAK9=C2Xe_U+1T8UE-dK11kK4D_+bS9n9p0Kp690XLQaO1eMjLg@mail.gmail.com>
Subject: Re: [kvmtool PATCH 0/6] RISC-V AIA irqchip and Svnapot support
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>, maz@kernel.org,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, julien.thierry.kdev@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 18, 2023 at 4:46=E2=80=AFPM Will Deacon <will@kernel.org> wrote=
:
>
> On Thu, Sep 14, 2023 at 10:26:34PM +0530, Anup Patel wrote:
> > On Tue, Jul 25, 2023 at 8:54=E2=80=AFPM Anup Patel <apatel@ventanamicro=
.com> wrote:
> > >
> > > The latest KVM in Linux-6.5 has support for:
> > > 1) Svnapot ISA extension support
> > > 2) AIA in-kernel irqchip support
> > >
> > > This series adds corresponding changes in KVMTOOL to use the above
> > > mentioned features for Guest/VM.
> > >
> > > These patches can also be found in the riscv_aia_v1 branch at:
> > > https://github.com/avpatel/kvmtool.git
> > >
> > > Anup Patel (6):
> > >   Sync-up header with Linux-6.5-rc3 for KVM RISC-V
> > >   riscv: Add Svnapot extension support
> > >   riscv: Make irqchip support pluggable
> > >   riscv: Add IRQFD support for in-kernel AIA irqchip
> > >   riscv: Use AIA in-kernel irqchip whenever KVM RISC-V supports
> > >   riscv: Fix guest/init linkage for multilib toolchain
> >
> > Friendly ping ?
>
> It all looks pretty self-contained, but please send another version
> importing the headers for v6.5 now that it has been released.

Sure, I will send another version soon.

Thanks,
Anup
