Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B03CE7BAFAC
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 02:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbjJFAoh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 20:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjJFAof (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 20:44:35 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8529DE7
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 17:44:33 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a507986ed6so23746607b3.1
        for <kvm@vger.kernel.org>; Thu, 05 Oct 2023 17:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696553072; x=1697157872; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TmC6vOdYmvXc1r+AmcCVVdtc5vurcrXqL0I0SrSeKiM=;
        b=y0XYfM9DGxxzDmPUq06lCUrcTdyITuI0MV5UtHzRq92cRAd4gAS632x+lFDCvbcGWJ
         yqXSm+6bj8nJbQLmD9cnfNfxRnd2iegx6QAz0LnIsgrZq2yo4HNhB5+8AwpNOgMsLszx
         E6N7vPB7csCZjQN6vSODnEq3rlwFzkLGZoqY/nrtaLBBtRNgS4CyFXIt4btwdH28f5L/
         tiZv9GxputkESK2hEyYat0jjuo4KKU1ZmYFGlhukKlQkLpUh8Sq8LRo18apLCoNt1LWV
         HherJoVzqsNBz1gJaVrFHI1LK50UFKsRYlk2zyQgA3+3LvwpJc9bktyRPRVqLp0Ptjo6
         idIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696553072; x=1697157872;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TmC6vOdYmvXc1r+AmcCVVdtc5vurcrXqL0I0SrSeKiM=;
        b=Q6C0QzAnAv00trFzh3AdijCt8XZ4zCq4VaLrUBW0zatwJT8ssunJO1RO8+SNc1Gx45
         vcYeCDDxPiVHxjm8gtGK/1P5Iy1Ieilaaow72o97gISb/j25Xu1NXkPkYawbjLBhWfk/
         xFJRZ32DlbofF1mxhO0xJghKtWcBMNl4qHuVwhy5Pyv5IqBJd8/QD9MzZfOShtKCFwh6
         9ThEruSM7PQNHZSq6o970IESMpWS9EfGR3nHamv7gv3Bg5wga4PbnHOaEdE0X4zyFOks
         x9IQcBWivjJBxxIRhg5QL769JnQBLB/fopRljxINGiD9SPz94mLuEw3JnOmrAD8w54Gc
         eJkQ==
X-Gm-Message-State: AOJu0YwYMKPkP/aWNZmK3v9G1+GTBnPH54m/9ghTlC2FexQY+9+4XbEb
        s5DHP87VpTS9Ig2vEDqN/3xd3DEzm/Q=
X-Google-Smtp-Source: AGHT+IH8zUoy3PHklZpdSRK7ZVEZ8csfl/RaK8sThKhtMAD1aTNhlQPTXCl1Sl90SHZ0grcyU46Gn8NLpyU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d510:0:b0:d89:4247:4191 with SMTP id
 r16-20020a25d510000000b00d8942474191mr110364ybe.3.1696553072785; Thu, 05 Oct
 2023 17:44:32 -0700 (PDT)
Date:   Thu, 5 Oct 2023 17:44:31 -0700
In-Reply-To: <04cae79f-cd04-4cfe-b6ca-8b02d96350f9@maciej.szmigiero.name>
Mime-Version: 1.0
References: <0ffde769702c6cdf6b6c18e1dcb28b25309af7f7.1695659717.git.maciej.szmigiero@oracle.com>
 <ZRHRsgjhOmIrxo0W@google.com> <8c6a1fc8-2ac5-4767-8b02-9ef56434724e@maciej.szmigiero.name>
 <ZRHckCMwOv3jfSs7@google.com> <ac402dd4-8bf3-87a8-7ade-50d62997ce97@amd.com>
 <e8993457-9e28-434a-b4e8-25ffcbee6517@maciej.szmigiero.name>
 <ZR3-90IQqb3mSV-b@google.com> <04cae79f-cd04-4cfe-b6ca-8b02d96350f9@maciej.szmigiero.name>
Message-ID: <ZR9Yb25A5zOhzDol@google.com>
Subject: Re: [PATCH] KVM: x86: Ignore MSR_AMD64_BU_CFG access
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
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

On Thu, Oct 05, 2023, Maciej S. Szmigiero wrote:
> On 5.10.2023 02:10, Sean Christopherson wrote:
> > On Mon, Oct 02, 2023, Maciej S. Szmigiero wrote:
> > > On 26.09.2023 00:25, Tom Lendacky wrote:
> > > > > > It's partially documented in various AMD BKDGs, however I could=
n't find
> > > > > > any definition for this particular bit (8) - other than that it=
 is reserved.
> > > > >=20
> > > > > I found it as MSR_AMD64_BU_CFG for Model 16h, but that's Jaguar/P=
uma, not Zen1.
> > > > > My guess is that Windows is trying to write this thing:
> > > > >=20
> > > > >  =C2=A0=C2=A0 MSRC001_1023 [Table Walker Configuration] (Core::X8=
6::Msr::TW_CFG)
> > > > >  =C2=A0=C2=A0 Read-write. Reset: 0000_0000_0000_0000h.
> > > > >  =C2=A0=C2=A0 _lthree0_core[3,1]; MSRC001_1023
> > > > >=20
> > > > >  =C2=A0=C2=A0 Bits=C2=A0=C2=A0 Description
> > > > >  =C2=A0=C2=A0 63:50=C2=A0 Reserved.
> > > > >  =C2=A0=C2=A0 49=C2=A0=C2=A0=C2=A0=C2=A0 TwCfgCombineCr0Cd: combi=
ne CR0_CD for both threads of a core. Read-write. Reset: 0. Init: BIOS,1.
> > > > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1=3DThe h=
ost Cr0_Cd values from the two threads are OR'd together and used by both t=
hreads.
> > > > >  =C2=A0=C2=A0 48:0=C2=A0=C2=A0 Reserved.
> > > > >=20
> > > > > Though that still doesn't explain bit 8...=C2=A0 Perhaps a chicke=
n-bit related to yet
> > > > > another speculation bug?
> > > > >=20
> > > > > Boris or Tom, any idea what Windows is doing?=C2=A0 I doubt it ch=
anges our options in
> > > > > terms of "fixing" this in KVM, but having a somewhat accurate/hel=
pful changelog
> > > > > would be nice.
> > > >=20
> > > > It's definitely not related to a speculation bug, but I'm unsure wh=
at was
> > > > told to Microsoft that has them performing that WRMSR. The patch do=
es the
> > > > proper thing, though, as a guest shouldn't be updating that setting=
.
> > > >=20
> > > > And TW_CFG is the proper name of that MSR for Zen.
> > >=20
> > > So, should I prepare v2 with MSR_AMD64_BU_CFG -> MSR_AMD64_TW_CFG cha=
nge?
> >=20
> > If we can get Paolo's attention, I'd like to get his thoughts on puntin=
g this
> > to QEMU/userspace.  I'm worried that "handling" uarch specific MSRs in =
KVM is
> > going to paint us into a corner and force KVM to check guest F/M/S some=
day, which
> > I want to avoid at pretty much all costs.
>=20
> We already do similar ignoring in KVM for MSR_AMD64_BU_CFG2, MSR_AMD64_DC=
_CFG
> and MSR_F15H_EX_CFG, so doing this {BU_CFG2,TW_CFG} MSR filtering in QEMU=
 would
> be inconsistent with these.

Not if QEMU filters those too. :-)

The MSR filter mechanism wasn't a thing back when KVM added "support" for t=
hose
MSR, so I don't feel that punting to userspace would be inconsistent.  It's=
 more
along the lines of asking/requiring userspace to utilize a new tool to solv=
e a
problem that is best solved in userspace, with a few outliers that got
grandfathered in.

Anyways, yeah, let's get Paolo's feedback.
