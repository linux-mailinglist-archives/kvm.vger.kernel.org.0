Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF6A25B43F5
	for <lists+kvm@lfdr.de>; Sat, 10 Sep 2022 06:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiIJEP4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Sep 2022 00:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiIJEPy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Sep 2022 00:15:54 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E69117F10E
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 21:15:53 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id 129so3638656vsi.10
        for <kvm@vger.kernel.org>; Fri, 09 Sep 2022 21:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=otYREk8t2WdG/NJ+ZPtuIVmKtO1jI4mWCWtGovgZifs=;
        b=P1/zZ7bOsUX2MawfFHJAH9LBegb1zhmBN9uR6JsmYDcDZCVq8AuQpbgnXpW8iPb4GB
         TP6FJIUZzb+d8XBBIush3ABrXqtl7/wyjLv6aKCkBCFR96Ej72dJpIhO3ezgUn/9MLYM
         Ot0IJEUCvIDFNlMv3Wifnjb5gdhNMEn+PqszUyRDnRilMi6VdoTYkUYAP1HLkux/qd9Y
         UO5gRN03fRRoRjEsJjH3k0g6kxnyy5bX9GYetj2MPWsi7zzaCdyN8RQiN08gM2Z+YRKJ
         tDUvQVqiH5TC9GSDcVbekxwRALeE1CoXehCkEdesZkbbLnE7g0v+5edVCZzDIjWZtRsT
         sK2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=otYREk8t2WdG/NJ+ZPtuIVmKtO1jI4mWCWtGovgZifs=;
        b=nDng69OJH36SKewzweNXHMlC8ZcqPPie5x4/396jV1XKf00RIjwYrjT4QoaMX0Opa9
         dStmMXPjHWryhEuPVeKz6F9N2TCkEDIft3wCuX+VGz0v96krkz+TDupmocqQp5nvXhYX
         0cTkc3wwIay35xsu06m1DuVS93W2pMvJL3IB89vA8K+KjH4ae3WyX9IxKgSbqFV4oERv
         927pwTyq68bci92nFCKsZItXx3uD6AnMbTKJSPaxcr74WtNik8OzI9Hgv9RWjOCCOlQe
         kLZcAidxu+raH49CmfawhtnMvYjptKl5D1PbUz6ZizbNL/MctCS3kabOP80XiJLqkWmS
         lB8A==
X-Gm-Message-State: ACgBeo1l5+PR7U5d9mPcr4coeY+6Fjnsz5f1zRA8Kg3UNEnB/KFCW+MN
        J/C/brSOCV9+cw7J3ux/atcMdy3YVcamBY+sqJsNUA==
X-Google-Smtp-Source: AA6agR4VUM5bZTnLtDGODi754vdxpwLgswug4ZoSrk/lFyazp+e82v69j928eFB59oIJrBArMmqhtHgMHx/zOs6vvnc=
X-Received: by 2002:a67:ea58:0:b0:38f:d89a:e4b3 with SMTP id
 r24-20020a67ea58000000b0038fd89ae4b3mr5967895vso.51.1662783353013; Fri, 09
 Sep 2022 21:15:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220825050846.3418868-1-reijiw@google.com> <20220825050846.3418868-4-reijiw@google.com>
 <YxuX+ztKm/rPetql@google.com>
In-Reply-To: <YxuX+ztKm/rPetql@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Fri, 9 Sep 2022 21:15:37 -0700
Message-ID: <CAAeT=Fx38tW+XkfWBvs+dgB4JU4SpVHOVzu4w-BMkAbe21+W5g@mail.gmail.com>
Subject: Re: [PATCH 3/9] KVM: arm64: selftests: Remove the hard-coded
 {b,w}pn#0 from debug-exceptions
To:     Ricardo Koller <ricarkol@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
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

Hi Ricardo,

On Fri, Sep 9, 2022 at 12:46 PM Ricardo Koller <ricarkol@google.com> wrote:
>
> On Wed, Aug 24, 2022 at 10:08:40PM -0700, Reiji Watanabe wrote:
> > Remove the hard-coded {break,watch}point #0 from the guest_code()
> > in debug-exceptions to allow {break,watch}point number to be
> > specified.  Subsequent patches will add test cases for non-zero
> > {break,watch}points.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  .../selftests/kvm/aarch64/debug-exceptions.c  | 50 ++++++++++++-------
> >  1 file changed, 32 insertions(+), 18 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > index 51047e6b8db3..183ee16acb7d 100644
> > --- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > +++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > @@ -93,6 +93,9 @@ GEN_DEBUG_WRITE_REG(dbgwvr)
> >
> >  static void reset_debug_state(void)
> >  {
> > +     uint8_t brps, wrps, i;
> > +     uint64_t dfr0;
> > +
> >       asm volatile("msr daifset, #8");
> >
> >       write_sysreg(0, osdlr_el1);
> > @@ -100,11 +103,20 @@ static void reset_debug_state(void)
> >       isb();
> >
> >       write_sysreg(0, mdscr_el1);
> > -     /* This test only uses the first bp and wp slot. */
> > -     write_sysreg(0, dbgbvr0_el1);
> > -     write_sysreg(0, dbgbcr0_el1);
> > -     write_sysreg(0, dbgwcr0_el1);
> > -     write_sysreg(0, dbgwvr0_el1);
> > +
> > +     /* Reset all bcr/bvr/wcr/wvr registers */
> > +     dfr0 = read_sysreg(id_aa64dfr0_el1);
> > +     brps = cpuid_get_ufield(dfr0, ID_AA64DFR0_BRPS_SHIFT);
>
> I guess this might have to change to ARM64_FEATURE_GET(). In any case:
>
> Reviewed-by: Ricardo Koller <ricarkol@google.com>
>
> (also assuming it includes the commit message clarification about reset
> clearing all registers).

Yes, I will fix those in V2.

Thank you for the review!
Reiji
