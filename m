Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD90377E3DB
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 16:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343758AbjHPOjv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 10:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343784AbjHPOja (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 10:39:30 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574602D67
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 07:39:03 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d6adc83eb10so3500158276.2
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 07:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692196741; x=1692801541;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jX7V1lWluewhSh6VMm5HNZIM42OiPORMFCW/iRk3n2s=;
        b=cccuvca16nyqVbTT+p9NSMZsvpgmLzaCavWmkhGRspARsQI445ljxYnl/xM9pXE9iq
         kI1541LdnXukuAuL73uLvN7Z7Lk0yrcLeeThM7TABW+xSp+QemBd0jzVoR/ZWyJfKz9O
         MwzWLAaDVQZGFMq9TF/+TfgKNe1ajrgF8PYwJVDSP1jDRVxXWvs0VFjyXdI+wEs9UqZp
         5WEpenVLKOKBbAentiDPY7WJq7kFfz14K0uY1+hJzNr/QtnnDD8VqI2z3K0ex2OSncm2
         X9qrvzbUrOYBzk5wstwOwcINpjuqoXdeccyAWWi4yAdY6B5HA1LeEsQ6+5pVY8Ur1LQx
         RoKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692196741; x=1692801541;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jX7V1lWluewhSh6VMm5HNZIM42OiPORMFCW/iRk3n2s=;
        b=SKKQppKzkTiqqM27NjceHpuF1h1gt4CehNkf+rYMUd2wZvaVse0p43DqFT5KgEaP8w
         eF4ZRP8lBX9TykZOf7rIIxHnjlWnQFC+RzByN9c+nUoSz3NTo9/qGecXwMeEIf73EWlL
         jGvxufxWCFpXAGGimpjyy6oky5nSukmoDMDTTS6t0r0NtLEDfvo8n/j7aMpTxU3uXqNP
         4NFt+O/VAx+NsCh5jR5QwjcBZYFTZI6YFNsdMv+dJAuxHyxb8vsA8NOBjy7vlxXpJ7G7
         5UDlb77iTR2XN3XdZDolyNzuFJYeTrBMwlBMv7pqzCfoNefszcVGr9i6FYeemAfgAveZ
         26gw==
X-Gm-Message-State: AOJu0YxEHvuVn8qwQUyrhRjbqkWu10jnXkqj73FFmWBfwrzZgTj6FL7V
        vtiDOGodqCgtWb5pKhTg0R3kMEWDCb8=
X-Google-Smtp-Source: AGHT+IGLS18VtpS5sotDPXKkkyKkV2lBpEJVX+jOkjIePdxefddQ5MDvZSPMjSRTbXRFZc1ZcLoclXrAX0E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:b901:0:b0:d71:36b5:e9ee with SMTP id
 x1-20020a25b901000000b00d7136b5e9eemr33704ybj.8.1692196740878; Wed, 16 Aug
 2023 07:39:00 -0700 (PDT)
Date:   Wed, 16 Aug 2023 07:38:59 -0700
In-Reply-To: <e2662efe-9c53-77de-836c-a29076d3ccdc@linux.intel.com>
Mime-Version: 1.0
References: <20230719024558.8539-1-guang.zeng@intel.com> <20230719024558.8539-3-guang.zeng@intel.com>
 <ZNwBeN8mGr1sJJ6i@google.com> <e2662efe-9c53-77de-836c-a29076d3ccdc@linux.intel.com>
Message-ID: <ZNzfgxTnB6KYWENg@google.com>
Subject: Re: [PATCH v2 2/8] KVM: x86: Use a new flag for branch instructions
From:   Sean Christopherson <seanjc@google.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     Zeng Guang <guang.zeng@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 16, 2023, Binbin Wu wrote:
>=20
>=20
> On 8/16/2023 6:51 AM, Sean Christopherson wrote:
> > Branch *targets*, not branch instructions.
> >=20
> > On Wed, Jul 19, 2023, Zeng Guang wrote:
> > > From: Binbin Wu <binbin.wu@linux.intel.com>
> > >=20
> > > Use the new flag X86EMUL_F_BRANCH instead of X86EMUL_F_FETCH in
> > > assign_eip(), since strictly speaking it is not behavior of instructi=
on
> > > fetch.
> > Eh, I'd just drop this paragraph, as evidenced by this code existing as=
-is for
> > years, we wouldn't introduce X86EMUL_F_BRANCH just because resolving a =
branch
> > target isn't strictly an instruction fetch.
> >=20
> > > Another reason is to distinguish instruction fetch and execution of b=
ranch
> > > instruction for feature(s) that handle differently on them.
> > Similar to the shortlog, it's about computing the branch target, not ex=
ecuting a
> > branch instruction.  That distinction matters, e.g. a Jcc that is not t=
aken will
> > *not* follow the branch target, but the instruction is still *executed*=
.  And there
> > exist instructions that compute branch targets, but aren't what most pe=
ople would
> > typically consider a branch instruction, e.g. XBEGIN.
> >=20
> > > Branch instruction is not data access instruction, so skip checking a=
gainst
> > > execute-only code segment as instruction fetch.
> > Rather than call out individual use case, I would simply state that as =
of this
> > patch, X86EMUL_F_BRANCH and X86EMUL_F_FETCH are identical as far as KVM=
 is
> > concernered.  That let's the reader know that (a) there's no intended c=
hange in
> > behavior and (b) that the intent is to effectively split all consumptio=
n of
> > X86EMUL_F_FETCH into (X86EMUL_F_FETCH | X86EMUL_F_BRANCH).
>=20
> How about this:
>=20
> =C2=A0=C2=A0=C2=A0 KVM: x86: Use a new flag for branch targets
>=20
> =C2=A0=C2=A0=C2=A0 Use the new flag X86EMUL_F_BRANCH instead of X86EMUL_F=
_FETCH in
> assign_eip()
> =C2=A0=C2=A0=C2=A0 to distinguish instruction fetch and branch target com=
putation for
> feature(s)

Just "features", i.e. no parentheses...

> =C2=A0=C2=A0=C2=A0 that handle differently on them.

...and tack on ", e.g. LASS and LAM." at the end.  There's zero reason not =
to more
explicitly call out why the flag is being added.  Trying to predict the fut=
ure in
changelogs is generally discouraged, but having understandable changelogs i=
s more
important.

> =C2=A0=C2=A0=C2=A0 As of this patch, X86EMUL_F_BRANCH and X86EMUL_F_FETCH=
 are identical as
> far as
> =C2=A0=C2=A0=C2=A0 KVM is concernered.
>=20
> =C2=A0=C2=A0=C2=A0 No functional change intended.

Heh, you need to fix whatever is forcefully wrapping lines, but other than =
the
nit above, the content itself is good.
