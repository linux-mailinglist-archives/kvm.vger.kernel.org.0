Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB2367944B0
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 22:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232902AbjIFUlV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 16:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234886AbjIFUlU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 16:41:20 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F9B1BF7
        for <kvm@vger.kernel.org>; Wed,  6 Sep 2023 13:40:45 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-58f9db8bc1dso3101677b3.3
        for <kvm@vger.kernel.org>; Wed, 06 Sep 2023 13:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694032844; x=1694637644; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zLKnmsDh7An3uMZlLtPf0KdRYzVIWg3PHDNc1codXb0=;
        b=uIp73PvIQ9n89Cmx2Qyz9qvd9E0Eef2wB32SjDGU0wgHbD4vQr8MQht3PXcEVyymw4
         PiukPR6DhGagKDc0KF8hmEG0DfHgZY9TfU7rR9hiEAaTq8NbXLsflYOko+NDYoqg0p5W
         drpvCSoIdg5tFe0ZirHld8t2AKFWvINDKdD5DP7fzyVxaSGKfMg3hy+CKjgoK2Lutyja
         bz1Y/6XkbDPk2jMsqN9b1jB8JxU2GiJNTcj3B4XrBbUln6eV629gl9VgJv5HAnzT7kod
         kvRt6xtBV+0XUL71jsRWZRFlJNYArFFKoRpu4iF/ry8s4mzgTMgh4jeRObncaoy/1y7G
         5jZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694032844; x=1694637644;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zLKnmsDh7An3uMZlLtPf0KdRYzVIWg3PHDNc1codXb0=;
        b=YC4z0xEPLKvla9PqD80vZBaYZ3PydKgTZ/Y/8Q+D71iK4WYMxWoBFszHq/gvzFF6nz
         LL6NPr6EJ3xXWw7h9V4Cdc5Von2ROaViI9hUrhY5hIbV8nLNVWisR6YrK2aquq4TKz56
         VD0RIjfH3sbPYmdyJ0njmNcqeq6p2GQZKahzEB2noDYxelkdU/d5jrmdbvV0mhS3hBVU
         0cAjk3N/Cga7TuBhagPCyyHlsOwYlIICTd9lV2CYiP0bovL1qIVzcVr8TysB8ll8rB2D
         9er2SxBhbpWr4ZDEZUmSqgef6P7g6c0ZeO98qbkVDk151t53h9xbjVUGn+UPnd9Y7jqr
         UbSA==
X-Gm-Message-State: AOJu0Yyhq25sKdiE2Ws5fQEYW2okm0rMj6z1a9kKQ3KuCnx/bR9rKpcU
        mKtKEP+e/53Ir+0XgrUyC7G0gLDKmos=
X-Google-Smtp-Source: AGHT+IHCl9HZalNurzI73f/uze8z39hSSAj52XJLJzJrlrIc+sSiWKr8T3RPPPdFNF9e9gQhFTDkDBroNKg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b628:0:b0:595:5cf0:a9b0 with SMTP id
 u40-20020a81b628000000b005955cf0a9b0mr410265ywh.9.1694032844712; Wed, 06 Sep
 2023 13:40:44 -0700 (PDT)
Date:   Wed, 6 Sep 2023 13:40:43 -0700
In-Reply-To: <b9915c9c-4cf6-051a-2d91-44cc6380f455@proxmox.com>
Mime-Version: 1.0
References: <20210920235134.101970-1-krish.sadhukhan@oracle.com>
 <20210920235134.101970-3-krish.sadhukhan@oracle.com> <f7c2d5f5-3560-8666-90be-3605220cb93c@redhat.com>
 <b9915c9c-4cf6-051a-2d91-44cc6380f455@proxmox.com>
Message-ID: <ZPjjy94x2BDIitOo@google.com>
Subject: Re: [PATCH 2/5] nSVM: Check for optional commands and reserved
 encodings of TLB_CONTROL in nested VMCB
From:   Sean Christopherson <seanjc@google.com>
To:     Stefan Sterz <s.sterz@proxmox.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        kvm@vger.kernel.org, jmattson@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, joro@8bytes.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 06, 2023, Stefan Sterz wrote:
> On 28.09.21 18:55, Paolo Bonzini wrote:
> > On 21/09/21 01:51, Krish Sadhukhan wrote:
> >> +{
> >> +=C2=A0=C2=A0=C2=A0 switch(tlb_ctl) {
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case TLB_CONTROL_DO_NOTHIN=
G:
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case TLB_CONTROL_FLUSH_ALL=
_ASID:
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
turn true;
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case TLB_CONTROL_FLUSH_ASI=
D:
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case TLB_CONTROL_FLUSH_ASI=
D_LOCAL:
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if=
 (guest_cpuid_has(vcpu, X86_FEATURE_FLUSHBYASID))
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 return true;
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fa=
llthrough;
> >
> > Since nested FLUSHBYASID is not supported yet, this second set of case
> > labels can go away.
> >
> > Queued with that change, thanks.
> >
> > Paolo
> >
>=20
> Are there any plans to support FLUSHBYASID in the future? It seems
> VMWare Workstation and ESXi require this feature to run on top of KVM
> [1]. This means that after the introduction of this check these VMs fail
> to boot and report missing features. Hence, upgrading to a newer kernel
> version is not an option for some users.

IIUC, there's two different issues.  KVM "broke" Workstation 16 by adding a=
 bogus
consistency check.  And Workstation 17 managed to make things worse by tryi=
ng to
do the right thing (assert that a feature is supported instead of blindly u=
sing it).

I say the above consistency check is bogus because I can't find anything in=
 the APM
that states that TLB_CONTROL is actually checked.  Unless something is call=
ed out
in "Canonicalization and Consistency Checks" or listed as MBZ (Must Be Zero=
), AMD
behavior is typically to let software shoot itself in the foot.

So unless I'm missing something, commit 174a921b6975 ("nSVM: Check for rese=
rved
encodings of TLB_CONTROL in nested VMCB") should be reverted.

However, that doesn't help Workstation 17.  On the other hand, I don't see =
how
Workstation 17 could ever have worked on KVM, since KVM has never advertise=
d
FLUSHBYASID to L1.

That said, "supporting" FLUSHBYASID is trivial, KVM just needs to advertise=
 the
bit to userspace.  That'll work because KVM's TLB flush "handling" for nSVM=
 is
to just flush everything on every transition (it's been a TODO for a long, =
long
time).

> Sorry if I misunderstood something or if this is not the right place to a=
sk.
>=20
> [1]: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2008583
