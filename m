Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAFC680A44
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 10:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236270AbjA3J73 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 04:59:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236260AbjA3J71 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 04:59:27 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9722512046
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 01:59:03 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id x4so13330400ybp.1
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 01:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YoKzreuTWkm8iCBf1EBE+XySj8qF1az5gLokgdEcFfY=;
        b=Fx9Gq6iPm/GasNiJUxyjKXHHGwlmlzDeFvJhX2SwPrda2srpnsWGOdwVInIW5jT+t/
         AN+t+XjWUWtQDTtf7eD3F96Zs3aXPXOpDIPjNHyKdT7l/6lCsQYcr+9iPWa9Su+6cnIn
         Pqe9EeKXS0wZrI6q7dLZA+fzEsHCJ76SHj8tbXH2q+b9d0tdw0FUXGsW4lbveM/x5GEU
         ThZTzavk865+3MoDFB8xSfVPnWUEzNoTIV2YSlrt590fOIAJd57etH2+lLcsQANLXI9z
         rxoJAGbVI1tuAFTf59bdEyTCBUt5ww1EJusPwFyflZ4HYH79lu7Ek250CmHOSqqw/TKq
         ksTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YoKzreuTWkm8iCBf1EBE+XySj8qF1az5gLokgdEcFfY=;
        b=uwCAohOGQVT9gb9EBX5qqkfopb/Fner3Tj1JV/7ZBB4J5hTNyhxRhz9s5QP2xpNoEw
         GT8E/53fA9JddCJosDA3iNpaQKe50vgnt0uSelYqYYMl/CioZNtpUCnFjbSal3NcdPn3
         p6Pm6tx9AQZgYWyp1zEZCyPKg0SlE1aQ6q0hzj36Pk+m3K6K/WoMmWX/2vTfliYCc1se
         oXX1vAh0QTMs6gMmgUTRKARnbXUztGeLt+TeqpctggSbSWjEsmReJQnFOJe7/IYRfZ+0
         B/rwQcTmlasXWweoBe6/xY0cOuMy+OBanqoUs7f0HL7JqdtwSsramTad46uJEy6yj9V2
         TVFA==
X-Gm-Message-State: AO0yUKWP0RNnFhRAB4KWgxexpe9vavHZTCTAIOyt31F4i9RQ7IV3ADO/
        miVrjrZKHbvM2D+Y2KRHgIIHq1ijhI1gBilVv1t23g==
X-Google-Smtp-Source: AK7set/vUcpKgiWJsVos8LAymmHBq1qACtgf3TpIkwJoAZSZ2hqheLAyitSF96PJUdF324nVPYFeIEvaMKbTenn+Y3M=
X-Received: by 2002:a25:8388:0:b0:80b:79e1:bdad with SMTP id
 t8-20020a258388000000b0080b79e1bdadmr2845506ybk.196.1675072740706; Mon, 30
 Jan 2023 01:59:00 -0800 (PST)
MIME-Version: 1.0
References: <20230125142056.18356-1-andy.chiu@sifive.com> <20230125142056.18356-17-andy.chiu@sifive.com>
 <Y9Q3i2z8uh1Bttzw@spud>
In-Reply-To: <Y9Q3i2z8uh1Bttzw@spud>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Mon, 30 Jan 2023 17:58:49 +0800
Message-ID: <CABgGipUR1+MRkt5WH8=cEr+9XB3x5TRsMOefu8adFfNkjWZ_nA@mail.gmail.com>
Subject: Re: [PATCH -next v13 16/19] riscv: Add V extension to KVM ISA
To:     Conor Dooley <conor@kernel.org>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jan 28, 2023 at 4:44 AM Conor Dooley <conor@kernel.org> wrote:
>
> On Wed, Jan 25, 2023 at 02:20:53PM +0000, Andy Chiu wrote:
> > riscv: Add V extension to KVM ISA
>
> I figure this should probably be "riscv: kvm:" or some variant with
> more capital letters.
Ok. adding it
> > diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> > index 92af6f3f057c..e7c9183ad4af 100644
> > --- a/arch/riscv/include/uapi/asm/kvm.h
> > +++ b/arch/riscv/include/uapi/asm/kvm.h
> > @@ -100,6 +100,7 @@ enum KVM_RISCV_ISA_EXT_ID {
> >       KVM_RISCV_ISA_EXT_H,
> >       KVM_RISCV_ISA_EXT_I,
> >       KVM_RISCV_ISA_EXT_M,
> > +     KVM_RISCV_ISA_EXT_V,
> >       KVM_RISCV_ISA_EXT_SVPBMT,
> >       KVM_RISCV_ISA_EXT_SSTC,
> >       KVM_RISCV_ISA_EXT_SVINVAL,
>
> Ehh, this UAPI so, AFAIU, you cannot add this in the middle of the enum
> and new entries must go at the bottom. Quoting Drew: "we can't touch enum
> KVM_RISCV_ISA_EXT_ID as that's UAPI. All new extensions must be added at
> the bottom. We originally also had to keep kvm_isa_ext_arr[] in that
> order, but commit 1b5cbb8733f9 ("RISC-V: KVM: Make ISA ext mappings
> explicit") allows us to list its elements in any order."
>
Thanks to mentioning this potential ABI break, I have moved it to the
end at v14 revision.
@@ -105,6 +105,7 @@ enum KVM_RISCV_ISA_EXT_ID {
        KVM_RISCV_ISA_EXT_SVINVAL,
        KVM_RISCV_ISA_EXT_ZIHINTPAUSE,
        KVM_RISCV_ISA_EXT_ZICBOM,
+       KVM_RISCV_ISA_EXT_V,
        KVM_RISCV_ISA_EXT_MAX,
 };
>
> > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > index 7c08567097f0..b060d26ab783 100644
> > --- a/arch/riscv/kvm/vcpu.c
> > +++ b/arch/riscv/kvm/vcpu.c
> > @@ -57,6 +57,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
> >       [KVM_RISCV_ISA_EXT_H] = RISCV_ISA_EXT_h,
> >       [KVM_RISCV_ISA_EXT_I] = RISCV_ISA_EXT_i,
> >       [KVM_RISCV_ISA_EXT_M] = RISCV_ISA_EXT_m,
> > +     [KVM_RISCV_ISA_EXT_V] = RISCV_ISA_EXT_v,
> >
> >       KVM_ISA_EXT_ARR(SSTC),
> >       KVM_ISA_EXT_ARR(SVINVAL),
>
> This one here is fine however.
Great!
>
> Thanks,
> Conor.
