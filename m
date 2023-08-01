Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0E3576AB86
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 10:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbjHAI7B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 04:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbjHAI7A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 04:59:00 -0400
X-Greylist: delayed 566 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 01 Aug 2023 01:58:59 PDT
Received: from w1.tutanota.de (w1.tutanota.de [81.3.6.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A5FE7
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 01:58:58 -0700 (PDT)
Received: from tutadb.w10.tutanota.de (unknown [192.168.1.10])
        by w1.tutanota.de (Postfix) with ESMTP id 42C55FBFB8D;
        Tue,  1 Aug 2023 08:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1690879770;
        s=s1; d=tutanota.com;
        h=From:From:To:To:Subject:Subject:Content-Description:Content-ID:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Cc:Cc:Date:Date:In-Reply-To:In-Reply-To:MIME-Version:MIME-Version:Message-ID:Message-ID:Reply-To:References:References:Sender;
        bh=+Au4Mj6RgnSR9rpwJXsJX+KLmib/ID20/x245dyyC5g=;
        b=ZGraCpW7hj6Q5j1iryy9A6HFaPu8hMl1L/3h7ASocvXmc41tQlca8WCm1vSLLnav
        gK7y3YaOlS7NPemowtk6D4XvjMCdLsL3mju00iK/SFxPxfyTaM6Wo+HvxWwF0NYUnj9
        Qs0ulXJOPlJzvopvYTAM7IQtojGiYoTr032nmpaOjUl/DrWRAbYRr5gC4RurgYc2TOz
        ULvdX/ZaSHayfQKE+OCDY+aeAtxgtYXXQVSEfjQxEb6RCz/usPV/bTYTnifaAulSzBi
        nHf0IX5hvdhxMTuVhSgajakif113QbTiqPekuGvGY/eH8/ShOdm6bRhbM+UKXlLr8tC
        49cybgUYuw==
Date:   Tue, 1 Aug 2023 10:49:30 +0200 (CEST)
From:   jwarren@tutanota.com
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, Kvm <kvm@vger.kernel.org>
Message-ID: <NakHQwK--3-9@tutanota.com>
In-Reply-To: <CALMp9eTti7gSNKgR=h__SsoKynaR1tR2nHhuk_6tse-3FHJ7mw@mail.gmail.com-NWmRa0I----9>
References: <NWb_YOE--3-9@tutanota.com> <357d135f9ed65f4e2970c82ae4e855547db70ad1.camel@redhat.com> <CALMp9eTyx1Y0yc7G0c0BsAig=Amv4DYtcNnWPmD-9JHP=ChZiw@mail.gmail.com> <CALMp9eSq1r87=jGWc1z85L-QGCTF-jpWgHEQxJ4sVCqCU_0KQQ@mail.gmail.com> <5e18e1424868eec10f6dc396b88b65283b57278a.camel@redhat.com> <ZHdcjFPJJwl9RoxF@google.com> <CALMp9eTti7gSNKgR=h__SsoKynaR1tR2nHhuk_6tse-3FHJ7mw@mail.gmail.com-NWmRa0I----9>
Subject: Re: [Bug] AMD nested: commit broke VMware
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi
Are there any thoughts on this?

PS As I see it, that commit didn't fix any real problem (up to 5.15 nothing=
 was broken that required it), but did break nested VMWare Workstation/ESXi=
 for people that use it (yes, it's vmware's code bug, but doubt they will f=
ix it).


May 31, 2023, 15:34 by jmattson@google.com:

> On Wed, May 31, 2023 at 7:41=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
>
>>
>> On Wed, May 31, 2023, Maxim Levitsky wrote:
>> > =D0=A3 =D0=B2=D1=82, 2023-05-30 =D1=83 13:34 -0700, Jim Mattson =D0=BF=
=D0=B8=D1=88=D0=B5:
>> > > On Tue, May 30, 2023 at 1:10=E2=80=AFPM Jim Mattson <jmattson@google=
.com> wrote:
>> > > > On Mon, May 29, 2023 at 6:44=E2=80=AFAM Maxim Levitsky <mlevitsk@r=
edhat.com> wrote:
>> > > > > =D0=A3 =D0=BF=D0=BD, 2023-05-29 =D1=83 14:58 +0200, jwarren@tuta=
nota.com =D0=BF=D0=B8=D1=88=D0=B5:
>> > > > > > I don't know what would be the best case here, maybe put a qui=
rk
>> > > > > > there, so it doesn't break "userspace".  Committer's email is =
dead,
>> > > > > > so I'm writing here.
>> > > > > >
>> > > > >
>> > > > > I have to say that I know about this for long time, because some=
 time
>> > > > > ago I used  to play with VMware player in a VM on AMD on my spar=
e time,
>> > > > > on weekends (just doing various crazy things with double nesting=
,
>> > > > > running win98 nested, vfio stuff, etc, etc).
>> > > > >
>> > > > > I didn't report it because its a bug in VMWARE - they set a bit =
in the
>> > > > > tlb_control without checking CPUID's FLUSHBYASID which states th=
at KVM
>> > > > > doesn't support setting this bit.
>> > > >
>> > > > I am pretty sure that bit 1 is supposed to be ignored on hardware
>> > > > without FlushByASID, but I'll have to see if I can dig up an old A=
PM
>> > > > to verify that.
>> > >
>> > > I couldn't find an APM that old, but even today's APM does not speci=
fy
>> > > that any checks are performed on the TLB_CONTROL field by VMRUN.
>> > >
>> > > While Intel likes to fail VM-entry for illegal VMCS state, AMD prefe=
rs
>> > > to massage the VMCB to render any illegal VMCB state legal. For
>> > > example, rather than fail VM-entry for a non-canonical address, AMD =
is
>> > > inclined to drop the high bits and sign-extend the low bits, so that
>> > > the address is canonical.
>> > >
>> > > I'm willing to bet that modern CPUs continue to ignore the TLB_CONTR=
OL
>> > > bits that were noted "reserved" in version 3.22 of the manual, and
>> > > that Krish simply manufactured the checks in commit 174a921b6975
>> > > ("nSVM: Check for reserved encodings of TLB_CONTROL in nested VMCB")=
,
>> > > without cause.
>>
>> Ya.  The APM even provides a definition of "reserved" that explicitly ca=
lls out
>> the different reserved qualifiers.  The only fields/values that KVM can =
actively
>> enforce are things tagged MBZ.
>>
>>  reserved
>>  Fields marked as reserved may be used at some future time.
>>  To preserve compatibility with future processors, reserved fields requi=
re special handling when
>>  read or written by software. Software must not depend on the state of a=
 reserved field (unless
>>  qualified as RAZ), nor upon the ability of such fields to return a prev=
iously written state.
>>  If a field is marked reserved without qualification, software must not =
change the state of that field;
>>  it must reload that field with the same value returned from a prior rea=
d.
>>  Reserved fields may be qualified as IGN, MBZ, RAZ, or SBZ (see definiti=
ons).
>>
>> > > > > Supporting FLUSHBYASID would fix this, and make nesting faster t=
oo,
>> > > > > but it is far from a trivial job.
>> > > > >
>> > > > > I hope that I will find time to do this soon.
>>
>> ...
>>
>> > Shall we revert the offending patch then?
>>
>> Yes please.
>>
>
> It's not quite that simple.
>
> The vmcb12 TLB_CONTROL field needs to be sanitized on its way into the
> vmcb02 (perhaps in nested_copy_vmcb_control_to_cache()?). Bits 63:2
> should be cleared. Also, if the guest CPUID does not advertise support
> for FlushByASID, then bit 1 should be cleared. Note that the vmcb12
> TLB_CONTROL field itself must not be modified, since the APM
> specifically states, "The VMRUN instruction reads, but does not
> change, the value of the TLB_CONTROL field."
>

