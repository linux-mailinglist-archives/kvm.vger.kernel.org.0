Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A644211AFD
	for <lists+kvm@lfdr.de>; Thu,  2 May 2019 16:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbfEBONF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 May 2019 10:13:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:22038 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbfEBONF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 May 2019 10:13:05 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 May 2019 07:13:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,421,1549958400"; 
   d="scan'208";a="139296728"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by orsmga008.jf.intel.com with ESMTP; 02 May 2019 07:13:05 -0700
Date:   Thu, 2 May 2019 07:13:04 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        marcorr@google.com, Riku Voipio <riku.voipio@linaro.org>,
        Alan Bennett <alan.bennett@linaro.org>,
        lkft-triage@lists.linaro.org
Subject: Re: [kvm-unit-tests ] results on stable-rc-5.0
Message-ID: <20190502141304.GA26138@linux.intel.com>
References: <CA+G9fYu_dLNiGJyeDxgr1kRSAHcKmyAjjUjEuSj5Qkw8=wbxYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYu_dLNiGJyeDxgr1kRSAHcKmyAjjUjEuSj5Qkw8=wbxYA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 02, 2019 at 12:54:14PM +0530, Naresh Kamboju wrote:
> Linaro test farm is validating each stable rc releases and reporting
> results to upstream. kvm-unit-tests also included in Linux Kernel
> Functional test plan and we see below results so please comment on
> reason for test failures and skip and suggest Kconfig or any userland
> tools for improve test coverage.

The test environment needs to load a KVM module, e.g. kvm_intel or kvm_amd.
The unit tests don't require KVM to be loaded and will happily test Qemu
emulation when possible (not sure if this is a bug or feature).

Lack of KVM is why you see

  SKIP ... (qemu-system-x86_64: CPU model 'host' requires KVM)

and is likely why other tests are failing, e.g. apic timeouts.


> 
> kvm unit tests results summary.
> PASS 23
> SKIP 18
> FAIL 14
> 
> Test results output log,
> --------------------------------
> FAIL apic-split (timeout; duration=90s)
> PASS ioapic-split (19 tests)
> FAIL apic (timeout; duration=30)
> PASS ioapic (19 tests)
> PASS smptest (1 tests)
> PASS smptest3 (1 tests)
> PASS vmexit_cpuid
> FAIL vmexit_vmcall
> PASS vmexit_mov_from_cr8
> PASS vmexit_mov_to_cr8
> PASS vmexit_inl_pmtimer
> PASS vmexit_ipi
> PASS vmexit_ipi_halt
> PASS vmexit_ple_round_robin
> PASS vmexit_tscdeadline
> PASS vmexit_tscdeadline_immed
> SKIP access (qemu-system-x86_64: CPU model 'host' requires KVM)
> SKIP smap (qemu-system-x86_64: CPU model 'host' requires KVM)
> SKIP pku (qemu-system-x86_64: CPU model 'host' requires KVM)
> FAIL emulator (timeout; duration=90s)
> PASS eventinj (13 tests)
> FAIL hypercall (timeout; duration=90s)
> FAIL idt_test (timeout; duration=90s)
> SKIP memory (qemu-system-x86_64: CPU model 'host' requires KVM)
> PASS msr (12 tests)
> cat: /proc/sys/kernel/nmi_watchdog: No such file or directory
> SKIP pmu (/proc/sys/kernel/nmi_watchdog not equal to 0)
> FAIL vmware_backdoors
> PASS port80
> FAIL realmode
> FAIL s3
> PASS sieve
> PASS syscall (2 tests)
> PASS tsc (3 tests)
> SKIP tsc_adjust (qemu-system-x86_64: CPU model 'host' requires KVM)
> SKIP xsave (qemu-system-x86_64: CPU model 'host' requires KVM)
> PASS rmap_chain
> FAIL svm (timeout; duration=90s)
> SKIP taskswitch (i386 only)
> SKIP taskswitch2 (i386 only)
> FAIL kvmclock_test
> FAIL pcid (3 tests, 1 unexpected failures)
> PASS umip (11 tests)
> SKIP vmx (qemu-system-x86_64: CPU model 'host' requires KVM)
> SKIP ept (qemu-system-x86_64: CPU model 'host' requires KVM)
> SKIP vmx_eoi_bitmap_ioapic_scan (qemu-system-x86_64: CPU model 'host'
> requires KVM)
> SKIP vmx_hlt_with_rvi_test (qemu-system-x86_64: CPU model 'host' requires KVM)
> SKIP vmx_apicv_test (qemu-system-x86_64: CPU model 'host' requires KVM)
> SKIP vmx_apic_passthrough_thread (qemu-system-x86_64: CPU model 'host'
> requires KVM)
> SKIP vmx_vmcs_shadow_test (qemu-system-x86_64: CPU model 'host' requires KVM)
> FAIL debug
> SKIP hyperv_synic
> SKIP hyperv_connections (1 tests, 1 skipped)
> PASS hyperv_stimer (1 tests)
> FAIL hyperv_clock (timeout; duration=90s)
> PASS intel_iommu (11 tests)
> 
> Kernel version,
> 5.0.11-rc1
> 
> x86_64 kernel config,
> http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/intel-corei7-64/lkft/linux-stable-rc-5.0/39/config
> 
> Test full results log,
> https://lkft.validation.linaro.org/scheduler/job/696689#L1415
> 
> Reference link for all test plans running on x86_64, i386, arm and arm64.
> https://qa-reports.linaro.org/lkft/linux-stable-rc-5.0-oe/
> 
> Best regards
> Naresh Kamboju
