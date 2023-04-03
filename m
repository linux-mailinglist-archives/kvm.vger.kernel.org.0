Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11E606D4419
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 14:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbjDCMFW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 08:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231782AbjDCMFT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 08:05:19 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F415010DA
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 05:05:11 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id eg48so116271495edb.13
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 05:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112; t=1680523510;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aTnNv9XdGhYjOU9CcATjnOwylj3cx5IlVTw/VdMJWrc=;
        b=1QVT5ZwH445IL+4hcb90apKtOn9XWo8AG3e4epOeRhuDSB0LUCiPjbbmuJyWq+tRZb
         u/IgbDyskrFey489XvB7OkvalYU8dGfnykhLS+cPZEjA+onfYSoFNvsj9aT8jfL9ZoBd
         gdzujFLSCOHiz4INorE7Di1m7BdejjdBE3XQhUtdBf69R0gbrkScWTUYd0Skvyxa+Y/h
         aNbQSGo2iTrlLmWazm+hpPGmlATA71GLVf63Wd0caLF+ijf1VOzcsd/o3avhyjbRtYq0
         MuJYMYq42icLOP0yB4Z3MMXeDh43gbbTPuT52FO9H2rlufmD9yYqDL4uZwCdQYxmYNZ6
         Y9iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680523510;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aTnNv9XdGhYjOU9CcATjnOwylj3cx5IlVTw/VdMJWrc=;
        b=qk5mLlIPGF9l9f167i5D21AoXCWFL/QTgOeZbVKgZuphIp0V6KlXJNAQ5FLrFt8HKN
         ptoJ0aOnowsBY3SSmmqjLFr3Zs9ay3NaitcJFQj05MuU1F0jfYKgjUklxmBAe1OCw98u
         +SVWTQz4QvIbv5sWaw7+cntjmgdG0lMyB9c0G8ZMbPxvATP4Kk0qoz/JVaXCuY+9WgAd
         Kw8Fjan7oIkpnHYOyX3EtXyj6KjlBGSCHwaivdNm8G1FWRiZTbPjiPOlEcJYwsucHEKe
         4Z7Q4r5dJNiRLdLhPCVNsrxiScBOHnHMeRV3M0GLhRLBMwwkmw6x41TPEo1klFCyyIgH
         E/6A==
X-Gm-Message-State: AAQBX9cWhWmPYhkaV5KjvO/joEvEK8ztKnwGxFMb/ghIYJJGEMBuZU+G
        J8c1PEaBzfL3ymWzdVC7o+NGMpEcyOSVvBxD8pI7Gg==
X-Google-Smtp-Source: AKy350YucQu0o4XWT9/o4B6ERGyItJAJlV74UNbolWd6EWP1LnSHsHXRJcMFXLDM0cgX2h5Cra/y5okQv4y+6QYR1CY=
X-Received: by 2002:a17:906:7c54:b0:932:6a66:fc43 with SMTP id
 g20-20020a1709067c5400b009326a66fc43mr17062399ejp.13.1680523510364; Mon, 03
 Apr 2023 05:05:10 -0700 (PDT)
MIME-Version: 1.0
References: <20230403093310.2271142-1-apatel@ventanamicro.com>
 <20230403093310.2271142-7-apatel@ventanamicro.com> <osrpjiywxtkgxb5i6mfvxzfrzrnjv75uqzvlu3fouo4mqsktgj@blcmyjt3twqg>
In-Reply-To: <osrpjiywxtkgxb5i6mfvxzfrzrnjv75uqzvlu3fouo4mqsktgj@blcmyjt3twqg>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 3 Apr 2023 17:34:57 +0530
Message-ID: <CAAhSdy1JEQBiO55iCy97arO63VjGc+NicUvvwzTpK97W97LmJg@mail.gmail.com>
Subject: Re: [PATCH v3 6/8] RISC-V: KVM: Add ONE_REG interface for AIA CSRs
To:     Andrew Jones <ajones@ventanamicro.com>
Cc:     Anup Patel <apatel@ventanamicro.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 3, 2023 at 5:01=E2=80=AFPM Andrew Jones <ajones@ventanamicro.co=
m> wrote:
>
> On Mon, Apr 03, 2023 at 03:03:08PM +0530, Anup Patel wrote:
> > We implement ONE_REG interface for AIA CSRs as a separate subtype
> > under the CSR ONE_REG interface.
> >
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > ---
> >  arch/riscv/include/uapi/asm/kvm.h | 8 ++++++++
> >  arch/riscv/kvm/vcpu.c             | 8 ++++++++
> >  2 files changed, 16 insertions(+)
> >
> > diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uap=
i/asm/kvm.h
> > index 182023dc9a51..cbc3e74fa670 100644
> > --- a/arch/riscv/include/uapi/asm/kvm.h
> > +++ b/arch/riscv/include/uapi/asm/kvm.h
> > @@ -79,6 +79,10 @@ struct kvm_riscv_csr {
> >       unsigned long scounteren;
> >  };
> >
> > +/* AIA CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> > +struct kvm_riscv_aia_csr {
> > +};
> > +
> >  /* TIMER registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> >  struct kvm_riscv_timer {
> >       __u64 frequency;
> > @@ -107,6 +111,7 @@ enum KVM_RISCV_ISA_EXT_ID {
> >       KVM_RISCV_ISA_EXT_ZIHINTPAUSE,
> >       KVM_RISCV_ISA_EXT_ZICBOM,
> >       KVM_RISCV_ISA_EXT_ZBB,
>
> Looks like this patch is also based on "[PATCH] RISC-V: KVM: Allow Zbb
> extension for Guest/VM"

Yes, do you want me to change the order of dependency?

Regards,
Anup
