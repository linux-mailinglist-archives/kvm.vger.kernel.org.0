Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D442B75B4AA
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 18:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbjGTQkH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 12:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbjGTQjw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 12:39:52 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FEEE30C3
        for <kvm@vger.kernel.org>; Thu, 20 Jul 2023 09:39:30 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id 46e09a7af769-6b9d68a7abaso820096a34.3
        for <kvm@vger.kernel.org>; Thu, 20 Jul 2023 09:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689871168; x=1690475968;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hbkr9MsN6GS2zP4ChfBB/zC7lOL9scc+qhxb4xXFEHY=;
        b=ZsFDGq8cH/dWXxvB9jnW7BB7gCWULwMCvXTzzuLeSz638a3+G9S2UqX/8cmrYcLzN0
         yvN+TMD76I2EYK0SX1EecmKJmCSn73KXdzTdxnZpEds3ttSrnvy/yeu62hWo01qPw8pq
         rxUf41TPQ7f0ZU98Dun0XYO9XulNM5WTTdq9SYdP0Bnl4izB0mNiHltWfH9F+2ASloM9
         dXgh0o8j6e8Nx0+gNnetSdWpBNiRagMqlHoqGcgcE3ykUzYsrj+9Z9Cip/cDdzgsuWoO
         yM1GYpZAHvwxUrEtih8bv+jp2JLPruSUnsHd12qWtMTjdaHr07WiGTOaq9DvlNfSqIYI
         dFKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689871168; x=1690475968;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hbkr9MsN6GS2zP4ChfBB/zC7lOL9scc+qhxb4xXFEHY=;
        b=A2pm2g2p6u3Hvo0ixB9IJCkS11BZ214yfGndh1dNQRapxjXRg1FxGxiqQ4fxaCmQbk
         X2nwaV6Z6oIe7q0kGNHe6J6LqaCbuHmHoMDDKLzI8FQ4c+GnFSIJ4yFeFYvLIQx3Q8tq
         +RvUtqatkLSXLBqKzp8ahCZJGYGLCM9GwEpm/ocOoOxx1XYyoCiGpl1rAzRGwYTaILJZ
         Kb3TjEqfR9hImLFc5lNsWLb01kN3feTGiayK9ydIb54syLcnWgnRJKsJ3dXVhIFoK2pK
         +1G3fCH5MLm0aT8Lzd8nL1SrnnU0err11yo1v+EFnbd3A21W3EPwGdQcUBAEyp/QTvN1
         OyCQ==
X-Gm-Message-State: ABy/qLarXtiWLIg/vnK4guAzZJJ1C4fhC8737DpgaVx44PelPxq4aoxa
        JCujTFNNvfbPsZbwwh+rCdXQnqpjvFNd2Y6uYnM7Cw==
X-Google-Smtp-Source: APBJJlFzGdOrTTow2+txRV2Vh5nCFjfKe7odZM806Rr1bFcCUvl0DLCd/EZzsZ/T53f5OmkGfZ+OZ09Q8fMBdMsSS0Q=
X-Received: by 2002:a05:6870:f68e:b0:1b0:649f:e68a with SMTP id
 el14-20020a056870f68e00b001b0649fe68amr24733oab.25.1689871168307; Thu, 20 Jul
 2023 09:39:28 -0700 (PDT)
MIME-Version: 1.0
References: <20230718164522.3498236-1-jingzhangos@google.com>
 <20230718164522.3498236-4-jingzhangos@google.com> <87o7k77yn5.fsf@redhat.com>
In-Reply-To: <87o7k77yn5.fsf@redhat.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Thu, 20 Jul 2023 09:39:15 -0700
Message-ID: <CAAdAUthM6JJ0tEqWELcW48E235EbcjZQSDLF9OQUZ_kUtqh3Ng@mail.gmail.com>
Subject: Re: [PATCH v6 3/6] KVM: arm64: Enable writable for ID_AA64DFR0_EL1
 and ID_DFR0_EL1
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>
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

Hi Cornelia,

On Thu, Jul 20, 2023 at 1:52=E2=80=AFAM Cornelia Huck <cohuck@redhat.com> w=
rote:
>
> On Tue, Jul 18 2023, Jing Zhang <jingzhangos@google.com> wrote:
>
> > All valid fields in ID_AA64DFR0_EL1 and ID_DFR0_EL1 are writable
> > from usrespace with this change.
>
> Typo: s/usrespace/userspace/
Thanks.
>
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 053d8057ff1e..f33aec83f1b4 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -2008,7 +2008,7 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
> >         .set_user =3D set_id_dfr0_el1,
> >         .visibility =3D aa32_id_visibility,
> >         .reset =3D read_sanitised_id_dfr0_el1,
> > -       .val =3D ID_DFR0_EL1_PerfMon_MASK, },
> > +       .val =3D GENMASK(63, 0), },
> >       ID_HIDDEN(ID_AFR0_EL1),
> >       AA32_ID_SANITISED(ID_MMFR0_EL1),
> >       AA32_ID_SANITISED(ID_MMFR1_EL1),
> > @@ -2057,7 +2057,7 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
> >         .get_user =3D get_id_reg,
> >         .set_user =3D set_id_aa64dfr0_el1,
> >         .reset =3D read_sanitised_id_aa64dfr0_el1,
> > -       .val =3D ID_AA64DFR0_EL1_PMUVer_MASK, },
> > +       .val =3D GENMASK(63, 0), },
> >       ID_SANITISED(ID_AA64DFR1_EL1),
> >       ID_UNALLOCATED(5,2),
> >       ID_UNALLOCATED(5,3),
>
> How does userspace find out whether a given id reg is actually writable,
> other than trying to write to it?
>
No mechanism was provided to userspace to discover if a given idreg or
any fields of a given idreg is writable. The write to a readonly idreg
can also succeed (write ignored) without any error if what's written
is exactly the same as what the idreg holds or if it is a write to
AArch32 idregs on an AArch64-only system.
Not sure if it is worth adding an API to return the writable mask for
idregs, since we want to enable the writable for all allocated
unhidden idregs eventually.

Thanks,
Jing
