Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8F47B9924
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 02:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244155AbjJEAKl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 20:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244177AbjJEAKh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 20:10:37 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F18DC
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 17:10:33 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-279353904a9so399054a91.3
        for <kvm@vger.kernel.org>; Wed, 04 Oct 2023 17:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696464633; x=1697069433; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gPugQrDnD73C5LTJhkV2zm1niwL250wt+6xcFQiBy84=;
        b=Dn0OGU81g5mIl6PaMNEj/WH0T2m6BygJ7GoIzh8tNy6B6ZqiGV0VmP3sGr+RdBkrsq
         jJoZjHteDHnA4LzSxuILn3AGoM6mddseCTXeEff2DpViwJlAW+KDaUXyDf/ZH6giXRGq
         hdiNt7tZ/oR4AEt16VMjK3Jq1reANaBFLMg4HBeSmAdjgXFOLP++kYOR10zAnzPPDGmQ
         xf9igVp63LSJgfpCsfsW2C2AXA7RGvw9pKt0lpLlPqDL5LK1dAnkYw2g+MHWIBm3c9qv
         nMaVbetDv/ODkCf7LtoACjq6mWXq32DRMrHEsenx2Mqj1MyqjgD94CyovVfnQx724oSb
         +NfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696464633; x=1697069433;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gPugQrDnD73C5LTJhkV2zm1niwL250wt+6xcFQiBy84=;
        b=lW9p4oXlPKyXRqw48FtiC1RZGXW2oixW5h2JWK1rbAPnBpM8/93OSciS7JYAlSotnq
         wYIvoEgdiNoHZNqMZu3oDgCRIA2Vb/gEdZbxevKyGEFQ6niEXLoKUE74i8vn0wr5mHZ2
         kN9KETg8hSJJ5JcocMZ4gUCf3o0ozgOcSdq+JGqFjX04d557peaXPnNky0/IrFFO+jgI
         TikxSHdEnKh/mzdkChCYLXAUiovTmrfzzcud2z4emb1YgPvRHF5zGNfMQS03RMNSLRYH
         8DiNaWwLiDkHVkr7H8eAdWu+DQkSxATlKfnTYCTn5iv6CncL6PMWKFCfmLwozhYBHkJ6
         7SBw==
X-Gm-Message-State: AOJu0Yx3ecK92NIBUmA+YDfwaf6FTMsKQFPPfiUlJki59XCPF70HEzI3
        X/fqBsdaX/Zq/viWDzzcIjLPwhGjU5M=
X-Google-Smtp-Source: AGHT+IGdEKoKxaHSokJn1QJOH9Dx8FDHttRYqzcRDDJyApk3QUMzw3Gxw6QozNYZnV8kxuN/bHp9HMXyr1w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:8d8:b0:278:fb8b:32ae with SMTP id
 ds24-20020a17090b08d800b00278fb8b32aemr61159pjb.9.1696464632755; Wed, 04 Oct
 2023 17:10:32 -0700 (PDT)
Date:   Wed, 4 Oct 2023 17:10:31 -0700
In-Reply-To: <e8993457-9e28-434a-b4e8-25ffcbee6517@maciej.szmigiero.name>
Mime-Version: 1.0
References: <0ffde769702c6cdf6b6c18e1dcb28b25309af7f7.1695659717.git.maciej.szmigiero@oracle.com>
 <ZRHRsgjhOmIrxo0W@google.com> <8c6a1fc8-2ac5-4767-8b02-9ef56434724e@maciej.szmigiero.name>
 <ZRHckCMwOv3jfSs7@google.com> <ac402dd4-8bf3-87a8-7ade-50d62997ce97@amd.com> <e8993457-9e28-434a-b4e8-25ffcbee6517@maciej.szmigiero.name>
Message-ID: <ZR3-90IQqb3mSV-b@google.com>
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
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 02, 2023, Maciej S. Szmigiero wrote:
> On 26.09.2023 00:25, Tom Lendacky wrote:
> > > > It's partially documented in various AMD BKDGs, however I couldn't =
find
> > > > any definition for this particular bit (8) - other than that it is =
reserved.
> > >=20
> > > I found it as MSR_AMD64_BU_CFG for Model 16h, but that's Jaguar/Puma,=
 not Zen1.
> > > My guess is that Windows is trying to write this thing:
> > >=20
> > > =C2=A0=C2=A0 MSRC001_1023 [Table Walker Configuration] (Core::X86::Ms=
r::TW_CFG)
> > > =C2=A0=C2=A0 Read-write. Reset: 0000_0000_0000_0000h.
> > > =C2=A0=C2=A0 _lthree0_core[3,1]; MSRC001_1023
> > >=20
> > > =C2=A0=C2=A0 Bits=C2=A0=C2=A0 Description
> > > =C2=A0=C2=A0 63:50=C2=A0 Reserved.
> > > =C2=A0=C2=A0 49=C2=A0=C2=A0=C2=A0=C2=A0 TwCfgCombineCr0Cd: combine CR=
0_CD for both threads of a core. Read-write. Reset: 0. Init: BIOS,1.
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1=3DThe host C=
r0_Cd values from the two threads are OR'd together and used by both thread=
s.
> > > =C2=A0=C2=A0 48:0=C2=A0=C2=A0 Reserved.
> > >=20
> > > Though that still doesn't explain bit 8...=C2=A0 Perhaps a chicken-bi=
t related to yet
> > > another speculation bug?
> > >=20
> > > Boris or Tom, any idea what Windows is doing?=C2=A0 I doubt it change=
s our options in
> > > terms of "fixing" this in KVM, but having a somewhat accurate/helpful=
 changelog
> > > would be nice.
> >=20
> > It's definitely not related to a speculation bug, but I'm unsure what w=
as
> > told to Microsoft that has them performing that WRMSR. The patch does t=
he
> > proper thing, though, as a guest shouldn't be updating that setting.
> >=20
> > And TW_CFG is the proper name of that MSR for Zen.
>=20
> So, should I prepare v2 with MSR_AMD64_BU_CFG -> MSR_AMD64_TW_CFG change?

If we can get Paolo's attention, I'd like to get his thoughts on punting th=
is
to QEMU/userspace.  I'm worried that "handling" uarch specific MSRs in KVM =
is
going to paint us into a corner and force KVM to check guest F/M/S someday,=
 which
I want to avoid at pretty much all costs.
