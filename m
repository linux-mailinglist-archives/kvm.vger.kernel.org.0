Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1642425A183
	for <lists+kvm@lfdr.de>; Wed,  2 Sep 2020 00:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728697AbgIAWc0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 18:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbgIAWcW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 18:32:22 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78E1C061244
        for <kvm@vger.kernel.org>; Tue,  1 Sep 2020 15:32:21 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id q21so3026834edv.1
        for <kvm@vger.kernel.org>; Tue, 01 Sep 2020 15:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y8Kqs1FhyFxYDeoHU6Zu55afEGALtbuNFoge6VETFuE=;
        b=aKWdEI0nW4hHs1YnMgp3+Hrkr++hc9rpCLsA/xs2TXIbOrgye7EGHDWiTjH5JePfL3
         Wcr9IQwQcPco2v37BDFuyQ+GOA/wM4GTM6Vzi+y6aiUXO0unFhYlQzdRDEH/A2niaF2h
         UxUo9uWDPQwYdCroC7inEuxXANNyMfw2bj3hPPRXHJ/doLXiR/833fmPUMAenEGWXicA
         9hlvZcn4JQYBvDFeW5le1YTyjQTnRO9LR/tfK1AVeRZB3Uw6D9tiQIowJVWgmGcERZot
         Da7c85cogEK0mEyM2zWWAcYk1G0nIwYmbJQdKXTjGHZeCS/2+u1uHtdGcIbjyOajxnlI
         ZOVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y8Kqs1FhyFxYDeoHU6Zu55afEGALtbuNFoge6VETFuE=;
        b=asVF+s+0W/r5yuPgy4zbSoWTsh7G8MSISqj/1fIdFj8PBgbZg5IJJrR7GdSPB7gywi
         oZyBYKCYcwSP/Qo38M04JVrG4OPCB4fO9zC7faMLpR3f927PeIEVHA15DdtyFGGZgzBZ
         QctPqcKQ2zdry/jrg+1NUsdnMsZAoxTebJxFYvK2VMlnN4DLkxOZX7AHTQwsDY7Rhrp3
         mIDapqjhB7tHKyHk7CQWBUBq4yWwMr/NOgQsG8F1bmbcmLSphEnBFTM7N57sjP3TQr04
         dWyyw0BSIauqyhSU8qkhL0D80+Nti0aLzpQHlERywUl3H3btBC61MBJ2t3yQPUNZsmZt
         e9wQ==
X-Gm-Message-State: AOAM532iAyCD+4McCrECdl1N3qqjWWrxTLi8wUmfNo2BeorkkfE9Ahm4
        33pgrt2pYwKkL1AwMde0xJ0JOWwqlyyceskBQCXrAA==
X-Google-Smtp-Source: ABdhPJwGK6px0iz7odPBxIwt3lB6PpV3BahZ5eaSFMIkyPmJUfJWFC7KPLJSWONYtfTRX7nU4YUqQw5s0PYw1IX86rQ=
X-Received: by 2002:aa7:d68c:: with SMTP id d12mr3939682edr.274.1598999540116;
 Tue, 01 Sep 2020 15:32:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200901201517.29086-1-graf@amazon.com>
