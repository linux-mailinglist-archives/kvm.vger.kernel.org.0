Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E224216240
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 01:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgGFX0b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 19:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgGFX0a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 19:26:30 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 971D4C061755
        for <kvm@vger.kernel.org>; Mon,  6 Jul 2020 16:26:30 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id r12so27220219ilh.4
        for <kvm@vger.kernel.org>; Mon, 06 Jul 2020 16:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pKPWHJBxnfYVFfiSt6IAtpeBP5q3hqa9XDCGu7gSuaE=;
        b=gNyZsNZj5tiwq6fyTkcI1bHnWVM+5FjB2m/8ITKdLoR/1c0ramwqJyIDG3vFBXivcm
         8t/y9nw9eDMazCM2NcAs4kqFyQEpcVsfcbJyRPE0IDbB/Mf9umfprulLebCdG64AqLHv
         LrCm278+QNaYRAdSOXhK1WTTRkDFNwwdwRaDf1aqKvWx/T1GlNWf3wTRBQTfpqLQ5QYR
         RRoZqNmVY15L+SgRLBGES8QBtnIRkxe1ALPnKfd4p8+UzYjYEnvw4ftaU+bcDM3Jc8Nw
         6vNoVySewSBNamxJQIQ8Y58GPqdbdTi38/gRIBs0y0qJt34uMwt4AwChk2fu2eih1sYZ
         7zeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pKPWHJBxnfYVFfiSt6IAtpeBP5q3hqa9XDCGu7gSuaE=;
        b=JiiG3GeNG8AWSJcRRBHdFIyYvr3ZZY0bh5/quJBS1LImJ7dCeJjNMMSkTozUyYbdez
         AX/WHd0GGfwOTVrpTljlfF9C8tQEqWoBBEYzFOI5YlfAQ4SZJ34Gjp8CUHFMl42Mmv5l
         vyQE80F50p0hf/fb14iBk8LFA6csJrX3bBsAkTgJExQxWitrD6nPHXQT/6dacCofW3BD
         ouh0S7w8K7h728S3gNxuMfD9+fY0sWUATK0vgTMrLhflB7ky2/VQc8LvKwg+qa1EHYEw
         PHhP82xGGwtuxUhV+4LKh7Fb48/zq2f9+XSHwl9MFSk22FeZ/PkZg6+8Uw/f8dPWJ883
         2Rvg==
X-Gm-Message-State: AOAM531vu0dcD+h3xnR3/iMHSpXoluMM1DtAsXFa3dA3WGdUeC5BoAVw
        rgB3StO2P+pP2aDjjR/0X7NV3ALg77ebT4Pw/kySfdwU
X-Google-Smtp-Source: ABdhPJzpWOoqKP7PWOl7GUOvjxzF9K988L6oix5Rl56b3+GGdwUg3bdIYmKL8E9MQVH0s+jh/f0ZUEGIV5V/DQqJ5Bc=
X-Received: by 2002:a92:aac8:: with SMTP id p69mr33880879ill.26.1594077989648;
 Mon, 06 Jul 2020 16:26:29 -0700 (PDT)
MIME-Version: 1.0
References: <DAFEA995-CFBA-4466-989B-D63466815AB1@gmail.com>
 <f297ebf8-15b8-57d3-4c56-fdf3f5d16b9d@redhat.com> <2B43FBC4-D265-4005-8FBA-870BDC627231@gmail.com>
In-Reply-To: <2B43FBC4-D265-4005-8FBA-870BDC627231@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 6 Jul 2020 16:26:18 -0700
Message-ID: <CALMp9eTDCDNctpso23uv+gM0QZUEBzMw47-M9JfNaG79fusa2A@mail.gmail.com>
Subject: Re: Question regarding nested_svm_inject_npf_exit()
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jul 5, 2020 at 7:12 PM Nadav Amit <nadav.amit@gmail.com> wrote:
>
> > On Jul 4, 2020, at 11:38 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 04/07/20 02:00, Nadav Amit wrote:
> >> Hello Paolo,
> >>
> >> I encountered an issue while running some svm tests. Apparently, the t=
ests
> >> =E2=80=9Cnpt_rw_pfwalk=E2=80=9D and =E2=80=9Cnpt_rsv_pfwalk=E2=80=9D e=
xpect the present bit to be clear.
> >>
> >> KVM indeed clears this bit in nested_svm_inject_npf_exit():
> >>
> >>       /*
> >>        * The present bit is always zero for page structure faults on r=
eal
> >>        * hardware.
> >>        */
> >>       if (svm->vmcb->control.exit_info_1 & (2ULL << 32))
> >>               svm->vmcb->control.exit_info_1 &=3D ~1;
> >>
> >>
> >> I could not find documentation of this behavior. Unfortunately, I do n=
ot
> >> have a bare-metal AMD machine to test the behavior (and some enabling =
of
> >> kvm-unit-tests/svm is required, e.g. this test does not run with more =
than
> >> 4GB of memory).
> >>
> >> Are you sure that this is the way AMD machines behave?
> >
> > No, I'm not.  The code was added when NPF was changed to synthesize
> > EXITINFO1, instead of simply propagating L0's EXITINFO1 into L1 (see
> > commit 5e3525195196, "KVM: nSVM: propagate the NPF EXITINFO to the
> > guest", 2014-09-03).  With six more years of understanding of KVM, the
> > lack of a present bit might well have been a consequence of how the MMU
> > works.
>
> Thanks. I ran =E2=80=98git blame=E2=80=99 before asking you, and that is =
the reason I
> assumed you would know best... ;-)
>
> > One of these days I'd like to run the SVM tests under QEMU without KVM.
> > It would probably find bugs in both.
>
> Well, I think we can agree that bare-metal is a better reference than
> another emulator for the matter. Even without running the tests on
> bare-metal, it is easy to dump EXITINFO1 on the nested page-fault. I will
> try to find a bare-metal machine.
>
> Anyhow, I would appreciate if anyone from AMD would tell whether any resu=
lt
> should be considered architectural.

I'd be happy to test on bare metal, but I'm still waiting for
instructions that a script kiddie (with read-only console access) can
follow.
