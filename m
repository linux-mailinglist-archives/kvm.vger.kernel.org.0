Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0CE878F3E7
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 22:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347346AbjHaUYu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Aug 2023 16:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234431AbjHaUYu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Aug 2023 16:24:50 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA797E70
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 13:24:45 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-570096f51acso1162173a12.0
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 13:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693513485; x=1694118285; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hLtP0B7QCbV/ETdNMxsWIMxjZHiPOti8qoiN6z1b1eo=;
        b=VHMxxokSRzqyBhlSZ7UhoftOI9uuXb7aOG1Bn3meu5bIiiKNslQDLUxyDsYjJamK3x
         MYsudD2am3x8WHq85yB6FM9M+YLNFdaEPR95L77HUnhz1o4hGtUvAaErREBJotdsMPSB
         RqywTzah69CU40v0wyuNsvoO3pMW9b+vQ05jcMaStUBDIo14Geqi9zSG3aWxgJbbmeE4
         yq5mB00X027GgrtWdG2QLkgrivKzJ41PiC3y136EsSLCiAWXBIkhIGAIXD4B9ycVHq+H
         vlHiv8oTNFt7yTM4/rT+4p07ptGn24wNXvyMUjum3jGW1YrijeMdsvUszXUgGxovjAes
         EVsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693513485; x=1694118285;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hLtP0B7QCbV/ETdNMxsWIMxjZHiPOti8qoiN6z1b1eo=;
        b=Zyo3iAb5EGgO/326fOkiCvWOCbe8w/kC6Q5raUoxkIEhtF0cTx5d05e4NEF7RM1vg8
         pTpaD9TKt15Z8JXDEWLrYL23+zVsWk/8qLdTIR5zh1sR9tK2st6YRz+1C+dW7gXf8Utx
         YpecC6FWL2o+uk5HlTq/YwdluX10e4UFCV4m5yIUUbMhHy/1ePioE+XzI0XyQ35DQ5Lk
         5ECXqmbMIq5EwmMFDVTerrEsD7aWoPQwOmrTO/qhViwKgfZEFRh4cdtJMZX/XA7MNRXQ
         afhjZ5N67dTJRixMhRKLNC/3oqVF/j+KJ7I3ScMkbnabMi8lmyxO+hnDa9NtirGIrZBq
         R7lg==
X-Gm-Message-State: AOJu0YxLQYgf5aLy93WGFABXatrVmOuDt0iK/XmMrzX5VIZRuAqz+myY
        8W/4KZ+zKaAWbkdey2y+H9dz1bI28Ho=
X-Google-Smtp-Source: AGHT+IEIR7uyyBtFUvM+BS8m3vckRckLqxPkMKgsib26tB7v3QMYK/vMPUnX7d2k+P2sC+84IAeEcYo9RDM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6046:0:b0:565:e585:cb56 with SMTP id
 a6-20020a656046000000b00565e585cb56mr161663pgp.2.1693513485291; Thu, 31 Aug
 2023 13:24:45 -0700 (PDT)
Date:   Thu, 31 Aug 2023 13:24:43 -0700
In-Reply-To: <873ccab4-1470-3ff0-2e59-01d1110809be@intel.com>
Mime-Version: 1.0
References: <20230719144131.29052-1-binbin.wu@linux.intel.com>
 <ZN1M5RvuARP1YMfp@google.com> <6e990b88-1e28-9563-2c2f-0d5d52f9c7ca@linux.intel.com>
 <e4aa03cb-0f80-bd5f-f69e-39b636476f00@linux.intel.com> <ZN93wp9lgmuJqYIA@google.com>
 <873ccab4-1470-3ff0-2e59-01d1110809be@intel.com>
Message-ID: <ZPD3C/AFnvs9S6vs@google.com>
Subject: Re: [PATCH v10 0/9] Linear Address Masking (LAM) KVM Enabling
From:   Sean Christopherson <seanjc@google.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Binbin Wu <binbin.wu@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        Chao Gao <chao.gao@intel.com>, Kai Huang <kai.huang@intel.com>,
        "David.Laight@aculab.com" <David.Laight@aculab.com>,
        "robert.hu@linux.intel.com" <robert.hu@linux.intel.com>
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

On Fri, Aug 25, 2023, Zeng Guang wrote:
>=20
> On 8/18/2023 9:53 PM, Sean Christopherson wrote:
> > On Fri, Aug 18, 2023, Binbin Wu wrote:
> > > On 8/17/2023 5:17 PM, Binbin Wu wrote:
> > > > On 8/17/2023 6:25 AM, Sean Christopherson wrote:
> > > > > On Wed, Jul 19, 2023, Binbin Wu wrote:
> > > > > For the next version, can you (or Zeng) send a single series for =
LAM
> > > > > and LASS?  They're both pretty much ready to go, i.e. I don't exp=
ect
> > > > > one to hold up the other at this point, and posting a single seri=
es
> > > > > will reduce the probability of me screwing up a conflict resoluti=
on
> > > > > or missing a dependency when applying.
> > > > >=20
> > > Hi Sean,
> > > Do you still prefer a single series for LAM and LASS=C2=A0 for the ne=
xt version
> > > when we don't need to rush for v6.6?
> > Yes, if it's not too much trouble on your end.  Since the two have over=
lapping
> > prep work and concepts, and both series are in good shape, my strong pr=
eference
> > is to grab them at the same time.  I would much rather apply what you'v=
e tested
> > and reduce the probability of messing up any conflicts.
> >=20
> >=20
> >=20
> Hi Sean,
> One more concern, KVM LASS patch has an extra dependency on kernel LASS
> series in which enumerates lass feature bit (X86_FEATURE_LASS/X86_CR4_LAS=
S).
> So far kernel lass patch is still under review, as alternative we may ext=
ract
> relevant patch part along with kvm lass patch set for a single series in =
case
> kernel lass cannot be merged before v6.7.  Do you think it OK in that way=
?

Hmm, since getting LASS support in KVM isn't urgent, I think it makes sense=
 to
wait for kernel support, no reason to complicate things.

To avoid delaying LAM, just put all the LAM patches first, it's trivally ea=
sy for
me to grab a partial series.

Speaking of kernel support, one thing we should explicit discuss is whether=
 or
not KVM should require kernel support for LASS, i.e. if KVM should support =
LASS
if it's present in hardware, even if it's not enabled in the host.

Looking at the kernel patches, LASS will be disabled if vsyscall is in emul=
ate
mode.  Ah, digging deeper, that's an incredibly esoteric and deprecated mod=
e.
bf00745e7791 ("x86/vsyscall: Remove CONFIG_LEGACY_VSYSCALL_EMULATE").

So scratch that, let's again keep things simple.  Might be worth a call out=
 in
the changelog that adds F(LASS), though.
