Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD7776DB97
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 01:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbjHBXbf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 19:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbjHBXbc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 19:31:32 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B4BD268F
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 16:31:31 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id e9e14a558f8ab-348c7075afcso30465ab.1
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 16:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691019090; x=1691623890;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w6aDWW1qzsmHKwnYtEop3+qy3EYV7hPBKqzqy/Xvj3s=;
        b=m3NlnJaByfDr7ifVkA4srlAokcnVrFW3hDZwqBExiqhz24rs0QjM2nw/BsJBND5pr4
         mW9AqnlkRlkZElVUaCeZrttBixkxw3SRCaBG00nOi12/VpeLFGUYeY01TMCYMOl3+Tav
         DMmDZSMrZyf53Md4l2VEqpF5J/2e7WQ9uapV9VkkN0uoEYwSjnLRWHZAFc68fY/va7nY
         sYMH6TZb7CrcUljoIDnhXXxcRMO+K68PA3ew5CVCMs+lXOPx9XdxJaBWgJ4Iarmf8m3O
         /9j8tmIGjn580lJx6nvJDZgVg26+1gjB/A9scOVbUOLX23/TiZdgE9tEaoHaYbM06VME
         Mp4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691019090; x=1691623890;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w6aDWW1qzsmHKwnYtEop3+qy3EYV7hPBKqzqy/Xvj3s=;
        b=U61FjN327TOax229rlrz5QVXlZfJTolfSOyTBpBwr9UwpwdaMLul2QSunzJj6lfSuQ
         yx8EOlVNNOR+j+5pQVRGusZ46YoSoNewUizQGvlIDmd8FyIyS9nat7iIb7pB1Q4FuAtO
         ilYztei8DRQr5Lq8RfJcmqAyL8dwdAo2v5elYUDW+87jD0BF17EYK72bodYnDpbvOflb
         cyyy+OzmD3GDVUzCcX2F005CoyYOJsNPbDgeQ/uaPm1eRAR3ry9/GQ4Q8n3WWSxAjHaj
         z6fsJz/rXYKFBjt3TZzsjc5uWgTaxA2pbMtWe5ZV/A4AL6bSaneWqyKMPuj1cI2R9fUz
         vvNA==
X-Gm-Message-State: ABy/qLYcleE5K8trXI5Xo+nig7QekGBP09e/P9m5e0ES+3QiHknGIga9
        W+J0jVzqacw0XyVDjXBidRZM88Zhldiah3yZAz3SJg==
X-Google-Smtp-Source: APBJJlHxlDzzHqPKBL2W2e8S5hxlmOS5GdG0S/eXkBRCshMRiYbddtmdl3QEWYXTh530kMhJWBHbbqF5IT4rpQ1iYo4=
X-Received: by 2002:a05:6e02:144d:b0:346:48bd:da43 with SMTP id
 p13-20020a056e02144d00b0034648bdda43mr1329597ilo.4.1691019090536; Wed, 02 Aug
 2023 16:31:30 -0700 (PDT)
MIME-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com> <20230722022251.3446223-7-rananta@google.com>
 <87r0otr579.wl-maz@kernel.org> <CAJHc60zqOeWXf3kh5hKL6DL3g4znmHaH-TqC0QDcBrWPsHAEXQ@mail.gmail.com>
 <875y5xqvvm.wl-maz@kernel.org>
In-Reply-To: <875y5xqvvm.wl-maz@kernel.org>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Wed, 2 Aug 2023 16:31:18 -0700
Message-ID: <CAJHc60zujOMwGUzc=yGeioy5Vz+wzx2HkcJpF=2aLDPZ-mVMEA@mail.gmail.com>
Subject: Re: [PATCH v7 06/12] arm64: tlb: Refactor the core flush algorithm of __flush_tlb_range
To:     Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        David Matlack <dmatlack@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Gavin Shan <gshan@redhat.com>,
        Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 2, 2023 at 8:58=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote:
>
> On Mon, 31 Jul 2023 18:36:47 +0100,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> >
> > On Thu, Jul 27, 2023 at 3:58=E2=80=AFAM Marc Zyngier <maz@kernel.org> w=
rote:
> > >
> > > On Sat, 22 Jul 2023 03:22:45 +0100,
> > > Raghavendra Rao Ananta <rananta@google.com> wrote:
> > > >
> > > > Currently, the core TLB flush functionality of __flush_tlb_range()
> > > > hardcodes vae1is (and variants) for the flush operation. In the
> > > > upcoming patches, the KVM code reuses this core algorithm with
> > > > ipas2e1is for range based TLB invalidations based on the IPA.
> > > > Hence, extract the core flush functionality of __flush_tlb_range()
> > > > into its own macro that accepts an 'op' argument to pass any
> > > > TLBI operation, such that other callers (KVM) can benefit.
> > > >
> > > > No functional changes intended.
> > > >
> > > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> > > > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > > > Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> > > > ---
> > > >  arch/arm64/include/asm/tlbflush.h | 109 +++++++++++++++-----------=
----
> > > >  1 file changed, 56 insertions(+), 53 deletions(-)
> > > >
> > > > diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include=
/asm/tlbflush.h
> > > > index 412a3b9a3c25..f7fafba25add 100644
> > > > --- a/arch/arm64/include/asm/tlbflush.h
> > > > +++ b/arch/arm64/include/asm/tlbflush.h
> > > > @@ -278,14 +278,62 @@ static inline void flush_tlb_page(struct vm_a=
rea_struct *vma,
> > > >   */
> > > >  #define MAX_TLBI_OPS PTRS_PER_PTE
> > > >
> > > > +/* When the CPU does not support TLB range operations, flush the T=
LB
> > > > + * entries one by one at the granularity of 'stride'. If the TLB
> > > > + * range ops are supported, then:
> > >
> > > Comment format (the original was correct).
> > >
> > Isn't the format the same as original? Or are you referring to the
> > fact that it needs to be placed inside the macro definition?
>
> No, I'm referring to the multiline comment that starts with:
>
>         /*  When the CPU does not support TLB range operations...
>
> instead of the required:
>
>         /*
>          * When the CPU does not support TLB range operations
>
> which was correct before the coment was moved.
>
Oh I see! I'll fix it in v8.

Thanks,
Raghavendra
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
