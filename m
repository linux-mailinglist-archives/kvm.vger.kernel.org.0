Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61A726EA253
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 05:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbjDUD13 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 23:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDUD12 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 23:27:28 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBAFD1BD8
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 20:27:26 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1a652700c36so404465ad.0
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 20:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682047646; x=1684639646;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c+iWliMmJZEtXgWOh0UHnuG4gBuoaGaej7xxMmyc3O4=;
        b=m3qK4dAlRbSQLQP8E9iBcnpbxqqk1LOFfr8sFysQIyq681Pc57ssOJHlWbQGrE79q0
         vUPIJ3+oRAzOKPcd0CeDHWphJwY3YChSycgwy5Zi0eyrRGbOaOn/K/YjmtH8JTg6WSEC
         88+VIvhTI23hiIFj++R7SXDpMGJkaa41FVvVwAH+jDUbvFvHC6ACR/9YGzwS6Z21qPXT
         OmkSejU9hG0Bm4svYxDQjalMw78od203TYfcb0VxmEOGM9EFvBfQddriLVQ6GEfB310K
         QAzuhREHhxJWQKp+MaNEcO/5rpzk+Qhl4rSLVysB1yHpBa3H+8nT/UeTQyohmU/PJWux
         +mqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682047646; x=1684639646;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c+iWliMmJZEtXgWOh0UHnuG4gBuoaGaej7xxMmyc3O4=;
        b=R2GfDXhyxsAviyzDaraHWhFpBAs6MyJvyC6zRuRC2MmriPG4nd2S15GNZWWQkJt72Q
         Zi74q6eRl86EQXEtFKYQ9pGm3w1KAuc9UTgocOaQK5Eaek183uDNV8eoXBo5/bbjEpzL
         XG8PR+Ppgj0IIz4EE07TBVaIb9Asa2VrAJjsEqd7XXi7FCGuCqIRm1H177AAXw/Ew9M+
         U6hjNHQbFDtVtOWik1NKUQXgCe7+r5SozyQZtP9cPk2GzVrPED320dvhR9F33xWhpzr2
         nUUikXWiOddbTkjJ1jb5qnG49HvVzLZXRk844zCoiejH4x5A3sX+8Cu94VZBfwOnerTJ
         dq6Q==
X-Gm-Message-State: AAQBX9f13mmNPngNbsaz9Z6Yx+vTqVRGGp9kvCtWQpKaBv66YhvFRWEZ
        WTt9DNFsVSmmWiAe9nMCxpVXO8ns61uhUlfFcitntw==
X-Google-Smtp-Source: AKy350Y0V3oR05OlOu9Ym/IEUsvWMzCAWltkwOvQWPTggbKuhXr6pJ7P/dof0FeWwGEsy6fXviKi3Rd9yRQakaBjSYg=
X-Received: by 2002:a17:902:7205:b0:1a9:343c:76e5 with SMTP id
 ba5-20020a170902720500b001a9343c76e5mr146872plb.18.1682047645947; Thu, 20 Apr
 2023 20:27:25 -0700 (PDT)
MIME-Version: 1.0
References: <20230419021852.2981107-1-reijiw@google.com> <20230419021852.2981107-2-reijiw@google.com>
 <87cz405or6.wl-maz@kernel.org> <20230420021302.iyl3pqo3lg6lpabv@google.com> <86y1mnj7dg.wl-maz@kernel.org>
In-Reply-To: <86y1mnj7dg.wl-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Thu, 20 Apr 2023 20:27:09 -0700
Message-ID: <CAAeT=FxAqWJ01MH748Usvhq5Js6QJnDA-4x3t=4WHTQ+7bXcDw@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] KVM: arm64: Acquire mp_state_lock in kvm_arch_vcpu_ioctl_vcpu_init()
To:     Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Will Deacon <will@kernel.org>
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

On Thu, Apr 20, 2023 at 1:16=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Thu, 20 Apr 2023 03:13:02 +0100,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Hi Marc,
> >
> > On Wed, Apr 19, 2023 at 08:12:45AM +0100, Marc Zyngier wrote:
> > > On Wed, 19 Apr 2023 03:18:51 +0100,
> > > Reiji Watanabe <reijiw@google.com> wrote:
> > > > kvm_arch_vcpu_ioctl_vcpu_init() doesn't acquire mp_state_lock
> > > > when setting the mp_state to KVM_MP_STATE_RUNNABLE. Fix the
> > > > code to acquire the lock.
> > > >
> > > > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > > > ---
> > > >  arch/arm64/kvm/arm.c | 5 ++++-
> > > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > > index fbafcbbcc463..388aa4f18f21 100644
> > > > --- a/arch/arm64/kvm/arm.c
> > > > +++ b/arch/arm64/kvm/arm.c
> > > > @@ -1244,8 +1244,11 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(str=
uct kvm_vcpu *vcpu,
> > > >    */
> > > >   if (test_bit(KVM_ARM_VCPU_POWER_OFF, vcpu->arch.features))
> > > >           kvm_arm_vcpu_power_off(vcpu);
> > > > - else
> > > > + else {
> > > > +         spin_lock(&vcpu->arch.mp_state_lock);
> > > >           WRITE_ONCE(vcpu->arch.mp_state.mp_state, KVM_MP_STATE_RUN=
NABLE);
> > > > +         spin_unlock(&vcpu->arch.mp_state_lock);
> > > > + }
> > > >
> > > >   return 0;
> > > >  }
> > >
> > > I'm not entirely convinced that this fixes anything. What does the
> > > lock hazard against given that the write is atomic? But maybe a
> >
> > It appears that kvm_psci_vcpu_on() expects the vCPU's mp_state
> > to not be changed by holding the lock.  Although I don't think this
> > code practically causes any real issues now, I am a little concerned
> > about leaving one instance that updates mpstate without acquiring the
> > lock, in terms of future maintenance, as holding the lock won't prevent
> > mp_state from being updated.
> >
> > What do you think ?
>
> Right, fair enough. It is probably better to take the lock and not
> have to think of this sort of things... I'm becoming more lazy by the
> minute!
>
> >
> > > slightly more readable of this would be to expand the critical sectio=
n
> > > this way:
> > >
> > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > index 4ec888fdd4f7..bb21d0c25de7 100644
> > > --- a/arch/arm64/kvm/arm.c
> > > +++ b/arch/arm64/kvm/arm.c
> > > @@ -1246,11 +1246,15 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(stru=
ct kvm_vcpu *vcpu,
> > >     /*
> > >      * Handle the "start in power-off" case.
> > >      */
> > > +   spin_lock(&vcpu->arch.mp_state_lock);
> > > +
> > >     if (test_bit(KVM_ARM_VCPU_POWER_OFF, vcpu->arch.features))
> > > -           kvm_arm_vcpu_power_off(vcpu);
> > > +           __kvm_arm_vcpu_power_off(vcpu);
> > >     else
> > >             WRITE_ONCE(vcpu->arch.mp_state.mp_state, KVM_MP_STATE_RUN=
NABLE);
> > >
> > > +   spin_unlock(&vcpu->arch.mp_state_lock);
> > > +
> > >     return 0;
> > >  }
> > >
> > > Thoughts?
> >
> > Yes, it looks better!
>
> Cool. I've applied this change to your patch, applied the series to
> the lock inversion branch, and remerged the branch in -next.
>
> We're getting there! ;-)

Thank you, Marc!
Reiji
