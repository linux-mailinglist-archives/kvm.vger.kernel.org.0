Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 756126F5D1B
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 19:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbjECRj7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 13:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjECRj6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 13:39:58 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466C0AC
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 10:39:57 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-24e0d569a01so2016889a91.2
        for <kvm@vger.kernel.org>; Wed, 03 May 2023 10:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683135597; x=1685727597;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jaNgUREymFs00Yb0mg7CK5SfoWbeJmned3OPDAQIihE=;
        b=fsYBHQWjLN1c2TAemudpJrNbjeVHqe7+5QQHkDQi6Z/0nBduOM1DUUrpIsMsFZGcLf
         NMpF3syzhVSx1vAOpx0fbLqAbosL4eI+dtlQi36iyccxfl6E6f+Po/vqB470Iul+FBlm
         F/M/eaAlClHy/c1D0atYjVen2fOKdL7B6UqbNpveqT7DfydQyM5h6SVr1KKhfejO8pmK
         Z88eJzWbSCgqwR5Mkcdy4bYH1xukJtlqbg6MKyFWL/9qMYkQz72IKUpwcaw/IBtLJi8a
         SyjTGe2unBzkFvf0wxrN+BW2BAPU2MvzDi48ZHHK9QIo/vWubYX4NKW5+LruoV9EB6ZA
         55Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683135597; x=1685727597;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jaNgUREymFs00Yb0mg7CK5SfoWbeJmned3OPDAQIihE=;
        b=GCWwEOi/456Yp2pwIMLBBy41/XIq+aV7b45tFHC9TqGKVR/ZsLbFCERyAtpUH82ct/
         va57jBf7u0zop52e8f39pNeTtEaBXBT642UBGh5apJ6JU0m9YejOjTZKyJbqU4rNJFwQ
         R6etYtGCIJXh7ObCsL75lHYpOoSVWk1Uavb/UmmVwIT/tewT8aD8uJKer5Ihcy6Xu/43
         X6fM/71lsZGPVFpAr3ItFEIq9oWLqSXbAYRBAZEPnFDwMOjOqoihzAhR4NQ1HLXDIssN
         +pzHzdwEaHaC7MG6MeCYVpOwAKmCueDizYlORvhYomO0Rg96TEwsn3icBJkzc3ZQ/pb+
         inBA==
X-Gm-Message-State: AC+VfDzttHwn1uL1k9b1rQLoZThOUSiM9267iePX9j5B1Zhl6vFyNZbL
        9bFBl0ravbXc4tby6kQoXSPxHtT/QDM=
X-Google-Smtp-Source: ACHHUZ5XjGSm7zCGuwEwfzGUlaSfDp04mSDPK5a311XubZ0+jqcjEKM5p3OevUqiAMIldDEYRLKxnOHDobs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:4d0a:b0:24d:fb1d:106d with SMTP id
 c10-20020a17090a4d0a00b0024dfb1d106dmr3029858pjg.2.1683135596770; Wed, 03 May
 2023 10:39:56 -0700 (PDT)
Date:   Wed, 3 May 2023 10:39:55 -0700
In-Reply-To: <CALMp9eTHsS2PwVu38QtOa7JkUvBuR7Znz5wjsNuWBfyjT1O8ow@mail.gmail.com>
Mime-Version: 1.0
References: <20230503041631.3368796-1-mizhang@google.com> <ZFKLB1C+v6HKcy0o@google.com>
 <CALMp9eTHsS2PwVu38QtOa7JkUvBuR7Znz5wjsNuWBfyjT1O8ow@mail.gmail.com>
Message-ID: <ZFKca+dKE+Gjl+IR@google.com>
Subject: Re: [PATCH] KVM: VMX: add MSR_IA32_TSX_CTRL into msrs_to_save
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Mingwei Zhang <mizhang@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 03, 2023, Jim Mattson wrote:
> On Wed, May 3, 2023 at 9:25=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > On Wed, May 03, 2023, Mingwei Zhang wrote:
> > > Add MSR_IA32_TSX_CTRL into msrs_to_save[] to explicitly tell userspac=
e to
> > > save/restore the register value during migration. Missing this may ca=
use
> > > userspace that relies on KVM ioctl(KVM_GET_MSR_INDEX_LIST) fail to po=
rt the
> > > value to the target VM.
> > >
> > > Fixes: b07a5c53d42a ("KVM: vmx: use MSR_IA32_TSX_CTRL to hard-disable=
 TSX on guest that lack it")
> > > Reported-by: Jim Mattson <jmattson@google.com>
> > > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > > ---
> > >  arch/x86/kvm/x86.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 237c483b1230..2236cfee4b7a 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -1431,7 +1431,7 @@ static const u32 msrs_to_save_base[] =3D {
> > >  #endif
> > >       MSR_IA32_TSC, MSR_IA32_CR_PAT, MSR_VM_HSAVE_PA,
> > >       MSR_IA32_FEAT_CTL, MSR_IA32_BNDCFGS, MSR_TSC_AUX,
> > > -     MSR_IA32_SPEC_CTRL,
> > > +     MSR_IA32_SPEC_CTRL, MSR_IA32_TSX_CTRL,
> > >       MSR_IA32_RTIT_CTL, MSR_IA32_RTIT_STATUS, MSR_IA32_RTIT_CR3_MATC=
H,
> > >       MSR_IA32_RTIT_OUTPUT_BASE, MSR_IA32_RTIT_OUTPUT_MASK,
> > >       MSR_IA32_RTIT_ADDR0_A, MSR_IA32_RTIT_ADDR0_B,
> > > --
> >
> > Hmm, KVM shouldn't report the MSR if it can't be written by the guest. =
 Over-
>=20
> I think you mean to say that KVM shouldn't report the MSR if it can't
> be written by *any* guest. KVM_GET_MSR_INDEX_LIST is a device ioctl,
> so it isn't capable of filtering out MSRs that can't be written by
> *the* guest, for some occurrence of "the."

Doh, yes, "the guest" was a handwavy reference to any/all guests.
