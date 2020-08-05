Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B48D323D05C
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 21:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbgHETrm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 15:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728393AbgHERAH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 13:00:07 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F11CC001FD9
        for <kvm@vger.kernel.org>; Wed,  5 Aug 2020 09:07:02 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id h19so48321334ljg.13
        for <kvm@vger.kernel.org>; Wed, 05 Aug 2020 09:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n0oirlzv8CSElmbedgdT8ng988ArvzupJ4QdhwzcCys=;
        b=uWXDItoJBXfGvimVjOTNjntF+41kfCYTISDyr+COBThDYjpOAVEug/G+WcmO1wP6vv
         cfA+k5+cZWLcATthyjY3wR35BbRIVa3oEf6t5qUT4SWq4/PKv4YX3WeOwhd00VlZnRMP
         42OvGPM4Z/ifYe7pW/P8iQ9gIicIw+DCZDLiaWF07Serg4P8/0b22t81jLaiZndwFCbP
         Z/zWs68a+VMXzm7MutUA3sz3oFjmqrbBUSOJnc7XCSaJibfRx7ejh+WQoZ8hOyergMPB
         650VdXOdBDfkH477pz7vF+PXnpDQAtjrnzM39a1TAsP0e2s2DCxNR9SCGx3p9kIbvXrY
         i2LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n0oirlzv8CSElmbedgdT8ng988ArvzupJ4QdhwzcCys=;
        b=eahUgEZL9cqq1n1hV5FdN2ubfztCVYTV/oPtRMXEiO5Fh0Jp1M71nQkoPrvk3toru9
         GpZ77hQ3gmzOdotNtMeKPtgk3peOB4/z5muqx92/lvHSrZLgIgLiUWztYbdSNe5Vf0Vr
         N+kdALLNEarOph1FErIpUtR7h9KVMRTnzlE8ATj5y1Fsqq0rvDMelfDSffgeucrGSHyf
         jeEtsUIVjaEOR44ZrhvrUrRv9CtysRkQEmRZEEQYlvU9DdHdxDxYkZSZWptu4lU85gYT
         8zoE6AZKD5n0Xp6DGlXwyx/+MpHdJfsvWg4QYECAE6HGrRBrNpmakguvIPwwsun6Ei7Z
         ALbw==
X-Gm-Message-State: AOAM530hlf5ZXd0aHgJnSmm8jsyuwBQ2jxfmep9mO0dlcyjuQB25sgKD
        A0wrqt/31vbl9O4xSQvuxHD4Qq4Lu8PoHCa47rsuE8xZ
X-Google-Smtp-Source: ABdhPJwKxwdSLKhlKkCvebZnf1/Zjm1qwgx7SQ8MsmVusUXcPygUYBXfHPW9sAZskvJJ9A86pa/GW+EO253tJSgWqWM=
X-Received: by 2002:a2e:90e:: with SMTP id 14mr1844954ljj.293.1596643620309;
 Wed, 05 Aug 2020 09:07:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200722032629.3687068-1-oupton@google.com> <CAOQ_QsgeN4DCghH6ibb68C+P0ETr77s2s7Us+uxF6E6LFx62tw@mail.gmail.com>
In-Reply-To: <CAOQ_QsgeN4DCghH6ibb68C+P0ETr77s2s7Us+uxF6E6LFx62tw@mail.gmail.com>
From:   Oliver Upton <oupton@google.com>
Date:   Wed, 5 Aug 2020 11:06:50 -0500
Message-ID: <CAOQ_QshUE_OQmAuWd6SzdfXvn7Y6SVukcC1669Re0TRGCoeEgg@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] KVM_{GET,SET}_TSC_OFFSET ioctls
To:     kvm list <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Hornyack <peterhornyack@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 28, 2020 at 11:33 AM Oliver Upton <oupton@google.com> wrote:
>
> On Tue, Jul 21, 2020 at 8:26 PM Oliver Upton <oupton@google.com> wrote:
> >
> > To date, VMMs have typically restored the guest's TSCs by value using
> > the KVM_SET_MSRS ioctl for each vCPU. However, restoring the TSCs by
> > value introduces some challenges with synchronization as the TSCs
> > continue to tick throughout the restoration process. As such, KVM has
> > some heuristics around TSC writes to infer whether or not the guest or
> > host is attempting to synchronize the TSCs.
> >
> > Instead of guessing at the intentions of a VMM, it'd be better to
> > provide an interface that allows for explicit synchronization of the
> > guest's TSCs. To that end, this series introduces the
> > KVM_{GET,SET}_TSC_OFFSET ioctls, yielding control of the TSC offset to
> > userspace.
> >
> > v2 => v3:
> >  - Mark kvm_write_tsc_offset() as static (whoops)
> >
> > v1 => v2:
> >  - Added clarification to the documentation of KVM_SET_TSC_OFFSET to
> >    indicate that it can be used instead of an IA32_TSC MSR restore
> >    through KVM_SET_MSRS
> >  - Fixed KVM_SET_TSC_OFFSET to participate in the existing TSC
> >    synchronization heuristics, thereby enabling the KVM masterclock when
> >    all vCPUs are in phase.
> >
> > Oliver Upton (4):
> >   kvm: x86: refactor masterclock sync heuristics out of kvm_write_tsc
> >   kvm: vmx: check tsc offsetting with nested_cpu_has()
> >   selftests: kvm: use a helper function for reading cpuid
> >   selftests: kvm: introduce tsc_offset_test
> >
> > Peter Hornyack (1):
> >   kvm: x86: add KVM_{GET,SET}_TSC_OFFSET ioctls
> >
> >  Documentation/virt/kvm/api.rst                |  31 ++
> >  arch/x86/include/asm/kvm_host.h               |   1 +
> >  arch/x86/kvm/vmx/vmx.c                        |   2 +-
> >  arch/x86/kvm/x86.c                            | 147 ++++---
> >  include/uapi/linux/kvm.h                      |   5 +
> >  tools/testing/selftests/kvm/.gitignore        |   1 +
> >  tools/testing/selftests/kvm/Makefile          |   1 +
> >  .../testing/selftests/kvm/include/test_util.h |   3 +
> >  .../selftests/kvm/include/x86_64/processor.h  |  15 +
> >  .../selftests/kvm/include/x86_64/svm_util.h   |  10 +-
> >  .../selftests/kvm/include/x86_64/vmx.h        |   9 +
> >  tools/testing/selftests/kvm/lib/kvm_util.c    |   1 +
> >  tools/testing/selftests/kvm/lib/x86_64/vmx.c  |  11 +
> >  .../selftests/kvm/x86_64/tsc_offset_test.c    | 362 ++++++++++++++++++
> >  14 files changed, 550 insertions(+), 49 deletions(-)
> >  create mode 100644 tools/testing/selftests/kvm/x86_64/tsc_offset_test.c
> >
> > --
> > 2.28.0.rc0.142.g3c755180ce-goog
> >
>
> Ping :)

Ping
