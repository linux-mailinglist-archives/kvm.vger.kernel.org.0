Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82CED705665
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 20:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjEPSzK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 14:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjEPSzJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 14:55:09 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 313211FD4
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 11:55:08 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1aaf702c3ccso15605ad.1
        for <kvm@vger.kernel.org>; Tue, 16 May 2023 11:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684263307; x=1686855307;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8fHu8DghP/3luSr7ps7cBkVA14o+LEPwp4DzxgOICm0=;
        b=EWymJLI8k5puZBECOECCM84RcyNPf+rTQ8fonInnveY/Tffhcw7y8207Ev8sUwcA1B
         VTOVrYAwkrLX/47yt82UvGrmSrlFwBkC3vW0bnGnrFF3CcnmyvGB0duRIXyqwBUf2EP7
         KQnI/Zndg507Fljg9y8xyqc+eOGV7A0p39pGeGBCdAclB9liFAq9U82AnbyTgpauEarM
         HOu11s1B8mjE3d6Z97hP+ZptKvE7hEiDr8f7uwWsuCNMMr1npGYmfp+Be7/bBF2hywbK
         Umm1BxmPThLI9WFUXoYpzxelXFbF3zAdXdiLgFti+Cz1/Btdni0Cp1cWGVBmm9nslRO4
         Qv3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684263307; x=1686855307;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8fHu8DghP/3luSr7ps7cBkVA14o+LEPwp4DzxgOICm0=;
        b=hXqnPXe9+I7GgKTJRHSb1QvRgkkeG54T+BwX3IfYTYBWoLe4mKEgHiLiOyWP/DF5Kx
         3UAEQmYvdI5b4JIZthN1j8Yoy6dGnrxkX9OIAtAuQBvRbM8Vz69t1BWLVBadSQldHui2
         o7l8qwFav/7cdTRf5WExEbe+j7wONyjHCOz8STHM6NDBrata/j/4RMNpiM0vz61vWKjB
         TL4UMbbPYM0nLpPn60FDmOnoAGJBXKlnRVQm3a+xh9KVOo98OEmefQl9wSjsHX89YZj7
         Jf9IKETvdmnakL2ianPQaV8BflIu93pWqzP7+k3ThkJqXs07ov0xvulNJ6SoS2FAoYZj
         Inaw==
X-Gm-Message-State: AC+VfDxZc7oh3hyYi+aZlDqhieB+sSvq53YTgMyFzddIhbMlIXUhLWUQ
        QWwpz0z7/27+HXareBOogm4DYG6HubWJ1gl11Bxu9A==
X-Google-Smtp-Source: ACHHUZ7tZ09F/p3tKg+e7V/wH7ylAcrEIIFRoV+uNHj0vk7rLne7WYSwiuVG8QKXQ1XXx7qqfBebFzGe81h5v2o/EMM=
X-Received: by 2002:a17:902:dac6:b0:1ac:2daf:34da with SMTP id
 q6-20020a170902dac600b001ac2daf34damr3858plx.17.1684263307150; Tue, 16 May
 2023 11:55:07 -0700 (PDT)
MIME-Version: 1.0
References: <20230414172922.812640-1-rananta@google.com> <20230414172922.812640-8-rananta@google.com>
 <ZF5xLrr2tEYdLL1i@linux.dev> <CAJHc60wUu3xB4J8oJ+FCxerDad1TzZLCMgHYGFfv0K-hzC0qmw@mail.gmail.com>
 <ZGPPj1AXS0Uah2Ug@linux.dev>
In-Reply-To: <ZGPPj1AXS0Uah2Ug@linux.dev>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Tue, 16 May 2023 11:54:55 -0700
Message-ID: <CAJHc60wF19h9ixEQK5SS+oGA41xNqrFQaH9VE6sS0DXjQFCh7A@mail.gmail.com>
Subject: Re: [PATCH v3 7/7] KVM: arm64: Use TLBI range-based intructions for unmap
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Ricardo Koller <ricarkol@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
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

On Tue, May 16, 2023 at 11:46=E2=80=AFAM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> On Tue, May 16, 2023 at 10:21:33AM -0700, Raghavendra Rao Ananta wrote:
> > On Fri, May 12, 2023 at 10:02=E2=80=AFAM Oliver Upton <oliver.upton@lin=
ux.dev> wrote:
> > > >  int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u6=
4 size)
> > > >  {
> > > > +     int ret;
> > > > +     struct stage2_unmap_data unmap_data =3D {
> > > > +             .pgt =3D pgt,
> > > > +             /*
> > > > +              * If FEAT_TLBIRANGE is implemented, defer the indivi=
dial PTE
> > > > +              * TLB invalidations until the entire walk is finishe=
d, and
> > > > +              * then use the range-based TLBI instructions to do t=
he
> > > > +              * invalidations. Condition this upon S2FWB in order =
to avoid
> > > > +              * a page-table walk again to perform the CMOs after =
TLBI.
> > > > +              */
> > > > +             .skip_pte_tlbis =3D system_supports_tlb_range() &&
> > > > +                                     stage2_has_fwb(pgt),
> > >
> > > Why can't the underlying walker just call these two helpers directly?
> > > There are static keys behind these...
> > >
> > I wasn't aware of that. Although, I tried to look into the
> > definitions, but couldn't understand how static keys are at play here.
> > By any chance are you referring to the alternative_has_feature_*()
> > implementations when checking for cpu capabilities?
>
> Ah, right, these were recently changed to rely on alternative patching
> in commit 21fb26bfb01f ("arm64: alternatives: add alternative_has_feature=
_*()").
> Even still, the significance remains as the alternative patching
> completely eliminates a conditional branch on the presence of a
> particular feature.
>
> Initializing a local with the presence/absence of a feature defeats such
> an optimization.
>
Thanks for the info! Introduction of stage2_unmap_defer_tlb_flush()
(in patch-7/7) would call these functions as needed and get rid of
'skip_pte_tlbis'.

- Raghavendra
> --
> Thanks,
> Oliver