In-Reply-To: <20200901201517.29086-1-graf@amazon.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Tue, 1 Sep 2020 15:32:08 -0700
Message-ID: <CAAAPnDFChjpK=nF=CGhLM9JJHcmW-6STJ5Am41CBjVei9-s4ow@mail.gmail.com>
Subject: Re: [PATCH v6 0/7] Allow user space to restrict and augment MSR emulation
To:     Alexander Graf <graf@amazon.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        KarimAllah Raslan <karahmed@amazon.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        kvm list <kvm@vger.kernel.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 1, 2020 at 1:15 PM Alexander Graf <graf@amazon.com> wrote:
>
> While tying to add support for the MSR_CORE_THREAD_COUNT MSR in KVM,
> I realized that we were still in a world where user space has no control
> over what happens with MSR emulation in KVM.
>
> That is bad for multiple reasons. In my case, I wanted to emulate the
> MSR in user space, because it's a CPU specific register that does not
> exist on older CPUs and that really only contains informational data that
> is on the package level, so it's a natural fit for user space to provide
> it.
>
> However, it is also bad on a platform compatibility level. Currrently,
> KVM has no way to expose different MSRs based on the selected target CPU
> type.
>
> This patch set introduces a way for user space to indicate to KVM which
> MSRs should be handled in kernel space. With that, we can solve part of
> the platform compatibility story. Or at least we can not handle AMD specific
> MSRs on an Intel platform and vice versa.
>
> In addition, it introduces a way for user space to get into the loop
> when an MSR access would generate a #GP fault, such as when KVM finds an
> MSR that is not handled by the in-kernel MSR emulation or when the guest
> is trying to access reserved registers.
>
> In combination with filtering, user space trapping allows us to emulate
> arbitrary MSRs in user space, paving the way for target CPU specific MSR
> implementations from user space.
>
> v1 -> v2:
>
>   - s/ETRAP_TO_USER_SPACE/ENOENT/g
>   - deflect all #GP injection events to user space, not just unknown MSRs.
>     That was we can also deflect allowlist errors later
>   - fix emulator case
>   - new patch: KVM: x86: Introduce allow list for MSR emulation
>   - new patch: KVM: selftests: Add test for user space MSR handling
>
> v2 -> v3:
>
>   - return r if r == X86EMUL_IO_NEEDED
>   - s/KVM_EXIT_RDMSR/KVM_EXIT_X86_RDMSR/g
>   - s/KVM_EXIT_WRMSR/KVM_EXIT_X86_WRMSR/g
>   - Use complete_userspace_io logic instead of reply field
>   - Simplify trapping code
>   - document flags for KVM_X86_ADD_MSR_ALLOWLIST
>   - generalize exit path, always unlock when returning
>   - s/KVM_CAP_ADD_MSR_ALLOWLIST/KVM_CAP_X86_MSR_ALLOWLIST/g
>   - Add KVM_X86_CLEAR_MSR_ALLOWLIST
>   - Add test to clear whitelist
>   - Adjust to reply-less API
>   - Fix asserts
>   - Actually trap on MSR_IA32_POWER_CTL writes
>
> v3 -> v4:
>
>   - Mention exit reasons in re-enter mandatory section of API documentation
>   - Clear padding bytes
>   - Generalize get/set deflect functions
>   - Remove redundant pending_user_msr field
>   - lock allow check and clearing
>   - free bitmaps on clear
>
> v4 -> v5:
>
>   - use srcu
>
> v5 -> v6:
>
>   - Switch from allow list to filtering API with explicit fallback option
>   - Support and test passthrough MSR filtering
>   - Check for filter exit reason
>   - Add .gitignore
>   - send filter change notification
>   - change to atomic set_msr_filter ioctl with fallback flag
>   - use EPERM for filter blocks
>   - add bit for MSR user space deflection
>   - check for overflow of BITS_TO_LONGS (thanks Dan Carpenter!)
>   - s/int i;/u32 i;/
>   - remove overlap check
>   - Introduce exit reason mask to allow for future expansion and filtering
>   - s/emul_to_vcpu(ctxt)/vcpu/
>   - imported patch: KVM: x86: Prepare MSR bitmaps for userspace tracked MSRs
>   - new patch: KVM: x86: Add infrastructure for MSR filtering
>   - new patch: KVM: x86: SVM: Prevent MSR passthrough when MSR access is denied
>   - new patch: KVM: x86: VMX: Prevent MSR passthrough when MSR access is denied
>
> Aaron Lewis (1):
>   KVM: x86: Prepare MSR bitmaps for userspace tracked MSRs
>
> Alexander Graf (6):
>   KVM: x86: Deflect unknown MSR accesses to user space
>   KVM: x86: Add infrastructure for MSR filtering
>   KVM: x86: SVM: Prevent MSR passthrough when MSR access is denied
>   KVM: x86: VMX: Prevent MSR passthrough when MSR access is denied
>   KVM: x86: Introduce MSR filtering
>   KVM: selftests: Add test for user space MSR handling
>
>  Documentation/virt/kvm/api.rst                | 176 +++++++++-
>  arch/x86/include/asm/kvm_host.h               |  18 ++
>  arch/x86/include/uapi/asm/kvm.h               |  19 ++
>  arch/x86/kvm/emulate.c                        |  18 +-
>  arch/x86/kvm/svm/svm.c                        | 122 +++++--
>  arch/x86/kvm/svm/svm.h                        |   7 +
>  arch/x86/kvm/vmx/nested.c                     |   2 +-
>  arch/x86/kvm/vmx/vmx.c                        | 303 ++++++++++++------
>  arch/x86/kvm/vmx/vmx.h                        |   9 +-
>  arch/x86/kvm/x86.c                            | 267 ++++++++++++++-
>  arch/x86/kvm/x86.h                            |   1 +
>  include/trace/events/kvm.h                    |   2 +-
>  include/uapi/linux/kvm.h                      |  17 +
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/x86_64/user_msr_test.c      | 224 +++++++++++++
>  16 files changed, 1055 insertions(+), 132 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/user_msr_test.c
>
> --
> 2.17.1
>
>
>
>
> Amazon Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> Sitz: Berlin
> Ust-ID: DE 289 237 879
>
>
>

Hi Alex,

I'm only seeing 4 commits.  Are you planning on sending the remaining 3?

Thanks,
Aaron
