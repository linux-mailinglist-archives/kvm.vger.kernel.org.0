Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 799627A50DD
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 19:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbjIRRWw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 13:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjIRRWv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 13:22:51 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E274FA
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 10:22:45 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id d75a77b69052e-41761e9181eso17741cf.1
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 10:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695057764; x=1695662564; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xvvJYFIiUxdYFTdPHEaO0CeIjpRLTphScVUwzbxkZK0=;
        b=wndlOZ7zcAzDQaFfix5uVbtaIVLy3pxjyxzT0S+erwGtCKgO7JR5HMn0Lh2iV545k6
         R1psIzr8Vy04SxEEFUZwM6KF+oc5KEQwzP66wHJKKWNGGEQJM5HIRdmz5RZxXHfOvyfZ
         z6LAXfIyTgOfGVHIqaBNu5QMEx0v/mPTvvcNw/TMO0k/M2rVc4X1Y/SFmbWuKI9GxnYc
         MTMzvuhUxUBu3KpQ6lBZTf6TJM/JFLxR/HJnlyblSrKWVX74uEOEbLIwP1yDHT0GohV0
         IyxKbIdsFg5f0v1Okg8uyUKwTz1k3+LmiWpsMWghvwGzjQ8FyApQUGBN6enhMICzDZ/n
         Qkug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695057764; x=1695662564;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xvvJYFIiUxdYFTdPHEaO0CeIjpRLTphScVUwzbxkZK0=;
        b=ZzeN/tp9EqBNSeiLkk70lSoL9v0QwTzl7BD8naO8VYhaQs0auJ1qi3nt55RT4zAHxj
         yzDqjotvV2NVKpsbq6NlZwRAIwN1IaTSLhhgcR+H0bWg2WPb0ewuXadfS8zYWUuk0n+4
         6cfimv3H8Yeq36rwlaqZKJL9X8ftGe1TyDxVuNPlF/qaArC4szIpeuuU8/2aaglxjMk5
         x3j8gEAnFGRmi/pNp+IWy/CYH072LBuyZ+VuSNdTI5+rNXdRJlRj6R2r3wJF4amJ3rfm
         P21dEtRzKGl24v3WzF3KURNvQvGscRUyMpoZQXGqOdWBGVx4A39ENOxQ6QOGtkUZqkTv
         U+OA==
X-Gm-Message-State: AOJu0YwKDFCKeGhG1xf0esPcJ7ACLwpXcLB40YyXFK82artM6MNIN6PI
        +RL7w5aUYoWnyo9ND5w7lKALl4cJi5DTklBKIpOHBg==
X-Google-Smtp-Source: AGHT+IHAUHQ/AMU/gJEDTtvG0y4/dOXnZypfx1XktwC4AQ0OOJH50KDr2c6hw6wINJLIcAGQ28aoPbcDfjjgNSFkLq4=
X-Received: by 2002:a05:622a:1049:b0:410:9855:ac6 with SMTP id
 f9-20020a05622a104900b0041098550ac6mr5770qte.14.1695057764287; Mon, 18 Sep
 2023 10:22:44 -0700 (PDT)
MIME-Version: 1.0
References: <20230817003029.3073210-1-rananta@google.com> <20230817003029.3073210-9-rananta@google.com>
 <ZQTEN664F/5PzyId@linux.dev> <ZQTSffkkI1x5lWIG@linux.dev> <CAJHc60y+xwV3oYk7-YxE1WiOfnSNFzroM419UDJwTeb=MCJdkA@mail.gmail.com>
