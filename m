Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89A847C8E3E
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 22:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232062AbjJMUZJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 16:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbjJMUZI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 16:25:08 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B51C4BB
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 13:25:05 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id e9e14a558f8ab-3514ece5ed4so6585ab.1
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 13:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697228705; x=1697833505; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pqAeTW3JeHR2NgxF+OPMVJ48NQjtKJfCWCw4Wwse+lk=;
        b=YUvVFEkCKzorMIna/Vc6KCU1QJlmsb7SiSv2V9G9SWvpzhnR/IrMOhSjhHBRsMDO4T
         1EzbPu3QmL9V6WIHayTOH4DvQkeSmH+zJRsBu5OzLQv3GYOmaQkzS585lLVrSKGdBrZN
         1i4CAAdU2EicMjBaIcKI/AbvaGEmNU2326XqCqaxUkUSrXA8HYF7Owgd54BvMUE2Ra1m
         7J27Y1nZosMp2ppZwFvwN5218AV1EKzzYfmnNTrbUTSMpUknXtcbfC1uVTsyoSd8G8NK
         PE60CABFa1cuBuNR1tIA6vstyrVCFz+qWr2LaLphMPktm6V0V5+3EGhgCwFQyY9BS0BO
         O9aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697228705; x=1697833505;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pqAeTW3JeHR2NgxF+OPMVJ48NQjtKJfCWCw4Wwse+lk=;
        b=MYAIaA5hrD/dtU4kc3VLuf/i/xIduR8G+x5hvZH4kyEr+154VRpl5gNYmlizq9X4xY
         eLyJT7FuuplzPETxv9wdyqDlwwOtFP9wpBoTvg22+T2KntMswmqN7sG7bOjHqRyRi2u8
         mydX2WWdexov40xV6D/1jD9HYo5c8CHdVgRyBms6wjcXDvtmpsE8mT7dh1b67FB7yggV
         E3KzDlvOhKBHg60PLBgQbN+gw8cKpPRO7f+Nz+kFLwpOK9oGeG010RfHWmtUsYIQ2trs
         27rqvsiTL/O/LSZ2bl4ZToLR/bApwGgbY9X7VU2g7jdF5/xstAnyI9vt+eTciNDplrr3
         zPjQ==
X-Gm-Message-State: AOJu0YyBYaY6eGYT1esmSbikv8nVgiTPYQiJ1t5dznKc8is9kImhbCkT
        f8sFy5zhrwioZXL5xrEjsOWXSVe5xa6O4RMhiux0lw==
X-Google-Smtp-Source: AGHT+IH3FYJ8icPieu2/ai2TXNcA8zCg7+rWyoOf+Iq4ZbCOKrHHuD6XmPVTgbe/B7M4h1eHHImeEnUWJbuZ8PtUB1c=
X-Received: by 2002:a05:6e02:220e:b0:351:efb:143d with SMTP id
 j14-20020a056e02220e00b003510efb143dmr29195ilf.22.1697228704929; Fri, 13 Oct
 2023 13:25:04 -0700 (PDT)
MIME-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-7-rananta@google.com>
 <ZSXQh2P_l5xcj7zS@linux.dev> <ZSjY5XCCoji6MjqC@linux.dev>
In-Reply-To: <ZSjY5XCCoji6MjqC@linux.dev>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Fri, 13 Oct 2023 13:24:52 -0700
Message-ID: <CAJHc60yjiuyacbKytTx_ry8=_574CqwzoWdMH7ehBYswCpk5ig@mail.gmail.com>
Subject: Re: [PATCH v7 06/12] KVM: arm64: PMU: Add a helper to read the number
 of counters
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On Thu, Oct 12, 2023 at 10:43=E2=80=AFPM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> On Tue, Oct 10, 2023 at 10:30:31PM +0000, Oliver Upton wrote:
> > On Mon, Oct 09, 2023 at 11:08:52PM +0000, Raghavendra Rao Ananta wrote:
> > > Add a helper, kvm_arm_get_num_counters(), to read the number
> > > of counters from the arm_pmu associated to the VM. Make the
> > > function global as upcoming patches will be interested to
> > > know the value while setting the PMCR.N of the guest from
> > > userspace.
> > >
> > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > ---
> > >  arch/arm64/kvm/pmu-emul.c | 17 +++++++++++++++++
> > >  include/kvm/arm_pmu.h     |  6 ++++++
> > >  2 files changed, 23 insertions(+)
> > >
> > > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > > index a161d6266a5c..84aa8efd9163 100644
> > > --- a/arch/arm64/kvm/pmu-emul.c
> > > +++ b/arch/arm64/kvm/pmu-emul.c
> > > @@ -873,6 +873,23 @@ static bool pmu_irq_is_valid(struct kvm *kvm, in=
t irq)
> > >     return true;
> > >  }
> > >
> > > +/**
> > > + * kvm_arm_get_num_counters - Get the number of general-purpose PMU =
counters.
> > > + * @kvm: The kvm pointer
> > > + */
> > > +int kvm_arm_get_num_counters(struct kvm *kvm)
> >
> > nit: the naming suggests this returns the configured number of PMCs, no=
t
> > the limit.
> >
> > Maybe kvm_arm_pmu_get_max_counters()?
>
Sure, kvm_arm_pmu_get_max_counters() it is!

> Following up on the matter -- please try to avoid sending patches that
> add helpers without any users. Lifting *existing* logic into a helper
> and updating the callsites is itself worthy of a separate patch. But
> adding a new function called by nobody doesn't do much, and can easily
> be squashed into the patch that consumes the new logic.
>
Sounds good. I'll squash patches of this type into the caller patches.

Thank you.
Raghavendra
> --
> Thanks,
> Oliver
