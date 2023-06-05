Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8AD722DFC
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 19:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235488AbjFERyt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 13:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbjFERyn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 13:54:43 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8352C10C
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 10:54:28 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-977c72b116fso353176266b.3
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 10:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685987667; x=1688579667;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I0rxC/AXZcDVD2p/332O86/6MCSD5wZD13+g0GaeIO8=;
        b=KHNZv6ltj0ezKfmsQaupIYuKlJIvLTAfNfpsI5wcLa+/yHxK/k4k870asv3XmhoqYa
         sNQb9ZBniophZjwPKlrN2LTO1viassQOLNrE0KJ7qen10QMZQ57Onr7zMuqTPhwQGuUc
         TAfMMfzNxMvHkDpCxRFwefg63hbvFo52LOxNLCGJKfL4RYQY1+amKeYbRjXsaWi7l3IX
         2HyyuBiguCGIobVNozDBEngq4kslCdAAJNNOHL7KfAzGzGwJ2avrUEL8GKCba+i3ig3j
         MfUw6xZbETNbVkj0zmg6m0QglxcBrrYpi5u11UvD1kFKsrrX0ECvn/59XiUQjqZwH/Xu
         3vDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685987667; x=1688579667;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I0rxC/AXZcDVD2p/332O86/6MCSD5wZD13+g0GaeIO8=;
        b=C8uL4FfHb7UnjxJGPBjPmN+ZOPw2W5Zlq65Gd+/TrR2rAgE5lE9uzfhOLRXcWMc4q8
         0G8cinKyk6lsG+xbCXhwZAFQvBNC7T7jXWlealjaVskR6kPLg6WMKLOhF4WcOxuT0b+U
         q9ouP4EL/osj0lZ61OL7T70wajD/2B51l33mFBiRYuUs/rmg1pofxYlki9FBiM0cNhkw
         9AllBCqOo/R3tAbowUoKyKD2B16clpY0hLti0BgWCMCNaCq4fHHXw2TxHrHufyMS0M4E
         ub0kv/9TYglbunZ7gxWeRy7cSgtd8O4j8CZAMNstvtTTHx0G/SGM89AxxO90cj7CZU2S
         a4SA==
X-Gm-Message-State: AC+VfDynbL/dfdPZalEimDZb/SdSDCwxH6Qq1IjWNMawDAgTyjQNr3uM
        iwi/UYTguMgON9f7RFoOP26L230G4zxEnPM5W1TvQQ==
X-Google-Smtp-Source: ACHHUZ7XfC1DgJ1vxU9jd4Il/BLV6t7V1cC3bN5yBhKGVQrT58fFZ8dnfxHNlnoNvgBcdPQ6N4l+ZCFTha5QEtAzHsQ=
X-Received: by 2002:a17:907:97cf:b0:96a:8412:a44d with SMTP id
 js15-20020a17090797cf00b0096a8412a44dmr7560270ejc.36.1685987666868; Mon, 05
 Jun 2023 10:54:26 -0700 (PDT)
MIME-Version: 1.0
References: <20230605004334.1930091-1-mizhang@google.com> <CALMp9eSQgcKd=SN4q2QRYbveKoayKzuYEQPM0Xu+FgQ_Mja8-g@mail.gmail.com>
 <CANgfPd9kKxq1146F3mX_u7KCC0HrWfgYrxZd6c9Dh7s19E4Eog@mail.gmail.com>
In-Reply-To: <CANgfPd9kKxq1146F3mX_u7KCC0HrWfgYrxZd6c9Dh7s19E4Eog@mail.gmail.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Mon, 5 Jun 2023 10:53:50 -0700
Message-ID: <CAL715WLyuQDg7LBmj=xqUbqZC_x2ZGUb4N6qZ_tvPhAAzggYng@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Remove KVM MMU write lock when accessing indirect_shadow_pages
To:     Ben Gardon <bgardon@google.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 5, 2023 at 10:17=E2=80=AFAM Ben Gardon <bgardon@google.com> wro=
te:
>
> On Mon, Jun 5, 2023 at 9:55=E2=80=AFAM Jim Mattson <jmattson@google.com> =
wrote:
> >
> > On Sun, Jun 4, 2023 at 5:43=E2=80=AFPM Mingwei Zhang <mizhang@google.co=
m> wrote:
> > >
> > > Remove KVM MMU write lock when accessing indirect_shadow_pages counte=
r when
> > > page role is direct because this counter value is used as a coarse-gr=
ained
> > > heuristics to check if there is nested guest active. Racing with this
> > > heuristics without mmu lock will be harmless because the correspondin=
g
> > > indirect shadow sptes for the GPA will either be zapped by this threa=
d or
> > > some other thread who has previously zapped all indirect shadow pages=
 and
> > > makes the value to 0.
> > >
> > > Because of that, remove the KVM MMU write lock pair to potentially re=
duce
> > > the lock contension and improve the performance of nested VM. In addi=
tion
> > > opportunistically change the comment of 'direct mmu' to make the
> > > description consistent with other places.
> > >
> > > Reported-by: Jim Mattson <jmattson@google.com>
> > > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > > ---
> > >  arch/x86/kvm/x86.c | 10 ++--------
> > >  1 file changed, 2 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 5ad55ef71433..97cfa5a00ff2 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -8585,15 +8585,9 @@ static bool reexecute_instruction(struct kvm_v=
cpu *vcpu, gpa_t cr2_or_gpa,
> > >
> > >         kvm_release_pfn_clean(pfn);
> > >
> > > -       /* The instructions are well-emulated on direct mmu. */
> > > +       /* The instructions are well-emulated on Direct MMUs. */
>
> Nit: Internally within Google, on older kernels, we have the "Direct
> MMU" which was the precursor to the TDP MMU we all know and love. This
> comment however does not refer to the Direct MMU. Direct here just
> refers to the direct role bit being set. Since it's just descriptive,
> direct should not be capitalized in this comment, so no reason to
> change this line.

You are right., it is incorrect to uppercase the 'direct', since that
generates confusions with our internal MMU implementation. So, I will
just uppercase the 'mmu' here in the next version.
