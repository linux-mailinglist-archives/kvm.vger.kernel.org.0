Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8FBE6ED320
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 19:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbjDXRG4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 13:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjDXRGy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 13:06:54 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A414C17
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 10:06:53 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id 3f1490d57ef6-b9963a72fbfso3118492276.3
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 10:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1682356012; x=1684948012;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=krNPE2dQqwX0Vq4fm7wJ0pMkyXc+ttcWhBFj1QMoyaA=;
        b=D7rTS2vUH4qstqeKjhm3dTJUdQJ9zearxJXie4vaHsSOhe6iOyE4MuVNYs2nvAkdqh
         YWB2XA8YznRxpQhqVXyYbmQO0l5hjbKoURaP9orwrnZJ4jLdD5gs6Riq1413LHIpnIlF
         SmAkENgZsLal9FeCJGi5fvk/mL8PXxsRwS6v6p2OKOlzDbCRop8Q6raKFjx2mzIEA8oQ
         L1vrymkRegx53sNtlKfCNlslx09Lxw+1ArQRKFkBfSNZh3Ii1YbSbDaaUwxeeWg7RjM/
         KjslZ8pw+jdBXEpm17EVwmaeLKgCHmVV9c2qbMADPGOajqxA01L8FvvH2Ef3JEKOguIR
         Wfnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682356012; x=1684948012;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=krNPE2dQqwX0Vq4fm7wJ0pMkyXc+ttcWhBFj1QMoyaA=;
        b=CUL77RYGzMY05Co6gG05aWPy6KyVlL2FmMM0zMmvPuZdiLrVm3ajn8TD9Nw/parGIW
         6wmRMv0ftHiHagnpLP1xaHdtu5wC+Mbm8+Mj1MD5mCkQmaLahe4Nr+WoppZEc+0GQgYk
         UQIBsJ2aXTRvaTt/HQi4OU85XYFxaSwsOAWyvhbhfTEosR7tpsBoOPHSVZSSZsLY6ATP
         7u6TrBf8e9a6gIF7PDzDSt2X286arUHB7v7DPMesDW0OlTrFoF9wDMYFyowIju4azcQQ
         tPglA1136/AtnWmF0cEBne4/e05+2IfQG3sBWubJzJvfGRAG8wK00r++x7r3i3X1oRGC
         jeLQ==
X-Gm-Message-State: AAQBX9eMXBS4ouIee0OiPgJ6kyamTmqmGvXNW0ObJMsNbWkMP2/w/76j
        m3OrvgYbnao/92RScM6OmSGgyEkfpt9Pg97D0hER1A==
X-Google-Smtp-Source: AKy350Z6JjDn4o4gZMOoqDt1M3eWc2C2i937mU2dIsCEho8OEIRTfS1kInWHGs5i0zOCy+k0w0BkWRW0fwbsXk0TwJQ=
X-Received: by 2002:a25:d48e:0:b0:b8f:3fa9:40db with SMTP id
 m136-20020a25d48e000000b00b8f3fa940dbmr10938551ybf.45.1682356012532; Mon, 24
 Apr 2023 10:06:52 -0700 (PDT)
MIME-Version: 1.0
References: <CAAhSdy2RLinG5Gx-sfOqrYDAT=xDa3WAk8r1jTu8ReO5Jo0LVA@mail.gmail.com>
 <CABgObfbS7ej9pqmV05DKwq1929QD10EQ9XdkEb_Qhtbm1WrkeQ@mail.gmail.com>
In-Reply-To: <CABgObfbS7ej9pqmV05DKwq1929QD10EQ9XdkEb_Qhtbm1WrkeQ@mail.gmail.com>
From:   Anup Patel <apatel@ventanamicro.com>
Date:   Mon, 24 Apr 2023 22:36:40 +0530
Message-ID: <CAK9=C2XBkOh2FdY08mXXaVjOFSikbSJUULAohrq3M4qWrNWvew@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.4
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Anup Patel <anup@brainfault.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Atish Patra <atishp@atishpatra.org>,
        Atish Patra <atishp@rivosinc.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On Sat, Apr 22, 2023 at 5:17=E2=80=AFAM Paolo Bonzini <pbonzini@redhat.com>=
 wrote:
>
> On Fri, Apr 21, 2023 at 7:34=E2=80=AFPM Anup Patel <anup@brainfault.org> =
wrote:
> > Please note that the Zicboz series has been taken by
> > Palmer through the RISC-V tree which results in few
> > minor conflicts in the following files:
> > arch/riscv/include/asm/hwcap.h
> > arch/riscv/include/uapi/asm/kvm.h
> > arch/riscv/kernel/cpu.c
> > arch/riscv/kernel/cpufeature.c
> > arch/riscv/kvm/vcpu.c
> >
> > I am not sure if a shared tag can make things easy for you or Palmer.
>
> It's not just making it easier, it is a requirement because I prefer
> to keep an eye on changes to uapi.h and especially to avoid that
> conflicts in KVM files reach Linus.
>
> The conflicts may be minor, but they are a symptom of overlooking
> "something" in the workflow.
>
> If I can get the shared tag from Palmer then good, otherwise I suppose
> this PR will also have to be delayed to the second week of the merge
> window.

I think it is better to delay this PR to the second week of the merge windo=
w.

Regards,
Anup
