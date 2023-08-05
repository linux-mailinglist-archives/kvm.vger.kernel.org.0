Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 298C7771092
	for <lists+kvm@lfdr.de>; Sat,  5 Aug 2023 18:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjHEQc1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Aug 2023 12:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjHEQc0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Aug 2023 12:32:26 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BFD4127
        for <kvm@vger.kernel.org>; Sat,  5 Aug 2023 09:32:24 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-51d95aed33aso4006448a12.3
        for <kvm@vger.kernel.org>; Sat, 05 Aug 2023 09:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20221208.gappssmtp.com; s=20221208; t=1691253143; x=1691857943;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GYZwvu2eYpPnKPH3ItmneVhr19GRxWhSHTpw1p6mhRA=;
        b=W4RID/l1HMz2deakeikDSBZhV+cMNY31/wH7bwD1pjqV9FqTK3FesvmXRg/7wDghm9
         JeU+pBCqnBH3UChpLoNWZSkoOQ6MI1BxhbjM482q/AwnrLfK9E3sa4vOr3KpNI3p6Wu+
         NG30ek1UI7Lwd9zZlYS9Sb4YSkEpFavg0arxPvSeE/AzU+vm9DneBpiKSYWqAYZAOccx
         Bqcs2wF9kvK2DieQMf9nMQAH4W7h+43HX7ZsIm+/yyyL6L6UkcE2nBuCQvrn3tENPArL
         Z6fazYA6rzH20oTIIF5kAvd1vKO3XK4sFw4ybrM56Y6PbGBBE8HQnfbAcgd+I1n2ZbrH
         T2Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691253143; x=1691857943;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GYZwvu2eYpPnKPH3ItmneVhr19GRxWhSHTpw1p6mhRA=;
        b=L1gZXlxQv7OxESrF6dHqNBL7FXJ9RLDVSMbW4+kEGIuKE0w1V8cRakvmMpDtHrN2CN
         36NImh/ozoyBQTSXBaAY0k4yLh6CqsijsfWbdipjmEsl/dl4J4JC5MZl37RI6XyuZmbt
         Bo1wu1C1aUHpyO1AQZG8KLW6gFfgRfTNDaF/Wb/98U09sh6lDNYh3GeHZqso4hWDrXQT
         9ouI8kCP6zY798S8dPPaNzfpayfU+60fYBChIBRc/gKnLiWdWSVHVAj0QF1m3S8ufWlj
         AGBLN2O7f3tAiUOgP0T+WY1qnSLGUYCDYHXYdGIf5yf0CMl2m3kf5sKUx3pQwQcVg1aF
         ajfQ==
X-Gm-Message-State: AOJu0Yz6QpWVYt3Xnop2xz2SfIXl/aZp4qYxssjae2p8JycaKpVQaGrg
        OfSfbe/wW5EBXXIEoKGoM4FQ+GoWLszPM0/IMBTSHCup9XovnPWz
X-Google-Smtp-Source: AGHT+IGqF5CoJHwPbyndmgCWCRxoTS0266kYUcXeGjcl5kQfH3xJ618u9OsIxBNwWatK5yJoqhEKsOvIh4Iz8zJeCEc=
X-Received: by 2002:aa7:db5a:0:b0:522:3ef1:b1d with SMTP id
 n26-20020aa7db5a000000b005223ef10b1dmr3650827edt.6.1691253142737; Sat, 05 Aug
 2023 09:32:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230803163302.445167-1-dbarboza@ventanamicro.com> <CAAhSdy0PoG=AwvcavJxuS1Y6nbFE8pcX5vXDuzFr6+vjhpAMkQ@mail.gmail.com>
In-Reply-To: <CAAhSdy0PoG=AwvcavJxuS1Y6nbFE8pcX5vXDuzFr6+vjhpAMkQ@mail.gmail.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Sat, 5 Aug 2023 22:02:10 +0530
Message-ID: <CAAhSdy17pWaXWQDOzzJpwKxQPkojv4sZa4+EKrQW6OmFLrXNrw@mail.gmail.com>
Subject: Re: [PATCH v4 00/10] RISC-V: KVM: change get_reg/set_reg error code
To:     Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Cc:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org, atishp@atishpatra.org, ajones@ventanamicro.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 4, 2023 at 2:41=E2=80=AFPM Anup Patel <anup@brainfault.org> wro=
te:
>
> On Thu, Aug 3, 2023 at 10:03=E2=80=AFPM Daniel Henrique Barboza
> <dbarboza@ventanamicro.com> wrote:
> >
> > Hi,
> >
> > This version includes a diff that Andrew mentioned in v2 [1] that I
> > missed. They were squashed into patch 1.
> >
> > No other changes made. Patches rebased on top of riscv_kvm_queue.
> >
> > Changes from v3:
> > - patch 1:
> >   - added missing EINVAL - ENOENT conversions
> > - v3 link: https://lore.kernel.org/kvm/20230803140022.399333-1-dbarboza=
@ventanamicro.com/
> >
> > [1] https://lore.kernel.org/kvm/20230801222629.210929-1-dbarboza@ventan=
amicro.com/
> >
> >
> > Andrew Jones (1):
> >   RISC-V: KVM: Improve vector save/restore errors
> >
> > Daniel Henrique Barboza (9):
> >   RISC-V: KVM: return ENOENT in *_one_reg() when reg is unknown
> >   RISC-V: KVM: use ENOENT in *_one_reg() when extension is unavailable
> >   RISC-V: KVM: do not EOPNOTSUPP in set_one_reg() zicbo(m|z)
> >   RISC-V: KVM: do not EOPNOTSUPP in set KVM_REG_RISCV_TIMER_REG
> >   RISC-V: KVM: use EBUSY when !vcpu->arch.ran_atleast_once
> >   RISC-V: KVM: avoid EBUSY when writing same ISA val
> >   RISC-V: KVM: avoid EBUSY when writing the same machine ID val
> >   RISC-V: KVM: avoid EBUSY when writing the same isa_ext val
> >   docs: kvm: riscv: document EBUSY in KVM_SET_ONE_REG
>
> I have queued all patches except PATCH9 for Linux-6.6.
>
> Drew, please send v5 of PATCH.

I have queued PATCH9 as well.

Thanks,
Anup


>
> Thanks,
> Anup
>
> >
> >  Documentation/virt/kvm/api.rst |  2 +
> >  arch/riscv/kvm/aia.c           |  4 +-
> >  arch/riscv/kvm/vcpu_fp.c       | 12 +++---
> >  arch/riscv/kvm/vcpu_onereg.c   | 74 ++++++++++++++++++++++------------
> >  arch/riscv/kvm/vcpu_sbi.c      | 16 ++++----
> >  arch/riscv/kvm/vcpu_timer.c    | 11 ++---
> >  arch/riscv/kvm/vcpu_vector.c   | 60 ++++++++++++++-------------
> >  7 files changed, 107 insertions(+), 72 deletions(-)
> >
> > --
> > 2.41.0
> >
