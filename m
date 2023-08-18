Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A449780D10
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 15:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377425AbjHRNx4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 09:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377442AbjHRNx1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 09:53:27 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DAE54210
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 06:53:09 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-58f9db8bc1dso4048897b3.3
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 06:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692366789; x=1692971589;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hcmJQTd7UNP5XiYb1sBnqy4rqkmZTlMQd83qoh50z00=;
        b=4CSZ0rvc4chRG6lB7b6lAhrvUkL78kkZlDm/UZotJZtuvX59E6nIlRjAtlurQNMSBu
         HO8hs3mOrtFx/z24wom2aig2viGmo+G8QB+lnbq4r/dkuTQTQ4baosOylwI8wdjadyPM
         5KN73mN7RSJHYvk5IpvV0EMENc2ARGvbIK/rysi+Nk3A/Np+BasI38m4DRrjmFXWBf4b
         cqrm6OvhidEkd9qDGobcKGXV+xPCglTrd73+16bTFRWwMPARpEO7dzD3ZdFaUvmhRQPk
         vhqqbVWnaDsoHHbxenzG9YzJLsVIh66tyxxvjPUGNre0bV42fBdFfh40F2+N4sxUwZf1
         o/Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692366789; x=1692971589;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hcmJQTd7UNP5XiYb1sBnqy4rqkmZTlMQd83qoh50z00=;
        b=OjyuCIMF66DsvvRLQjJQ2NWszTbW0zPLCTbX2PFee2vvAlgSixTe5yT0kqRcr4J7MX
         yyIsioFwC0CP2IjA4sjyOL39aK5YCzUq2kajkrY6+KCEZvKpdWvhadk5v+LaAfprooBv
         7hbINzvVvuAtRzqToeAEeC0ASTPyfgWYBKQIPfECgNuE5WlpwUW5betZzFlxvuTaXetg
         AcuzMMNpqFdISvAjdyEm1zYjPgphUzUKoVDvDGk2WGtiL8Z98AOLyELFNWCeSfYgl/kT
         WLxq06LBYKqK7chRTy3GWrdDfMqKfWOptqaTWZT1ldMIVbF7pvR6lV7RAyTGD4aXmr++
         mYCA==
X-Gm-Message-State: AOJu0Yz+YRNpEz33zRHVL5SktOkMVE3eaxMf73cS/DG2f1NFMoNBLW4T
        9BgGAxfmYUMNqqObi22u5woTUmJv0l8=
X-Google-Smtp-Source: AGHT+IF6I79/vPORNFMW6F+ZxKSAuKsoetE7Y6ZYqr6kfgMkwTJWo8DLPimGms97rTsh2mrL8K02HNIK8Fw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:181d:b0:d74:58a4:8ba0 with SMTP id
 cf29-20020a056902181d00b00d7458a48ba0mr11454ybb.7.1692366788875; Fri, 18 Aug
 2023 06:53:08 -0700 (PDT)
Date:   Fri, 18 Aug 2023 06:53:06 -0700
In-Reply-To: <e4aa03cb-0f80-bd5f-f69e-39b636476f00@linux.intel.com>
Mime-Version: 1.0
References: <20230719144131.29052-1-binbin.wu@linux.intel.com>
 <ZN1M5RvuARP1YMfp@google.com> <6e990b88-1e28-9563-2c2f-0d5d52f9c7ca@linux.intel.com>
 <e4aa03cb-0f80-bd5f-f69e-39b636476f00@linux.intel.com>
Message-ID: <ZN93wp9lgmuJqYIA@google.com>
Subject: Re: [PATCH v10 0/9] Linear Address Masking (LAM) KVM Enabling
From:   Sean Christopherson <seanjc@google.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        David.Laight@aculab.com, robert.hu@linux.intel.com,
        guang.zeng@intel.com
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

On Fri, Aug 18, 2023, Binbin Wu wrote:
>=20
> On 8/17/2023 5:17 PM, Binbin Wu wrote:
> >=20
> > On 8/17/2023 6:25 AM, Sean Christopherson wrote:
> > > On Wed, Jul 19, 2023, Binbin Wu wrote:
> > > > Binbin Wu (7):
> > > > =C2=A0=C2=A0 KVM: x86/mmu: Use GENMASK_ULL() to define __PT_BASE_AD=
DR_MASK
> > > > =C2=A0=C2=A0 KVM: x86: Add & use kvm_vcpu_is_legal_cr3() to check C=
R3's legality
> > > > =C2=A0=C2=A0 KVM: x86: Use KVM-governed feature framework to track =
"LAM enabled"
> > > > =C2=A0=C2=A0 KVM: x86: Virtualize CR3.LAM_{U48,U57}
> > > > =C2=A0=C2=A0 KVM: x86: Introduce get_untagged_addr() in kvm_x86_ops=
 and
> > > > call it in
> > > > =C2=A0=C2=A0=C2=A0=C2=A0 emulator
> > > > =C2=A0=C2=A0 KVM: VMX: Implement and wire get_untagged_addr() for L=
AM
> > > > =C2=A0=C2=A0 KVM: x86: Untag address for vmexit handlers when LAM a=
pplicable
> > > >=20
> > > > Robert Hoo (2):
> > > > =C2=A0=C2=A0 KVM: x86: Virtualize CR4.LAM_SUP
> > > > =C2=A0=C2=A0 KVM: x86: Expose LAM feature to userspace VMM
> > > Looks good, just needs a bit of re-organination.=C2=A0 Same goes for =
the
> > > LASS series.
> > >=20
> > > For the next version, can you (or Zeng) send a single series for LAM
> > > and LASS?
> > > They're both pretty much ready to go, i.e. I don't expect one to
> > > hold up the other
> > > at this point, and posting a single series will reduce the
> > > probability of me
> > > screwing up a conflict resolution or missing a dependency when applyi=
ng.
> > >=20
> Hi Sean,
> Do you still prefer a single series for LAM and LASS=C2=A0 for the next v=
ersion
> when we don't need to rush for v6.6?

Yes, if it's not too much trouble on your end.  Since the two have overlapp=
ing
prep work and concepts, and both series are in good shape, my strong prefer=
ence
is to grab them at the same time.  I would much rather apply what you've te=
sted
and reduce the probability of messing up any conflicts.
