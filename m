Return-Path: <kvm+bounces-57124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B3E02B50552
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 20:32:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D559A1C6766D
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 18:33:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 708CC34F497;
	Tue,  9 Sep 2025 18:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="UUc02X7e"
X-Original-To: kvm@vger.kernel.org
Received: from terminus.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD53D3009F7;
	Tue,  9 Sep 2025 18:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757442667; cv=none; b=VValfAK9KhaHD7WK5MHidJC+55n9B5x7ywdT5e5vgNXAlFYne3/NfvMg42wU7CPzH71LKekn1DdRtk8XpYHCrnMmQOJreRCZj98azWISFJtZI7PArQEW6JShBmLPYkjTtL4SfPhV3+qxGxnAuYRpEHp9WuZ3M4c8CFMwMF/VVlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757442667; c=relaxed/simple;
	bh=pStNnpckjBLLxiCBdaRhSwHKmajHAFXvUVGozP1EwF0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nodW5cax7HbZYNSxDPBlTXXH8miS2UlntWmt8rsJAtSZfGI54FINBTUkCyc7KO38ANmVSo2eZIfRy4WQhaIsjV671YbpsT7ee8hB6yxKFcrghwl84rgYDWpSBayEtVw0uzO5RUq214IYxKYdP4YCstXLJCrGkWr8UVg6LZGIw9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=UUc02X7e; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 589ISSCx1542432
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 9 Sep 2025 11:28:32 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 589ISSCx1542432
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025082201; t=1757442513;
	bh=CH/NWgaZ5GpbCC8/+8SUZ4UxLR0GYrpdjFXxNoAb+HA=;
	h=From:To:Cc:Subject:Date:From;
	b=UUc02X7eS9hHXoR5t1iGlp6z92iu5VX+brkyldlBDbUMApAijCSL89t8qZNIpymqt
	 rDbqeIY0vUD6znn7goSyBl+ODBSZuLIXQPnWsnp4juKjYai6A0PILQ4mMTuc+Ks/sW
	 r03JtS4cPuYZCJFDg6Zh9dV/IfwWTsrobyhnnqSmKig8/uPiUQbtcvyJlVBXtGXwIP
	 GmenLjCbJeJQz2f66Ga9nH0mIxFWH9gh1bxpEKnsp8dh+J2qtVylz5ygWQAsrlqdVv
	 KKPCn/ulWGYmnMho3bxl5wsMe/Ebg266iJkTETezXULGIo12uzI1iI1dN8ZmI4t8rO
	 KFPlh5YNB2YtQ==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, rafael@kernel.org, pavel@kernel.org,
        brgerst@gmail.com, xin@zytor.com, david.kaplan@amd.com,
        peterz@infradead.org, andrew.cooper3@citrix.com,
        kprateek.nayak@amd.com, arjan@linux.intel.com, chao.gao@intel.com,
        rick.p.edgecombe@intel.com, dan.j.williams@intel.com
Subject: [RFC PATCH v1 0/5] x86/boot, KVM: Move VMXON/VMXOFF handling from KVM to CPU lifecycle
Date: Tue,  9 Sep 2025 11:28:20 -0700
Message-ID: <20250909182828.1542362-1-xin@zytor.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

There is now broad consensus that TDX should be decoupled from KVM. To
achieve this separation, it is necessary to move VMXON/VMXOFF handling
out of KVM. Sean has also discussed this approach in several TDX patch
series threads, e.g. [1], and has already done a round of refactoring
in KVM [2].

The simplest thing we could think of is to execute VMXON during the CPU
startup phase and VMXOFF during the CPU shutdown phase, even although
this leaves VMX on when it doesn't strictly need to be on.

This RFC series demonstrates the idea and seeks feedback from the KVM
community on its viability.


The benefits of doing VMXON/VMXOFF in the CPU startup/shutdown phase:

  1) Eliminates in-flight VMXON/VMXOFF during CPU hotplug, system reboot,
     or kexec while KVM is loading or unloading.

  2) Removes the “insane dances” for handling unexpected VMXON/VMXOFF
     execution, including the emergency reboot disable virtualization
     mechanism and kvm_rebooting.

  3) Allows KVM and other hypervisors on Linux to omit explicit VMX
     enable/disable logic.


This RFC series follows the direction and does the following:

  1) Move VMXON to the CPU startup phase instead of KVM initialization.

  2) Move VMXOFF to the CPU shutdown phase instead of KVM teardown.

  3) Move VMCLEAR of VMCSs to cpu_disable_virtualization().

  4) Remove the emergency reboot disable virtualization mechanism.

  5) Remove kvm_rebooting.


AMD SVM support is not included, as I do not have access to AMD hardware,
but adding it should be straightforward (currently broken in this RFC).

Note, the first two patches should ideally be merged into a single patch
to avoid breaking functionality in between. However, they are kept
separate in this RFC for clarity and easier review. I will merge them
if this approach proves viable.


[1] https://lore.kernel.org/lkml/ZhawUG0BduPVvVhN@google.com/
[2] https://lore.kernel.org/lkml/20240830043600.127750-1-seanjc@google.com/


Xin Li (Intel) (5):
  x86/boot: Shift VMXON from KVM init to CPU startup phase
  x86/boot: Move VMXOFF from KVM teardown to CPU shutdown phase
  x86/shutdown, KVM: VMX: Move VMCLEAR of VMCSs to
    cpu_disable_virtualization()
  x86/reboot: Remove emergency_reboot_disable_virtualization()
  KVM: Remove kvm_rebooting and its references

 arch/x86/include/asm/kvm_host.h  |   1 -
 arch/x86/include/asm/processor.h |   3 +
 arch/x86/include/asm/reboot.h    |  11 --
 arch/x86/include/asm/vmx.h       |   5 +
 arch/x86/kernel/cpu/common.c     | 162 +++++++++++++++++++++++++++
 arch/x86/kernel/crash.c          |   5 +-
 arch/x86/kernel/process.c        |   3 +
 arch/x86/kernel/reboot.c         |  88 ++-------------
 arch/x86/kernel/smp.c            |   3 +-
 arch/x86/kernel/smpboot.c        |   6 +
 arch/x86/kvm/svm/svm.c           |   8 --
 arch/x86/kvm/svm/vmenter.S       |  42 +++----
 arch/x86/kvm/vmx/main.c          |   1 -
 arch/x86/kvm/vmx/tdx.c           |   4 +-
 arch/x86/kvm/vmx/vmcs.h          |  10 +-
 arch/x86/kvm/vmx/vmenter.S       |   2 -
 arch/x86/kvm/vmx/vmx.c           | 185 ++-----------------------------
 arch/x86/kvm/x86.c               |  18 +--
 arch/x86/power/cpu.c             |  10 +-
 include/linux/kvm_host.h         |   9 --
 virt/kvm/kvm_main.c              |  29 +----
 21 files changed, 230 insertions(+), 375 deletions(-)


base-commit: 76eeb9b8de9880ca38696b2fb56ac45ac0a25c6c
-- 
2.51.0


