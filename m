Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC7D5421D34
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 06:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbhJEEYk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 00:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbhJEEYj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Oct 2021 00:24:39 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF07DC061749
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 21:22:49 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id a131-20020a1c7f89000000b0030d4c90fa87so1819546wmd.2
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 21:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PMJ+9x8m5hwSi/H7EIQliJKkNzjB0DxfaHLEuq28K2o=;
        b=SZ9ECJ51JcaeYSmGP0VckwfF4wtaA9CXQo76dxViUkdRIljjPdLkCsuGAfF5uQWcFf
         eqoAgGjpbsDeFoJPfrfR0anidoGqsCNQ1LQtAewcGyL57fV2LmE2t4I2MB4+iV2+5xiV
         Tj9v4cMPYjN45x3VZsZXzDfa7ZUe9cAcUtGUnNfz8ObAd+mddcA4hS1qgmDuyO5Y+Jm2
         TFYVr+PKJgy/HEus1PynsMihA0d7V1bFrTBpSIsKy8LYCux3E123IEvDqjTpNTqNTle+
         nsvh+VoQHr1Wws2Fi0yHoAls/FMT6QU2XB32uQtjFsZ2bsCZE3H1XHR3r3etG/EE1vvz
         3ZaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PMJ+9x8m5hwSi/H7EIQliJKkNzjB0DxfaHLEuq28K2o=;
        b=75cOswZRn91wxfqDu9i5b3bChjKzd87TvYpX2ly7ROxKhPESnToi1f+8xirwDNTI3f
         x8vnOPRaTbUuJs1zol+a2j9pDVeQD5VwbGl8A1U/0FsP2HJIPxtcnvCga8hVBbUYSWDp
         BCgFGYIpecTMHXWnvMtk2LdFTBducknhFjKet4X+E7umRZB2sfnTRbWSdbPnM59Hsxck
         Hlzp/1g3uSbT0JOqBYbdIxFz2fPfNPJubTju1Sqe/6FFz14RG4mDUdLVuERMtOroJkCx
         IQ6kP28yirkkRl6MOBAVaLSymS1nX9T/0x16hNT7JV0izOpJX6jwNfmh26na0OxSzc1M
         s5Xg==
X-Gm-Message-State: AOAM530C2rGRH49T6pdOUUZAXuNBXvSGCLUolbFqooX44Mjh42T4CH1Q
        AFtbK+LcdeRt72PiR0qaWjwLvFRfzOzT5KZ6w5nh9yFSFk4=
X-Google-Smtp-Source: ABdhPJzjJ2NZbFDT+6nC0o5g30O6wQOKxAZi70Cyuqf41cn5zzONv0xSUwWWt9L0ghl89U+hsvaOeL64c4eNnMNjnUI=
X-Received: by 2002:a05:600c:41d6:: with SMTP id t22mr1029713wmh.59.1633407768121;
 Mon, 04 Oct 2021 21:22:48 -0700 (PDT)
