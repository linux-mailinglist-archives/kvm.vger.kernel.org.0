Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B59F8230F6F
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 18:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731451AbgG1Qd7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 12:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731191AbgG1Qd6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 12:33:58 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F00C061794
        for <kvm@vger.kernel.org>; Tue, 28 Jul 2020 09:33:57 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id s16so6608721ljc.8
        for <kvm@vger.kernel.org>; Tue, 28 Jul 2020 09:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yuxijuLHIOB0F9v49dQBc2O0af6WKNiJzGh1ZbKbHko=;
        b=qsskc5KL0O+PY0safIF+iwWyev/qr/QYPqK184NvB4tWeb1Qc4WElTrgsjF8wUJBde
         6MOlXLXFGN0WOGQ8uP/XgKzS68dmY/cP8bWCA/2t7/F5E/VFCrjFKUnzEuaCW7CIhKH0
         t04iiX06F00McgNMDboalxkDBmyOsGcCAQK3C5VF6zuol7T7wQNK6MpF/ox5qu+Qd1yK
         mcAGqt09zds5G55etToMx0hH8PwE3lTjZcG1kjHZBnxCe4hIsrIm5dpCOQ2yiAtuHqZC
         bm/zIzgpWWZQl0a8QB2YBhlSWvNgIoebiT7WFxWFD9ip4iSW4uotv0iK6ptBimzxaB8B
         kD7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yuxijuLHIOB0F9v49dQBc2O0af6WKNiJzGh1ZbKbHko=;
        b=YBRjBGUKKOuovG59cDZdwIzG1GPOgYBgI8TLKvLBFnIeANyPkE3VTUcpChOXA4G1bW
         UuUHaAKAfZ/XODlmVgmOocrJcgkH2g/E0lMttyk83oXGPOYFIAvm1gLMBsuHKQcd8Enk
         Cn5Twk7/uI9I2JheHkfGNH8cHb6yFP74zydoQACPrnpGxk823oecCEkr00hB5twy1W5S
         gN4i5E4XIBlvfppIAt09odrSKt0GmAsIjmfs7lSGfNLmvPRVj+d5aDUM3ZxhYj363kI4
         WnmLEX5XX3gZCT9skkWevwDAta9Mv89QiBryAdumH+ksCocSg2hszgelToIzTkO3XRT+
         xovg==
X-Gm-Message-State: AOAM533c4KM7DhR6hNovBH3e8FbxctI1Hsno47d6mZXA1nO8HYcPOPUM
        m4O3GIbFGkAwl8kupdToeggCJqj9e2WwuHCA2sSX+e1f
X-Google-Smtp-Source: ABdhPJxMv6WOP64yxWZJODcfz0QcbngiD7jQIfRiSyMAGdRtOUJr9z5zEVBqrGvazNCPGBspJIYC8iIZ26e5dNfAp7Y=
X-Received: by 2002:a05:651c:324:: with SMTP id b4mr12255329ljp.235.1595954035506;
 Tue, 28 Jul 2020 09:33:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200722032629.3687068-1-oupton@google.com>
In-Reply-To: <20200722032629.3687068-1-oupton@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Tue, 28 Jul 2020 09:33:43 -0700
Message-ID: <CAOQ_QsgeN4DCghH6ibb68C+P0ETr77s2s7Us+uxF6E6LFx62tw@mail.gmail.com>
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

On Tue, Jul 21, 2020 at 8:26 PM Oliver Upton <oupton@google.com> wrote:
>
> To date, VMMs have typically restored the guest's TSCs by value using
> the KVM_SET_MSRS ioctl for each vCPU. However, restoring the TSCs by
> value introduces some challenges with synchronization as the TSCs
> continue to tick throughout the restoration process. As such, KVM has
> some heuristics around TSC writes to infer whether or not the guest or
> host is attempting to synchronize the TSCs.
>
> Instead of guessing at the intentions of a VMM, it'd be better to
> provide an interface that allows for explicit synchronization of the
> guest's TSCs. To that end, this series introduces the
> KVM_{GET,SET}_TSC_OFFSET ioctls, yielding control of the TSC offset to
> userspace.
>
> v2 => v3:
>  - Mark kvm_write_tsc_offset() as static (whoops)
>
> v1 => v2:
>  - Added clarification to the documentation of KVM_SET_TSC_OFFSET to
>    indicate that it can be used instead of an IA32_TSC MSR restore
>    through KVM_SET_MSRS
>  - Fixed KVM_SET_TSC_OFFSET to participate in the existing TSC
>    synchronization heuristics, thereby enabling the KVM masterclock when
>    all vCPUs are in phase.
>
> Oliver Upton (4):
>   kvm: x86: refactor masterclock sync heuristics out of kvm_write_tsc
>   kvm: vmx: check tsc offsetting with nested_cpu_has()
>   selftests: kvm: use a helper function for reading cpuid
>   selftests: kvm: introduce tsc_offset_test
>
> Peter Hornyack (1):
>   kvm: x86: add KVM_{GET,SET}_TSC_OFFSET ioctls
>
>  Documentation/virt/kvm/api.rst                |  31 ++
>  arch/x86/include/asm/kvm_host.h               |   1 +
>  arch/x86/kvm/vmx/vmx.c                        |   2 +-
>  arch/x86/kvm/x86.c                            | 147 ++++---
>  include/uapi/linux/kvm.h                      |   5 +
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../testing/selftests/kvm/include/test_util.h |   3 +
>  .../selftests/kvm/include/x86_64/processor.h  |  15 +
>  .../selftests/kvm/include/x86_64/svm_util.h   |  10 +-
>  .../selftests/kvm/include/x86_64/vmx.h        |   9 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    |   1 +
>  tools/testing/selftests/kvm/lib/x86_64/vmx.c  |  11 +
>  .../selftests/kvm/x86_64/tsc_offset_test.c    | 362 ++++++++++++++++++
>  14 files changed, 550 insertions(+), 49 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/tsc_offset_test.c
>
> --
> 2.28.0.rc0.142.g3c755180ce-goog
>

Ping :)
