Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B11C11417
	for <lists+kvm@lfdr.de>; Thu,  2 May 2019 09:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbfEBHY2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 May 2019 03:24:28 -0400
Received: from mail-lj1-f171.google.com ([209.85.208.171]:43720 "EHLO
        mail-lj1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726159AbfEBHY2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 May 2019 03:24:28 -0400
Received: by mail-lj1-f171.google.com with SMTP id t1so1209642lje.10
        for <kvm@vger.kernel.org>; Thu, 02 May 2019 00:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=ghFNzOb61UFVqL/XSwKbwaqYhv0lw7MSasmWuDDEF2U=;
        b=v7hjG2/bb84Xw2nz3GV0oO2Aa4FFFX9f2pyw+sEGzGz0awb4WiMIKIwFcMJXCF/Hte
         CNeAvdNr4Fa4iWvcm3d9z6pdTAeLS1DwFgLQkuqxF/EEVm2s5gonW610ljglVpW/UjW0
         zKjOthmpbYABQ7DurpBQaHCI1fQXPJluJUyf9gF/DEPGAZdzfPXPul0k7J9xvrfDTFG+
         EtLK1hXSmMyWLyrpfISXpO1qTJpOvZtq8Lam8D+0Qp3pUQwCmTZ8CikUzjlwJ1RL28oC
         mPx5sS03eou2lNLyxh49YTLMqBi28NiOh23C7gdAFuhyO3rroKfbd/nzkNoZqAng56IW
         fryA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=ghFNzOb61UFVqL/XSwKbwaqYhv0lw7MSasmWuDDEF2U=;
        b=UgyGA51E0pBM+nRGBoprO16DW6rF3ORszLStJvecETFIuV4Lc40xDVbml7fAoEBgRB
         9PBnn56XQd58nnnW0EgVxbEsXHdi+r0kEt8N2anMd40zVXejn7bY6JHcFCsTIf9VhVZF
         klHMQwkV135Uz81Jp2PdG3Mme7WNcLWMGf2mjtKgqn+9ghHxb/lbo0+iiJwU+4oMMIMh
         xwK/jdvQ2iQGUI8EkDsQlAAuwU1cxdvjTwjVA9nIs9dftIDRJJYVMoCrMFh6W3CFVdzR
         alTvRYljAX+viyPJGQf7BH4qiJ269rfhwGcD/OS/baiaIOSP5kk/9F8zbmDnFLOpJyft
         4Opg==
X-Gm-Message-State: APjAAAWwP7LGuy7MGHGurVmAfwErSnMHIT+piAYYNWuc++v6yVgt8ede
        TuWyPqF9l2PE/XmgrJyAY16f27rOnobEyKY6RNPUjxeFrENCMw==
X-Google-Smtp-Source: APXvYqx+IPehC0kPnSGMPpmoJdv0vtOPR5z3WWCk7KBaZaBxU2AQ00ebqFedPJgbqlXyVRzBtLkTrMY4oJuzxx2avh8=
X-Received: by 2002:a2e:9689:: with SMTP id q9mr857641lji.194.1556781865773;
 Thu, 02 May 2019 00:24:25 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 2 May 2019 12:54:14 +0530
Message-ID: <CA+G9fYu_dLNiGJyeDxgr1kRSAHcKmyAjjUjEuSj5Qkw8=wbxYA@mail.gmail.com>
Subject: [kvm-unit-tests ] results on stable-rc-5.0
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, marcorr@google.com,
        Riku Voipio <riku.voipio@linaro.org>,
        Alan Bennett <alan.bennett@linaro.org>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linaro test farm is validating each stable rc releases and reporting
results to upstream. kvm-unit-tests also included in Linux Kernel
Functional test plan and we see below results so please comment on
reason for test failures and skip and suggest Kconfig or any userland
tools for improve test coverage.

kvm unit tests results summary.
PASS 23
SKIP 18
FAIL 14

Test results output log,
--------------------------------
FAIL apic-split (timeout; duration=90s)
PASS ioapic-split (19 tests)
FAIL apic (timeout; duration=30)
PASS ioapic (19 tests)
PASS smptest (1 tests)
PASS smptest3 (1 tests)
PASS vmexit_cpuid
FAIL vmexit_vmcall
PASS vmexit_mov_from_cr8
PASS vmexit_mov_to_cr8
PASS vmexit_inl_pmtimer
PASS vmexit_ipi
PASS vmexit_ipi_halt
PASS vmexit_ple_round_robin
PASS vmexit_tscdeadline
PASS vmexit_tscdeadline_immed
SKIP access (qemu-system-x86_64: CPU model 'host' requires KVM)
SKIP smap (qemu-system-x86_64: CPU model 'host' requires KVM)
SKIP pku (qemu-system-x86_64: CPU model 'host' requires KVM)
FAIL emulator (timeout; duration=90s)
PASS eventinj (13 tests)
FAIL hypercall (timeout; duration=90s)
FAIL idt_test (timeout; duration=90s)
SKIP memory (qemu-system-x86_64: CPU model 'host' requires KVM)
PASS msr (12 tests)
cat: /proc/sys/kernel/nmi_watchdog: No such file or directory
SKIP pmu (/proc/sys/kernel/nmi_watchdog not equal to 0)
FAIL vmware_backdoors
PASS port80
FAIL realmode
FAIL s3
PASS sieve
PASS syscall (2 tests)
PASS tsc (3 tests)
SKIP tsc_adjust (qemu-system-x86_64: CPU model 'host' requires KVM)
SKIP xsave (qemu-system-x86_64: CPU model 'host' requires KVM)
PASS rmap_chain
FAIL svm (timeout; duration=90s)
SKIP taskswitch (i386 only)
SKIP taskswitch2 (i386 only)
FAIL kvmclock_test
FAIL pcid (3 tests, 1 unexpected failures)
PASS umip (11 tests)
SKIP vmx (qemu-system-x86_64: CPU model 'host' requires KVM)
SKIP ept (qemu-system-x86_64: CPU model 'host' requires KVM)
SKIP vmx_eoi_bitmap_ioapic_scan (qemu-system-x86_64: CPU model 'host'
requires KVM)
SKIP vmx_hlt_with_rvi_test (qemu-system-x86_64: CPU model 'host' requires KVM)
SKIP vmx_apicv_test (qemu-system-x86_64: CPU model 'host' requires KVM)
SKIP vmx_apic_passthrough_thread (qemu-system-x86_64: CPU model 'host'
requires KVM)
SKIP vmx_vmcs_shadow_test (qemu-system-x86_64: CPU model 'host' requires KVM)
FAIL debug
SKIP hyperv_synic
SKIP hyperv_connections (1 tests, 1 skipped)
PASS hyperv_stimer (1 tests)
FAIL hyperv_clock (timeout; duration=90s)
PASS intel_iommu (11 tests)

Kernel version,
5.0.11-rc1

x86_64 kernel config,
http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/intel-corei7-64/lkft/linux-stable-rc-5.0/39/config

Test full results log,
https://lkft.validation.linaro.org/scheduler/job/696689#L1415

Reference link for all test plans running on x86_64, i386, arm and arm64.
https://qa-reports.linaro.org/lkft/linux-stable-rc-5.0-oe/

Best regards
Naresh Kamboju