MIME-Version: 1.0
References: <5cadb0b3-5e8f-110b-c6ed-4adaea033e58@redhat.com> <mhng-1bfcbce2-3da3-4490-bcc5-45173ad84285@palmerdabbelt-glaptop>
In-Reply-To: <mhng-1bfcbce2-3da3-4490-bcc5-45173ad84285@palmerdabbelt-glaptop>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 5 Oct 2021 09:52:36 +0530
Message-ID: <CAAhSdy1vQg+UKxquZiQG32YFmU95xYc_4Yb_VUA0nd=t8vRu-A@mail.gmail.com>
Subject: Re: [PATCH v20 00/17] KVM RISC-V Support
To:     Palmer Dabbelt <palmerdabbelt@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Anup Patel <Anup.Patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 4, 2021 at 11:31 PM Palmer Dabbelt <palmerdabbelt@google.com> wrote:
>
> On Mon, 04 Oct 2021 01:58:28 PDT (-0700), pbonzini@redhat.com wrote:
> > On 27/09/21 13:39, Anup Patel wrote:
> >> This series adds initial KVM RISC-V support. Currently, we are able to boot
> >> Linux on RV64/RV32 Guest with multiple VCPUs.
> >>
> >> Key aspects of KVM RISC-V added by this series are:
> >> 1. No RISC-V specific KVM IOCTL
> >> 2. Loadable KVM RISC-V module supported
> >> 3. Minimal possible KVM world-switch which touches only GPRs and few CSRs
> >> 4. Both RV64 and RV32 host supported
> >> 5. Full Guest/VM switch is done via vcpu_get/vcpu_put infrastructure
> >> 6. KVM ONE_REG interface for VCPU register access from user-space
> >> 7. PLIC emulation is done in user-space
> >> 8. Timer and IPI emuation is done in-kernel
> >> 9. Both Sv39x4 and Sv48x4 supported for RV64 host
> >> 10. MMU notifiers supported
> >> 11. Generic dirtylog supported
> >> 12. FP lazy save/restore supported
> >> 13. SBI v0.1 emulation for KVM Guest available
> >> 14. Forward unhandled SBI calls to KVM userspace
> >> 15. Hugepage support for Guest/VM
> >> 16. IOEVENTFD support for Vhost
> >>
> >> Here's a brief TODO list which we will work upon after this series:
> >> 1. KVM unit test support
> >> 2. KVM selftest support
> >> 3. SBI v0.3 emulation in-kernel
> >> 4. In-kernel PMU virtualization
> >> 5. In-kernel AIA irqchip support
> >> 6. Nested virtualizaiton
> >> 7. ..... and more .....
> >
> > Looks good, I prepared a tag "for-riscv" at
> > https://git.kernel.org/pub/scm/virt/kvm/kvm.git.  Palmer can pull it and
> > you can use it to send me a pull request.
>
> Thanks.  I'm assuming "you" there is Anup?
>
> Just to make sure we're on the same page here, I've got
>
>     commit 6c341a285912ddb2894ef793a58ad4f8462f26f4 (HEAD -> for-next)
>     Merge: 08da1608a1ca 3f2401f47d29
>     Author: Palmer Dabbelt <palmerdabbelt@google.com>
>     Date:   Mon Oct 4 10:12:44 2021 -0700
>
>         Merge tag 'for-riscv' of https://git.kernel.org/pub/scm/virt/kvm/kvm.git into for-next
>
>         H extension definitions, shared by the KVM and RISC-V trees.
>
>         * tag 'for-riscv' of ssh://gitolite.kernel.org/pub/scm/virt/kvm/kvm: (301 commits)
>           RISC-V: Add hypervisor extension related CSR defines
>           KVM: selftests: Ensure all migrations are performed when test is affined
>           KVM: x86: Swap order of CPUID entry "index" vs. "significant flag" checks
>           ptp: Fix ptp_kvm_getcrosststamp issue for x86 ptp_kvm
>           x86/kvmclock: Move this_cpu_pvti into kvmclock.h
>           KVM: s390: Function documentation fixes
>           selftests: KVM: Don't clobber XMM register when read
>           KVM: VMX: Fix a TSX_CTRL_CPUID_CLEAR field mask issue
>           selftests: KVM: Explicitly use movq to read xmm registers
>           selftests: KVM: Call ucall_init when setting up in rseq_test
>           KVM: Remove tlbs_dirty
>           KVM: X86: Synchronize the shadow pagetable before link it
>           KVM: X86: Fix missed remote tlb flush in rmap_write_protect()
>           KVM: x86: nSVM: don't copy virt_ext from vmcb12
>           KVM: x86: nSVM: test eax for 4K alignment for GP errata workaround
>           KVM: x86: selftests: test simultaneous uses of V_IRQ from L1 and L0
>           KVM: x86: nSVM: restore int_vector in svm_clear_vintr
>           kvm: x86: Add AMD PMU MSRs to msrs_to_save_all[]
>           KVM: x86: nVMX: re-evaluate emulation_required on nested VM exit
>           KVM: x86: nVMX: don't fail nested VM entry on invalid guest state if !from_vmentry
>           ...
>
> into ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/palmer/linux.git for-next
> (I know that's kind of a confusing name, but it's what I've been using
> as my short-term staging branch so I can do all my tests before saying
> "it's on for-next").
>
> If that looks OK I can make it a touch more official by putting into the
> RISC-V tree.
>
> > I look forward to the test support. :)  Would be nice to have selftest
> > support already in 5.16, since there are a few arch-independent
> > selftests that cover the hairy parts of the MMU.
>
> Me too ;).
>
> I'm happy to add some KVM-related stuff to my pre-push test set, just
> LMK if there's anything specific I should be looking in to.

Thanks Palmer, I will ping you once I have basic kvm-selftest patches
ready for RISC-V.

Regards,
Anup
