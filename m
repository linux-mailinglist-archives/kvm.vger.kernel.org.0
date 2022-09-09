Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E59F5B39B1
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 15:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbiIINsa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 09:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231643AbiIINsZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 09:48:25 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB7563F2A;
        Fri,  9 Sep 2022 06:48:04 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-3450990b0aeso19358197b3.12;
        Fri, 09 Sep 2022 06:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=XNsL7A+ParoI+QQ6Xv0iUaI58zw0NLxrSar+h7dj9ic=;
        b=i8dShfjNLy/UDAtFho8YmRkq1V+zKZO4FEer5IpuaPzN+RjDGfNg25NdaItiA/MSoV
         V8LvnyIrToatsgR6HAKhGcsJ3d7IwRejPtekRmTdQHjMNpHgdR2cV1FAWntCBnQQc774
         yefztNDXms4lJvs6hEjLXAx9nbMtT48CwKxCIhgjsnMFA3vxrk2mYnr8a2Z+OZJO+kmA
         89icyrnUwNgkN/jai7x197eRbTqkDarA5nN7fk6Vgff4SZNlYFyAdm4iREQ/B2KYiVWQ
         Bz/YjR6CRhzhSrdDNqvy/orVECVCU+adILNIVcrhsULO4TnBelUNNKPmtMK95FTRTxLt
         fjoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=XNsL7A+ParoI+QQ6Xv0iUaI58zw0NLxrSar+h7dj9ic=;
        b=77hANl7MoFEEJeQnV4iAmEv0AHSV5vMTRtXCzeNe9GraRal0lrUAtEVJ5OvqUSSYBt
         9VAPt6UYDmHBkPSWv8qJPDVh0hqvw1BSMcOgzwUwMiRHZgmmJuYDtVBL+hUrP1xH8GFk
         8sNvhluiAEK+SI3Rme6xzq6lXFr4UHjoeMx10LAR+4kOcmuFhiC3LK2JY972YqvArooh
         JVBIsNL0rFnHKHLPDHU7KGh+M6ReyeLAi5WVUBmt1VCpQnbsm9602GjdEp1GDlJ6JjJO
         Vj3CaH5mH04KnxBpS1uJNOHUaL13//M/KTdcR3B0lnMW3UaZgCdibz0PoK6De/pcFJ7U
         DJhg==
X-Gm-Message-State: ACgBeo1B0sR/hZiLoSSOUtBrVOmqH2GgMv1rlxT6wRQNdxOHxuI5gJci
        67qvym4qDSgUGzqVWcx7cuncQ8ghYCjTGp16fso=
X-Google-Smtp-Source: AA6agR6FOqzzU7JQSMz01Q6u6UiAUpMuFACh7Mr4F/7w2ukrPXLqBzqyG7GfefRz6A8DXYVTHr6nnEOhflXbaHwH/3A=
X-Received: by 2002:a0d:d441:0:b0:345:83ae:9330 with SMTP id
 w62-20020a0dd441000000b0034583ae9330mr11962783ywd.97.1662731283363; Fri, 09
 Sep 2022 06:48:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220908141210.1375828-1-zhiguangni01@zhaoxin.com> <YxoPS5OCup1h8QD4@google.com>
In-Reply-To: <YxoPS5OCup1h8QD4@google.com>
From:   Liam Ni <zhiguangni01@gmail.com>
Date:   Fri, 9 Sep 2022 21:47:53 +0800
Message-ID: <CACZJ9cVSYtda7oyJnMmNDtfZotXZu+0i-c8G8onLqj4sPDkCRg@mail.gmail.com>
Subject: Re: [PATCH v2] KVM:x86: Clean up ModR/M "reg" initialization in reg
 op decoding
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, tglx@linutronix.de,
        dave.hansen@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 8 Sept 2022 at 23:50, Sean Christopherson <seanjc@google.com> wrote=
:
>
> On Thu, Sep 08, 2022, Liam Ni wrote:
> > From: Liam Ni <zhiguangni01@gmail.com>
> >
> > Refactor decode_register_operand() to get the ModR/M register if and
> > only if the instruction uses a ModR/M encoding to make it more obvious
> > how the register operand is retrieved.
> >
> > Signed-off-by: Liam Ni <zhiguangni01@gmail.com>
> > ---
>
> Pushed to branch `for_paolo/6.1` at:
>
>     https://github.com/sean-jc/linux.git
>
> with the below nit sqaushed.  Unless you hear otherwise, it will make its=
 way to
> kvm/queue "soon".
>
> Note, the commit IDs are not guaranteed to be stable.
>
> >  arch/x86/kvm/emulate.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> > index f092c54d1a2f..879b52af763a 100644
> > --- a/arch/x86/kvm/emulate.c
> > +++ b/arch/x86/kvm/emulate.c
> > @@ -1137,9 +1137,11 @@ static int em_fnstsw(struct x86_emulate_ctxt *ct=
xt)
> >  static void decode_register_operand(struct x86_emulate_ctxt *ctxt,
> >                                   struct operand *op)
> >  {
> > -     unsigned reg =3D ctxt->modrm_reg;
> > +     unsigned int reg;
> >
> > -     if (!(ctxt->d & ModRM))
> > +     if ((ctxt->d & ModRM))
>
> Only need one set of parentheses.

Sorry=EF=BC=8C  Should I prepare a new patch?

>
> > +             reg =3D ctxt->modrm_reg;
> > +     else
> >               reg =3D (ctxt->b & 7) | ((ctxt->rex_prefix & 1) << 3);
> >
> >       if (ctxt->d & Sse) {
> > --
> > 2.34.1
> >
