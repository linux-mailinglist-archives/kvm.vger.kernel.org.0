Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7BE7718672
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 17:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234548AbjEaPeg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 11:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232596AbjEaPef (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 11:34:35 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C042D126
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 08:34:33 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id e9e14a558f8ab-33bf12b5fb5so124215ab.1
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 08:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685547273; x=1688139273;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yAsiLyOxi5daIerA3y0ZBWvd5Ri4pWJ7DUXyGwKxwlo=;
        b=NX27w1pyXpwUc7WFgu3R99JaxoBrhjCzepzqVTchiZ0NNEs7m1A2/bJtAlKkqMuFji
         o+IQxxDRRtHDuMD9Tq6e5+Vu5kzizMN9x2Aj0u4gH4BRgN5WIUOxZvR+z45in5Z67NOc
         320UjyWAiUpi2TasztP9gceocD7NAW+Pdn3yuTuLG8U3of/l3W50Gsh+NH7B7zgjtYlU
         6zbuV0Ia+EYfTsdLNNkXMnHk6ctvpgfTUK0PQJL6acs+PjaPVdVRdkZgBFzqgRhsOQi+
         +pLynNf88YV2DSZj/vRBqwoweC8miAEA7Fc5QBOZFn588QSt6fMbQ2cjKgfLJlgW1SKd
         HgaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685547273; x=1688139273;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yAsiLyOxi5daIerA3y0ZBWvd5Ri4pWJ7DUXyGwKxwlo=;
        b=iWL/kySfvu0Ss7kBk9DqArp56UY3snhA+h9KPR5sfKZ6RO1vnQpLjbOz+wiIaWQcLA
         0eGdAnLQHUqG1l9vz6cHGdU5HtkNug93zWvQbyfxmreE5cffNApVt2zlGZwbhFanpYtx
         XxeaL7re5EdUC5CjRzVcsmrk5P1WIW0Ai2XGS/6LckhX+Q7gvpzAVqEbVcADKTX81KJO
         5Za7f1w6HCsftC+YKbCwJfoG+NdQgvTN9UgnU4dBu4+I+9uZ2RMZtCJ4++EGCKRU8iwo
         dKrTSWwwwhyIvCs1tNRMgnbwCo1exjWsMjRSs7tUOjCID4kVQds2iXoHwJxzZIzE0mgZ
         W3wQ==
X-Gm-Message-State: AC+VfDwPw98uykOCmHv+XSfhMXpPHVN48GdeL3vJLpgI0twyiCZnJycq
        m5RMbLpmxVQTgUC4BCI2mprfDEHTEm3dfFyR5Fp3Qw==
X-Google-Smtp-Source: ACHHUZ6JhefCODv0aAeKS9y15lUSrXPKxu1AHl3fKoEtLaDypcYxAwnya9L/0uK7o6EJ7yrHB1I4m3xo50yzv0Gt/PU=
X-Received: by 2002:a05:6e02:b2e:b0:32f:7715:4482 with SMTP id
 e14-20020a056e020b2e00b0032f77154482mr183590ilu.4.1685547272905; Wed, 31 May
 2023 08:34:32 -0700 (PDT)
MIME-Version: 1.0
References: <NWb_YOE--3-9@tutanota.com> <357d135f9ed65f4e2970c82ae4e855547db70ad1.camel@redhat.com>
 <CALMp9eTyx1Y0yc7G0c0BsAig=Amv4DYtcNnWPmD-9JHP=ChZiw@mail.gmail.com>
 <CALMp9eSq1r87=jGWc1z85L-QGCTF-jpWgHEQxJ4sVCqCU_0KQQ@mail.gmail.com>
 <5e18e1424868eec10f6dc396b88b65283b57278a.camel@redhat.com> <ZHdcjFPJJwl9RoxF@google.com>
In-Reply-To: <ZHdcjFPJJwl9RoxF@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 31 May 2023 08:34:21 -0700
Message-ID: <CALMp9eTti7gSNKgR=h__SsoKynaR1tR2nHhuk_6tse-3FHJ7mw@mail.gmail.com>
Subject: Re: [Bug] AMD nested: commit broke VMware
To:     Sean Christopherson <seanjc@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, jwarren@tutanota.com,
        Kvm <kvm@vger.kernel.org>
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

On Wed, May 31, 2023 at 7:41=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, May 31, 2023, Maxim Levitsky wrote:
> > =D0=A3 =D0=B2=D1=82, 2023-05-30 =D1=83 13:34 -0700, Jim Mattson =D0=BF=
=D0=B8=D1=88=D0=B5:
> > > On Tue, May 30, 2023 at 1:10=E2=80=AFPM Jim Mattson <jmattson@google.=
com> wrote:
> > > > On Mon, May 29, 2023 at 6:44=E2=80=AFAM Maxim Levitsky <mlevitsk@re=
dhat.com> wrote:
> > > > > =D0=A3 =D0=BF=D0=BD, 2023-05-29 =D1=83 14:58 +0200, jwarren@tutan=
ota.com =D0=BF=D0=B8=D1=88=D0=B5:
> > > > > > I don't know what would be the best case here, maybe put a quir=
k
> > > > > > there, so it doesn't break "userspace".  Committer's email is d=
ead,
> > > > > > so I'm writing here.
> > > > > >
> > > > >
> > > > > I have to say that I know about this for long time, because some =
time
> > > > > ago I used  to play with VMware player in a VM on AMD on my spare=
 time,
> > > > > on weekends (just doing various crazy things with double nesting,
> > > > > running win98 nested, vfio stuff, etc, etc).
> > > > >
> > > > > I didn't report it because its a bug in VMWARE - they set a bit i=
n the
> > > > > tlb_control without checking CPUID's FLUSHBYASID which states tha=
t KVM
> > > > > doesn't support setting this bit.
> > > >
> > > > I am pretty sure that bit 1 is supposed to be ignored on hardware
> > > > without FlushByASID, but I'll have to see if I can dig up an old AP=
M
> > > > to verify that.
> > >
> > > I couldn't find an APM that old, but even today's APM does not specif=
y
> > > that any checks are performed on the TLB_CONTROL field by VMRUN.
> > >
> > > While Intel likes to fail VM-entry for illegal VMCS state, AMD prefer=
s
> > > to massage the VMCB to render any illegal VMCB state legal. For
> > > example, rather than fail VM-entry for a non-canonical address, AMD i=
s
> > > inclined to drop the high bits and sign-extend the low bits, so that
> > > the address is canonical.
> > >
> > > I'm willing to bet that modern CPUs continue to ignore the TLB_CONTRO=
L
> > > bits that were noted "reserved" in version 3.22 of the manual, and
> > > that Krish simply manufactured the checks in commit 174a921b6975
> > > ("nSVM: Check for reserved encodings of TLB_CONTROL in nested VMCB"),
> > > without cause.
>
> Ya.  The APM even provides a definition of "reserved" that explicitly cal=
ls out
> the different reserved qualifiers.  The only fields/values that KVM can a=
ctively
> enforce are things tagged MBZ.
>
>   reserved
>     Fields marked as reserved may be used at some future time.
>     To preserve compatibility with future processors, reserved fields req=
uire special handling when
>     read or written by software. Software must not depend on the state of=
 a reserved field (unless
>     qualified as RAZ), nor upon the ability of such fields to return a pr=
eviously written state.
>     If a field is marked reserved without qualification, software must no=
t change the state of that field;
>     it must reload that field with the same value returned from a prior r=
ead.
>     Reserved fields may be qualified as IGN, MBZ, RAZ, or SBZ (see defini=
tions).
>
> > > > > Supporting FLUSHBYASID would fix this, and make nesting faster to=
o,
> > > > > but it is far from a trivial job.
> > > > >
> > > > > I hope that I will find time to do this soon.
>
> ...
>
> > Shall we revert the offending patch then?
>
> Yes please.

It's not quite that simple.

The vmcb12 TLB_CONTROL field needs to be sanitized on its way into the
vmcb02 (perhaps in nested_copy_vmcb_control_to_cache()?). Bits 63:2
should be cleared. Also, if the guest CPUID does not advertise support
for FlushByASID, then bit 1 should be cleared. Note that the vmcb12
TLB_CONTROL field itself must not be modified, since the APM
specifically states, "The VMRUN instruction reads, but does not
change, the value of the TLB_CONTROL field."