In-Reply-To: <CAJHc60y+xwV3oYk7-YxE1WiOfnSNFzroM419UDJwTeb=MCJdkA@mail.gmail.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Mon, 18 Sep 2023 10:22:32 -0700
Message-ID: <CAJHc60xT61+o2SY45X9m=ffypo9L3k_wMAU9FTCDay9w1RwM5g@mail.gmail.com>
Subject: Re: [PATCH v5 08/12] KVM: arm64: PMU: Allow userspace to limit
 PMCR_EL0.N for the guest
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On Mon, Sep 18, 2023 at 10:11=E2=80=AFAM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> On Fri, Sep 15, 2023 at 2:54=E2=80=AFPM Oliver Upton <oliver.upton@linux.=
dev> wrote:
> >
> > On Fri, Sep 15, 2023 at 08:53:16PM +0000, Oliver Upton wrote:
> > > Hi Raghu,
> > >
> > > On Thu, Aug 17, 2023 at 12:30:25AM +0000, Raghavendra Rao Ananta wrot=
e:
> > > > From: Reiji Watanabe <reijiw@google.com>
> > > >
> > > > KVM does not yet support userspace modifying PMCR_EL0.N (With
> > > > the previous patch, KVM ignores what is written by upserspace).
> > >
> > > typo: userspace
> > >
> > > > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > > > index ce7de6bbdc967..39ad56a71ad20 100644
> > > > --- a/arch/arm64/kvm/pmu-emul.c
> > > > +++ b/arch/arm64/kvm/pmu-emul.c
> > > > @@ -896,6 +896,7 @@ int kvm_arm_set_vm_pmu(struct kvm *kvm, struct =
arm_pmu *arm_pmu)
> > > >      * while the latter does not.
> > > >      */
> > > >     kvm->arch.pmcr_n =3D arm_pmu->num_events - 1;
> > > > +   kvm->arch.pmcr_n_limit =3D arm_pmu->num_events - 1;
> > >
> > > Can't we just get at this through the arm_pmu instance rather than
> > > copying it into kvm_arch?
> > >
> > > >     return 0;
> > > >  }
> > > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > > index 2075901356c5b..c01d62afa7db4 100644
> > > > --- a/arch/arm64/kvm/sys_regs.c
> > > > +++ b/arch/arm64/kvm/sys_regs.c
> > > > @@ -1086,6 +1086,51 @@ static int get_pmcr(struct kvm_vcpu *vcpu, c=
onst struct sys_reg_desc *r,
> > > >     return 0;
> > > >  }
> > > >
> > > > +static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_de=
sc *r,
> > > > +               u64 val)
> > > > +{
> > > > +   struct kvm *kvm =3D vcpu->kvm;
> > > > +   u64 new_n, mutable_mask;
> > > > +   int ret =3D 0;
> > > > +
> > > > +   new_n =3D FIELD_GET(ARMV8_PMU_PMCR_N, val);
> > > > +
> > > > +   mutex_lock(&kvm->arch.config_lock);
> > > > +   if (unlikely(new_n !=3D kvm->arch.pmcr_n)) {
> > > > +           /*
> > > > +            * The vCPU can't have more counters than the PMU
> > > > +            * hardware implements.
> > > > +            */
> > > > +           if (new_n <=3D kvm->arch.pmcr_n_limit)
> > > > +                   kvm->arch.pmcr_n =3D new_n;
> > > > +           else
> > > > +                   ret =3D -EINVAL;
> > > > +   }
> > >
> > > Hmm, I'm not so sure about returning an error here. ABI has it that
> > > userspace can write any value to PMCR_EL0 successfully. Can we just
> > > ignore writes that attempt to set PMCR_EL0.N to something higher than
> > > supported by hardware? Our general stance should be that system regis=
ter
> > > fields responsible for feature identification are immutable after the=
 VM
> > > has started.
> >
> > I hacked up my reply and dropped some context; this doesn't read right.
> > Shaoqin made the point about preventing changes to PMCR_EL0.N after the
> > VM has started and I firmly agree. The behavior should be:
> >
> >  - Writes to PMCR always succeed
> >
> >  - PMCR_EL0.N values greater than what's supported by hardware are
> >    ignored
> >
> >  - Changes to N after the VM has started are ignored.
> >
> Reiji and I were wondering if we should proceed with this as this
> would change userspace expectation. BTW, when you said "ignored", does
> that mean we silently return to userspace with a success or with EBUSY
> (changing the expectations)?
>
Sorry, I just read your earlier comment (one before you detailed the
behavior), from which I'm guessing "ignore" means simply disregard the
change and return success to userspace. But wouldn't that cause issues
in debugging?

Thank you.
Raghavendra
> Thank you.
> Raghavendra
> > --
> > Thanks,
> > Oliver
