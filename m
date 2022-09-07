Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6995B09A8
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 18:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbiIGQFd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 12:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiIGQFH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 12:05:07 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96AF0BD0A8;
        Wed,  7 Sep 2022 09:03:38 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id b136so1556651yba.2;
        Wed, 07 Sep 2022 09:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=yF8Rt8ulk7W0JkE/TCCmFvph/zoFHn4xY7O3voIDGAs=;
        b=O+JiMy+OEvVNjM0SVwSeiPMUmtqNFabE88IKd7ei2chRVskDiANSjiud9wi7D8p5wt
         HwXZmYkWBHgMo4nzPyCFxCoStq/e/+XdA/LygUQYK9Vd0IoKufi2DEOgMWNoUaxc5kfo
         p0UZ3I5BJnF+esWyM9/pD4uMHeNM/7x5pvjOeeZtP5NUQbfu5wZT4PoFpJ90oNk7KxRY
         9LX/rwXYB1xLWDNNV89L2X3fVvxvxQUcGN7YMnnCGaFiTZvO1YvEnfDzE/i5s582sWUf
         9oOkYPe8cMl7hN5tJw350ey3IdUk5iqhDdLPZJaENGj78yBYKlBD2gvQvbjMxgafAK6s
         yvkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=yF8Rt8ulk7W0JkE/TCCmFvph/zoFHn4xY7O3voIDGAs=;
        b=zRfTH4njPd1a3bupS/Rp56pHh4Pa7/eTDDwrIoOqSJkhIujjbsyFXilhwwD1v0bAby
         9ks3QTxrBHFvMUg8zVA5CnEW+rVnQuGemQ3qA5xbmKD1PcaSgp+isfW2t6fIgARPFS60
         uLaDrY0+JYQuwQ4DTo+84a7CmSGkNzosBeQPoDwiYyYE37nfUGdW308ZpSaa2Lb/8jfM
         1YSBVjzRQ6sEE6y+ntNlkwrexwFDln794kwvVa/szKYnmbGUl2jivqnm7R8ZnSIyXYS9
         /toB4K4bwTQ+cKxrFu1p/OJzCRwOkK1/r02GAAZUf2ka0odGwaBiFh6nUQ68dUywYzuk
         24hQ==
X-Gm-Message-State: ACgBeo1Hys03sR0P2adsvD6R7pCa599QOhnfqti/YF1eyxf58fB7tk8K
        Mj3x9N4RKvBM9WaYihzYDxyhm78WUsVNnA8jAcotQQ/GQwY=
X-Google-Smtp-Source: AA6agR6vgqesxVxzRqaG1ffp+FJUfyIfrXyUwxPU4OwFMOvBwZyItTOsnTuIYtQ0DfAFjU0vGIaNZL3WPSDG0b5A8XI=
X-Received: by 2002:a05:6902:102f:b0:699:a7b9:d4ed with SMTP id
 x15-20020a056902102f00b00699a7b9d4edmr3478737ybt.393.1662566617821; Wed, 07
 Sep 2022 09:03:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220906153357.1362555-1-zhiguangni01@zhaoxin.com> <Yxdx36BHlClCq52J@google.com>
In-Reply-To: <Yxdx36BHlClCq52J@google.com>
From:   Liam Ni <zhiguangni01@gmail.com>
Date:   Thu, 8 Sep 2022 00:03:26 +0800
Message-ID: <CACZJ9cUdbk_9UtsX=BZpqNgBshHDLy3=C5E4591STGsxtZwiSA@mail.gmail.com>
Subject: Re: [PATCH] KVM: Reduce the execution of one instruction
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, tglx@linutronix.de,
        dave.hansen@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 7 Sept 2022 at 00:14, Sean Christopherson <seanjc@google.com> wrote:
>
> "KVM: x86:" for the shortlog.
>
> On Tue, Sep 06, 2022, Liam Ni wrote:
> > From: Liam Ni <zhiguangni01@gmail.com>
> >
> > If the condition is met,
>
> Please describe this specific code change, "If the condition is met" is extremely
> generic and doesn't help the reader understand what change is being made.
>
> > reduce the execution of one instruction.
>
> This is highly speculative, e.g. clang will generate identical output since it's
> trivial for the compiler to observe that ctxt->modrm_reg doesn't need to be read.
>
> And similar to the above "If the condition is met", the shortlog is too generic
> even if it were 100% accurate.
>
> I do think this change is a net positive, but it's beneficial only in making the
> code easier to read.  Shaving a single cheap instruction in a relatively slow path
> isn't sufficient justification even if the compiler isn't clever enough to optimize
> away the load in the first place.
>
> E.g. something like:
>
>   KVM: x86: Clean up ModR/M "reg" initialization in reg op decoding
>
>   Refactor decode_register_operand() to get the ModR/M register if and
>   only if the instruction uses a ModR/M encoding to make it more obvious
>   how the register operand is retrieved.
>
> > Signed-off-by: Liam Ni <zhiguangni01@gmail.com>
> > ---
> >  arch/x86/kvm/emulate.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> > index f8382abe22ff..ebb95f3f9862 100644
> > --- a/arch/x86/kvm/emulate.c
> > +++ b/arch/x86/kvm/emulate.c
> > @@ -1139,10 +1139,12 @@ static int em_fnstsw(struct x86_emulate_ctxt *ctxt)
> >  static void decode_register_operand(struct x86_emulate_ctxt *ctxt,
> >                                   struct operand *op)
> >  {
> > -     unsigned reg = ctxt->modrm_reg;
> > +     unsigned int reg;
> >
> >       if (!(ctxt->d & ModRM))
> >               reg = (ctxt->b & 7) | ((ctxt->rex_prefix & 1) << 3);
> > +     else
> > +             reg = ctxt->modrm_reg;
>
> I'd prefer to write this as:
>
>         unsigned int reg;
>
>         if (ctxt->d & ModRM)
>                 reg = ctxt->modrm_reg;
>         else
>                 reg = (ctxt->b & 7) | ((ctxt->rex_prefix & 1) << 3);
>
> so that "is ModRM" check is immediately followed by "get ModRM".
>
> >
> >       if (ctxt->d & Sse) {
> >               op->type = OP_XMM;
> > --
> > 2.25.1
>
> >

Thanks for the suggestion, I will submit a new patch V2.
