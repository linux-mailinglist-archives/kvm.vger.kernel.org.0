Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6054972A7DF
	for <lists+kvm@lfdr.de>; Sat, 10 Jun 2023 03:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232647AbjFJBxE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 21:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbjFJBxC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 21:53:02 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796913A81;
        Fri,  9 Jun 2023 18:53:01 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id 98e67ed59e1d1-25bb2c4c2c0so22265a91.3;
        Fri, 09 Jun 2023 18:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686361981; x=1688953981;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P5H8c5fhNOiP2kPeNPmLWxBJaGebVzwRYAH/KEzsb/o=;
        b=o5IEWExG1NARMaNk6he7idt3DYkmEZ8IETKouydJDY8E7MmeCE4saF+xhrTmtOxQS4
         hAHfQjbQtmaBrhHZ8cK9pMVranzL/IIPEUUIrQndDDVimK3FhSb9ntBEcoPwwahSAh3m
         hACnZD+emSlWfcH4An7rojRacRraYcHJkQUJMp1e1GLNFu9ZWoE6CMlKyJlivAw3nBCc
         TqHVjw4vMBtro52n1QyhjrkckDUaROeEp4Qrh1jq2p2qYenbvREA7yoRr5TF8zsOumlC
         sBKPnMdbX4PJeW0R5ZLlpCJblJMpkhOHf4Wh60F3mDWMIemBsQu8F4Dp4PtPe7YSufb9
         e3ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686361981; x=1688953981;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P5H8c5fhNOiP2kPeNPmLWxBJaGebVzwRYAH/KEzsb/o=;
        b=BDC6hs+NAc/qx+ntfGW+uAI30UsBAP7SJVjM+qjzS16igBNddNsr2fLj+RCh+QR00+
         8lFfp3Nf1NRbtkUvMpiWIsXyeq8sH8y4/mJrlz1Ggu7F235qLhWHjAfGbwhfOYg//rSl
         xYRSVc2vhrl22KfL5q1hI+J32XGpksWY/d90czUGIs4VWjmU4L5Vu2fEnXAP9oXBa73R
         q7s803V/5Vdm2oPJvCDwyUVOaLzTADnvV+QrwdNooj39+R/1SmfiG6njSe5/7JTw61MK
         0HwyoNzatHV25GD689BT6ZMEbzgqLVQP+e2XGMpl9klHft/M2T+ePX+EM6L0oE3bbsFg
         2b5A==
X-Gm-Message-State: AC+VfDyhuOgkRuPm6gvxXlSN3o7hQPY511qiHvqXjIySxWO1zuQn25U7
        vB3Tofg+4P8s7gLvjt5YIquId0cCcDwBwXrZ7pA=
X-Google-Smtp-Source: ACHHUZ4PfyrbrrByZ6aHkSTloCbBQDhXuHuMhFFM7m5jFoKSg1VwDMV6miDRrHtzgh4dJ1ddJOWEE8Uh/c7gcgtb1Uo=
X-Received: by 2002:a17:90a:cf12:b0:25b:b0d1:b602 with SMTP id
 h18-20020a17090acf1200b0025bb0d1b602mr143927pju.10.1686361980872; Fri, 09 Jun
 2023 18:53:00 -0700 (PDT)
MIME-Version: 1.0
References: <20230605064848.12319-1-jpn@linux.vnet.ibm.com>
 <20230605064848.12319-2-jpn@linux.vnet.ibm.com> <CT696R4C69N1.1OZKTR1A9D3X1@wheely>
In-Reply-To: <CT696R4C69N1.1OZKTR1A9D3X1@wheely>
From:   Jordan Niethe <jniethe5@gmail.com>
Date:   Sat, 10 Jun 2023 11:52:49 +1000
Message-ID: <CACzsE9r3s9taz4uvjzqnnc6RG3t4AgeRVZdwpyyNRkvRUFANwg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/6] KVM: PPC: Use getters and setters for vcpu
 register state
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     Jordan Niethe <jpn@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, mikey@neuling.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, sbhat@linux.ibm.com,
        vaibhav@linux.ibm.com
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

