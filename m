Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FAAB688694
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 19:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232828AbjBBSec (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 13:34:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjBBSeO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 13:34:14 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA87790A0
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 10:33:29 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id g2so3356662ybk.8
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 10:33:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=M6HXg422ci4ijnK9d40AWAOs2pgOWeo5nlN+xSVQ2LU=;
        b=LzMBPMQoBsC76rsmtlthxOnyQllty6Qvf7uSSKu/DFeT2nd7nWjWYRKX4TgQ8AcqSt
         jUA43LR+YXdblBlTjys+iNLjJFzPkOW2RDRIYeXa9lzwG0yLhzvoPo/+5N8RUhiUJ6O8
         8gS6Mk6UFZvhriTgL3fH8t0Fod78eSuGBzDDU+R4HAOJl1BLztjzgRyPatLirwDCd9Kv
         qJ3mQBKb1AMQzo6KhdwbRwSvE8WXBbz5vs0QL8v9xrlbsTSQbOIigjPHb98qtKVLF4jI
         VeQpDzTYke9m4sOxfz/1QlBu1GUcAOX3aplWgn4qeaq7c7zkcwO5f0094fMTa2v/mqwR
         uIuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M6HXg422ci4ijnK9d40AWAOs2pgOWeo5nlN+xSVQ2LU=;
        b=4e7NGdjlMNGBTl1Y5mfktmolgOdVIrorLQvJA3XhrIIsfAPRBq8oLcuatsW89SjZ4c
         DCIoGzKZi08+TTKUZYYiRrwtXUpTXbxLQ4WemzNkgVS8nG5w2Dz7AADPS5IhlczhFRo3
         Vmlt2b6uUotD2HgrXOQ8Va/oxgOI7rQdxQgiCvmnGhycgzBXU1y71vFbVtbMuE5Lco3+
         nebhSJKGZ4+uVxKp7eal5wyGRVkwacvpDTGaJs/YVap4G8PFGgU98vCrVMdJd2tVkdtw
         UHdQGrUDurfDdnXYSKkGYHRu/YYSXM69W5w0cnVB5zVdOe5XnQvHSETcmlb4NkQW/BND
         zezQ==
X-Gm-Message-State: AO0yUKWOWZF5ldBcoifIdoGTey83KD0gq72odHOenvPsvb4Lst4Kniat
        j+FmAP8oz9sIxp3ZMeXTS+BcYko81MYEdeW0yiMOVA==
X-Google-Smtp-Source: AK7set/YulCJuKfuPHmvvQvnx3jtIp1d9R6Phgt78HqTprImWWlbXR94lrLGayq3YLJthygHt1EEDzu7JQLb6dsVubk=
X-Received: by 2002:a25:7313:0:b0:80b:e8b4:7fc with SMTP id
 o19-20020a257313000000b0080be8b407fcmr967839ybc.358.1675362736502; Thu, 02
 Feb 2023 10:32:16 -0800 (PST)
MIME-Version: 1.0
References: <20221212183720.4062037-1-vipinsh@google.com> <20221212183720.4062037-13-vipinsh@google.com>
 <Y9r0q9cuK/ifu+OW@google.com>
In-Reply-To: <Y9r0q9cuK/ifu+OW@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Thu, 2 Feb 2023 10:31:40 -0800
Message-ID: <CAHVum0fEmEAQSxozb1BTTy-d3UGrsvhjt8V5FXQPrX5wOYqpPQ@mail.gmail.com>
Subject: Re: [Patch v4 12/13] KVM: selftests: Make vCPU exit reason test
 assertion common.
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, dmatlack@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        m Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 1, 2023 at 3:24 PM Sean Christopherson <seanjc@google.com> wrote:
>
> +all the other KVM selftests maintainers and reviewers
>
> On Mon, Dec 12, 2022, Vipin Sharma wrote:
> > Make TEST_ASSERT_KVM_EXIT_REASON() macro and replace all exit reason
> > test assert statements with it.
> >
> > No functional changes intended.
> >
> > Suggested-by: David Matlack <dmatlack@google.com>
> > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > Reviewed-by: David Matlack <dmatlack@google.com>
> > ---
> >  .../testing/selftests/kvm/aarch64/psci_test.c |  4 +--
> >  .../testing/selftests/kvm/include/test_util.h | 10 ++++++++
> >  .../kvm/lib/s390x/diag318_test_handler.c      |  3 +--
> >  .../selftests/kvm/s390x/sync_regs_test.c      | 15 +++--------
> >  .../selftests/kvm/set_memory_region_test.c    |  6 +----
> >  tools/testing/selftests/kvm/x86_64/amx_test.c |  8 +-----
> >  .../kvm/x86_64/cr4_cpuid_sync_test.c          |  8 +-----
> >  .../testing/selftests/kvm/x86_64/debug_regs.c |  2 +-
> >  .../selftests/kvm/x86_64/flds_emulation.h     |  5 +---
> >  .../selftests/kvm/x86_64/hyperv_clock.c       |  7 +-----
> >  .../selftests/kvm/x86_64/hyperv_evmcs.c       |  8 +-----
> >  .../selftests/kvm/x86_64/hyperv_features.c    | 14 ++---------
> >  .../testing/selftests/kvm/x86_64/hyperv_ipi.c |  6 +----
> >  .../selftests/kvm/x86_64/hyperv_svm_test.c    |  7 +-----
> >  .../selftests/kvm/x86_64/hyperv_tlb_flush.c   | 14 ++---------
> >  .../selftests/kvm/x86_64/kvm_clock_test.c     |  5 +---
> >  .../selftests/kvm/x86_64/kvm_pv_test.c        |  5 +---
> >  .../selftests/kvm/x86_64/monitor_mwait_test.c |  9 +------
> >  .../kvm/x86_64/nested_exceptions_test.c       |  5 +---
> >  .../selftests/kvm/x86_64/platform_info_test.c | 14 +++--------
> >  .../kvm/x86_64/pmu_event_filter_test.c        |  6 +----
> >  tools/testing/selftests/kvm/x86_64/smm_test.c |  9 +------
> >  .../testing/selftests/kvm/x86_64/state_test.c |  8 +-----
> >  .../selftests/kvm/x86_64/svm_int_ctl_test.c   |  8 +-----
> >  .../kvm/x86_64/svm_nested_shutdown_test.c     |  7 +-----
> >  .../kvm/x86_64/svm_nested_soft_inject_test.c  |  6 +----
> >  .../selftests/kvm/x86_64/svm_vmcall_test.c    |  6 +----
> >  .../selftests/kvm/x86_64/sync_regs_test.c     | 25 ++++---------------
> >  .../kvm/x86_64/triple_fault_event_test.c      |  9 ++-----
> >  .../selftests/kvm/x86_64/tsc_scaling_sync.c   |  6 +----
> >  .../kvm/x86_64/ucna_injection_test.c          | 22 +++-------------
> >  .../selftests/kvm/x86_64/userspace_io_test.c  |  6 +----
> >  .../kvm/x86_64/userspace_msr_exit_test.c      | 22 +++-------------
> >  .../kvm/x86_64/vmx_apic_access_test.c         | 11 ++------
> >  .../kvm/x86_64/vmx_close_while_nested_test.c  |  5 +---
> >  .../selftests/kvm/x86_64/vmx_dirty_log_test.c |  7 +-----
> >  .../vmx_exception_with_invalid_guest_state.c  |  4 +--
> >  .../x86_64/vmx_invalid_nested_guest_state.c   |  4 +--
> >  .../kvm/x86_64/vmx_nested_tsc_scaling_test.c  |  6 +----
> >  .../kvm/x86_64/vmx_preemption_timer_test.c    |  8 +-----
> >  .../kvm/x86_64/vmx_tsc_adjust_test.c          |  6 +----
> >  .../selftests/kvm/x86_64/xapic_ipi_test.c     |  6 +----
> >  .../selftests/kvm/x86_64/xen_shinfo_test.c    |  7 +-----
> >  .../selftests/kvm/x86_64/xen_vmcall_test.c    |  5 +---
> >  44 files changed, 71 insertions(+), 293 deletions(-)
>
> I love the cleanup, but in the future, please don't squeeze KVM-wide changes in
> the middle of an otherwise arch-specific series unless it's absolutely necessary.
> I get why you added the macro before copy-pasting more code into a new test, but
> the unfortunate side effect is that complicates grabbing the entire series.
>

Make sense. So what is preferable:
1. Make the big cleanup identified during a series as the last patches
in that series?
2. Have two series and big cleanups rebased on top of the initial series?

Or, both 1 & 2 are acceptable depending on the cleanup?

> And incorporate ./scripts/get_maintainer.pl into your workflow, the other KVM
> selftests folks need to be in the loop for these types of changes.

My mistake. I will be careful next time.

>
> > diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
> > index 80d6416f3012..3f15f216d2a6 100644
> > --- a/tools/testing/selftests/kvm/include/test_util.h
> > +++ b/tools/testing/selftests/kvm/include/test_util.h
> > @@ -63,6 +63,16 @@ void test_assert(bool exp, const char *exp_str,
> >                   #a, #b, #a, (unsigned long) __a, #b, (unsigned long) __b); \
> >  } while (0)
> >
> > +#define TEST_ASSERT_KVM_EXIT_REASON(vcpu, expected_exit_reason)              \
> > +({                                                                   \
>
> Unless the macro needs to "return" a value, do-while(0) is generally preferred.

Good to know. I thought do{}while(0) was the old style and ({}) is the new one.

>
> > +     __u32 exit_reason = (vcpu)->run->exit_reason;                   \
> > +                                                                     \
> > +     TEST_ASSERT(exit_reason == (expected_exit_reason),              \
> > +                 "Unexpected exit reason: %u (%s)",                  \
>
> This "needs" to opportunistically enhance the message to spit out the expected
> reason, and to clarify that it's a KVM exit reason.  In the open coded form, the
> expected reason is _usually_ captured in the assertion, but that's not guaranteed,
> e.g. if it's not hardcoded.  But with the common code, the expected exit reason
> will generally get resolved into its literal, which isn't very human friendly.
>
> And even when it is provided, I find it annoying to have to search back a few
> lines to understand what failed.
>
> E.g. the new macro yields "x86_64/hyperv_evmcs.c:269: exit_reason == (2)".
>
> > +                 exit_reason,                                        \
> > +                 exit_reason_str(exit_reason));                      \
>
> No need to put these on separate lines.

Okay.

>
> How about this?
>
> #define TEST_ASSERT_KVM_EXIT_REASON(vcpu, expected)                     \
> do {                                                                    \
>         __u32 exit_reason = (vcpu)->run->exit_reason;                   \
>                                                                         \
>         TEST_ASSERT(exit_reason == (expected),                          \
>                     "Wanted KVM exit reason: %u (%s), got: %u (%s)",    \
>                     expected, exit_reason_str(expected),                \
>                     exit_reason, exit_reason_str(exit_reason));         \
> } while (0)
>
> which yields errors like:
>
> ==== Test Assertion Failure ====
>   x86_64/hyperv_extended_hypercalls.c:71: exit_reason == (2)
>   pid=108104 tid=108104 errno=0 - Success
>      1  0x0000000000401793: main at hyperv_extended_hypercalls.c:71
>      2  0x00000000004148b3: __libc_start_call_main at libc-start.o:?
>      3  0x0000000000415eff: __libc_start_main_impl at ??:?
>      4  0x00000000004018f0: _start at ??:?
>   Wanted KVM exit reason: 2 (IO), got: 27 (HYPERV)
>

I like this, I will make this change.

> On a related topic, exit_reason_str() is a bit stale and also annoying to update.
> Can you fold in the below when you send v2 of this patch?  And then if you're
> feeling ambititous, add another patch to update the array?
>

Yes and Yes.

> --
> From: Sean Christopherson <seanjc@google.com>
> Date: Wed, 1 Feb 2023 23:17:19 +0000
> Subject: [PATCH] KVM: selftests: Add macro to generate KVM exit reason strings
>
> Add and use a macro to generate the KVM exit reason strings array instead
> of relying on developers to correctly copy+paste+edit each string.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c | 55 ++++++++++++----------
>  1 file changed, 29 insertions(+), 26 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index f25b3e9b5a07..b3682b25eedf 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1815,38 +1815,41 @@ void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
>                 vcpu_dump(stream, vcpu, indent + 2);
>  }
>
> +#define KVM_EXIT_STRING(x) {KVM_EXIT_##x, #x}
> +
>  /* Known KVM exit reasons */
>  static struct exit_reason {
>         unsigned int reason;
>         const char *name;
>  } exit_reasons_known[] = {
> -       {KVM_EXIT_UNKNOWN, "UNKNOWN"},
> -       {KVM_EXIT_EXCEPTION, "EXCEPTION"},
> -       {KVM_EXIT_IO, "IO"},
> -       {KVM_EXIT_HYPERCALL, "HYPERCALL"},
> -       {KVM_EXIT_DEBUG, "DEBUG"},
> -       {KVM_EXIT_HLT, "HLT"},
> -       {KVM_EXIT_MMIO, "MMIO"},
> -       {KVM_EXIT_IRQ_WINDOW_OPEN, "IRQ_WINDOW_OPEN"},
> -       {KVM_EXIT_SHUTDOWN, "SHUTDOWN"},
> -       {KVM_EXIT_FAIL_ENTRY, "FAIL_ENTRY"},
> -       {KVM_EXIT_INTR, "INTR"},
> -       {KVM_EXIT_SET_TPR, "SET_TPR"},
> -       {KVM_EXIT_TPR_ACCESS, "TPR_ACCESS"},
> -       {KVM_EXIT_S390_SIEIC, "S390_SIEIC"},
> -       {KVM_EXIT_S390_RESET, "S390_RESET"},
> -       {KVM_EXIT_DCR, "DCR"},
> -       {KVM_EXIT_NMI, "NMI"},
> -       {KVM_EXIT_INTERNAL_ERROR, "INTERNAL_ERROR"},
> -       {KVM_EXIT_OSI, "OSI"},
> -       {KVM_EXIT_PAPR_HCALL, "PAPR_HCALL"},
> -       {KVM_EXIT_DIRTY_RING_FULL, "DIRTY_RING_FULL"},
> -       {KVM_EXIT_X86_RDMSR, "RDMSR"},
> -       {KVM_EXIT_X86_WRMSR, "WRMSR"},
> -       {KVM_EXIT_XEN, "XEN"},
> -       {KVM_EXIT_HYPERV, "HYPERV"},
> +       KVM_EXIT_STRING(UNKNOWN),
> +       KVM_EXIT_STRING(EXCEPTION),
> +       KVM_EXIT_STRING(IO),
> +       KVM_EXIT_STRING(HYPERCALL),
> +       KVM_EXIT_STRING(DEBUG),
> +       KVM_EXIT_STRING(HLT),
> +       KVM_EXIT_STRING(MMIO),
> +       KVM_EXIT_STRING(IRQ_WINDOW_OPEN),
> +       KVM_EXIT_STRING(SHUTDOWN),
> +       KVM_EXIT_STRING(FAIL_ENTRY),
> +       KVM_EXIT_STRING(INTR),
> +       KVM_EXIT_STRING(SET_TPR),
> +       KVM_EXIT_STRING(TPR_ACCESS),
> +       KVM_EXIT_STRING(S390_SIEIC),
> +       KVM_EXIT_STRING(S390_RESET),
> +       KVM_EXIT_STRING(DCR),
> +       KVM_EXIT_STRING(NMI),
> +       KVM_EXIT_STRING(INTERNAL_ERROR),
> +       KVM_EXIT_STRING(OSI),
> +       KVM_EXIT_STRING(PAPR_HCALL),
> +       KVM_EXIT_STRING(DIRTY_RING_FULL),
> +       KVM_EXIT_STRING(X86_RDMSR),
> +       KVM_EXIT_STRING(X86_WRMSR),
> +       KVM_EXIT_STRING(XEN),
> +       KVM_EXIT_STRING(HYPERV),
> +
>  #ifdef KVM_EXIT_MEMORY_NOT_PRESENT
> -       {KVM_EXIT_MEMORY_NOT_PRESENT, "MEMORY_NOT_PRESENT"},
> +       KVM_EXIT_STRING(MEMORY_NOT_PRESENT),
>  #endif
>  };
>
>
> base-commit: b20015517a2c6b45bafa09aee45d1698f91428d6
> --
>
