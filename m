Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCD4D55B533
	for <lists+kvm@lfdr.de>; Mon, 27 Jun 2022 04:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbiF0C3z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Jun 2022 22:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiF0C3y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Jun 2022 22:29:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC4A2BFC
        for <kvm@vger.kernel.org>; Sun, 26 Jun 2022 19:29:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E7F7B80EA2
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 02:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B7F6DC341CC
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 02:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656296987;
        bh=XM7B/hpAstUf2/f4McL5EMSZqcwI3jqJctsSXOvV0yY=;
        h=From:To:Subject:Date:From;
        b=IDHskKijnTNuPYf39I3ePvNnMD+FROdsm+eRgMt0H7tdslROHfSv+VC9Od1M2QtEI
         xjo5ehrEeTVzPFbcY8hLXkhXPo8Aibh+aIyLL+f+XKbQUnxrnZc1pMEQFJwb/aPo3H
         xFoo8BWbB+6K53Dna5WlGqrD3kIUkvwteAbInlaLXyYQrGr9mC1goM8tamlbypFTpB
         NdUj0hfLBk6bTlr8IE0Q+fEaxGexSaCRcXnygVpd6EbNCsBp4rfLMd7POdmIGqj9wg
         UWPay3spexo/fxCdbZ9gnu/qe98knnKvm+/t+GKIVS/C+bGvvMLce3vWwV51nb1MBX
         TO/K5NQ9ZRzAw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 9F095CC13B1; Mon, 27 Jun 2022 02:29:47 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 216178] New: kvm-unit-tests
 vmx_pf_exception_test_reduced_maxphyaddr fails in kvm 5.19-rc1
Date:   Mon, 27 Jun 2022 02:29:47 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: lixiao.yang@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-216178-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216178

            Bug ID: 216178
           Summary: kvm-unit-tests
                    vmx_pf_exception_test_reduced_maxphyaddr fails in kvm
                    5.19-rc1
           Product: Virtualization
           Version: unspecified
    Kernel Version: 5.19-rc1
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: lixiao.yang@intel.com
        Regression: No

Environment:
CPU Architecture: x86_64
Host OS: Red Hat Enterprise Linux 8.4 (Ootpa)
Host kernel: 5.19.0-rc1
gcc: gcc version 8.4.1
Host kernel source: https://git.kernel.org/pub/scm/virt/kvm/kvm.git
Branch: next
Commit: 4b88b1a518b337de1252b8180519ca4c00015c9e

Qemu source: https://git.qemu.org/git/qemu.git
Branch: master
Commit: 40d522490714b65e0856444277db6c14c5cc3796

kvm-unit-tests source: https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git
Branch: master
Commit: ca85dda2671e88d34acfbca6de48a9ab32b1810d

Bug Detailed Description:
kvm-unit-tests vmx_pf_exception_test_reduced_maxphyaddr fails in kvm 5.19-r=
c1.=20

Reproducibility:
Always=20

Reproducing Steps:
rmmod kvm_intel
modprobe kvm_intel nested=3DY allow_smaller_maxphyaddr=3DY=20
git clone https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git
cd kvm-unit-tests
./configure
make standalone
cd tests
./vmx_pf_exception_test_reduced_maxphyaddr


