Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0646B306A
	for <lists+kvm@lfdr.de>; Thu,  9 Mar 2023 23:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbjCIWUv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 17:20:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbjCIWUp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 17:20:45 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB3698EA1
        for <kvm@vger.kernel.org>; Thu,  9 Mar 2023 14:20:07 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id bg11so2855584oib.5
        for <kvm@vger.kernel.org>; Thu, 09 Mar 2023 14:20:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678400358;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jym0nUiEEbOOCFzlnlOfW+LijEktB+G0Iqs6BtQtNZI=;
        b=s+CvGVw1kC4Rp4CiFuDvNherDkdkqI71dca1eQMFFKnt/ztNDdolfJ3V/EFzX9CoGL
         Zmq3uiPhG+DhMSodJ1+x/pYKXPB0TcR6piRswV/C6I7kOvMB6XwoZqw7DDrCIEVmLqzV
         jhoWc1JhFiRfIowkQ3YowN/5iBUTsmvT8jLRN7ZBntHzDbRcNk//PIuhxaOwSB5IoAJX
         ZXgoIlisxtV8sMd5bsquQc7mP1euMQy32d4gKV6OPnhst+oRTpfIx+BB/ATMzOVtB2T2
         uPqSHkcOMPRvQwCC69BQ4qqfYios5ZgcNabJL4CGaGrNYoZfdRiPpe94s/+VKEb7Yaft
         kNlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678400358;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jym0nUiEEbOOCFzlnlOfW+LijEktB+G0Iqs6BtQtNZI=;
        b=4RN+Ye26J8pmsBwbBY8dQZf5Dg/ffwYWJu3fQhK/j+fa16GJnbQfzq+bDgd5QJvIrI
         /pxVHTOKc2f8TxaDwlo7aHPrEbjfEgtVLaGFzQXxb5SfI8T//SVdvttAh7jCWtrqlnj0
         iHS4TRpEnTQ1dt3RJRQeIZ7O4VdanpHG1pszwupgQf9rm6bzGlwd76Fr0BxPYbgrw1UU
         jRwKWpPHvlOKIx/TrIvOsqSCFmYEYGQTsITn+Vexjz2QV8bgHnlWrw1U9TlIM7HQAXVd
         YBft7zXO2d7K0/O2h88/FZYmP7GYqfxQF9M31Eq+jWyVD64MPzPBfAn8e9b/wes/Py2g
         6OKA==
X-Gm-Message-State: AO0yUKVgVwkZOpng6Ex6++P0CRfE78oZOBqumzVRwyL7G+r8I08M+PSO
        XCuJ/ihv5xaOPDwDuRV6HmlSNKRowxAvnO/TI1nxNg==
X-Google-Smtp-Source: AK7set+PZFyz/IkkqHj3/hze6nBpdrjOZL7Z92InN2k9JiBNkaLuMMQTPuvGBxTXFbyreldmu/TdVrCVAIl6lmnmJy4=
X-Received: by 2002:a54:4102:0:b0:37f:ab56:ff42 with SMTP id
 l2-20020a544102000000b0037fab56ff42mr8087904oic.9.1678400358006; Thu, 09 Mar
 2023 14:19:18 -0800 (PST)
MIME-Version: 1.0
References: <20230215010717.3612794-1-rananta@google.com> <20230215010717.3612794-8-rananta@google.com>
 <CAAeT=FxVyHVRTj_78Jebz9nsc79yfYcbOu2c2hcekJTLgKFFaQ@mail.gmail.com>
In-Reply-To: <CAAeT=FxVyHVRTj_78Jebz9nsc79yfYcbOu2c2hcekJTLgKFFaQ@mail.gmail.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Thu, 9 Mar 2023 14:19:07 -0800
Message-ID: <CAJHc60w7gwUJ_rh6B3F_9SD_uxEDMRLFyahowGpCi54-84y3Hg@mail.gmail.com>
Subject: Re: [REPOST PATCH 07/16] selftests: KVM: aarch64: Add PMU cycle
 counter helpers
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reiji,

On Thu, Mar 2, 2023 at 7:06=E2=80=AFPM Reiji Watanabe <reijiw@google.com> w=
rote:
>
> Hi Raghu,
>
> On Tue, Feb 14, 2023 at 5:07=E2=80=AFPM Raghavendra Rao Ananta
> <rananta@google.com> wrote:
> >
> > Add basic helpers for the test to access the cycle counter
> > registers. The helpers will be used in the upcoming patches
> > to run the tests related to cycle counter.
> >
> > No functional change intended.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  .../testing/selftests/kvm/aarch64/vpmu_test.c | 40 +++++++++++++++++++
> >  1 file changed, 40 insertions(+)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_test.c b/tools/te=
sting/selftests/kvm/aarch64/vpmu_test.c
> > index d72c3c9b9c39f..15aebc7d7dc94 100644
> > --- a/tools/testing/selftests/kvm/aarch64/vpmu_test.c
> > +++ b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
> > @@ -147,6 +147,46 @@ static inline void disable_counter(int idx)
> >         isb();
> >  }
> >
> > +static inline uint64_t read_cycle_counter(void)
> > +{
> > +       return read_sysreg(pmccntr_el0);
> > +}
> > +
> > +static inline void reset_cycle_counter(void)
> > +{
> > +       uint64_t v =3D read_sysreg(pmcr_el0);
> > +
> > +       write_sysreg(ARMV8_PMU_PMCR_C | v, pmcr_el0);
> > +       isb();
> > +}
> > +
> > +static inline void enable_cycle_counter(void)
> > +{
> > +       uint64_t v =3D read_sysreg(pmcntenset_el0);
> > +
> > +       write_sysreg(ARMV8_PMU_CNTENSET_C | v, pmcntenset_el0);
> > +       isb();
> > +}
>
> You might want to use enable_counter() and disable_counter()
> from enable_cycle_counter() and disable_cycle_counter() respectively?
>
Yes, that should work. I'll do that.

Thank you.
Raghavendra

> Thank you,
> Reiji
>
> > +
> > +static inline void disable_cycle_counter(void)
> > +{
> > +       uint64_t v =3D read_sysreg(pmcntenset_el0);
> > +
> > +       write_sysreg(ARMV8_PMU_CNTENSET_C | v, pmcntenclr_el0);
> > +       isb();
> > +}
> > +
> > +static inline void write_pmccfiltr(unsigned long val)
> > +{
> > +       write_sysreg(val, pmccfiltr_el0);
> > +       isb();
> > +}
> > +
> > +static inline uint64_t read_pmccfiltr(void)
> > +{
> > +       return read_sysreg(pmccfiltr_el0);
> > +}
> > +
> >  static inline uint64_t get_pmcr_n(void)
> >  {
> >         return FIELD_GET(ARMV8_PMU_PMCR_N, read_sysreg(pmcr_el0));
> > --
> > 2.39.1.581.gbfd45094c4-goog
> >
