Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBBCE7D0B33
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 11:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376593AbjJTJLy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 05:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376523AbjJTJLx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 05:11:53 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324C3D49;
        Fri, 20 Oct 2023 02:11:51 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id 4fb4d7f45d1cf-53e08b60febso812504a12.1;
        Fri, 20 Oct 2023 02:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697793109; x=1698397909; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X/i6Fw+r194GHmzLf5s0/R2GunByWxbzISKNUr2Ewbs=;
        b=WK273gnNBgQqtxS19+jYkmOUl/PUmlEIEavgAfKHtTxfPBGa1PIwsFZaaR+CkE1VAJ
         T6NUdNNx3tHeO3ejL/cFtG5yRgJOeO/+Gqcy65AyL+D8LVgkFoq7ocDNsu1f2mynPjFR
         B6GMy3EAOU4r5IXNC4OsMi1p11u8Ta41NMSbIvJVh4APkrTnh2mqWb4UWvwycH6B4ndx
         wBK2o/UG03KGD2SdIe2M4j5MHXEC2EyZ4sQFrdz8ZUXIZ2l9oxEzACss2xEGweiVPH+i
         W6EcEoE66mQVVXWA3pc/YzPxSafac/hcW58qM7lvc48s+TLXnsQWVjmAjZiAcT4Jm3Ga
         PdDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697793109; x=1698397909;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X/i6Fw+r194GHmzLf5s0/R2GunByWxbzISKNUr2Ewbs=;
        b=NRPrTHhXPaTtly2Zb1pLPdNyrs60dZwqkHWCCqyTLg9N8qzb2O8lfikAOgChEoo6ix
         zyANZhI6pOZpriBYdtLsMuwi99d/j8tFQ91RppsCKVBEZNLTtRThk62UJHRLOVhaaUgC
         opL6dXLV94PBFIBTqYhGpTUS8idrpHy6KmpefEmC/9IUh+8Uv+dbROWZmji9glL3e2tM
         oMLEWw0HRWUkgGGVRSkZQseMfb5lakrqYBUrouDfBMIiLlSGdiqp7y0+oOdsKn8Zv4SD
         MYrilo4981faaoQ5hy9LFE33mZMkuiqsGe7b80YNZ2p6nMwNrYsjfcYJJIas4AGLq7N9
         8dAw==
X-Gm-Message-State: AOJu0YyNtFpxQ0wbNtSvDtq/3XTEpk+8Z9gYwyDTmMKlkdnmLZXn30NN
        xqKikEIgeI/Xiyad4xfV2TbtTZIL44uvzVfgbd4=
X-Google-Smtp-Source: AGHT+IE8NvcGYuTH2X4TAtkNajqUfVispERe7ssyHACJl3CPrCBjy+Mr7xKL/Px/u1PKsPdLHsoLIX397B80GJJ4fXc=
X-Received: by 2002:a50:aad2:0:b0:525:6c74:5e58 with SMTP id
 r18-20020a50aad2000000b005256c745e58mr1002625edc.23.1697793109383; Fri, 20
 Oct 2023 02:11:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230911114347.85882-1-cloudliang@tencent.com> <ZTHJvQm-nDNkvldM@google.com>
In-Reply-To: <ZTHJvQm-nDNkvldM@google.com>
From:   Jinrong Liang <ljr.kernel@gmail.com>
Date:   Fri, 20 Oct 2023 17:11:37 +0800
Message-ID: <CAFg_LQVsXjcnpnDFnP1rrypXD4N0DD3kYq_vxXK8SRzGjEjA1A@mail.gmail.com>
Subject: Re: [PATCH v4 0/9] KVM: selftests: Test the consistency of the PMU's
 CPUID and its features
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Like Xu <likexu@tencent.com>,
        David Matlack <dmatlack@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> =E4=BA=8E2023=E5=B9=B410=E6=9C=8820=
=E6=97=A5=E5=91=A8=E4=BA=94 08:28=E5=86=99=E9=81=93=EF=BC=9A
>
> On Mon, Sep 11, 2023, Jinrong Liang wrote:
> > Jinrong Liang (9):
> >   KVM: selftests: Add vcpu_set_cpuid_property() to set properties
> >   KVM: selftests: Extend this_pmu_has() and kvm_pmu_has() to check arch
> >     events
> >   KVM: selftests: Add pmu.h for PMU events and common masks
> >   KVM: selftests: Test Intel PMU architectural events on gp counters
> >   KVM: selftests: Test Intel PMU architectural events on fixed counters
> >   KVM: selftests: Test consistency of CPUID with num of gp counters
> >   KVM: selftests: Test consistency of CPUID with num of fixed counters
> >   KVM: selftests: Test Intel supported fixed counters bit mask
> >   KVM: selftests: Test consistency of PMU MSRs with Intel PMU version
>
> I've pushed a modified version to
>
>   https://github.com/sean-jc/linux/branches x86/pmu_counter_tests
>
> which also has fixes for KVM's funky handling of fixed counters.  I'll wa=
it for
> you to respond, but will tentatively plan on posting the above branch as =
v5
> some time next week.

I truly appreciate your time and effort in reviewing my patches and
making the necessary modifications. I've carefully examined the
updated code in the branch you kindly provided:

https://github.com/sean-jc/linux/branches x86/pmu_counter_tests

I completely agree with the changes you made. Please feel free to post
the modified branch as v5 next week. I will add AMD counters related
selftests after this patch set is merged.

Thank you once again for your time and guidance.