Actual Result:
[root@icx-2s1 tests]$./vmx_pf_exception_test_reduced_maxphyaddr
BUILD_HEAD=3Dca85dda2
timeout -k 1s --foreground 90s /usr/local/bin/qemu-system-x86_64 --no-reboot
-nodefaults -device pc-testdev -device isa-debug-exit,iobase=3D0xf4,iosize=
=3D0x4
-vnc none -serial stdio -device pci-testdev -machine accel=3Dkvm -kernel
/tmp/tmp.tqLBp4BJLc -smp 1 -cpu IvyBridge,phys-bits=3D36,host-phys-bits=3Do=
ff,+vmx
-append vmx_pf_exception_test vmx_pf_no_vpid_test vmx_pf_vpid_test
vmx_pf_invvpid_test # -initrd /tmp/tmp.yMFfmwwAsy
qemu-system-x86_64: warning: Host physical bits (46) does not match phys-bi=
ts
property (36)
enabling apic
paging enabled
cr0 =3D 80010011
cr3 =3D 1007000
cr4 =3D 20
filter =3D vmx_pf_exception_test, test =3D test_vmx_feature_control
filter =3D vmx_pf_exception_test, test =3D test_vmxon
filter =3D vmx_pf_exception_test, test =3D test_vmptrld
filter =3D vmx_pf_exception_test, test =3D test_vmclear
filter =3D vmx_pf_exception_test, test =3D test_vmptrst
filter =3D vmx_pf_exception_test, test =3D test_vmwrite_vmread
filter =3D vmx_pf_exception_test, test =3D test_vmcs_high
filter =3D vmx_pf_exception_test, test =3D test_vmcs_lifecycle
filter =3D vmx_pf_exception_test, test =3D test_vmx_caps
filter =3D vmx_pf_exception_test, test =3D test_vmread_flags_touch
filter =3D vmx_pf_exception_test, test =3D test_vmwrite_flags_touch
filter =3D vmx_pf_exception_test, test =3D null
filter =3D vmx_pf_exception_test, test =3D vmenter
filter =3D vmx_pf_exception_test, test =3D preemption timer
filter =3D vmx_pf_exception_test, test =3D control field PAT
filter =3D vmx_pf_exception_test, test =3D control field EFER
filter =3D vmx_pf_exception_test, test =3D CR shadowing
filter =3D vmx_pf_exception_test, test =3D I/O bitmap
filter =3D vmx_pf_exception_test, test =3D instruction intercept
filter =3D vmx_pf_exception_test, test =3D EPT A/D disabled
filter =3D vmx_pf_exception_test, test =3D EPT A/D enabled
filter =3D vmx_pf_exception_test, test =3D PML
filter =3D vmx_pf_exception_test, test =3D interrupt
filter =3D vmx_pf_exception_test, test =3D nmi_hlt
filter =3D vmx_pf_exception_test, test =3D debug controls
filter =3D vmx_pf_exception_test, test =3D MSR switch
filter =3D vmx_pf_exception_test, test =3D vmmcall
filter =3D vmx_pf_exception_test, test =3D disable RDTSCP
filter =3D vmx_pf_exception_test, test =3D int3
filter =3D vmx_pf_exception_test, test =3D into
filter =3D vmx_pf_exception_test, test =3D exit_monitor_from_l2_test
filter =3D vmx_pf_exception_test, test =3D invalid_msr
filter =3D vmx_pf_exception_test, test =3D v2_null_test
filter =3D vmx_pf_exception_test, test =3D v2_multiple_entries_test
filter =3D vmx_pf_exception_test, test =3D fixture_test_case1
filter =3D vmx_pf_exception_test, test =3D fixture_test_case2
filter =3D vmx_pf_exception_test, test =3D invvpid_test
filter =3D vmx_pf_exception_test, test =3D vmx_controls_test
filter =3D vmx_pf_exception_test, test =3D vmx_host_state_area_test
filter =3D vmx_pf_exception_test, test =3D vmx_guest_state_area_test
filter =3D vmx_pf_exception_test, test =3D vmentry_movss_shadow_test
filter =3D vmx_pf_exception_test, test =3D vmentry_unrestricted_guest_test
filter =3D vmx_pf_exception_test, test =3D vmx_eoi_bitmap_ioapic_scan_test
filter =3D vmx_pf_exception_test, test =3D vmx_hlt_with_rvi_test
filter =3D vmx_pf_exception_test, test =3D apic_reg_virt_test
filter =3D vmx_pf_exception_test, test =3D virt_x2apic_mode_test
filter =3D vmx_pf_exception_test, test =3D vmx_apic_passthrough_test
filter =3D vmx_pf_exception_test, test =3D vmx_apic_passthrough_thread_test
filter =3D vmx_pf_exception_test, test =3D vmx_apic_passthrough_tpr_thresho=
ld_test
filter =3D vmx_pf_exception_test, test =3D vmx_init_signal_test
filter =3D vmx_pf_exception_test, test =3D vmx_sipi_signal_test
filter =3D vmx_pf_exception_test, test =3D vmx_vmcs_shadow_test
filter =3D vmx_pf_exception_test, test =3D vmx_ldtr_test
filter =3D vmx_pf_exception_test, test =3D vmx_cr_load_test
filter =3D vmx_pf_exception_test, test =3D vmx_cr4_osxsave_test
filter =3D vmx_pf_exception_test, test =3D vmx_nm_test
filter =3D vmx_pf_exception_test, test =3D vmx_db_test
filter =3D vmx_pf_exception_test, test =3D vmx_nmi_window_test
filter =3D vmx_pf_exception_test, test =3D vmx_intr_window_test
filter =3D vmx_pf_exception_test, test =3D vmx_pending_event_test
filter =3D vmx_pf_exception_test, test =3D vmx_pending_event_hlt_test
filter =3D vmx_pf_exception_test, test =3D vmx_store_tsc_test
filter =3D vmx_pf_exception_test, test =3D vmx_preemption_timer_zero_test
filter =3D vmx_pf_exception_test, test =3D vmx_preemption_timer_tf_test
filter =3D vmx_pf_exception_test, test =3D vmx_preemption_timer_expiry_test
filter =3D vmx_pf_exception_test, test =3D ept_access_test_not_present
filter =3D vmx_pf_exception_test, test =3D ept_access_test_read_only
filter =3D vmx_pf_exception_test, test =3D ept_access_test_write_only
filter =3D vmx_pf_exception_test, test =3D ept_access_test_read_write
filter =3D vmx_pf_exception_test, test =3D ept_access_test_execute_only
filter =3D vmx_pf_exception_test, test =3D ept_access_test_read_execute
filter =3D vmx_pf_exception_test, test =3D ept_access_test_write_execute
filter =3D vmx_pf_exception_test, test =3D ept_access_test_read_write_execu=
te
filter =3D vmx_pf_exception_test, test =3D ept_access_test_reserved_bits
filter =3D vmx_pf_exception_test, test =3D ept_access_test_ignored_bits
filter =3D vmx_pf_exception_test, test =3D
ept_access_test_paddr_not_present_ad_disabled
filter =3D vmx_pf_exception_test, test =3D
ept_access_test_paddr_not_present_ad_enabled
filter =3D vmx_pf_exception_test, test =3D
ept_access_test_paddr_read_only_ad_disabled
filter =3D vmx_pf_exception_test, test =3D
ept_access_test_paddr_read_only_ad_enabled
filter =3D vmx_pf_exception_test, test =3D ept_access_test_paddr_read_write
filter =3D vmx_pf_exception_test, test =3D ept_access_test_paddr_read_write=
_execute
filter =3D vmx_pf_exception_test, test =3D
ept_access_test_paddr_read_execute_ad_disabled
filter =3D vmx_pf_exception_test, test =3D
ept_access_test_paddr_read_execute_ad_enabled
filter =3D vmx_pf_exception_test, test =3D
ept_access_test_paddr_not_present_page_fault
filter =3D vmx_pf_exception_test, test =3D ept_access_test_force_2m_page
filter =3D vmx_pf_exception_test, test =3D atomic_switch_max_msrs_test
filter =3D vmx_pf_exception_test, test =3D atomic_switch_overflow_msrs_test
filter =3D vmx_pf_exception_test, test =3D rdtsc_vmexit_diff_test
filter =3D vmx_pf_exception_test, test =3D vmx_mtf_test
filter =3D vmx_pf_exception_test, test =3D vmx_mtf_pdpte_test
filter =3D vmx_pf_exception_test, test =3D vmx_pf_exception_test

Test suite: vmx_pf_exception_test
run
CR4.PKE not available, disabling PKE tests
x86/vmx_tests.c:10631: assert failed: false: Unexpected exit to L1,
exit_reason: VMX_EXC_NMI (0x0)
        STACK: 406ede 407032 401e88 403c2e 4002c4
FAIL vmx_pf_exception_test_reduced_maxphyaddr


Expected Result:
...
PASS vmx_pf_exception_test_reduced_maxphyaddr

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
