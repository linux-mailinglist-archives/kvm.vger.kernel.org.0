Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A942782F8F
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 19:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236861AbjHURiB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 13:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236827AbjHURiA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 13:38:00 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48971F7
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 10:37:58 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 38308e7fff4ca-2b9b5ee9c5aso57600851fa.1
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 10:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692639476; x=1693244276;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7okh5cvhwnlmOxK+/Z3A9I3seXSXeBzNclCnymMRoEM=;
        b=JaDE8RAjX1+JUIrgBZ97U+V4RthvwRFPv6SgdZS3i1eNjzCrj/twl0v6E/EcvUqMUF
         us49XyDth0tI6Cgw5HbTMX8nXgMBNPoDU1T/zcIaGdJqOQaFuqfvaoJinqAbht7htShQ
         GWLcFTSR6amMsuC7E3innMSGeS7TYNF2kFdVCjlie8bcNf4947vqc0ufOm+mdujYiZrD
         jheq7sQa1LAxi2/XzTGvVGJ/DoTvjVMAOo7c5QDFFeLz2btUvhUCliQcwjAqCSnpVkpz
         U+r7ePnfuLL7sqSkPuV4rGUs+m9BAlNOXYQh5UCIxAGcVcZ4I4g544BAyqvyGHFNd9Vr
         62Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692639476; x=1693244276;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7okh5cvhwnlmOxK+/Z3A9I3seXSXeBzNclCnymMRoEM=;
        b=fEWWzJReLuVOxTxndhyQbbjOuNzNyi+LrTQAW/1vmDzb0DSLHErXXkoqwFKvTLmFoB
         LBOR+2eiyuL9F7H6h5tMTlb0n6bDR21Me0Zf3djMLEfxJ9kSNpEX+BraqZiOWcpP/ZsL
         ZWDkj9FVo3yCReYRnpJq0GNSIRdR1p39UeJWuYBE/MGvk44KeaTP5FHbR/u+jIGrr6sk
         gVNLhTujhflHRe6ua4em/Chqjf2oQeXzCBcI3yKWhcQqluVi1etgFLPMov3eChW3UQqe
         u90bTGsixTIpOkbFCkQGXdtV9vWIZw183ONEKT6k4FtN76fh0IW2G23gk9D4zJU9n3HI
         pqWw==
X-Gm-Message-State: AOJu0YyU9nvtikU4p06V7i5Ta1mMLVK8wl71L1W6iaG7Xpx8w2t248NF
        H6lBl+o3eRLeDKNy//OoKko9l54lmYxj0XRCBhmNkId4Dm6qf/RGe3w=
X-Google-Smtp-Source: AGHT+IEsySuciEjUJJT9kSv7k1wphPuG1Rrg8bBGkcdN3O/Ew8oRCE9wRTnB/Y0XqHDRZEsP5CKesfakYf6SLZe3+Bk=
X-Received: by 2002:a2e:b1c4:0:b0:2b9:3883:a765 with SMTP id
 e4-20020a2eb1c4000000b002b93883a765mr5492471lja.31.1692639476432; Mon, 21 Aug
 2023 10:37:56 -0700 (PDT)
MIME-Version: 1.0
References: <20230807162210.2528230-1-jingzhangos@google.com>
 <20230807162210.2528230-6-jingzhangos@google.com> <86r0o1fzdm.wl-maz@kernel.org>
In-Reply-To: <86r0o1fzdm.wl-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Mon, 21 Aug 2023 10:37:44 -0700
Message-ID: <CAAdAUtjN3AYT2ARip20Xjom-V01WA2S_Y78WCfng2LHrRy08Rw@mail.gmail.com>
Subject: Re: [PATCH v8 05/11] KVM: arm64: Enable writable for ID_AA64DFR0_EL1
 and ID_DFR0_EL1
To:     Marc Zyngier <maz@kernel.org>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>,
        Cornelia Huck <cohuck@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Thu, Aug 17, 2023 at 8:43=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Mon, 07 Aug 2023 17:22:03 +0100,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > All valid fields in ID_AA64DFR0_EL1 and ID_DFR0_EL1 are writable
> > from usrespace with this change.
>
> nit: userspace
>

Fixed.

> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index afade7186675..5f6c2be12e44 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -2006,7 +2006,7 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
> >         .set_user =3D set_id_dfr0_el1,
> >         .visibility =3D aa32_id_visibility,
> >         .reset =3D read_sanitised_id_dfr0_el1,
> > -       .val =3D ID_DFR0_EL1_PerfMon_MASK, },
> > +       .val =3D GENMASK(63, 0), },
>
> For obvious reasons, this cannot be a 64 bit mask...
>
> >       ID_HIDDEN(ID_AFR0_EL1),
> >       AA32_ID_SANITISED(ID_MMFR0_EL1),
> >       AA32_ID_SANITISED(ID_MMFR1_EL1),
> > @@ -2055,7 +2055,7 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
> >         .get_user =3D get_id_reg,
> >         .set_user =3D set_id_aa64dfr0_el1,
> >         .reset =3D read_sanitised_id_aa64dfr0_el1,
> > -       .val =3D ID_AA64DFR0_EL1_PMUVer_MASK, },
> > +       .val =3D GENMASK(63, 0), },
>
> What is the actual justification to go from "only the PMU version is
> writable" to "everything is writable"?
>
> Also, what about the RES0 fields?

You're right. We should not mark RES0 fields and those fields KVM hide
from userspace as writable.
So, I think all the other fields can be writable?

>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
>

Thanks,
Jing
