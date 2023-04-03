Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA1E6D4445
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 14:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbjDCMXH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 08:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbjDCMXF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 08:23:05 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBAFB113CE
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 05:23:03 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id d17so29119566wrb.11
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 05:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1680524582;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lrBrOilikEyXuAaAszQyqb1SxcC+8RUdzbuNXh0/KE8=;
        b=RfTogZ7Y6xOi5ujkHNr//ymCYW3SqcxpJZEFacwGPGcTxe7lGrhbQpazMQ9bU/f4LA
         t8NyF1Wq2b+rS/cNRCKgWIs3eLPd6o9qSCn92qKrGKHl3WWwd9hIemIWnJh0SySs8bgO
         qOrlTVmaHFYdqGril+mt71YPdzqNfPMgTR+X/vI1e8eYAVEMjAN6JVSEp/MPRS60lJ4l
         tU8nM4zhBp+Zmbw7vAfRwikbrs8dDqijRrsINt8+UQRa4z2h2Eww2J9+qgHuUJXjXXI5
         AksJEIDKdJkqK/XJW99bHdSB6GRypGTyjCdcAjLgWrbIr6fQPKrZCJsxCuXtccUjN+q5
         vgJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680524582;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lrBrOilikEyXuAaAszQyqb1SxcC+8RUdzbuNXh0/KE8=;
        b=IOLXkC1d/b5TnzFXGW4e2lR4bg2NU6ykr1bt75bD/gVWs57AvVkIh6FeoFwpjo1a11
         S9QTKEqWjsX9OSAmL/WEzONpags9M4WY8UhQy3dREoD8pTa/GuJXUmw/fTTVjM3YswNa
         F1YSzyIdYHSqKEx/ly7ZOAKt7aeTeP+kqvgq6fzPEZaOihkPBaHqWcxpENx1oYufSEpK
         dr9v0aSRkTlMsqpwnWkbX5tUQ8qf12tPAn7mBXhl7rrcTZiltPPJ9jqF2Z7iu+TVODeY
         JHF/qvhZXWUC9AlMU2OIPb8rUOzAHW5F5gNAcOysqvDxlIDSPaii6776Njf+dabk2Hb2
         QJ7Q==
X-Gm-Message-State: AAQBX9fmsz/AZU/v1UcFjo9yAD2RISnO/x7hS4VUG4JxL6qlKapAM4Yt
        og8/M7nzJ82bfsg12OJwkIUISA==
X-Google-Smtp-Source: AKy350aJnE9hGqG/GQp+ahW3juensBB2QAN/lIZSr5g1oWyEjJFGC6dwqBgxYd5i7A73nQ3iqq3cAg==
X-Received: by 2002:a5d:4092:0:b0:2dc:c0da:405 with SMTP id o18-20020a5d4092000000b002dcc0da0405mr28089467wrp.34.1680524582474;
        Mon, 03 Apr 2023 05:23:02 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id k12-20020adfe8cc000000b002c7b229b1basm9617245wrn.15.2023.04.03.05.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 05:23:02 -0700 (PDT)
Date:   Mon, 3 Apr 2023 14:23:01 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Anup Patel <anup@brainfault.org>
Cc:     Anup Patel <apatel@ventanamicro.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 6/8] RISC-V: KVM: Add ONE_REG interface for AIA CSRs
Message-ID: <ejt3x4p7xhxfvwiafnogfwdn5dzd4qyowlht22utnbvzefsbyh@7dch4mebwckm>
References: <20230403093310.2271142-1-apatel@ventanamicro.com>
 <20230403093310.2271142-7-apatel@ventanamicro.com>
 <osrpjiywxtkgxb5i6mfvxzfrzrnjv75uqzvlu3fouo4mqsktgj@blcmyjt3twqg>
 <CAAhSdy1JEQBiO55iCy97arO63VjGc+NicUvvwzTpK97W97LmJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAhSdy1JEQBiO55iCy97arO63VjGc+NicUvvwzTpK97W97LmJg@mail.gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 03, 2023 at 05:34:57PM +0530, Anup Patel wrote:
> On Mon, Apr 3, 2023 at 5:01 PM Andrew Jones <ajones@ventanamicro.com> wrote:
> >
> > On Mon, Apr 03, 2023 at 03:03:08PM +0530, Anup Patel wrote:
> > > We implement ONE_REG interface for AIA CSRs as a separate subtype
> > > under the CSR ONE_REG interface.
> > >
> > > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > > ---
> > >  arch/riscv/include/uapi/asm/kvm.h | 8 ++++++++
> > >  arch/riscv/kvm/vcpu.c             | 8 ++++++++
> > >  2 files changed, 16 insertions(+)
> > >
> > > diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> > > index 182023dc9a51..cbc3e74fa670 100644
> > > --- a/arch/riscv/include/uapi/asm/kvm.h
> > > +++ b/arch/riscv/include/uapi/asm/kvm.h
> > > @@ -79,6 +79,10 @@ struct kvm_riscv_csr {
> > >       unsigned long scounteren;
> > >  };
> > >
> > > +/* AIA CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> > > +struct kvm_riscv_aia_csr {
> > > +};
> > > +
> > >  /* TIMER registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> > >  struct kvm_riscv_timer {
> > >       __u64 frequency;
> > > @@ -107,6 +111,7 @@ enum KVM_RISCV_ISA_EXT_ID {
> > >       KVM_RISCV_ISA_EXT_ZIHINTPAUSE,
> > >       KVM_RISCV_ISA_EXT_ZICBOM,
> > >       KVM_RISCV_ISA_EXT_ZBB,
> >
> > Looks like this patch is also based on "[PATCH] RISC-V: KVM: Allow Zbb
> > extension for Guest/VM"
> 
> Yes, do you want me to change the order of dependency?

It's probably best if neither depend on each other, since they're
independent, but otherwise the order doesn't matter. It'd be nice to call
the order out in the cover letter to give patchwork a chance at automatic
build testing, though. To call it out, I believe adding

Based-on: 20230401112730.2105240-1-apatel@ventanamicro.com

to the cover letter should work.

Thanks,
drew
