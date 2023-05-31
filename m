Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0999718867
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 19:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbjEaRZS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 13:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjEaRZQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 13:25:16 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C889138
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 10:25:15 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-19f22575d89so13097fac.0
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 10:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685553913; x=1688145913;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R8+/MBQepRDI0OzLzQ5plxv42NdlvgBOSqXlyRiX80Y=;
        b=xfHjW547AHFk/W3dAN1Jx5EKvwh3tf1YH020KFRZ2GEsw6YPt+i03E0W3sqGPqfoF1
         ie/s+hDMtN/R1V/nMp21qdHsDu9b+ykH5CX5xDSOMV9WFCL//a/kxYB+GSPDoeKWlSVD
         9ZVahGF1X1cVAJQ0BQ3RoFyTUnYYte4THgKPHP9+Iz9nSGmoRAlK0A6QUaMZkVoCdrz4
         mpG58Mxboy9DkxFzW1KUu56ii+RphjRex0q72WLZ4GUm/aoBzfKDHz3U2ucplWgy/RAm
         0Qr5msDg8cyrOsEvzKvgFdfxPSaWehdDZt6OuXGgJeAtqjwZ3b/NWf4cdjbnBFl0iwvu
         oi8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685553913; x=1688145913;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R8+/MBQepRDI0OzLzQ5plxv42NdlvgBOSqXlyRiX80Y=;
        b=SJjzjJ/nk2NWS5s6UG5ULKPffTN5J2UM2lOB+nKWg9sUjz8spTTtBc1pjh1GUtAcjs
         PMuHYbffEcKgFXYHGckOUZUXo0LmJUFAHolorzccLH7Y2Ko1m6Fab0shAOH5gtLd8cBK
         gAx/8+Ht8h+9fbDzgYoqbqkhz2anchJx1+ZbydHWt7Sh0A9L+YkMXHDBf4Dno9U1BakU
         iwEN6GwtRG+CEP+Y7Zd7k3rJQlP/JNZrfsfWDF2F/Leozvn0FSEJLL99dtJJGUwkEak4
         gdlZVqk0kKQCkCDttCsY5D/BMnZn+bE3yUDFdyZKep79PIbVQKwIrrwqgHDieyeioriN
         vAUA==
X-Gm-Message-State: AC+VfDyQGw9hadO4FIGijGD8gsMdasakUice3hBRNx6NbC8Dmknn5fKN
        iuLawMD7atggRyL9j3m8Riu9eTn1SmEXzq7nEPjlvg==
X-Google-Smtp-Source: ACHHUZ7yJXTw61LUz1K4R+gWjK7FQ4VYk3Vtr9WfXanKCcQCZmy3tZpSmzEwwwtsQyzOUvwrJEAL8ukZmooRX+6EI54=
X-Received: by 2002:a05:6870:44c2:b0:19a:71ce:c9f5 with SMTP id
 t2-20020a05687044c200b0019a71cec9f5mr2683493oai.29.1685553912941; Wed, 31 May
 2023 10:25:12 -0700 (PDT)
MIME-Version: 1.0
References: <20230522221835.957419-1-jingzhangos@google.com>
 <20230522221835.957419-2-jingzhangos@google.com> <87ttvwok3d.wl-maz@kernel.org>
 <CAAdAUtinwccyd+URCLjowXq47_LP_SjLNEqm-F9GqycmTZrYuw@mail.gmail.com> <864jntc6au.wl-maz@kernel.org>
In-Reply-To: <864jntc6au.wl-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Wed, 31 May 2023 10:25:01 -0700
Message-ID: <CAAdAUthzGevCPfb=aK0ndTCckLtcHmxZ3kgwYUejMYVy0=CHmg@mail.gmail.com>
Subject: Re: [PATCH v10 1/5] KVM: arm64: Save ID registers' sanitized value
 per guest
To:     Marc Zyngier <maz@kernel.org>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
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

Hi Marc,

On Wed, May 31, 2023 at 12:24=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> On Tue, 30 May 2023 19:02:03 +0100,
> Jing Zhang <jingzhangos@google.com> wrote:
>
> [...]
>
> > > > +/*
> > > > + * Set the guest's ID registers with ID_SANITISED() to the host's =
sanitized value.
> > > > + */
> > > > +void kvm_arm_init_id_regs(struct kvm *kvm)
> > > > +{
> > > > +     const struct sys_reg_desc *idreg;
> > > > +     struct sys_reg_params params;
> > > > +     u32 id;
> > > > +
> > > > +     /* Find the first idreg (SYS_ID_PFR0_EL1) in sys_reg_descs. *=
/
> > > > +     id =3D SYS_ID_PFR0_EL1;
> > > > +     params =3D encoding_to_params(id);
> > > > +     idreg =3D find_reg(&params, sys_reg_descs, ARRAY_SIZE(sys_reg=
_descs));
> > > > +     if (WARN_ON(!idreg))
> > > > +             return;
> > >
> > > What is this trying to guard against? Not finding ID_PFR0_EL1 in the
> > > sysreg table? But this says nothing about the following registers (al=
l
> > > 55 of them), so why do we need to special-case this one?
> > Here is to find the first idreg in the array and warn that no idregs
> > found in the array with the assumption that ID_PFR0_EL1 is the first
> > one defined and if it is not found, then no other idregs are defined
> > either.
>
> I didn't make my point clear. What we have is a purely static array.
> Why should we perform such a test on every single VM creation? Any
> structural validation should only happen once, at KVM init time.
>
> > Another way is to go through all the regs in array sys_reg_descs and
> > do the initialization if it is a idreg.
>
> That'd be a waste of precious cycles.
>
> This WARN_ON()+early return should go, but the rest is fine.
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
That makes sense. We don't have to do the check on every single VM
creation. And the code to find the ID_PFR0_EL1 should not be done for
every VM creation either.
I'll use a static variable to save the pointer to ID_PFR0_EL1 and do
the check and search in kvm_sys_reg_table_init().

Thanks,
Jing
