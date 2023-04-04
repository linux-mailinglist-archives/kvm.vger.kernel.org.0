Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C34866D5F8A
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 13:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234292AbjDDLwv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 07:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233561AbjDDLwt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 07:52:49 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9925199E
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 04:52:46 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id t4so27256938wra.7
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 04:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1680609165;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OLv0LN8lAk3QfnUhhhnsk24mDFgoCCiKw5kM+c/FrNk=;
        b=PIlIYQqvjr/V8cmB877Rcy8JB6XO7vQw6kz3u5ewvPi/aNCK9zVxMGitBDmI+6p/7D
         QT79PNqb8XggeQ6ggP6RpTGCLaREBQ/fM0+tB1ZF3J9IZvdpirQg+vl9Ge/YvJxBEVM8
         Sh7iDicitGN00XAVMZAqG5rsejGo/Wx5E6rWtsYlyqOsxIAdKBC8vIpUmNrZ1J5tJx7k
         Ofrj8QaOZc9IWERMqUwAbI+Zemye5wxZcdNzaXrb78dbgqoMHpybLvBZq8Oar6aZrOXm
         lPgCqlZEy3jB8t5/wdP3gtix8wLReCQtMnhSxZFXJ/M0rKVtoXWDpHquRNOney/B37us
         z9bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680609165;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OLv0LN8lAk3QfnUhhhnsk24mDFgoCCiKw5kM+c/FrNk=;
        b=jzbqp4tiQ8ow6+bAmWKlGgPEEOgmyIpn4jHktvHe+Qi900gFc3OT4RiYvwYAKsGxya
         5gDjaMIQqSjOdHpl7yGtm7Hjne0rL+xzEcExmvWIf7IP/LnWKWoFtyq7hdvr/OCy75/6
         UgjfOXCQ16oI53EUnXBxmbHHKW2r9em7tpHiUb8YUUzXZemw4AU1IyoAG5FwxPtUkQT0
         Fpr/2P7HDUtC3i5jNRNGJiwjt2HCgUwrv2mlzH3qXUX417WCe5pMPONHfE+jUdIPfaYj
         howMK2i9t17HlB119xM9uDhgmrKs/jHNivTWGgKzb7+J0F1JPO/hJ8Bg9hErbpkknzFl
         UlJQ==
X-Gm-Message-State: AAQBX9fKln3wQbMHBVggIzR/EbZuWG0XEb7Hg67naCfEcI9iE8G2PAhW
        uk9x0VPnMB0gvjTC8M5AGf1EXA==
X-Google-Smtp-Source: AKy350Yya7ma4256kplKnJKWPZOqQ3wKmsQ11nyME/nhGt+TWoTPHYoPW3R82d3hK3Fcm80POIwx0w==
X-Received: by 2002:a5d:4904:0:b0:2cf:e868:f781 with SMTP id x4-20020a5d4904000000b002cfe868f781mr1470835wrq.42.1680609164757;
        Tue, 04 Apr 2023 04:52:44 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id d16-20020a5d4f90000000b002d51d10a3fasm12192160wru.55.2023.04.04.04.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 04:52:44 -0700 (PDT)
Date:   Tue, 4 Apr 2023 13:52:43 +0200
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
Message-ID: <uogikq56rf7jytuufhsutdedb73b3rh67biwpzsz6ngg5rudco@qcwt7plumwpb>
References: <20230403093310.2271142-1-apatel@ventanamicro.com>
 <20230403093310.2271142-7-apatel@ventanamicro.com>
 <osrpjiywxtkgxb5i6mfvxzfrzrnjv75uqzvlu3fouo4mqsktgj@blcmyjt3twqg>
 <CAAhSdy1JEQBiO55iCy97arO63VjGc+NicUvvwzTpK97W97LmJg@mail.gmail.com>
 <ejt3x4p7xhxfvwiafnogfwdn5dzd4qyowlht22utnbvzefsbyh@7dch4mebwckm>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ejt3x4p7xhxfvwiafnogfwdn5dzd4qyowlht22utnbvzefsbyh@7dch4mebwckm>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 03, 2023 at 02:23:01PM +0200, Andrew Jones wrote:
> On Mon, Apr 03, 2023 at 05:34:57PM +0530, Anup Patel wrote:
> > On Mon, Apr 3, 2023 at 5:01 PM Andrew Jones <ajones@ventanamicro.com> wrote:
> > >
> > > On Mon, Apr 03, 2023 at 03:03:08PM +0530, Anup Patel wrote:
> > > > We implement ONE_REG interface for AIA CSRs as a separate subtype
> > > > under the CSR ONE_REG interface.
> > > >
> > > > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > > > ---
> > > >  arch/riscv/include/uapi/asm/kvm.h | 8 ++++++++
> > > >  arch/riscv/kvm/vcpu.c             | 8 ++++++++
> > > >  2 files changed, 16 insertions(+)
> > > >
> > > > diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> > > > index 182023dc9a51..cbc3e74fa670 100644
> > > > --- a/arch/riscv/include/uapi/asm/kvm.h
> > > > +++ b/arch/riscv/include/uapi/asm/kvm.h
> > > > @@ -79,6 +79,10 @@ struct kvm_riscv_csr {
> > > >       unsigned long scounteren;
> > > >  };
> > > >
> > > > +/* AIA CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> > > > +struct kvm_riscv_aia_csr {
> > > > +};
> > > > +
> > > >  /* TIMER registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> > > >  struct kvm_riscv_timer {
> > > >       __u64 frequency;
> > > > @@ -107,6 +111,7 @@ enum KVM_RISCV_ISA_EXT_ID {
> > > >       KVM_RISCV_ISA_EXT_ZIHINTPAUSE,
> > > >       KVM_RISCV_ISA_EXT_ZICBOM,
> > > >       KVM_RISCV_ISA_EXT_ZBB,
> > >
> > > Looks like this patch is also based on "[PATCH] RISC-V: KVM: Allow Zbb
> > > extension for Guest/VM"
> > 
> > Yes, do you want me to change the order of dependency?
> 
> It's probably best if neither depend on each other, since they're
> independent, but otherwise the order doesn't matter. It'd be nice to call
> the order out in the cover letter to give patchwork a chance at automatic
> build testing, though. To call it out, I believe adding
> 
> Based-on: 20230401112730.2105240-1-apatel@ventanamicro.com
> 
> to the cover letter should work.

I also just noticed that this based on "RISC-V: KVM: Add ONE_REG
interface to enable/disable SBI extensions"[1] and it needs to be
in order to pick up the KVM_REG_RISCV_SUBTYPE_MASK and
KVM_REG_RISCV_SUBTYPE_SHIFT defines. It'd be good to call that
patch out with Based-on.

[1]: 20230331174542.2067560-2-apatel@ventanamicro.com

Thanks,
drew