On Wed, Jun 7, 2023 at 5:53=E2=80=AFPM Nicholas Piggin <npiggin@gmail.com> =
wrote:
[snip]
>
> The general idea is fine, some of the names could use a bit of
> improvement. What's a BOOK3S_WRAPPER for example, is it not a
> VCPU_WRAPPER, or alternatively why isn't a VCORE_WRAPPER Book3S
> as well?

Yeah the names are not great.
I didn't call it VCPU_WRAPPER because I wanted to keep separate
BOOK3S_WRAPPER for book3s registers
HV_WRAPPER for hv specific registers
I will change it to something like you suggested.

[snip]
>
> Stray hunk I think.

Yep.

>
> > @@ -957,10 +957,32 @@ static inline void kvmppc_set_##reg(struct kvm_vc=
pu *vcpu, u##size val) \
> >              vcpu->arch.shared->reg =3D cpu_to_le##size(val);          =
 \
> >  }                                                                    \
> >
> > +#define SHARED_CACHE_WRAPPER_GET(reg, size)                          \
> > +static inline u##size kvmppc_get_##reg(struct kvm_vcpu *vcpu)         =
       \
> > +{                                                                    \
> > +     if (kvmppc_shared_big_endian(vcpu))                             \
> > +            return be##size##_to_cpu(vcpu->arch.shared->reg);        \
> > +     else                                                            \
> > +            return le##size##_to_cpu(vcpu->arch.shared->reg);        \
> > +}                                                                    \
> > +
> > +#define SHARED_CACHE_WRAPPER_SET(reg, size)                          \
> > +static inline void kvmppc_set_##reg(struct kvm_vcpu *vcpu, u##size val=
)      \
> > +{                                                                    \
> > +     if (kvmppc_shared_big_endian(vcpu))                             \
> > +            vcpu->arch.shared->reg =3D cpu_to_be##size(val);          =
 \
> > +     else                                                            \
> > +            vcpu->arch.shared->reg =3D cpu_to_le##size(val);          =
 \
> > +}                                                                    \
> > +
> >  #define SHARED_WRAPPER(reg, size)                                    \
> >       SHARED_WRAPPER_GET(reg, size)                                   \
> >       SHARED_WRAPPER_SET(reg, size)                                   \
> >
> > +#define SHARED_CACHE_WRAPPER(reg, size)                               =
       \
> > +     SHARED_CACHE_WRAPPER_GET(reg, size)                             \
> > +     SHARED_CACHE_WRAPPER_SET(reg, size)                             \
>
> SHARED_CACHE_WRAPPER that does the same thing as SHARED_WRAPPER.

That changes once the guest state buffer IDs are included in a later
patch.

>
> I know some of the names are a but crufty but it's probably a good time
> to rethink them a bit.
>
> KVMPPC_VCPU_SHARED_REG_ACCESSOR or something like that. A few
> more keystrokes could help imensely.

Yes, I will do something like that, for the BOOK3S_WRAPPER and
HV_WRAPPER
too.

>
> > diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/b=
ook3s_hv_p9_entry.c
> > index 34f1db212824..34bc0a8a1288 100644
> > --- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
> > +++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
> > @@ -305,7 +305,7 @@ static void switch_mmu_to_guest_radix(struct kvm *k=
vm, struct kvm_vcpu *vcpu, u6
> >       u32 pid;
> >
> >       lpid =3D nested ? nested->shadow_lpid : kvm->arch.lpid;
> > -     pid =3D vcpu->arch.pid;
> > +     pid =3D kvmppc_get_pid(vcpu);
> >
> >       /*
> >        * Prior memory accesses to host PID Q3 must be completed before =
we
>
> Could add some accessors for get_lpid / get_guest_id which check for the
> correct KVM mode maybe.

True.

Thanks,
Jordan

>
> Thanks,
> Nick
>
