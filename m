Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE1F57B8E10
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 22:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244753AbjJDU3j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 16:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244701AbjJDU3h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 16:29:37 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4CCAD
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 13:29:32 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id 2adb3069b0e04-502f29ed596so1579e87.0
        for <kvm@vger.kernel.org>; Wed, 04 Oct 2023 13:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696451370; x=1697056170; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ULcbPeVXF1YZ+PSpdpBI4ln4bPTinWz7u+G6K/2zwK0=;
        b=26GqU3ytQmiEs5cmGlgk5+IGkzW5jTio9t5V3W2QwVWIL3wDelSHGnKAvus1APDTfw
         rv5CFTO7UDLd5umIndG7ATXGbKy/VVueysmZdjaOjfef/5smNCLUHJggzGNxjebg4vwE
         2mYNXv3/pZtaIkU6QGXyQxdhjgVZkN+tOToWrOUHXSje24+KmiSiG/uYhggr17l/rGrz
         z1gYOmW+qsB9/y6E80jc+HMu/W3mCDm4G58hTp2h3jdtPJc5W22Q+l2nU9/LU9fdw0bC
         4iNtnE42xCZoEtIHsT/JV8FTGM1tJaCKOfNnzdzSOhBz1OLQWicqM9YeKY6+sHJ7Q6BT
         EDlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696451370; x=1697056170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ULcbPeVXF1YZ+PSpdpBI4ln4bPTinWz7u+G6K/2zwK0=;
        b=GEXI4F3NX4GQnFwpN9NZS1HhiyFmXvjNjLBVsrBPrczffiXs7KgvMP/WuqY42JeOEB
         9iswM1mExigxTfRhADgBGW2YFOmkmsptgdrkD17UsB97eKIVSPHKXTcOKFobU7eY+ezi
         U1g13BJ26Y/uSWLzCPhlKDuGzygXehx0MqZE775oHzYpjbX26QCPXGIqeiCVQE+cE71R
         7OuIUrvvx4K/oaeHjVeKiA5T19dmpRE6UQWi+YI6bwORVyckeLnrUbhBlbnK0IIWc0ni
         XSbei2wLzW6ivj3V8/bMI3iO/Jn22wBYE3g17grD1csndTyKLAnRMiN5UDKE8YlOMvL6
         Iw5A==
X-Gm-Message-State: AOJu0YwRGf5sfZX2/Yemt/wdS3v1FaAePSwK10nQKQ6IlOgdzk8YdscZ
        8bzkOQEfSPfJi2Pj5Ii1vtjR59F5Ql3hCSDgF3Azog==
X-Google-Smtp-Source: AGHT+IHzJtM7k+kUTGyXAWVzPEzSaQ1kE5vqmOg+cGd45iBE1Lgxpx9c3I5fBCW0FMS138wNvOmmuyOL9idRGF7p4uk=
X-Received: by 2002:ac2:5142:0:b0:502:dc15:7fb with SMTP id
 q2-20020ac25142000000b00502dc1507fbmr100lfd.5.1696451369919; Wed, 04 Oct 2023
 13:29:29 -0700 (PDT)
MIME-Version: 1.0
References: <20231004002038.907778-1-jmattson@google.com> <01009a2a-929e-ce16-6f44-1d314e6bcba5@intel.com>
 <CALMp9eR+Qudg++J_dmY_SGbM_kr=GQcRRcjuUxtm9rfaC_qeXQ@mail.gmail.com> <20231004075836.GBZR0bLC/Y09sSSYWw@fat_crate.local>
In-Reply-To: <20231004075836.GBZR0bLC/Y09sSSYWw@fat_crate.local>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 4 Oct 2023 13:29:15 -0700
Message-ID: <CALMp9eQN9_OK6oE9tEz_DW4ZBwWEB_JJJdjKsQoLyh9tGWNfYw@mail.gmail.com>
Subject: Re: [PATCH] x86: KVM: Add feature flag for AMD's FsGsKernelGsBaseNonSerializing
To:     Borislav Petkov <bp@alien8.de>
Cc:     Dave Hansen <dave.hansen@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 4, 2023 at 12:59=E2=80=AFAM Borislav Petkov <bp@alien8.de> wrot=
e:
>
> On Tue, Oct 03, 2023 at 07:44:51PM -0700, Jim Mattson wrote:
> > The business of declaring breaking changes to the architectural
> > specification in a CPUID bit has never made much sense to me.
>
> How else should they be expressed then?
>
> In some flaky PDF which changes URLs whenever the new corporate CMS gets
> installed?
>
> Or we should do f/m/s matching which doesn't make any sense for VMs?
>
> When you think about it, CPUID is the best thing we have.
>
> > No one is likely to query CPUID.80000021H.EAX[bit 21] today, but if
> > someone does query the bit in the future, they can reasonably expect
> > that WRMSR({FS,GS,KERNELGS}_BASE) is a serializing operation whenever
> > this bit is clear. Therefore, any hypervisor that doesn't pass the bit
> > through is broken. Sadly, this also means that for a heterogenous
> > migration pool, the hypervisor must set this bit in the guest CPUID if
> > it is set on any host in the pool. Yes, that means that the legacy
> > behavior may sometimes be present in a VM that enumerates the CPUID
> > bit, but that's the best we can do.
>
> Yes, add this to your commit message.
>
> > I'm a little surprised at the pushback, TBH. Are you implying that
> > there is some advantage to *not* passing this bit through?
>
> We don't add stuff which is not worth adding. There has to be *at*
> *least* some justification for it.

Let me propose the following axiom as justification:

KVM_GET_SUPPORTED_CPUID must pass through any defeature bits that are
set on the host, unless KVM is prepared to emulate the missing
feature.

Here, a defeature bit is any CPUID bit where a value of '1' indicates
the absence of a feature.

> Thx.
>
> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette
