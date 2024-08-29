Return-Path: <kvm+bounces-25345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 52DE7964406
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 14:13:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A889BB24228
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 12:13:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05E0C195FD5;
	Thu, 29 Aug 2024 12:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RVf1C8Hm"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27BB5194C89
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 12:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724933574; cv=none; b=I0q88heRJBQokStPZuWpC6MoKLvO/3QHWIiKWUqCJMgadK72ECnkpAebTrFGY5Ww0rfqPVPl5deA34Gv6U5SUYJ4SJpzWvOuYka7wBI4/iFVYg1O74y/r9QbWB7Yc6f4Oxw+Is/YUjitUKQIFMCe0KOuAy9tS1aO9WsY0rCKvMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724933574; c=relaxed/simple;
	bh=PW0P6Xh11OlkVI1keUT9RhpzZkrKMuBxwYNo4CjZGEk=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Bu5j7Vzpq7zyE3MATo+CyalyuzV8C5yz1pSqMuEFla0Bp1a7sK2mXsLDl4O0Ilrm4lXDFmmigyzOYwIX5wlgiejWJFbR2BncuA1SVvNj8IeUnTgep8qy/4a/+WNxNfAvPsUFtGVNXli5Zh//VC0w6fPki9jajs+0slZLgndBAZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RVf1C8Hm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id B6B76C4CEC7
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 12:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724933573;
	bh=PW0P6Xh11OlkVI1keUT9RhpzZkrKMuBxwYNo4CjZGEk=;
	h=From:To:Subject:Date:From;
	b=RVf1C8Hm0H9GwuMAndw0vaLKJoWWDrCRYMtJv6TnZOi3qMsA9UHIRNGwQFL0PciqC
	 IWL84gPSpxTHdcfaKosGz85YOm2UIYXzCvSWkSa6pW61U41w8D4RpQU4XEFoySr1p3
	 hVgfeQI+hMwJ8ttcBiJBRXR0i2ZN0bcx7FPVbWHxHS5atFG7TMrBGJWXx/+B/OeScZ
	 xTjgVHG5c660imhfZi4RfPZ19f7BFkGcJitwVZGknr1ql963Z0KQ3PpRvabzcCbUAt
	 DnUvL+d4k+uVJhkrffRv74KQGBgYDVcprIVxgxSfHpKVOEtLUYFVDwMMu8p3ThVLR8
	 0MOF8a7TmYFnQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id A847AC53BC4; Thu, 29 Aug 2024 12:12:53 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: kvm@vger.kernel.org
Subject: [Bug 219210] New: [kvm-unit-tests] kvm-unit-tests
 vmx_posted_intr_test failed
Date: Thu, 29 Aug 2024 12:12:53 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: xuelian.guo@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-219210-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D219210

            Bug ID: 219210
           Summary: [kvm-unit-tests] kvm-unit-tests vmx_posted_intr_test
                    failed
           Product: Virtualization
           Version: unspecified
          Hardware: Intel
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: kvm
          Assignee: virtualization_kvm@kernel-bugs.osdl.org
          Reporter: xuelian.guo@intel.com
        Regression: No

Environment:
KVM commit/branch: 332d2c1d/next
Qemu commit/branch: a7ddb48b/master
kvm-unit-tests commit: 201b9e8bdc84c6436dd53b45d93a60c681b92719

Host OS: CentOS 9
Host Kernel: 6.10.0-rc7
Platforms: platform-independent=20

Bug detail description:=20

Failed to run kvm-unit-tests case vmx_posted_intr_test.

Reproduce steps:=20

1. git clone https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git
2. cd kvm-unit-tests; ./configure
3. make standalone
4. rmmod kvm_intel; rmmod kvm
5. modprobe kvm enable_vmware_backdoor=3DY
6. modprobe kvm_intel nested=3DY allow_smaller_maxphyaddr=3DY
7. cd tests; ./vmx_posted_intr_test=20

Error log:=20

Test suite: vmx_posted_interrupts_test
PASS: Set ISR for vectors 33-255.
FAIL: x86/vmx_tests.c:2164: Assertion failed: (expected) =3D=3D (actual)
        LHS: 0x0000000000000012 -
0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0001'=
0010
- 18
        RHS: 0x0000000000000001 -
0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'=
0001
- 1
Expected VMX_VMCALL, got VMX_EXTINT.
        STACK: 406faa 40730c 417317 4177da 402039 403f11 4001bd
filter =3D vmx_posted_interrupts_test, test =3D vmx_apic_passthrough_test
filter =3D vmx_posted_interrupts_test, test =3D vmx_apic_passthrough_thread=
_test
filter =3D vmx_posted_interrupts_test, test =3D
vmx_apic_passthrough_tpr_threshold_test
filter =3D vmx_posted_interrupts_test, test =3D vmx_init_signal_test
filter =3D vmx_posted_interrupts_test, test =3D vmx_sipi_signal_test
filter =3D vmx_posted_interrupts_test, test =3D vmx_vmcs_shadow_test
filter =3D vmx_posted_interrupts_test, test =3D vmx_ldtr_test
filter =3D vmx_posted_interrupts_test, test =3D vmx_cr_load_test
filter =3D vmx_posted_interrupts_test, test =3D vmx_cr4_osxsave_test
filter =3D vmx_posted_interrupts_test, test =3D vmx_no_nm_test
filter =3D vmx_posted_interrupts_test, test =3D vmx_db_test
filter =3D vmx_posted_interrupts_test, test =3D vmx_nmi_window_test
filter =3D vmx_posted_interrupts_test, test =3D vmx_intr_window_test
filter =3D vmx_posted_interrupts_test, test =3D vmx_pending_event_test
filter =3D vmx_posted_interrupts_test, test =3D vmx_pending_event_hlt_test
filter =3D vmx_posted_interrupts_test, test =3D vmx_store_tsc_test
filter =3D vmx_posted_interrupts_test, test =3D vmx_preemption_timer_zero_t=
est
filter =3D vmx_posted_interrupts_test, test =3D vmx_preemption_timer_tf_test
filter =3D vmx_posted_interrupts_test, test =3D vmx_preemption_timer_expiry=
_test
filter =3D vmx_posted_interrupts_test, test =3D ept_access_test_not_present
filter =3D vmx_posted_interrupts_test, test =3D ept_access_test_read_only
filter =3D vmx_posted_interrupts_test, test =3D ept_access_test_write_only
filter =3D vmx_posted_interrupts_test, test =3D ept_access_test_read_write
filter =3D vmx_posted_interrupts_test, test =3D ept_access_test_execute_only
filter =3D vmx_posted_interrupts_test, test =3D ept_access_test_read_execute
filter =3D vmx_posted_interrupts_test, test =3D ept_access_test_write_execu=
te
filter =3D vmx_posted_interrupts_test, test =3D ept_access_test_read_write_=
execute
filter =3D vmx_posted_interrupts_test, test =3D ept_access_test_reserved_bi=
ts
filter =3D vmx_posted_interrupts_test, test =3D ept_access_test_ignored_bits
filter =3D vmx_posted_interrupts_test, test =3D
ept_access_test_paddr_not_present_ad_disabled
filter =3D vmx_posted_interrupts_test, test =3D
ept_access_test_paddr_not_present_ad_enabled
filter =3D vmx_posted_interrupts_test, test =3D
ept_access_test_paddr_read_only_ad_disabled
filter =3D vmx_posted_interrupts_test, test =3D
ept_access_test_paddr_read_only_ad_enabled
filter =3D vmx_posted_interrupts_test, test =3D ept_access_test_paddr_read_=
write
filter =3D vmx_posted_interrupts_test, test =3D
ept_access_test_paddr_read_write_execute
filter =3D vmx_posted_interrupts_test, test =3D
ept_access_test_paddr_read_execute_ad_disabled
filter =3D vmx_posted_interrupts_test, test =3D
ept_access_test_paddr_read_execute_ad_enabled
filter =3D vmx_posted_interrupts_test, test =3D
ept_access_test_paddr_not_present_page_fault
filter =3D vmx_posted_interrupts_test, test =3D ept_access_test_force_2m_pa=
ge
filter =3D vmx_posted_interrupts_test, test =3D atomic_switch_max_msrs_test
filter =3D vmx_posted_interrupts_test, test =3D atomic_switch_overflow_msrs=
_test
filter =3D vmx_posted_interrupts_test, test =3D rdtsc_vmexit_diff_test
filter =3D vmx_posted_interrupts_test, test =3D vmx_mtf_test
filter =3D vmx_posted_interrupts_test, test =3D vmx_mtf_pdpte_test
filter =3D vmx_posted_interrupts_test, test =3D vmx_pf_exception_test
filter =3D vmx_posted_interrupts_test, test =3D
vmx_pf_exception_forced_emulation_test
filter =3D vmx_posted_interrupts_test, test =3D vmx_pf_no_vpid_test
filter =3D vmx_posted_interrupts_test, test =3D vmx_pf_invvpid_test
filter =3D vmx_posted_interrupts_test, test =3D vmx_pf_vpid_test
filter =3D vmx_posted_interrupts_test, test =3D vmx_exception_test
SUMMARY: 674 tests, 1 unexpected failures
FAIL vmx_posted_intr_test (674 tests, 1 unexpected failures)

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=

