Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 550C7716EE5
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 22:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233506AbjE3Ufz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 16:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjE3Ufy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 16:35:54 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B79DE11A
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 13:35:22 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id e9e14a558f8ab-33b398f2ab8so51865ab.0
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 13:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685478857; x=1688070857;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X4Ug6LGLvnLcDJXgrri6o42SxnjjBZdChx70M96ADWI=;
        b=tB+1Y6VWHo69ocjqG3p9P4P4Tl9TTv8zO/VHBaq6Fsm2o6shVuy5JMZiOFxa+i3cA/
         e9plcnhg0vtN+/jpJyiMctdSs/TpESycUBclEm/YXGP3vOxmSeqGEG/k2nE6B8bH3Q2n
         Vse1ujkpPDdd1qfrncD5XNGEsjAWcTI7wvJ/iVzJMsynQepCdE/VBdLJ1jrEVctEPWNr
         hniqb5uaDWJ85eDqSzieHXYkWGF6JN94wgcYP0i8pP+ny2vI+WITUuCsLlphB/5jVVVO
         lwJqrTLhZhmWfwtAh+V8OtzyJt4IBIADvJjLycq7Mkw/44+3nu4UVgPi8a06OxtNqjcr
         C9sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685478857; x=1688070857;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X4Ug6LGLvnLcDJXgrri6o42SxnjjBZdChx70M96ADWI=;
        b=PligQs26wcPCkbUYCnKPJodPEzCOSR2SQMYH4lbN1aBirWaXuzmxji7F+9IadmXggi
         FoPEdOHi7o7SZhcY8q0mpSreFbSqL3kf6I6n1KyA/okerbovRlh53Dv7rIZqyqBJKa76
         dYyktsH6vcYzFJrt5cHypOI0kJKAGu0TyOUEo3pxPznyizP5olI+wco4wyPHDARc5MvL
         rE9AbXsg3Ad3UORG3yzZQcOHnAvRw23+wftoUSGKufpeGEG6YCr0t2S+ABe3qyWRfAqf
         KmeTcfwfc7iP06DAPtvAz5JEgiQ1qJ78xkA9Nal8W9FR3n57faqNR5xe54E5AOFLUYTB
         qOZg==
X-Gm-Message-State: AC+VfDyxcnnWn9oYpJlVPmSVffWqHURk7ewrOhQCt0Z8XuHbsop9tFJJ
        6H6Hxlor/7dGNymNSGFSpC5SqTkr1Neg38RK229y9JBFLenpdXQ28QUrIA==
X-Google-Smtp-Source: ACHHUZ4A6TcuIdG30/XBOltwjA/QJH2DWvaOgeGhjImLbiJTbe1l7018KDx8ricqvbH6cRFUCFdmBdwrnwy19s/oYww=
X-Received: by 2002:a05:6e02:12cd:b0:335:5c4b:2f8a with SMTP id
 i13-20020a056e0212cd00b003355c4b2f8amr2494ilm.5.1685478857338; Tue, 30 May
 2023 13:34:17 -0700 (PDT)
MIME-Version: 1.0
References: <NWb_YOE--3-9@tutanota.com> <357d135f9ed65f4e2970c82ae4e855547db70ad1.camel@redhat.com>
 <CALMp9eTyx1Y0yc7G0c0BsAig=Amv4DYtcNnWPmD-9JHP=ChZiw@mail.gmail.com>
In-Reply-To: <CALMp9eTyx1Y0yc7G0c0BsAig=Amv4DYtcNnWPmD-9JHP=ChZiw@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 30 May 2023 13:34:06 -0700
Message-ID: <CALMp9eSq1r87=jGWc1z85L-QGCTF-jpWgHEQxJ4sVCqCU_0KQQ@mail.gmail.com>
Subject: Re: [Bug] AMD nested: commit broke VMware
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     jwarren@tutanota.com, Kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 30, 2023 at 1:10=E2=80=AFPM Jim Mattson <jmattson@google.com> w=
rote:
>
> On Mon, May 29, 2023 at 6:44=E2=80=AFAM Maxim Levitsky <mlevitsk@redhat.c=
om> wrote:
> >
> > =D0=A3 =D0=BF=D0=BD, 2023-05-29 =D1=83 14:58 +0200, jwarren@tutanota.co=
m =D0=BF=D0=B8=D1=88=D0=B5:
> > > Hello,
> > > Since kernel 5.16 users can't start VMware VMs when it is nested unde=
r KVM on AMD CPUs.
> > >
> > > User reports are here:
> > > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2008583
> > > https://forums.unraid.net/topic/128868-vmware-7x-will-not-start-any-v=
ms-under-unraid-6110/
> > >
> > > I've pinpointed it to commit 174a921b6975ef959dd82ee9e8844067a62e3ec1=
 (appeared in 5.16rc1)
> > > "nSVM: Check for reserved encodings of TLB_CONTROL in nested VMCB"
> > >
> > > I've confirmed that VMware errors out when it checks for TLB_CONTROL_=
FLUSH_ASID support and gets a 'false' answer.
> > >
> > > First revisions of the patch in question had some support for TLB_CON=
TROL_FLUSH_ASID, but it was removed:
> > > https://lore.kernel.org/kvm/f7c2d5f5-3560-8666-90be-3605220cb93c@redh=
at.com/
> > >
> > > I don't know what would be the best case here, maybe put a quirk ther=
e, so it doesn't break "userspace".
> > > Committer's email is dead, so I'm writing here.
> > >
> >
> > I have to say that I know about this for long time, because some time a=
go I used  to play with VMware player in a
> > VM on AMD on my spare time, on weekends
> > (just doing various crazy things with double nesting, running win98 nes=
ted, vfio stuff, etc, etc).
> >
> > I didn't report it because its a bug in VMWARE - they set a bit in the =
tlb_control without checking CPUID's FLUSHBYASID
> > which states that KVM doesn't support setting this bit.
>
> I am pretty sure that bit 1 is supposed to be ignored on hardware
> without FlushByASID, but I'll have to see if I can dig up an old APM
> to verify that.

I couldn't find an APM that old, but even today's APM does not specify
that any checks are performed on the TLB_CONTROL field by VMRUN.

While Intel likes to fail VM-entry for illegal VMCS state, AMD prefers
to massage the VMCB to render any illegal VMCB state legal. For
example, rather than fail VM-entry for a non-canonical address, AMD is
inclined to drop the high bits and sign-extend the low bits, so that
the address is canonical.

I'm willing to bet that modern CPUs continue to ignore the TLB_CONTROL
bits that were noted "reserved" in version 3.22 of the manual, and
that Krish simply manufactured the checks in commit 174a921b6975
("nSVM: Check for reserved encodings of TLB_CONTROL in nested VMCB"),
without cause.

> > Supporting FLUSHBYASID would fix this, and make nesting faster too,
> > but it is far from a trivial job.
> >
> > I hope that I will find time to do this soon.
> >
> > Best regards,
> >         Maxim Levitsky
> >
> >
